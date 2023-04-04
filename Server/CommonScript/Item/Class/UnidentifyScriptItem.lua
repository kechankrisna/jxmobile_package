
local tbUnidentify = Item:GetClass("UnidentifyScriptItem");

function tbUnidentify:OnUse(it)
	local nCost = self:GetIdentifyCost(it.dwTemplateId)
	local nEquipTemplateId = KItem.GetItemExtParam(it.dwTemplateId, 2);
	local nOtherTemplateId = KItem.GetItemExtParam(it.dwTemplateId, 3);
	if nEquipTemplateId <= 0 or not me.CostMoney("Coin", nCost, Env.LogWay_IdentifyItem) then
		return
	end

	if nOtherTemplateId > 0 and MarketStall:CheckIsLimitPlayer(me) then
		nEquipTemplateId = nOtherTemplateId;
	end

	me.SendAward({{"item", nEquipTemplateId, 1}}, true, false, Env.LogWay_IdentifyItem);
	me.CenterMsg("Giám định thành công");
	return 1;
end

function tbUnidentify:GetIdentifyCost(dwTemplateId)
	return KItem.GetItemExtParam(dwTemplateId, 1);
end

function tbUnidentify:CheckUsable(it)
	local nCost = self:GetIdentifyCost(it.dwTemplateId)
	if me.GetMoney("Coin") < nCost then
		return 0, string.format("Không đủ %d Bạc", nCost)
	end

	return 1;
end

function tbUnidentify:GetIntroBottom(nTemplateId)
	local _, szMoneyEmotion = Shop:GetMoneyName("Coin")
	return string.format("Giám định tiêu hao %s %d", szMoneyEmotion, self:GetIdentifyCost(nTemplateId));
end

function tbUnidentify:GetUseSetting()
	return {szFirstName = "Giám định", fnFirst = "UseItem"};
end
