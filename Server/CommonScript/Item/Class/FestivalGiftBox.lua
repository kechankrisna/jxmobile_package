-- 赠品·佳节礼盒
local tbItem = Item:GetClass("FestivalGiftBox")

function tbItem:GetUseSetting(nTemplateId, nItemId)
	return {
    	szFirstName = "Tặng",
    	fnFirst = function()
    		Ui:OpenWindow("GiftSystem")
        	Ui:CloseWindow("ItemTips")
    	end,
    }
end
