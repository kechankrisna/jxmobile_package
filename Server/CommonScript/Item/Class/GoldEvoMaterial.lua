
local tbItem = Item:GetClass("GoldEvoMaterial");

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local tbUseSetting = {szFirstName = "Dùng"};
	tbUseSetting.fnFirst = function ()
		Ui:CloseWindow("ItemTips")
		Ui:OpenWindow("EquipmentEvolutionPanel", "Type_Evolution")
	end
	
	if GetTimeFrameState("OpenLevel89") == 1 then
		tbUseSetting.szFirstName = "Chế tạo"
		tbUseSetting.szSecondName = "Tăng bậc"
		tbUseSetting.fnSecond = function ()
			Ui:CloseWindow("ItemTips")
			Ui:OpenWindow("EquipmentEvolutionPanel", "Type_Upgrade")	
		end
	end
	

	return tbUseSetting;		
end

