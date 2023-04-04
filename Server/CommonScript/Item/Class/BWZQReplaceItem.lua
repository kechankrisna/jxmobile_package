local tbItem = Item:GetClass("BWZQReplaceItem");

function tbItem:OnUse(it)
	if not Activity:__IsActInProcessByType("NpcBiWuZhaoQin") then
		me.CenterMsg("Hiện không có hoạt động Tỉ Võ Chiêu Thân!")
		return 
	end
	Activity:OnPlayerEvent(me, "Act_NpcBiWuZhaoQinClientCall", "UseReplaceItem");
end