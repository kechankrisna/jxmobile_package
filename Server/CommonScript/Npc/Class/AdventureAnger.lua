local tbNpc = Npc:GetClass("AdventureAnger")

function tbNpc:OnDialog()
    local tbParams  = Lib:SplitStr(him.szScriptParam, "|")
    local nFaction  = tonumber(tbParams[1]) or -1
    local nTime     = tonumber(tbParams[2]) or 1
    local nAddAnger = tonumber(tbParams[3]) or 1000
    local szDialog  = tbParams[4]
    local szMsg     = tbParams[5]
    
    if nFaction == -1 or me.nFaction == nFaction then
        GeneralProcess:StartProcess(me, nTime * Env.GAME_FPS, szDialog or "", self.EndProcess, self, me.dwID, him.nId, nAddAnger, szMsg or "")
    else
        me.CenterMsg("Phái tương ứng mới được mở cơ quan này");
    end
end

function tbNpc:EndProcess(nPlayerId, nNpcId, nAddAnger, szMsg)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    if not pPlayer then
        Log("[AdventureAnger EndProcess] Error, Player is nil")
        return
    end
    local pNpc = KNpc.GetById(nNpcId)
    if not pNpc or pNpc.IsDelayDelete() then
        Log("AdventureAnger npc had been use")
        return
    end

    pNpc.Delete()
    pPlayer.GetNpc().AddAnger(nAddAnger)

    local tbInstance = Fuben:GetFubenInstance(pPlayer)
    if tbInstance and tbInstance.bClose ~= 1 then
        tbInstance:OnGetAnger(pPlayer)
        tbInstance:BlackMsg(szMsg)
    end
    
    if MODULE_GAMESERVER then
        ChatMgr:SendTeamOrSysMsg(pPlayer, string.format("「%s」đã mở cơ quan Nộ Khí, nộ khí tăng đầy, không thể ngăn cản!", pPlayer.szName))
    end
end
