Require("CommonScript/Item/XiuLian.lua");
local tbDef = XiuLian.tbDef;

local tbItem = Item:GetClass("XiuLianDan");
tbItem.nExtAddResiduTime = 1;
tbItem.nSaveGroupID = 92;
tbItem.nSaveCount   = 1;
tbItem.nSaveTime    = 2;
tbItem.nSaveVersion = 3;

tbItem.szTimeUpdateTime = "4:00"; --每天更新的时间
tbItem.nMaxAddOpenCount = 3;

tbItem.tbVipExtCount = --VIP每天多少次
{
    {nMin = 0; nMax = 13, nCount = 1};
    {nMin = 14; nMax = 30, nCount = 2};
};

tbItem.tbShowTip = --显示Tip
{
    {
        nMin = 0,
        nMax = 10,
        szMsg = "Dùng tăng [FFFE0D]30 phút[-] luyện công Ngoài Thành của Tu Luyện Châu, [FFFE0D]4:00 hàng ngày[-] Tu Luyện Đơn hồi phục [FFFE0D]1 lần[-] sử dụng, tối đa tích lũy [FFFE0D]3 lần[-]";
    };

    {
        nMin = 11,
        nMax = 13,
        szMsg = "Dùng tăng [FFFE0D]30 phút[-] luyện công Ngoài Thành của Tu Luyện Châu, [FFFE0D]4:00 hàng ngày[-] Tu Luyện Đơn hồi phục [FFFE0D]1 lần[-] sử dụng, tối đa tích lũy [FFFE0D]3 lần[-].\nKiếm Hiệp 14 mỗi ngày tăng thêm [FFFE0D]1 lần[-]";
    };

    {
        nMin = 14,
        nMax = 30,
        szMsg = "Dùng tăng [FFFE0D]30 phút[-] luyện công Ngoài Thành của Tu Luyện Châu, [FFFE0D]4:00 hàng ngày[-] Tu Luyện Đơn hồi phục [FFFE0D]2 lần[-] sử dụng, tối đa tích lũy [FFFE0D]6 lần[-].";
    };
};

tbItem.tbShowShopTip = --商店显示
{
    {
        nMin = 0,
        nMax = 10,
        szMsg = "Dùng tăng [FFFE0D]30 phút [-] Luyện Công Ngoài Thành của Tu Luyện Châu, [FFFE0D]4 giờ[-] mỗi ngày Tu Luyện Đơn hồi phục [FFFE0D]1 lần[-] số lần sử dụng, tối đa có thể tích lũy [FFFE0D]3 lần[-]\n\n\n\n";
    };

    {
        nMin = 11,
        nMax = 13,
        szMsg = "Dùng tăng [FFFE0D]30 phút [-] Luyện Công Ngoài Thành của Tu Luyện Châu, [FFFE0D]4 giờ[-] mỗi ngày Tu Luyện Đơn hồi phục [FFFE0D]1 lần[-] số lần sử dụng, tối đa có thể tích lũy [FFFE0D]3 lần[-]\nTăng cấp Kiếm Hiệp 14 mỗi ngày có thể tăng số lần dùng [FFFE0D]1 lần[-]\n";
    };

    {
        nMin = 14,
        nMax = 30,
        szMsg = "Dùng tăng [FFFE0D]30 phút [-] Luyện Công Ngoài Thành của Tu Luyện Châu, [FFFE0D]4 giờ[-] mỗi ngày Tu Luyện Đơn hồi phục [FFFE0D]1 lần[-] số lần sử dụng, tối đa có thể tích lũy [FFFE0D]6 lần[-]\n\n\n\n";
    };
};

function tbItem:GetTip(pItem)
    local nCount = self:GetOpenResidueCount(me);
    local nMaxAddCount = self:GetXiuLianMaxTime(me)
    local szTip = string.format("Tích lũy lần dùng: %s/%d", nCount, nMaxAddCount);
    return szTip;
end

function tbItem:GetXiuLianMaxTime(pPlayer)
    local nPerAddCount = self:GetVIPCount(pPlayer);
    return tbItem.nMaxAddOpenCount * nPerAddCount;
end

function tbItem:GetIntrol(nTemplateId, nItemId)
    local szMsg = self:GetShowTipInfo(me, self.tbShowTip);
    if not szMsg then
        return;
    end

    return szMsg;
end

function tbItem:GetShowTipInfo(pPlayer, tbShowTip)
    local nVipLevel = pPlayer.GetVipLevel();
    for _, tbInfo in pairs(tbShowTip) do
        if tbInfo.nMin <= nVipLevel and nVipLevel <= tbInfo.nMax then
            return tbInfo.szMsg;
        end
    end
end

function tbItem:GetShopTip(pItem)
    local nVipLevel = me.GetVipLevel();
    local szTipShow = self:GetShowTipInfo(me, self.tbShowShopTip) or "";
    local nCount = self:GetOpenResidueCount(me);
    local szTip = string.format(szTipShow.."[FFFE0D]         Tích lũy lần dùng: %s[-]", nCount);
    return szTip;
end

function tbItem:GetVIPCount(pPlayer)
    local nVipLevel = pPlayer.GetVipLevel();
    for _, tbInfo in pairs(self.tbVipExtCount) do
        if tbInfo.nMin <= nVipLevel and nVipLevel <= tbInfo.nMax then
            return tbInfo.nCount;
        end
    end

    return 1;
end

function tbItem:GetOpenResidueCount(pPlayer)
    local nTime           = GetTime();
    local nLastTime       = pPlayer.GetUserValue(tbItem.nSaveGroupID, tbItem.nSaveTime);
    local nParseTodayTime = Lib:ParseTodayTime(tbItem.szTimeUpdateTime);
    local nUpdateDay      = Lib:GetLocalDay((nTime - nParseTodayTime));
    local nUpdateLastDay  = 0;
    if nLastTime == 0 then
        nUpdateLastDay = nUpdateDay - 1;
    else
        nUpdateLastDay  = Lib:GetLocalDay((nLastTime - nParseTodayTime));    
    end

    local nResidueCount = pPlayer.GetUserValue(tbItem.nSaveGroupID, tbItem.nSaveCount);
    local nAddDay = math.abs(nUpdateDay - nUpdateLastDay);
    local nVersion = pPlayer.GetUserValue(tbItem.nSaveGroupID, tbItem.nSaveVersion);
    if nVersion <= 0 then
        nResidueCount = 0;

        if MODULE_GAMESERVER then
            pPlayer.SetUserValue(tbItem.nSaveGroupID, tbItem.nSaveCount, 0);
        end
            
        if nAddDay ~= 0 then
            if MODULE_GAMESERVER then
                pPlayer.SetUserValue(tbItem.nSaveGroupID, tbItem.nSaveTime, 0);
            end
                
            nAddDay = 1;
        end

        if MODULE_GAMESERVER then
            pPlayer.SetUserValue(tbItem.nSaveGroupID, tbItem.nSaveVersion, 1);
        end    
    end
    
    if nAddDay == 0 then
        return nResidueCount;
    end

    local nPerAddCount = self:GetVIPCount(pPlayer);
    nResidueCount = nResidueCount + nAddDay * nPerAddCount;
    if nResidueCount <= 0 then
        nResidueCount = 1;
    end

    local nMaxAddCount = tbItem.nMaxAddOpenCount * nPerAddCount;
    nResidueCount = math.min(nResidueCount, nMaxAddCount);

    if MODULE_GAMESERVER then
        pPlayer.SetUserValue(tbItem.nSaveGroupID, tbItem.nSaveTime, nTime);
        pPlayer.SetUserValue(tbItem.nSaveGroupID, tbItem.nSaveCount, nResidueCount);
    end
    
    return nResidueCount;     
end

function tbItem:CheckXiuLianResiduTime(pPlayer, nAddResiduTime)
    local nResidueTime = XiuLian:GetXiuLianResidueTime(pPlayer);
    nResidueTime = nResidueTime + nAddResiduTime;
    if nResidueTime > tbDef.nMaxAddXiuLianTime then
        return false, "Thời gian tích lũy tu luyện đã đạt tối đa";
    end

    local nCount = self:GetOpenResidueCount(pPlayer);
    if nCount <= 0 then
        return false, "Số lần được dùng còn lại không đủ (4:00 ngày kế có thể dùng)";
    end

    return true, "";    
end

function tbItem:OnUse(it) 
    local nAddResiduTime = KItem.GetItemExtParam(it.dwTemplateId, self.nExtAddResiduTime);
    if nAddResiduTime <= 0 then
        Log("Error XiuLianDan AddResiduTime", nAddResiduTime);
        return;
    end

    local bRet, szMsg = self:CheckXiuLianResiduTime(me, nAddResiduTime);
    if not bRet then
        me.CenterMsg(szMsg);
        return;
    end

    local nCount = self:GetOpenResidueCount(me);
    nCount = nCount - 1;
    me.SetUserValue(tbItem.nSaveGroupID, tbItem.nSaveCount, nCount);

    XiuLian:AddXiuLianResiduTime(me, nAddResiduTime);
    me.CenterMsg(string.format("Thời gian tích lũy tu luyện tăng %s phút [FFFE0D](Tu Luyện Châu) [-] ", math.floor(nAddResiduTime / 60)));
    return 1;    
end