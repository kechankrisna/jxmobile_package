Kin.MonsterNian = Kin.MonsterNian or {}
local KinMonsterNian = Kin.MonsterNian

function KinMonsterNian:OnActOpen()
	self.bEnabled = true
	self.bMonsterBorn = false
	self:ClearData()
	self:ClearScore()
end

function KinMonsterNian:OnActClose()
	self.bMonsterBorn = false
	Kin:TraverseKin(function(tbKinData)
		self:OnFinish(tbKinData)
	end)
	self:ClearData()
	self.bEnabled = false
end

function KinMonsterNian:IsEnabled()
	return self.bEnabled
end

function KinMonsterNian:ClearData()
	self.tbLanterns = {}
	self.tbMonsters = {}
	self.tbGatherBoxes = {}
end

function KinMonsterNian:ClearScore()
	self.tbScores = {}
end

function KinMonsterNian:GetKinScore(nKinId)
	local nTotal = 0
	for nPlayerId, nScore in pairs(self.tbScores[nKinId] or {}) do
		if type(nPlayerId)=="number" then
			nTotal = nTotal+nScore
		end
	end
	return nTotal
end

function KinMonsterNian:AddScore(pPlayer, nAdd)
	if not self:IsEnabled() then
		return
	end

	local nKinId = pPlayer.dwKinId
	local nPlayerId = pPlayer.dwID
	if not nKinId or nKinId<=0 then
		Log("[x] KinMonsterNian:AddScore, no kin", nPlayerId, nAdd)
		return
	end

	self.tbScores[nKinId] = self.tbScores[nKinId] or {nVersion = 0}
	self.tbScores[nKinId][nPlayerId] = (self.tbScores[nKinId][nPlayerId] or 0)+nAdd
	self.tbScores[nKinId].nVersion = self.tbScores[nKinId].nVersion+1
	self.tbScores[nKinId].nTime = GetTime()
	Log("KinMonsterNian:AddScore", nKinId, nPlayerId, nAdd)
end

function KinMonsterNian:RemoveScore(nKinId, nPlayerId)
	if not self.tbScores[nKinId] then
		return
	end
	self.tbScores[nKinId][nPlayerId] = nil
	Log("KinMonsterNian:RemoveScore", nKinId, nPlayerId)
end

function KinMonsterNian:OnLogin(pPlayer)
	if pPlayer.nMapTemplateId~=Kin.Def.nKinMapTemplateId then
		return
	end
	self:OnEnterKinMap(pPlayer)
end

function KinMonsterNian:OnEnterKinMap(pPlayer)
	if self.bEnabled then
		pPlayer.CallClientScript("Ui:OpenWindow", "UseItemPop", {
			nTempId = Kin.MonsterNianDef.nFireworkId,
			nCD = Kin.MonsterNianDef.nFireworkCD,
			szAtlas = Kin.MonsterNianDef.szFireworkUseAtlas,
			szSprite = Kin.MonsterNianDef.szFireworkUseSprite,
		})
		pPlayer.CallClientScript("Player:ServerSyncData", "KinMonsterNianOpened",  1)
	end
	self:UpdateMiniMap(pPlayer)
end

function KinMonsterNian:OnLeaveKinMap(pPlayer)
	pPlayer.CallClientScript("Ui:CloseWindow", "UseItemPop")
	pPlayer.CallClientScript("Player:ServerSyncData", "KinMonsterNianOpened",  0)
end

function KinMonsterNian:Open(nKinId)
	if not self.bEnabled then
		return false, "Hoạt động chưa mở"
	end

	local tbKin = Kin:GetKinById(nKinId)
	if not tbKin then
		Log("[x] KinMonsterNian:Open, no kin", tostring(nKinId))
		return false, "Chưa có bang hội"
	end

	local nMapId = tbKin:GetMapId()
	if not nMapId or nMapId<=0 then
		return false, "Chưa có lãnh địa bang hội"
	end

	for _, nSec in ipairs(Kin.MonsterNianDef.tbLanternCreateTimes) do
		if nSec<=0 then nSec=1 end
		Timer:Register(Env.GAME_FPS*nSec, self.CreateLanterns, self, tbKin)
	end
	for _, nSec in ipairs(Kin.MonsterNianDef.tbCleanLanternTimes) do
		if nSec<=0 then nSec=1 end
		Timer:Register(Env.GAME_FPS*nSec, self.ClearLanterns, self, nKinId)
	end
	Timer:Register(Env.GAME_FPS*Kin.MonsterNianDef.nMonsterCreateTime, self.CreateMonster, self, tbKin)

	local tbPlayer = KPlayer.GetMapPlayer(nMapId)
	for _, pPlayer in ipairs(tbPlayer or {}) do
		self:OnEnterKinMap(pPlayer)
	end

	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, "Trong 30 giây sẽ xuất hiện rất nhiều lồng đèn trong lãnh địa bang hội, hãy đi xem có những gì nào!", nKinId)

	return true
end

function KinMonsterNian:CreateMonster(tbKin)
	local nKinId = tbKin.nKinId
	local nMapId = tbKin:GetMapId()
	if not nMapId or nMapId<=0 then
		Log("[x] KinMonsterNian:CreateMonster, map nil", nKinId)
		return
	end
	local nX, nY = unpack(Kin.MonsterNianDef.tbMonsterBornPos)
	local pMonster = KNpc.Add(Kin.MonsterNianDef.nMonsterId, 1, 0, nMapId, nX, nY)
	self.tbMonsters[nKinId] = pMonster.nId
	pMonster.nKinId = nKinId

	local tbMapSetting = Map:GetMapSetting(Kin.Def.nKinMapTemplateId)
    local szMsg = string.format("Niên thú xuất hiện tại <%s(%d,%d)>, xin mọi người nhanh đi khu vực niên thú!", tbMapSetting.MapName, math.floor(nX*Map.nShowPosScale), math.floor(nY*Map.nShowPosScale))
    local tbLinkData = {
        nLinkType = ChatMgr.LinkType.Position,
        nMapId = Kin.Def.nKinMapTemplateId,
        nX = nX,
        nY = nY,
        nMapTemplateId = Kin.Def.nKinMapTemplateId,
    }
    ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId, tbLinkData)

    self.bMonsterBorn = true
    local tbPlayers = KPlayer.GetMapPlayer(nMapId)
    for _, pPlayer in ipairs(tbPlayers or {}) do
    	self:UpdateMiniMap(pPlayer)
    end
end

function KinMonsterNian:UpdateMiniMap(pPlayer)
	pPlayer.CallClientScript("Kin:OnSynMiniMainMapInfo", self:IsEnabled(pPlayer.dwKinId) and self.bMonsterBorn)
end

function KinMonsterNian:GetKinScoreRewardBoxTimes(nKinId)
	local nTotalScore = self:GetKinScore(nKinId)
	local nRet = 0
	for _, tb in ipairs(Kin.MonsterNianDef.tbKinScoreRewardBoxTimes) do
		local nMinScore, nTotal = unpack(tb)
		if nTotalScore>=nMinScore then
			nRet = nTotal
			break
		end
	end
	return nRet
end

function KinMonsterNian:SendScoreRewards(nKinId)
	local tbKin = Kin:GetKinById(nKinId)
	if not tbKin then
		Log("[x] KinMonsterNian:SendScoreRewards, kin nil", nKinId)
		return
	end
	local nMapId = tbKin:GetMapId()
	if not self.bEnabled or not nMapId then
		Log("KinMonsterNian:CreateGatherBoxes return", nKinId, tostring(self.bEnabled), tostring(nMapId))
		return
	end

	self.tbGatherBoxes[nKinId] = self.tbGatherBoxes[nKinId] or {}
    local nTimes = self:GetKinScoreRewardBoxTimes(nKinId)
    local nPlayerCount = 0
    local tbPlayers = KPlayer.GetMapPlayer(nMapId)
    for _, pPlayer in ipairs(tbPlayers or {}) do
    	if pPlayer.nLevel>=Kin.MonsterNianDef.nMinJoinLevel then
    		nPlayerCount = nPlayerCount+1
    	end
    end
    local nCount = nTimes*nPlayerCount
    for i=1, nCount do
    	local tbGatherBoxPos = Kin.MonsterNianDef.tbGatherBoxPos
        local tbPos = tbGatherBoxPos[MathRandom(#tbGatherBoxPos)]
        local nX, nY = unpack(tbPos)
        local pNpc = KNpc.Add(Kin.MonsterNianDef.nMonsterRewardId, 1, 0, nMapId, nX, nY)
        table.insert(self.tbGatherBoxes[nKinId], pNpc.nId)
    end

    if nCount>0 then
		local szMsg = "Niên thú ném ra rất nhiều bảo rương, mọi người nhanh đi mở ra xem!"
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId)
	end
	Log("KinMonsterNian:CreateGatherBoxes", nKinId, nPlayerCount, nTimes, nCount)
end

function KinMonsterNian:DeleteMonster(nNpcID)
	local pMonster = KNpc.GetById(nNpcID or 0)
	if not pMonster then return end
	pMonster.Delete()
end

function KinMonsterNian:MonsterLeave(nKinId)
	local nMonsterId = self.tbMonsters[nKinId]
	local pMonster = KNpc.GetById(nMonsterId or 0)
	if not pMonster then return end
	pMonster.AddSkillState(Kin.MonsterNianDef.nMonsterLeaveBuffId, 1, 0, 20*Env.GAME_FPS)
	pMonster.SetAi("Setting/Npc/Ai/KeepMoving.ini")
	pMonster.AI_ClearMovePathPoint()
    local x, y = unpack(Kin.MonsterNianDef.tbMonsterLeavePos)
    pMonster.AI_AddMovePos(x, y)
    pMonster.SetActiveForever(1)
    pMonster.AI_StartPath()
    pMonster.tbOnArrive = {self.DeleteMonster, self, nMonsterId}

    local tbKin = Kin:GetKinById(nKinId)
	local nMapId = tbKin:GetMapId()
    local tbPlayer = KPlayer.GetMapPlayer(nMapId)
    for _, pPlayer in ipairs(tbPlayer) do
    	pPlayer.CallClientScript("Ui:NpcBubbleTalk", nMonsterId, "A nha đau quá, đừng đánh nữa đừng đánh nữa, ta cũng không dám nữa!", 20)
    	self:UpdateMiniMap(pPlayer)
    end
	Log("KinMonsterNian:MonsterLeave", nKinId, nMonsterId)
end

function KinMonsterNian:OnFinish(tbKin)
	local nKinId = tbKin.nKinId
	self:ClearLanterns(nKinId)
	self:MonsterLeave(nKinId)

	self:SendScoreTitle(nKinId)
	self:SendScoreRewards(nKinId)
	self:GiveAuctionRewards(nKinId)

	Timer:Register(Env.GAME_FPS*Kin.MonsterNianDef.nClearGatherBoxDelay, self.ClearGatherBoxes, self, Lib:CopyTB(self.tbGatherBoxes[nKinId] or {}))

    ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, "Chúc mừng mọi người đồng tâm hiệp lực đuổi chạy Niên thú!", nKinId)
	Log("KinMonsterNian:OnFinish", nKinId)
end

function KinMonsterNian:SendScoreTitle(nKinId)
	local tbKinScore = self.tbScores[nKinId] or {}
	local nMaxScore = -1
	for nPlayerId, nScore in pairs(tbKinScore) do
		if type(nPlayerId)=="number" and nMaxScore<nScore then
			nMaxScore = nScore
		end
	end
	if nMaxScore<=0 then return end

	local nNow = GetTime()
	for nPlayerId, nScore in pairs(tbKinScore) do
		if type(nPlayerId)=="number" and nMaxScore==nScore then
			Mail:SendSystemMail({
				To = nPlayerId,
				Title = "Điểm thưởng cao nhất",
				Text = "Trong bang hội có số điểm tích lũy cao nhất, hãy nhận thưởng",
				From = "Hệ Thống",
				tbAttach = {{"AddTimeTitle", Kin.MonsterNianDef.nScoreTitleId, nNow+24*60*60}},
				nLogReazon = Env.LogWay_MonsterNianAct,
			})
			Log("KinMonsterNian:SendScoreTitle", nKinId, nPlayerId, nMaxScore)
		end
	end
end

function KinMonsterNian:GiveAuctionRewards(nKinId)
	local tbKinData = Kin:GetKinById(nKinId)
	if not tbKinData then
		Log("[x] KinMonsterNian:GiveAuctionRewards, kin nil", tostring(nKinId))
		return
	end

	local tbMembers = {}
	for nPlayerId in pairs(self.tbScores[nKinId] or {}) do
		if type(nPlayerId)=="number" then
			local pStay = KPlayer.GetRoleStayInfo(nPlayerId)
			if pStay and pStay.nLevel>=Kin.MonsterNianDef.nMinJoinLevel then
				tbMembers[nPlayerId] = true
			else
				Log("KinMonsterNian:GiveAuctionRewards, ignore player", nKinId, nPlayerId, pStay and pStay.nLevel or -1)
			end
		end
	end

	local nTotalScore = self:GetKinScore(nKinId)
	local nTotalValue = nTotalScore*Kin.MonsterNianDef.nValuePerScore
	local tbItems = {}
	local tbAuctionSettings = {}
	for _, v in ipairs(Kin.MonsterNianDef.tbAuctionSettings) do
		if GetTimeFrameState(v[1])==1 then
			tbAuctionSettings = v[2]
			break
		end
	end

	for _, tbSetting in ipairs(tbAuctionSettings) do
		local nItemId, nPercent, nSingleValue, nBatch = unpack(tbSetting)
		nBatch = nBatch or 1
		local nValue = math.floor(nPercent*nTotalValue)
		local nCount = math.floor(nValue/nSingleValue)
		local nMod = nValue%nSingleValue
		local bAdd = MathRandom(nSingleValue)<nMod
		if bAdd then
			nCount = nCount+1
		end
		if nCount>0 then
			table.insert(tbItems, {nItemId, nCount*nBatch})
			Log("KinMonsterNian:GiveAuctionRewards, addItem", nKinId, nItemId, nCount, nBatch)
		end
	end
	if next(tbItems) then
		Kin:AddAuction(nKinId, "MonsterNianAuction", tbMembers, tbItems)
		Log("KinMonsterNian:GiveAuctionRewards", nKinId, nTotalScore, nTotalValue, #tbItems)
	else
		local szMsg = "Lần tham gia đuổi niên thú này quá ít nên không có phần thưởng nào, hãy cố gắng lần sau nhé!"
   		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId)
		Log("KinMonsterNian:GiveAuctionRewards, no item", nKinId, nTotalScore, nTotalValue)
	end
end

function KinMonsterNian:ClearLanterns(nKinId)
	local tbKinFireworks = self.tbLanterns[nKinId] or {}
	if not next(tbKinFireworks) then
        return
    end

    for _, nId in ipairs(tbKinFireworks) do
        local pNpc = KNpc.GetById(nId)
        if pNpc then
            pNpc.Delete()
        end
    end
    self.tbLanterns[nKinId] = nil
end

function KinMonsterNian:CreateLanterns(tbKin)
	local nKinId = tbKin.nKinId
	local nMapId = tbKin:GetMapId()
	self:ClearLanterns(nKinId)
	if not self.bEnabled or not nMapId then
		Log("KinMonsterNian:CreateFireworks return", nKinId, tostring(self.bEnabled), tostring(nMapId))
		return
	end

    self.tbLanterns[nKinId] = self.tbLanterns[nKinId] or {}
    local nPlayerCount = 0
    local tbPlayers = KPlayer.GetMapPlayer(nMapId)
    for _, pPlayer in ipairs(tbPlayers or {}) do
    	if pPlayer.nLevel>=Kin.MonsterNianDef.nMinJoinLevel then
    		nPlayerCount = nPlayerCount+1
    	end
    end
    local nCount = math.floor(nPlayerCount*Kin.MonsterNianDef.nLanternsCountMult)
    for i = 1, nCount do
    	local tbLanternsPos = Kin.MonsterNianDef.tbLanternsPos
        local tbPos = tbLanternsPos[MathRandom(#tbLanternsPos)]
        local nX, nY = unpack(tbPos)
        local pNpc = KNpc.Add(Kin.MonsterNianDef.nLanternPickNpcId, 1, 0, nMapId, nX, nY)
        pNpc.nQuestionId = MathRandom(#Activity:GetClass("MonsterNianAct").tbQuestions)
        table.insert(self.tbLanterns[nKinId], pNpc.nId)
    end

	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, "Những chiếc đèn lồng đỏ được treo cao và năm mới đã đến. Hãy cùng xem những gì ẩn giấu bên trong!", nKinId)
	Log("KinMonsterNian:CreateLanterns", nKinId, nPlayerCount)
end

function KinMonsterNian:ClearGatherBoxes(tbGatherBoxes)
	if not next(tbGatherBoxes or {}) then
        return
    end

    for _, nId in ipairs(tbGatherBoxes) do
        local pNpc = KNpc.GetById(nId)
        if pNpc then
            pNpc.Delete()
        end
    end
end

function KinMonsterNian:Answer(pPlayer, nNpcId, nQuestionId, nAnswerId)
	if not self:IsEnabled() then
		return false, "Hoạt động chưa mở"
	end

    local pNpc = KNpc.GetById(nNpcId)
    if not pNpc or pNpc.IsDelayDelete() then
        return false, "Đã được người khác thu thập"
    end

    local nPlayerId = pPlayer.dwID
    pNpc.tbAnsweredPids = pNpc.tbAnsweredPids or {}
    pNpc.tbAnsweredPids[nPlayerId] = true

    local tbQuestion = Activity:GetClass("MonsterNianAct"):GetQuestion(nQuestionId)
    if not tbQuestion then
    	Log("[x] KinMonsterNian:Answer", nPlayerId, nQuestionId, nAnswerId)
    	return false
    end

    if tbQuestion.nAnswerId==nAnswerId then
    	pNpc.Delete()
	    local nCount = MathRandom(Kin.MonsterNianDef.tbLanternRewardCount[1], Kin.MonsterNianDef.tbLanternRewardCount[2])
	    pPlayer.SendAward({
	    	{"Item", Kin.MonsterNianDef.nFireworkId, nCount, self:GetItemTimeout()},
	    	{"Coin", Kin.MonsterNianDef.nLanternRewardCoin},
	    }, false, true, Env.LogWay_MonsterNianAct)
	    Log("KinMonsterNian:Answer", nPlayerId, nNpcId, nCount)
	    pPlayer.CenterMsg("Câu trả lời là chính xác!")
    else
	    Dialog:SendBlackBoardMsg(pPlayer, "Trả lời thất bại, đi xem những chiếc đèn lồng khác!")
    end

    return true
end

function KinMonsterNian:GetItemTimeout()
	local tbDeadline = os.date("*t", GetTime())
	tbDeadline.hour = 23
	tbDeadline.min = 59
	tbDeadline.sec = 59
	return os.time(tbDeadline)
end

local tbValidReqs = {
	Answer = true,
	UpdateRankData = true,
}
function KinMonsterNian:ClientReq(pPlayer, szReq, ...)
	if not tbValidReqs[szReq] then
		Log("[x] KinMonsterNian:ClientReq", pPlayer.dwID, szReq, ...)
		return false
	end

	local fn = self[szReq]
	return fn(self, pPlayer, ...)
end

function KinMonsterNian:UpdateRankData(pPlayer, nVersion)
	local nKinId = pPlayer.dwKinId
	if not nKinId or nKinId<=0 then
		return false
	end

	local tbScores = self.tbScores[nKinId] or {nVersion = 0}
	if tbScores.nVersion==nVersion then
		return true
	end

	local tbData = {nVersion=tbScores.nVersion, nTime=tbScores.nTime}
	for nPlayerId, nScore in pairs(tbScores) do
		if type(nPlayerId)=="number" then
			local pStay = KPlayer.GetRoleStayInfo(nPlayerId)
			if pStay then
				table.insert(tbData, {nPlayerId, pStay.szName, nScore})
			end
		end
	end
	pPlayer.CallClientScript("Activity.MonsterNianAct:OnUpdateRankData", tbData)

	return true
end