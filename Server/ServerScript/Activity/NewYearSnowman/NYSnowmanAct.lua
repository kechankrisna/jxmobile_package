local tbAct = Activity:GetClass("NYSnowmanAct")

tbAct.tbTrigger  = {Init = {}, Start = {}, End = {}}

local NYSnowman = Kin.NYSnowman

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then
		self:InitAct()
	elseif szTrigger == "Start" then
		Activity:RegisterPlayerEvent(self, "Act_GatherAnswerWrong", "OnGatherAnswerWrong")
		Activity:RegisterPlayerEvent(self, "Act_GatherAnswerRight", "OnGatherAnswerRight")
		Activity:RegisterPlayerEvent(self, "Act_DialogNYSnowman", "OnDialogSnowman")
		Activity:RegisterGlobalEvent(self, "Act_OnKinMapCreate", "OnKinMapCreate")
		Activity:RegisterGlobalEvent(self, "Act_OnKinMapDestroy", "OnKinMapDestroy")
		Activity:RegisterGlobalEvent(self, "Act_OnKinGatherJoin", "OnKinGatherJoin")
		Activity:RegisterGlobalEvent(self, "Act_KinGather_Close", "OnKinGatherClose")
		Activity:RegisterGlobalEvent(self, "Act_KinGather_Question", "OnKinGatherQuestion")
		Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnPlayerLogin")
		self:OnStartAct()
	elseif szTrigger == "End" then
		self:OnEndAct()
	end
	Log("NYSnowmanAct OnTrigger:", szTrigger)
end

function tbAct:OnKinGatherQuestion(nKinId,tbGatherData)
	local kinData = Kin:GetKinById(nKinId)
	if not kinData or not kinData:IsMapOpen() then
		return 
	end

	if tbGatherData and tbGatherData.nCurQuestionIdx and tbGatherData.nCurQuestionIdx == 2 then
		local nPosX,nPosY = unpack(NYSnowman.tbSnowmanNpcPos)
		local szMsg = string.format("Thu hoạch được bông tuyết sau, đi nơi đây <%d,%d> Chồng chất bang phái người tuyết đi!",nPosX* Map.nShowPosScale,nPosY* Map.nShowPosScale)
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId, {nLinkType = ChatMgr.LinkType.Position, linkParam = {kinData:GetMapId(),nPosX,nPosY, Kin.Def.nKinMapTemplateId}});
	end
end

function tbAct:OnGatherAnswerWrong(pPlayer)
	if not NYSnowman:CheckLevel(pPlayer) then
		Log("[NYSnowmanAct] OnGatherAnswerWrong level limit",pPlayer.dwID,pPlayer.szName,pPlayer.dwKinId,pPlayer.nLevel)
		return
	end

	local nCount = MathRandom(NYSnowman.tbAnswerWrongBegin,NYSnowman.tbAnswerWrongEnd)

	pPlayer.SendAward({{"item", NYSnowman.nSnowflakeItemId, nCount}}, nil, true, Env.LogWay_NYSnowmanActBox);
	Log("[NYSnowmanAct] OnGatherAnswerWrong ",pPlayer.dwID,pPlayer.szName,pPlayer.dwKinId,pPlayer.nLevel)
end

function tbAct:OnGatherAnswerRight(pPlayer)
	if not NYSnowman:CheckLevel(pPlayer) then
		Log("[NYSnowmanAct] OnGatherAnswerRight level limit",pPlayer.dwID,pPlayer.szName,pPlayer.dwKinId,pPlayer.nLevel)
		return
	end

	local nCount = MathRandom(NYSnowman.tbAnswerRightBegin,NYSnowman.tbAnswerRightEnd)

	pPlayer.SendAward({{"item", NYSnowman.nSnowflakeItemId, nCount}}, nil, true, Env.LogWay_NYSnowmanActBox);

	Log("[NYSnowmanAct] OnGatherAnswerRight ",pPlayer.dwID,pPlayer.szName,pPlayer.dwKinId,pPlayer.nLevel)
end

function tbAct:OnDialogSnowman(pPlayer,pNpc)
	local nKinId = pNpc.tbTmp and pNpc.tbTmp.nKey
	if not nKinId or nKinId ~= pPlayer.dwKinId then
		Log("[SnowmanNpc] no match kin id",pPlayer.dwID,pPlayer.szName,pPlayer.dwKinId,nKinId or 0)
		return
	end

	local kinData = Kin:GetKinById(nKinId);
	if not kinData then
		Log("[SnowmanNpc] no kinData",pPlayer.dwID,pPlayer.szName,pPlayer.dwKinId,nKinId)
		return 
	end

	local fnDetail = function (dwID)
		local pPlayer = KPlayer.GetPlayerObjById(dwID)
		if pPlayer then
			pPlayer.CallClientScript("Ui:OpenWindow", "NewInformationPanel", "ShuangJieTongQing")
		end
	end

	local tbSnowmanData = kinData:GetSnowmanData()
	local tbOptList = {
		{Text = "Đống tuyết người", Callback = self.MakingSnowman, Param = {self, pNpc.nId,pPlayer.dwID}},
		{Text = "Nhận lấy người tuyết hộp quà", Callback = self.GetGiftBox, Param = {self, pPlayer.dwID}},
		{Text = "Hiểu rõ tường tình", Callback = fnDetail, Param = {pPlayer.dwID}}
	}

    Dialog:Show(
    {
        Text    = "Một năm mới muốn tới, giá trị này tết nguyên đán ngày hội, cùng một chỗ thật vui vẻ đống tuyết người đi!",
        OptList = tbOptList,
    }, pPlayer, pNpc);
end

function tbAct:GetGiftBox(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
		return
	end

	local kinData = Kin:GetKinById(pPlayer.dwKinId);
	if not kinData then
		pPlayer.CenterMsg("Mời trước gia nhập bang phái")
		return
	end

	local tbSnowmanData = kinData:GetSnowmanData()
	if not tbSnowmanData.nProcess or tbSnowmanData.nProcess ~= NYSnowman.Process_Type.MAKING then
		pPlayer.CenterMsg("Bang phái tụ tập sưởi ấm lúc mới có thể nhận lấy bảo rương!")
		return
	end

	-- 因为对话框所以检查
	if not NYSnowman:IsRunning() then
		pPlayer.CenterMsg("Hoạt động đã kết thúc")
		return 
	end

	local nAward = DegreeCtrl:GetDegree(pPlayer, "NYSnowmanActAward")
	if nAward < 1 then
		pPlayer.CenterMsg("Hôm nay ngươi đã nhận lấy quá khen lệ!")
		return
	end

	if not NYSnowman:CheckLevel(pPlayer) then
		pPlayer.CenterMsg(string.format("Mời trước đem đẳng cấp tăng lên tới %d Cấp!",NYSnowman.JOIN_LEVEL))
		return
	end

	if not DegreeCtrl:ReduceDegree(pPlayer, "NYSnowmanActAward", 1) then
		pPlayer.CenterMsg("Nhận lấy hộp quà số lần khấu trừ thất bại", true)
		return 
	end

	local nStartTime = self:GetOpenTimeInfo()
	self:TryResetTimes(pPlayer, GetTime(), nStartTime)

	pPlayer.SendAward(NYSnowman.tbDayAward, nil, true, Env.LogWay_NYSnowmanActBox);

	Activity:OnPlayerEvent(pPlayer, "Act_NYSnowmanGetGiftBox", tbSnowmanData.nSnowmanNpcLevel)
end

function tbAct:MakingSnowman(nNpcId,dwID)
	if not nNpcId or not dwID then
		return
	end

	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
		return
	end

	local bRet,szMsg = self:CheckMaking(pPlayer,nNpcId)
	if not bRet then
		pPlayer.CenterMsg(szMsg)
		return
	end
   
    local fnMaking = function (dwID,nNpcId)
   		local pMaker = KPlayer.GetPlayerObjById(dwID)
		if not pMaker then
			return
		end
		local bRet,szMsg = self:CheckMaking(pMaker,nNpcId)
		if not bRet then
			pMaker.CenterMsg(szMsg)
			return
		end
		local nHave,kinData = unpack(szMsg)
		local nKinId = kinData.nKinId
		local nConsume = pMaker.ConsumeItemInAllPos(NYSnowman.nSnowflakeItemId,nHave, Env.LogWay_NYSnowmanActBox);
	    if nConsume < nHave then
	    	pMaker.CenterMsg("Khấu trừ bông tuyết thất bại!",true);
	    	Log("[SnowmanNpc] MakingSnowman no kinData",pMaker.dwID,pMaker.szName,nKinId,nConsume,nHave)
	    	return
	    end
	    local nNpcLevel = NYSnowman:GetLevelBySnowflake(kinData.nSnowflake)
	    local nSnowflake = (kinData.nSnowflake or 0) + nHave
	    kinData:SetSnowflake(nSnowflake)
	    pPlayer.AddExperience(nConsume * NYSnowman.nSnowFlakeExp,Env.LogWay_NYSnowmanActBox)
	    tbAct:OnUpdateSnowman(pMaker)
	    Dialog:SendBlackBoardMsg(pMaker, string.format("Thành công tiến hành %d Lần đống tuyết người, người tuyết tựa hồ biến lớn chút!",nConsume));
	    Log("[SnowmanNpc] MakingSnowman ok ",pMaker.dwID,pMaker.szName,nKinId,kinData.szName,nSnowflake,nNpcLevel,nConsume,nHave)
	end

	local nHave = unpack(szMsg)
	pPlayer.MsgBox(string.format("Ngài trước mắt có được「Bông tuyết」%d cái, đem toàn bộ dùng để đống tuyết người?",nHave),
		{
			{"Xác định", fnMaking, pPlayer.dwID,nNpcId},
			{"Hủy bỏ"},
		})
end

function tbAct:CheckMaking(pPlayer,nNpcId)
	
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc then
		Log("[SnowmanNpc] MakingSnowman no pNpc",nNpcId,dwID)
		return false,"Người tuyết không thấy?"
	end

	local nKinId = pNpc.tbTmp and pNpc.tbTmp.nKey
	if not nKinId or pPlayer.dwKinId ~= nKinId then
		Log("[SnowmanNpc] MakingSnowman no match kin id ",nNpcId,dwID,pPlayer.szName,pPlayer.dwKinId,nKinId or 0)
		return false,"Bang phái nào người tuyết?"
	end

	local kinData = Kin:GetKinById(nKinId);
	if not kinData then
		Log("[SnowmanNpc] MakingSnowman no kinData",pPlayer.dwID,pPlayer.szName,pPlayer.dwKinId,nKinId)
		return false,"Ngươi là bang phái nào?"
	end

	if not NYSnowman:CheckLevel(pPlayer) then
		return false,string.format("Mời trước đem đẳng cấp tăng lên tới %d Cấp",NYSnowman.JOIN_LEVEL)
	end

    local nHave = pPlayer.GetItemCountInAllPos(NYSnowman.nSnowflakeItemId)
    if nHave <= 0 then
    	return false,"Mời thu thập một chút「Bông tuyết」Lại đến đống tuyết người"
    end

	-- 因为对话框所以检查
	if not NYSnowman:IsRunning() then
		return false,"Hoạt động đã kết thúc"
	end

    return true,{nHave,kinData}
end

function tbAct:TraverseInKinMap(kinData, fnCall, ...)
	local tbMember  = Kin:GetKinMembers(kinData.nKinId)
	local nKinMapId = kinData:GetMapId()
	for nPlayerId, _ in pairs(tbMember) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if pPlayer and pPlayer.nMapId == nKinMapId then
			fnCall(pPlayer, ...)
		end
	end
end

function tbAct:OnStartAct()
	local fnCall = function (pPlayer)
		pPlayer.CallClientScript("Kin.NYSnowman:ShowEffect")
	end
	Kin:TraverseKin(function (kinData)
		kinData:ResetSnowmanData()
		self:CreateNpc(kinData)
		if kinData:IsMapOpen() then
			Lib:CallBack({tbAct.TraverseInKinMap,tbAct,kinData,fnCall});
		end
	end);

	local nStartTime = self:GetOpenTimeInfo()
	local nNowTime = GetTime()
	local tbPlayer = KPlayer.GetAllPlayer()
    for _, pPlayer in pairs(tbPlayer) do
        self:TryResetTimes(pPlayer,nNowTime,nStartTime)
    end
end

function tbAct:TryResetTimes(pPlayer,nNowTime,nStartTime)
	local nUpdateTime = pPlayer.GetUserValue(NYSnowman.SAVE_ONHOOK_GROUP, NYSnowman.Update_Time);
    if nUpdateTime < nStartTime then
    	pPlayer.SetUserValue(NYSnowman.SAVE_ONHOOK_GROUP,NYSnowman.Award_Count,0)
    	pPlayer.SetUserValue(NYSnowman.SAVE_ONHOOK_GROUP,NYSnowman.Update_Time,nNowTime)
    end
end

function tbAct:OnPlayerLogin()
	local nStartTime = self:GetOpenTimeInfo()
	local nNowTime = GetTime()
	self:TryResetTimes(me,nNowTime,nStartTime)
end

function tbAct:InitAct()
	Kin:TraverseKin(function (kinData)
		kinData:SetSnowflake(0)
		kinData:ResetMakingPlayer()
	end);
	Log("[NYSnowmanAct] InitAct ")
end

function tbAct:OnEndAct()
	Kin:TraverseKin(function (kinData)
		if kinData:IsMapOpen() then
			self:RemoveNpc(kinData)
		end
		kinData:ResetSnowmanData()
		kinData:SetSnowflake(0)
		kinData:ResetMakingPlayer()
	end);
end

function tbAct:OnKinGatherClose()
	Kin:TraverseKin(function (kinData)
			local tbSnowmanData = kinData:GetSnowmanData()
			if tbSnowmanData.nProcess and tbSnowmanData.nProcess == NYSnowman.Process_Type.MAKING then
				tbSnowmanData.nProcess = nil
			else
				Log("[NYSnowmanAct] OnKinGatherClose no match process",nKinId,tbSnowmanData.nProcess or 0)
			end
		end)
end

function tbAct:PlayEffect(kinData)
	local tbSnowmanData = kinData:GetSnowmanData()
	local tbSnowHeadNpc = tbSnowmanData.tbSnowHeadNpc or {}
	for nNpcId,tbPos in pairs(tbSnowHeadNpc) do
		local pNpc = KNpc.GetById(nNpcId);
		if pNpc then
			-- 放技能播特效
			pNpc.CastSkill(NYSnowman.nFireWorksSkill, 1, tbPos[1], tbPos[2]);
		end
	end
end

function tbAct:OnKinGatherJoin(nKinId)
	local kinData = Kin:GetKinById(nKinId);
	if not kinData then
		Log("[NYSnowmanAct] OnKinGatherJoin no kinData",nKinId)
		return
	end
	local tbSnowmanData = kinData:GetSnowmanData()
	local nSnowflake = kinData.nSnowflake or 0
	local nNewSnowmanNpcLevel = NYSnowman:GetLevelBySnowflake(nSnowflake)
	tbSnowmanData.nSnowmanNpcLevel = nNewSnowmanNpcLevel
	tbSnowmanData.nProcess = NYSnowman.Process_Type.MAKING
	tbSnowmanData.tbPlayerCount = {}
end

function tbAct:OnUpdateSnowman(pPlayer)
	local nKinId = pPlayer.dwKinId or 0
	local kinData = Kin:GetKinById(nKinId);
	if not kinData then
		Log("[NYSnowmanAct] OnUpdateSnowman no kinData",pPlayer.dwID,pPlayer.szName,nKinId)
		return 
	end
	if not kinData:IsMapOpen() then
		Log("[NYSnowmanAct] OnUpdateSnowman no kin map",pPlayer.dwID,pPlayer.szName,nKinId)
		return 
	end
	local tbSnowmanData = kinData:GetSnowmanData()
	local nSnowflake = kinData.nSnowflake or 0
	local nNewSnowmanNpcLevel,nSnowmanNpcTId = NYSnowman:GetLevelBySnowflake(nSnowflake)
	local nOldSnowmanNpcLevel = tbSnowmanData.nSnowmanNpcLevel
	-- 记录堆雪人玩家
	kinData:SetMakingPlayer(nOldSnowmanNpcLevel + 1,pPlayer.dwID)

	if nNewSnowmanNpcLevel ~= nOldSnowmanNpcLevel then
		local nOldLevelSnowflake = NYSnowman.tbSnowmanLevel[nOldSnowmanNpcLevel]
		local nOldNpcId = tbSnowmanData.nSnowmanNpcId
		local pSnowmanNpc = KNpc.Add(nSnowmanNpcTId, 1, 0, kinData:GetMapId(), NYSnowman.tbSnowmanNpcPos[1], NYSnowman.tbSnowmanNpcPos[2],0,NYSnowman.nSnowmanDir);
		if pSnowmanNpc then
			tbSnowmanData.nSnowmanNpcId = pSnowmanNpc.nId
			tbSnowmanData.nSnowmanNpcLevel = nNewSnowmanNpcLevel
			pSnowmanNpc.tbTmp = {nKey = nKinId}
			local pNpc = KNpc.GetById(nOldNpcId)
			if pNpc then
				pNpc.Delete()
			end

			local nCrossLevel = nNewSnowmanNpcLevel - nOldSnowmanNpcLevel

			for nLevel = 1,nCrossLevel do
				local nContribLevel = nOldSnowmanNpcLevel + nLevel
				local nUpLevelSnowflake = NYSnowman.tbSnowmanLevel[nContribLevel - 1]
				-- 如果玩家堆的雪花使雪人跨等级，两级都有玩家的贡献
				if nSnowflake > nUpLevelSnowflake then
					kinData:SetMakingPlayer(nContribLevel + 1,pPlayer.dwID)
					Log("[NYSnowmanAct] OnUpdateSnowman CrossLevel",pPlayer.dwID,pPlayer.szName,nContribLevel,nUpLevelSnowflake)
				end
			end

			for nLevel = 1,nCrossLevel do
				local nUpLevel = nOldSnowmanNpcLevel + nLevel
				self:SnownmanUpdateAward(kinData,nUpLevel)
				local szColor = NYSnowman.tbColor[nUpLevel] or "-"
				local szTip = string.format("Bản bang phái tết nguyên đán người tuyết thăng cấp, phẩm chất đề thăng làm %s Sắc! Làm lần này thăng cấp tiến hành「Đống tuyết người」Bang phái thành viên thu được ban thưởng, mời kiểm tra và nhận bưu kiện!",szColor)
				ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szTip, nKinId);
			end
			Lib:CallBack({tbAct.PlayEffect,tbAct,kinData});
			Log("[NYSnowmanAct] OnUpdateSnowman pSnowmanNpc ok",nMapId,nSnowmanNpcTId,nKinId,nNewSnowmanNpcLevel,nOldSnowmanNpcLevel,nSnowflake,nCrossLevel)
		else
			Log("[NYSnowmanAct] OnUpdateSnowman no pSnowmanNpc",nMapId,nSnowmanNpcTId,nKinId,nNewSnowmanNpcLevel,nOldSnowmanNpcLevel,nSnowflake)
		end
	end
end

function tbAct:SnownmanUpdateAward(kinData,nLevel)
	local tbAward = NYSnowman.tbMakinkAward[nLevel]
	if tbAward then
		local tbMakingPlayer = kinData.tbMakingPlayer or {}
		local tbPlayer = tbMakingPlayer[nLevel] or {}
		if not next(tbPlayer) then
			Log("[NYSnowmanAct] SnownmanUpdateAward no tbPlayer",nLevel,kinData.nKinId,kinData.nSnowflake or 0)
			return
		end
		for nPlayerId,_ in pairs(tbPlayer) do
			local pPlayerStay = KPlayer.GetRoleStayInfo(nPlayerId) or {};
  			local nKinId = pPlayerStay.dwKinId or -1
  			-- 防止退出家族
  			if nKinId == kinData.nKinId then
				local tbMail = {
					To = nPlayerId;
					Title = "Người tuyết bảo rương";
					From = "Hệ thống";
					Text = "Đại hiệp, bởi vì ngài cùng bang phái thành viên không ngừng cố gắng, bang phái tết nguyên đán người tuyết trở nên càng lớn tốt hơn! Vì cảm tạ mọi người, bang phái nhân viên quản lý đưa cho mọi người một phần thần bí lễ vật, mời kiểm tra và nhận!";
					tbAttach = tbAward;
					nLogReazon = Env.LogWay_NYSnowmanActBox;
					};
				Mail:SendSystemMail(tbMail);
			else
				Log("[NYSnowmanAct] SnownmanUpdateAward out kin",nLevel,kinData.nKinId,nKinId,kinData.nSnowflake or 0)
			end
		end
	end
	Log("[NYSnowmanAct] SnownmanUpdateAward ",nLevel,kinData.nKinId,kinData.nSnowflake or 0,tbAward and "ok" or "NoAward")
end

function tbAct:CreateNpc(kinData)
	if not kinData:IsMapOpen() then
		return
	end
	self:RemoveNpc(kinData)
	local nMapId = kinData:GetMapId()
	local tbSnowmanData = kinData:GetSnowmanData()
	local nSnowflake = kinData.nSnowflake or 0
	local nSnowmanNpcLevel,nSnowmanNpcTId = NYSnowman:GetLevelBySnowflake(nSnowflake)
	local pSnowmanNpc = KNpc.Add(nSnowmanNpcTId, 1, 0,nMapId,NYSnowman.tbSnowmanNpcPos[1], NYSnowman.tbSnowmanNpcPos[2],0,NYSnowman.nSnowmanDir);
	if pSnowmanNpc then
		tbSnowmanData.nSnowmanNpcId = pSnowmanNpc.nId
		tbSnowmanData.nSnowmanNpcLevel = nSnowmanNpcLevel
		pSnowmanNpc.tbTmp = {nKey = kinData.nKinId}
		Log("[NYSnowmanAct] CreateNpc pSnowmanNpc ok",kinData.nKinId,nSnowmanNpcLevel,nSnowflake,nSnowmanNpcTId)
	else
		Log("[NYSnowmanAct] CreateNpc no pSnowmanNpc",kinData.nKinId,nSnowmanNpcLevel,nSnowflake,nSnowmanNpcTId)
	end
	tbSnowmanData.tbSnowHeadNpc = tbSnowmanData.tbSnowHeadNpc or {}
	for nIndex,tbPos in ipairs(NYSnowman.tbSnowHead) do
		local pHeadNpc = KNpc.Add(NYSnowman.nSnowHeadNpcId, 1, 0, nMapId,tbPos[1], tbPos[2]);
		if pHeadNpc then
			tbSnowmanData.tbSnowHeadNpc[pHeadNpc.nId] = tbPos
		else
			Log("[NYSnowmanAct] CreateNpc pHeadNpc fail",kinData.nKinId)
		end
	end
	Log("[NYSnowmanAct] CreateNpc >>> ",kinData.nKinId)
end

function tbAct:RemoveNpc(kinData)
	local tbSnowmanData = kinData:GetSnowmanData()
	if tbSnowmanData.nSnowmanNpcId then
		local pNpc =  KNpc.GetById(tbSnowmanData.nSnowmanNpcId)
		if pNpc then
			pNpc.Delete()
		end
		tbSnowmanData.nSnowmanNpcId = nil
	end
	tbSnowmanData.tbSnowHeadNpc = tbSnowmanData.tbSnowHeadNpc or {}
	if next(tbSnowmanData.tbSnowHeadNpc) then
		for nNpcId,_ in pairs(tbSnowmanData.tbSnowHeadNpc) do
			local pHeadNpc = KNpc.GetById(nNpcId);
			if pHeadNpc then
				pHeadNpc.Delete()
			end
			tbSnowmanData.tbSnowHeadNpc[nNpcId] = nil
		end
	end
end

function tbAct:OnKinMapCreate(nMapId)
	local nKinId = Kin:GetKinIdByMapId(nMapId) or 0
	local kinData = Kin:GetKinById(nKinId);
	if not kinData then
		Log("[NYSnowmanAct] OnKinMapCreate no kinData",nMapId,nKinId)
		return 
	end
	self:CreateNpc(kinData)
end

function tbAct:OnKinMapDestroy(nMapId)
	local nKinId = Kin:GetKinIdByMapId(nMapId) or 0
	local kinData = Kin:GetKinById(nKinId);
	if not kinData then
		Log("[NYSnowmanAct] OnKinMapDestroy no kinData",nMapId,nKinId)
		return 
	end
    self:RemoveNpc(kinData)
end
