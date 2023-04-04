-- 所有开启的活动的信息
BiWuZhaoQin.tbActData = BiWuZhaoQin.tbActData or {}

function BiWuZhaoQin:StartS(nTargetId, nKinId, bNpcType)
    if nKinId > 0 and not Kin:GetKinById(nKinId) then
        Log("BiWuZhaoQin fnStart no kin ", nTargetId, nKinId)
        return
    end
    local nServerId = GetServerIdentity();
    local szTimeFrame = Lib:GetMaxTimeFrame(BiWuZhaoQin.tbAvatar)
    CallZoneServerScript("BiWuZhaoQin:Start", nTargetId, nKinId, szTimeFrame, bNpcType, nServerId);
    Log("BiWuZhaoQin fnStart ", nServerId, nTargetId, nKinId, szTimeFrame, bNpcType and "true" or "false");
end
function BiWuZhaoQin:OnSynData(nTargetId,tbFightInfo)
    BiWuZhaoQin.tbActData[nTargetId] = tbFightInfo
end

function BiWuZhaoQin:GetActData(nTargetId)
    return BiWuZhaoQin.tbActData[nTargetId]
end

function BiWuZhaoQin:ClearActData(nTargetId)
    if BiWuZhaoQin.tbActData[nTargetId] then
        BiWuZhaoQin.tbActData[nTargetId] = nil
        Log("BiWuZhaoQin fnClearActDataS ok",nTargetId)
    end
end

-- 招亲结束回调
function BiWuZhaoQin:OnCompleteZhaoQinS(nPreMapId, nTargetId, nWinerId, nType, tbAllPlayer, tbFinalLostPlayer)
    local tbActData = self:GetActData(nTargetId);
    local bNpcType = tbActData and tbActData.bNpcType;
    if bNpcType then
        -- 这里说明是Npc的招亲
        Activity:OnGlobalEvent("Act_OnCompleteZhaoQinS", tbAllPlayer, nWinerId, nTargetId);
    end

    local pWiner = KPlayer.GetPlayerObjById(nWinerId)
    if not pWiner then
        self:OnEndZhaoQinS(nPreMapId, nTargetId, nType, tbAllPlayer, tbFinalLostPlayer, nWinerId)
        local tbMail = {
                To = nWinerId;
                Title = "Luận võ chọn rể";
                From = "Hệ thống";
                Text = "Bởi vì luận võ chọn rể tranh tài lúc bắt đầu ngài không tuyến bên trên, bỏ lỡ quán quân!";
                nLogReazon = Env.LogWay_BiWuZhaoQin;
            };

       Mail:SendSystemMail(tbMail);
       Log("BiWuZhaoQin fnOnCompleteZhaoQinS offline ",nPreMapId,nTargetId,nWinerId,nType)
       return
    end

    self:SendPlayerJoinAward(tbAllPlayer, tbFinalLostPlayer, nTargetId, nType, nWinerId)

    if not bNpcType then
        Item:GetClass("LoveToken"):AddLoveToken(pWiner, nTargetId, BiWuZhaoQin.nItemTID, nType);
    end

    self:ClearActData(nTargetId)
    local pTargetInfo = KPlayer.GetPlayerObjById(nTargetId) or KPlayer.GetRoleStayInfo(nTargetId)
    if pTargetInfo and not bNpcType then

        local szName = pTargetInfo.szName or "-"

        local tbMail = {
                    To = nWinerId;
                    Title = "Luận võ chọn rể quán quân";
                    From = "Hệ thống";
                    Text = string.format("Đại hiệp, chúc mừng ngài thu được hiệp sĩ [FFFE0D]%s[-] Luận võ chọn rể quán quân, kết thành tình duyên đạo cụ [FFFE0D][url=openwnd: Tín vật đính ước, ItemTips,'Item',nil,%d][-] Đã gửi đi đến trong hành trang, xin mau sớm sử dụng cùng nó kết thành tình duyên đi!",szName,BiWuZhaoQin.nItemTID);
                    nLogReazon = Env.LogWay_BiWuZhaoQin;
                };
        Mail:SendSystemMail(tbMail);

        tbMail = {
                    To = nTargetId;
                    Title = "Luận võ chọn rể";
                    From = "Hệ thống";
                    Text = string.format("Ngài luận võ chọn rể tranh tài kết thúc, hiệp sĩ [FFFE0D]%s[-] Trở thành người chiến thắng, xin mau sớm cùng nó liên hệ kết thành tình duyên!",pWiner.szName);
                    nLogReazon = Env.LogWay_BiWuZhaoQin;
                };
        Mail:SendSystemMail(tbMail);
    end


    Log("BiWuZhaoQin fnOnCompleteZhaoQinS ",nPreMapId,nTargetId,nWinerId, bNpcType and "true" or "false");
end

function BiWuZhaoQin:SendPlayerJoinAward(tbAllPlayer, tbFinalLostPlayer, nTargetId, nType, nWinerId)
    Log("BiWuZhaoQin fnSendPlayerJoinAward Start ", nTargetId, nType)
    if not tbAllPlayer or not next(tbAllPlayer) then
        Log("BiWuZhaoQin fnSendPlayerJoinAward no player ", nTargetId, nType)
        return
    end
    local tbFinalLostPlayer = tbFinalLostPlayer or {}
    local tbJoinPlayer = {}
    for nRound,tbPlayer in pairs(tbAllPlayer) do
        for dwID,_ in pairs(tbPlayer) do
            tbJoinPlayer[dwID] = (tbJoinPlayer[dwID] or 0) + 1
        end
    end
    for dwID,nCount in pairs(tbJoinPlayer) do
        local nBaseExpCount = tbFinalLostPlayer[dwID] and nCount - 1 or nCount
        -- 除掉冠军最后一份数据
        if nWinerId and nWinerId == dwID then
            nBaseExpCount = nBaseExpCount - 1
        end
        if nBaseExpCount > 0 then
            local tbMail = {
                To = dwID;
                Title = "Luận võ chọn rể";
                From = "Hệ thống";
                Text = "Đây là ngươi tham gia luận võ chọn rể thu hoạch được kinh nghiệm ban thưởng, mời kiểm tra và nhận!";
                tbAttach = {{"BasicExp", nBaseExpCount * BiWuZhaoQin.nBaseExpCount}};
                nLogReazon = Env.LogWay_BiWuZhaoQin;
            };
            Mail:SendSystemMail(tbMail);
            Log("BiWuZhaoQin fnSendPlayerJoinAward ok ", dwID, nCount, nBaseExpCount, nTargetId, nType)
        else
            Log("BiWuZhaoQin fnSendPlayerJoinAward Zero ", dwID, nCount, nBaseExpCount, nTargetId, nType)
        end
    end
end

-- 开始招亲回调
function BiWuZhaoQin:OnStartZhaoQinS(nPreMapId, nTargetId, nType, nKinId, bNpcType)
    local szMsg = ""
    local pTargetInfo = KPlayer.GetPlayerObjById(nTargetId) or KPlayer.GetRoleStayInfo(nTargetId)
    if pTargetInfo then
        local szName = pTargetInfo and pTargetInfo.szName or "-"
        if nType == BiWuZhaoQin.TYPE_KIN then
            if nKinId and nKinId ~= 0 then
                szMsg = string.format("Bang phái thành viên [FFFE0D]%s[-] Luận võ chọn rể bắt đầu báo danh, thời gian [FFFE0D]5 Phút [-], xin mọi người mau chóng tìm [FFFE0D] Tương Dương yến như tuyết [-] Báo danh tham gia!", szName)
                ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId);
                local fnMsg = function(self, pPlayer, szMsg)
                    pPlayer.Msg(szMsg)
                end
                BiWuZhaoQin:ForeachKinPlayer(fnMsg, nKinId, szMsg)
            else
               Log("BiWuZhaoQin OnStartZhaoQin no kin id", nPreMapId, nTargetId, nType);
            end
        elseif nType == BiWuZhaoQin.TYPE_GLOBAL then
            szMsg = string.format("Hiệp sĩ [FFFE0D]%s[-] Luận võ chọn rể bắt đầu báo danh, thời gian [FFFE0D]5 Phút [-], xin mọi người mau chóng tìm [FFFE0D] Tương Dương yến như tuyết [-] Báo danh tham gia!", szName)
            KPlayer.SendWorldNotify(1,1000, szMsg, ChatMgr.ChannelType.Public, 1);
        end
    end

    if bNpcType then
        Activity:OnGlobalEvent("Act_OnStartZhaoQinS", nPreMapId, nTargetId);
    end

    Log("BiWuZhaoQin fnOnStartZhaoQinS ", nPreMapId, nTargetId, nType, bNpcType and "true" or "false");
end

-- 招亲无人参加或者所有参赛者失去资格回调
function BiWuZhaoQin:OnEndZhaoQinS(nPreMapId, nTargetId, nType, tbAllPlayer, tbFinalLostPlayer, nWinerId)
    self:SendPlayerJoinAward(tbAllPlayer, tbFinalLostPlayer, nTargetId, nType, nWinerId)

    local tbActData = self:GetActData(nTargetId);
    local bNpcType = tbActData and tbActData.bNpcType;
    if bNpcType then
        Activity:OnGlobalEvent("Act_OnEndZhaoQinS", tbAllPlayer, nPreMapId, nTargetId);
    end

    self:ClearActData(nTargetId)

    local pTargetInfo = KPlayer.GetPlayerObjById(nTargetId) or KPlayer.GetRoleStayInfo(nTargetId)
    if pTargetInfo then
        local tbMail = {
                    To = nTargetId;
                    Title = "Luận võ chọn rể";
                    From = "Hệ thống";
                    Text = "Rất tiếc nuối thông tri ngài, bởi vì ngài Luận võ chọn rể Tranh tài không người tham gia, chọn rể thất bại!";
                    nLogReazon = Env.LogWay_BiWuZhaoQin;
                };
        Mail:SendSystemMail(tbMail);
    end

	Log("BiWuZhaoQin fnOnEndZhaoQinS ",nPreMapId,nTargetId,nType, bNpcType and "true" or "false");
end

function BiWuZhaoQin:OnStartFinalS(nTargetId)
     local tbActData = self:GetActData(nTargetId)
     if not tbActData then
        Log("BiWuZhaoQin fnOnStartFinalS no tbActData",nTargetId)
        return
    end
    local szMsg = ""
    tbActData.nProcess = BiWuZhaoQin.Process_Final
    local pTargetInfo = KPlayer.GetPlayerObjById(nTargetId) or KPlayer.GetRoleStayInfo(nTargetId)
    if pTargetInfo then
        if tbActData.nType == BiWuZhaoQin.TYPE_KIN then
            local nKinId = tbActData.nKinId
            if nKinId and nKinId ~= 0 then
                szMsg = string.format("Bang phái thành viên [FFFE0D]%s[-] Luận võ chọn rể Trận chung kết sắp bắt đầu, mọi người có thể tìm [FFFE0D] Tương Dương yến như tuyết [-] Tiến vào sân bãi quan chiến!",pTargetInfo.szName or "-")
                ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId);
            end
        elseif tbActData.nType == BiWuZhaoQin.TYPE_GLOBAL then
            szMsg = string.format("Hiệp sĩ [FFFE0D]%s[-] Luận võ chọn rể Trận chung kết sắp bắt đầu, mọi người có thể tìm [FFFE0D] Tương Dương yến như tuyết [-] Tiến vào sân bãi quan chiến!",pTargetInfo.szName or "-")
            KPlayer.SendWorldNotify(1,1000, szMsg, ChatMgr.ChannelType.Public, 1);
        end
    end

    local tbActData = self:GetActData(nTargetId);
    local bNpcType = tbActData and tbActData.bNpcType;
    if bNpcType then
        Activity:OnGlobalEvent("Act_OnStartFinalS", nPreMapId, nTargetId);
    end
end

function BiWuZhaoQin:CheckCanEnter(dwID, nTargetId, bNoJoin)
    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
        return false;
    end
    local tbActData = self:GetActData(nTargetId)
    if not tbActData or not tbActData.nPreMapId then
        return false, "Hoạt động chưa mở ra!", pPlayer;
    end

    if not bNoJoin and tbActData.nKinId > 0 and tbActData.nKinId ~= pPlayer.dwKinId then
        return false, "Nhất định phải cùng chọn rể người chơi tại cùng một bang phái mới tham ngộ cùng", pPlayer;
    end

    if not bNoJoin and dwID == tbActData.nTargetId then
        return false, "Chọn rể người chỉ có thể để xem chiến hình thức tiến vào", pPlayer;
    end

    if not bNoJoin and pPlayer.nLevel < BiWuZhaoQin.nJoinLevel then
        return false, string.format("Cần chờ cấp đạt tới %d Cấp!",BiWuZhaoQin.nJoinLevel), pPlayer;
    end

    if not bNoJoin and (not tbActData.nProcess or tbActData.nProcess ~=  BiWuZhaoQin.Process_Pre) and not self:HadJoin(dwID,tbActData.nTargetId) then
        return false, "Báo danh giai đoạn đã kết thúc, mời để xem chiến hình thức tiến vào", pPlayer;
    end

    if not bNoJoin and tbActData.nJoin >= BiWuZhaoQin.nMaxJoin then
        return false, "Số người tham gia đã đủ, mời để xem chiến hình thức tiến vào", pPlayer;
    end
    return true, "", pPlayer, tbActData;
end

-- 玩家进入的接口
function BiWuZhaoQin:Enter(dwID, nTargetId, bNoJoin)
    local bRet, szMsg, pPlayer, tbActData = self:CheckCanEnter(dwID, nTargetId, bNoJoin);
    if not bRet then
        if pPlayer then
            pPlayer.CenterMsg(szMsg, true);
        end
        return false;
    end

    CallZoneServerScript("BiWuZhaoQin:OnTryEnterPreMap", dwID, tbActData.nPreMapId, bNoJoin);
    if not pPlayer.SwitchZoneMap(tbActData.nPreMapId, 0, 0) then
        pPlayer.CenterMsg("Nên chọn rể tranh tài địa đồ hiện tại đã vô pháp tiến vào", true)
        return false;
    end

    Log("BiWuZhaoQin fnEnterS ", dwID, nTargetId, tbActData.nKinId, bNoJoin and 1 or 0)
    return true;
end

function BiWuZhaoQin:ForeachKinPlayer(fnFunc,nKinId,...)
    local tbMember = Kin:GetKinMembers(nKinId)
    for dwID,_ in pairs(tbMember) do
        local pPlayer = KPlayer.GetPlayerObjById(dwID)
        if pPlayer then
            Lib:CallBack({fnFunc, self, pPlayer,...});
        end
    end
end

-- 玩家参加后离开判断是否参加过
function BiWuZhaoQin:HadJoin(dwID,nTargetId)
    local tbActData = self:GetActData(nTargetId)
    if tbActData and tbActData.tbPlayer then
        return tbActData.tbPlayer[dwID]
    end
end

function BiWuZhaoQin:OnSynJoinS(nTargetId,nJoin)
    local tbActData = self:GetActData(nTargetId)
    if not tbActData then
        Log("BiWuZhaoQin fnOnSynJoinS ",nTargetId,nJoin)
        return
    end
    tbActData.nJoin = nJoin
end

function BiWuZhaoQin:OnFirstFightS(tbFightInfo)
     local tbActData = self:GetActData(tbFightInfo.nTargetId)
     if not tbActData then
        Log("BiWuZhaoQin fnOnFirstFightS no tbActData",tbFightInfo.nTargetId)
        return
    end
    tbActData.nProcess = tbFightInfo.nProcess
    tbActData.tbPlayer = tbFightInfo.tbPlayer[tbFightInfo.nRound]
end

function BiWuZhaoQin:GetAllLoverInfo()
    local tbData = ScriptData:GetValue("BiWuZhaoQin");
    if not tbData.tbAllLoverInfo then
        tbData.tbAllLoverInfo = {};
        ScriptData:AddModifyFlag("BiWuZhaoQin");
    end

    return tbData.tbAllLoverInfo;
end

function BiWuZhaoQin:GetLover(nPlayerId)
    local tbAllLoverInfo = self:GetAllLoverInfo();
    return tbAllLoverInfo[nPlayerId];
end

function BiWuZhaoQin:CheckIsLover(nPlayerId, nOtherId)
    local nLoverId = self:GetLover(nPlayerId) or 0;
    return nLoverId == nOtherId;
end

function BiWuZhaoQin:AddLover(pPlayer, pOther)
    if not pPlayer or not pOther then
        Log("[BiWuZhaoQin] AddLover Fail !!", pPlayer and "true" or "nil", pOther and "true" or "nil");
        return;
    end

    local tbAllLoverInfo = self:GetAllLoverInfo();
    if tbAllLoverInfo[pPlayer.dwID] or tbAllLoverInfo[pOther.dwID] then
        Log("[BiWuZhaoQin] AddLover Fail !! Lover has exist !!", pPlayer.dwID, tbAllLoverInfo[pPlayer.dwID] or "nil", pOther.dwID, tbAllLoverInfo[pOther.dwID] or "nil");
        return;
    end

    pPlayer.CallClientScript("BiWuZhaoQin:OnSyncLoverInfo", pOther.dwID);
    pOther.CallClientScript("BiWuZhaoQin:OnSyncLoverInfo", pPlayer.dwID);

    FriendShip:ForceAddFriend(pPlayer, pOther);
    tbAllLoverInfo[pPlayer.dwID] = pOther.dwID;
    tbAllLoverInfo[pOther.dwID] = pPlayer.dwID;

    ScriptData:AddModifyFlag("BiWuZhaoQin");
    ScriptData:CheckAndSave();
end

function BiWuZhaoQin:RemoveLover(pPlayer)
    if not pPlayer then
        return false;
    end

    local tbAllLoverInfo = self:GetAllLoverInfo();
    local nOtherId = tbAllLoverInfo[pPlayer.dwID];
    if not nOtherId then
        return;
    end

    pPlayer.CallClientScript("BiWuZhaoQin:OnSyncLoverInfo");
    tbAllLoverInfo[pPlayer.dwID] = nil;
    ScriptData:AddModifyFlag("BiWuZhaoQin");
    ScriptData:CheckAndSave();
    return nOtherId;
end

function BiWuZhaoQin:OnLogin(pPlayer)
    local nLoverId = self:GetLover(pPlayer.dwID);
    if not nLoverId then
        return;
    end

    local nMyId = self:GetLover(nLoverId);
    if not nMyId or nMyId ~= pPlayer.dwID then
        -- 说明对方已经解除关系
        -- 移除数据，解除关系
        BiWuZhaoQin:RemoveLover(pPlayer);
        pPlayer.DeleteTitle(BiWuZhaoQin.nTitleId);
        return;
    end

    pPlayer.CallClientScript("BiWuZhaoQin:OnSyncLoverInfo", nLoverId);
    local pLover = KPlayer.GetPlayerObjById(nLoverId);
    if pLover then
        pLover.Msg(string.format("Ngài tình duyên「%s」lên mạng", pPlayer.szName));
    end
end