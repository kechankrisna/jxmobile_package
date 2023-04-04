local tbItem = Item:GetClass("DrinkHouseDinnerItem");

function tbItem:GetUseSetting()
	local fnFirst = function (  )
		AutoPath:AutoPathToNpc(DrinkHouse.tbDinnerDef.nDinnerNpcId, DrinkHouse.tbDinnerDef.nDinnerNpcMapId)
		Ui:CloseWindow("ItemTips")
		Ui:CloseWindow("ItemBox")
	end
	return {szFirstName = "Dùng", fnFirst = fnFirst};
end