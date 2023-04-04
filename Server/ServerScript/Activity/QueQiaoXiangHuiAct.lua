local tbAct = Activity:GetClass("QueQiaoXiangHuiAct")
tbAct.tbTimerTrigger = {
    [1] = {szType = "Day", Time = "18:00" , Trigger = "SendWorldNotify" },
}
tbAct.tbTrigger = {
	Init={},
	Start={
        {"StartTimerTrigger", 1},
    },
	End={},
    SendWorldNotify = { {"WorldMsg", "各位少俠，七夕節限時活動相會鵲橋開始了，大家可通過查詢“最新消息”瞭解活動內容！", 20} },
    OpenAct = {},
    CloseAct = {},
}

function tbAct:OnTrigger(szTrigger)
    Log("QueQiaoXiangHuiAct:OnTrigger", szTrigger)
    if szTrigger=="Init" then
    elseif szTrigger=="Start" then
        local _, nEndTime = self:GetOpenTimeInfo()
        self:RegisterDataInPlayer(nEndTime)

        ActionInteract.tbDef.tbLimitMap[self.nMapTemplateId] = 1

        Activity:RegisterNpcDialog(self, self.nDialogNpcId, {Text = "相會鵲橋", Callback = self.TryApply, Param = {self}})
        Activity:RegisterPlayerEvent(self, "Act_QueQiaoXiangHuiReq", "OnClientReq")
    elseif szTrigger=="End" then
	end
end

function tbAct:CheckBeforeEnter(pCaptain)
    local bOk, szErr, pOther = self:CheckTeam(pCaptain)
    if not bOk then
        if szErr and szErr ~= "" then
            pCaptain.CenterMsg(szErr)
        end
        return false
    end
    
    local tbPlayers = {pCaptain, pOther}
    for _, pPlayer in ipairs(tbPlayers) do
        local nItemId, nNeed = self.nPutItemId, 1
        local nCount = pPlayer.GetItemCountInBags(nItemId)
        if nCount < nNeed then
            local szName = KItem.GetItemShowInfo(nItemId, pPlayer.nFaction, pPlayer.nSex)
            pCaptain.CenterMsg(string.format("%s身上沒有%s", pPlayer.szName, szName), true)
            return false
        end

        local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
        if tbSaveData.bJoined then
            pCaptain.CenterMsg(string.format("%s已經參加過了", pPlayer.szName), true)
            return false
        end
    end
    return true, pOther
end

function tbAct:SendConfirmMsgBox(nMyId, nOtherId, szMsg)
    local pOther = KPlayer.GetPlayerObjById(nOtherId)
    if not pOther then
        return
    end

    local tbCZQQAct = Activity:GetClass("ChuanZhenQiQiaoAct")
    local bOtherFinished = tbCZQQAct:FinishedToday(pOther)
    if not bOtherFinished then
        local pPlayer = KPlayer.GetPlayerObjById(nMyId)
        if pPlayer then
            pPlayer.CenterMsg("請等待隊友確定", true)
        end
        pOther.MsgBox(szMsg, {
            {"去意已決", function()
                self:TryEnterMap(nMyId, nOtherId)
            end}, {"我再想想", function()
                local pPlayer = KPlayer.GetPlayerObjById(nMyId)
                if pPlayer then
                    pPlayer.CenterMsg("隊友拒絕參加", true)
                end
            end}
        })
    else
        local pPlayer = KPlayer.GetPlayerObjById(nMyId)
        if pPlayer then
            pPlayer.CenterMsg("請等待隊友確定", true)
        end
        pOther.MsgBox("隊長正開啟相會鵲橋活動，是否前往？", {
            {"確定", function()
                self:TryEnterMap(nMyId, nOtherId)
            end}, {"取消", function()
                local pPlayer = KPlayer.GetPlayerObjById(nMyId)
                if pPlayer then
                    pPlayer.CenterMsg("隊友拒絕參加", true)
                end
            end}
        })
    end
end

function tbAct:TryApply()
    local bOk, pOther = self:CheckBeforeEnter(me)
    if not bOk then
        return
    end

    local tbCZQQAct = Activity:GetClass("ChuanZhenQiQiaoAct")
    local bMeFinished = tbCZQQAct:FinishedToday(me)

    local nMyId, nOtherId = me.dwID, pOther.dwID
    local szMsg = "大俠今天的穿針乞巧任務還未完成，還可獲得鵲之靈，更多的鵲之靈會提高自己在相會鵲橋活動中的成績，是否暫緩參與相會鵲橋？"
    if not bMeFinished then
        me.MsgBox(szMsg, {
            {"去意已決", function()
                self:SendConfirmMsgBox(nMyId, nOtherId, szMsg)
            end},
            {"我再想想"}
        })
    else
        self:SendConfirmMsgBox(nMyId, nOtherId, szMsg)
    end
end

function tbAct:TryEnterMap(nPlayer1, nPlayer2)
    local pCaptain = KPlayer.GetPlayerObjById(nPlayer1)
    if not pCaptain then
        return
    end
    if not self:CheckBeforeEnter(pCaptain) then
        return
    end

    Fuben:ApplyFuben(nPlayer1, self.nMapTemplateId, 
        function(nMapId)
            local pPlayer1 = KPlayer.GetPlayerObjById(nPlayer1)
            local pPlayer2 = KPlayer.GetPlayerObjById(nPlayer2)
            if not pPlayer1 or not pPlayer2 then
                Log("[x] QueQiaoXiangHuiAct:TryEnterMap, player offline", nPlayer1, nPlayer2)
                return
            end

            for _, pPlayer in ipairs({pPlayer1, pPlayer2}) do
                local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
                tbSaveData.bJoined = true
                self:SaveDataToPlayer(pPlayer, tbSaveData)

                pPlayer.SetEntryPoint()
                pPlayer.SwitchMap(nMapId, 0, 0)
            end
        end,
        function ()
            Log("[x] QueQiaoXiangHuiAct:TryEnterMap, create map fail", nPlayer1, nPlayer2)
        end, nPlayer1, nPlayer2)
    Log("QueQiaoXiangHuiAct:TryEnterMap", nPlayer1, nPlayer2)
end

function tbAct:CheckTeam(pPlayer)
    if not pPlayer.dwTeamID or pPlayer.dwTeamID == 0 then
        return false, "你還沒有隊伍"
    end
 
    local tbTeam = TeamMgr:GetTeamById(pPlayer.dwTeamID)
    if tbTeam:GetCaptainId() ~= pPlayer.dwID then
        return false, "你不是隊長無權操作！"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, "隊伍必須為一男一女兩人隊伍！"
    end

    local dwMember = tbMember[1] == pPlayer.dwID and tbMember[2] or tbMember[1]
    local pMember = KPlayer.GetPlayerObjById(dwMember)
    if not pMember then
        return false, "沒找到隊友"
    end

    if pPlayer.nSex == pMember.nSex then
        return false, "隊伍必須為一男一女兩人隊伍！"
    end

    local nMapId1 = pPlayer.GetWorldPos()
    local nMapId2 = pMember.GetWorldPos()
    if nMapId1 ~= nMapId2 or pPlayer.GetNpc().GetDistance(pMember.GetNpc().nId) > Npc.DIALOG_DISTANCE * 3 then
        return false, "有隊員不在附近！"
    end

    return true, nil, pMember
end

function tbAct:CheckPlayer(pPlayer)
    if pPlayer.nLevel < self.nJoinLevel then
        return false, string.format("請先將等級提升至%d", self.nJoinLevel)
    end
    return true
end

tbAct.tbValidReqs = {
    Put = true,
    Delete = true,
    Ready = true,
    Cancel = true,
}
function tbAct:OnClientReq(pPlayer, szType, ...)
    if not self.tbValidReqs[szType] then
        return
    end

    local fn = self["OnReq_"..szType]
    if not fn then
        return
    end

    local bOk, szErr = fn(self, pPlayer, ...)
    if not bOk then
        if szErr and szErr~="" then
            pPlayer.CenterMsg(szErr)
            return
        end
    end
end

function tbAct:OnReq_Put(pPlayer)
    if pPlayer.nMapTemplateId ~= self.nMapTemplateId then
        return false, "不在活動地圖內"
    end
    local tbFubenInst = Fuben.tbFubenInstance[pPlayer.nMapId]
    if not tbFubenInst or not tbFubenInst.PutNpc then
        return false
    end
    return tbFubenInst:PutNpc(pPlayer)
end

function tbAct:OnReq_Delete(pPlayer, nNpcId)
    if pPlayer.nMapTemplateId ~= self.nMapTemplateId then
        return false, "不在活動地圖內"
    end
    local tbFubenInst = Fuben.tbFubenInstance[pPlayer.nMapId]
    if not tbFubenInst or not tbFubenInst.DeleteNpc then
        return false, "不在活動地圖內"
    end
    return tbFubenInst:DeleteNpc(pPlayer, nNpcId)
end

function tbAct:OnReq_Ready(pPlayer)
    if pPlayer.nMapTemplateId ~= self.nMapTemplateId then
        return false, "不在活動地圖內"
    end
    local tbFubenInst = Fuben.tbFubenInstance[pPlayer.nMapId]
    if not tbFubenInst or not tbFubenInst.Ready then
        return false, "不在活動地圖內"
    end
    return tbFubenInst:Ready(pPlayer)
end

function tbAct:OnReq_Cancel(pPlayer)
    if pPlayer.nMapTemplateId ~= self.nMapTemplateId then
        return false, "不在活動地圖內"
    end
    local tbFubenInst = Fuben.tbFubenInstance[pPlayer.nMapId]
    if not tbFubenInst or not tbFubenInst.CancelReady then
        return false, "不在活動地圖內"
    end
    return tbFubenInst:CancelReady(pPlayer)
end

function tbAct:GainItem(pPlayer, nItemId, nCount)
    if not nCount or nCount<=0 then
        return
    end
    local _, nEndTime = self:GetOpenTimeInfo()
    local tbAward = {{"item", nItemId, nCount}}
    tbAward = self:FormatAward(tbAward, nEndTime)
    pPlayer.SendAward(tbAward, true, true, Env.LogWay_Qixi)
    Log("QueQiaoXiangHuiAct:GainItem", pPlayer.dwID, nCount)
end

function tbAct:FormatAward(tbAward, nEndTime)
    if not MODULE_GAMESERVER or not Activity:__IsActInProcessByType("QueQiaoXiangHuiAct") or not nEndTime then
        return tbAward
    end
    local tbFormatAward = Lib:CopyTB(tbAward or {})
    for _, v in ipairs(tbFormatAward) do
        if v[1] == "item" or v[1] == "Item" then
            v[4] = nEndTime
        end
    end
    return tbFormatAward
end