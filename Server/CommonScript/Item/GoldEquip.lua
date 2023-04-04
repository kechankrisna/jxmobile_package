Require("CommonScript/Item/Define.lua")

Item.GoldEquip 			= Item.GoldEquip or {};
local GoldEquip 		= Item.GoldEquip;
GoldEquip.COLOR_ACTVIED 	= "ActiveGreen"; --激活的熟悉颜色
GoldEquip.COLOR_UN_ACTVIED 	= "ASctiveGrey"; --未激活的属性颜色
-- GoldEquip.GOLD_QUALITY_COLOR = 7;
GoldEquip.DetailTypeColorQuality = { --黄金，白金的品质颜色
	[Item.DetailType_Gold] = 7;
	[Item.DetailType_Platinum] = 9;
}

--享有黄金以上装备特效的类型，强化、镶嵌跟等级走
GoldEquip.DetailTypeGoldUp = {
	[Item.DetailType_Gold] = "Hoàng Kim";
	[Item.DetailType_Platinum] = "Bạch Kim";
};

GoldEquip.MAX_ATTRI_NUM = 3
GoldEquip.MAX_TRAIN_ATTRI_LEVEL = 15 ;--养成属性的最大属性等级为15级
GoldEquip.UPGRADE_MAX_TIMEFRAME_C = 10;
function GoldEquip:Init()
	self.tbEvolutionSetting = LoadTabFile(
	"Setting/Item/GoldEquip/Evolution.tab",
	"dddddddddddds", "SrcItem",
	{"SrcItem", "TarItem", "CosumeItem1", "ConsumeCount1", "CosumeItem2", "ConsumeCount2", "CosumeItem3", "ConsumeCount3", "CosumeItemBAK1","ConsumeCountBAK1","CosumeItemBAK2","ConsumeCountBAK2", "TimeFrame"});

	local szCols = "ddddd"
	local tbCols = {"SrcItem", "TarItem", "CosumeItem", "Cosume2Item", "Consume2Count"};
	for i=1,self.UPGRADE_MAX_TIMEFRAME_C do 
		szCols = szCols .. "sd"
		table.insert(tbCols, "TimeFrame" .. i)
		table.insert(tbCols, "ConsumeCount" .. i) 	
	end
	self.tbEvolutionUpgradeSetting = LoadTabFile(
	"Setting/Item/GoldEquip/EvolutionUpgrade.tab", szCols, "SrcItem", tbCols);

	self.tbSuitIndex = LoadTabFile("Setting/Item/GoldEquip/SuitEquip.tab","ddd", "ItemId", {"SuitIndex", "Level", "ItemId" });
	local tbCols = {"SuitIndex"}
	local szCols = "d"
	for i=1, self.MAX_ATTRI_NUM do
		table.insert(tbCols, "ActiveNum" .. i)
		szCols = szCols .. "d";
	end
	self.tbSuitActiveSetting = LoadTabFile(
		"Setting/Item/GoldEquip/SuitActive.tab",
		szCols, "SuitIndex", tbCols);
	local tbFile = LoadTabFile(
		"Setting/Item/GoldEquip/SuitLevelAttrib.tab",
		"ddd", nil, {"SuitIndex","ActiveLevel","AttriGroup"});
	self.tbSuitLevelAttrib = {};
	for i,v in ipairs(tbFile) do
		self.tbSuitLevelAttrib[v.SuitIndex] = self.tbSuitLevelAttrib[v.SuitIndex] or {};
		self.tbSuitLevelAttrib[v.SuitIndex][v.ActiveLevel] = v.AttriGroup;
	end



	local tbCols = {"Item",	"AttribGroup", "CostItemId"};
	local szCols = "ddd";
	for i=1,self.MAX_TRAIN_ATTRI_LEVEL do
		table.insert(tbCols, "CostItemCount" .. i)
		table.insert(tbCols, "CostCoin" .. i)
		szCols = szCols .. "d";
	end
	self.tbTrainAttriSetting = LoadTabFile(
		"Setting/Item/GoldEquip/TrainAtriEquip.tab",
		szCols, "Item",
		 tbCols);

	self.tbGoldExternAttrib = LoadTabFile(
	"Setting/Item/GoldEquip/GoldExternAttrib.tab", 
	"dddddd", "nEquipLevel",
	{"nEquipLevel","nModifyLevel", "nAddLevel4", "nMaxLevel4", "nAddLevel5", "nMaxLevel5"});

	self.tbGoldEquipTypeAddLevel = {};
	local tbItemType = {Item.EQUIP_WEAPON;
					Item.EQUIP_HELM;
					Item.EQUIP_NECKLACE;
					Item.EQUIP_CUFF;
					Item.EQUIP_RING;
					Item.EQUIP_ARMOR;
					Item.EQUIP_PENDANT;
					Item.EQUIP_BELT;
					Item.EQUIP_AMULET;
					Item.EQUIP_BOOTS;
				}
	for i,v in ipairs(tbItemType) do
		self.tbGoldEquipTypeAddLevel[v] = i -1;
	end

	self.tbExternSetting = LoadTabFile(
	"Setting/Item/GoldEquip/GoldExternSetting.tab", 
	"dddd", nil,
	{"nPlayerLevel", "nEquipLevel",	"nHoleCount", "nInsetLevel"});
end



GoldEquip:Init()



function GoldEquip:GetCosumeItemToTarItem(SrcItem)
	local tbInfo = self.tbEvolutionSetting[SrcItem]
	if tbInfo then
		return tbInfo.TarItem
	end
end

function GoldEquip:GetCosumeItemAutoSelectConsumItem1(CosumeItem1)
	if not self.tbItemAutoSelectConsumItem1 then
		self.tbItemAutoSelectConsumItem1 = {};
		for k, v in pairs(self.tbEvolutionSetting) do
			self.tbItemAutoSelectConsumItem1[v.CosumeItem1] = v.TarItem;
		end
	end
	return self.tbItemAutoSelectConsumItem1[CosumeItem1]
end

function GoldEquip:GetExternSetting( nPlayerLevel, nItemType )
	local tbSetting;
	local nAddLevel = self.tbGoldEquipTypeAddLevel[nItemType] 
	if not nAddLevel then
		return
	end
	nPlayerLevel = nPlayerLevel - nAddLevel
	local nNeedLevel;
	for i,v in ipairs(self.tbExternSetting) do
		if v.nPlayerLevel <= nPlayerLevel then
			tbSetting = v;
			nNeedLevel = v.nPlayerLevel + nAddLevel
		else
			break;
		end
	end
	return tbSetting, nNeedLevel
end

function GoldEquip:GetExternSettingNeedPlayerLevel( nEquipLevel, nItemType )
	local nAddLevel = self.tbGoldEquipTypeAddLevel[nItemType] 
	if not nAddLevel then
		return
	end
	for i,v in ipairs(self.tbExternSetting) do
		if v.nEquipLevel == nEquipLevel then
			return v.nPlayerLevel + nAddLevel
		end
	end
end


--获取所有初始的黄金装备6阶装备
function GoldEquip:GetAllInitEvolutionTarItems()
	if not self.tbAllInitEvolutionTarItems then
		self.tbAllInitEvolutionTarItems = {};
		for SrcItem, v in pairs(self.tbEvolutionSetting) do
			if v.CosumeItem1 == 2804 and v.CosumeItem2 == 0 then
				self.tbAllInitEvolutionTarItems[v.TarItem] = SrcItem;
			end
		end
	end
	return self.tbAllInitEvolutionTarItems
end


function GoldEquip:GetRealUseAttribLevel(nDetailType, nEquipLevel, nCurAttribLevel)
	if not nDetailType then
		return nCurAttribLevel
	end
	local tbSet = self.tbGoldExternAttrib[nEquipLevel]
	if not tbSet then
		return nCurAttribLevel
	end
	local nAddLevel = tbSet["nAddLevel" .. nDetailType]
	if not nAddLevel then
		return nCurAttribLevel
	end
	if nCurAttribLevel < tbSet.nModifyLevel then
		return nCurAttribLevel
	end
	return math.max(nCurAttribLevel, math.min(nCurAttribLevel + nAddLevel, tbSet["nMaxLevel" .. nDetailType]))
end

function GoldEquip:Evolution(pPlayer, nItemId)
	local pItemSrc = pPlayer.GetItemInBag(nItemId)
	if not pItemSrc then
		return false
	end

	local bEquiped = false;
	if not self:CanEvolution(pPlayer, nItemId) then
		return false
	end
	local tbItemInVals;
	if pItemSrc.IsEquip() then
		local pCurEquip = pPlayer.GetEquipByPos(pItemSrc.nEquipPos)
		if pCurEquip and pCurEquip.dwId == pItemSrc.dwId then
			bEquiped = true
		end
		tbItemInVals = Item.tbRefinement:GetSaveRandomAttrib(pItemSrc)
	end
	local nTemplateIdSrc = pItemSrc.dwTemplateId
	local tbSetting = self.tbEvolutionSetting[nTemplateIdSrc]

	local tbConsumeSetting = self:GetEvolutionConsumeSetting(pPlayer, pItemSrc)
	local tbHideID = { [nItemId] = 1 };
	for i,v in ipairs(tbConsumeSetting) do
		local nCosumeItem, nConsumeCount = unpack(v)
		if pPlayer.ConsumeItemInBag(nCosumeItem, nConsumeCount, Env.LogWay_GoldEquipEvo, tbHideID) ~= nConsumeCount then
			Log(pPlayer.dwID, debug.traceback())
			return
		end
	end

	if  pPlayer.ConsumeItem(pItemSrc, 1, Env.LogWay_GoldEquipEvo) ~= 1 then
		Log(debug.traceback(), pPlayer.dwID)
		return
	end

	local pItemTar = pPlayer.AddItem(tbSetting.TarItem, 1, nil, Env.LogWay_GoldEquipEvo);
	if not pItemTar then
		Log(debug.traceback(), pPlayer.dwID)
		return
	end


	local tbTrainSetting = self.tbTrainAttriSetting[tbSetting.TarItem]
	if tbTrainSetting then
		pItemTar.SetIntValue(Item.EQUIP_VALUE_TRAIN_ATTRI_LEVEL, 1)
	end
	if tbItemInVals then
		for k,v in pairs(tbItemInVals) do
			pItemTar.SetIntValue(k, v);
		end
		pItemTar.ReInit();
	end

	pPlayer.TLog("EquipFlow", pItemTar.nItemType, pItemTar.dwTemplateId, pItemTar.dwId, 1, Env.LogWay_GoldEquipEvo, 0, 2, pItemTar.GetIntValue(1),pItemTar.GetIntValue(2), pItemTar.GetIntValue(3), pItemTar.GetIntValue(4), pItemTar.GetIntValue(5),pItemTar.GetIntValue(6), 0, "");

	if bEquiped then
		Item:UseEquip(pItemTar.dwId, false, pItemTar.nEquipPos)
	end

	if  Item:IsMainEquipPos(pItemTar.nEquipPos) then
		local szKinPrefix = "";
		if pPlayer.dwKinId ~= 0 then
			local tbKin = Kin:GetKinById(pPlayer.dwKinId)
			if tbKin then
				szKinPrefix = string.format("Bang %s-", tbKin.szName)
			end
		end
		local szEquipName = KItem.GetItemShowInfo(tbSetting.TarItem, pPlayer.nFaction, pPlayer.nSex);
		
		if (pPlayer.nFaction >= 18) then
			szEquipName = Item:GetNewItemShowInfo(tbSetting.TarItem, pPlayer.nFaction, pPlayer.nSex);
		end
		
		
		local szNameType = self.DetailTypeGoldUp[pItemTar.nDetailType]
		local szWorldMsg = string.format("Chúc mừng %s「%s」đã chế tạo thành công trang bị bậc %d %s <%s>. ", szKinPrefix, pPlayer.szName, pItemTar.nLevel, szNameType, szEquipName);
		local szKinMsg = string.format("Chúc mừng「%s」đã chế tạo thành công trang bị bậc %d %s <%s>. ", pPlayer.szName, pItemTar.nLevel, szNameType, szEquipName)
		KPlayer.SendWorldNotify(1, 999, szWorldMsg, 0, 1)
		local tbRandomAtrrib = Item.tbRefinement:GetSaveRandomAttrib(pItemTar) ;
		local tbData = {
			nCount = 1,
			nLinkType = ChatMgr.LinkType.Item, 
			nFaction = pPlayer.nFaction,
			nSex = pPlayer.nSex,
			nTemplateId = tbSetting.TarItem, 
			szName = szEquipName,
			bIsEquip = true,
			tbRandomAtrrib = tbRandomAtrrib,
		}
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.System, szWorldMsg, 0, tbData)
		if pPlayer.dwKinId ~= 0 then
			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szKinMsg, pPlayer.dwKinId, tbData)
		end

		Achievement:AddCount(pPlayer, "Equip_3", 1)
	end

	pPlayer.CallClientScript("Item.GoldEquip:OnEvolutionSuccess")
end

function GoldEquip:CanEvolutionTarItem(dwTemplateId)
	local tbSetting = self.tbEvolutionSetting[dwTemplateId]
	if tbSetting then
		if not Lib:IsEmptyStr(tbSetting.TimeFrame) and GetTimeFrameState(tbSetting.TimeFrame) ~= 1 then
			return
		end
		return tbSetting.TarItem
	end
end

function GoldEquip:CanEvolution(pPlayer, dwItemId)
	local pEquip = pPlayer.GetItemInBag(dwItemId)
	if not pEquip then
		return false, "Không có trang bị tương ứng"
	end
	local dwTemplateId = pEquip.dwTemplateId
	local tbSetting = self.tbEvolutionSetting[dwTemplateId]
	if not tbSetting then
		return false, "Không có thiết lập chế tạo"
	end
	if not Lib:IsEmptyStr(tbSetting.TimeFrame) and GetTimeFrameState(tbSetting.TimeFrame) ~= 1 then
		return false, "Hiện chưa mở"
	end
	local tbItemBase = KItem.GetItemBaseProp(tbSetting.TarItem)
	if not tbItemBase then
		return false, "Lỗi thiết lập"
	end

	if tbItemBase.nRequireLevel > pPlayer.nLevel then
		return false, string.format("Chưa đạt Lv%d, không thể tăng bậc trang bị này, tăng cấp rồi thử lại", tbItemBase.nRequireLevel) 
	end

	local tbConsumeSetting = self:GetEvolutionConsumeSetting(pPlayer, pEquip)
	if not next(tbConsumeSetting) then
		return false, "Thiết lập tiêu hao lỗi"
	end
	
	local tbHideID = { [pEquip.dwId] = 1 };

	for i,v in ipairs(tbConsumeSetting) do
		local nCosumeItem, nConsumeCount = unpack(v)
		local nHasCount = pPlayer.GetItemCountInBags(nCosumeItem, tbHideID)
		if nHasCount < nConsumeCount then
			return false, "Nguyên liệu không đủ"
		end
	end

	return true;
end

function GoldEquip:GetSuitAttrib(dwTemplateId, pPlayer)
	local tbSetting = self.tbSuitIndex[dwTemplateId]
	if not tbSetting then
		return
	end
	local tbActiedSuitIndex = pPlayer and pPlayer.tbActiedSuitIndex or {};
	local tbSuitIndexEquipNum = pPlayer and pPlayer.tbSuitIndexEquipNum or {};
	--todo 目前是每激活一档只是一个属性,不然现有结构无法用
	local tbAttris = {}
	local nSuitLevel, nSuitIndex = tbSetting.Level, tbSetting.SuitIndex
	local tbSuitInfo = {0,0}
	local nEquipTypeNum = tbSuitIndexEquipNum[nSuitIndex] and tbSuitIndexEquipNum[nSuitIndex][nSuitLevel]
	if nEquipTypeNum then
		tbSuitInfo[2] = nEquipTypeNum
	end
	local tbSuitActiveSetting = self.tbSuitActiveSetting[nSuitIndex]
	for ActiveLevel= 1, self.MAX_ATTRI_NUM do
		local nActiveNeedNum = tbSuitActiveSetting["ActiveNum" .. ActiveLevel]
		if nActiveNeedNum ~= 0 then
			tbSuitInfo[1] = nActiveNeedNum
			local tbExtAttrib = KItem.GetExternAttrib(self.tbSuitLevelAttrib[nSuitIndex][ActiveLevel], nSuitLevel);
			for nIndex, v in ipairs(tbExtAttrib) do
				local szDesc  = FightSkill:GetMagicDesc(v.szAttribName, v.tbValue) or "";
				local  nColor = self.COLOR_UN_ACTVIED;
				if tbActiedSuitIndex[nSuitIndex] and tbActiedSuitIndex[nSuitIndex][nSuitLevel] and tbActiedSuitIndex[nSuitIndex][nSuitLevel][ActiveLevel] then
					nColor = self.COLOR_ACTVIED
				end
				table.insert(tbAttris, {string.format("%s  %s", string.format("(%d món)", nActiveNeedNum), szDesc) , nColor})
			end
		else
			break;
		end
	end
	return tbAttris, tbSuitInfo
end

function GoldEquip:GetTrainAttrib(dwTemplateId, nLevel)
	local tbSetting = self.tbTrainAttriSetting[dwTemplateId]
	if not tbSetting then
		return
	end
	if not nLevel or  nLevel == 0  then
		nLevel = 1
	end
	if nLevel > self.MAX_TRAIN_ATTRI_LEVEL then
		return
	end
	local tbExtAttrib = KItem.GetExternAttrib(tbSetting.AttribGroup, nLevel);
	if not tbExtAttrib then
		return
	end

	local tbAttris = {}
	for nIndex, v in ipairs(tbExtAttrib) do
		local szDesc  = FightSkill:GetMagicDesc(v.szAttribName, v.tbValue) or "";
		table.insert(tbAttris, {szDesc , 0}) --无用功能
	end
	return tbAttris
end

function GoldEquip:GetActiedSuitIndexFromEquips( tbEquips )
	local tbSuitIndexs = {}
	for _, nItemId in pairs(tbEquips) do
		local pEquip = KItem.GetItemObj(nItemId)
		if pEquip then
			local tbSuitInfo = self.tbSuitIndex[pEquip.dwTemplateId]
			if tbSuitInfo then
				local SuitIndex, nSuitLevel = tbSuitInfo.SuitIndex, tbSuitInfo.Level
				tbSuitIndexs[SuitIndex] = tbSuitIndexs[SuitIndex] or {};
				for nLevel=1,nSuitLevel do
					tbSuitIndexs[SuitIndex][nLevel] = (tbSuitIndexs[SuitIndex][nLevel] or 0)  + 1; 
				end
			end
		end
	end
	
	local tbUseExtRet = {};
	for SuitIndex, v1 in pairs(tbSuitIndexs) do
		for nLevel, nEquipNum in ipairs(v1) do
			local tbSetting = self.tbSuitActiveSetting[SuitIndex]
			for i = 1, self.MAX_ATTRI_NUM do
				local nActiveNeedNum = tbSetting["ActiveNum" .. i]
				if nActiveNeedNum ~= 0 and nEquipNum >= nActiveNeedNum then
					tbUseExtRet[SuitIndex] = tbUseExtRet[SuitIndex] or {};
			    	tbUseExtRet[SuitIndex][nLevel] = tbUseExtRet[SuitIndex][nLevel] or {}
			    	tbUseExtRet[SuitIndex][nLevel][i] = nEquipNum;
			    	if tbUseExtRet[SuitIndex][nLevel - 1] then
			    		tbUseExtRet[SuitIndex][nLevel - 1][i] = nil; 
			    	end
				else
					break;
				end
			end
		end
	end
	return tbUseExtRet, tbSuitIndexs
end

-- 登陆 脱穿装备时 更新
function GoldEquip:UpdateSuitAttri(pPlayer)
	if pPlayer.tbActiedSuitIndex then --玩家 身上已经激活的套装属性
		for SuitIndex,v1 in pairs(pPlayer.tbActiedSuitIndex) do
			for nLevel,v2 in pairs(v1) do
				for ActiveLevel, _ in pairs(v2) do
					pPlayer.RemoveExternAttrib(self.tbSuitLevelAttrib[SuitIndex][ActiveLevel])
				end
			end
		end
	end

	
	local tbSaveAsyncVals = {}
	local tbEquips = pPlayer.GetEquips()
	local tbActiedSuitIndex, tbSuitIndexEquipNum = self:GetActiedSuitIndexFromEquips(tbEquips)
	pPlayer.tbActiedSuitIndex = tbActiedSuitIndex
	pPlayer.tbSuitIndexEquipNum = tbSuitIndexEquipNum
	-- [SuitIndex][nLevel][ActiveLevel]
	for SuitIndex,v1 in pairs(tbActiedSuitIndex) do
		for nLevel,v2 in pairs(v1) do
			for ActiveLevel, nIsApply in pairs(v2) do
				if nIsApply ~= 0 then
					local AttriGroup = self.tbSuitLevelAttrib[SuitIndex][ActiveLevel];
					pPlayer.ApplyExternAttrib(AttriGroup, nLevel)
					table.insert(tbSaveAsyncVals, AttriGroup * 100 + nLevel) --一个激活属性一条了	
				end
			end
		end
	end

	if MODULE_GAMESERVER then
		local pAsyncData = KPlayer.GetAsyncData(pPlayer.dwID)
		if pAsyncData then
			if #tbSaveAsyncVals > 10 then
				Log(debug.traceback())
			end
			for i = 1,10 do
				local nVal = tbSaveAsyncVals[i] or 0
				pAsyncData.SetSuit(i, nVal)
				if nVal == 0 then
					break;
				end
			end
		end
	end
end

--异步数据加载时用到
function GoldEquip:UpdateTrainAttriToNpc(pNpc, tbEquipTemplates, tbEquipTranLevels)
	for nPos, nAttriLevel in pairs(tbEquipTranLevels) do
		local dwTemplateId = tbEquipTemplates[nPos]
		local tbSetting = self.tbTrainAttriSetting[dwTemplateId]
		if tbSetting then
			pNpc.ApplyExternAttrib(tbSetting.AttribGroup, nAttriLevel)
		end
	end
end

--这个 登陆，脱穿时 最好是跟着C里脱穿装备走
function GoldEquip:UpdateTrainAttri(pPlayer, nEquipPos)
	local tbApplyedTrainAttri = pPlayer.tbApplyedTrainAttri or {};

	local nActiveGroup = tbApplyedTrainAttri[nEquipPos]
	if nActiveGroup then
		pPlayer.RemoveExternAttrib(nActiveGroup)
		tbApplyedTrainAttri[nEquipPos] = nil;
	end

	local pEquip = pPlayer.GetEquipByPos(nEquipPos)
	if pEquip then
		local tbSetting = self.tbTrainAttriSetting[pEquip.dwTemplateId]
		if tbSetting then
			local nLevel = pEquip.GetBaseIntValue(Item.EQUIP_VALUE_TRAIN_ATTRI_LEVEL)
			if nLevel > 0 then
				pPlayer.ApplyExternAttrib(tbSetting.AttribGroup, nLevel)
				tbApplyedTrainAttri[nEquipPos] = tbSetting.AttribGroup
			end
		end
	end

	pPlayer.tbApplyedTrainAttri = tbApplyedTrainAttri;
end

function GoldEquip:OnLogin(pPlayer)
	self:UpdateSuitAttri(pPlayer)
	for nEquipPos = Item.EQUIPPOS_HEAD, Item.EQUIPPOS_PENDANT do
		self:UpdateTrainAttri(pPlayer, nEquipPos)
	end
end

function GoldEquip:UpgradeEquipTrainLevel(pPlayer, nItemId)
	local pEquip = pPlayer.GetItemInBag(nItemId)
	if not pEquip then
		return
	end
	local nNowLevel = pEquip.GetBaseIntValue(Item.EQUIP_VALUE_TRAIN_ATTRI_LEVEL)
	if nNowLevel == 0 then
		return
	end
	local tbSetting = self.tbTrainAttriSetting[pEquip.dwTemplateId]
	if not tbSetting then
		return
	end

	local nNextLevel = nNowLevel + 1
	if nNextLevel > self.MAX_TRAIN_ATTRI_LEVEL then
		return
	end

	local nCousumeCount, nConsumeCoin = tbSetting["CostItemCount" .. nNextLevel], tbSetting["CostCoin" .. nNextLevel]
	if not  nCousumeCount or not nConsumeCoin then
		Log(debug.traceback(), pEquip.dwTemplateId, nNextLevel)
		return
	end

	if not pPlayer.CostMoney("Coin", nConsumeCoin, Env.LogWay_TrainEquipAttri) then
		return
	end

	if pPlayer.ConsumeItemInAllPos(tbSetting.CostItemId, nCousumeCount, Env.LogWay_TrainEquipAttri) ~= nCousumeCount then
		Log(debug.traceback(), pEquip.dwTemplateId, nNextLevel)
		return
	end

	pEquip.SetBaseIntValue(Item.EQUIP_VALUE_TRAIN_ATTRI_LEVEL, nNextLevel)
	Log("GoldEquip:UpgradeEquipTrainLevel", pPlayer.dwID, pEquip.dwTemplateId, nNextLevel, nItemId)
	self:UpdateTrainAttri(pPlayer, pEquip.nEquipPos)

	pPlayer.CallClientScript("Item.GoldEquip:OnUpgradeEquipTrainLevelSuc", pEquip.nEquipPos)
end

function GoldEquip:CanEquipTrainAttris(pPlayer, nItemId)
	local pEquip = pPlayer.GetItemInBag(nItemId)
	if not pEquip then
		return
	end
	local nNowLevel = pEquip.GetBaseIntValue(Item.EQUIP_VALUE_TRAIN_ATTRI_LEVEL)
	if nNowLevel == 0 then
		return false, "Chưa chế tạo qua"
	end
	local tbSetting = self.tbTrainAttriSetting[pEquip.dwTemplateId]
	if not tbSetting then
		return
	end

	local nNextLevel = nNowLevel + 1
	local tbExtAttrib = KItem.GetExternAttrib(tbSetting.AttribGroup, nNextLevel);
	if not tbExtAttrib then
		return
	end
	if pPlayer.GetItemCountInAllPos(tbSetting.CostItemId) <  tbSetting["CostItemCount" .. nNextLevel] then
		return false, "Nguyên liệu không đủ"
	end
	if pPlayer.GetMoney("Coin") < tbSetting["CostCoin" .. nNextLevel] then
		return false, "Bạc không đủ"
	end

	return true;
end

--C
function GoldEquip:OnEvolutionSuccess()
	UiNotify.OnNotify(UiNotify.emNOTIFY_EQUIP_EVOLUTION, true)
end

--C
function GoldEquip:OnUpgradeEquipTrainLevelSuc(nEquipPos)
	self:UpdateTrainAttri(me, nEquipPos)
	me.CenterMsg("Tinh luyện thành công!")
	UiNotify.OnNotify(UiNotify.emNOTIFY_EQUIP_TRAIN_ATTRIB, true)
end

function GoldEquip:GetEvolutionSetting(dwTemplateId)
	return self.tbEvolutionSetting[dwTemplateId]
end

function GoldEquip:GetTrainAttriSetting( dwTemplateId )
	return self.tbTrainAttriSetting[dwTemplateId]
end


--进阶
function GoldEquip:CanUpgradeTarItem(dwTemplateId)
	local tbSetting = self.tbEvolutionUpgradeSetting[dwTemplateId]
	if tbSetting then
		return tbSetting.TarItem
	end
end

function GoldEquip:GetUpgradeSetting(dwTemplateId)
	return self.tbEvolutionUpgradeSetting[dwTemplateId]
end

function GoldEquip:GetUpgradeConsumCount(tbSetting)
	local ConsumeCount;
	local ConsumeCountOrg = tbSetting["ConsumeCount1"]
	for i=1,self.UPGRADE_MAX_TIMEFRAME_C do
		local szTimeFrame = tbSetting["TimeFrame" .. i]
		if not Lib:IsEmptyStr(szTimeFrame) and GetTimeFrameState(szTimeFrame) == 1 then
			ConsumeCount = tbSetting["ConsumeCount" .. i]
		else
			break;
		end
	end
	if ConsumeCountOrg == ConsumeCount then
		ConsumeCountOrg = nil
	end
	return ConsumeCount,ConsumeCountOrg
end

function GoldEquip:CanUpgrade(pPlayer, dwTemplateId)
	local tbSetting = self.tbEvolutionUpgradeSetting[dwTemplateId]
	if not tbSetting then
		return false, "Không có thiết lập tăng bậc"
	end

	local nEquipPos = KItem.GetEquipPos(dwTemplateId)
	local pCurEquip = pPlayer.GetEquipByPos(nEquipPos)
	if not pCurEquip then
		return false, "Chưa trang bị đạo cụ này"
	end

	local tbConsumeSetting = self:GetUpgradeConsumeSetting(dwTemplateId)
	if not next(tbConsumeSetting)  then
		return false, "Hiện chưa mở"
	end
	for i,v in ipairs(tbConsumeSetting) do
		if pPlayer.GetItemCountInAllPos(v[1]) < v[2] then
			return false, "Nguyên liệu không đủ"
		end
	end
	
	local tbItemBase = KItem.GetItemBaseProp(tbSetting.TarItem)
	if not tbItemBase then
		return false, "Lỗi thiết lập"
	end

	if tbItemBase.nRequireLevel > pPlayer.nLevel then
		return false, string.format("Chưa đạt Lv%d, không thể tăng bậc trang bị này, tăng cấp rồi thử lại", tbItemBase.nRequireLevel) 
	end

	return true, nil, tbConsumeSetting;
end



function GoldEquip:CheckDoUpgradeParam(pPlayer, tbRefinemRecord)
	local pSrcItem = pPlayer.GetItemInBag(tbRefinemRecord.SrcItemId) --消耗T7稀有
	if not pSrcItem then
		return false, "1"
	end
	local pCostItem = pPlayer.GetItemInBag(tbRefinemRecord.CostItemId)--消耗掉的T6黄金
	if not pCostItem then
		return false, "2"
	end

	local tbSetting = self.tbEvolutionUpgradeSetting[pCostItem.dwTemplateId]
	if not tbSetting then
		return false, "3"
	end

	if tbSetting.CosumeItem1 ~= pSrcItem.dwTemplateId then
		return false, "4"
	end

	local tbRefineIndex = tbRefinemRecord.tbRefineIndex
	if tbRefinemRecord.nCoin == 0  then
		if next(tbRefineIndex) then
			return false, "5"
		end
	else

		if not next(tbRefineIndex) then
			return false, "6"
		end
		local nCostTotal = 0
		local tbOldAllVals = {}
		for i=1,6 do
			table.insert(tbOldAllVals, pSrcItem.GetIntValue(i))
		end
		--检查是否所有的 nSrcVal 都在pSrcItem 里出现
		for nTarPos, nSrcVal in pairs(tbRefineIndex) do
			local bFound = false
			for k,v in pairs(tbOldAllVals) do
				if nSrcVal == v then
					bFound = true
					tbOldAllVals[k] = nil;
					break;
				end
			end
			if not bFound then
				return false, "6" .. nTarPos
			end
		end

		for nTarPos, nSrcVal in pairs(tbRefineIndex) do
			if nTarPos < 1 or nTarPos > 6 then
				return false, "7"
			end
			if nSrcVal == 0 then
				return false, "9"
			end
			local nCurCost = Item.tbRefinement:GetRefineCost(nSrcVal, pSrcItem.nItemType)
			if nCurCost == 0 then
				return false, "10"
			end
			nCostTotal = nCostTotal + nCurCost

		end

		if nCostTotal ~= tbRefinemRecord.nCoin then
			return false, "11"
		end


		if pPlayer.GetMoney("Coin") < nCostTotal then
			return false, "Bạc không đủ"
		end
	end
	return true
end

function GoldEquip:ClientPorcessUpgrade(tbRefinemRecord)
	local nFakeSrcId = tbRefinemRecord.nFakeSrcId
	local nFakeTarId = tbRefinemRecord.nFakeTarId
	tbRefinemRecord.nFakeSrcId = nil;
	tbRefinemRecord.nFakeTarId = nil;

	local bRet, szMsg = self:CheckDoUpgradeParam(me, tbRefinemRecord)
	if bRet then
		RemoteServer.RequestEquipUpgrade(tbRefinemRecord)
	else
		me.CenterMsg( szMsg or "Tham số tiến cấp trang bị bị lỗi", true)
	end

	Item:RemoveFakeItem(nFakeSrcId)
	Item:RemoveFakeItem(nFakeTarId)
end


function GoldEquip:ServerDoEquipUpgrade(pPlayer, nSrcItemId)
	local pSrcItem = pPlayer.GetItemInBag(nSrcItemId)
	if not pSrcItem then
		return
	end

	local tbSetting = self.tbEvolutionUpgradeSetting[pSrcItem.dwTemplateId]
	if not tbSetting then
		return
	end

	local bRet, szMsg, tbConsumeSetting = self:CanUpgrade(pPlayer, pSrcItem.dwTemplateId)
	if not bRet then
		return
	end
	for i,v in ipairs(tbConsumeSetting) do
		if pPlayer.ConsumeItemInAllPos(v[1], v[2], Env.LogWay_GoldEquipUpgrade) ~= v[2] then	
			Log(pPlayer.dwID, debug.traceback())
			return
		end
	end

	local tbItemInVals = Item.tbRefinement:GetSaveRandomAttrib(pSrcItem)

	if not pSrcItem.Delete(Env.LogWay_GoldEquipUpgrade) then
		Log(pPlayer.dwID, debug.traceback())
		return
	end

	local pItemTar = pPlayer.AddItem(tbSetting.TarItem, 1, nil, Env.LogWay_GoldEquipUpgrade)
	if not pItemTar then
		Log(pPlayer.dwID, debug.traceback())
		return
	end

	for k,v in pairs(tbItemInVals) do
		pItemTar.SetIntValue(k, v);
	end

	pItemTar.ReInit();

	pPlayer.TLog("EquipFlow", pItemTar.nItemType, pItemTar.dwTemplateId, pItemTar.dwId, 1, Env.LogWay_GoldEquipUpgrade, 0, 2, pItemTar.GetIntValue(1),pItemTar.GetIntValue(2), pItemTar.GetIntValue(3), pItemTar.GetIntValue(4), pItemTar.GetIntValue(5),pItemTar.GetIntValue(6),0, "");

	local pNowEquip = pPlayer.GetEquipByPos(pItemTar.nEquipPos)
	if not pNowEquip then
		Item:UseEquip(pItemTar.dwId, false, pItemTar.nEquipPos)
	end

	local szKinPrefix = "";
	if pPlayer.dwKinId ~= 0 then
		local tbKin = Kin:GetKinById(pPlayer.dwKinId)
		if tbKin then
			szKinPrefix = string.format("Bang %s-", tbKin.szName)
		end
	end
	local szEquipName = KItem.GetItemShowInfo(tbSetting.TarItem, pPlayer.nFaction, pPlayer.nSex);
	
	if (pPlayer.nFaction >= 18) then
		szEquipName = Item:GetNewItemShowInfo(tbSetting.TarItem, pPlayer.nFaction, pPlayer.nSex);
	end
	
	local szNameType = self.DetailTypeGoldUp[pItemTar.nDetailType]
	local szWorldMsg = string.format("Chúc mừng  %s「%s」thông qua tăng bậc trang bị %s nhận trang bị bậc %d %s <%s>. ", szKinPrefix, pPlayer.szName,  szNameType,  pItemTar.nLevel, szNameType, szEquipName);
	local szKinMsg = string.format("Chúc mừng「%s」tăng bậc trang bị %s nhận trang bị bậc %d %s <%s>. ", pPlayer.szName, szNameType, pItemTar.nLevel, szNameType, szEquipName)
	KPlayer.SendWorldNotify(1, 999, szWorldMsg, 0, 1)
	local tbData = {
		nCount = 1,
		nLinkType = ChatMgr.LinkType.Item, 
		nFaction = pPlayer.nFaction,
		nSex = pPlayer.nSex,
		nTemplateId = tbSetting.TarItem, 
		szName = szEquipName,
		bIsEquip = true,
		tbRandomAtrrib = tbItemInVals,
	}
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.System, szWorldMsg, 0, tbData)
	if pPlayer.dwKinId ~= 0 then
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szKinMsg, pPlayer.dwKinId, tbData)
	end

	pPlayer.CallClientScript("Item.GoldEquip:OnEvolutionSuccess")
	Achievement:AddCount(pPlayer, "Equip_3", 1)
end

function GoldEquip:IsShowHorseUpgradeRed(pPlayer)
	for nEquipPos,v in pairs(Item.tbHorseItemPos) do
		local pEquip2 = pPlayer.GetEquipByPos(nEquipPos);
		if pEquip2 and Item.GoldEquip:CanEvolution(pPlayer, pEquip2.dwId) then
			return true
		end
	end
	return false
end

function GoldEquip:IsHaveHorseUpgradeItem(pPlayer)
	for nEquipPos,v in pairs(Item.tbHorseItemPos) do
		local pEquip2 = pPlayer.GetEquipByPos(nEquipPos);
		if pEquip2 and self:CanEvolutionTarItem(pEquip2.dwTemplateId) then
			return true
		end
	end
	return false
end

--如果没有第二套的话则显示第一套，有第二套齐全的话优先显示第二套
function GoldEquip:GetEvolutionConsumeSetting(pPlayer, pSrcItem, nSrcTemplateId)
	if not nSrcTemplateId and pSrcItem then
		nSrcTemplateId = pSrcItem.dwTemplateId
	end
	if not nSrcTemplateId then
		return
	end
	local tbSetting = self.tbEvolutionSetting[nSrcTemplateId]
	local tbConsumeSetting = {}; 
	if not tbSetting then
		return tbConsumeSetting
	end
	local tbHideID = {  };
	if pSrcItem then
		tbHideID[pSrcItem.dwId] = 1
	end
	
	if tbSetting.CosumeItemBAK1 ~= 0  and tbSetting.ConsumeCountBAK1 ~= 0 then
		local nCount = pPlayer.GetItemCountInBags(tbSetting.CosumeItemBAK1, tbHideID)
		if nCount >= tbSetting.ConsumeCountBAK1 then
			table.insert(tbConsumeSetting, {tbSetting.CosumeItemBAK1, tbSetting.ConsumeCountBAK1})
			if tbSetting.CosumeItemBAK2 ~= 0  and tbSetting.ConsumeCountBAK2 ~= 0 then
				table.insert(tbConsumeSetting, {tbSetting.CosumeItemBAK2, tbSetting.ConsumeCountBAK2})
			end
		end

		if next(tbConsumeSetting) then
			return tbConsumeSetting
		end
	end

	if tbSetting.CosumeItem1 ~= 0  and tbSetting.ConsumeCount1 ~= 0 then
		table.insert(tbConsumeSetting, {tbSetting.CosumeItem1, tbSetting.ConsumeCount1})
	end

	if tbSetting.CosumeItem2 ~= 0  and tbSetting.ConsumeCount2 ~= 0 then
		table.insert(tbConsumeSetting, {tbSetting.CosumeItem2, tbSetting.ConsumeCount2})
	end
	if tbSetting.CosumeItem3 ~= 0  and tbSetting.ConsumeCount3 ~= 0 then
		table.insert(tbConsumeSetting, {tbSetting.CosumeItem3, tbSetting.ConsumeCount3})
	end
	return  tbConsumeSetting
end

function GoldEquip:GetUpgradeConsumeSetting(dwTemplateId)
	local tbSetting = self.tbEvolutionUpgradeSetting[dwTemplateId]
	local tbConsumeSetting = {}; 
	if not tbSetting then
		return tbConsumeSetting
	end
	local nCousumeCount, nCousumeCountOrg = self:GetUpgradeConsumCount(tbSetting)
	if not nCousumeCount then
		return tbConsumeSetting
	end
	table.insert(tbConsumeSetting, {tbSetting.CosumeItem, nCousumeCount, nCousumeCountOrg})
	if tbSetting.Cosume2Item ~= 0 and tbSetting.Consume2Count ~= 0 then
		table.insert(tbConsumeSetting, {tbSetting.Cosume2Item, tbSetting.Consume2Count})
	end 
	return  tbConsumeSetting
end