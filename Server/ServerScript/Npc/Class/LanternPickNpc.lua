local tbNpc = Npc:GetClass("LanternPickNpc")

function tbNpc:OnDialog()
    if me.nLevel<Kin.MonsterNianDef.nMinJoinLevel then
        me.CenterMsg("Cấp bậc chưa đủ, không cách nào tham dự hoạt động")
        return
    end

    him.tbAnsweredPids = him.tbAnsweredPids or {}
    if him.tbAnsweredPids[me.dwID] then
        Dialog:SendBlackBoardMsg(me, "Ngài đã nhìn qua cái này đèn lồng!")
        return
    end

    GeneralProcess:StartProcess(me, Kin.MonsterNianDef.nLanternPickTime*Env.GAME_FPS, "Đang thu thập", self.EndProcess, self, me.dwID, him.nId)
end

function tbNpc:EndProcess(nPlayerId, nNpcId)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
    local pNpc = KNpc.GetById(nNpcId)
    if not pPlayer then
        return
    end

    if not pNpc or pNpc.IsDelayDelete() then
        pPlayer:CenterMsg("Đã được người khác thu thập")
        return
    end
    
    local nQuestionId = pNpc.nQuestionId
    if not nQuestionId or nQuestionId<=0 then
        Log("[x] LanternPickNpc:EndProcess", nPlayerId, nNpcId, tostring(nQuestionId))
        return
    end
    pPlayer.CallClientScript("Ui:OpenWindow", "LanternQuestionPanel", nNpcId, nQuestionId)
end
