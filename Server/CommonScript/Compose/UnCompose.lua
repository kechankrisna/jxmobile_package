Compose.UnCompose = Compose.UnCompose or {};
local UnCompose = Compose.UnCompose 
function UnCompose:LoadSetting()
    UnCompose.MAX_TAR_COUNT = 3;
    self.tbSetting = LoadTabFile("Setting/Item/ItemCompose/UnCompose.tab", "dddddddddd", "SrcItem", {"SrcItem","TarItem1","TarItemCount1", "Bind1", "TarItem2","TarItemCount2", "Bind2", "TarItem3","TarItemCount3", "Bind3",});
end

UnCompose:LoadSetting()

function UnCompose:CanUnCompose(dwTemplateId)
    local tbInfo = self.tbSetting[dwTemplateId]
    if not tbInfo then
        return  false
    end
    return tbInfo
end

function UnCompose:UncomposeItem(pPlayer, nItemId)
    local pItem = pPlayer.GetItemInBag(nItemId)
   if not pItem then
        return
    end
   local tbInfo = self:CanUnCompose(pItem.dwTemplateId)
   if not tbInfo then
        return
    end
    if pPlayer.ConsumeItem(pItem, 1, Env.LogWay_Uncompose) ~= 1 then
        pPlayer.CenterMsg("Tiêu hao đạo cụ thất bại")
        return
    end
    local tbAward = {};
    for i=1,self.MAX_TAR_COUNT do
        if tbInfo["TarItem" .. i] ~= 0 then
            table.insert(tbAward, {"item", tbInfo["TarItem" .. i], tbInfo["TarItemCount" .. i], 0, tbInfo["Bind" .. i] == 1 })
        else
            break;
        end
    end
    pPlayer.SendAward(tbAward, nil,nil, Env.LogWay_Uncompose)
    pPlayer.CenterMsg("Tách thành công")
end

if not MODULE_GAMESERVER then
    function UnCompose:DoRequestUncompose(nItemId)
       local pItem = me.GetItemInBag(nItemId)
       if not pItem then
            return
        end
        local tbInfo = self:CanUnCompose(pItem.dwTemplateId)
        if not tbInfo then
            return
        end
        local fnYes = function ()
            RemoteServer.RequestUnComposeItem(nItemId)
        end
        local tbItemDesc = {};
        for i = 1, self.MAX_TAR_COUNT  do
            if tbInfo["TarItem" .. i] ~= 0 then
                local szName = KItem.GetItemShowInfo(tbInfo["TarItem" .. i])        
                table.insert(tbItemDesc, string.format("[ffff00]%s%s[-] * [ffff00]%d[-]", szName, tbInfo["Bind" .. i] == 1 and "(Phong)" or "",  tbInfo["TarItemCount" .. i]))
            else
                break;
            end
        end
        local szItemDesc = table.concat( tbItemDesc, ", ")
        me.MsgBox(string.format("Tách nhận %s, đồng ý?", szItemDesc), 
            {
                {"Đồng ý", fnYes },
                {"Hủy"}
            })
        
    end    
end