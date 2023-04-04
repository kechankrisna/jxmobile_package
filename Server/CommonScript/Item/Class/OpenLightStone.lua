
Require("CommonScript/Item/OpenLight.lua");

local tbItem = Item:GetClass("OpenLightStone");

function tbItem:OnUse(pItem) 
    local bRet, szMsg, bMsgBox = OpenLight:CheckUseLightType(me, pItem.dwId);
    if not bRet then
        me.CenterMsg(szMsg);
        return;
    end    

    if bMsgBox then
        local tbOpt = 
        {
            {"Xác nhận", self.OpenLightItem, self, pItem.dwId},
            {"Hủy"}
        };

        me.MsgBox(szMsg, tbOpt);
        return;
    end 

    OpenLight:OpenLightItem(me, pItem.dwId);   
end

function tbItem:OpenLightItem(nItemID)
    OpenLight:OpenLightItem(me, nItemID);
end

function tbItem:GetTip(pItem)
    local tbAttibMsg = OpenLight:GetLightAttribMsg(pItem.dwTemplateId) or {};
    local szMsg = "";
    for _, tbAttrib in ipairs(tbAttibMsg) do
        szMsg = szMsg .. string.format("%s\n", tbAttrib[1]);
    end

    local tbLightInfo = OpenLight:GetLightSetting(pItem.dwTemplateId);   
    szMsg = szMsg..string.format("Hạn: %s", Lib:TimeDesc(tbLightInfo.TimeOut));
    return szMsg;
end


function tbItem:GetUseSetting(nTemplateId, nItemId)
    if InDifferBattle.bRegistNotofy then
        local tbUseSetting = { szSecondName = "Dùng"};
        if InDifferBattle:IsJueDiVersion() then
            tbUseSetting.szFirstName = "Bỏ"
            tbUseSetting.fnFirst = function ()
                RemoteServer.InDifferBattleRequestInst("TrowItem", nItemId)
            end
        else
            tbUseSetting.szFirstName = "Bán"
            tbUseSetting.fnFirst = "SellItem"
        end
        
        tbUseSetting.fnSecond = function ()
            InDifferBattle:UseItem(nItemId)
        end;

        return tbUseSetting;        
    end

    return { szFirstName = "Dùng",  fnFirst = "UseItem"};
end


function tbItem:IsUsableItem(pPlayer, dwTemplateId)
    --如果已经附魔了或者是包里有 同类型或者更高级的，则对应的就是无用的
    local tbSetting = OpenLight:GetLightSetting(dwTemplateId)
    local LightLevel = tbSetting.LightLevel
    local nCurLightStoneId = pPlayer.GetUserValue(OpenLight.nSaveGroupID, OpenLight.nSaveLightID);
    if nCurLightStoneId > 0 then
        local tbCurInfo = OpenLight:GetLightSetting(nCurLightStoneId)
        if tbCurInfo.LightLevel >= LightLevel then
            return false
        end
    end
    local tbItems = pPlayer.FindItemInBag("OpenLightStone")
    for i, pItem in ipairs(tbItems) do
        local tbCurInfo = OpenLight:GetLightSetting(pItem.dwTemplateId)
        if tbCurInfo.LightLevel >= LightLevel then
            return false
        end
    end
    
    return true;
end