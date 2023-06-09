
local tbUnidentify = Item:GetClass("Unidentify");
tbUnidentify.szCostMoneyType = "Coin"

function tbUnidentify:OnUse(it)
	local nCost = self:GetIdentifyCost(it.dwTemplateId)
	local nEquipTemplateId = KItem.GetItemExtParam(it.dwTemplateId, 1);
	if not me.CostMoney(self.szCostMoneyType, nCost, Env.LogWay_IdentifyEquip) then
		return
	end

	Task:OnTaskExtInfo(me, Task.ExtInfo_JianDing);
	local pItem = me.AddItem(nEquipTemplateId, 1, nil, Env.LogWay_IdentifyEquip);
	if pItem and pItem.GetIntValue(Item.tbZhenYuan.nItemKeySKillInfo) ~= 0 and pItem.szClass == "ZhenYuan" then
		local szEquipName = KItem.GetItemShowInfo(nEquipTemplateId, me.nFaction, me.nSex);
		
		if (me.nFaction >= 18) then
			szEquipName = Item:GetNewItemShowInfo(nEquipTemplateId, me.nFaction, me.nSex);
		end
		
		
		
		local szSysMsg = string.format("「%s」giám định thành công <%s>, thật là may mắn!", me.szName, szEquipName)
		local tbRandomAtrrib = {};
		for i=1,7 do
			tbRandomAtrrib[i] = pItem.GetIntValue(i);
		end
		local tbData = {
			nCount = 1,
			nLinkType = ChatMgr.LinkType.Item, 
			nFaction = me.nFaction,
			nSex = me.nSex,
			nTemplateId = nEquipTemplateId, 
			szName = szEquipName,
			bIsEquip = true,
			tbRandomAtrrib = tbRandomAtrrib,
		}
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.System, szSysMsg, 0, tbData)
		Achievement:AddCount(me, "ZhenYuan_Skill", 1)
	end
	me.CenterMsg("Giám định thành công");
	return 1;
end

function tbUnidentify:GetIdentifyCost(dwTemplateId)
	local tbBaseInfo = KItem.GetItemBaseProp(dwTemplateId)
	return math.floor(tbBaseInfo.nValue * 0.1 / 10)
end

function tbUnidentify:CheckUsable(it)
	local nCost = self:GetIdentifyCost(it.dwTemplateId)
	if me.GetMoney(self.szCostMoneyType) < nCost then
		local szMoneyName = Shop:GetMoneyName(self.szCostMoneyType)
		return 0, string.format("Trên người không đủ %d%s", nCost, szMoneyName)
	end

	return 1;
end

function tbUnidentify:GetIntroBottom(nTemplateId)
	local _, szMoneyEmotion = Shop:GetMoneyName(self.szCostMoneyType)
	return string.format("Giám định tiêu hao %s %d", szMoneyEmotion, self:GetIdentifyCost(nTemplateId));
end

function tbUnidentify:GetIntrol(nTemplateId, nItemId)
	local nSumPrice, szMoneyType = Shop:GetSellSumPrice(me, nTemplateId, 1)
	local tbItemBase = KItem.GetItemBaseProp(nTemplateId)
	if nSumPrice then
		local _, szMoneyEmotion = Shop:GetMoneyName(szMoneyType)
		return  string.format("%s\n\n\n[73cbd5]Bán sẽ nhận: %s%d[-]", tbItemBase.szIntro, szMoneyEmotion, nSumPrice)
	end
	return tbItemBase.szIntro
end

function tbUnidentify:GetUseSetting(nTemplateId, nItemId)
	if Shop:CanSellWare(me, nItemId, 1) then
		return {szFirstName = "Bán", fnFirst = "SellItem", szSecondName = "Giám định", fnSecond = "UseItem"};
	else
		return {szFirstName = "Giám định", fnFirst = "UseItem"};
	end
end
