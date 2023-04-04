if MODULE_ZONESERVER then
	return
end

local tbValidReqs = {
	Join = true,
	UpdateRecords = true,
}
function KinEncounter:OnClientReq(pPlayer, szType, ...)
	if not tbValidReqs[szType] then
		Log("[x] KinEncounter:OnClientReq", pPlayer.dwID, szType)
		return
	end

	local fn = self[szType]
	if not fn then
		Log("[x] KinEncounter:OnClientReq, not imp", pPlayer.dwID, szType)
		return
	end

	local bOk, szErr = fn(self, pPlayer, ...)
	if not bOk then
		if szErr and szErr ~= "" then
			pPlayer.CenterMsg(szErr)
		end
		return
	end
end

function KinEncounter:UpdateRecords(pPlayer)
	local nKinId = pPlayer.dwKinId
	if not nKinId or nKinId <= 0 then
		return false
	end

	local tbData = ScriptData:GetValue("KinEncounter")
	pPlayer.CallClientScript("KinEncounter:OnRecordUpdated", tbData[nKinId] or {0, 0, 0})

	return true
end

function KinEncounter:Join(pPlayer)
	if self.bPrepareOver then
		return false, "Không tại hoạt động mở ra thời gian bên trong！"
	end

	if not self.nPrepareMapId or self.nPrepareMapId<=0 then
		return false, "Không tại hoạt động mở ra thời gian bên trong！"
	end

	local nKinId = Kin:GetKinIdByMemberId(pPlayer.dwID)
	if not nKinId or nKinId <= 0 then
		return false, "Ngài còn không có bang phái！"
	end

	if pPlayer.nLevel < self.Def.nJoinLevel then
		return false, string.format("Cấp bậc chưa đủ %d", self.Def.nJoinLevel)
	end

	if pPlayer.dwTeamID > 0 then
        TeamMgr:QuiteTeam(pPlayer.dwTeamID, pPlayer.dwID)
    end

	if not pPlayer.SwitchZoneMap(self.nPrepareMapId, 0, 0) then
		Log("[x] KinEncounter:Join", pPlayer.dwID, self.nPrepareMapId)
        return false, "Tiến vào chuẩn bị trận thất bại"
    end

    return true
end

function KinEncounter:OnPrepareMapCreated(nMapId)
	if not self:IsOpenToday() then
		Log("KinEncounter:OnPrepareMapCreated, not open today", nMapId)
		return
	end

	self.nStartTime = GetTime()

	self.bPrepareOver = nil
	self.nPrepareMapId = nMapId

	KPlayer.SendWorldNotify(self.Def.nJoinLevel, 999, "Các vị thiếu hiệp, bang phái tao ngộ chiến bắt đầu, mọi người có thể thông qua thẩm tra tin tức mới nhất hiểu rõ trong hoạt động cho!", 1, 1)
	KPlayer.SendWorldNotify(self.Def.nJoinLevel, 999, "Các vị thiếu hiệp, bang phái tao ngộ chiến bắt đầu, mọi người nhanh chóng báo danh tham gia vì bang phái vinh dự mà chiến!", 1, 1)
	KPlayer.BoardcastScript(1, "KinEncounter:OnPrepareBegin")
end

function KinEncounter:OnPrepareOver()
	self.bPrepareOver = true
	self.nPrepareMapId = nil
	KPlayer.BoardcastScript(1, "KinEncounter:OnPrepareEnd")
end

function KinEncounter:OnZoneQueryKinInfo(nZoneKinId, nKinId)
	local tbKin = Kin:GetKinById(nKinId)
	if not tbKin then
		Log("[x] KinEncounter:OnZoneQueryKinInfo", nKinId)
		return
	end

	local tbManagers = {}
	for nCareer in pairs(self.Def.tbManagerCareers) do
		local tbIds = tbKin:GetCareerMemberIds(nCareer)
		for _, nId in ipairs(tbIds) do
			table.insert(tbManagers, nId)
		end
	end

	local tbData = ScriptData:GetValue("KinEncounter")
	local _, _, _, szLastKin1, szLastKin2 = unpack(tbData[nKinId] or {})

	local tbInfo = {
		szName = tbKin.szName,
		tbManagers = tbManagers,
		tbLastKins = {szLastKin1, szLastKin2},
	}
	CallZoneServerScript("KinEncounter:OnQueryKinInfoRsp", nZoneKinId, tbInfo)
end

function KinEncounter:SendKinMsg(nKinId, szMsg)
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId)
end

function KinEncounter:OnInvalid(tbPlayers)
	local szMsg = string.format("Bản bang phái báo danh nhân số không đủ %d Người, không cách nào tham dự hoạt động!", self.Def.nMinKinMemberCount)
	for _, nPlayerId in ipairs(tbPlayers) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer then
			pPlayer.Msg(szMsg, 1)
		end
        Log("KinEncounter:OnInvalid", nPlayerId)
	end
	Log("-------")
end

function KinEncounter:OnSingle(tbPlayers)
	local nKinId = 0
	local tbMail = {Title = "Bang phái tao ngộ chiến", From = "幫派總管", nLogReazon = Env.LogWay_KinEncounter, Text = "大俠所在幫派在幫派遭遇戰中輪空，未能匹配到對手，這是您的補償，請查收！"}
	for _, nPlayerId in ipairs(tbPlayers) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer then
			pPlayer.CenterMsg("大俠的幫派在本次幫派遭遇戰中輪空了！")
			if not nKinId or nKinId <= 0 then
				nKinId = pPlayer.dwKinId
			end
		end
		
        tbMail.To = nPlayerId
        tbMail.tbAttach = self.Def.tbRewards.tbSingle
        Mail:SendSystemMail(tbMail)
        Log("KinEncounter:OnSingle", nPlayerId)
	end
	if nKinId and nKinId > 0 then
		self:RecordResult(nKinId, 1)
	end
	Log("KinEncounter:OnSingle", tostring(nKinId))
end

function KinEncounter:GetExpandRewardCfg(bWin, nPlayerCount)
	local tbRet = {}
	local tbOrgCfg = bWin and self.Def.tbRewards.tbWin or self.Def.tbRewards.tbLose
	local nLastRank = 0
	for _, tb in ipairs(tbOrgCfg) do
		local nMaxRankPercent, tbRewards = unpack(tb)
		local nMaxRank = math.floor(nPlayerCount * nMaxRankPercent / 100)
		for nRank=(nLastRank + 1), nMaxRank do
			tbRet[nRank] = tbRewards
		end
		nLastRank = nMaxRank
	end
	return tbRet
end

function KinEncounter:OnGameOver(tbData)
   	local tbMail = {Title = "幫派遭遇戰", From = "幫派總管", nLogReazon = Env.LogWay_KinEncounter}
	local tbRewardCfg = self:GetExpandRewardCfg(tbData.nResult > 0, #tbData.tbPlayers)
	local szResult = "堪堪戰平"
	if tbData.nResult > 0 then
		szResult = "取得勝利"
	elseif tbData.nResult < 0 then
		szResult = "不幸落敗"
	end
	for nRank, nPlayerId in ipairs(tbData.tbPlayers) do
        tbMail.Text = string.format("大俠在幫派遭遇戰中擊殺強敵%d人，排名第%d，最終%s，這是您的獎勵，請查收！", tbData.tbKills[nRank] or 0, nRank, szResult)
        tbMail.To = nPlayerId
        tbMail.tbAttach = tbRewardCfg[nRank]
        Mail:SendSystemMail(tbMail)
        Log("KinEncounter:OnGameOver", nRank, nPlayerId)
	end

	local tbClientData = {
		nResult = tbData.nResult,
		tbPlayers = {},
	}	
	local tbPlayers = {}
	for i, nPlayerId in ipairs(tbData.tbPlayers) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer then
			table.insert(tbClientData.tbPlayers, {
				pPlayer.szName,
				tbData.tbKills[i] or 0,
			})
			table.insert(tbPlayers, pPlayer)
		end
	end
	local nKinId = 0
	for _, pPlayer in ipairs(tbPlayers) do
		if not nKinId or nKinId <= 0 then
			nKinId = pPlayer.dwKinId
		end
		pPlayer.CallClientScript("KinEncounter:OnGameOver", tbClientData)
	end

	self.nTransferToKinMapDeadline = GetTime() + self.Def.nDelayKickoutTime + 5

	self:RecordResult(nKinId, tbData.nResult, tbData.szOtherKin)
end

function KinEncounter:OnReConnectZoneClient(pPlayer)
	if self.nTransferToKinMapDeadline and GetTime() < self.nTransferToKinMapDeadline then
		local tbKinData = Kin:GetKinById(pPlayer.dwKinId)
		if tbKinData then
			tbKinData:GoMap(pPlayer.dwID)
		end
	end
end

function KinEncounter:GetMaxNpcLevel()
	local szLvlFrame = Lib:GetMaxTimeFrame(self.Def.tbNpcLevel)
	return self.Def.tbNpcLevel[szLvlFrame] or 105
end

function KinEncounter:GetMaxTransformBuffLevel()
	local szLvlFrame = Lib:GetMaxTimeFrame(self.Def.tbTransformBuffLevel)
	return self.Def.tbTransformBuffLevel[szLvlFrame] or 1
end

function KinEncounter:QueryMaxLevel()
	local nNpcLevel = self:GetMaxNpcLevel()
	local nBuffLevel = self:GetMaxTransformBuffLevel()
	CallZoneServerScript("KinEncounter:OnQueryMaxLevelRsp", nNpcLevel, nBuffLevel)
	Log("KinEncounter:QueryMaxLevel", nNpcLevel, nBuffLevel)
end

function KinEncounter:ClearRecords()
	ScriptData:SaveAtOnce("KinEncounter", {})
	Log("KinEncounter:ClearRecords")
end

-- nResult: -1输，0平，1赢
function KinEncounter:RecordResult(nKinId, nResult, szOtherKin)
	local tbData = ScriptData:GetValue("KinEncounter")
	tbData[nKinId] = tbData[nKinId] or {0, 0, 0, "", ""}	--输，平，赢，最近匹配家族1，最近匹配家族2
	if nResult < 0 then
		tbData[nKinId][1] = tbData[nKinId][1] + 1
	elseif nResult == 0 then
		tbData[nKinId][2] = tbData[nKinId][2] + 1
	else
		tbData[nKinId][3] = tbData[nKinId][3] + 1
	end
	if szOtherKin and szOtherKey~=tbData[nKinId][4] and szOtherKey~=tbData[nKinId][5] then
		table.remove(tbData[nKinId], 4)
		table.insert(tbData[nKinId], szOtherKin)
	end
	ScriptData:AddModifyFlag("KinEncounter")
	Log("KinEncounter:RecordResult", nKinId, nResult)
end

function KinEncounter:SendRecordRewards()
	if self.bForceClose then 
		Log("KinEncounter:SendRecordRewards, force closed not send")
		return
	end
	
	local tbData = ScriptData:GetValue("KinEncounter")
	for nKinId, tbRecord in pairs(tbData) do
		while true do
			local _, _, nWin = unpack(tbRecord)
			local tbRewards = self.Def.tbRecordRewards[nWin]
			if not tbRewards then
				Log("KinEncounter:SendRecordRewards, no rewards", nKinId, nWin)
				break
			end

			local tbKinData = Kin:GetKinById(nKinId)
			if not tbKinData then
				Log("[x] KinEncounter:SendRecordRewards, no kindata", nKinId, nWin)
				break
			end

			local tbPlayers = {tbKinData:GetLeaderId() or 0, tbKinData:GetMasterId() or 0}
			for i, nPlayerId in ipairs(tbPlayers) do
				if nPlayerId > 0 then
					local nItemId, nEventId = unpack(tbRewards[i])
					Mail:SendSystemMail({
				        To = nPlayerId,
				        Title = "幫派遭遇戰",
				        Text = "幫派遭遇戰匯總獎勵",
				        From = "幫派總管",
				        tbAttach = {
				        	{"item", nItemId, 1},
				        },
				        nLogReazon = Env.LogWay_KinEncounter,
				    })
					Kin:RedBagGainWithoutCheck(nKinId, nPlayerId, nEventId)
					Log("KinEncounter:SendRecordRewards", nKinId, nWin, i, nPlayerId, nItemId, nEventId)
				else
					Log("KinEncounter:SendRecordRewards, career none", nKinId, nWin, i, nPlayerId)
				end
			end

			break
		end
	end
	Log("KinEncounter:SendRecordRewards done")
end

function KinEncounter:OnLogin(pPlayer)
	if not KinEncounter:IsRunning() then
		return
	end
	pPlayer.CallClientScript("KinEncounter:OnLogin", self.nStartTime)
end