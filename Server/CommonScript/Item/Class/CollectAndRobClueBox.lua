local tbItem = Item:GetClass("CollectAndRobClueBox");

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local tbUserSet = {};
	if Activity:__IsActInProcessByType("CollectAndRobClue") then
		local fnFirst = function ()
			Ui:OpenWindow("NationalCollectPanel") 
			Ui:CloseWindow("ItemTips")
		end
		tbUserSet.szFirstName = "Mở"
		tbUserSet.fnFirst = fnFirst		
	else
		if Shop:CanSellWare(me, nItemId, 1) then
			tbUserSet.szFirstName = "Bán"
			tbUserSet.fnFirst = "SellItem"
		end
	end
	return tbUserSet
end