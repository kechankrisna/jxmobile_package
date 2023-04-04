
local tbItem = Item:GetClass("GoldEvoMaterialMap");

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local tbUseSetting = {szFirstName = "Dùng"};
	tbUseSetting.fnFirst = function ()
		Ui:CloseWindow("ItemTips")
		local nTarItem = Item.GoldEquip:GetCosumeItemToTarItem(nTemplateId)
		Ui:OpenWindow("EquipmentEvolutionPanel", "Type_Evolution", nTarItem)
	end
	
	if Shop:CanSellWare(me, nItemId, 1) then
		tbUseSetting.fnSecond = "SellItem";
		tbUseSetting.szSecondName = "Bán";
	end

	return tbUseSetting;		
end

