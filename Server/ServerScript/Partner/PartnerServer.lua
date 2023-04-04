
Require("CommonScript/Partner/PartnerCommon.lua");
local tbSeveranceDiscountItem = Item:GetClass("SeveranceDiscount");
function Partner:SetPartnerPos(pPlayer, tbPosInfo)
	if not tbPosInfo then
		return;
	end
	for nIdx in pairs(tbPosInfo) do
		if self.tbPosNeedLevel[nIdx] > pPlayer.nLevel then
			tbPosInfo[nIdx] = 0;
		end
	end

	pPlayer.SetPartnerPos(tbPosInfo);

	local tbPos = pPlayer.GetPartnerPosInfo();
	local tbAllPartner = pPlayer.GetAllPartner();
	local bAllPartner = true;
	local bAllSPartner = true;
	local bAllSSPartner = true;
	local bUseParner = false;
	for _, nPartnerId in pairs(tbPos or {}) do
		local tbPartner = tbAllPartner[nPartnerId];
		if not tbPartner then
			bAllPartner = false;
			bAllSPartner = false;
			bAllSSPartner = false
			break;
		end

		bUseParner = true;

		if tbPartner.nQualityLevel > 3 then
			bAllSPartner = false;
		end
		if tbPartner.nQualityLevel > 2 then
			bAllSSPartner = false
		end
	end

	if bUseParner then
		Task:OnTaskExtInfo(pPlayer, Task.ExtInfo_ShangZhenTongBan);
	end

	if bAllPartner then
		Achievement:AddCount(me, "Partner_3", 1);
	end

	if bAllSPartner then
		Achievement:AddCount(me, "Partner_5", 1);
	end

	if bAllSSPartner then
		Achievement:AddCount(me, "Partner_7", 1);
	end
	JingMai:UpdatePlayerAttrib(pPlayer);
	FightPower:ChangeFightPower("JingMai", pPlayer);
	PartnerCard:UpdatePlayerAttribute(pPlayer)
	FightPower:ChangeFightPower("PartnerCard", pPlayer);

	Partner:CheckPowerAchi(pPlayer)
	PartnerCard:CheckActiveSkillAchi(pPlayer)
end

function Partner:CheckPowerAchi(pPlayer)
	local tbPosInfo = PartnerCard:GetPartnerInfo(pPlayer)
	local nTotalPower = 0
	for _, v in pairs(tbPosInfo) do
		local nFightPower = v.nFightPower or 0
		nTotalPower = nTotalPower + nFightPower
	end
	Achievement:SetCount(pPlayer, "Partner_CE", nTotalPower);
end

function Partner:BatchUseProtentialItem(pPlayer, nPartnerId, nProtentialType, nUseCount)
	if self:CheckNeedConfirmReinit(pPlayer, nPartnerId) then
		pPlayer.CenterMsg("Xin hãy chờ kết quả");
		return;
	end

	local szShowMsg;
	nUseCount = math.max(nUseCount or 1, 1);

	local nAllAddValue = 0;
	local nCurUseCount = 0;
	for i = 1, nUseCount do
		local bRet, szMsg = self:CheckCanUseProtentialItem(pPlayer, nPartnerId, nProtentialType);
		if i == 1 and not bRet then
			szShowMsg = szMsg;
		end

		if not bRet then
			break;
		end

		nAllAddValue = nAllAddValue + (self:UseProtentialItem(pPlayer, nPartnerId, nProtentialType) or 0);
		nCurUseCount = nCurUseCount + 1;
	end

	if not szShowMsg then
		szShowMsg = string.format("Tiêu hao [FFFE0D]%s[-] Tư Chất Đơn, [FFFE0D]%s[-] tăng [FFFE0D]%s[-]", nCurUseCount, self.tbProtentialName[nProtentialType], nAllAddValue);
	end

	pPlayer.CenterMsg(szShowMsg);
	Lib:CallBack({JingMai.OnUsePartnerProtentialItem, JingMai, pPlayer, nCurUseCount});
end

function Partner:UseProtentialItem(pPlayer, nPartnerId, nProtentialType)
	local bRet, szMsg, nType, nProtential, pItem, pPartner, nQualityLevel = self:CheckCanUseProtentialItem(pPlayer, nPartnerId, nProtentialType);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		return;
	end

	if self:CheckNeedConfirmReinit(pPlayer, nPartnerId) then
		pPlayer.CenterMsg("Xin hãy chờ kết quả");
		return;
	end

	local nCount = pPlayer.ConsumeItem(pItem, 1, Env.LogWay_PartnerUseProtentialItem);
	if nCount <= 0 then
		pPlayer.CenterMsg("Tiêu hao đạo cụ thất bại!");
		return;
	end

	local nValue, nOrgValue = self:RandomProtentialItemValue();
	local nResultProtential = nValue + nProtential;
	pPartner.SetProtential(nProtentialType, nResultProtential);

	local nOldUseProValue = pPartner.GetUseProtentialItemValue();
	pPartner.SetUseProtentialItemValue(nOldUseProValue + nOrgValue);
	pPartner.TLog(self.TLOG_DEF_PARTNER_USE_PROTENTIAL_ITEM, Env.LogWay_PartnerUseProtentialItem);

	local nAddValue = math.floor(nResultProtential / self.tbProtentialToValue[nQualityLevel]) - math.floor(nProtential / self.tbProtentialToValue[nQualityLevel]);
	--pPlayer.CenterMsg(string.format("%s潜能增加了%s点", self.tbProtentialName[nProtentialType], nAddValue));
	Task:OnTaskExtInfo(pPlayer, Task.ExtInfo_TiShengZiZhi);
	Log("[Partner] UseProtentialItem ", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, pItem.dwTemplateId, pPartner.nTemplateId, pPartner.szName, nProtentialType, nValue, nProtential, nResultProtential);
	return nAddValue;
end

function Partner:CheckReinitResult(pPlayer, bNotShowData)
	local tbData = pPlayer.GetScriptTable("Partner");
	if tbData and tbData.tbData then
		local pPartner = pPlayer.GetPartnerObj(tbData.nPartnerId);
		if not pPartner then
			tbData.tbData = nil;
			tbData.tbAward = nil;
			tbData.nPartnerId = nil;
		end
	end

	if bNotShowData then
		pPlayer.CallClientScript("Partner:SyncHasReinitData", (tbData and tbData.tbData) and true or false);
		return;
	end

	if tbData and tbData.tbData then
		pPlayer.CallClientScript("Ui:OpenWindow", "PartnerReInitPanel", {nPartnerId = tbData.nPartnerId, tbData = tbData.tbData});
		return true;
	end

	pPlayer.CallClientScript("Partner:SyncHasReinitData", false);
	return;
end

function Partner:GradeLevelup(pPlayer, nPartnerId)
	local bRet, szMsg, pPartner, nDstLevel = self:CheckCanGradeLevelup(pPlayer, nPartnerId);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		pPlayer.SyncPartner(nPartnerId);
		return;
	end

	pPartner.SetGradeLevel(nDstLevel);
	pPlayer.CallClientScript("Partner:OnGradeLevelup", nPartnerId, nDstLevel);
end

function Partner:CheckNeedConfirmReinit(pPlayer, nPartnerId)
	local tbData = pPlayer.GetScriptTable("Partner");
	if tbData.nPartnerId and tbData.nPartnerId == nPartnerId then
		return true;
	end

	return false;
end

function Partner:ReInitPartner(pPlayer, nPartnerId)
	local bHasPartnerData = self:CheckReinitResult(pPlayer);
	if bHasPartnerData then
		return;
	end

	local bRet, szMsg, pPartner, nCost, tbAward, nQualityLevel, nUseItemProtentialValue, bDiscount = self:CheckReinitPartner(pPlayer, nPartnerId);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		return;
	end
	local nRet = pPlayer.ConsumeItemInAllPos(self.nSeveranceItemId, nCost, Env.LogWay_PartnerReInit);
	if nRet ~= nCost then
		pPlayer.CenterMsg("Khấu trừ đạo cụ thất bại!");
		Log("[Partner] ReInitPartner ERR Cost Item Fail !! ", self.nSeveranceItemId, nCost, nRet);
		return;
	end

	local tbData = pPlayer.GetScriptTable("Partner");
	tbData.nPartnerId = nPartnerId;
	tbData.tbRandomCount = tbData.tbRandomCount or {};
	tbData.tbRandomCount[nQualityLevel] = tbData.tbRandomCount[nQualityLevel] or {1, 1}
	tbData.nUseItemProtentialValue = nUseItemProtentialValue;

	local nType = self.PARTNER_TYPE_NORMAL;
	if tbData.tbRandomCount[nQualityLevel][1] >= self.nMaxRandomBYCount then
		nType = self.PARTNER_TYPE_BY;
	elseif tbData.tbRandomCount[nQualityLevel][2] >= self.nMaxRandomGoodCount then
		nType = self.PARTNER_TYPE_GOOD;
	end

	local nNeed = Player:GetRewardValueDebt(pPlayer.dwID);
	if nNeed and nNeed > 0 then
		local nReInitCost = self:GetReInitCostToGold(pPartner.nTemplateId);
		if nReInitCost and nReInitCost > 0 then
			nType = Partner.PARTNER_TYPE_DEBT;
			Player:CostRewardValueDebt(pPlayer.dwID, nReInitCost, Env.LogWay_PartnerReInit);
		end
	end

	tbData.tbData, nType = self:RandomAll(pPartner.nTemplateId, nType);

	if nType ~= self.PARTNER_TYPE_DEBT then
		if nType == self.PARTNER_TYPE_BY then
			tbData.tbRandomCount[nQualityLevel][1] = 1;
		elseif nType == self.PARTNER_TYPE_GOOD then
			tbData.tbRandomCount[nQualityLevel][2] = 1;
			tbData.tbRandomCount[nQualityLevel][1] = tbData.tbRandomCount[nQualityLevel][1] + 1;
		else
			tbData.tbRandomCount[nQualityLevel][1] = tbData.tbRandomCount[nQualityLevel][1] + 1;
			tbData.tbRandomCount[nQualityLevel][2] = tbData.tbRandomCount[nQualityLevel][2] + 1;
		end
	end

	local nLevel, nExp = pPartner.GetLevelInfo();
	tbData.tbData.nLevel = nLevel;
	tbData.tbData.nExp = nExp;
	tbData.tbData.nGradeLevel = pPartner.GetGradeLevel();
	tbData.tbData.nWeaponState = pPartner.nWeaponState;
	tbData.tbData.nAwareness = Partner:GetPartnerAwareness(pPlayer, pPartner.nTemplateId);
	tbData.tbAward = tbAward;
	if bDiscount then
		tbSeveranceDiscountItem:ClearDiscount(pPlayer)
	end
	pPlayer.CenterMsg(string.format("Tẩy tủy thành công, tốn %s Tẩy Tủy Đơn", nCost));
	self:CheckReinitResult(pPlayer);

	-- S 级及以上同伴进行洗髓后立即存盘
	if nQualityLevel <= 3 then
		pPlayer.SavePlayer();
	end

	SummerGift:OnJoinAct(pPlayer, "PartnerRefinement")
	Log("[Partner] ReInitPartner ", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, pPartner.nTemplateId, pPartner.szName);
end

function Partner:ReInitPartnerConfirm(pPlayer, nPartnerId, bUseOrg)
	local tbPartnerData = pPlayer.GetScriptTable("Partner");
	local nOrgId = tbPartnerData.nPartnerId;
	local tbData = tbPartnerData.tbData;
	local tbAward = tbPartnerData.tbAward;

	tbPartnerData.tbData = nil;
	tbPartnerData.tbAward = nil;
	tbPartnerData.nPartnerId = nil;

	if bUseOrg then
		return;
	end

	if not nOrgId or not tbData or nOrgId ~= nPartnerId then
		pPlayer.CenterMsg("Số liệu quá thời gian");
		return;
	end

	local pPartner = pPlayer.GetPartnerObj(nPartnerId);
	if not pPartner then
		pPlayer.CenterMsg("Đồng hành không tồn tại");
		return;
	end

	if tbAward then
		pPlayer.SendAward(tbAward, false, true, Env.LogWay_PartnerReInit);
	end

	tbData.nAwareness = Partner:GetPartnerAwareness(pPlayer, pPartner.nTemplateId);
	pPartner.SetSkillValue(self.INT_VALUE_USE_SKILL_BOOK, 0);
	pPartner.SetSkillValue(self.INT_VALUE_SKILL_ORG_VALUE, 0);
	pPartner.SetUseProtentialItemValue(0);
	self:SetPartnerData(pPartner, tbData);

	pPartner.Update();
	pPartner.TLog(self.TLOG_DEF_PARTNER_REINIT, Env.LogWay_PartnerReInit);

	pPlayer.SyncPartner(nPartnerId);
	pPlayer.CenterMsg("Thay thế thành công");
	Lib:CallBack({JingMai.OnGetProtentialItemByPartner, JingMai, pPlayer, tbPartnerData.nUseItemProtentialValue});
	Partner:CheckPartnerSkillAchi(pPlayer, pPartner)
end

function Partner:DecomposePartner(pPlayer, tbPartnerList)
	local bRet, szMsg, tbAward, szLogInfo, nUseItemProtentialValue, bHasLimitPartner = self:CheckCanDecomposePartner(pPlayer, tbPartnerList);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		return;
	end

	for nPartnerId in pairs(tbPartnerList) do
		pPlayer.DeletePartner(nPartnerId, Env.LogWay_DecomposePartner);
	end

	if bHasLimitPartner and Lib:CountTB(tbAward) <= 0 then
		pPlayer.CenterMsg("Không có phần thưởng sau khi đồng hành bị sa thải!");
	end
	self:FormatDecomposeAward(tbAward)
	pPlayer.SendAward(tbAward, false, true, Env.LogWay_DecomposePartner);
	Lib:CallBack({JingMai.OnGetProtentialItemByPartner, JingMai, pPlayer, nUseItemProtentialValue});
	Log("[Partner] DecomposePartner ", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, szLogInfo);
end

function Partner:FormatDecomposeAward(tbAward)
	for _, v in ipairs(tbAward or {}) do
		if (v[1] == "item" or v[1] == "Item") and (v[2] == 1968 or v[2] == 1969) then
			v[4] = 0
			v[5] = true
		end
	end
end

function Partner:UseSkillBook(pPlayer, nPartnerId, nItemId, nPos)
	local pPartner = pPlayer.GetPartnerObj(nPartnerId);
	local bRet, szMsg, tbParam, nMustPos, tbAllowInfo, nValue = self:CheckCanUseSkillBook(pPlayer, nPartnerId, nItemId);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		return;
	end

	if self:CheckNeedConfirmReinit(pPlayer, nPartnerId) then
		pPlayer.CenterMsg("Xin hãy chờ kết quả");
		return;
	end

	local szName = tbParam.szName;
	local nTemplateId = tbParam.nTemplateId;
	local pItem = tbParam.pItem;
	local nSkillId = tbParam.nSkillId;

	if nMustPos and nMustPos > 0 and nMustPos ~= nPos then
		return;
	end

	if nMustPos and nMustPos <= 0 and not tbAllowInfo[nPos] then
		return;
	end

	local nRet = pPlayer.ConsumeItem(pItem, 1, Env.LogWay_PartnerUseSkillBook);
	if nRet ~= 1 then
		Log("[Partner] UseSkillBook ConsumeItem Fail !!", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, pItem.dwTemplateId, nTemplateId, szName, nPos);
		return;
	end

	local nOldUseSBValue = pPartner.GetSkillValue(self.INT_VALUE_USE_SKILL_BOOK);
	if nOldUseSBValue <= 0 then
		local tbSkillInfo = {};
		for i = 1, 5 do
			local nSkillId, nSkillLevel = pPartner.GetSkillInfo(i);
			if nSkillId > 0 then
				tbSkillInfo[nSkillId] = math.max(nSkillLevel, 1);
			end
		end
		local nSkillValue = self:GetSkillValue(tbSkillInfo);
		pPartner.SetSkillValue(self.INT_VALUE_SKILL_ORG_VALUE, nSkillValue);
	end

	Task:OnTaskExtInfo(pPlayer, Task.ExtInfo_TongBanDaShu);
	bRet = pPlayer.SetPartnerSkill(nPartnerId, nPos, nSkillId);
	if not bRet then
		Log("[Partner] UseSkillBook SetPartnerSkill Fail !!", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, pItem.dwTemplateId, nTemplateId, szName, nPos);
		return;
	end

	pPartner.SetSkillValue(self.INT_VALUE_USE_SKILL_BOOK, nOldUseSBValue + nValue);
	pPartner.TLog(self.TLOG_DEF_PARTNER_USE_SKILL_BOOK, Env.LogWay_PartnerUseSkillBook);
	self:CheckPartnerSkillAchi(pPlayer, pPartner)
	local _, szSkillName = FightSkill:GetSkillShowInfo(nSkillId);
	pPlayer.CenterMsg(string.format("「%s」đã học được %s", pPartner.szName, szSkillName));
	Log("[Partner] UseSkillBook ", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, pItem.dwTemplateId, nTemplateId, szName, nPos);
end

function Partner:CheckPartnerSkillAchi(pPlayer, pPartner)
	if not pPartner then
		Log("Partner fnCheckPartnerSkillAchi fail", pPlayer.dwID, pPlayer.szName)
		return
	end
	local tbSkillLevel = {}
	local bAllLevel_1 = true
	local bAllLevel_2 = true
	local bAllLevel_3 = true
	local bAllLevel_4 = true
	for i = 1, Partner.MAX_PARTNER_SKILL_COUNT do
		local nSkillId = pPartner.GetSkillInfo(i);
		local nQuality = 0
		if nSkillId <= 0 then
			bAllLevel_1 = false 
			bAllLevel_2 = false 
			bAllLevel_3 = false 
			bAllLevel_4 = false 
			break
		end
		local tbSSetting = self:GetSkillInfoBySkillId(nSkillId) or {}
		nQuality = tbSSetting.nQuality or 0 
		if nQuality < 1 then
			bAllLevel_1= false
		end
		if nQuality < 2 then
			bAllLevel_2 = false
		end
		if nQuality < 3 then
			bAllLevel_3 = false
		end
		if nQuality < 4 then
			bAllLevel_4 = false
		end
	end
	-- 给1个同伴学满5个1级及以上技能
	if bAllLevel_1 then
		Achievement:AddCount(pPlayer, "Partner_Skill1", 1);
	end
	-- 给1个同伴学满5个2级及以上技能
	if bAllLevel_2 then
		Achievement:AddCount(pPlayer, "Partner_Skill2", 1);
	end
	-- 给1个同伴学满5个3级及以上技能
	if bAllLevel_3 then
		Achievement:AddCount(pPlayer, "Partner_Skill3", 1);
	end
	-- 给1个同伴学满5个4级及以上技能
	if bAllLevel_4 then
		Achievement:AddCount(pPlayer, "Partner_Skill4", 1);
	end
end

function Partner:DoUseExpItem(pPlayer, nPartnerId, nItemTemplateId, nUseCount)
	nUseCount = nUseCount or 1;
	if nUseCount <= 0 then
		return;
	end

	if self:CheckNeedConfirmReinit(pPlayer, nPartnerId) then
		pPlayer.CenterMsg("Xin hãy chờ kết quả");
		return;
	end

	local pPartner = pPlayer.GetPartnerObj(nPartnerId);
	if not pPartner or pPartner.nLevel >= pPlayer.nLevel then
		pPlayer.CenterMsg("Cấp đồng hành không được vượt quá nhân vật!");
		return;
	end

	if pPartner.nLevel >= self.MAX_LEVEL then
		pPlayer.CenterMsg("Đồng hành bạn đã đạt giới hạn cấp");
		return;
	end

	local _, nQualityLevel = GetOnePartnerBaseInfo(pPartner.nTemplateId);
	local tbItemClass = Item:GetClass("PartnerExpItem");
	local nBaseExp = tbItemClass:GetExpInfo(0, nItemTemplateId, me);
	if not nBaseExp or nBaseExp <= 0 then
		pPlayer.CenterMsg("Đạo cụ vô hiệu, không thể sử dụng!");
		return;
	end

	local nItemCount = pPlayer.GetItemCountInAllPos(nItemTemplateId);
	if nItemCount <= 0 then
		pPlayer.CenterMsg("Đạo cụ sử dụng xong!!");
		return;
	end

	nUseCount = math.min(nUseCount, nItemCount);

	for i = 1, nUseCount do
		local nCount = pPlayer.ConsumeItemInAllPos(nItemTemplateId, 1, Env.LogWay_PartnerUseExpItem);
		if not nCount or nCount < 1 then
			Log("[Partner] DoUseExpItem ", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, pPartner.szName, pPartner.nTemplateId, nItemTemplateId, i - 1);
			return;
		end

		local nExp = math.floor(nBaseExp * GetPartnerBaseExp(nQualityLevel, pPartner.nLevel));
		pPlayer.AddPartnerExp(nPartnerId, nExp, i == nUseCount);
		if pPartner.nLevel >= self.MAX_LEVEL then
			pPlayer.AddPartnerExp(nPartnerId, 1, true);
			nUseCount = i;
			break;
		end
	end

	Task:OnTaskExtInfo(pPlayer, Task.ExtInfo_TongBanJiaJingYan);
	Log("[Partner] DoUseExpItem ", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, pPartner.szName, pPartner.nTemplateId, nItemTemplateId, nUseCount, pPartner.nLevel);
end

function Partner:DoAwareness(pPlayer, nPartnerId, tbUsePartnerInfo)
	local pPartner = pPlayer.GetPartnerObj(nPartnerId);
	if pPartner then
		local tbNeedInfo = self.tbAwareness[pPartner.nTemplateId];
		if tbNeedInfo then
			local nCount = pPlayer.GetItemCountInBags(self.nPartnerAwarenessCostItem);
			if nCount < tbNeedInfo.nNeedSeveranceItem then
				MarketStall:TipBuyItemFromMarket(pPlayer, self.nPartnerAwarenessCostItem);
				return;
			end
		end
	end

	local bRet, szMsg, nPartnerTemplateId, tbNeedInfo, tbAward, tbConsumeItem, nTotalProtentialValue = Partner:CheckCanAwareness(pPlayer, nPartnerId, tbUsePartnerInfo);
	if not bRet then
		pPlayer.CenterMsg(szMsg or "Không thể thức tỉnh");
		return;
	end

	if self:CheckNeedConfirmReinit(pPlayer, nPartnerId) then
		pPlayer.CenterMsg("Xin hãy chờ kết quả");
		return;
	end

	local nCostCount = pPlayer.ConsumeItemInBag(self.nPartnerAwarenessCostItem, tbNeedInfo.nNeedSeveranceItem, Env.LogWay_PartnerAwareness);
	if nCostCount ~= tbNeedInfo.nNeedSeveranceItem then
		pPlayer.CenterMsg("Tiêu hao đạo cụ thất bại!", true);
		Log("[Partner] DoAwareness cost item fail !!", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, tbNeedInfo.nNeedSeveranceItem, nCostCount);
		return;
	end

	for _, nWeaponItemId in pairs(tbConsumeItem or {}) do
		local nCCount = pPlayer.ConsumeItemInBag(nWeaponItemId, 1, Env.LogWay_PartnerAwareness);
		if nCCount ~= 1 then
			pPlayer.CenterMsg("Tiêu hao đạo cụ thất bại!", true);
			Log("[Partner] DoAwareness cost item fail !!", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, tbNeedInfo.nNeedSeveranceItem, nCostCount);
		else
			Log("[Partner] DoAwareness Consume PartnerWeapon ", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, self.nPartnerAwarenessCostItem, tbNeedInfo.nNeedSeveranceItem, nWeaponItemId);
		end
	end

	for _, nPartnerId in pairs(tbUsePartnerInfo) do
		pPlayer.DeletePartner(nPartnerId, Env.LogWay_PartnerAwareness);
	end

	if tbAward then
		pPlayer.SendAward(tbAward, false, true, Env.LogWay_PartnerAwareness);
		if nTotalProtentialValue > 0 then
			Lib:CallBack({JingMai.OnGetProtentialItemByPartner, JingMai, pPlayer, nTotalProtentialValue});
		end
	end
	Partner:SetPartnerAwareness(pPlayer, nPartnerTemplateId);
	pPlayer.SendBlackBoardMsg("Thức tỉnh thành công, tiềm năng đã được tăng mạnh mẽ!");
	pPlayer.CallClientScript("Partner:PGAwarenessFinish", nPartnerId);

	pPlayer.TLog("OptPartner", self.TLOG_DEF_PARTNER_AWARENESS, Env.LogWay_PartnerAwareness, 0, nPartnerTemplateId, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	Partner:CheckAwakenAchi(pPlayer)
	
	local szName, nQualityLevel = GetOnePartnerBaseInfo(nPartnerTemplateId);

	if nQualityLevel <= 2 then
		KPlayer.SendWorldNotify(0, 1000, string.format("Chúc mừng「%s」có đồng hành %s-%s thức tỉnh thành công, tiềm năng đã được tăng hết!", pPlayer.szName, Partner.tbQualityLevelDes[nQualityLevel], szName), 1, 1);
	end

	if nQualityLevel <= 3 then
		if pPlayer.dwKinId > 0 then
			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format("Thành viên「%s」có đồng hành %s-%s thức tỉnh thành công, tiềm năng đã được tăng hết!", pPlayer.szName, Partner.tbQualityLevelDes[nQualityLevel], szName), pPlayer.dwKinId);
		end
	end
	Log("[Partner] DoAwareness", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, nPartnerTemplateId);
end

-- 新版成就更新之后将某些重要的已经达到的成就设置已完成
function Partner:CheckOldFinishAchievent(pPlayer)
	local tbAllPartner = pPlayer.GetAllPartner();
	for nPartnerId, tbPartnerInfo in pairs(tbAllPartner or {}) do
		-- 第一次获得天级同伴
		if tbPartnerInfo.nQualityLevel <= Partner.tbDes2QualityLevel.SSS then
			Achievement:AddCount(pPlayer, "Partner_8", 1);
		end
		-- 第一次获得地级同伴
		if tbPartnerInfo.nQualityLevel <= Partner.tbDes2QualityLevel.SS then
			Achievement:AddCount(pPlayer, "Partner_6", 1);
		end
		local pPartner = pPlayer.GetPartnerObj(nPartnerId);
		Partner:CheckPartnerSkillAchi(pPlayer, pPartner)
	end
	Partner:CheckWeaponAchi(pPlayer)
	Partner:CheckAwakenAchi(pPlayer)
	Partner:CheckPowerAchi(pPlayer)

	local tbLearnInfo = JingMai:GetLearnedXueWeiInfo(pPlayer, nil, true) or {}
	if next(tbLearnInfo) then
		Achievement:AddCount(pPlayer, "Meridian", 1);
	end
	JingMai:CheckXueWeiAchi(pPlayer)
	Task:CheckOldAchi(pPlayer)
end

function Partner:CheckAwakenAchi(pPlayer)
	local nCount = 0
	local tbAllPartner = pPlayer.GetAllPartner();
	for _, tbPartnerInfo in pairs(tbAllPartner or {}) do
		if tbPartnerInfo.nAwareness == 1 then
			nCount = nCount + 1
		end
	end
	if nCount > 0 then
		Achievement:SetCount(pPlayer, "Partner_Awaken", nCount);
	end
end

function Partner:CheckWeaponAchi(pPlayer)
	local nCount = 0
	local tbAllPartner = pPlayer.GetAllPartner();
	for _, tbPartnerInfo in pairs(tbAllPartner or {}) do
		if tbPartnerInfo.nWeaponState ~= 0 then
			nCount = nCount + 1
		end
	end
	if nCount > 0 then
		Achievement:SetCount(pPlayer, "Partner_Equip", nCount);
	end
end

local tbPartnerWeapon;
function Partner:UseWeapon(pPlayer, nPartnerId)
	local tbPartner = pPlayer.GetPartnerInfo(nPartnerId or 0);
	if not tbPartner then
		return;
	end

	if tbPartner.nWeaponState ~= 0 then
		pPlayer.CenterMsg(string.format("【%s】đã có vũ khí này", tbPartner.szName));
		return;
	end

	if self:CheckNeedConfirmReinit(pPlayer, nPartnerId) then
		pPlayer.CenterMsg("Xin hãy chờ kết quả");
		return;
	end

	local nWeaponItemTemplateId = Partner.tbPartner2WeaponItem[tbPartner.nTemplateId];
	if not nWeaponItemTemplateId then
		pPlayer.CenterMsg("Không có Vũ Khí Bổn Mạng đồng hành!");
		return;
	end

	local nCount, tbItems = pPlayer.GetItemCountInBags(nWeaponItemTemplateId);
	if nCount <= 0 then
		MarketStall:TipBuyItemFromMarket(pPlayer, nWeaponItemTemplateId);
		return;
	end

	local pItem = tbItems[1];
	tbPartnerWeapon = tbPartnerWeapon or Item:GetClass("PartnerWeapon");
	local szItemName = string.gsub(pItem.szName, tbPartner.szName .. "·", "");
	pPlayer.MsgBox(string.format("Trang bị [FFFE0D]%s[-] Vũ Khí Bổn Mạng [FFFE0D]%s[-]?\n[FFFE0D](Sau khi trang bị không được gỡ, sa thải sẽ hoàn trả)[-]", tbPartner.szName, szItemName),
		{
			{"Đồng ý", tbPartnerWeapon.UseWeapon, tbPartnerWeapon, pPlayer.dwID, nPartnerId, pItem.dwId},
			{"Hủy"}
		});
end

function Partner:OnAddPartner(nPartnerId, nQualityLevel, nLogReazon, nPId)
	Log("Partner:OnAddPartner", me.dwID, me.szAccount, me.szName, nPartnerId, nQualityLevel);

	if me.GetUserValue(self.PARTNER_HAS_GROUP, nPartnerId) == 0 then
		me.SetUserValue(self.PARTNER_HAS_GROUP, nPartnerId, 1);
	end

	if nQualityLevel <= 3 then
		local szPartnerName = GetOnePartnerBaseInfo(nPartnerId);
		if szPartnerName then
			local szWorldNotifyMsg = string.format("[FFFF00]「%s」[-]nhận Đồng Hành [FFFF00]%s[-] [FF0066]「%s」[-]", me.szName, Partner.tbQualityLevelDes[nQualityLevel], szPartnerName);
			if nLogReazon >= Env.LogWay_CoinPick and nLogReazon <= Env.LogWay_GoldFreePick then
				Timer:Register(Env.GAME_FPS * 10, function ()
					KPlayer.SendWorldNotify(0, 1000, szWorldNotifyMsg, 1, 1);
				end);
			else
				KPlayer.SendWorldNotify(0, 1000, szWorldNotifyMsg, 1, 1);
			end
		end
	end
	-- 第一次获得同伴
	Achievement:AddCount(me, "Partner_1", 1);
	-- 第一次获得乙级以上同伴
	if nQualityLevel <= Partner.tbDes2QualityLevel.A then
		Achievement:AddCount(me, "Partner_2", 1);
	end
	-- 第一次获得甲级以上同伴
	if nQualityLevel <= Partner.tbDes2QualityLevel.S then
		Achievement:AddCount(me, "Partner_4", 1);
	end
	-- 第一次获得地级同伴
	if nQualityLevel <= Partner.tbDes2QualityLevel.SS then
		Achievement:AddCount(me, "Partner_6", 1);
	end
	-- 第一次获得天级同伴
	if nQualityLevel <= Partner.tbDes2QualityLevel.SSS then
		Achievement:AddCount(me, "Partner_8", 1);
	end

	if nQualityLevel <= Partner.tbDes2QualityLevel.SS then
		local nSSCount = me.GetUserValue(Sdk.Def.SDK_INFO_SAVEGROUP, Sdk.Def.SDK_INFO_SS_PARTNER_COUNT);
		if nSSCount == 0 then
			Sdk:SendTXLuckyBagMail(me, "FirstSSPartner");
		end
		me.SetUserValue(Sdk.Def.SDK_INFO_SAVEGROUP, Sdk.Def.SDK_INFO_SS_PARTNER_COUNT, nSSCount + 1);
	end
	if nPId then
		local pPartner = me.GetPartnerObj(nPId);
		if pPartner then
			self:CheckPartnerSkillAchi(me, pPartner)
		end
	end

	self:ReportPartner(nQualityLevel)
end

function Partner:OnDeletePartner(nPartnerId, nQualityLevel, nTemplateId, nHave)
	Log("[Partner] OnDeletePartner", me.dwID, me.szAccount, me.szName, nPartnerId, nQualityLevel, nTemplateId, nHave);
	self:ReportPartner(nQualityLevel, nHave)
end

function Partner:ReportPartner(nQualityLevel, nHave)
    local nHave = nHave or (Partner:GetPartnerCountByQuality(me,nQualityLevel) or 0)

    if nQualityLevel == Partner.tbDes2QualityLevel.SS then
        AssistClient:ReportQQScore(me, Env.QQReport_PartnenrSSCount, nHave, 0, 1)
    elseif nQualityLevel == Partner.tbDes2QualityLevel.S then
        AssistClient:ReportQQScore(me, Env.QQReport_PartnenrSCount, nHave, 0, 1)
    elseif nQualityLevel == Partner.tbDes2QualityLevel.A then
        AssistClient:ReportQQScore(me, Env.QQReport_PartnenrACount, nHave, 0, 1)
    elseif nQualityLevel == Partner.tbDes2QualityLevel.B then
        AssistClient:ReportQQScore(me, Env.QQReport_PartnenrBCount, nHave, 0, 1)
    elseif nQualityLevel == Partner.tbDes2QualityLevel.C then
        AssistClient:ReportQQScore(me, Env.QQReport_PartnenrCCount, nHave, 0, 1)
    end
end

function Partner:OnLogin(pPlayer)
	local tbAllPartner = pPlayer.GetAllPartner();

	for nPartnerId, tbPartnerInfo in pairs(tbAllPartner or {}) do
		if pPlayer.GetUserValue(self.PARTNER_HAS_GROUP, tbPartnerInfo.nTemplateId) == 0 then
			pPlayer.SetUserValue(self.PARTNER_HAS_GROUP, tbPartnerInfo.nTemplateId, 1);
		end

		local nAwareness = Partner:GetPartnerAwareness(pPlayer, tbPartnerInfo.nTemplateId);
		local pPartner = pPlayer.GetPartnerObj(nPartnerId);

		if pPartner.GetAwareness() ~= nAwareness then
			pPartner.SetAwareness(nAwareness)
			pPartner.Update();
		end
	end
end

function Partner:OnZoneLogin(pPlayer) --对应同伴数据未初始化，先只有武林大会用到设置其出战同步
	local pAsync = KPlayer.GetAsyncData(pPlayer.dwID)
	if not pAsync then
		return
	end
	local tbPartnerPosToId = pPlayer.GetPartnerPosInfo()
	if not tbPartnerPosToId then
		return
	end
	local nMaxFightPower = 0
	local nTarnPartnerId;
	for nPos,nPartnerId in ipairs(tbPartnerPosToId) do
		if nPartnerId ~= 0 then
			local nPartnerTemplateId, nLevel,nFightPower = pAsync.GetPartnerInfo(nPos);
			if nFightPower and nFightPower > nMaxFightPower then
				nTarnPartnerId = nPartnerId
				nMaxFightPower = nFightPower
			end
		end
	end
	if nTarnPartnerId then
		pPlayer.SetFightPartnerID(nTarnPartnerId)
	else
		pPlayer.SetFightPartnerID(0)	
	end
end

function Partner:CallPartner(pPlayer, nPartnerTemplateId)
	local szPartnerName, nQualityLevel = GetOnePartnerBaseInfo(nPartnerTemplateId);
	local nNeedCount = self.tbCallPartnerCost[nQualityLevel or 0];
	if not nNeedCount or nNeedCount <= 0 then
		return;
	end

	local nHasPartner = pPlayer.GetUserValue(self.PARTNER_HAS_GROUP, nPartnerTemplateId);
	if nHasPartner == 0 then
		pPlayer.CenterMsg("Đồng hành đã từng sử dụng mới có thể chiêu mộ");
		return;
	end


	local nItemCount = pPlayer.GetItemCountInAllPos(self.nSeveranceItemId);
	if nItemCount < nNeedCount then
		pPlayer.CenterMsg("Tẩy Tủy Đơn để chiêu mộ đồng hành không đủ");
		return;
	end

	local nCost = pPlayer.ConsumeItemInAllPos(self.nSeveranceItemId, nNeedCount, Env.LogWay_PartnerCallPartner);
	if nCost ~= nNeedCount then
		pPlayer.CenterMsg("Khấu trừ đạo cụ thất bại, xin vui lòng liên hệ bộ phận CSKH!");
		Log("[Partner] CallPartner ConsumeItemInAllPos Fail !!", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, nCost, nNeedCount);
		return;
	end

	pPlayer.SendAward({{"partner", nPartnerTemplateId, 1}}, true, false, Env.LogWay_PartnerCallPartner);
	Log("[Partner] CallPartner", pPlayer.dwID, pPlayer.szAccount, pPlayer.szName, nPartnerTemplateId, nQualityLevel, nCost);
end

function Partner:ChangePartnerFightID(pPlayer, nPartnerId)
	if type(nPartnerId) ~= "number" then
		return;
	end

    local tbPartner = pPlayer.GetPartnerInfo(nPartnerId);
    if not tbPartner then
    	return;
    end

    pPlayer.SetFightPartnerID(nPartnerId);
 	pPlayer.CallClientScript("Partner:ChangePartnerFightID", nPartnerId);
 	pPlayer.OnEvent("OnChangePartnerFightID", nPartnerId);
 	Log("Partner ChangePartnerFightID", pPlayer.dwID, nPartnerId);
end

function Partner:OnZCSetFightPartnerID(dwRoleId, nPartnerId)
	local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
	if not pPlayer then
		return
	end
	pPlayer.SetFightPartnerID(nPartnerId);
end

PlayerEvent:RegisterGlobal("OnAddPartner",				Partner.OnAddPartner, Partner);
PlayerEvent:RegisterGlobal("OnDeletePartner",			Partner.OnDeletePartner, Partner);

