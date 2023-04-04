local tbItem = Item:GetClass("PlayerPortraitItem")

function tbItem:OnUse(it)
    local nMySex    = me.nSex;
    local nPortrait = KItem.GetItemExtParam(it.dwTemplateId, nMySex)
    if not nPortrait then
        Log("[PlayerPortraitItem Setting Err]", it.dwTemplateId)
        return
    end

    PlayerPortrait:AddPortrait(me, nPortrait)
    PlayerPortrait:ChangePortrait(me, nPortrait)
    if PlayerPortrait:HaveBigFace(nPortrait) then
        PlayerPortrait:ChangeBigFace(me, nPortrait)
    end
    me.CenterMsg("Đã nhận hình đại diện mới! Đã tự động cập nhật!")
    Log("[PlayerPortraitItem OnUse]", it.dwId, me.dwID, nPortrait)
    return 1
end


--不区分性别，全部给
local tbItem_NoSex = Item:GetClass("PlayerPortraitItem_NoSex")
function tbItem_NoSex:OnUse(it)
    local nChangePor
    for i = 1, 99 do
        local nPortrait = KItem.GetItemExtParam(it.dwTemplateId, i)
        if not nPortrait or nPortrait <= 0 then
            return 1
        end

        PlayerPortrait:AddPortrait(me, nPortrait)
        if not nChangePor and PlayerPortrait:CheckFaction(nPortrait, me.nFaction, me.nSex) then
            nChangePor = nPortrait
            PlayerPortrait:ChangePortrait(me, nPortrait)
            if PlayerPortrait:HaveBigFace(nPortrait) then
                PlayerPortrait:ChangeBigFace(me, nPortrait)
            end
            me.CenterMsg("Đại hiệp nhận được hình đại diện mới! Đã tự động đổi!")
        end
        Log("[PlayerPortraitItem_NoSex OnUse]", it.dwId, me.dwID, nPortrait)
    end
end