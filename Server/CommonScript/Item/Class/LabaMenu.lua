local tbItem = Item:GetClass("LabaMenu");
function tbItem:OnUse(it)
	if not Activity:__IsActInProcessByType("LabaAct") then
		me.CenterMsg("Hoạt động đã kết thúc", true)
		return
	end
	me.CallClientScript("Activity.LabaAct:OnUseLabaMenu")
end
