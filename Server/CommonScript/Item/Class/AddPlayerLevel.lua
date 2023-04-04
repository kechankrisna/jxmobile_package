local tbItem = Item:GetClass("AddPlayerLevel")
tbItem.nExtLevel = 1
tbItem.nExtPrice = 2
tbItem.tbVipExtLevel = {
--vip等级，对应给玩家加的等级，从大到小排序
    {18, 4},
    {15, 3},
    {12, 2},
    {9, 1},
}

function tbItem:OnUse(it)
    local nLevel = KItem.GetItemExtParam(it.dwTemplateId, self.nExtLevel)
    local nMaxLevel = GetMaxLevel()
    if nLevel > nMaxLevel then
        me.CenterMsg("Cấp này chưa mở")
        return
    end

    local nFinalLevel = self:GetFinalLevel(me.GetVipLevel(), it.dwTemplateId)
    if me.nLevel >= nFinalLevel then
        me.CenterMsg("Đại hiệp đã đạt cấp này")
        return
    end

    nFinalLevel = nFinalLevel - me.nLevel
    me.AddLevel(nFinalLevel)
    Log("AddPlayerLevel Item AddLevel Success", me.dwID, me.nLevel, nLevel, nFinalLevel + me.nLevel)
    return 1
end

function tbItem:GetFinalLevel(nVipLevel, nItemTID)
    local nLevel = KItem.GetItemExtParam(nItemTID, self.nExtLevel)
    local nExtLevel = 0
    for _, tbInfo in ipairs(self.tbVipExtLevel) do
        if nVipLevel >= tbInfo[1] then
            nExtLevel = tbInfo[2]
            break
        end
    end

    local nDayExt = DirectLevelUp:GetItemDayExtLv(nItemTID)
    return nLevel + nExtLevel + nDayExt
end

function tbItem:GetIntrol(dwTemplateId)
    local tbBase = KItem.GetItemBaseProp(dwTemplateId)
    local szBaseTip = tbBase.szIntro
    local nFinalLevel = self:GetFinalLevel(me.GetVipLevel(), dwTemplateId)
    szBaseTip = string.format(szBaseTip, nFinalLevel)

    local nVipLevel = me.GetVipLevel()
    local nCurLevelUp = 0
    for _, tbInfo in ipairs(self.tbVipExtLevel) do
        if nVipLevel >= tbInfo[1] then
            szBaseTip = string.format("%s\n\nKiếm Hiệp hiện tại tăng thêm [FFFE0D]%d[-] cấp", szBaseTip, tbInfo[2])
            nCurLevelUp = tbInfo[2]
            break
        end
    end
    for i = #self.tbVipExtLevel, 1, -1 do
        if nVipLevel < self.tbVipExtLevel[i][1] then
            szBaseTip = string.format("%s %s đạt Kiếm Hiệp %d, sẽ tăng thêm [FFFE0D]%d[-] cấp", szBaseTip, nCurLevelUp > 0 and "\n" or "\n\n", self.tbVipExtLevel[i][1], self.tbVipExtLevel[i][2] - nCurLevelUp)
            break
        end
    end
    local _, nNextAppLv = DirectLevelUp:GetItemDayExtLv(dwTemplateId, true)
    if nNextAppLv then
        szBaseTip = string.format("%s\nCòn [FFFE0D]%d[-] ngày tăng thêm [FFFE0D]1[-] cấp", szBaseTip, nNextAppLv)
    end
    return szBaseTip
end

function tbItem:GetUseSetting(nItemTemplateId, nItemId)
    return {szFirstName = "Dùng", fnFirst = "UseItem"};
end

function tbItem:OnClientUse(it)
    local fnUse = function ()
        RemoteServer.UseItem(it.dwId)
    end
    me.MsgBox("Mỗi người chỉ được dùng 1 Tăng Cấp Đơn, dùng chứ?", {{"Dùng", fnUse}, {"Hủy"}})
    return 1
end