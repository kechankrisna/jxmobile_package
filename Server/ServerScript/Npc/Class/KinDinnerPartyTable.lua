local tbNpc = Npc:GetClass("KinDinnerPartyTable")

tbNpc.nMaxAddExpCount = 1000	--最大加经验次数，防止出错无限加
tbNpc.nAddExpDis = 100000

function tbNpc:OnDialog(szParam)
	self:OnClickNpc(me, him.nId)
end

function tbNpc:OnGeneralDialog(szParam)
	self:OnClickNpc(me, him.nId)
end

function tbNpc:OnCreate(szParam)
	him.tbTmp = {}
end

function tbNpc:OnClickNpc(pPlayer, nNpcId)
    local tbActivity = KinDinnerParty.tbActivities[nNpcId]
	if not tbActivity then
		Log("[x] KinDinnerPartyTable:OnClickNpc", nNpcId, pPlayer.dwID)
		return
	end

	if not tbActivity.bStarted then
		pPlayer.CenterMsg("聚餐尚未正式開始")
		return
	end

	local bOwner = tbActivity.nOwner == pPlayer.dwID
	if bOwner then
		if not self:Eat(pPlayer, nNpcId, bOwner) then
			self:Guess(pPlayer, nNpcId)
		end
	else
		self:Eat(pPlayer, nNpcId, bOwner)
	end
end

function tbNpc:Eat(pPlayer, nNpcId, bOwner)
	local tbActivity = KinDinnerParty.tbActivities[nNpcId]
	if not tbActivity then
		return
	end
	local bCanJoin, bMaxJoinCount, szErr = KinDinnerParty:CanPlayerJoin(pPlayer, nNpcId)
	if not bCanJoin then
		if bMaxJoinCount and not bOwner then
			pPlayer.CenterMsg(string.format("您本周已經參與過[FFFE0D]%d[-]次幫派聚餐，無法享用本次佳餚", KinDinnerParty.Def.nMaxPlayerJoinCount), true)
		end
		if szErr and not bOwner then
			pPlayer.CenterMsg(szErr)
		end
		return false
	end

	if tbActivity.tbEatPlayers[pPlayer.dwID] then
		pPlayer.CenterMsg("你已經吃過這道菜了")
		return false
	end

	GeneralProcess:StartProcess(pPlayer, 3 * Env.GAME_FPS, "吃菜...", self.DoEat, self, pPlayer.dwID, nNpcId, bOwner)
	return true
end

function tbNpc:DoEat(nPlayerId, nNpcId, bOwner)
	local tbActivity = KinDinnerParty.tbActivities[nNpcId]
	if not tbActivity then
		return
	end
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end
	tbActivity.tbEatPlayers[pPlayer.dwID] = true
	pPlayer.SendAward(KinDinnerParty.Def.tbEatRewards, nil, true, Env.LogWay_KinDinnerParty)
	Log("KinDinnerPartyTable:Eat, SendAward", pPlayer.dwID, nNpcId, tbActivity.nKinId, tbActivity.nOwner)

	local szChar = tbActivity.tbGuessPlayers[pPlayer.dwID]
	if szChar then
		Mail:SendSystemMail({
	        To = pPlayer.dwID,
	        Title = "猜成語",
	        Text = string.format("您在幫派聚餐中發現了一個“[FFFE0D]%s[-]”字，快去告訴幫派成員吧！當前為第%d輪，別弄混淆了！", szChar, tbActivity.nGuessRound),
	        From = "幫派總管",
	    })
		tbActivity.tbGuessPlayers[pPlayer.dwID] = nil
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format("「%s」在吃菜的時候，獲得了成語中的一個字！", pPlayer.szName), tbActivity.nKinId)
	end
	return true
end

function tbNpc:Guess(pPlayer, nNpcId)
	local tbActivity = KinDinnerParty.tbActivities[nNpcId]
	if not tbActivity then
		return
	end
	pPlayer.CallClientScript("Ui:OpenWindow", "KinDinnerPartyGuessPanel", nNpcId, tbActivity.nGuessRound)
end

function tbNpc:StartAddExpTimer(nNpcId)
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc then
		return
	end

	local tbTmp = pNpc.tbTmp
	tbTmp.nCount = 1
	tbTmp.nTimerId = Timer:Register(KinDinnerParty.Def.nAddExpInterval * Env.GAME_FPS, self.OnAddExpTimer, self, nNpcId)
	self:OnAddExpTimer(nNpcId)
end

function tbNpc:StopAddExpTimer(nNpcId)
	local pNpc = KNpc.GetById(nNpcId);
	if not pNpc then
		return false
	end

	if pNpc.tbTmp.nTimerId then
		Timer:Close(pNpc.tbTmp.nTimerId)
		pNpc.tbTmp.nTimerId = nil
	end
end

function tbNpc:OnAddExpTimer(nNpcId)
	local pNpc = KNpc.GetById(nNpcId);
	if not pNpc then
		return false
	end

	local tbActivity = KinDinnerParty.tbActivities[nNpcId]
	if not tbActivity then
		Log("[x] KinDinnerParty:OnAddExpTimer, no activity", nNpcId)
		return false
	end

	local tbTmp = pNpc.tbTmp
	if tbTmp.nCount >= self.nMaxAddExpCount then
		Log("KinDinnerPartyTable:OnAddExpTimer, max count", nNpcId, tbTmp.nCount)
		return false
	end
	tbTmp.nCount = tbTmp.nCount + 1

	local tbTmp	= pNpc.tbTmp
	local tbPlayers = KNpc.GetAroundPlayerList(nNpcId, self.nAddExpDis)
	local tbPlayerIds = {}
	for _, pPlayer in pairs(tbPlayers or {}) do
		if KinDinnerParty:CanPlayerJoin(pPlayer, nNpcId) then
			table.insert(tbPlayerIds, pPlayer.dwID)
		end
	end
	for _, nPlayerId in pairs(tbPlayerIds) do
		self:AddExp2Player(nPlayerId, nNpcId, tbActivity.nGuessRight + 1)
	end

	return true
end

function tbNpc:AddExp2Player(nPlayerId, nNpcId, nMulti)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc then
		return
	end

	pPlayer.AddSkillState(KinDinnerParty.Def.nBuffId, 1, FightSkill.STATE_TIME_TYPE.state_time_normal, KinDinnerParty.Def.nAddExpInterval * Env.GAME_FPS, 0, 1)

	local nBaseExp = pPlayer.GetBaseAwardExp()
	local nExp = math.floor(nBaseExp * KinDinnerParty.Def.nAddExpBase * nMulti)
	pPlayer.AddExperience(nExp, Env.LogWay_KinDinnerParty)

	KinDinnerParty:OnPlayerJoin(nNpcId, pPlayer)
end