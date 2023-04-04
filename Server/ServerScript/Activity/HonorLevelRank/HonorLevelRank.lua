
local tbAct = Activity:GetClass("HonorLevelRank");

tbAct.tbTimerTrigger = 
{
};

tbAct.tbTrigger = 
{
    Init = {},
    Start = {},
    End = {},
};

tbAct.tbHonorLevelType =
{
    [1] = 
    {
        nHonorLevel = 6; --头衔的等级
        tbAllRankAward = 
        {
            {nMinRank = 1, nMaxRank = 1, tbAward = {{"item", 6015, 1}, {"item", 1126, 1}} };
            {nMinRank = 2, nMaxRank = 10, tbAward = {{"item", 6017, 1}, {"item", 1616, 1}} };
        };
        tbMailInfo =
        {
            szTitle = "Tiềm Long danh hiệu xông bảng ban thưởng";
            szContent =
[[Chúc mừng thiếu hiệp! Tại Tiềm Long danh hiệu xông bảng trong hoạt động biểu hiện ưu dị, hiện đã thu hoạch được thứ [FFFE0D]%s[-] Tên ban thưởng, mời kiểm tra và nhận.
Nhìn thiếu hiệp tiếp tục cố gắng, sớm ngày danh chấn giang hồ!
]];
        };
        tbUpdateNewInformation =
        {
            szTitle = "Tiềm Long danh hiệu xông bảng";
            szContent =
[[  Thời gian hoạt động: [c8ff00]%s Năm %s Nguyệt %s Nhật 0 Điểm -%s Năm %s Nguyệt %s Nhật %s Điểm [-]
    Chư vị hiệp sĩ:
    Bây giờ giang hồ gió nổi mây phun, các lộ hào hiệp tổng hợp nơi này. Hiện đẩy ra Tiềm Long danh hiệu xông bảng hoạt động, đối ưu tiên đạt tới [aa62fc] Tiềm Long danh hiệu [-] Kiệt xuất hào hiệp cho phong phú ban thưởng.
    Trong đó đệ nhất danh tướng cho [ff578c] [url=openwnd: Xưng hào · Đệ nhất Tiềm Long, ItemTips, "Item", nil, 6015] [-], [ff8f06] [url=openwnd: Ngũ giai hi hữu vũ khí, ItemTips,  "Item", nil, 1126, me.nFaction] [-] Phong phú ban thưởng;
    Thứ hai đến mười tên đem cho [aa62fc] [url=openwnd: Xưng hào · Thập đại Tiềm Long, ItemTips, "Item", nil, 6017] [-], [aa62fc] [url=openwnd: Ngũ giai truyền thừa vũ khí, ItemTips,  "Item", nil, 1616, me.nFaction] [-] Phong phú ban thưởng.
    Nhìn mọi người tích cực tham gia, dũng đoạt vinh hạnh đặc biệt!
    Trở xuống là trước mắt xông bảng danh sách:
%s
]];
        };

    };

    [2] = 
    {
        nHonorLevel = 8; --头衔的等级
        tbAllRankAward = 
        {
            {nMinRank = 1, nMaxRank = 1, tbAward = {{"item", 6016, 1}, {"item", 4282, 1}} };
            {nMinRank = 2, nMaxRank = 10, tbAward = {{"item", 6018, 1}, {"item", 4289, 1}} };
        };
        tbMailInfo =
        {
            szTitle = "Ỷ Thiên danh hiệu xông bảng ban thưởng";
            szContent =
[[Chúc mừng thiếu hiệp! Tại Ỷ Thiên danh hiệu xông bảng trong hoạt động biểu hiện ưu dị, hiện đã thu hoạch được thứ [FFFE0D]%s[-] Tên ban thưởng, mời kiểm tra và nhận.
Nhìn thiếu hiệp tiếp tục cố gắng, sớm ngày danh chấn giang hồ!
]];
        };
        tbUpdateNewInformation =
        {
            szTitle = "Ỷ Thiên danh hiệu xông bảng";
            szContent =
[[  Thời gian hoạt động: [c8ff00]%s Năm %s Nguyệt %s Nhật 0 Điểm -%s Năm %s Nguyệt %s Nhật %s Điểm [-]
    Chư vị hiệp sĩ:
    Bây giờ giang hồ phân tranh không ngừng, các lộ hào hiệp tiến bộ càng là tiến triển cực nhanh. Hiện đẩy ra Ỷ Thiên danh hiệu xông bảng hoạt động, đối ưu tiên đạt tới [ff578c] Ỷ Thiên danh hiệu [-] Kiệt xuất hào hiệp cho phong phú ban thưởng.
    Trong đó đệ nhất danh tướng cho [ff578c] [url=openwnd: Xưng hào · Đệ nhất Ỷ Thiên, ItemTips, "Item", nil, 6016] [-], [ff8f06] [url=openwnd:【 Hi hữu 】 Thái hư chi linh, ItemTips,  "Item", nil, 4282] [-] Phong phú ban thưởng;
    Thứ hai đến mười tên đem cho [aa62fc] [url=openwnd: Xưng hào · Thập đại Ỷ Thiên, ItemTips, "Item", nil, 6018] [-], [aa62fc] [url=openwnd:【 Truyền thừa 】 Thái hư chi linh, ItemTips,  "Item", nil, 4289] [-] Phong phú ban thưởng.
    Nhìn mọi người tích cực tham gia, dũng đoạt vinh hạnh đặc biệt!
    Trở xuống là trước mắt xông bảng danh sách:
%s
]];
        };
    };
}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
        self:UpdateNewInformation();
    elseif szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_HonorLevel", "OnHonorLevel");
    end

    local nType = self:GetHonorLevelType();
    Log("HonorLevelRank OnTrigger:", szTrigger, nType or "-");
end

function tbAct:GetHonorLevelType()
    if not self.tbParam then
        return;
    end

    if not self.tbParam[1] then
        return;
    end

    local nType = tonumber(self.tbParam[1]);
    return nType;
end

function tbAct:GetRankAward(tbTypeInfo, nRank)
    for _, tbInfo in pairs(tbTypeInfo.tbAllRankAward) do
        if tbInfo.nMinRank <= nRank and nRank <= tbInfo.nMaxRank then
            return tbInfo;
        end    
    end
end

function tbAct:CheckPlayerHonorLevel(pPlayer, nHonorLevel)
    local nType = self:GetHonorLevelType();
    if not nType then
        return false;
    end

    local tbHonorLevelInfo = Player.tbHonorLevel:GetHonorLevelInfo(nHonorLevel);
    if not tbHonorLevelInfo then
        return false;
    end    

    local tbTypeInfo = tbAct.tbHonorLevelType[nType];
    if not tbTypeInfo then
        return false;
    end

    if tbTypeInfo.nHonorLevel ~= nHonorLevel then
        return false;
    end

    local tbSaveData = self:GetSaveHonorLevel(nType);
    if tbSaveData.tbPlayer[pPlayer.dwID] then
        return false;
    end

    local nCurRank = tbSaveData.nRank + 1;
    local tbRankAward = self:GetRankAward(tbTypeInfo, nCurRank);
    if not tbRankAward then
        return false;
    end

    return true, tbRankAward, nCurRank, nType;    
end

function tbAct:OnHonorLevel(pPlayer, nHonorLevel)
    local bRet, tbRankAward, nRank, nType = self:CheckPlayerHonorLevel(pPlayer, nHonorLevel);
    if not bRet then
        return;
    end

    local tbTypeInfo = tbAct.tbHonorLevelType[nType];
    local tbSaveData = self:GetSaveHonorLevel(nType);
    tbSaveData.tbPlayer[pPlayer.dwID] = nRank;
    tbSaveData.nRank = nRank;

    local szKey = self:GetSaveKey(nType);
    ScriptData:AddModifyFlag(szKey);

    local tbMail =
    {
        To = pPlayer.dwID,
        Title = tbTypeInfo.tbMailInfo.szTitle,
        Text = string.format(tbTypeInfo.tbMailInfo.szContent, nRank);
        nLogReazon = Env.LogWay_ActHonorLevelRank;
        tbAttach = tbRankAward.tbAward,
    }

    Mail:SendSystemMail(tbMail);
    self:UpdateNewInformation();
    Log("HonorLevelRank OnHonorLevel", pPlayer.dwID, nHonorLevel, nType, nRank);
end

function tbAct:GetSaveKey(nType)
    local szKey = string.format("ActHonorLevelRank:%s", nType);
    return szKey;
end

function tbAct:GetSaveHonorLevel(nType)
    local szKey = self:GetSaveKey(nType);
    ScriptData:AddDef(szKey);
    local tbSaveHonor = ScriptData:GetValue(szKey);
    if not tbSaveHonor.nRank then
        tbSaveHonor.nRank = 0;
        tbSaveHonor.tbPlayer = {};
    end

    return tbSaveHonor;
end

function tbAct:UpdateNewInformation()
    local nType = self:GetHonorLevelType();
    if not nType then
        return;
    end

    local tbTypeInfo = tbAct.tbHonorLevelType[nType];
    if not tbTypeInfo then
        return;
    end

    local szPlayerRank = "";
    local tbSaveData = self:GetSaveHonorLevel(nType);
    local tbAllShowInfo = {};
    for nPlayerID, nRank in pairs(tbSaveData.tbPlayer) do
        local pRole = KPlayer.GetRoleStayInfo(nPlayerID)
        local szName = "-";
        if pRole then
            szName = pRole.szName;
        end

        local tbPlayerInfo = {nPlayerID = nPlayerID, szName = szName, nRank = nRank};
        tbAllShowInfo[nRank] = tbPlayerInfo;
    end
    
    for nI = 1, 10 do
        local szExt = "  ";
        if nI == 10 then
            szExt = "";
        end

        local tbInfo = tbAllShowInfo[nI];
        if tbInfo then
            szPlayerRank = szPlayerRank .. string.format("    Thứ [FFFE0D]%s[-]Tên: %s[FFFE0D][url=viewrole:%s,%s][-]\n", tbInfo.nRank, szExt, tbInfo.szName, tbInfo.nPlayerID);
        else
            szPlayerRank = szPlayerRank .. string.format("    Thứ [FFFE0D]%s[-]Tên: %s Để trống chỗ\n", nI, szExt);    
        end    
    end

    local nStartTime, nEndTime = self:GetOpenTimeInfo();
    local tbTime1 = os.date("*t", nStartTime)
    local tbTime2 = os.date("*t", nEndTime);
    local szContent = string.format(tbTypeInfo.tbUpdateNewInformation.szContent, tbTime1.year, tbTime1.month, tbTime1.day, tbTime2.year, tbTime2.month, tbTime2.day, tbTime2.hour, szPlayerRank);
    NewInformation:AddInfomation("ActHonorLevelRank_NewInfo", nEndTime, {szContent}, {szTitle = tbTypeInfo.tbUpdateNewInformation.szTitle, nReqLevel = 1});
end