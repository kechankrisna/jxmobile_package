
local tbItem = Item:GetClass("RecordStone");

function tbItem:GetUseSetting(nTemplateId, nItemId)
    local tbUseSetting = { szFirstName = "Dùng"};
    tbUseSetting.fnFirst = function ()
   		local tbStoneList = RecordStone:GetCurStoneList(me)     
        for i,nStoneId in ipairs(tbStoneList) do
            if nStoneId == nTemplateId then
                me.CenterMsg("Đã có Đá Khắc Chữ này")
                return
            end
        end

   		if #tbStoneList < RecordStone.MAX_RECORD_STONE_NUM then
   			RecordStone:DoRequestRecord(nTemplateId, #tbStoneList  +1)
   		else
   			Ui:OpenWindow("InscriptionChangePanel", nTemplateId) 
   		end
   		Ui:CloseWindow("ItemTips")
    end;

    return tbUseSetting;        
end