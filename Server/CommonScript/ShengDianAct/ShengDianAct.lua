ShengDianAct.MAP_ID = 7002

ShengDianAct.nZLY = -1
ShengDianAct.nLGX = -2
ShengDianAct.tbFakePlayer = {
    [ShengDianAct.nZLY] = {
        dwID = ShengDianAct.nZLY,
        nFaction = 14,
        nPortrait = 212,
        dwKinId = 0,
        szName = "Triệu Ân Đồng",
        szAccount = "",
        nHonorLevel = 5,
        nHouseState = 0, 
        nMarketStallLimit = 0,
        nLastOnlineTime = 0,
        nBanEndTime = 0,
        nVipLevel = 18,
        nState = 2,
        nNamePrefix = 10,
        nHeadBg = 39,
        nChatBg = 40,
    };
    [ShengDianAct.nLGX] = {
        dwID = ShengDianAct.nLGX,
        nFaction = 13,
        nPortrait = 213,
        dwKinId = 0,
        szName = "Lâm Triều Hoa",
        szAccount = "",
        nHonorLevel = 5,
        nHouseState = 0, 
        nMarketStallLimit = 0,
        nLastOnlineTime = 0,
        nBanEndTime = 0,
        nVipLevel = 18,
        nState = 2,
        nNamePrefix = 10,
        nHeadBg = 39,
        nChatBg = 40,
    };
}
ShengDianAct.tbVoice = {
    {"Setting/Sound/jhsd_zly.voice", "29/10, Giang Hồ Thịnh Điển-Võ Lâm Truyền Kỳ Mobile sẽ thông báo nội dung nổi bật 2018, hãy cùng đến tham gia!", 11000},
    {"Setting/Sound/gc_lgx.voice", "Võ Lâm Truyền Kỳ Mobile Mới sắp ra mắt! Hãy mau tải để nhận quà lớn!", 13000},
    {"Setting/Sound/xnh_lgx.voice", "Xin chào! Năm mới lại đến, Lâm Triều Hoa chúc đại hiệp năm mới vui vẻ!", 11100},
    {"Setting/Sound/xnh_zly.voice", "Triệu Ân Đồng chúc thiếu hiệp năm mới vui vẻ, may mắn, vạn sự như ý!", 12830},
    {"Setting/Sound/dncy_zly.voice", "Hôm nay là mùng 1, đại hiệp đã giành lì xì chưa? Hãy vào Võ Lâm Truyền Kỳ Mobile để giành lì xì hậu hĩnh!", 14580},
}
ShengDianAct.tbContent = {
}

function ShengDianAct:FormatContent(content)
    if not content then
        return
    end

    if type(content) == "number" then
        content = self.tbContent[content]
    end
    if Lib:IsEmptyStr(content) then
        content = nil
    end
    return content
end

function ShengDianAct:CheckMessageParam(nChannelType, nID, content, nVoiceId)
    if nChannelType ~= ChatMgr.ChannelType.Private and nChannelType ~= ChatMgr.ChannelType.Public then
        return false, "Chỉ có thể gửi ở kênh Thế Giới hoặc Chat Riêng"
    end

    if nID ~= self.nLGX and nID ~= self.nZLY then
        return false, "Không tìm thấy đại diện"
    end

    content = self:FormatContent(content)
    if not content and not nVoiceId then
        return false, "Không có nội dung và voice"
    end
    if content then
        return true
    end

    if nVoiceId then
        local tbVoiceInfo = self.tbVoice[nVoiceId]
        if not tbVoiceInfo then
            return false, "Nội dung voice bị lỗi"
        end
        return true
    end
    return false, "Tham số nội dung bị lỗi"
end