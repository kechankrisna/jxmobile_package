local tbItem = Item:GetClass("MedalItem")

function tbItem:GetUseSetting(nTemplateId, nItemId)
	return {
        szFirstName = "Xem hạng",
        fnFirst = function()
            Ui:CloseWindow("ItemTips")
            Ui:OpenWindow("RankBoardPanel", "MedalFightAct")
        end,
    }
end