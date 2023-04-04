local tbAct = Activity:GetClass("ChuanZhenQiQiaoAct")
tbAct.tbTimerTrigger = {
    [1] = {szType = "Day", Time = "10:00" , Trigger = "SendWorldNotify" },
    [2] = {szType = "Day", Time = "13:00" , Trigger = "SendWorldNotify" },
    [3] = {szType = "Day", Time = "20:00" , Trigger = "SendWorldNotify" },
}
tbAct.tbTrigger = {
	Init={},
	Start={
        {"StartTimerTrigger", 1},
        {"StartTimerTrigger", 2},
        {"StartTimerTrigger", 3},
    },
	End={},
    SendWorldNotify = { {"WorldMsg", "各位少俠，七夕節活動開始了，大家可通過查詢“最新消息”瞭解活動內容！", 20} },
    OpenAct = {},
    CloseAct = {},
}

function tbAct:OnTrigger(szTrigger)
    Log("ChuanZhenQiQiaoAct:OnTrigger", szTrigger)
    if szTrigger=="Start" then
        local _, nEndTime = self:GetOpenTimeInfo()
        self:RegisterDataInPlayer(nEndTime)

        Activity:RegisterNpcDialog(self, self.nDialogNpcId, {Text = "穿針乞巧", Callback = self.TryApply, Param = {self}})

        Activity:RegisterPlayerEvent(self, "Act_EverydayTargetGainAward", "OnEverydayTargetGainAward")
        Activity:RegisterPlayerEvent(self, "Act_ChuanZhenQiQiaoReq", "OnClientReq")
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin")
	end
end

function tbAct:FinishedToday(pPlayer)
    local _, tbRunning = Activity:GetActivityData()
    if not tbRunning.ChuanZhenQiQiaoAct then
        return true
    end

    local tbInst = tbRunning.ChuanZhenQiQiaoAct.tbInst
    local tbSaveData = tbInst:GetDataFromPlayer(pPlayer.dwID) or {}
    return not Lib:IsDiffDay(4*3600, GetTime(), tbSaveData.nLastJoinTime or 0)
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
        local nItemId, nNeed = unpack(self.tbDialogItems[pPlayer.nSex])
        local nCount = pPlayer.GetItemCountInBags(nItemId)
        if nCount < nNeed then
            local szName = KItem.GetItemShowInfo(nItemId, pPlayer.nFaction, pPlayer.nSex)
            pCaptain.CenterMsg(string.format("%s身上沒有%s，快去收集吧！", pPlayer.szName, szName), true)
            return false
        end
    end
    return true, pOther
end

function tbAct:TryApply()
    local bOk, pOther = self:CheckBeforeEnter(me)
    if not bOk then
        return
    end

    TeamMgr:SetAutoAgree(false)
    local nMyId, nOtherId = me.dwID, pOther.dwID
    me.CenterMsg("請等待隊友確定", true)
    pOther.MsgBox("隊長正開啟穿針乞巧活動，是否前往？", {
        {"確定", function()
            self:TryJoin(nMyId, nOtherId)
        end}, {"取消", function()
            local pPlayer = KPlayer.GetPlayerObjById(nMyId)
            if pPlayer then
                pPlayer.CenterMsg("隊友拒絕參加", true)
            end
        end}
    })
end

function tbAct:TryJoin(nCaptainId, nOtherId)
    local pCaptain = KPlayer.GetPlayerObjById(nCaptainId)
    if not pCaptain then
        return
    end

    local bOk, pOther = self:CheckBeforeEnter(pCaptain)
    if not bOk then
        return
    end

    self:NewMatch(nCaptainId, nOtherId)
end

function tbAct:NewMatch(nPlayer1, nPlayer2)
    self.nMatchIdx = (self.nMatchIdx or 0) + 1
    self.tbMatches = self.tbMatches or {}
    self.tbMatches[self.nMatchIdx] = {
        nMatchIdx = self.nMatchIdx,
        tbPlayers = {
            [nPlayer1] = false,
            [nPlayer2] = false,
        },
        nStartTime = 0,
        bFemaleAnswer = true,
        fnNext = Lib:GetRandomSelect(#self.tbQuestions),
        nRight = 0,
        nQuestionId = 0,
    }
    self.tbPlayerMatchMap = self.tbPlayerMatchMap or {}
    self.tbPlayerMatchMap[nPlayer1] = self.nMatchIdx
    self.tbPlayerMatchMap[nPlayer2] = self.nMatchIdx

    self:SyncMatchState(self.tbMatches[self.nMatchIdx])
end

function tbAct:SyncMatchState(tbMatch)
    local tbState = {
        tbPlayers = tbMatch.tbPlayers,
        bStarted = tbMatch.nStartTime > 0,
    }
    for nPlayerId in pairs(tbMatch.tbPlayers) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if pPlayer then
            pPlayer.CallClientScript("Activity.ChuanZhenQiQiaoAct:OnSyncMatchState", tbState)
        end
    end
end

function tbAct:GetMatch(pPlayer)
    self.tbMatches = self.tbMatches or {}
    self.tbPlayerMatchMap = self.tbPlayerMatchMap or {}
    local nMatchIdx = self.tbPlayerMatchMap[pPlayer.dwID] or 0
    return self.tbMatches[nMatchIdx]
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
    Ready = true,
    Answer = true,
    SyncAnswer = true,
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

function tbAct:OnReq_Ready(pPlayer)
    local tbMatch = self:GetMatch(pPlayer)
    if not tbMatch then
        Log("[x] ChuanZhenQiQiaoAct:OnReq_Ready, no match", pPlayer.dwID)
        return
    end

    local nNow = GetTime()
    if tbMatch.nStartTime > 0 and nNow - tbMatch.nStartTime <= self.nMatchTime then
        Log("[x] ChuanZhenQiQiaoAct:OnReq_Ready, already start", pPlayer.dwID, nNow, tbMatch.nStartTime)
        return
    end

    tbMatch.tbPlayers[pPlayer.dwID] = true

    self:CheckStart(tbMatch)
    self:SyncMatchState(tbMatch)
end

function tbAct:OnReq_SyncAnswer(pPlayer, nQuestionId, nAnswerIdx)
    local tbMatch = self:GetMatch(pPlayer)
    if not tbMatch then
        return
    end

    if nQuestionId ~= tbMatch.nQuestionId then
        return
    end

    for nPlayerId in pairs(tbMatch.tbPlayers) do
        if pPlayer.dwID ~= nPlayerId then
            local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
            if pPlayer then
                pPlayer.CallClientScript("Activity.ChuanZhenQiQiaoAct:OnSyncAnswer", nAnswerIdx)
            end
        end
    end
end

function tbAct:OnReq_Answer(pPlayer, nQuestionId, nAnswerIdx)
    local tbMatch = self:GetMatch(pPlayer)
    if not tbMatch then
        return
    end

    if nQuestionId ~= tbMatch.nQuestionId then
        return
    end

    if GetTime() - tbMatch.nStartTime > self.nMatchTime then
        self:MatchOver(tbMatch, true)
        return
    end

    if pPlayer.nSex ~= (tbMatch.bFemaleAnswer and Player.SEX_FEMALE or Player.SEX_MALE) then
        pPlayer.CenterMsg("請讓隊友答題")
        return
    end

    local bNewQuestion = true
    if self:IsAnswerRight(tbMatch.nQuestionId, nAnswerIdx) then
        tbMatch.nRight = tbMatch.nRight + 1
        self:SendBlackBoardMsg(tbMatch, tbMatch.bFemaleAnswer and "女俠成功答對問題，獲得織女幫助！" or "大俠成功答對問題，獲得織女幫助！")
        if tbMatch.nRight >= self.nAnswerCount then
            self:MatchOver(tbMatch, false)
            return
        end
    else
        self:SendBlackBoardMsg(tbMatch, tbMatch.bFemaleAnswer and "女俠答錯啦，換人來答！" or "大俠答錯啦，下一題！")
        if tbMatch.bFemaleAnswer then
            tbMatch.bFemaleAnswer = false
            bNewQuestion = false
        else
            tbMatch.bFemaleAnswer = true
        end
    end

    local tbData = self:GetQuestion(tbMatch, not bNewQuestion)
    for nPlayerId in pairs(tbMatch.tbPlayers) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if pPlayer then
            pPlayer.CallClientScript("Activity.ChuanZhenQiQiaoAct:OnUpdateData", tbData)
        end
    end
end

function tbAct:SendBlackBoardMsg(tbMatch, szMsg)
    for nPlayerId in pairs(tbMatch.tbPlayers) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if pPlayer then
            Dialog:SendBlackBoardMsg(pPlayer, szMsg)
        end
    end
end

function tbAct:GetReward(nTimeUsed, bTimeout, nRight)
    nRight = nRight or 0

    local tbSettings = bTimeout and self.tbRewards.tbNotFinished or self.tbRewards.tbFinished
    local nCmpValue = bTimeout and nRight or nTimeUsed
    for _, tb in ipairs(tbSettings) do
        local nValue, szJudge, nCount, tbRewards = unpack(tb)
        if nCmpValue <= nValue then
            return szJudge, nCount, tbRewards
        end
    end
    return "", 0, {}
end

function tbAct:MatchOver(tbMatch, bTimeout)
    self.tbPlayerMatchMap = self.tbPlayerMatchMap or {}
    local nTimeUsed = GetTime() - tbMatch.nStartTime

    local szJudge, nCount, tbExtRewards = self:GetReward(nTimeUsed, bTimeout, tbMatch.nRight)
    local szMsg = bTimeout and string.format("兩位大俠在本次穿針乞巧中並未完成任務，實在可惜，評價為[FFFE0D]%s[-]，獲得[FFFE0D]鵲之靈%d個[-]！", szJudge, nCount) or
        string.format("兩位大俠在本次穿針乞巧中共計耗時[FFFE0D]%s[-]，評價為[FFFE0D]%s[-]，獲得[FFFE0D]鵲之靈%d個[-]！", Lib:TimeDesc(nTimeUsed), szJudge, nCount)

    local tbMail = {Title = "穿針乞巧", From = "月老", nLogReazon = Env.LogWay_Qixi}
    tbMail.Text = szMsg
    tbMail.tbAttach = {}
    if nCount > 0 then
        local _, nEndTime = self:GetOpenTimeInfo()
        table.insert(tbMail.tbAttach, {"item", self.nAnswerRewardItemId, nCount, nEndTime})
    end
    for _, tb in ipairs(tbExtRewards or {}) do
        table.insert(tbMail.tbAttach, tb)
    end

    for nPlayerId in pairs(tbMatch.tbPlayers) do
        tbMail.To = nPlayerId
        Mail:SendSystemMail(tbMail)

        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if pPlayer then
            pPlayer.MsgBox(szMsg, {{"知道了"}})
            pPlayer.CallClientScript("Ui:CloseWindow", "ChuanZhenQiQiaoPanel")
        end

        self.tbPlayerMatchMap[nPlayerId] = nil
    end
    self.tbMatches = self.tbMatches or {}
    self.tbMatches[tbMatch.nMatchIdx] = nil
end

function tbAct:CheckStart(tbMatch)
    for _, bReady in pairs(tbMatch.tbPlayers) do
        if not bReady then
            return
        end
    end

    local nNow = GetTime()
    tbMatch.nStartTime = nNow

    local tbData = self:GetQuestion(tbMatch)
    for nPlayerId in pairs(tbMatch.tbPlayers) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if not pPlayer then
            Log("[x] ChuanZhenQiQiaoAct:CheckStart, player offline", nPlayerId)
            return
        end

        local tbSaveData = self:GetDataFromPlayer(nPlayerId) or {}
        tbSaveData.nLastJoinTime = nNow
        self:SaveDataToPlayer(pPlayer, tbSaveData)

        local nItemId, nNeed = unpack(self.tbDialogItems[pPlayer.nSex])
        pPlayer.ConsumeItemInBag(nItemId, nNeed, Env.LogWay_Qixi)

        pPlayer.CallClientScript("Activity.ChuanZhenQiQiaoAct:OnUpdateData", tbData)
    end
end

function tbAct:GetQuestion(tbMatch, bNotNext)
    if not bNotNext then
        tbMatch.bFemaleAnswer = true
        tbMatch.nQuestionId = tbMatch.fnNext()
    end

    return {
        nQuestionId = tbMatch.nQuestionId,
        bFemaleAnswer = tbMatch.bFemaleAnswer,
        nRight = tbMatch.nRight,
        nTimeLeft = tbMatch.nStartTime + self.nMatchTime - GetTime(),
    }
end

function tbAct:OnEverydayTargetGainAward(pPlayer, nAwardIdx)
    if not self:CheckPlayer(pPlayer) then
        return
    end
    for _, tb in ipairs(self.tbTargetRewards[pPlayer.nSex][nAwardIdx] or {}) do
        local nItemId, nCount = unpack(tb)
        if nCount and nCount > 0 then
            self:GainItem(pPlayer, nItemId, nCount)
            Log("ChuanZhenQiQiaoAct:OnEverydayTargetGainAward", pPlayer.dwID, nAwardIdx, nCount)
        end
    end
end

function tbAct:GainItem(pPlayer, nItemId, nCount)
    if not nCount or nCount<=0 then
        return
    end
    local _, nEndTime = self:GetOpenTimeInfo()
    local tbAward = {{"item", nItemId, nCount}}
    tbAward = self:FormatAward(tbAward, nEndTime)
    pPlayer.SendAward(tbAward, true, true, Env.LogWay_Qixi)
    Log("ChuanZhenQiQiaoAct:GainItem", pPlayer.dwID, nCount)
end

function tbAct:FormatAward(tbAward, nEndTime)
    if not MODULE_GAMESERVER or not Activity:__IsActInProcessByType("ChuanZhenQiQiaoAct") or not nEndTime then
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

function tbAct:GetUiData()
    if not self.tbUiData then
        local tbData = {}
        tbData.nShowLevel = 20
        tbData.szTitle = "七夕活動"
        tbData.nBottomAnchor = 0

        local nStartTime, nEndTime = self:GetOpenTimeInfo()
        local tbTime1 = os.date("*t", nStartTime)
        local tbTime2 = os.date("*t", nEndTime)
        tbData.szContent = string.format([[活動時間：[c8ff00]%s年%s月%s日%d點%d分-%s年%s月%s日%s點%d分[-]
七夕活動開始了！
]], tbTime1.year, tbTime1.month, tbTime1.day, tbTime1.hour, tbTime1.min, tbTime2.year, tbTime2.month, tbTime2.day, tbTime2.hour, tbTime2.min)
        tbData.tbSubInfo = {}
        table.insert(tbData.tbSubInfo, {szType = "Item2", szInfo = [[[FFFE0D]活躍達成 材料收集[-]
活動期間每天少俠打開[FFFE0D]活躍寶箱[-]都會獲得一些材料，男性少俠可將自己獲得的材料合成[ff578c][url=openwnd:五彩線, ItemTips, "Item", nil, 9445][-]，女性少俠可將自己獲得的材料合成[ff578c][url=openwnd:九孔針, ItemTips, "Item", nil, 9448][-]，每天[FFFE0D]活躍度滿[-]，恰好能合成[FFFE0D]1次[-]哦！

[FFFE0D]攜手前行 穿針乞巧[-]
兩位異性少俠手中各持有[ff578c][url=openwnd:五彩線, ItemTips, "Item", nil, 9445][-]和[ff578c][url=openwnd:九孔針, ItemTips, "Item", nil, 9448][-]後，可以組隊前往襄陽城[FFFE0D][url=npc:月老, 2371, 10][-]處與其對話參與[FFFE0D]穿針乞巧[-]活動。
活動中女性少俠通過[FFFE0D]答對[-]織女的問題來獲得織女的幫助，每答對[FFFE0D]1[-]次織女都會説明兩位元穿[FFFE0D]1[-]次針，直至答對[FFFE0D]9[-]次穿針完畢，最後根據[FFFE0D]耗時[-]確定評價，最高可獲得[FFFE0D]得巧[-]評價，不同評價會獲得不同獎勵。
女俠過程中答錯也沒關係，男性少俠可以有1次[FFFE0D]補答[-]的機會，答對照樣可以獲得織女的幫助。

[FFFE0D]欣賞美景 相會鵲橋[-]
活動的[FFFE0D]最後一天晚上18：00後[-]會限時開啟[FFFE0D]相會鵲橋[-]活動，需要兩位元異性少俠組隊持穿針乞巧過程中獲得的[aa62fc][url=openwnd:鵲之靈, ItemTips, "Item", nil, 9449][-]前往襄陽城[FFFE0D][url=npc:月老, 2371, 10][-]處與其對話參與[FFFE0D]相會鵲橋[-]活動。
兩位元少俠需要使用自己的[aa62fc][url=openwnd:鵲之靈, ItemTips, "Item", nil, 9449][-]賦予其生命將其擺放到橋面上，搭建屬於兩個人的鵲橋。雙方均擺放完畢自己手中的[aa62fc][url=openwnd:鵲之靈, ItemTips, "Item", nil, 9449][-]並且點擊[FFFE0D]準備完畢[-]按鈕之後，此時會根據兩位元少俠擺放喜鵲的[FFFE0D]數量、均勻程度、覆蓋面積[-]等要素評分，滿分為[FFFE0D]100分[-]，得分越高獲得的獎勵越高！得分超過80分的還可以獲得稀有頭像框[ff578c][url=openwnd:頭像框·金風玉露一相逢, ItemTips, "Item", nil, 9450][-]！
]]})

        self.tbUiData = tbData
    end
    return self.tbUiData
end

function tbAct:OnLogin(pPlayer)
    local tbMatch = self:GetMatch(pPlayer)
    if not tbMatch then
        return
    end

    self:SyncMatchState(tbMatch)
    if tbMatch.nStartTime > 0 then
        local tbData = self:GetQuestion(tbMatch, true)
        pPlayer.CallClientScript("Activity.ChuanZhenQiQiaoAct:OnUpdateData", tbData)
    end
end