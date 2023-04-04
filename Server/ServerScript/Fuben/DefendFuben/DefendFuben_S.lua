local function fnAllMember(tbMember, fnSc, ...)
    for _, nPlayerId in pairs(tbMember or {}) do
        local pMember = KPlayer.GetPlayerObjById(nPlayerId);
        if pMember then
            fnSc(pMember, ...);
        end
    end
end

local function fnMsg(pPlayer, szMsg)
    pPlayer.CenterMsg(szMsg);
end

function DefendFuben:CheckCanEnter(pTarget)
    local tbTeamMember = TeamMgr:GetMembers(pTarget.dwTeamID)

    local bInProcess = Activity:__IsActInProcessByType("DefendAct")
    if not bInProcess then
        return false,"Hoạt động chưa mở",tbTeamMember
    end

    if pTarget.dwTeamID == 0 then
        return false, string.format("Tạo đội %d rồi hãy đến",DefendFuben.JOIN_MEMBER_COUNT),tbTeamMember
    end
  
    if #tbTeamMember ~= DefendFuben.JOIN_MEMBER_COUNT then
        return false, string.format("Đội phải có %d người",DefendFuben.JOIN_MEMBER_COUNT),tbTeamMember
    end

    local tbTeam = TeamMgr:GetTeamById(pTarget.dwTeamID)
    local nCaptainId = tbTeam:GetCaptainId();
    if nCaptainId ~= pTarget.dwID then
        return false,"Đội trưởng mới có thể báo danh",tbTeamMember
    end

    local bRet,szMsg = self:CheckDistance(pTarget)
    if not bRet then
        return false,szMsg
    end

    table.sort(tbTeamMember, function (a, b)
        return a == pTarget.dwID and b ~= pTarget.dwID
    end)

    local tbSecOK = {}
    for nIdx, nPlayerId in ipairs(tbTeamMember) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if not pPlayer then
            return false, "Không tìm được người chơi",tbTeamMember
        end

        if pPlayer.nLevel < DefendFuben.JOIN_LEVEL then
            return false, string.format("「%s」 không đủ cấp %d ",pPlayer.szName, DefendFuben.JOIN_LEVEL),tbTeamMember
        end

        tbSecOK[nIdx] = pPlayer.nSex;
        if DegreeCtrl:GetDegree(pPlayer, "DefendFuben") <= 0 then
            return false,string.format("「%s」 số lần không đủ",pPlayer.szName),tbTeamMember
        end
    end
    if tbSecOK[1] == tbSecOK[2] then
        return false, "Tổ đội khác",tbTeamMember
    end

    return true,nil,tbTeamMember
end

function DefendFuben:CheckDistance(pPlayer)
    local tbTeamMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    local pPlayer1 = KPlayer.GetPlayerObjById(tbTeamMember[1])
    local pPlayer2 = KPlayer.GetPlayerObjById(tbTeamMember[2])
    local nMapId1, nX1, nY1 = pPlayer1.GetWorldPos()
    local nMapId2, nX2, nY2 = pPlayer2.GetWorldPos()

    local szName = ""
    if pPlayer1.dwID == me.dwID then
        szName = pPlayer2.szName
    elseif pPlayer2.dwID == me.dwID then
         szName = pPlayer1.szName
    end

    if nMapId1 ~= nMapId2 then
        return false, string.format("Đồng đội % không có trong bản đồ",szName)
    end

    local fDists = Lib:GetDistsSquare(nX1, nY1, nX2, nY2)
    if fDists > (self.MIN_DISTANCE * self.MIN_DISTANCE) then
        return false, string.format("Đồng đội %s không ở gần",szName)
    end

    return true
end

function DefendFuben:TryCreateFuben(pPlayer)

    local bRet, szMsg,tbMember = self:CheckCanEnter(pPlayer);
    if not bRet then
        if not tbMember or not next(tbMember) then
            pPlayer.CenterMsg(szMsg)
        else
            fnAllMember(tbMember, fnMsg, szMsg);
        end
       ChatMgr:SendTeamOrSysMsg(pPlayer, szMsg)
       return;
    end

    local function fnSuccessCallback(nMapId)
        local function fnSucess(pPlayer, nMapId)
            pPlayer.SetEntryPoint();
            pPlayer.SwitchMap(nMapId, 0, 0);
        end
        fnAllMember(tbMember, fnSucess, nMapId);
    end

    local function fnFailedCallback()
        fnAllMember(tbMember, fnMsg, "Mở phó bản thất bại, thử lại sau");
    end

    Fuben:ApplyFuben(pPlayer.dwID, DefendFuben.nFubenMapTemplateId, fnSuccessCallback, fnFailedCallback);

    return true;
end