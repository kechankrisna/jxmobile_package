Require("CommonScript/Task/TaskCommon.lua");

function Task:LoadTask()
end

function Task:OnLogin()
	self:CheckTaskValidTime(me)
	me.CallClientScript("Task:SyncTaskData", self:GetPlayerTaskInfo(me));

	local nTaskId = 413;
	local tbMainTask = Task:GetCurMainTask(me);
	local nTaskFlag = Task:GetTaskFlag(me, nTaskId);
	local nNextTaskFlag = Task:GetTaskFlag(me, nTaskId + 1);
	if me.nLevel >= 90 and not tbMainTask and nTaskFlag == 1 and nNextTaskFlag == 0 then
		Task:SetTaskFlag(me, nTaskId, 0);
		Task:ForceAcceptTask(me, nTaskId);
	end
	Task:AcceptJYFLFirstTask(me)
	Task:CheckAndAutoFinish(me, "Achievement")
end

function Task:AcceptJYFLFirstTask(pPlayer)
	local nTaskId = Task:CanAcceptFirstJYFLTask(pPlayer)
	if nTaskId then
		local bRet = Task:ForceAcceptTask(pPlayer, nTaskId, nil, true)
		if bRet then
			pPlayer.SetUserValue(Task.SAVE_GROUP_JYFL, Task.FIRST_TASK_ACCEPT_TIME, GetTime())
		end
		Log("[Task] Accept JYFL First Task", pPlayer.dwID, pPlayer.szName, nTaskId, bRet and 1 or 0)
	end
end

function Task:SyncOneTask(pPlayer, tbCurTask)
	pPlayer.CallClientScript("Task:SyncOneTask", tbCurTask);
end

function Task:OnNpcDeath(pNpc, pKiller)
	local nNpcTemplateId = pNpc.nTemplateId;
	local nFinishType = self.tbKillNpc[nNpcTemplateId];
	if not nFinishType then
		return;
	end

	if pKiller then
		pKiller = pKiller.GetPlayer();
	end

	if nFinishType == 0 and not pKiller then
		return;
	end

	local tbAllPlayer = pKiller and {pKiller} or {};
	if nFinishType == 1 then
		local tbPlayerList = pNpc.GetDamagePlayerList();
		tbAllPlayer = {};
		for _, tbInfo in pairs(tbPlayerList or {}) do
			if tbInfo.pPlayer then
				table.insert(tbAllPlayer, tbInfo.pPlayer);
			end
		end
	end

	local nKillerId = pKiller and pKiller.dwID or 0;
	for _, pPlayer in pairs(tbAllPlayer) do
		Task:OnKillNpc(pPlayer, nNpcTemplateId,  pPlayer.dwID == nKillerId);
	end
end

function Task:ForeachTaskCheck(pPlayer, szTarget, fnCheck, fnSet, ...)
	local function fnSetInfo(pPlayer, tbCurTask, tbDstTask, ...)
		tbCurTask.tbTargetInfo[szTarget] = tbCurTask.tbTargetInfo[szTarget] or {};
		local tbPlayerTarget = tbCurTask.tbTargetInfo[szTarget];
		fnSet(tbPlayerTarget, ...);
		Task:SyncOneTask(pPlayer, tbCurTask);
		if tbDstTask.bAutoFinish == 1 then
			if tbDstTask.nNeedConfirmFinish > 0 then
				pPlayer.CallClientScript("Task:OpenConfirmPanel", nTaskId, pPlayer.GetNpc().nId);
			else
				Task:TryFinishTask(pPlayer, tbCurTask.nTaskId, pPlayer.GetNpc().nId, true);
			end
		end
	end

	self:ForeachTask(pPlayer, szTarget, fnCheck, fnSetInfo, ...);
end

function Task:ForeachTask(pPlayer, szTarget, fnCheck, fnSet, ...)
	local tbPlayerCurTask = Task:GetPlayerCurTask(pPlayer);
	for nTaskId, tbCurTask in pairs(tbPlayerCurTask or {}) do
		local tbDstTask = self:GetTask(nTaskId);
		local tbTarget = ((tbDstTask or {}).tbTargetInfo or {})[szTarget];
		if tbTarget and fnCheck(tbCurTask, tbDstTask, tbTarget, ...) then
			fnSet(pPlayer, tbCurTask, tbDstTask, ...);
		end
	end
end

local function CheckKillNpcTask(tbCurTask, tbDstTask, tbTarget, nNpcTemplateId, bIsKiller)
	if not tbTarget[nNpcTemplateId] then
		return false;
	end

	if not bIsKiller and tbDstTask.bKillNpcToAllPlayer ~= 1 then
		return false;
	end

	return true;
end

local function SetKillNpcTarget(tbPlayerTarget, nNpcTemplateId)
	tbPlayerTarget[nNpcTemplateId] = tbPlayerTarget[nNpcTemplateId] or 0;
	tbPlayerTarget[nNpcTemplateId] = tbPlayerTarget[nNpcTemplateId] + 1;
end

function Task:OnKillNpc(pPlayer, nNpcTemplateId, bIsKiller)
	self:ForeachTaskCheck(pPlayer, "KillNpc", CheckKillNpcTask, SetKillNpcTarget, nNpcTemplateId, bIsKiller);
end

function Task:OnFinishPersonalFuben(nFubenIndex, nFubenLevel)
	local nSectionIdx, nSubSectionIdx = PersonalFuben:GetSectionIdx(nFubenIndex, nFubenLevel);
	if not nSectionIdx then
		return;
	end

	local tbCheckList = {};
	local function fnCheck(tbCurTask, tbDstTask, tbTargetInfo)
		if tbTargetInfo.nSectionIdx == nSectionIdx and tbTargetInfo.nSubSectionIdx == nSubSectionIdx and tbTargetInfo.nFubenLevel == nFubenLevel then
			return true;
		end
		return false;
	end

	local function fnSet(pPlayer, tbCurTask, tbDstTask)
		table.insert(tbCheckList, tbCurTask.nTaskId);
	end

	self:ForeachTask(me, "PersonalFuben", fnCheck, fnSet);

	for _, nTaskId in pairs(tbCheckList) do
		self:CheckAndAutoFinish(me, "PersonalFuben", {function ()
			me.CallClientScript("Ui:CloseWindow", "FubenSectionPanel");
		end}, nTaskId);
	end
end

function Task:OnAchievementCompleted(szMainKind, szSubKind, nCompletedLevel)
	local tbCheckList = {};
	local function fnCheck(tbCurTask, tbDstTask, tbTargetInfo)
		if tbTargetInfo[1] == szMainKind and tbTargetInfo[2] == nCompletedLevel then
			return true;
		end
		return false;
	end

	local function fnSet(pPlayer, tbCurTask, tbDstTask)
		table.insert(tbCheckList, tbCurTask.nTaskId);
	end

	self:ForeachTask(me, "Achievement", fnCheck, fnSet);

	for _, nTaskId in pairs(tbCheckList) do
		self:CheckAndAutoFinish(me, "Achievement", nil, nTaskId);
	end
end

function Task:OnLevelUp()
	local nLevel = me.nLevel;
	local tbCheckList = {};
	local function fnCheck(tbCurTask, tbDstTask, nTargetLevel)
		if nTargetLevel == nLevel then
			return true;
		end
		return false;
	end

	local function fnSet(pPlayer, tbCurTask, tbDstTask)
		table.insert(tbCheckList, tbCurTask.nTaskId);
	end

	self:ForeachTask(me, "MinLevel", fnCheck, fnSet);

	for _, nTaskId in pairs(tbCheckList) do
		self:CheckAndAutoFinish(me, "MinLevel", nil, nTaskId);
	end

	Task:AcceptJYFLFirstTask(me)
end

local function CheckEnterMapTask(tbCurTask, tbDstTask, target, nMapTemplateId)
	return target == nMapTemplateId;
end

local function SetEnterMapTarget(tbPlayerTarget, nMapTemplateId)
	tbPlayerTarget[nMapTemplateId] = true;
end

function Task:OnEnterMap(nMapTemplateId)
	self:ForeachTaskCheck(me, "EnterMap", CheckEnterMapTask, SetEnterMapTarget, nMapTemplateId or me.nMapTemplateId);
end

local function CheckOnTrapTask(tbCurTask, tbDstTask, tbTarget, nMapTemplateId, szTrap)
	if tbTarget.nMapTemplateId ~= nMapTemplateId or tbTarget.szTrap ~= szTrap then
		return false;
	end
	return true;
end

local function SetOnTrapTarget(tbPlayerTarget, nMapTemplateId, szTrap)
	tbPlayerTarget[nMapTemplateId] = tbPlayerTarget[nMapTemplateId] or {};
	tbPlayerTarget[nMapTemplateId][szTrap] = true;
end

function Task:OnPlayerTrap(nMapTemplateID, nMapID, szTrapName)
	self:ForeachTaskCheck(me, "OnTrap", CheckOnTrapTask, SetOnTrapTarget, nMapTemplateID, szTrapName);
end

local function CheckExtInfo(tbCurTask, tbDstTask, target, szType)
	local tbPlayerTarget = tbCurTask.tbTargetInfo.ExtInfo;
	if target ~= szType or (tbPlayerTarget and tbPlayerTarget[szType]) then
		return false;
	end

	return true;
end

local function SetExtInfoTarget(tbPlayerTarget, szType)
	tbPlayerTarget[szType] = true;
end

function Task:OnTaskExtInfo(pPlayer, szType)
	self:ForeachTaskCheck(pPlayer, "ExtInfo", CheckExtInfo, SetExtInfoTarget, szType);
end

function Task:TryAddZoneExtPoint(pPlayer, nTaskId)
	if not self:CheckZoneTaskAddExtPoint(nTaskId) then
		return
	end
	self:DoAddExtPoint(pPlayer, nTaskId)
end

function Task:DoAddExtPoint(pPlayer, nTaskId, nExtPoint)
	nExtPoint = nExtPoint or 1;
	local tbCurTask = Task:GetPlayerTaskInfo(pPlayer, nTaskId);
	if not tbCurTask then
		return;
	end

	local szTarget = "ExtPoint";
	local tbDstTask = self:GetTask(nTaskId);
	local nTargetValue = ((tbDstTask or {}).tbTargetInfo or {})[szTarget];
	if nTargetValue and nTargetValue > 0 then
		tbCurTask.tbTargetInfo[szTarget] = tbCurTask.tbTargetInfo[szTarget] or {};

		local tbPlayerTarget = tbCurTask.tbTargetInfo[szTarget];
		tbPlayerTarget.nValue = (tbPlayerTarget.nValue or 0) + nExtPoint;

		self:SyncOneTask(pPlayer, tbCurTask);
		if nTargetValue <= tbPlayerTarget.nValue and tbDstTask.bAutoFinish == 1 then
			if tbDstTask.nNeedConfirmFinish > 0 then
				pPlayer.CallClientScript("Task:OpenConfirmPanel", nTaskId, pPlayer.GetNpc().nId);
			else
				self:TryFinishTask(pPlayer, nTaskId, pPlayer.GetNpc().nId, true);
			end
		end
	end
end

function Task:SetExtPointByBit(pPlayer, nTaskId, nBit)
	local tbCurTask = Task:GetTaskTargetInfo(pPlayer, nTaskId)
	if not tbCurTask then
		return
	end
	local nExtPoint = 0
	if not tbCurTask["ExtPoint"] then
		nExtPoint = KLib.SetBit(0, nBit, 1)
	else
		local tbExtPoint = tbCurTask["ExtPoint"]
		nExtPoint = KLib.SetBit(tbExtPoint.nValue, nBit, 1) - tbExtPoint.nValue
	end
	if nExtPoint > 0 then
		Task:DoAddExtPoint(pPlayer, nTaskId, nExtPoint)
	end
end

function Task:CheckAndAutoFinish(pPlayer, szType, tbCallBack, nCheckTaskId)
	local fnCheckFunc = self.tbCheckTargetFunc[szType];
	if not fnCheckFunc then
		return;
	end

	local tbCurTaskInfo = self:GetPlayerCurTask(pPlayer);
	for nTaskId, tbCurTask in pairs(tbCurTaskInfo or {}) do
		if not nCheckTaskId or nTaskId == nCheckTaskId then
			local tbDstTask = self:GetTask(nTaskId);
			local tbTarget = ((tbDstTask or {}).tbTargetInfo or {})[szType];

			if tbTarget and fnCheckFunc(self, pPlayer, nTaskId, tbTarget) then
				self:SyncOneTask(pPlayer, tbCurTask);

				if tbCallBack then
					Lib:CallBack(tbCallBack);
				end

				if tbDstTask.bAutoFinish == 1 then
					if tbDstTask.nNeedConfirmFinish > 0 then
						pPlayer.CallClientScript("Task:OpenConfirmPanel", nTaskId, pPlayer.GetNpc().nId);
					else
						self:TryFinishTask(pPlayer, nTaskId, pPlayer.GetNpc().nId, true);
					end
				end
			end
		end
	end
end

function Task:UseTaskItem(pPlayer, nTaskId)
	local tbPlayerTask = self:GetPlayerTaskInfo(pPlayer, nTaskId);
	if not tbPlayerTask then
		return;
	end

	local tbTaskItem = self:GetTaskItem(nTaskId);
	if not tbTaskItem then
		return;
	end

	local nMapId, nX, nY = pPlayer.GetWorldPos();
	if pPlayer.nMapTemplateId ~= tbTaskItem.nMapTemplateId or nX ~= tbTaskItem.nX or nY ~= tbTaskItem.nY then
		Log(string.format("[TaskItem] ERR ?? UseTaskItem nTaskId = %s, nMapTemplateId = %s, nX = %s, nY = %s", nTaskId, pPlayer.nMapTemplateId, nX, nY));
		return;
	end

	local function fnEndUseTaskItem(nPlayerId, nTaskId)
		local pUsePlayer = KPlayer.GetPlayerObjById(nPlayerId);
		if not pUsePlayer then
			return;
		end

		self:DoAddExtPoint(pPlayer, nTaskId);
	end

	GeneralProcess:StartProcess(pPlayer, tbTaskItem.nTime * Env.GAME_FPS, tbTaskItem.szMsg, fnEndUseTaskItem, pPlayer.dwID, nTaskId);
end

function Task:UpdateTask(pPlayer, nNpcId, nTaskId)
	local tbAllTask = self:GetPlayerTaskInfo(pPlayer);
	local tbCurTaskInfo = tbAllTask.tbCurTaskInfo;
	for _, tbTask in pairs(tbCurTaskInfo) do
		if not nTaskId or nTaskId == tbTask.nTaskId then
			self:DoTaskNextStep(pPlayer, nNpcId or 0, tbTask.nTaskId, true);
		end
	end

	pPlayer.CallClientScript("Task:OnTaskHasChange");
end

function Task:CheckShowDialogInfo(pPlayer, nTaskId)
	if nTaskId and nTaskId == Task.nFlowTaskId and not Task:AllFlowTaskFinish(pPlayer) then
		return false
	end
	return true
end

function Task:GetDialogInfo(pPlayer, pNpc)
	if not pPlayer or not pNpc then
		return {};
	end

	local tbAllTaskAboutNpc = self:GetTaskByNpcTemplateId(pNpc.nTemplateId);
	local tbResult = {};

	local function fnGetTaskShowInfo(nTaskId)
		local tbTask = Task:GetTask(nTaskId) or {};
		local szName = tbTask.szTaskTitle;
		if not szName then
			return;
		end

		local nState = Task:GetTaskState(pPlayer, nTaskId, pNpc.nId);
		if nState == Task.STATE_NONE or (nState == Task.STATE_CAN_ACCEPT and tbTask.nAcceptTaskNpcId ~= pNpc.nTemplateId) then
			return;
		end

		if nState == self.STATE_CAN_ACCEPT then
			szName = "【Nhận】" .. szName;
		elseif nState == self.STATE_CAN_FINISH then
			szName = "【Trả】" .. szName;
		elseif nState == self.STATE_ON_DING then
			szName = "【Đang làm】" .. szName;
		end

		return {Text = szName, Type = "Task", Param = {nTaskId = nTaskId, nState = nState, nNpcId = pNpc.nId}}
	end
	for _, nTaskId in pairs(tbAllTaskAboutNpc or {}) do
		if Task:CheckShowDialogInfo(pPlayer, nTaskId) then
			local tbShowInfo = fnGetTaskShowInfo(nTaskId);
			if tbShowInfo then
				table.insert(tbResult, tbShowInfo);
			end
		end
	end

	-- 按照一定顺序进行排序，保证每次看到 dialog 选项都是一样的
	-- 优先级 可交 可接 进行中
	local function fnSort(tbA, tbB)
		local function fnGetValue(tb)
			local nState = tb.Param.nState;
			local nStateValue = 10000000;
			if nState == Task.STATE_CAN_FINISH then
				return 10 * nStateValue + tb.Param.nTaskId;
			elseif nState == Task.STATE_CAN_ACCEPT then
				return 9 * nStateValue + tb.Param.nTaskId;
			elseif nState == Task.STATE_ON_DING then
				return 8 * nStateValue + tb.Param.nTaskId;
			end
		end
		return fnGetValue(tbA) > fnGetValue(tbB);
	end

	table.sort(tbResult, fnSort);
	return tbResult;
end

function Task:DoTaskNextStep(pPlayer, nNpcId, nTaskId, bWhithoutMsg)
	local tbTask = self:GetTask(nTaskId or 0);
	if not tbTask then
		Log("[Task] Task:OnDialog Get Task Fail !! nTaskId = " .. nTaskId);
		return;
	end

	local nDialogId = 0;
	local nFinishGuide = 0;
	local nState = self:GetTaskState(pPlayer, nTaskId, nNpcId);
	if nState == self.STATE_ON_DING then
		if tbTask.szDoNextFunc and self[tbTask.szDoNextFunc] then
			Lib:CallBack({self[tbTask.szDoNextFunc], self, pPlayer, nNpcId, nTaskId});
		else
			pPlayer.CallClientScript("Task:OnTrack", nTaskId);
		end
		return;
	end

	if nState == self.STATE_CAN_ACCEPT then
		nDialogId = tbTask.nAcceptDialogId;
		pPlayer.nCurAcceptTaskId = nTaskId;
	elseif nState == self.STATE_CAN_FINISH then
		nDialogId = tbTask.nFinishDialogId;
		nFinishGuide = tbTask.IsFinishGuide;
	else
		return;
	end

	if nDialogId > 0 then
		pPlayer.CallClientScript("Ui:OpenTaskDialog", nTaskId, nNpcId, nDialogId, nState);
		return;
	end

	if nState == self.STATE_CAN_FINISH and tbTask.nNeedConfirmFinish > 0 then
		pPlayer.CallClientScript("Task:OpenConfirmPanel", nTaskId, nNpcId);
		return;
	end

	if nFinishGuide == 1 then
		pPlayer.CallClientScript("Guide:OnTaskCheck", nTaskId)
		return;
	end

	GameSetting:SetGlobalObj(pPlayer, him, it);
	c2s:OnFinishTaskDialog(nTaskId, nState, nNpcId);
	GameSetting:RestoreGlobalObj();
end

function Task:GetLogWay(nTaskType)
	if nTaskType == Task.TASK_TYPE_MAIN then
		return Env.LogWay_Task
	elseif nTaskType == Task.TASK_TYPE_WLDS or nTaskType == Task.TASK_TYPE_WLDS_CYCLE then
		return Env.LogWay_WldsTask
	elseif nTaskType == Task.TASK_TYPE_JYFL then
		return Env.LogWay_JYFL
	end
	return Env.LogWay_SubTask
end

function Task:SendTaskAward(pPlayer, nTaskId)
	local tbTask = Task:GetTask(nTaskId);
	if not tbTask then
		print("Task:SendTaskAward ERR ?? tbTask is nil !!", pPlayer.szName, pPlayer.dwID, nTaskId);
		return;
	end

	local taskType = Task:GetLogWay(tbTask.nTaskType);
	if tbTask.tbAward and #tbTask.tbAward > 0 then
		pPlayer.SendAward(tbTask.tbAward, false, true, taskType, nTaskId);
	end

	if Task.tbExtTaskAward[nTaskId] then
		pPlayer.SendAward(Task.tbExtTaskAward[nTaskId], nil, nil, taskType, nTaskId);
	end
end

function Task:ConsumeTaskItem(pPlayer, tbTask, bForce)
	local tbCollectItem = tbTask.tbTargetInfo["CollectItem"] or {};
	for nItemId, nCount in pairs(tbCollectItem) do
		if pPlayer.ConsumeItemInBag(nItemId, nCount, Env.LogWay_TaskItem) ~= nCount and not bForce then
			return false;
		end
	end

	return true;
end

function Task:ForceFinishTask(pPlayer, nTaskId, bNotSyncFinish)
	return self:DoFinishTask(pPlayer, nTaskId, -1, true, true, bNotSyncFinish);
end

function Task:TryFinishTask(pPlayer, nTaskId, nNpcId, bWhithoutMsg)
	if not nNpcId or nNpcId <= 0 then
		Log("Task:TryFinishTask nNpcId is -1 !!", pPlayer.szName, nTaskId, nNpcId, bWhithoutMsg and "true" or "false");
		Log(debug.traceback());
		return false;
	end

	return self:DoFinishTask(pPlayer, nTaskId, nNpcId, bWhithoutMsg);
end

function Task:DoFinishTask(pPlayer, nTaskId, nNpcId, bWhithoutMsg, bForce, bNotSyncFinish)
	local bCanFinish, szMsg = self:CheckCanFinishTask(pPlayer, nTaskId, nNpcId);
	if not bForce and not bCanFinish then
		if not bWhithoutMsg then
			pPlayer.Msg(szMsg);
			print("can not finish task >>" .. szMsg);
		end
		return false;
	end

	local tbTask = self:GetTask(nTaskId);
	if not self:ConsumeTaskItem(pPlayer, tbTask, bForce) then
		return false;
	end

	local _, tbPlayerTask, nIndex = self:GetPlayerTaskInfo(pPlayer, nTaskId);
	table.remove(tbPlayerTask.tbCurTaskInfo, nIndex);

	self:SetTaskFlag(pPlayer, nTaskId);
	if tbTask.nAutoNextTaskId and tbTask.nAutoNextTaskId > 0 then
		self:DoTaskNextStep(pPlayer, nNpcId, tbTask.nAutoNextTaskId);
	end

	if not bNotSyncFinish then
		pPlayer.CallClientScript("Task:OnFinishTask", nTaskId);
	end
	self:SendTaskAward(pPlayer, nTaskId);

	pPlayer.OnEvent("FinishTask", nTaskId, nNpcId);

	-- 如果是分流支线任务为分流主任务解锁一个点
	if Task:IsFlowTaskEndId(nTaskId) then
		Task:DoAddExtPoint(pPlayer, Task.nFlowTaskId, 1)
	end

	if not Lib:IsEmptyStr(tbTask.szAchievement) then
		Achievement:AddCount(pPlayer, tbTask.szAchievement, 1)
	end

	local taskType = Task:GetLogWay(tbTask.nTaskType);
	-- LogD(Env.LOGD_ActivityPlay, pPlayer.szAccount, pPlayer.dwID, pPlayer.nLevel, nTaskId, Env.LOGD_VAL_FINISH_TASK, taskType, pPlayer.GetFightPower());
	pPlayer.TLog("TaskFlow", pPlayer.nLevel, pPlayer.GetVipLevel(), taskType, nTaskId, 1)

	return true;
end

function Task:ForceAcceptTask(pPlayer, nTaskId, bNotSyncAccept, bForce)
	return self:DoAcceptTask(pPlayer, nTaskId, -1, bNotSyncAccept, bForce);
end

function Task:TryAcceptTask(pPlayer, nTaskId, nNpcId)
	if not nNpcId or nNpcId <= 0 then
		Log("Task:TryFinishTask nNpcId is -1 !!", pPlayer.szName, nTaskId, nNpcId, bWhithoutMsg and "true" or "false");
		Log(debug.traceback());
		return false;
	end
	return self:DoAcceptTask(pPlayer, nTaskId, nNpcId);
end

function Task:DoAcceptTask(pPlayer, nTaskId, nNpcId, bNotSyncAccept, bForce)
	local bCanAccept, szMsg, tbTask = self:CheckCanAcceptTask(pPlayer, nTaskId, nNpcId);
	if not bForce and not bCanAccept then
		pPlayer.Msg(szMsg);
		print("can not accept task >>" .. szMsg);
		return false;
	end
	if bForce and not tbTask then
		tbTask = self:GetTask(nTaskId)
	end

	local tbPlayerTask = self:GetPlayerTaskInfo(pPlayer);
	table.insert(tbPlayerTask.tbCurTaskInfo, {nTaskId = nTaskId, tbTargetInfo = {}});
	if not bNotSyncAccept then
		pPlayer.CallClientScript("Task:OnAcceptTask", nTaskId);
	end
	local taskType = Task:GetLogWay(tbTask.nTaskType);
	-- LogD(Env.LOGD_ActivityPlay, pPlayer.szAccount, pPlayer.dwID, pPlayer.nLevel, nTaskId, Env.LOGD_VAL_TAKE_TASK, taskType, pPlayer.GetFightPower());
	pPlayer.TLog("TaskFlow", pPlayer.nLevel, pPlayer.GetVipLevel(), taskType, nTaskId, 0)


	pPlayer.OnEvent("AcceptTask", nTaskId, nNpcId);
	Activity:OnPlayerEvent(pPlayer, "Act_OnAcceptTask", nTaskId);

	GameSetting:SetGlobalObj(pPlayer, him, it);
	self:OnEnterMap();
	self:CheckAndAutoFinish(me, "PersonalFuben", nil, nTaskId);
	self:CheckAndAutoFinish(me, "Achievement", nil, nTaskId);
	self:CheckAndAutoFinish(me, "MinLevel", nil, nTaskId);
	GameSetting:RestoreGlobalObj();
	return true;
end

function Task:OnZhenFaTaskDoNext(pPlayer, nNpcId, nTaskId)
	ZhenFaTask:OnZhenFaTaskDoNext(pPlayer, nNpcId, nTaskId);
end

function Task:OpenTaskVideo(pPlayer, nVideoType, nTaskId)
	local tbVideoTask = Task.tbAllVideoTask[nVideoType]
	if not tbVideoTask then
		Log("Task fnOpenTaskVideo no tbVideoTask", pPlayer.dwID, pPlayer.szName, nVideoType, nTaskId)
		return
	end
	pPlayer.CallClientScript("Task:OnOpenTaskVideo", nVideoType)
	Task:DoAddExtPoint(pPlayer, nTaskId, 1)
	Log("Task fnOpenTaskVideo Ok", pPlayer.dwID, pPlayer.szName, nVideoType, nTaskId)
end

local tbMap = Map:GetClass(Task.nJYFLTaskMapTId);
function tbMap:OnPlayerTrap(nMapId, szClassName)
	if szClassName == "jinshinei" then
		me.SetPosition(3280, 6516);
	elseif szClassName == "qushiwai" then
		me.SetPosition(5453, 17629);
	end
end

function Task:TryAcceptFlowTask(pPlayer, nFlowType)
	local tbFlowInfo = Task.tbFlowSetting[nFlowType]
	if not tbFlowInfo then
		return
	end
	if Task:HaveAcceptTask(pPlayer, tbFlowInfo.nStartTaskId) then
		pPlayer.CenterMsg("Đã tiếp nên nhiệm vụ tuyến", true)
		return
	end

	if Task:IsFinish(pPlayer, tbFlowInfo.nStartTaskId) then
		pPlayer.CenterMsg("Đã hoàn thành nên nhiệm vụ tuyến", true)
		return 
	end

	if Task:GetRunningFlowTaskType(pPlayer) then
		pPlayer.CenterMsg("Mời trước hoàn thành nhiệm vụ trước mặt tuyến", true)
		return
	end

	local bRet = Task:ForceAcceptTask(pPlayer, tbFlowInfo.nStartTaskId, nil, true)
	pPlayer.CenterMsg("Xác nhận nhiệm vụ tuyến thành công", true)
	Log("[Task] fnTryAcceptFlowTask ok", pPlayer.dwID, pPlayer.szName, nFlowType, tbFlowInfo.nStartTaskId)
end

function Task:TryAnswerFlowQuestion(pPlayer, nFlowType, tbAnswer)
	local bRet, szMsg, nQuestionTaskId, tbQuestion = self:CheckAnswerFlowQuestion(pPlayer, nFlowType, tbAnswer)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return 
	end
	local fnCostCallback = function (nPlayerId, bSuccess, szBillNo, nFlowType, tbAnswer)
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if not pPlayer then
			return false, "Khấu trừ Nguyên bảo quá trình bên trong ngươi rơi dây"
		end
		if not bSuccess then
			return false, "Khấu trừ Nguyên bảo thất bại"
		end
		local bRet, szMsg, nQuestionTaskId, tbQuestion = self:CheckAnswerFlowQuestion(pPlayer, nFlowType, tbAnswer, true)
		if not bRet then
			pPlayer.CenterMsg(szMsg, true)
			return 
		end
		local tbRight = {}
		local bRight = true
		for nIdx, v in ipairs(tbQuestion) do
			local nAnswerIdx = tbAnswer[nIdx]
			local nRight =  -1
			if not nAnswerIdx or nAnswerIdx ~= v.nAnswerIdx then
				bRight = false
				nRight = nAnswerIdx
			end
			tbRight[nIdx] = nRight
		end
		if bRight then
			Task:DoAddExtPoint(pPlayer, nQuestionTaskId, 1)
			pPlayer.CenterMsg("Trả lời chính xác", true)
		else
			pPlayer.CenterMsg("Có đề mục trả lời sai lầm, mời một lần nữa bài thi", true)
		end
		local nAnswerCount = pPlayer.GetUserValue(self.Flow_Save_Group, nFlowType);
		nAnswerCount = nAnswerCount + 1
		pPlayer.SetUserValue(self.Flow_Save_Group, nFlowType, nAnswerCount)
		
		pPlayer.CallClientScript("Task:OnAnswerFlowQuestion", bRight, nFlowType, tbRight)
		Log("[Task] fnTryAnswerFlowQuestion Ok", pPlayer.dwID, pPlayer.szName, nQuestionTaskId, nFlowType, nAnswerCount, tostring(bRight))
		return true
	end
	local nAnswerCount = pPlayer.GetUserValue(self.Flow_Save_Group, nFlowType);
	if nAnswerCount >= self.nFlowQuestionCostCount then
		local bRet = pPlayer.CostGold(self.nFlowQuestionCostGold, Env.LogWay_JYFL, nil, fnCostCallback, nFlowType, tbAnswer)
	    if not bRet then
	        pPlayer.CenterMsg("Thanh toán thất bại, mời thử lại")
	    end
	else
		fnCostCallback(pPlayer.dwID, true, nil, nFlowType, tbAnswer)
	end
end

function Task:CheckOldAchi(pPlayer)
	for _, v in ipairs(Task.tbOldAchi) do
		if self:IsFinish(pPlayer, v[1]) then
			Achievement:AddCount(pPlayer, v[2], 1)
		end
	end
end

function Task:OnAsyncBattleFightEnd(pPlayer, nResult, tbParams)
	Task:ForeachTaskCheck(pPlayer, "EnterMap", CheckEnterMapTask, SetEnterMapTarget, tbParams.nMapTemplateId)
end
AsyncBattle:ResgiterBattleType("Task_AsyncBattle_Fuben", Task, Task.OnAsyncBattleFightEnd)