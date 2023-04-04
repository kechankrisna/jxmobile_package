Require("ServerScript/PartnerCard/PartnerCardTripFubenMgr.lua")
local tbTripFuben = PartnerCard.tbTripFuben
local tbFuben = Fuben:CreateFubenClass(tbTripFuben.szFubenBase);

function tbFuben:OnCreate(dwOwnerId, nCardId)
	self.dwOwnerId = dwOwnerId
	self.nCardId = nCardId
	self.nStartTime = GetTime();
	self.nReadyEndTime = self.nStartTime + self.tbSetting.nReadyTime
	self:Start();
	self.bCanInvite = true
	self.nPlayerCount = 0;
	self.tbJoinTime = {};
	PartnerCard:OnTripFubenCreate(dwOwnerId, nCardId)
end

function tbFuben:OnFirstJoin(pPlayer)
	if pPlayer.dwID ~= self.dwOwnerId then --加入owner 的队伍
		local pOwner = KPlayer.GetPlayerObjById(self.dwOwnerId) 
		local szNotifyMsg = string.format("Hiệp sĩ [FFFE0D]%s[-] vào phó bản du lịch", pPlayer.szName)
		if pOwner then
			pOwner.CenterMsg(szNotifyMsg)
			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Team, szNotifyMsg, pOwner.dwTeamID);
		end
	else
		self.nPlayerCount = self.nPlayerCount + 1; --被邀请者的计数不加在这里是防止2个人同时点了接受邀请却在下一帧增加个数
		Achievement:AddCount(pPlayer.dwID, "Guest_Task2", 1);
	end

	self.tbJoinTime[pPlayer.dwID] = GetTime()
	if self.nPlayerCount >= tbTripFuben.nMaxPlayerNum then
		local pOwner = KPlayer.GetPlayerObjById(self.dwOwnerId) 
		if pOwner then
			pOwner.CallClientScript("Fuben:HideInviteButton");
		end
	end
end

function tbFuben:OnLogin()
	self:OnJoin(me)
end

function tbFuben:OnJoin(pPlayer)
	pPlayer.nCanLeaveMapId = self.nMapId;
	pPlayer.SetPkMode(0)
	local tbFubenInfo = {
		szName = self.tbSetting.szName,
		nEndTime = self.nReadyEndTime,
		bOwner = (pPlayer.dwID == self.dwOwnerId),
	}
	pPlayer.CallClientScript("Ui:OpenWindow", "HomeScreenFuben", "PartnerCardTripFuben", tbFubenInfo);
end

function tbFuben:OnOut(pPlayer)
	self:ClearDeathState(pPlayer);
	pPlayer.CallClientScript("Ui:CloseWindow", "HomeScreenFuben");
	--TODO 如果所有人都出去了也关闭
	if pPlayer.dwID == self.dwOwnerId then
		--pPlayer.SendAward({{"item", FubenMgr.CREATE_FUBEN_AWARD, 1}}, true, false, Env.LogWay_FindDungeonAward)
		self.dwOwnerId = 0;
	end

	pPlayer.TLogRoundFlow(Env.LogWay_PartnerCardTripFuben, self.tbSetting.nMapTemplateId, 0, GetTime() - self.tbJoinTime[pPlayer.dwID]
 			, self.bLost and Env.LogRound_FAIL or Env.LogRound_SUCCESS, 0, 0); 

end

function tbFuben:OnOwnerShowTaskDialog(nDialogId, bIsOnce)
	local pPlayer = KPlayer.GetPlayerObjById(self.dwOwnerId)
	if not pPlayer then
		return
	end
	pPlayer.CallClientScript("Ui:TryPlaySitutionalDialog", nDialogId, bIsOnce);
end

function tbFuben:OnOpenOwnerInvitePanel()
	local pPlayer = KPlayer.GetPlayerObjById(self.dwOwnerId)
	if  pPlayer then
		pPlayer.CallClientScript("Fuben:SetOpenUiAfterDialog", "DungeonInviteList", "PartnerCardTripFuben")
	end
end

function tbFuben:OnAddCardNpc()
	local tbCardInfo = PartnerCard:GetCardInfo(self.nCardId)
	if not tbCardInfo then
		Log("PartnerCardTripFuben fnOnAddCardNpc Fail ", self.dwOwnerId, self.nCardId, self.nMapId)
		return 
	end
	local nNpcTID = tbCardInfo.nNpcTempleteId
	local pNpc = KNpc.Add(nNpcTID, 1, 0, self.nMapId, unpack(self.tbSetting.tbCardNpcPoint))
	pNpc.szType = PartnerCard.NPC_TYPE_TRIP_FUBEN
	pNpc.nOwnerId = self.dwOwnerId
	pNpc.nCardId = self.nCardId
	self.nCardNpcId = pNpc.nId
end

function tbFuben:OnCardNpcBubble(szMsg, szTime)
	local pNpc = KNpc.GetById(self.nCardNpcId or 0)
	if pNpc then
		local nNpcId = pNpc.nId
		local fnTalk = function (pPlayer)
			pPlayer.CallClientScript("PartnerCard:DoBubbleTalk", nNpcId, szMsg, szTime)
		end
		 self:AllPlayerExcute(fnTalk);
	end
end

--BOSS被杀
function tbFuben:OnOpenGate()
	self.bGateOpened = true;
	local tbAward =tbTripFuben.tbGateAward

	local fnExcute = function (pPlayer)
        pPlayer.SendAward(tbAward, true, false, Env.LogWay_PartnerCardTripFubenGate)
    end
    self:AllPlayerExcute(fnExcute);
	local szNotify = "Lửa đã nhóm, có thể cầm tục thu hoạch được kinh nghiệm"
	self:ChangeTrap(self.tbSetting.szLeaveTrapName, nil, nil, nil, nil, "LeaveTripFuben")
	local nMapId = self.nMapId
	KNpc.Add(self.tbSetting.nLeavegGateNpcId, 1, 0, nMapId, unpack(self.tbSetting.tbLeavegGatePoint))
	KNpc.Add(self.tbSetting.nGuohuoNpcId, 1, 0, nMapId, unpack(self.tbSetting.tbGuohuoPoint))
	Timer:Register(Env.GAME_FPS * 40, function ()
		local tbInst = Fuben.tbFubenInstance[nMapId]
		if tbInst then
			 tbInst:KickOutAllPlayer()
		end
	end)

	Timer:Register(Env.GAME_FPS * 60, function ()
		if Fuben.tbFubenInstance[nMapId] then
			Fuben.tbFubenInstance[nMapId]:BlackMsg("Không có gì đáng để khám phá trong cảnh xung đột này.")
		end
	end)
	
	self:BlackMsg(szNotify)
end

function tbFuben:OnLeaveTripFuben()
	me.GotoEntryPoint();
end

function tbFuben:OnKillNpc(pNpc, pKiller)
	if self.bGateOpened then
		return
	end
	local nRandCoin = MathRandom(unpack(tbTripFuben.tbNpcKillAward))
	
	local szAwardDesc = string.format("Chúc mừng ngài thu được %d Bạc", nRandCoin)
	local fnExcute = function (pPlayer)
		pPlayer.CenterMsg(szAwardDesc, true)
		pPlayer.AddMoney("Coin", nRandCoin, Env.LogWay_PartnerCardTripFubenKill)
    end
    self:AllPlayerExcute(fnExcute);
end

function tbFuben:ClearDeathState(pPlayer)
	pPlayer.RemoveSkillState(Fuben.RandomFuben.DEATH_SKILLID);
	pPlayer.nFightMode = 1;
end

function tbFuben:OnPlayerDeath()
	me.Revive(1);
	me.AddSkillState(Fuben.RandomFuben.DEATH_SKILLID, 1, 0, 10000);
	me.nFightMode = 2;
	
	Timer:Register(tbTripFuben.nReviveTime * Env.GAME_FPS, self.DoRevive, self, me.dwID);
	--客户端显示一个倒计时 todo
end

function tbFuben:DoRevive(nPlayerId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if not pPlayer then
		return;
	end

	if pPlayer.nFightMode ~= 2 then
		return;
	end

	self:ClearDeathState(pPlayer);
end

function tbFuben:OnCloseInvite()
	local pPlayer = KPlayer.GetPlayerObjById(self.dwOwnerId)
	if not pPlayer then
		return
	end
	pPlayer.CallClientScript("Fuben:HideInviteButton");
	self.bCanInvite = false
end

function tbFuben:GameLost()
	self.bLost = true;
	local fnExcute = function (pPlayer)
		pPlayer.SendBlackBoardMsg("Du lịch phó bản đã biến mất");
	end
	self:AllPlayerExcute(fnExcute);
end

function tbFuben:GameWin()
	self.bLost = true;
	local fnExcute = function (pPlayer)
		pPlayer.SendBlackBoardMsg("Thành công hiệp trợ môn khách giải quyết xung đột");
	end
	self:AllPlayerExcute(fnExcute);
end

function tbFuben:KickOutAllPlayer()
	local tbAllPlayer = KPlayer.GetMapPlayer(self.nMapId);
	for _, pPlayer in pairs(tbAllPlayer) do
		pPlayer.GotoEntryPoint();
	end
end