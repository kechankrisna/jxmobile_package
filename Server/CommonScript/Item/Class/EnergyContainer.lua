local tbItem = Item:GetClass("EnergyContainer");
function tbItem:OnUse(it)
	local nItemTemplateId = tonumber(KItem.GetItemExtParam(it.dwTemplateId, 1))
	assert(nItemTemplateId, "illegal param: " .. it.dwTemplateId);

	local tbItemInfo = KItem.GetItemBaseProp(nItemTemplateId);
	if not tbItemInfo or tbItemInfo.szClass ~= "EnergyItem" then
		me.CenterMsg("Đạo cụ bất thường!");
		return;
	end

	local nEnergy = math.floor(tonumber(KItem.GetItemExtParam(nItemTemplateId, 1)));
	if nEnergy <= 0 then
		me.CenterMsg("Đạo cụ bất thường!");
		return;
	end

	if me.GetMoney("Energy") < nEnergy then
		me.CenterMsg("Nguyên Khí không đủ");
		return;
	end

	local bRet, szMsg = me.CheckNeedArrangeBag();
	if bRet then
		me.CenterMsg(szMsg);
		return;
	end

	if not me.CostMoney("Energy", nEnergy, Env.LogWay_UseEnergyContainer) then
		me.CenterMsg("Khấu trừ Nguyên Khí thất bại");
		return;
	end

	me.SendAward({{"item", nItemTemplateId, 1}}, true, true, Env.LogWay_UseEnergyContainer);

	Log("[EnergyContainer] OnUse ", it.dwTemplateId, "==>", nItemTemplateId);

	return 1;
end