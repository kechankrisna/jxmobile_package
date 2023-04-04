
local ACT_CLASS = "HouseDefend";
local tbActivity = Activity:GetClass(ACT_CLASS);

tbActivity.tbTimerTrigger = 
{
}

tbActivity.tbTrigger = 
{
	Init = 
	{
	},
    Start = 
    {
    },
    End = 
    {
    },
}

tbActivity.tbDailyAward =
{
    [1] = {{"Item", 5420, 1}},
    [2] = {{"Item", 5420, 1}},
    [3] = {{"Item", 5420, 1}},
    [4] = {{"Item", 5420, 1}},
    [5] = {{"Item", 5421, 1}},
};
tbActivity.tbJoinAward = 
{   
    {"Item", 4818, 1},
};
tbActivity.tbFubenAward =
{
    {"Item", 5430, 1},
};

tbActivity.MIN_LEVEL = 60;
tbActivity.TIME_CLEAR = 4 * 3600;
tbActivity.USERGROUP = 137;
tbActivity.USERKEY_FUBENTIME = 1; 
tbActivity.USERKEY_ACT_TIME = 2;
tbActivity.USERKEY_AWARD_COUNT = 3;
tbActivity.nFubenMapTemplateId = 4007;
tbActivity.MAX_AWARD_COUNT = 10;

tbActivity.tbHouseFuben = tbActivity.tbHouseFuben or {};

function tbActivity:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_EverydayTarget_Award", "OnGainEverydayAward");
        Activity:RegisterPlayerEvent(self, "Act_HouseDefend_OpenFuben", "OpenFuben");
        Activity:RegisterPlayerEvent(self, "Act_HouseDefend_EnterFuben", "EnterFuben");
        Activity:RegisterPlayerEvent(self, "Act_HouseDefend_FubenFinished", "OnFubenFinished");

        Activity:RegisterGlobalEvent(self, "Act_HouseDefend_FubenClose", "OnFubenClose");

        self:SendNews();
    end
end

function tbActivity:SendNews()
    local _, nEndTime = self:GetOpenTimeInfo();
    NewInformation:AddInfomation("ActHouseDefend", nEndTime, 
        {
        [[Thời gian hoạt động: [FFFE0D]2017 Năm 7 Nguyệt 13 Nhật 04: 00-2017 Năm 7 Nguyệt 24 Nhật 3: 59[-]\n\n[FFFE0D] Mới lạ tiểu trúc, chân tình thường trú [-]\n    Chư vị hiệp sĩ, gần đây nghe nói Dương đại hiệp thiếu hiệp cùng Chân nhi nữ hiệp lại lại dắt tay cùng xông vào giang hồ, chỉ là hai người ghét ác như cừu, hành hiệp trượng nghĩa lúc không khỏi đắc tội không ít võ lâm ác đồ, những này ác đảng nếu là quang minh chính đại đến đây khiêu chiến, hai vị hiệp lữ tất nhiên là không sợ, nhưng lại sinh những này hèn hạ người, sợ rằng sẽ sử dụng một chút hạ lưu mánh khoé. Cho nên võ lâm minh đặc biệt mời chư vị hiệp sĩ, trợ Dương đại hiệp cùng Triệu nữ hiệp một chút sức lực. Tham dự phương thức như sau: \n\n    Hoạt động trong lúc đó, hoàn thành [FFFE0D] Mỗi ngày mục tiêu [-] Liền có thể thu hoạch được hợp thành vật liệu, mỗi ngày hoàn thành [FFFE0D]20, 40, 60, 80[-] Lúc, đồng đều đem thu hoạch được [aa62fc][url=openwnd: U ám con thỏ chụp đèn, ItemTips, "Item", nil, 5420][-], hoàn thành [FFFE0D]100 Điểm [-] Lúc đem thu hoạch được [aa62fc][url=openwnd: Chập chờn con thỏ bấc đèn, ItemTips, "Item", nil, 5421][-], tập hợp đủ sau có cơ hội thu hoạch được [ff8f06][url=openwnd: Thư mời · Dương đại hiệp, ItemTips, "Item", nil, 5423][-] [ff8f06][url=openwnd: Thư mời · Chân nhi, ItemTips, "Item", nil, 5424][-] Hoặc là một phần [FFFE0D] Ngẫu nhiên ban thưởng [-].\n\n    Như hiệp sĩ may mắn đạt được thư mời, lại có gia viên, nhưng mời Dương đại hiệp thiếu hiệp / Chân nhi nữ hiệp đến chính mình quê hương làm khách, đã gia nhập bang phái hiệp sĩ, còn có thể cùng bọn hắn đối thoại mở ra mới lạ tiểu trúc đoạt lại chiến, cùng [FFFE0D] Bang phái thành viên [-] Cùng nhau nói minh bọn hắn đoạt lại gia viên, quy tắc như sau: \n\n1, mới lạ tiểu trúc đoạt lại chiến mở ra sau, [FFFE0D] Mở ra người [-] Đem thu hoạch được một phần ban thưởng, chỗ bang phái thành viên đồng đều có thể vào khiêu chiến, đánh bại cuối cùng đầu mục sau [FFFE0D] Tất cả trong địa đồ hiệp sĩ đồng đều đem thu hoạch được một phần ban thưởng [-], hoạt động trong lúc đó, mỗi cái hiệp sĩ nhiều nhất chỉ có thể thu hoạch được [FFFE0D]10 Lần ban thưởng [-], nhưng vẫn nhưng tiến về trợ giúp cái khác hiệp sĩ đoạt lại mới lạ tiểu trúc \n2, mở ra mới lạ tiểu trúc đoạt lại chiến sau đem gửi đi bang phái thông cáo, [FFFE0D] Cửa vào tiếp tục 1 Giờ sau quan bế [-], nhất định phải xác định có đầy đủ bang phái thành viên cùng ngươi cùng nhau khiêu chiến lại mở ra!\n3, thư mời thời hạn có hiệu lực đến ngày kế tiếp [FFFE0D] Lăng Thần 4 Điểm [-], nhưng tuyệt đối không nên quên sử dụng ờ \n4, Dương đại hiệp thiếu hiệp / Chân nhi nữ hiệp cũng sẽ tại ngày kế tiếp lăng Thần 4 Nhật rời đi, đừng quên kịp thời mở ra đoạt lại chiến \n5, hiệp sĩ mở ra tranh đoạt chiến sau, như thay đổi bang phái, mới bang phái thành viên không cách nào hiệp trợ ngươi tiến hành hoạt động ]]
        }, 
        {
            szTitle = "Mới lạ tiểu trúc tình trường trú", 
            nReqLevel = 60
        });
end

function tbActivity:OnGainEverydayAward(pPlayer, nAwardIdx)
    if pPlayer.nLevel < tbActivity.MIN_LEVEL then
        return;
    end

    local tbAward = tbActivity.tbDailyAward[nAwardIdx];
    if not tbAward then
        return;
    end

    local nEndTime = Activity:GetActEndTime(self.szKeyName);
    for _, tbInfo in ipairs(tbAward) do
        if tbInfo[1] == "Item" then
            tbInfo[4] = nEndTime;
        end
    end

    pPlayer.SendAward(tbAward, true, true, Env.LogWay_HouseDefend);

    Log("[HouseDefend] player gain daily award:", pPlayer.dwID, pPlayer.szName, nAwardIdx);
end

function tbActivity:CanOpenFuben(pPlayer)
    if not Env:CheckSystemSwitch(pPlayer, Env.SW_HouseDefend) then
        return false, "Hoạt động tạm thời quan bế, xin đợi thử lại";
    end

    if not House:IsInOwnHouse(pPlayer) then
        return false, "Chỉ có thể ở gia viên của mình mở ra phó bản a";
    end

    if pPlayer.nLevel < tbActivity.MIN_LEVEL then
        return false, string.format("Cấp bậc chưa đủ %d Cấp", tbActivity.MIN_LEVEL);
    end

    local nOpenFubenTime = pPlayer.GetUserValue(tbActivity.USERGROUP, tbActivity.USERKEY_FUBENTIME);
    if nOpenFubenTime ~= 0 then
        local nCurDay = Lib:GetLocalDay(GetTime() - tbActivity.TIME_CLEAR);
        local nLastDay = Lib:GetLocalDay(nOpenFubenTime - tbActivity.TIME_CLEAR);
        if nCurDay == nLastDay then
            return false, "Ngươi đã mở ra phó bản";
        end
    end

    if pPlayer.dwKinId == 0 then
        return false, "Ngươi còn không có bang phái! Đi trước gia nhập một bang phái đi";
    end

    local dwPlayerId = pPlayer.dwID;
    if tbActivity.tbHouseFuben[dwPlayerId] then
        return false, "Ngươi còn có phó bản không hoàn thành!";
    end

    return true;
end

function tbActivity:OpenFuben(pPlayer, bConfirm)
    local bRet, szMsg = self:CanOpenFuben(pPlayer);
    if not bRet then
        pPlayer.CenterMsg(szMsg);
        return;
    end

    if not bConfirm then
        pPlayer.MsgBox("Mới lạ tiểu trúc đoạt lại chiến mở ra sau [FFFE0D] Tiếp tục 1 Giờ [-], trong đó tặc phỉ đông đảo, mời bảo đảm có đầy đủ bang phái thành viên cùng ngươi cùng nhau tham dự, phải chăng xác định mở ra?", {{"Xác định", function ()
            self:OpenFuben(me, true);
            end}, {"Hủy bỏ"}});
        return;
    end

    pPlayer.SetUserValue(tbActivity.USERGROUP, tbActivity.USERKEY_FUBENTIME, GetTime());
    pPlayer.SendAward(tbActivity.tbJoinAward, true, false, Env.LogWay_HouseDefend);

    local dwPlayerId = pPlayer.dwID;
    local dwKinId = pPlayer.dwKinId;
    local fnSuccessCallback = function (nMapId)
        assert(not tbActivity.tbHouseFuben[dwPlayerId], "repeated fuben:" .. dwPlayerId);
        tbActivity.tbHouseFuben[dwPlayerId] = { nMapId = nMapId, dwKinId = dwKinId };

        local pPlayer = KPlayer.GetPlayerObjById(dwPlayerId);
        if pPlayer then
            pPlayer.CenterMsg("Mở ra mới lạ tiểu trúc đoạt lại chiến thành công!", 1);
        end

        local szMsg = string.format("「%s」Mở ra mới lạ tiểu trúc đoạt lại chiến rồi, đoạt lại hậu nhân người có thưởng, chư vị bang phái huynh đệ, nhanh đi giúp hắn một tay!", pPlayer.szName);
        ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, dwKinId);
    end

    local fnFailedCallback = function ()
        Log("[ERROR][HouseDefend] failed to create fuben: ", dwPlayerId);
    end

    Fuben:ApplyFuben(dwPlayerId, tbActivity.nFubenMapTemplateId, fnSuccessCallback, fnFailedCallback, dwPlayerId);

    Log("[HouseDefend] fuben open: player", dwPlayerId, "kin", dwKinId, "map", nMapId);
end

function tbActivity:OnFubenClose(nMapId, dwOwnerId)
    local tbFuben = tbActivity.tbHouseFuben[dwOwnerId];
    if not tbFuben then
        return;
    end
    
    if tbFuben.nMapId ~= nMapId then
        Log("[ERROR][HouseDefend] unknown fuben: ", nMapId, dwOwnerId);
        return;
    end

    tbActivity.tbHouseFuben[dwOwnerId] = nil;

    Log("[HouseDefend] fuben close: ", nMapId, dwOwnerId);
end

function tbActivity:CanEnterFuben(pPlayer, dwOwnerId)
    if not Env:CheckSystemSwitch(pPlayer, Env.SW_HouseDefend) then
        return false, "Hoạt động tạm thời quan bế, xin đợi thử lại";
    end

    local tbFuben = tbActivity.tbHouseFuben[dwOwnerId];
    if not tbFuben then
        return false, "Còn chưa mở ra phó bản";
    end

    if pPlayer.dwID ~= dwOwnerId and pPlayer.dwKinId ~= tbFuben.dwKinId then
        return false, "Ngươi không phù hợp điều kiện tiến vào";
    end

    return true, tbFuben.nMapId;
end

function tbActivity:EnterFuben(pPlayer, dwOwnerId)
    local bRet, result = self:CanEnterFuben(pPlayer, dwOwnerId);
    if not bRet then
        pPlayer.CenterMsg(result);
        return;
    end
    pPlayer.SetEntryPoint();
    pPlayer.SwitchMap(result, 0, 0);
end

function tbActivity:GetAwardCount(pPlayer)
    local nLastActTime = pPlayer.GetUserValue(tbActivity.USERGROUP, tbActivity.USERKEY_ACT_TIME);
    local nCurActTime = Activity:GetActBeginTime(self.szKeyName);
    if nLastActTime < nCurActTime then
        pPlayer.SetUserValue(tbActivity.USERGROUP, tbActivity.USERKEY_ACT_TIME, nCurActTime);
        pPlayer.SetUserValue(tbActivity.USERGROUP, tbActivity.USERKEY_AWARD_COUNT, 0);
    end
    return pPlayer.GetUserValue(tbActivity.USERGROUP, tbActivity.USERKEY_AWARD_COUNT);
end

function tbActivity:OnFubenFinished(pPlayer, nMapId)
    local nCurAwardCount = self:GetAwardCount(pPlayer);
    if nCurAwardCount >= tbActivity.MAX_AWARD_COUNT then
        Npc:SetPlayerNoDropMap(pPlayer, nMapId);
        return;
    end

    pPlayer.SetUserValue(tbActivity.USERGROUP, tbActivity.USERKEY_AWARD_COUNT, nCurAwardCount + 1);
    pPlayer.SendAward(tbActivity.tbFubenAward, true, true, Env.LogWay_HouseDefend);
    
    Log("[HouseDefend] player gain fuben award: ", pPlayer.dwID, pPlayer.szName);
end