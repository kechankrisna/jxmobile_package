Require("CommonScript/Item/XiuLian.lua");

local tbItem = Item:GetClass("XiuLianZhu");
function tbItem:OnUse(pItem)
    local tbDef = XiuLian.tbDef;
    local bRet = XiuLian:CanBuyXiuLianDan(me);
    if bRet then
        me.CallClientScript("Ui:CloseWindow", "ItemTips");
        local nCount, tbDanItem = me.GetItemCountInBags(tbDef.nXiuLianDanID);
        if nCount > 0 and tbDanItem and tbDanItem[1] then
            me.CallClientScript("Ui:OpenWindow", "ItemTips", "Item", tbDanItem[1].dwId, tbDef.nXiuLianDanID);
        else
            me.CallClientScript("Ui:OpenWindow", "CommonShop", "Treasure", "tabAllShop", tbDef.nXiuLianDanID);
        end
    else
        me.CallClientScript("Ui:OpenWindow", "FieldPracticePanel");
    end
end

function tbItem:GetTip(pItem)
    local tbDan = Item:GetClass("XiuLianDan");
    local szMsg = "";
    local nCount = tbDan:GetOpenResidueCount(me);
    local nResidueTime = XiuLian:GetXiuLianResidueTime(me);
    local nMaxCount = tbDan:GetXiuLianMaxTime(me);
    szMsg = string.format("Thời gian tích lũy tu luyện còn: [FFFE0D]%s[-]\nTích lũy có thể dùng Tu Luyện Đơn: [FFFE0D]%s/%d lần[-]", Lib:TimeDesc(nResidueTime), nCount, nMaxCount);
    return szMsg;
end

function tbItem:GetUseSetting(nTemplateId, nItemId)
    local tbDef = XiuLian.tbDef;
    local tbOpt = {szFirstName = "Dùng", fnFirst = "UseItem"};
    local bRet = XiuLian:CanBuyXiuLianDan(me);
    if bRet then
        tbOpt.szFirstName = "Mua Tu Luyện Đơn";
        local nCount = me.GetItemCountInBags(tbDef.nXiuLianDanID);
        if nCount > 0 then
            tbOpt.szFirstName = "Sử dụng Tu Luyện Đơn";
        end
    end

    return tbOpt;
end