local tbItem = Item:GetClass("ArborItemNpc");

function tbItem:OnUse(it)
	if not Activity:__IsActInProcessByType("ArborDayCure") then
		me.CenterMsg("Hoạt động đã kết thúc", true)
		return 
	end

	local nNpcTID =  KItem.GetItemExtParam(it.dwTemplateId, 1);
	if not nNpcTID then
		me.CenterMsg("Đạo cụ chưa biết", true)
		return 
	end

	Activity:OnPlayerEvent(me, "Act_UseArborItemNpc", it.dwTemplateId, nNpcTID);
end