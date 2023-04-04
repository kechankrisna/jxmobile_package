local tbItem = Item:GetClass("EnergyItem");
function tbItem:OnUse(it)
	local nEnergy = math.floor(tonumber(KItem.GetItemExtParam(it.dwTemplateId, 1)));
	if nEnergy <= 0 then
		me.CenterMsg("Đạo cụ bất thường!");
		return;
	end

	me.SendAward({{"Energy", nEnergy}}, true, false, Env.LogWay_UseEnergyItem);

	Log("[EnergyItem] OnUse ", it.dwTemplateId, "==> Energy: ", nEnergy);

	return 1;
end