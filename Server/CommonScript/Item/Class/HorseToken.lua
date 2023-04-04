local tbItem = Item:GetClass("HorseToken")
tbItem.szEvolutionTimeFrame = "OpenLevel79"
tbItem.szEvolutionTimeFrame2 = "OpenLevel99"
tbItem.szEvolutionTimeFrame3 = "OpenLevel119"
tbItem.szEvolutionTimeFrame4 = "OpenLevel139"
tbItem.szEvolutionTimeFrame5 = "OpenLevel159"

function tbItem:GetUseSetting(nTemplateId, nItemId)
    local tbUseSetting = {szFirstName = "Đổi", fnFirst = "UseItem"};

    if GetTimeFrameState(self.szEvolutionTimeFrame) == 1 then
        tbUseSetting.szSecondName = "Tăng bậc"        
        tbUseSetting.fnSecond = function ()
            Ui:CloseWindow("ItemTips")
            Ui:OpenWindow("EquipmentEvolutionPanel", "Type_EvolutionHorse")
        end
    end

    return tbUseSetting;        
end

function tbItem:OnUse(pItem)
    local tbExchangeItem = Item:GetClass("ExchangeItem")
    return  tbExchangeItem:OnUse(pItem)
end

function tbItem:GetIntrol(dwTemplateId)
    local tbBase = KItem.GetItemBaseProp(dwTemplateId)
    local szBaseTip = tbBase.szIntro
    if GetTimeFrameState(self.szEvolutionTimeFrame) == 1 then
        szBaseTip = szBaseTip .. "\n\nCó thể tăng Ô Vân Đạp Tuyết Lv50 lên thành Tuyệt Ảnh Lv70"
    end
    if GetTimeFrameState(self.szEvolutionTimeFrame2) == 1 then
        szBaseTip = szBaseTip .. "\nCó thể tăng Tuyệt Ảnh Lv70 lên thành Vạn Lý Yên Vân Chiếu Lv90"
    end
    if GetTimeFrameState(self.szEvolutionTimeFrame3) == 1 then
        szBaseTip = szBaseTip .. "\nCó thể tăng Vạn Lý Yên Vân Chiếu Lv90 lên thành Truy Phong Lôi Báo Lv110"
    end
    if GetTimeFrameState(self.szEvolutionTimeFrame4) == 1 then
        szBaseTip = szBaseTip .. "\nCó thể tăng Truy Phong Lôi Báo Lv110 lên thành Tái Long Hắc Tông Lv130"
    end
    if GetTimeFrameState(self.szEvolutionTimeFrame5) == 1 then
        szBaseTip = szBaseTip .. "\nCó thể tăng Tái Long Hắc Tông Lv130 lên thành Long Lân Phượng Vũ Lv150"
    end	
    return szBaseTip
end