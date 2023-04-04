local tbItem = Item:GetClass("NYSnowmanBox");

function tbItem:OnUse(it)
	local NYSnowman = Kin.NYSnowman
	local nGet = me.GetUserValue(NYSnowman.SAVE_ONHOOK_GROUP, NYSnowman.Award_Count);
	if nGet >= NYSnowman.nBoxOpenCount then
		me.CenterMsg("Số lần mở hộp quà đã hết",true)
		return
	end

	me.SetUserValue(NYSnowman.SAVE_ONHOOK_GROUP,NYSnowman.Award_Count,nGet + 1)

	local nItemId = tonumber(KItem.GetItemExtParam(it.dwTemplateId, 1))
	me.SendAward({{"item", nItemId, 1}}, nil, true, Env.LogWay_NYSnowmanActBox);
	Log("[NYSnowmanBox] OnUse ",nItemId,it.dwTemplateId,nGet)
	return 1
end