local tbItem = Item:GetClass("SwornFriendsTitleToken")

function tbItem:OnUse(it)
	if not SwornFriends:IsConnectedState(me) then
		me.CenterMsg("Đại hiệp chưa kết bái, không thể dùng")
		return
	end

    me.CallClientScript("Ui:CloseWindow", "QuickUseItem")
	me.CallClientScript("Ui:CloseWindow", "ItemTips")
	me.CallClientScript("Ui:CloseWindow", "ItemBox")
	me.CallClientScript("Ui:OpenWindow", "SwornFriendsPersonalTitlePanel", true)
end
