local tbItem = Item:GetClass("DrinkHouseDrinkItem");


function tbItem:OnUse( it )
	if DrinkHouse:InviteDrinkPopAvaliable(me) then
		me.CenterMsg("Đã dùng đạo cụ này")
		return
	end
	me.SetUserValue(DrinkHouse.tbDef.SAVE_GROUP, DrinkHouse.tbDef.SAVE_KEY_DRINK_INVITE, 1)	
	me.CenterMsg("Đã nhận tính năng mời rượu, hãy đến Vong Ưu Tửu Quán thử nào.", true)
	return 1;
end