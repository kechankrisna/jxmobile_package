Require("CommonScript/Activity/DaXueZhangDef.lua");

local tbDaXueZhang = Activity.tbDaXueZhang;
local tbDef = tbDaXueZhang.tbDef;

local tbAct = Activity:GetClass("DaXueZhang");

tbAct.tbTimerTrigger =
{
    [1] = {szType = "Day", Time = "13:30" , Trigger = "StartEnter" },
    [2] = {szType = "Day", Time = "13:44" , Trigger = "CloseEnter" },
    [3] = {szType = "Day", Time = "16:00" , Trigger = "StartEnter" },
    [4] = {szType = "Day", Time = "16:14" , Trigger = "CloseEnter" },
    [5] = {szType = "Day", Time = "20:00" , Trigger = "StartEnter" },
    [6] = {szType = "Day", Time = "20:14" , Trigger = "CloseEnter" },
};

tbAct.tbTrigger =
{
    Init = {},
    Start =
    {
        {"StartTimerTrigger", 1}, {"StartTimerTrigger", 2},
        {"StartTimerTrigger", 3}, {"StartTimerTrigger", 4},
        {"StartTimerTrigger", 5}, {"StartTimerTrigger", 6},
    },
    End = {},
    StartEnter = {},
    CloseEnter = {},
};

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        self:StartDaXueZhang();

    elseif szTrigger == "End" then
        self:EndDaXueZhang();

    elseif szTrigger == "StartEnter" then
        self:StartEnter();

    elseif szTrigger == "CloseEnter" then
        self:CloseEnter();
    end

    Log("DaXueZhang OnTrigger:", szTrigger)
end

function tbAct:StartDaXueZhang()
    tbDaXueZhang.bHaveDXZ = true;
    Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnPlayerLogin");

    local tbAllPlayer = KPlayer.GetAllPlayer();
    for _, pPlayer in pairs(tbAllPlayer) do
        tbDaXueZhang:GetDXZJoinCount(pPlayer);
    end

    Log("DaXueZhang StartDaXueZhang");
end

function tbAct:OnPlayerLogin()
    tbDaXueZhang:OnDXZLogin(me)
end

function tbAct:EndDaXueZhang()
    tbDaXueZhang.bStartEnterZone = false;
    tbDaXueZhang.bHaveDXZ = false;

    Log("DaXueZhang EndDaXueZhang");
end

function tbAct:CreateZonePreMap()
    tbDaXueZhang.nEnterZoneMapId = nil;
    CallZoneServerScript("Activity.tbDaXueZhang:CreatePreMapZ");
    Log("DaXueZhang CreateZonePreMap");
end

function tbAct:StartEnter()
    self:CreateZonePreMap();

    KPlayer.SendWorldNotify(1, 999, "Ném tuyết hoạt động bắt đầu báo danh, thời gian 5 Phút, mọi người mau tới báo danh!", 1, 1);

    local tbMsgData =
    {
        szType = "DaXueZhang";
        nTimeOut = GetTime() + 1800;
    };

    KPlayer.BoardcastScript(tbDef.nLimitLevel, "Ui:SynNotifyMsg", tbMsgData);
    tbDaXueZhang.bStartEnterZone = true;

    Log("DaXueZhang StartEnter");
end

function tbAct:CloseEnter()
    tbDaXueZhang.bStartEnterZone = false;
    Log("DaXueZhang CloseEnter");
end

function tbDaXueZhang:OnDXZLogin(pPlayer)
    if not self.bHaveDXZ then
        return;
    end

    tbDaXueZhang:GetDXZJoinCount(pPlayer);
end

function tbDaXueZhang:LoadSetting()
    self.tbMapPosSetting = {};
    local tbFileData = Lib:LoadTabFile("ServerSetting/Activity/DaXueZhangPos.tab", {MapTID = 1, PosX = 1, PosY = 1});
    for nRow, tbInfo in pairs(tbFileData) do
        self.tbMapPosSetting[tbInfo.MapTID] = self.tbMapPosSetting[tbInfo.MapTID] or {};
        table.insert(self.tbMapPosSetting[tbInfo.MapTID], tbInfo);
    end
end

tbDaXueZhang:LoadSetting()

function tbDaXueZhang:GetMapAllPos(nMapTID)
    return self.tbMapPosSetting[nMapTID];
end

function tbDaXueZhang:RandomEnterMapPos(nMapTID)
    local tbAllPos = self:GetMapAllPos(nMapTID);
    if not tbAllPos then
        return;
    end

    local nTotalCount = #tbAllPos;
    local nRandIndex = MathRandom(nTotalCount);
    local tbPos = tbAllPos[nRandIndex];
    return tbPos;
end

function tbDaXueZhang:SendPreMapIdS(nMapId)
    self.nEnterZoneMapId = nMapId;

    Log("DaXueZhang SendPreMapIdS", nMapId);
end

function tbDaXueZhang:ReducePlayerCountS(nPlayerID, nCount)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerID);
    if not pPlayer then
        return;
    end

    local nCurCount = self:GetDXZJoinCount(pPlayer);
    if nCurCount <= 0 then
        Log("Error DaXueZhang ReducePlayerCountS", nPlayerID, nCount);
        CallZoneServerScript("Activity.tbDaXueZhang:KickOutPlayerOnZoneZ", nPlayerID);
        return;
    end

    self:AddPlayerJoinCount(pPlayer, nCount);
end

function tbDaXueZhang:SendPlayerMailAwardS(nPlayerID, nAwardType, nRank)
    local tbAwardInfo = tbDef.tbPlayerAward.tbFail;
    if nAwardType == tbDef.nWinType then
        tbAwardInfo = tbDef.tbPlayerAward.tbWin;
    end

    local tbAllAwrd = tbAwardInfo.tbRankAward[nRank];
    if not tbAllAwrd then
        Log("Error DaXueZhang SendPlayerMailAwardS", nPlayerID, nAwardType, nRank);
        return;
    end

    local tbMail =
    {
        To = nPlayerID,
        Title = "Ném tuyết",
        Text = tbAwardInfo.szMailContent;
        nLogReazon = Env.LogWay_DaXueZhang;
        tbAttach = tbAllAwrd,
    }
    Mail:SendSystemMail(tbMail);

    Log("DaXueZhang SendPlayerMailAwardS", nPlayerID, nAwardType, nRank);
end

function tbDaXueZhang:CheckPlayerEnterDaXueZhange(pPlayer)
    if not self.nEnterZoneMapId then
        return false, "Chưa mở ra";
    end

    if not self.bStartEnterZone then
        return false, "Chưa mở ra";
    end

    local bRet, szMsg = self:CheckSimplePlayerEnter(pPlayer);
    if not bRet then
        return false, szMsg;
    end

    local nTeamId = pPlayer.dwTeamID;
    if nTeamId > 0 then
        local tbTeam = TeamMgr:GetTeamById(nTeamId)
        local nCaptainId = tbTeam:GetCaptainId();
        if nCaptainId ~= pPlayer.dwID then
            return false, "Tổ đội tình huống dưới chỉ có đội trưởng có thể báo danh!";
        end

        local tbMember = tbTeam:GetMembers();
        local nTeamCount = Lib:CountTB(tbMember);
        if nTeamCount > tbDef.nTeamCount then
            return false, string.format("Đội ngũ nhân số không đủ %s Người", tbDef.nTeamCount);
        end

        for _, nPlayerID in pairs(tbMember) do
            local pMember = KPlayer.GetPlayerObjById(nPlayerID);
            if not pMember then
                return false, "Đội ngũ có người chơi không online!"
            end

            local bRet1, szMsg1 = self:CheckSimplePlayerEnter(pMember);
            if not bRet1 then
                local szTips = string.format("「%s」%s", pMember.szName, szMsg1);
                if nTeamId > 0 then
                    ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Team, szTips, nTeamId);
                end

                return false, szTips;
            end
        end
    end

    return true, "", self.nEnterZoneMapId;
end

function tbDaXueZhang:CheckSimplePlayerEnter(pPlayer)
    if pPlayer.nLevel < tbDef.nLimitLevel then
        return false, string.format("Tham dự hoạt động cần chờ cấp đạt tới %s", tbDef.nLimitLevel);
    end

    if not Map:IsCityMap(pPlayer.nMapTemplateId) then
        return false, "Chỉ có tại vong ưu đảo cùng chủ thành mới có thể tham gia ném tuyết!";
    end

    local bRet = Map:CheckEnterOtherMap(pPlayer);
    if not bRet then
        return false, "Không phải khu vực an toàn không cách nào tiến hành tương quan thao tác!";
    end

    local nCount = self:GetDXZJoinCount(pPlayer);
    if nCount <= 0 then
        return false, "Tham gia hoạt động số lần không đủ!";
    end

    return true, "";
end


function tbDaXueZhang:PlayerEnterDaXueZhang(pPlayer)
    local bRet, szMsg, nEnterZoneMapId = self:CheckPlayerEnterDaXueZhange(pPlayer);
    if not bRet then
        pPlayer.CenterMsg(szMsg, true);
        return;
    end

    local tbPos = self:RandomEnterMapPos(tbDef.nPrepareMapTID);
    local nTeamId = pPlayer.dwTeamID;
    local tbSyncPlayer = {};
    if nTeamId > 0 then
        tbSyncPlayer = {};
        local tbTeam = TeamMgr:GetTeamById(nTeamId)
        local nCaptainId = tbTeam:GetCaptainId();
        local tbMember = tbTeam:GetMembers();
        for _, nPlayerID in pairs(tbMember) do
            local tbInfo = {};
            tbInfo.nTeamId = nTeamId;
            tbSyncPlayer[nPlayerID] = tbInfo;
        end

        CallZoneServerScript("Activity.tbDaXueZhang:SendSyncPlayerTeamZ", tbSyncPlayer);

        bRet = pPlayer.SwitchZoneMap(nEnterZoneMapId, tbPos.PosX, tbPos.PosY);
        if not bRet then
            pPlayer.CenterMsg("Ném tuyết hoạt động hiện tại đã vô pháp tiến vào!", true);
        end

        for nPlayerID, _ in pairs(tbSyncPlayer) do
            local pMember = KPlayer.GetPlayerObjById(nPlayerID);
            if nPlayerID ~= pPlayer.dwID then
                bRet = pMember.SwitchZoneMap(nEnterZoneMapId, tbPos.PosX, tbPos.PosY);
                if not bRet then
                    pMember.CenterMsg("Ném tuyết hoạt động hiện tại đã vô pháp tiến vào!", true);
                end
                TeamMgr:QuiteTeam(pMember.dwTeamID, pMember.dwID);
            end
        end

        TeamMgr:QuiteTeam(pPlayer.dwTeamID, pPlayer.dwID);
    else
        tbSyncPlayer = {};
        local tbInfo = {};
        tbInfo.nTeamId = 0;
        tbSyncPlayer[pPlayer.dwID] = tbInfo;
        CallZoneServerScript("Activity.tbDaXueZhang:SendSyncPlayerTeamZ", tbSyncPlayer);

        bRet = pPlayer.SwitchZoneMap(nEnterZoneMapId, tbPos.PosX, tbPos.PosY);
        if not bRet then
            pPlayer.CenterMsg("Ném tuyết hoạt động hiện tại đã vô pháp tiến vào!", true)
        end
    end
end

function tbDaXueZhang:AddPlayerHonorBox(pPlayer, nHonor, nLogReazon, nLogReazon2)
    local nCurHonor = pPlayer.GetUserValue(tbDef.nSaveGroup, tbDef.nSaveHonor);
    nCurHonor = nCurHonor + nHonor;

    local tbAllAward = {};
    for _, tbInfo in ipairs(tbDef.tbHonorInfo) do
        local nBoxCount = math.floor(nCurHonor / tbInfo.nNeed);
        nCurHonor = math.floor(nCurHonor % tbInfo.nNeed);

        if nBoxCount > 0 then
            local tbAward = {"item", tbInfo.nItemID, nBoxCount};
            table.insert(tbAllAward, tbAward);
        end
    end

    pPlayer.SetUserValue(tbDef.nSaveGroup, tbDef.nSaveHonor, nCurHonor);

    if Lib:HaveCountTB(tbAllAward) then
        pPlayer.SendAward(tbAllAward, true, nil, nLogReazon, nLogReazon2)
    end

    Log("DaXueZhang AddPlayerHonorBox", pPlayer.dwID, nHonor, nCurHonor);
end

function tbDaXueZhang:AddPlayerJoinCount(pPlayer, nAddCount)
    local nCurCount = self:GetDXZJoinCount(pPlayer);
    nCurCount = nCurCount + nAddCount;
    if nCurCount < 0 then
        nCurCount = 0;
    end

    pPlayer.SetUserValue(tbDef.nSaveGroup, tbDef.nSaveJoin, nCurCount);
    Log("DaXueZhang AddPlayerJoinCount", pPlayer.dwID, nAddCount, nCurCount);
end


