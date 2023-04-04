local tbItem = Item:GetClass("DiscountCoupon")
tbItem.EXCHANGE_ITEM  = 1
tbItem.EXCHANGE_PRICE = 2
tbItem.EXCHANGE_DIS_PRICE = 3

function tbItem:OnUse(pItem, nCount)
    nCount = nCount or 1
    if nCount <= 0 then
        return
    end
    if pItem.nCount < nCount then
        me.CenterMsg("Đạo cụ không đủ")
        return
    end

    local nPrice  = KItem.GetItemExtParam(pItem.dwTemplateId, self.EXCHANGE_DIS_PRICE)
    local nItemId = pItem.dwId
    me.CostGold(nPrice*nCount, Env.LogWay_DiscountCoupon, nil,
        function (nPlayerId, bSuccess)
            local bRet, szMsg = self:OnCostCallback(nPlayerId, bSuccess, nItemId, nCount)
            return bRet, szMsg
        end)
end

function tbItem:OnCostCallback(nPlayerId, bSuccess, nItemId, nCount)
    if not bSuccess then
        return false, "Thanh toán thất bại"
    end

    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
        return false, "Mất kết nối, hãy thử lại!"
    end

    local pItem = KItem.GetItemObj(nItemId)
    if not pItem or pItem.nCount < nCount then
        return false, "Đạo cụ không đủ"
    end

    local nRet = pPlayer.ConsumeItem(pItem, nCount, Env.LogWay_DiscountCoupon)
    if nRet ~= nCount then
        Log("DiscountCoupon OnCostCallback Fail", nPlayerId, nItemId, nCount, nRet)
        return false, "Dùng đạo cụ thất bại"
    end

    local nItem = KItem.GetItemExtParam(pItem.dwTemplateId, self.EXCHANGE_ITEM)
    pPlayer.SendAward({{"Item", nItem, nCount}}, true, false, Env.LogWay_DiscountCoupon)
    Log("DiscountCoupon OnCostCallback:", nPlayerId, nCount)
    return true
end

function tbItem:OnClientUse(pItem)
    if pItem then
        local nItem = KItem.GetItemExtParam(pItem.dwTemplateId, self.EXCHANGE_ITEM)
        local nPrice = KItem.GetItemExtParam(pItem.dwTemplateId, self.EXCHANGE_PRICE)
        local nDisPrice = KItem.GetItemExtParam(pItem.dwTemplateId, self.EXCHANGE_DIS_PRICE)
        Ui:OpenWindow("DiscountCouponPanel", pItem, nItem, nPrice, nDisPrice)
        Ui:CloseWindow("ItemTips")
    end
    return 1
end