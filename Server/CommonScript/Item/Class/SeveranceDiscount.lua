local tbItem = Item:GetClass("SeveranceDiscount");
tbItem.SAVE_GROUP = 152
tbItem.KEY_DISCOUNT = 1 				-- 洗髓折扣道具折扣
tbItem.tbDiscountLevel = {1,2,3,4} 		-- 可以打折的等级
tbItem.tbDiscountQualityLevel = {}
for _, nQualityLevel in ipairs(tbItem.tbDiscountLevel) do
	tbItem.tbDiscountQualityLevel[nQualityLevel] = true
end

function tbItem:OnUse(it)
	local nDiscount =  KItem.GetItemExtParam(it.dwTemplateId, 1);
	if nDiscount >= 10 or nDiscount <= 0 then
		me.CenterMsg("Đạo cụ chưa rõ giá giảm", true)
		return
	end
	local nCurDiscount = self:GetDiscount(me)
	if nCurDiscount ~= 0 then
		me.CenterMsg("Đã có giảm giá tẩy tủy", true)
		return
	end
	me.SetUserValue(self.SAVE_GROUP, self.KEY_DISCOUNT, nDiscount);
	me.CenterMsg(string.format("Tẩy tủy đồng hành lần sau chỉ tốn %s%% Tẩy Tủy Đơn", nDiscount * 10), true)
	return 1
end

function tbItem:GetDiscount(pPlayer)
	return pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_DISCOUNT);
end

function tbItem:ClearDiscount(pPlayer)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_DISCOUNT, 0);
end

function tbItem:Discount(pPlayer, nCost, nQualityLevel)
	local bDiscount 
	local nDiscount = self:GetDiscount(pPlayer)
	if self.tbDiscountQualityLevel[nQualityLevel] and nCost and nDiscount > 0 and nDiscount < 10 then
		-- 取上不会有0的情况
		nCost = math.ceil(nCost * nDiscount / 10)
		bDiscount = true
	end
	return nCost, bDiscount
end