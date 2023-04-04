TeacherStudent.tbApplyList = TeacherStudent.tbApplyList or {}
TeacherStudent.tbSearchList = TeacherStudent.tbSearchList or {
	tbTeachers = {},
	tbStudents = {},
}

-- requests
local tbValidRequests = {
	ApplyAsTeacher = true,
	ApplyAsStudent = true,
	AcceptApply = true,
	ReqChuanGong = true,
	AcceptChuanGongReq = true,
	ReportTargets = true,
	ConfirmTargetReport = true,
	ReqDismiss = true,
	CancelDismiss = true,
	RefreshOtherStatusInfoReq = true,
	RefreshApplyListReq = true,
	RefreshStudentListReq = true,
	RefreshTeacherListReq = true,
	RefreshMainInfoReq = true,
	GiveGraduateReward = true,
	ChangeTeacherSettings = true,
	ReqForceGraduate = true,
	ReqGraduate = true,
	ClearApplyList = true,
	AssignCustomTasks = true,
	ReportCustomTasks = true,
	CustomTaskRemindTeacherReq = true,
}

function TeacherStudent:OnRequest(szFunc, ...)
	if not tbValidRequests[szFunc] then
		Log("[x] TeacherStudent:OnRequest, invalid req", szFunc, ...)
		return
	end

	if self.bClosed then
		me.CenterMsg("Hệ thống sư đồ đang bảo trì")
		return
	end

	local tbSetting = self:GetCurrentTimeFrameSettings()
	if not tbSetting then
		return false, "Hệ thống chưa mở"
	end

	local func = self[szFunc]
	if not func then
		Log("[x] TeacherStudent:OnRequest, unknown req", szFunc, ...)
		return
	end

	local bSuccess, szErr = func(self, ...)
	if bSuccess==false and szErr then
		me.CenterMsg(szErr)
		return
	end
end

function TeacherStudent:CustomTaskRemindTeacherReq(nTeacherId)
	local nStudentId = me.dwID
	if not self:IsMyTeacher(me, nTeacherId) then
		return false, "Đối phương không phải sư phụ của ngươi"
	end

	local tbStudent = self:GetPlayerScriptTable(me)
	local tbTeacher = tbStudent.tbTeachers[nTeacherId]
	if not tbTeacher.bGraduate then
		return false, "Ngươi chưa từ đối phương môn hạ xuất sư"
	end

	if tbTeacher.tbCustomTasks and next(tbTeacher.tbCustomTasks.tbTasks or {}) then
		return false, "Đối phương đã cho ngươi bố trí nhiệm vụ"
	end

	SendPrivateMsg(me.dwID, nTeacherId, "Sư phụ ngươi tuần này còn không có cho ta bố trí nhiệm vụ, hoàn thành nhiệm vụ sau sư đồ đều có thể thu hoạch được ban thưởng a.< Tiến về bố trí >", {
			nLinkType = ChatMgr.LinkType.OpenWnd,
			tbParams = {"SocialPanel", "MasterPanel", "MainInfo", me.dwID},
	})
	
	local szMsg = "Đã nhắc nhở sư phụ bố trí nhiệm vụ"
	me.Msg(szMsg)
	me.CenterMsg(szMsg)
end

function TeacherStudent:ApplyAsTeacher(nStudentId)
	local pStudent = KPlayer.GetPlayerObjById(nStudentId)
	if not pStudent then
		return false, "Đối phương chưa online"
	end

	local bOk, szErr = self:_CheckBeforeAdd(me, pStudent)
	if not bOk then
		return false, szErr
	end

	bOk, szErr = self:_AddToApplyList(nStudentId, me, true)
	if not bOk then
		return false, szErr
	end

	self:_SendConnectApplyNotify(me, nStudentId, true)
end

function TeacherStudent:ApplyAsStudent(nTeacherId)
	local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
	if not pTeacher then
		return false, "Đối phương chưa online"
	end

	local bOk, szErr = self:_CheckBeforeAdd(pTeacher, me)
	if not bOk then
		return false, szErr
	end

	bOk, szErr = self:_AddToApplyList(nTeacherId, me, false)
	if not bOk then
		return false, szErr
	end

	self:_SendConnectApplyNotify(me, nTeacherId, false)
end

function TeacherStudent:AcceptApply(nTargetId)
	local tbMyApplyList = self.tbApplyList[me.dwID] or {}
	local tbTargetInfo = tbMyApplyList[nTargetId]
	if not tbTargetInfo then
		return false, "Đối phương không có trong danh sách"
	end

	local pTarget = KPlayer.GetPlayerObjById(nTargetId)
	if not pTarget then
		return false, "Đối phương chưa online"
	end

	tbMyApplyList[nTargetId] = nil

	local pTeacher, pStudent
	if tbTargetInfo.bAsTeacher then
		pTeacher, pStudent = pTarget, me
	else
		pTeacher, pStudent = me, pTarget
	end

	local bOk, szErr = self:_CheckBeforeAdd(pTeacher, pStudent)
	if not bOk then
		return false, szErr
	end

	self:_DoAddAfterCheck(pTeacher, pStudent)
end

function TeacherStudent:ReqChuanGong(nTargetId)
	local pTarget = KPlayer.GetPlayerObjById(nTargetId)
	if not pTarget then
		return false, "Đối phương chưa online"
	end

	local pTeacher, pStudent = self:_GetRelations(me, pTarget)
	if not pTeacher then
		return false, "Các ngươi không phải quan hệ thầy trò"
	end

	local bOk, szErr = self:_CheckBeforeChuanGong(pTeacher, pStudent)
	if not bOk then
		return false, szErr
	end

	local bOtherTeacher = nTargetId==pTeacher.dwID
	self:_SendNotifyMsg(pTarget, bOtherTeacher and "TSChuanGongGet" or "TSChuanGongSend", {
		szName = me.szName,
		nId = me.dwID,
		nKinId = me.dwKinId,
		bTeacher = bOtherTeacher,
	})
	local szTip = bOtherTeacher and "Đã gửi yêu cầu cho 「%s」, đợi đối phương xác nhận" or "Đã gửi yêu truyền công cầu cho 「%s」, đợi đối phương xác nhận"
	me.CenterMsg(string.format(szTip, pTarget.szName))

	return true
end

function TeacherStudent:AcceptChuanGongReq(nReqPid)
	local pReqPlayer = KPlayer.GetPlayerObjById(nReqPid)
	if not pReqPlayer then
		return false, "Đối phương chưa online"
	end

	local pTeacher, pStudent = self:_GetRelations(me, pReqPlayer)
	if not pTeacher then
		return false, "Các ngươi không phải quan hệ thầy trò"
	end

	local bOk, szErr = self:_CheckBeforeChuanGong(pTeacher, pStudent)
	if not bOk then
		return false, szErr
	end

	self:_DoChuanGongAfterCheck(pTeacher, pStudent)
end

function TeacherStudent:AssignCustomTasks(nStudentId, tbTasks)
	if not self:IsMyStudent(me, nStudentId) then
		return false, "Đối phương không phải đồ đệ của ngươi"
	end

	local pStudent = KPlayer.GetPlayerObjById(nStudentId)
	if not pStudent then
		return false, "Đồ đệ không ibkube, không thể bố trí nhiệm vụ"
	end

	local tbTeacher = self:GetPlayerScriptTable(me)
	if not tbTeacher.tbStudents[nStudentId].bGraduate then
		return false, "Đối phương chưa xuất sư"
	end

	if me.nLevel-pStudent.nLevel < self.Def.nCustomTaskLvDiff then
		return false, "Chỉ có đồ đệ nhỏ hơn cấp của bạn mới có thể giao nhiệm vụ"
	end

	local tbStudent = self:GetPlayerScriptTable(pStudent)
	local tbCustomTasks = tbStudent.tbTeachers[me.dwID].tbCustomTasks or {
		nLastAssignTime = 0,
	}
	if tbCustomTasks.tbTasks then
		return false, "Đã bố trí qua nhiệm vụ, mời lên giao nhiệm vụ"
	end

	local nNow = GetTime()
	if not Lib:IsDiffWeek(nNow, tbCustomTasks.nLastAssignTime, 0) then
		return false, "Tuần này đã bố trí qua nhiệm vụ, thứ hai hãy tiếp tục"
	end

	local tbTaskProgress = {}
	for _, nTaskId in ipairs(tbTasks) do
		tbTaskProgress[nTaskId] = 0
	end
	if Lib:CountTB(tbTaskProgress)~=self.Def.nCustomTaskCount then
		return false, string.format("Bố trí nhiệm vụ số lượng nhất định phải là %d cái", self.Def.nCustomTaskCount)
	end

	tbCustomTasks.nLastAssignTime = nNow
	tbCustomTasks.tbTasks = tbTaskProgress

	tbStudent.tbTeachers[me.dwID].tbCustomTasks = Lib:CopyTB(tbCustomTasks)
	tbTeacher.tbStudents[nStudentId].tbCustomTasks = Lib:CopyTB(tbCustomTasks)

	self:_SendNotifyMsg(pStudent, "TSAssignCustomTasks", {
		szName = me.szName,
		nId = me.dwID,
	})
	me.CallClientScript("TeacherStudent:OnAssignedCustomTasks", pStudent.dwID, tbTasks, nNow)
	pStudent.CallClientScript("TeacherStudent:OnAssignedCustomTasks", me.dwID, tbTasks, nNow)
	me.CenterMsg(string.format("Đã giao nhiệm vụ cho「%s」", pStudent.szName))
	Log("TeacherStudent:AssignCustomTasks", me.dwID, nStudentId, table.concat(tbTasks, ","))
end

function TeacherStudent:_CustomTargetGetFinished(tbTasks)
	local tbRet = {}
	for nTaskId, nProgress in pairs(tbTasks) do
		if self:IsCustomTargetFinished(nTaskId, nProgress) then
			table.insert(tbRet, nTaskId)
		end
	end
	return tbRet
end

--[[
存储结构:
tbCustomTaskRewards = {
	nLastReset = timestamp,	--上次重置时间
	tbData = {
		[1] = {	--前两名
			[StudentId1] = count1,
			[StudentId2] = count2,
		},
		[2] = {
			[StudentId3] = count3,
			...
		},
	}
}
]]
function TeacherStudent:_CustomTargetAddTeacherReward(pTeacher, pStudent, nFinishedCount)
	local nTeacherId = pTeacher.dwID
	local nStudentId = pStudent.dwID

	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	local tbRewardInfo = tbTeacher.tbCustomTaskRewards or {}
	local nNow = GetTime()
	if Lib:IsDiffWeek(tbRewardInfo.nLastReset or 0, nNow, 0) then
		Log("TeacherStudent:_CustomTargetAddTeacherReward, reset", tostring(tbRewardInfo.nLastReset), nNow, nTeacherId, nStudentId, nFinishedCount)
		tbRewardInfo.nLastReset = nNow
		tbRewardInfo.tbData = nil
	end

	local tbRewards = tbRewardInfo.tbData or {
		[1] = {},
		[2] = {},
	}

	local szStatus = "not_satisfy"
	local nTeacherReward = 0
	if Lib:CountTB(tbRewards[1])<self.Def.nCustomTaskRewardTop then
		tbRewards[1][nStudentId] = nFinishedCount
		szStatus = "dont_need_payback"
		nTeacherReward = self:GetCustomTargetRewardsByCount(nFinishedCount)
	else
		local nMinCount = math.huge
		local nMinId = 0
		for nStudentId, nCount in pairs(tbRewards[1]) do
			if nCount<nMinCount then
				nMinId = nStudentId
				nMinCount = nCount
			end
		end
		if nMinCount<nFinishedCount then
			tbRewards[2][nMinId] = nMinCount
			tbRewards[1][nMinId] = nil
			tbRewards[1][nStudentId] = nFinishedCount
			szStatus = "need_payback"
			local nRewardOld = self:GetCustomTargetRewardsByCount(nMinCount)
			local nRewardNew = self:GetCustomTargetRewardsByCount(nFinishedCount)
			nTeacherReward = nRewardNew-nRewardOld
		else
			tbRewards[2][nStudentId] = nFinishedCount
		end
	end

	tbRewardInfo.tbData = tbRewards
	tbTeacher.tbCustomTaskRewards = tbRewardInfo
	
	return szStatus, nTeacherReward
end

function TeacherStudent:ReportCustomTasks(nTeacherId)
	if not self:IsMyTeacher(me, nTeacherId) then
		return false, "Đối phương không phải sư phụ của ngươi"
	end

	local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
	if not pTeacher then
		return false, "Sư phụ online mới có thể hồi báo"
	end

	local tbStudent = self:GetPlayerScriptTable(me)
	if not tbStudent.tbTeachers[nTeacherId].bGraduate then
		return false, "Ngươi chưa xuất sư"
	end

	local tbCustomTasks = tbStudent.tbTeachers[nTeacherId].tbCustomTasks
	if not tbCustomTasks or not tbCustomTasks.tbTasks then
		return false, "Sư phụ chưa giao nhiệm vụ"
	end

	local tbTasks = tbCustomTasks.tbTasks
	local tbFinished = self:_CustomTargetGetFinished(tbTasks)
	if #tbFinished<self.Def.nCustomTaskReportMin then
		return false, string.format("Hoàn thành ít nhất %d nhiệm vụ mới có thể hồi báo", self.Def.nCustomTaskReportMin)
	end

	tbCustomTasks.tbTasks = nil
	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	tbTeacher.tbStudents[me.dwID].tbCustomTasks = tbCustomTasks
	pTeacher.CallClientScript("TeacherStudent:OnReportCustomTasks", me.dwID)
	me.CallClientScript("TeacherStudent:OnReportCustomTasks", nTeacherId)

	local _, nStudentReward, nFinishedCount = self:GetCustomTargetRewards(tbTasks, true)
    me.SendAward({{"BasicExp", nStudentReward}}, true, nil, Env.LogWay_TS_CustomTasks)

	local szStatus, nTeacherReward = self:_CustomTargetAddTeacherReward(pTeacher, me, nFinishedCount)
	self:_CustomTargetSendTeacherReward(nTeacherId, me, nFinishedCount, szStatus, nTeacherReward)

	Log("TeacherStudent:ReportCustomTasks", nTeacherId, me.dwID, nFinishedCount, table.concat(tbFinished, ","), nTeacherReward, nStudentReward, szStatus)
end

function TeacherStudent:_CustomTargetSendTeacherReward(nTeacherId, pStudent, nFinishedCount, szStatus, nTeacherReward)
	local szMailContent = ""
	local tbTeacherRewards = {
		{"Renown", nTeacherReward},
	}
	if nTeacherReward<=0 then
		tbTeacherRewards = nil
	end

	local szStudentName = pStudent.szName
	if szStatus=="not_satisfy" then
		szMailContent = string.format([[    Đồ đệ của ngươi [FFFE0D]%s[-] Hoàn thành ngươi bố trí [FFFE0D]%d[-] Cái nhiệm vụ, nhiệm vụ hoàn thành số tại tuần này tất cả đồ đệ bên trong [FFFE0D] Sắp xếp trước hai vị về sau [-], lần này sư đồ nhiệm vụ sư phụ không ban thưởng.
    
Tiểu đề bày ra:
· Đồ đệ hoàn thành nhiệm vụ số lượng càng nhiều, song phương ban thưởng càng cao
· Sư phụ ban thưởng mỗi tuần lấy hoàn thành nhiệm vụ số nhiều nhất hai cái đồ đệ tính toán]], szStudentName, nFinishedCount)
	elseif szStatus=="dont_need_payback" then
		szMailContent = string.format([[    Đồ đệ của ngươi [FFFE0D]%s[-] Hoàn thành ngươi bố trí [FFFE0D]%d[-] Cái nhiệm vụ, phụ kiện là phần thưởng của ngươi!
    
Tiểu đề bày ra:
· Đồ đệ hoàn thành nhiệm vụ số lượng càng nhiều, song phương ban thưởng càng cao
· Sư phụ ban thưởng mỗi tuần lấy hoàn thành nhiệm vụ số nhiều nhất hai cái đồ đệ tính toán]], szStudentName, nFinishedCount)
	elseif szStatus=="need_payback" then
		szMailContent = string.format([[    Đồ đệ của ngươi [FFFE0D]%s[-] Hoàn thành ngươi bố trí [FFFE0D]%d[-] Cái nhiệm vụ, nhiệm vụ hoàn thành số tại tuần này tất cả đồ đệ bên trong [FFFE0D] Sắp xếp trước hai vị [-], ngươi danh vọng ban thưởng sai biệt xin thông qua phụ kiện nhận lấy!
    
Tiểu đề bày ra:
· Đồ đệ hoàn thành nhiệm vụ số lượng càng nhiều, song phương ban thưởng càng cao
· Sư phụ ban thưởng mỗi tuần lấy hoàn thành nhiệm vụ số nhiều nhất hai cái đồ đệ tính toán]], szStudentName, nFinishedCount)
	end

	Mail:SendSystemMail({
		To = nTeacherId,
		Title = "Báo cáo nhiệm vụ",
		Text = szMailContent,
		From = "Thượng Quan Phi Long",
		tbAttach = tbTeacherRewards,
		nLogReazon = Env.LogWay_TS_CustomTasks,
	})
end

function TeacherStudent:ReportTargets(nTeacherId)
	local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
	if not pTeacher then
		return false, "Sư phụ không lên mạng"
	end

	local bOk, szErr, tbTargets = self:_CheckBeforeReport(pTeacher, me)
	if not bOk then
		return false, szErr
	end

	self:_SendNotifyMsg(pTeacher, "TSReportReq", {
		szName = me.szName,
		nId = me.dwID,
		tbTargets = tbTargets,
	})
	me.CenterMsg(string.format("Gửi cho「%s」 báo cáo nhiệm vụ, hãy chờ xác nhận", pTeacher.szName))
end

function TeacherStudent:ConfirmTargetReport(nStudentId)
	local pStudent = KPlayer.GetPlayerObjById(nStudentId)
	if not pStudent then
		return false, "Đối phương chưa online"
	end

	local bOk, szErr, tbTargets = self:_CheckBeforeReport(me, pStudent)
	if not bOk then
		return false, szErr
	end

	self:_DoConfirmReportAfterCheck(me, pStudent, tbTargets)
end

function TeacherStudent:ReqDismiss(nTargetId)
	local tbMe = self:GetPlayerScriptTable(me)
	local bTargetTeacher = tbMe.tbTeachers[nTargetId]
	local bTargetStudent = tbMe.tbStudents[nTargetId]
	if bTargetTeacher==bTargetStudent then
		Log("[x] TeacherStudent:ReqDismiss failed, not connected", tostring(bTargetTeacher), tostring(bTargetStudent), me.dwID, nTargetId)
		return false, "Đối phương cùng ngươi không phải quan hệ thầy trò "
	end

	local tbDismissing = ScriptData:GetValue("TSDismissing")
	tbDismissing[me.dwID] = tbDismissing[me.dwID] or {}

	local nNow = GetTime()
	if tbDismissing[me.dwID][nTargetId] and tbDismissing[me.dwID][nTargetId][1]>nNow then
		return false, "Đã trong thời gian chờ giải trừ quan hệ"
	end

	local bGraduate = false
	if bTargetStudent then
		bGraduate = tbMe.tbStudents[nTargetId].bGraduate
	else
		bGraduate = tbMe.tbTeachers[nTargetId].bGraduate
	end

	local function DoAfterPay(pPlayer)
		local bForce = true
		if not bGraduate then
			local _, nOffSeconds = Player:GetOfflineDays(nTargetId)
			bForce = nOffSeconds>=self.Def.nForceDissmissTime
		end

		local nDismissDeadline = self:_ComputeDismissDeadline(bGraduate, nTargetId)
		tbDismissing[pPlayer.dwID][nTargetId] = {nDismissDeadline, bForce, bGraduate}
		ScriptData:AddModifyFlag("TSDismissing")

		self:_PushToClient(pPlayer, "TS_DISMISS", {
			nId = nTargetId,
			nDismissDeadline = nDismissDeadline,
		})

		pPlayer.CenterMsg("Xin giải trừ quan hệ thầy trò thành công ")
		Log("TeacherStudent:ReqDismiss", pPlayer.dwID, nTargetId, tostring(bTargetTeacher), tostring(bGraduate), self.Def.nGraduateDismissCost)
	end

	if bGraduate then
		if me.GetMoney("Gold") < self.Def.nGraduateDismissCost then
			return false, "Nguyên bảo không đủ!"
		end

		me.CostGold(self.Def.nGraduateDismissCost, Env.LogWay_TS_Dismiss, 0, function(nPlayerId, bSuccess)
			local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
			if not pPlayer then
				return false, "Khi giải trừ quan hệ thầy trò, bạn ngoại tuyến"
			end
			if not bSuccess then
				return false, "Tiêu hao Nguyên bảo thất bại "
			end
			DoAfterPay(pPlayer)
			Dialog:SendBlackBoardMsg(pPlayer, string.format("Tiêu hao %d Nguyên bảo [FFFE0D]( Hủy bỏ xin sau tự động trả lại )[-]", self.Def.nGraduateDismissCost));
			return true
		end)
	else
		DoAfterPay(me)
	end
end

function TeacherStudent:CancelDismiss(nTargetId)
	local tbDismissing = ScriptData:GetValue("TSDismissing")
	tbDismissing[me.dwID] = tbDismissing[me.dwID] or {}
	local tbDismissInfo = tbDismissing[me.dwID][nTargetId]
	if not tbDismissInfo then
		return false, "Bạn không ở trong trạng thái bị giải trừ"
	end

	tbDismissing[me.dwID][nTargetId] = nil
	ScriptData:AddModifyFlag("TSDismissing")

	self:_PushToClient(me, "TS_DISMISS", {
		nId = nTargetId,
		nDismissDeadline = 0,
	})

	me.CallClientScript("TeacherStudent:OnSrvRsp", "CancelDismiss", {
		nOtherId = nTargetId,
	})

	local _, _, bGraduate = unpack(tbDismissInfo)
	if bGraduate then
		local bOtherTeacher = self:IsMyTeacher(me, nTargetId)
		local pStay = KPlayer.GetRoleStayInfo(nTargetId)
		Mail:SendSystemMail({
			To = me.dwID,
			Title = "Hủy bỏ giải trừ quan hệ sư đồ",
			Text = string.format("    Cùng %s [FFFE0D]%s[-] Giải trừ quan hệ thầy trò xin đã bị ngươi hủy bỏ! Phụ kiện trả lại xin lúc chỗ tốn hao [FFFE0D]%d Nguyên bảo [-], mời kịp thời nhận lấy.",
				bOtherTeacher and "Sư phụ" or "Đồ đệ", pStay.szName, self.Def.nGraduateDismissCost),
			From = "Thượng Quan Phi Long",
			tbAttach = {
				{"Gold", self.Def.nGraduateDismissCost},
			},
			nLogReazon = Env.LogWay_TS_CancelDismiss,
		})
	end
	Log("TeacherStudent:CancelDismiss", me.dwID, nTargetId, tostring(bGraduate), self.Def.nGraduateDismissCost)
end

function TeacherStudent:RefreshOtherStatusInfoReq(nOtherId)
	local tbResult = self:_GetOtherStatusInfo(me, nOtherId)
	if tbResult then
		me.CallClientScript("TeacherStudent:OnRefreshOtherStatusInfoRsp", tbResult)
	end
end

function TeacherStudent:RefreshApplyListReq()
	local tbResult = self:_GetApplyList(me)
	if tbResult then
		me.CallClientScript("TeacherStudent:OnRefreshApplyListRsp", tbResult)
	end
end

function TeacherStudent:RefreshStudentListReq()
	local tbResult = self:_GetStudentList(me)
	if tbResult then
		me.CallClientScript("TeacherStudent:OnRefreshStudentListRsp", tbResult)
	end
end

function TeacherStudent:RefreshTeacherListReq()
	local tbResult = self:_GetTeacherList(me)
	if tbResult then
		me.CallClientScript("TeacherStudent:OnRefreshTeacherListRsp", tbResult)
	end
end

function TeacherStudent:RefreshMainInfoReq()
	local tbResult = self:_GetMainInfo(me)
	if tbResult then
		me.CallClientScript("TeacherStudent:OnRefreshMainInfoRsp", tbResult)
	end
end

function TeacherStudent:GiveGraduateReward(nStudentId, nItemId, szMsg)
	local pStudent = KPlayer.GetPlayerObjById(nStudentId)
	if not pStudent then
		return false, "Đối phương chưa online"
	end

	local nLen = Lib:Utf8Len(szMsg or "")
	if nLen>self.Def.nGiftMsgMax then
		return false, string.format("Độ dài nhiều nhất %d chữ", self.Def.nGiftMsgMax)
	end

	local bOk, szErr = self:_CheckBeforeGiveGraduateReward(me, pStudent, nItemId)
	if not bOk then
		return false, szErr
	end
	self:_GiveGraduateRewardAfterCheck(me, pStudent, nItemId, szMsg)
	me.CallClientScript("TeacherStudent:OnSrvRsp", "GiveGraduateReward", {
		nStudentId = nStudentId,
	})
end

function TeacherStudent:ChangeTeacherSettings(bNotice, xValue)
	local tbTeacher = self:GetPlayerScriptTable(me)
	if bNotice then
		xValue = tostring(xValue)
		local nLen = Lib:Utf8Len(xValue)
		if nLen>self.Def.nTeacherDeclarationMax then
			return false, string.format("Thông báo nhận đồ đệ nhiều nhất %d chữ", self.Def.nTeacherDeclarationMax)
		end

		tbTeacher.tbSettings.szNotice = xValue
	else
		local bClosed = not not xValue
		if tbTeacher.tbSettings.bClosed~=bClosed then
			tbTeacher.tbSettings.bClosed = bClosed
			if bClosed then
				self:_RemoveFromSearchList(me.dwID)
			else
				self:_CheckAddToSearchList(me)
			end
		end
	end
	me.CenterMsg("Sửa chữa thành công")
end

function TeacherStudent:ReqForceGraduate(nOtherId)
	local bOk, szErr = self:CheckBeforeForceGraduate(me, nOtherId)
	if not bOk then
		return false, szErr
	end

	self:_DoForceGraduateAfterCheck(me, nOtherId)
end

function TeacherStudent:ReqGraduate(nTeacherId, nStudentId)
	local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
	local pStudent = KPlayer.GetPlayerObjById(nStudentId)
	if not pTeacher or not pStudent then
		return false, "Đối phương chưa online"
	end

	local bOk, szErr = self:_CheckBeforeGraduate(pTeacher, pStudent)
	if not bOk then
		return false, szErr
	end

	self:_DoGraduateAfterCheck(pTeacher, pStudent)
end

function TeacherStudent:ClearApplyList()
	self.tbApplyList[me.dwID] = nil
end

-- helpers

function TeacherStudent:GetPlayerScriptTable(pPlayer)
	local tbScriptTable = pPlayer.GetScriptTable("TeacherStudent")
	if not tbScriptTable.bInited then
		tbScriptTable.bInited = true

		tbScriptTable.tbSettings = {
			szNotice = "",
			bClosed = false,
		}

		tbScriptTable.tbTeachers = {}
		tbScriptTable.tbStudents = {}
		tbScriptTable.tbChuanGong = {}
		tbScriptTable.nLastChuanGong = 0
		tbScriptTable.nAcceptCount = 0
		tbScriptTable.nLastAccept = 0
		tbScriptTable.nPunishDeadline = 0
		tbScriptTable.nImityReportCount = 0
	end

	return tbScriptTable
end

function TeacherStudent:IsMyTeacher(pMe, nOtherId)
	local tbMe = self:GetPlayerScriptTable(pMe)
	return tbMe.tbTeachers[nOtherId]
end

function TeacherStudent:IsMyStudent(pMe, nOtherId)
	local tbMe = self:GetPlayerScriptTable(pMe)
	return tbMe.tbStudents[nOtherId]
end

function TeacherStudent:_IsRelationValid(pTeacher, pStudent)
	return self:IsMyTeacher(pStudent, pTeacher.dwID) and self:IsMyStudent(pTeacher, pStudent.dwID)
end

function TeacherStudent:_IsConnected(pPlayer1, pPlayer2)
	return self:_GetRelations(pPlayer1, pPlayer2)~=nil
end

-- return teacher, student(valid) or nil(invalid)
function TeacherStudent:_GetRelations(pPlayer1, pPlayer2)
	if self:_IsRelationValid(pPlayer1, pPlayer2) then
		return pPlayer1, pPlayer2
	elseif self:_IsRelationValid(pPlayer2, pPlayer1) then
		return pPlayer2, pPlayer1
	end

	return nil
end

function TeacherStudent:_IsPunishing(tbPlayer)
	return tbPlayer.nPunishDeadline>GetTime()
end

function TeacherStudent:_CanAddStudent(pPlayer)
	local bImPlayer = pPlayer==me
	local tbSetting = self:GetCurrentTimeFrameSettings()
	if not tbSetting then
		return false, "Sư đồ hệ thống chưa mở ra "
	end

	if pPlayer.nLevel<tbSetting.nTeaLvMin then
		return false, bImPlayer and "Đẳng cấp của ngươi đủ điều kiện nhận đệ tử" or "Đẳng cấp đối phương đủ điều kiện nhận đệ tử"
	end

	local tbPlayer = self:GetPlayerScriptTable(pPlayer)

	local nNow = GetTime()
	local nPunishCd = tbPlayer.nPunishDeadline-nNow
	local nAcceptCd = tbPlayer.nAcceptCount>=self.Def.nAddStudentNoCdCount and tbPlayer.nLastAccept+self.Def.nAddStudentInterval-nNow or 0
	if nPunishCd>0 or nAcceptCd>0 then
		self:_RemoveFromSearchList(pPlayer.dwID)
		if nPunishCd>nAcceptCd then
			return false, bImPlayer and string.format("Ngươi đang trong thời gian trừng phạt sư đồ,Sau %s có thể thu đệ tử", Lib:TimeDesc5(nPunishCd)) or "Đối phương đang trong thời gian trừng phạt sư đồ, không thể bái làm sư "
		end
		return false, bImPlayer and string.format("Đang trong thời gian giãn cách thu nhận đệ tử, sau %s có thể nhận đệ tử", Lib:TimeDesc5(nAcceptCd)) or "Đối phương đang trong thời gian giãn cách thu nhận đệ tử, không thể bái làm sư "
	end

	local nUngraduateCount = 0
	for _, tbStudent in pairs(tbPlayer.tbStudents) do
		if not tbStudent.bGraduate then
			nUngraduateCount = nUngraduateCount+1
		end
	end
	if nUngraduateCount>=self.Def.nMaxUndergraduate then
		self:_RemoveFromSearchList(pPlayer.dwID)
		return false, bImPlayer and "Số lượng đệ tử đã đầy" or "Số lượng đệ tử của đối phương đã đầy"
	end

	return true
end

function TeacherStudent:_CanAddTeacher(pPlayer)
	local bImPlayer = pPlayer==me
	local tbSetting = self:GetCurrentTimeFrameSettings()
	if not tbSetting then
		return false, "Hệ thống sư đồ chưa mở"
	end

	if pPlayer.nLevel<tbSetting.nStuLvMin then
		return false, bImPlayer and "Đẳng cấp của ngươi không vừa lòng bái sư điều kiện " or "Đối phương đẳng cấp không vừa lòng bái sư điều kiện "
	end

	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	if self:_IsPunishing(tbPlayer) then
		return false, bImPlayer and string.format("Ngươi ở vào giải trừ quan hệ thầy trò trừng phạt, %s Sau bái sư ", Lib:TimeDesc5(tbPlayer.nPunishDeadline-GetTime())) or "Đối phương ở vào giải trừ quan hệ thầy trò trừng phạt, không cách nào thu làm đồ "
	end

	local nTeacherCount = Lib:CountTB(tbPlayer.tbTeachers)
	if nTeacherCount>=self.Def.nMaxTeachers then
		self:_RemoveFromSearchList(pPlayer.dwID)
		return false, bImPlayer and "Số lượng sư phụ đã đầy" or "Số lượng sư phụ của đối phương đã đầy"
	end

	return true
end

function TeacherStudent:_IsLevelValidToAdd(pTeacher, pStudent)
	local tbSetting = self:GetCurrentTimeFrameSettings()
	if not tbSetting then
		return false, "Hệ thống sư đồ chưa mở"
	end

	local nCurVip = math.max(pTeacher.GetVipLevel(), pStudent.GetVipLevel())
	local nLvDiff = self:GetConnectLvDiff(nCurVip)
	if (pTeacher.nLevel-pStudent.nLevel)<nLvDiff then
		return false, string.format("Đẳng cấp chênh lệch không đủ %d Cấp ", nLvDiff)
	end

	return true
end

function TeacherStudent:_CheckBeforeAdd(pTeacher, pStudent)
	if self:_IsConnected(pTeacher, pStudent) then
		return false, "Đã là quan hệ thầy trò "
	end

	local bOk, szErr = self:_CanAddTeacher(pStudent)
	if not bOk then
		return false, szErr
	end

	bOk, szErr = self:_CanAddStudent(pTeacher)
	if not bOk then
		return false, szErr
	end

	bOk, szErr = self:_IsLevelValidToAdd(pTeacher, pStudent)
	if not bOk then
		return false, szErr
	end

	return true
end

function TeacherStudent:_AddToApplyList(nTargetId, pApplyer, bAsTeacher)
	self.tbApplyList[nTargetId] = self.tbApplyList[nTargetId] or {}
	if self.tbApplyList[nTargetId][pApplyer.dwID] then
		return false, "Xin đã gửi đi, xin chờ đợi đối phương xác nhận "
	end

	if Lib:CountTB(self.tbApplyList[nTargetId])>=self.Def.nApplyListMax then
		return false, "Danh sách xin đối phương đã đầy"
	end

	local szKinName = ""
	local tbKin = Kin:GetKinByMemberId(pApplyer.dwID)
	if tbKin then
		szKinName = tbKin.szName
	end

	self.tbApplyList[nTargetId][pApplyer.dwID] = {
		nId = pApplyer.dwID,
		szName = pApplyer.szName,
		szKinName = szKinName,
		nLevel = pApplyer.nLevel,
		nFaction = pApplyer.nFaction,
		nPortrait = pApplyer.nPortrait,
		nHonorLevel = pApplyer.nHonorLevel,
		bAsTeacher = bAsTeacher,
		nTime = GetTime(),
	}
	return true
end

function TeacherStudent:_SendNotifyMsg(pPlayer, szType, tbData)
	tbData.szType = szType
	tbData.nTimeOut = GetTime()+self.Def.TIME_DELAY
	pPlayer.CallClientScript("Ui:SynNotifyMsg", tbData)
end

function TeacherStudent:_SendConnectApplyNotify(pMe, nOtherId, bTeacher)
	local pOther = KPlayer.GetPlayerObjById(nOtherId)
	if not pOther then
		return
	end

	self:_SendNotifyMsg(pOther, "TSConnectReq", {
		szName = pMe.szName,
		nId = pMe.dwID,
		bOtherTeacher = bTeacher,
	})
	pOther.CallClientScript("TeacherStudent:OnApply")
	local szTip = bTeacher and "Đã gửi yêu cầu đến 「%s」, chờ xác nhận" or "Đã gửi yêu cầu đến 「%s」, chờ xác nhận"
	pMe.CenterMsg(string.format(szTip, pOther.szName))
end

function TeacherStudent:_IsAlreadyFinished(tbPlayerStatus, nTargetId)
	if nTargetId==3 then --成功加入家族
		return tbPlayerStatus.nKinId>0

	elseif nTargetId==14 then --将身上1件装备洗满6条属性
		return tbPlayerStatus.nRefineCount>=1
	elseif nTargetId==15 then --将全身10件装备洗满6条属性
		return tbPlayerStatus.nRefineCount>=10

	elseif nTargetId==16 then --全身穿满传承以上装备
		return tbPlayerStatus.bAllCC
	elseif nTargetId==17 then --全身穿满稀有装备
		return tbPlayerStatus.bAllXY

	elseif nTargetId==40 then --全身装备强化+20
		return tbPlayerStatus.nStrengthLevel>=20
	elseif nTargetId==41 then --全身装备强化+30
		return tbPlayerStatus.nStrengthLevel>=30
	elseif nTargetId==42 then --全身装备强化+40
		return tbPlayerStatus.nStrengthLevel>=40

	elseif nTargetId==43 then --镶嵌20个以上1级魂石
		return tbPlayerStatus.nInsertLevel>=1
	elseif nTargetId==44 then --镶嵌20个以上2级魂石
		return tbPlayerStatus.nInsertLevel>=2
	elseif nTargetId==45 then --镶嵌20个以上3级魂石
		return tbPlayerStatus.nInsertLevel>=3
	elseif nTargetId==46 then --镶嵌20个以上4级魂石
		return tbPlayerStatus.nInsertLevel>=4

	elseif nTargetId==49 then --达到惊鸿头衔
		return tbPlayerStatus.nHonorLevel>=3
	elseif nTargetId==50 then --达到凌云头衔
		return tbPlayerStatus.nHonorLevel>=4
	elseif nTargetId==51 then --达到御空头衔
		return tbPlayerStatus.nHonorLevel>=5
	elseif nTargetId==52 then --达到潜龙头衔
		return tbPlayerStatus.nHonorLevel>=6

	elseif nTargetId==53 then --与师傅亲密度达到10级
		return tbPlayerStatus.nImityLevel>=10
	elseif nTargetId==54 then --与师傅亲密度达到15级
		return tbPlayerStatus.nImityLevel>=15
	elseif nTargetId==55 then --与师傅亲密度达到20级
		return tbPlayerStatus.nImityLevel>=20

	elseif nTargetId==63 then --购买一本万利
		return tbPlayerStatus.bBoughtInvest

	elseif nTargetId==64 then --达到Vip6级
		return tbPlayerStatus.nVipLevel>=6
	end
	return false
end

function TeacherStudent:_GetInitTargetStates(pStudent, nTeacherId)
	local bAllCC, bAllXY = self:_GetEquipQualityState(pStudent)
	local tbStudentStatus = {
		nKinId = pStudent.dwKinId or 0,
		nRefineCount = Item.tbRefinement:GetFullRefineCount(pStudent),
		bAllCC = bAllCC,
		bAllXY = bAllXY,
		nStrengthLevel = Strengthen:GetMinEnhLevel(pStudent),
		nInsertLevel = StoneMgr:UpdateInsetAttrib(pStudent),
		nHonorLevel = pStudent.nHonorLevel,
	 	nImityLevel = FriendShip:GetFriendImityLevel(pStudent.dwID, nTeacherId) or 0,
	 	bBoughtInvest = Recharge:HasBoughtInvest(pStudent),
	 	nVipLevel = pStudent.GetVipLevel(),
	}

	local tbStates = {}
	for nTargetId, tbSetting in pairs(self.tbTargets) do
		local nCurrent = self:_IsImityTarget(nTargetId) and 0 or pStudent.GetUserValue(self.Def.nTargetProgressGroup, nTargetId)
		if nCurrent>=tbSetting.nNeed then
			tbStates[nTargetId] = self.Def.tbTargetStates.FinishedBefore
		elseif self:_IsAlreadyFinished(tbStudentStatus, nTargetId) then
			tbStates[nTargetId] = self.Def.tbTargetStates.NotReport
			if self:_IsImityTarget(nTargetId) then
				local tbStudent = self:GetPlayerScriptTable(pStudent)
				if (tbStudent.nImityReportCount or 0)>=self.Def.nMaxImityReportCount then
					tbStates[nTargetId] = self.Def.tbTargetStates.FinishedBefore
				end
			else
				self:_TargetForceFinished(pStudent, nTargetId)
			end
		end
	end
	return tbStates
end

function TeacherStudent:_CheckResetData(tbPlayer)
	local nNow = GetTime()
	if next(tbPlayer.tbChuanGong) then
		if Lib:IsDiffDay(self.Def.nChuanGongRefreshOffset, nNow, tbPlayer.nLastChuanGong) then
			tbPlayer.tbChuanGong = {}
		end
	end
end

function TeacherStudent:_DoAddAfterCheck(pTeacher, pStudent)
	local nNow = GetTime()
	local tbTargetStates = self:_GetInitTargetStates(pStudent, pTeacher.dwID)

	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	tbTeacher.tbStudents[pStudent.dwID] = {
		bGraduate = false,
		nRewardCount = 0,
		nConnectTime = nNow,
		tbTargetStates = Lib:CopyTB(tbTargetStates),
	}

	self:_CheckResetData(tbTeacher)
	tbTeacher.nAcceptCount = tbTeacher.nAcceptCount+1
	tbTeacher.nLastAccept = nNow

	local tbStudent = self:GetPlayerScriptTable(pStudent)
	tbStudent.tbTeachers[pTeacher.dwID] = {
		bGraduate = false,
		nRewardCount = 0,
		nConnectTime = nNow,
		tbTargetStates = Lib:CopyTB(tbTargetStates),
	}

	FriendShip:ForceAddFriend(pTeacher, pStudent)
	self:_AddTitle(pTeacher, pStudent)

	self:_PushMainInfo(pTeacher)
	self:_PushMainInfo(pStudent)

	local szTeacherNotice = string.format("Đã nhận 「%s」 làm đệ tử", pStudent.szName)
	pTeacher.Msg(szTeacherNotice)
	pTeacher.CenterMsg(szTeacherNotice)
	pTeacher.CallClientScript("TeacherStudent:OnSrvRsp", "_DoAddAfterCheck", {
		nOtherId = pStudent.dwID,
	})

	local szStudentNotice = string.format("Đã bái 「%s」 làm sư phụ", pTeacher.szName)
	pStudent.Msg(szStudentNotice)
	pStudent.CenterMsg(szStudentNotice)
	pStudent.CallClientScript("TeacherStudent:OnSrvRsp", "_DoAddAfterCheck", {
		nOtherId = pTeacher.dwID,
	})

	Log("TeacherStudent:_DoAddAfterCheck", pTeacher.dwID, pStudent.dwID)
end

function TeacherStudent:_GetUnusedTitleId(pPlayer)
	for i, nTitleId in ipairs(self.Def.tbTitleIds) do
		local nOtherId = pPlayer.GetUserValue(self.Def.nTitleGroup, i)
		if not nOtherId or nOtherId<=0 then
			return nTitleId
		end
	end
end

function TeacherStudent:_SetTitleIdUsed(pPlayer, nUsedTitleId, nOtherId)
	for i, nTitleId in ipairs(self.Def.tbTitleIds) do
		if nTitleId==nUsedTitleId then
			pPlayer.SetUserValue(self.Def.nTitleGroup, i, nOtherId)
			break
		end
	end
end

function TeacherStudent:_RemoveTitleWith(pPlayer, nOtherId)
	for i, nTitleId in ipairs(self.Def.tbTitleIds) do
		local nSaveId = pPlayer.GetUserValue(self.Def.nTitleGroup, i)
		if nOtherId==nSaveId then
			pPlayer.DeleteTitle(nTitleId, true)
			pPlayer.SetUserValue(self.Def.nTitleGroup, i, 0)
			return true
		end
	end
	return false
end

function TeacherStudent:_AddTitleWith(pMe, bImTeacher, nOtherId, szOtherName)
	local nTitleId = self:_GetUnusedTitleId(pMe)
	if not nTitleId then
		Log("[x] TeacherStudent:_AddTitleWith, get unused title id failed", pMe.dwID, bImTeacher, nOtherId, szOtherName)
		return
	end

	local szTitle = bImTeacher and string.format("Sư phụ %s ", szOtherName) or string.format("Đồ đệ %s", szOtherName)
	pMe.AddTitle(nTitleId, 0, false, false, szTitle)
	self:_SetTitleIdUsed(pMe, nTitleId, nOtherId)
end

function TeacherStudent:_AddTitle(pTeacher, pStudent)
	self:_AddTitleWith(pTeacher, true, pStudent.dwID, pStudent.szName)
	self:_AddTitleWith(pStudent, false, pTeacher.dwID, pTeacher.szName)
end

function TeacherStudent:_CheckChuanGongCount(pPlayer, nOtherId)
	local nNow = GetTime()
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	self:_CheckResetData(tbPlayer)
	if not Lib:IsDiffDay(self.Def.nChuanGongRefreshOffset, nNow, tbPlayer.nLastChuanGong) then
		if Lib:IsInArray(tbPlayer.tbChuanGong, nOtherId) then
			return false, "Các ngươi hôm nay đã truyền công "
		end
		if #tbPlayer.tbChuanGong>=self.Def.nDailyChuanGongMax then
			local bImPlayer = me==pPlayer
			return false, bImPlayer and "Số lần truyền công hôm nay đã hết" or "Số lần truyền công đối phương hôm nay đã hết"
		end
	end
	return true
end

function TeacherStudent:_CheckBeforeChuanGong(pTeacher, pStudent)
	local tbStudent = self:GetPlayerScriptTable(pStudent)
	if tbStudent.tbTeachers[pTeacher.dwID].bGraduate then
		return false, "Đồ đệ đã xuất sư "
	end

	local bOk, szErr = self:_CheckChuanGongCount(pTeacher, pStudent.dwID)
	if not bOk then
		return false, szErr
	end

	bOk, szErr = self:_CheckChuanGongCount(pStudent, pTeacher.dwID)
	if not bOk then
		return false, szErr
	end

	bOk, szErr = ChuangGong:CheckLevelLimi(pTeacher.nLevel, pStudent.nLevel, pTeacher.GetVipLevel(), pStudent.GetVipLevel())
	if not bOk then
		if pStudent.nLevel >= pTeacher.nLevel then
			szErr = pStudent==me and "Đẳng cấp của ngươi ≥ Sư phụ, không thể truyền công" or "Đẳng cấp của ngươi thấp hơn đệ tử, không thể truyền công"
		end
		return false, szErr
	end

	return true
end

function TeacherStudent:_DoChuanGongAfterCheck(pTeacher, pStudent)
	ChuangGong:PrcoceedChuangGong(pStudent, pTeacher, "TeacherStudent")
	Log("TeacherStudent:_DoChuanGongAfterCheck", pTeacher.dwID, pStudent.dwID)
end

function TeacherStudent:_GetTargetState(pStudent, nTargetId, nTeacherId)
	local tbStudent = self:GetPlayerScriptTable(pStudent)
	local tbTeacher = tbStudent.tbTeachers[nTeacherId]
	if not tbTeacher then
		Log("[x] TeacherStudent:_GetTargetState, not connected", pStudent.dwID, nTeacherId, nTargetId)
		return
	end

	local nState = tbTeacher.tbTargetStates[nTargetId]
	if not nState then
		local nImityLevel = self.Def.tbImityTargetsIdToLevels[nTargetId]
		if nImityLevel then
			local nCurLevel = FriendShip:GetFriendImityLevel(pStudent.dwID, nTeacherId) or 0
			if nCurLevel>=nImityLevel then
				return self.Def.tbTargetStates.NotReport
			end
		end
		return self.Def.tbTargetStates.NotFinish
	end
	return nState
end

function TeacherStudent:_GetCanReportTargets(pTeacher, pStudent)
	local tbRet = {}
	for nTargetId, tbTarget in ipairs(self.tbTargets) do
		local nState = self:_GetTargetState(pStudent, nTargetId, pTeacher.dwID)
		if nState==self.Def.tbTargetStates.NotReport then
			table.insert(tbRet, nTargetId)
		end
	end
	return tbRet
end

function TeacherStudent:_CheckBeforeReport(pTeacher, pStudent)
	if not self:_IsRelationValid(pTeacher, pStudent) then
		return false, "Các ngươi không phải quan hệ thầy trò "
	end

	local bImTeacher = pTeacher==me
	local tbStudent = self:GetPlayerScriptTable(pStudent)
	if tbStudent.tbTeachers[pTeacher.dwID].bGraduate then
		return false, bImTeacher and "Đối phương đã xuất sư, không thể báo cáo " or "Ngươi đã xuất sư, không thể báo cáo "
	end

	local tbTargets = self:_GetCanReportTargets(pTeacher, pStudent)
	if #tbTargets<=0 then
		return false, "Không có mục tiêu báo cáo"
	end

	return true, "", tbTargets
end

function TeacherStudent:_DoConfirmReportAfterCheck(pTeacher, pStudent, tbTargets)
	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	local tbStudent = self:GetPlayerScriptTable(pStudent)

	local nTotalExp = 0
	local nTotalRenown = 0
	local tbReportedTargets = {}
	local bIgnoreImityReward = false
	for _, nTargetId in ipairs(tbTargets) do
		table.insert(tbReportedTargets, nTargetId)

		tbTeacher.tbStudents[pStudent.dwID].tbTargetStates[nTargetId] = self.Def.tbTargetStates.Reported
		tbStudent.tbTeachers[pTeacher.dwID].tbTargetStates[nTargetId] = self.Def.tbTargetStates.Reported

		if self:_IsImityTarget(nTargetId) then
			tbStudent.nImityReportCount = (tbStudent.nImityReportCount or 0)+1
			if tbStudent.nImityReportCount>self.Def.nMaxImityReportCount then
				bIgnoreImityReward = true
			end
		end
		if not bIgnoreImityReward then
			local tbTargetSetting = self:GetTargetSetting(nTargetId)
			if tbTargetSetting then
				nTotalExp = nTotalExp+tbTargetSetting.nStudentExp
				nTotalRenown = nTotalRenown+tbTargetSetting.nTeacherRenown
			end
		end
	end
	if #tbReportedTargets>0 then
		self:_PushToClient(pTeacher, "TS_TAR_RPT", {
			nId = pStudent.dwID,
			tbTargets = tbReportedTargets,
		})
		self:_PushToClient(pStudent, "TS_TAR_RPT", {
			nId = pTeacher.dwID,
			tbTargets = tbReportedTargets,
		})
	end

	if nTotalExp>0 then
		pStudent.AddExperience(nTotalExp, Env.LogWay_TS_Report)
		local szStudentNotice = string.format("Báo cáo thành công mục tiêu, báo cáo này đã đạt được %d kinh nghiệm", nTotalExp)
		pStudent.CenterMsg(szStudentNotice)
		pStudent.Msg(szStudentNotice)
	end
	if bIgnoreImityReward then
		pStudent.Msg("Vì số lượng báo cáo tích lũy cho mục tiêu thân mật của bạn đã đạt đến giới hạn trên, báo cáo này sẽ không đưa ra phần thưởng mục tiêu thân mật.")
	end

	if nTotalRenown>0 then
		pTeacher.AddMoney("Renown", nTotalRenown, Env.LogWay_TS_Report)
		local szTeacherNotice = string.format("Xác nhận thành công mục tiêu, báo cáo này đã đạt được %d danh vọng", nTotalRenown)
		pTeacher.CenterMsg(szTeacherNotice)
		pTeacher.Msg(szTeacherNotice)
	end
	if bIgnoreImityReward then
		pTeacher.Msg("Do số lượng mục tiêu thân mật của tích lũy đã đạt đến giới hạn trên, báo cáo sẽ không đưa ra phần thưởng mục tiêu thân mật.")
	end

	Log("TeacherStudent:_DoConfirmReportAfterCheck", pTeacher.dwID, pStudent.dwID, #tbTargets)
end

function TeacherStudent:_ComputeDismissDeadline(bGraduate, nOtherId)
	local nNow = GetTime()
	local nSec = self.Def.nDismissWaitTime
	if bGraduate then
		nSec = self.Def.nGraduateDismissWaitTime
		if nOtherId and nOtherId>0 then
			local nOffDays = Player:GetOfflineDays(nOtherId)
			if nOffDays>=7 then
				nSec = self.Def.nGraduateDismissQuitWaitTime
			end
		end
	end
	local nDeadline = nNow+nSec
	local tbDeadline = os.date("*t", nDeadline)
	tbDeadline.hour = 23
	tbDeadline.min = 59
	tbDeadline.sec = 0
	return os.time(tbDeadline)
end

function TeacherStudent:_GetDismissDeadline(pMe, nOtherId)
	local tbDismissing = ScriptData:GetValue("TSDismissing")
	local tbMyReq = tbDismissing[pMe.dwID] or {}
	local tbDeadline = tbMyReq[nOtherId] or {0}
	return tbDeadline[1]
end

function TeacherStudent:_GetTargetFinishedCount(pPlayer, nOtherId)
	local nCount = 0
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	local tbOther = tbPlayer.tbStudents[nOtherId] or tbPlayer.tbTeachers[nOtherId]
	if not tbOther then
		Log("[x] TeacherStudent:_GetTargetFinishedCount", pPlayer.dwID, nOtherId)
		return nCount
	end

	local tbOtherTargetStates = tbOther.tbTargetStates or {}
	for _, nState in pairs(tbOtherTargetStates) do
		if nState~=self.Def.tbTargetStates.NotFinish then
			nCount = nCount+1
		end
	end

	local nImityLevel = FriendShip:GetFriendImityLevel(pPlayer.dwID, nOtherId) or 0
	for nId, nLevel in pairs(self.Def.tbImityTargetsIdToLevels) do
		if nImityLevel>=nLevel and tbOtherTargetStates[nId]==nil then
			nCount = nCount+1
		end
	end

	return nCount
end

function TeacherStudent:CheckBeforeForceGraduate(pMe, nOtherId)
	local bAmIStudent = self:IsMyTeacher(pMe, nOtherId)
	if not bAmIStudent and not self:IsMyStudent(pMe, nOtherId) then
		return false, "Các ngươi không phải quan hệ thầy trò "
	end

	local _, nOffSeconds = Player:GetOfflineDays(nOtherId)
    if nOffSeconds<self.Def.nForceGraduateTime then
    	return false, "Đối phương offline không đủ thời gian "
    end

	local tbMe = self:GetPlayerScriptTable(pMe)
	local bGraduate = false
	local nConnectTime = 0
	if bAmIStudent then
		bGraduate = tbMe.tbTeachers[nOtherId].bGraduate
		nConnectTime = tbMe.tbTeachers[nOtherId].nConnectTime
	else
		bGraduate = tbMe.tbStudents[nOtherId].bGraduate
		nConnectTime = tbMe.tbStudents[nOtherId].nConnectTime
	end
	if bGraduate then
		return false, "Đồ đệ đã xuất sư"
	end

	if Lib:SecondsToDays(GetTime()-nConnectTime)<self.Def.nGraduateConnectDaysMin then
		return false, string.format("Thời gian bái sư không đủ %d ngày", self.Def.nGraduateConnectDaysMin)
	end

	local nTargetsCount = self:_GetTargetFinishedCount(pMe, nOtherId)
	if nTargetsCount<self.Def.nGraduateTargetMin then
		return false, "Số lượng mục tiêu sư đồ không đủ"
	end

	return true
end

function TeacherStudent:_GiveGraduateRewards(pPlayer, nOtherId, bDontGiveOther)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	local bOtherStudent = self:IsMyStudent(pPlayer, nOtherId)
	local tbTargetStates = bOtherStudent and tbPlayer.tbStudents[nOtherId].tbTargetStates or tbPlayer.tbTeachers[nOtherId].tbTargetStates
	local nFinishedCount = self:_GetTargetFinishedCount(pPlayer, nOtherId)

	local tbTeacherReward = nil
	for i=#self.Def.tbGraduateTeacherRewards,1,-1 do
		local tbInfo = self.Def.tbGraduateTeacherRewards[i]
		if nFinishedCount>=tbInfo.nMin then
			tbTeacherReward = tbInfo
			break
		end
	end

	local tbStudentReward = nil
	for i=#self.Def.tbGraduateStudentRewards,1,-1 do
		local tbInfo = self.Def.tbGraduateStudentRewards[i]
		if nFinishedCount>=tbInfo.nMin then
			tbStudentReward = tbInfo
			break
		end
	end

	local pOtherStay = KPlayer.GetRoleStayInfo(nOtherId)
	local szOtherName = pOtherStay and pOtherStay.szName or ""

	local nTeacherId, nStudentId = nOtherId, pPlayer.dwID
	if bOtherStudent then
		nTeacherId, nStudentId = pPlayer.dwID, nOtherId
	end

	if tbTeacherReward and not(bDontGiveOther and nTeacherId==nOtherId) then
		Mail:SendSystemMail({
			To = nTeacherId,
			Title = "Thưởng Xuất sư",
			Text = string.format("    Đồ đệ「%s」Đã xuất sư,Nhận được Thưởng Xuất sư, Hãy mau nhận lấy!\n    Xuất sư đánh giá: %s( Đạt thành %d mục tiêu sư đồ )\n    Thưởng Xuất sư：%s", bOtherStudent and szOtherName or pPlayer.szName, tbTeacherReward.szJudgement, tbTeacherReward.nMin, tbTeacherReward.szJudgement2),
			From = "Thượng Quan Phi Long",
			tbAttach = tbTeacherReward.tbAttach,
			nLogReazon = Env.LogWay_TS_Graduate,
		})
	end
	if tbStudentReward and not(bDontGiveOther and nStudentId==nOtherId) then
		Mail:SendSystemMail({
			To = nStudentId,
			Title = "Thưởng Xuất sư",
			Text = string.format("    Xuất sư thành công từ sư phụ 「%s」có thể hành tẩu giang hồ. Nhận được Thưởng Xuất sư, Hãy mau nhận lấy!\n    Xuất sư đánh giá: %s( Đạt thành %d mục tiêu sư đồ )\n    Thưởng Xuất sư：%s", bOtherStudent and pPlayer.szName or szOtherName, tbStudentReward.szJudgement, tbStudentReward.nMin, tbStudentReward.szJudgement2),
			From = "Thượng Quan Phi Long",
			tbAttach = tbStudentReward.tbAttach,
			nLogReazon = Env.LogWay_TS_Graduate,
		})
	end
	Log("TeacherStudent:_GiveGraduateRewards", pPlayer.dwID, nTeacherId, nStudentId, nFinishedCount, tostring(bDontGiveOther))

	return tbTeacherReward
end

function TeacherStudent:RefundForceDismissGold(nId1, nId2, bTeacher)
	local tbDismissing = ScriptData:GetValue("TSDismissing")
	local tbDismissInfo = tbDismissing[nId1] and tbDismissing[nId1][nId2]
	if not tbDismissInfo then
		return
	end

	local _, _, bGraduate = unpack(tbDismissInfo)
	if bGraduate then
		local pStay = KPlayer.GetRoleStayInfo(nId2)
		Mail:SendSystemMail({
			To = nId1,
			Title = "Hủy bỏ giải trừ quan hệ sư đồ",
			Text = string.format("    Cùng %s [FFFE0D]%s[-] Giải trừ quan hệ thầy trò xin đã bị tự động hủy bỏ! Phụ kiện trả lại xin lúc chỗ tốn hao [FFFE0D]%d Nguyên bảo [-], mời kịp thời nhận lấy.",
				bTeacher and "Sư phụ" or "Đồ đệ", pStay.szName, self.Def.nGraduateDismissCost),
			From = "Thượng Quan Phi Long",
			tbAttach = {
				{"Gold", self.Def.nGraduateDismissCost},
			},
			nLogReazon = Env.LogWay_TS_CancelDismiss,
		})
	end
end

function TeacherStudent:_ForceCancelDismiss(nId1, nId2, bTeacher)

	self:RefundForceDismissGold(nId1, nId2, bTeacher)
	self:RefundForceDismissGold(nId2, nId1, not bTeacher)

	local bModified = false
	local tbDismissing = ScriptData:GetValue("TSDismissing")
	if tbDismissing[nId1] and tbDismissing[nId1][nId2] then
		bModified = true
		tbDismissing[nId1][nId2] = nil
	end
	if tbDismissing[nId2] and tbDismissing[nId2][nId1] then
		bModified = true
		tbDismissing[nId2][nId1] = nil
	end
	if bModified then
		ScriptData:AddModifyFlag("TSDismissing")
	end
end

function TeacherStudent:_DoForceGraduate(pMe, nOtherId)
	local tbMe = self:GetPlayerScriptTable(pMe)
	local bAmIStudent = tbMe.tbTeachers[nOtherId]
	if not bAmIStudent then
		self:_RemoveTitleWith(pMe, nOtherId)
	end
	local tbTeacherReward = self:_GiveGraduateRewards(pMe, nOtherId, true)
	self:_ForceCancelDismiss(pMe.dwID, nOtherId, bAmIStudent)

	if tbMe.tbStudents[nOtherId] then
		tbMe.tbStudents[nOtherId].bGraduate = true
		tbMe.tbStudents[nOtherId].tbTargetStates = nil
	end
	if tbMe.tbTeachers[nOtherId] then
		tbMe.tbTeachers[nOtherId].bGraduate = true
		tbMe.tbTeachers[nOtherId].tbTargetStates = nil
	end

	self:_PushMainInfo(pMe)
	pMe.CallClientScript("TeacherStudent:OnGraduate", nOtherId)

	if bAmIStudent then
		local szStudentNotice = "Ngươi đã thành công xuất sư, sau này có thể một mình xông pha giang hồ (Phần thưởng đã gửi đến thư)"
		pMe.CenterMsg(szStudentNotice)
		pMe.Msg(szStudentNotice)
	else
		local pStay = KPlayer.GetRoleStayInfo(nOtherId)
		local szTeacherNotice = tbTeacherReward and string.format("Đồ đệ「%s」 đã xuất sư thành công(Phần thưởng đã gửi đến thư)", pStay.szName) or string.format("Đồ đệ「%s」 đã xuất sư thành công", pStay.szName)
		pMe.CenterMsg(szTeacherNotice)
		pMe.Msg(szTeacherNotice)

		Achievement:AddCount(pMe, "TeacherStudentMaster_1", 1)

		if tbTeacherReward and tbTeacherReward.bEliteAchieve then
			if version_tx then
				local nAchieveAcount = Achievement:GetSubKindCount(pMe, "TeacherStudentElite_1");
				if nAchieveAcount == 0 then
					Sdk:SendTXLuckyBagMail(pMe, "FirstStudentEliteOut");
				end
			end

			Achievement:AddCount(pMe, "TeacherStudentElite_1", 1)
		end
	end

	Log("TeacherStudent:_DoForceGraduate", pMe.dwID, nOtherId)
end

function TeacherStudent:_DoForceGraduateAfterCheck(pMe, nOtherId)
	self:_DoForceGraduate(pMe, nOtherId)

	local szMainKey = "TSForceGraduate"
	local tbForce, nSlot = ScriptData:GrpFindOrGetFreeSlot(szMainKey, nil, nOtherId)
	tbForce[nOtherId] = tbForce[nOtherId] or {}
	table.insert(tbForce[nOtherId], pMe.dwID)
	ScriptData:GrpSaveSlot(szMainKey, nSlot)
end

function TeacherStudent:_CheckBeforeGraduate(pTeacher, pStudent)
	local tbSetting = self:GetCurrentTimeFrameSettings()
	if not tbSetting then
		return false, "Hệ thống chưa mở ra "
	end

	if pStudent.dwTeamID~=pTeacher.dwTeamID or pStudent.dwTeamID<=0 then
		return false, "Hãy tổ đội rồi đến gặp ta"
	end

	if not self:_IsRelationValid(pTeacher, pStudent) then
		return false, "Các ngươi không phải quan hệ thầy trò "
	end

	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	local tbStudent = self:GetPlayerScriptTable(pStudent)

	local nNow = GetTime()
	local nConnectTime = tbStudent.tbTeachers[pTeacher.dwID].nConnectTime
	if Lib:SecondsToDays(nNow-nConnectTime)<self.Def.nGraduateConnectDaysMin then
		return false, string.format("Bái sư chưa được %d ngày", self.Def.nGraduateConnectDaysMin)
	end

	if tbStudent.tbTeachers[pTeacher.dwID].bGraduate or tbTeacher.tbStudents[pStudent.dwID].bGraduate then
		return false, "Đồ đệ đã xuất sư"
	end

	local nTargetsCount = self:_GetTargetFinishedCount(pStudent, pTeacher.dwID)
	if nTargetsCount<self.Def.nGraduateTargetMin then
		return false, string.format("Tối thiều hoàn thành %d mục tiêu sư đồ", self.Def.nGraduateTargetMin)
	end

	return true
end

function TeacherStudent:_DoGraduateAfterCheck(pTeacher, pStudent)
	self:ConfirmTargetReport(pStudent.dwID)
	local tbTeacherReward = self:_GiveGraduateRewards(pTeacher, pStudent.dwID) or {}
	self:_ForceCancelDismiss(pTeacher.dwID, pStudent.dwID, false)

	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	tbTeacher.tbStudents[pStudent.dwID].bGraduate = true
	tbTeacher.tbStudents[pStudent.dwID].tbTargetStates = nil

	local tbStudent = self:GetPlayerScriptTable(pStudent)
	tbStudent.tbTeachers[pTeacher.dwID].bGraduate = true
	tbStudent.tbTeachers[pTeacher.dwID].tbTargetStates = nil

	self:_RemoveTitleWith(pTeacher, pStudent.dwID)

	self:_PushMainInfo(pTeacher)
	self:_PushMainInfo(pStudent)
	pTeacher.CallClientScript("TeacherStudent:OnGraduate", pStudent.dwID)
	pStudent.CallClientScript("TeacherStudent:OnGraduate", pTeacher.dwID)

	local szTeacherNotice = string.format("Đồ đệ「%s」 đã xuất sư thành công(Phần thưởng đã gửi đến thư)", pStudent.szName)
	pTeacher.CenterMsg(szTeacherNotice)
	pTeacher.Msg(szTeacherNotice)

	local szStudentNotice = "Ngươi đã thành công xuất sư, sau này có thể một mình xông pha giang hồ (Phần thưởng đã gửi đến thư)"
	pStudent.CenterMsg(szStudentNotice)
	pStudent.Msg(szStudentNotice)

	Achievement:AddCount(pTeacher, "TeacherStudentMaster_1", 1)

	if tbTeacherReward and tbTeacherReward.bEliteAchieve then
		if version_tx then
			local nAchieveAcount = Achievement:GetSubKindCount(pTeacher, "TeacherStudentElite_1");
			if nAchieveAcount == 0 then
				Sdk:SendTXLuckyBagMail(pTeacher, "FirstStudentEliteOut");
			end
		end

		Achievement:AddCount(pTeacher, "TeacherStudentElite_1", 1)
	end

	self:_CheckAddToSearchList(pTeacher)
	self:_CheckAddToSearchList(pStudent)

	Log("TeacherStudent:_DoGraduateAfterCheck", pTeacher.dwID, pStudent.dwID, tbTeacherReward.nMin)
end

function TeacherStudent:_CheckDismiss()
	local nNow = GetTime()
	local tbDismissing = ScriptData:GetValue("TSDismissing")
	for nReqPid, tbTargets in pairs(tbDismissing) do
		for nTargetId, tbInfo in pairs(tbTargets) do
			local nDeadline, bForce, bGraduate = unpack(tbInfo)
			if nDeadline<=nNow then
				self:_DoDismiss(nReqPid, nTargetId, bForce, bGraduate)

				tbDismissing[nReqPid][nTargetId] = nil
				if tbDismissing[nTargetId] then
					tbDismissing[nTargetId][nReqPid] = nil
				end
			end
		end
	end

	for nReqPid, tbTargets in pairs(tbDismissing) do
		if not next(tbTargets) then
			tbDismissing[nReqPid] = nil
		end
	end
	ScriptData:AddModifyFlag("TSDismissing")
end

function TeacherStudent:_CheckAddToSearchList(pPlayer)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	if tbPlayer.tbSettings.bClosed then
		return
	end

	if self:_CanAddTeacher(pPlayer) then
		self.tbSearchList.tbStudents[pPlayer.dwID] = true
	end
	if self:_CanAddStudent(pPlayer) then
		self.tbSearchList.tbTeachers[pPlayer.dwID] = true
	end
end

function TeacherStudent:_RemoveFromSearchList(nPlayerId)
	self.tbSearchList.tbStudents[nPlayerId] = nil
	self.tbSearchList.tbTeachers[nPlayerId] = nil
end

function TeacherStudent:_DoDelayDismiss(pPlayer)
	local szMainKey = "TSDelayDismiss"
	local nPlayerId = pPlayer.dwID
	local tbDelayDismiss, nSlot = ScriptData:GrpFindSlot(szMainKey, nPlayerId)
	if not tbDelayDismiss then
		return
	end

	local bModified = false
	local tbDismiss = tbDelayDismiss[nPlayerId] or {}
	for nTargetId, tbInfo in pairs(tbDismiss) do
		bModified = true
		local bForce, bReq, bGraduate = unpack(tbInfo)
		self:_DoDismissWith(pPlayer, nTargetId, bForce, bReq, bGraduate)
	end
	if bModified then
		tbDelayDismiss[nPlayerId] = nil
		ScriptData:GrpSaveSlot(szMainKey, nSlot)
	end
end

function TeacherStudent:_DoDelayForceGraduate(pPlayer)
	local szMainKey = "TSForceGraduate"
	local nPlayerId = pPlayer.dwID
	local tbDelayGraduate, nSlot = ScriptData:GrpFindSlot(szMainKey, nPlayerId)
	if not tbDelayGraduate then
		return
	end

	local tbGraduate = tbDelayGraduate[nPlayerId] or {}
	for _, nOtherId in ipairs(tbGraduate) do
		self:_DoForceGraduate(pPlayer, nOtherId)
	end
	tbDelayGraduate[nPlayerId] = nil
	ScriptData:GrpSaveSlot(szMainKey, nSlot)
end

function TeacherStudent:_BroadcastToTeachers(pPlayer, fn)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	for nTeacherId in pairs(tbPlayer.tbTeachers) do
		local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
		if pTeacher then
			fn(pTeacher)
		end
	end
end

function TeacherStudent:_BroadcastToAll(pPlayer, fn)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	local tbIds = {}
	for nTeacherId in pairs(tbPlayer.tbTeachers) do
		tbIds[nTeacherId] = true
	end
	for nStudentId in pairs(tbPlayer.tbStudents) do
		tbIds[nStudentId] = true
	end

	for nId in pairs(tbIds) do
		local pOther = KPlayer.GetPlayerObjById(nId)
		if pOther then
			fn(pOther)
		end
	end
end

function TeacherStudent:_CheckShowDismissNotice(pPlayer)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	local tbDismissing = ScriptData:GetValue("TSDismissing")

	local tbMyDismissing = {}
	for nOtherId, tbInfo in pairs(tbDismissing[pPlayer.dwID] or {}) do
		tbMyDismissing[nOtherId] = {
			bMyReq = true,
			nDeadline = tbInfo[1],
			bOtherTeacher = tbPlayer.tbTeachers[nOtherId],
		}
	end

	for nTeacherId, tbTeacher in pairs(tbPlayer.tbTeachers) do
		if tbDismissing[nTeacherId] and tbDismissing[nTeacherId][pPlayer.dwID] then
			tbMyDismissing[nTeacherId] = {
				nDeadline = tbDismissing[nTeacherId][pPlayer.dwID][1],
				bOtherTeacher = true,
			}
		end
	end

	for nStudentId, tbStudent in pairs(tbPlayer.tbStudents) do
		if tbDismissing[nStudentId] and tbDismissing[nStudentId][pPlayer.dwID] then
			tbMyDismissing[nStudentId] = {
				nDeadline = tbDismissing[nStudentId][pPlayer.dwID][1],
			}
		end
	end

	local nNow = GetTime()
	for nOtherId, tbInfo in pairs(tbMyDismissing) do
		local szOtherRole = tbInfo.bOtherTeacher and "Sư phụ" or "Đồ đệ"
		local szDeadline = Lib:TimeDesc5(tbInfo.nDeadline-nNow)
		local pOtherStayInfo = KPlayer.GetRoleStayInfo(nOtherId)
		if pOtherStayInfo then
			local szMsg
			if tbInfo.bMyReq then
				szMsg = string.format("Ngươi cùng %s「%s」xin hủy bỏ quan hệ sư đồ, ,sau %s sẽ có hiệu lực", szOtherRole, pOtherStayInfo.szName, szDeadline)
			else
				szMsg = string.format("%s ngươi 「%s」 xin hủy bỏ quan hệ sư đồ, sau %s sẽ có hiệu lực", szOtherRole, pOtherStayInfo.szName, szDeadline)
			end
			pPlayer.Msg(szMsg)
		end
	end
end

function TeacherStudent:_DoDismissWith(pMe, nOtherId, bForce, bReq, bGraduate)
	local tbMe = self:GetPlayerScriptTable(pMe)
	local bOtherTeacher = not not tbMe.tbTeachers[nOtherId]
	local bOtherStudent = not not tbMe.tbStudents[nOtherId]
	if bOtherTeacher==bOtherStudent then
		Log("[x] TeacherStudent:_DoDismissWith failed", bOtherTeacher, bOtherStudent, pMe.dwID, nOtherId, tostring(bForce))
		return
	end

	local szOtherRole = "Sư phụ"
	if bOtherTeacher then
		tbMe.tbTeachers[nOtherId] = nil
	else
		szOtherRole = "Đồ đệ"
		tbMe.tbStudents[nOtherId] = nil
	end

	if not bForce and bReq then
		tbMe.nPunishDeadline = GetTime()+self.Def.nDismissPunishTime
		self:_PushToClient(pMe, "TS_PUNISH", {
			nPunishDeadline = tbMe.nPunishDeadline,
		})
	end
	self:_PushMainInfo(pMe)
	self:_RemoveTitleWith(pMe, nOtherId)

	local pOtherStayInfo = KPlayer.GetRoleStayInfo(nOtherId)
	if not pOtherStayInfo then
		Log("[x] TeacherStudent:_DoDismissWith, send mail failed", pMe.dwID, nOtherId)
		return
	end
	Mail:SendSystemMail({
		To = pMe.dwID,
		Title = "Giải trừ quan hệ sư đồ",
		Text = string.format("    %s ngươi 「%s」 đã chính thức hủy bỏ quan hệ sư đồ", szOtherRole, pOtherStayInfo.szName),
		From = "Thượng Quan Phi Long",
	})

	pMe.CallClientScript("TeacherStudent:OnSrvRsp", "_DoDismissWith", {
		nOtherId = nOtherId,
	})

	Log("TeacherStudent:_DoDismissWith", pMe.dwID, nOtherId, tostring(bForce), tostring(bReq), tostring(bGraduate))
end

function TeacherStudent:_DoDismiss(nReqPid, nTargetId, bForce, bGraduate)
	local szMainKey = "TSDelayDismiss"

	local pReq = KPlayer.GetPlayerObjById(nReqPid)
	if not pReq then
		local tbDelayDismiss, nSlot = ScriptData:GrpFindOrGetFreeSlot(szMainKey, nil, nReqPid)
		tbDelayDismiss[nReqPid] = tbDelayDismiss[nReqPid] or {}
		tbDelayDismiss[nReqPid][nTargetId] = {bForce, true, bGraduate}	-- bForce, bReq, bGraduate
		ScriptData:GrpSaveSlot(szMainKey, nSlot)
	else
		self:_DoDismissWith(pReq, nTargetId, bForce, true, bGraduate)
	end

	local pTarget = KPlayer.GetPlayerObjById(nTargetId)
	if not pTarget then
		local tbDelayDismiss, nSlot = ScriptData:GrpFindOrGetFreeSlot(szMainKey, nil, nTargetId)
		tbDelayDismiss[nTargetId] = tbDelayDismiss[nTargetId] or {}
		tbDelayDismiss[nTargetId][nReqPid] = {bForce, false, bGraduate}
		ScriptData:GrpSaveSlot(szMainKey, nSlot)
	else
		self:_DoDismissWith(pTarget, nReqPid, bForce, false, bGraduate)
	end

	Log("TeacherStudent:_DoDismiss", nReqPid, nTargetId, tostring(bForce), tostring(bGraduate))
end

function TeacherStudent:_OnCustomTargetProgressChange(pStudent, nTeacherId, nTargetId, nCurrent)
	local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
	if pTeacher then
		self:_PushToClient(pTeacher, "TS_CUS_TAR_PRO", {
			nStudentId = pStudent.dwID,
			nTargetId = nTargetId,
			nCurrent = nCurrent,
		})
	end

	self:_PushToClient(pStudent, "TS_MINE_CUS_TAR_PRO", {
		nTeacherId = nTeacherId,
		nTargetId = nTargetId,
		nCurrent = nCurrent,
	})
end

function TeacherStudent:_OnTargetProgressChange(pPlayer, nTargetId, nCurrent)
	self:_BroadcastToTeachers(pPlayer, function(pTeacher)
		self:_PushToClient(pTeacher, "TS_TAR_PRO", {
			nId = pPlayer.dwID,
			nTargetId = nTargetId,
			nCurrent = nCurrent,
		})
	end)

	self:_PushToClient(pPlayer, "TS_MINE_TAR_PRO", {
		nTargetId = nTargetId,
		nCurrent = nCurrent,
	})
end

function TeacherStudent:_OnTargetFinished(pPlayer, nTargetId)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	for nTeacherId, tbTeacher in pairs(tbPlayer.tbTeachers) do
		if not tbTeacher.bGraduate and tbTeacher.tbTargetStates then
			local nState = tbTeacher.tbTargetStates[nTargetId]
			if not nState or nState==self.Def.tbTargetStates.NotFinish then
				tbTeacher.tbTargetStates[nTargetId] = self.Def.tbTargetStates.NotReport
			else
				Log("[x] TeacherStudent:_OnTargetFinished, target state error", pPlayer.dwID, nTargetId, nTeacherId, tostring(nState))
			end

			local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
			if pTeacher then
				self:_OnStudentTargetFinished(pTeacher, pPlayer.dwID, nTargetId)
			end
		end
	end
end

function TeacherStudent:_OnStudentTargetFinished(pTeacher, nStudentId, nTargetId)
	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	local tbStudent = tbTeacher.tbStudents[nStudentId]
	if not tbStudent then
		Log("[x] TeacherStudent:_OnStudentTargetFinished, not connected", pTeacher.dwID, nStudentId, nTargetId)
		return
	end

	local nState = tbStudent.tbTargetStates[nTargetId]
	if not nState or nState==self.Def.tbTargetStates.NotFinish then
		tbStudent.tbTargetStates[nTargetId] = self.Def.tbTargetStates.NotReport
	else
		Log("[x] TeacherStudent:_OnStudentTargetFinished, target state error", pTeacher.dwID, nStudentId, nTargetId, nState)
	end
end

function TeacherStudent:_FillRelationBaseInfo(tbOut, tbPlayers)
	for nId, tbPlayer in pairs(tbPlayers) do
		local pPlayer = KPlayer.GetPlayerObjById(nId)
		local nLastOnlineTime = 0
		if not pPlayer then
			pPlayer = KPlayer.GetRoleStayInfo(nId)
			nLastOnlineTime = pPlayer.nLastOnlineTime
		end
		if pPlayer then
			tbOut[nId] = {
				nId = nId,
				szName = pPlayer.szName,
				nLevel = pPlayer.nLevel,
				nFaction = pPlayer.nFaction,
				nHonorLevel = pPlayer.nHonorLevel,
				nPortrait = pPlayer.nPortrait,
				nLastOnlineTime = nLastOnlineTime,

				bGraduate = tbPlayer.bGraduate,
				nConnectTime = tbPlayer.nConnectTime,
			}
		else
			Log("[x] TeacherStudent:_FillRelationBaseInfo, get player obj failed", nId)
		end
	end
end

function TeacherStudent:_GetMainInfo(pPlayer)
	local tbMainInfo = {}

	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	self:_CheckResetData(tbPlayer)

	tbMainInfo.tbSettings = tbPlayer.tbSettings

	local nMyId = pPlayer.dwID
	if next(tbPlayer.tbTeachers) then
		tbMainInfo.tbTeachers = {}
		self:_FillRelationBaseInfo(tbMainInfo.tbTeachers, tbPlayer.tbTeachers)
	end

	if next(tbPlayer.tbStudents) then
		tbMainInfo.tbStudents = {}
		self:_FillRelationBaseInfo(tbMainInfo.tbStudents, tbPlayer.tbStudents)
	end

	tbMainInfo.tbChuanGong = tbPlayer.tbChuanGong or {}
	tbMainInfo.nLastChuanGong = tbPlayer.nLastChuanGong

	if tbPlayer.nAcceptCount>=self.Def.nAddStudentNoCdCount then
		tbMainInfo.nLastAccept = tbPlayer.nLastAccept
	end

	tbMainInfo.nPunishDeadline = tbPlayer.nPunishDeadline or 0

	return tbMainInfo
end

function TeacherStudent:_GetTeacherList(pPlayer)
	local bOk, szErr = self:_CanAddTeacher(pPlayer)
	if not bOk then
		return
	end

	local tbResult = {}
	for nTeacherId in pairs(self.tbSearchList.tbTeachers) do
		local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
		if not pTeacher then
			self:_RemoveFromSearchList(nTeacherId)
		elseif self:_CheckBeforeAdd(pTeacher, pPlayer) then
			local tbTeacher = self:GetPlayerScriptTable(pTeacher)
			local szKinName = ""
			local tbKin = Kin:GetKinByMemberId(nTeacherId)
			if tbKin then
				szKinName = tbKin.szName
			end
			table.insert(tbResult, {
				nId = nTeacherId,
				szName = pTeacher.szName,
				szKinName = szKinName,
				nLevel = pTeacher.nLevel,
				nFaction = pTeacher.nFaction,
				nHonorLevel = pTeacher.nHonorLevel,
				nPortrait = pTeacher.nPortrait,
				szNotice = tbTeacher.tbSettings.szNotice,
			})
			if #tbResult>=self.Def.nFindTeacherListMax then
				break
			end
		end
	end

	return tbResult
end

function TeacherStudent:_GetStudentList(pPlayer)
	local bOk, szErr = self:_CanAddStudent(pPlayer)
	if not bOk then
		return
	end

	local tbResult = {}
	for nStudentId in pairs(self.tbSearchList.tbStudents) do
		local pStudent = KPlayer.GetPlayerObjById(nStudentId)
		if not pStudent then
			self:_RemoveFromSearchList(nStudentId)
		elseif self:_CheckBeforeAdd(pPlayer, pStudent) then
			local szKinName = ""
			local tbKin = Kin:GetKinByMemberId(nStudentId)
			if tbKin then
				szKinName = tbKin.szName
			end
			table.insert(tbResult, {
				nId = nStudentId,
				szName = pStudent.szName,
				szKinName = szKinName,
				nLevel = pStudent.nLevel,
				nFaction = pStudent.nFaction,
				nHonorLevel = pStudent.nHonorLevel,
				nPortrait = pStudent.nPortrait,
			})
			if #tbResult>=self.Def.nFindStudentListMax then
				break
			end
		end
	end

	return tbResult
end

function TeacherStudent:_GetApplyList(pPlayer)
	local tbResult = {}
	for _, tbApplyInfo in pairs(self.tbApplyList[pPlayer.dwID] or {}) do
		table.insert(tbResult, tbApplyInfo)
	end
	table.sort(tbResult, function(tbA, tbB)
		return tbA.nTime<tbB.nTime or (tbA.nTime==tbB.nTime and tbA.nId<tbB.nId)
	end)
	return tbResult
end

function TeacherStudent:_SyncTargetProgress(pTeacher, pStudent)
	local tbStudent = self:GetPlayerScriptTable(pStudent)
	local tbTeacherInfo = tbStudent.tbTeachers[pTeacher.dwID]
	if not tbTeacherInfo then
		return
	end

	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	local tbStudentInfo = tbTeacher.tbStudents[pStudent.dwID]
	if not tbStudentInfo then
		return
	end

	if tbTeacherInfo.bGraduate then
		tbStudentInfo.tbCustomTasks = Lib:CopyTB(tbTeacherInfo.tbCustomTasks or {})
		return
	end

	tbStudentInfo.tbTargetStates = Lib:CopyTB(tbTeacherInfo.tbTargetStates)
end

function TeacherStudent:_CheckTargetStates(pPlayer)
	local tbTargetStates = {}
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	for nTeacherId, tbTeacher in pairs(tbPlayer.tbTeachers) do
		if not tbTeacher.bGraduate then
			tbTargetStates[nTeacherId] = tbTeacher.tbTargetStates
		end
	end
	if not next(tbTargetStates) then
		return
	end

	for nTargetId, tbSetting in pairs(self.tbTargets) do
		local nCurrent = self:_IsImityTarget(nTargetId) and 0 or pPlayer.GetUserValue(self.Def.nTargetProgressGroup, nTargetId)
		if nCurrent>=tbSetting.nNeed then
			for nTeacherId, tbStates in pairs(tbTargetStates) do
				if not tbStates[nTargetId] then
					tbStates[nTargetId] = self.Def.tbTargetStates.NotReport
					Log("TeacherStudent:_CheckTargetStates", nTargetId, nTeacherId)
				end
			end
		end
	end
end

function TeacherStudent:_CheckImityTargetStates(pPlayer)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	if tbPlayer.nImityReportCount>=self.Def.nMaxImityReportCount then
		return
	end

	local bErr = false
	for nTeacherId, tbTeacher in pairs(tbPlayer.tbTeachers) do
		if not tbTeacher.bGraduate then
			local nImityLevel = FriendShip:GetFriendImityLevel(pPlayer.dwID, nTeacherId) or 0
			for nTargetId, nLevel in pairs(self.Def.tbImityTargetsIdToLevels) do
				if tbTeacher.tbTargetStates[nTargetId]==self.Def.tbTargetStates.FinishedBefore then
					local nRightState = nImityLevel>=nLevel and self.Def.tbTargetStates.NotReport or nil --dont saved if not finished
					tbTeacher.tbTargetStates[nTargetId] = nRightState
					bErr = true
					Log("TeacherStudent:_CheckImityTargetStates", nTargetId, nImityLevel, nLevel, tostring(nRightState))
				end
			end
		end
	end
	if bErr then
		for nTargetId in pairs(self.Def.tbImityTargetsIdToLevels) do
			pPlayer.SetUserValue(self.Def.nTargetProgressGroup, nTargetId, 0)
		end
	end
end

function TeacherStudent:_SyncTargetProgressToTeachers(pPlayer)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	for nTeacherId, tbTeacher in pairs(tbPlayer.tbTeachers) do
		local pTeacher = KPlayer.GetPlayerObjById(nTeacherId)
		if pTeacher then
			self:_SyncTargetProgress(pTeacher, pPlayer)
		end
	end
end

function TeacherStudent:_GetOtherStatusInfo(pMe, nOtherId)
	local pOther = KPlayer.GetPlayerObjById(nOtherId)
	local pStudent = nil
	if pOther then
		local pTeacher = nil
		pTeacher, pStudent = self:_GetRelations(pMe, pOther)
		if not pTeacher then
			Log("[x] TeacherStudent:_GetOtherStatusInfo, not connected1", pMe.dwID, pOther.dwID)
			return
		end
		self:_SyncTargetProgress(pTeacher, pStudent)
	end

	local tbMe = self:GetPlayerScriptTable(pMe)
	local tbOtherData = tbMe.tbTeachers[nOtherId] or tbMe.tbStudents[nOtherId]
	if not tbOtherData then
		Log("[x] TeacherStudent:_GetOtherStatusInfo, not connected2", pMe.dwID, nOtherId)
		return
	end
	
	if tbMe.tbTeachers[nOtherId] then
		pStudent = pMe
	end

	local tbResult = {
		nId = nOtherId,
	}
	tbResult.nRewardCount = tbOtherData.nRewardCount or 0
	tbResult.nConnectTime = tbOtherData.nConnectTime	

	local bGraduate = tbOtherData.bGraduate
	if not bGraduate then
		tbResult.tbTargetStates = Lib:CopyTB(tbOtherData.tbTargetStates)
	else
		tbResult.tbCustomTasks = Lib:CopyTB(tbOtherData.tbCustomTasks or {})
	end

	if pStudent and not bGraduate then
		for nTargetId, tbSetting in pairs(self.tbTargets) do
			if not tbResult.tbTargetStates[nTargetId] then
				local nState = 0
				if not self:_IsImityTarget(nTargetId) then
					local nCurrent = pStudent.GetUserValue(self.Def.nTargetProgressGroup, nTargetId)
					if nCurrent<tbSetting.nNeed then
						nState = -nCurrent	--使用负数来记录进度，与状态区分
					end
				end
				tbResult.tbTargetStates[nTargetId] = nState
			end
		end
	end

	local nDeadline = self:_GetDismissDeadline(pMe, nOtherId)
	if nDeadline>0 then
		tbResult.nDismissDeadline = nDeadline
	end

	return tbResult
end

function TeacherStudent:_PushToClient(pPlayer, szType, tbValue)
	pPlayer.CallClientScript("TeacherStudent:OnPushToClient", szType, tbValue)
end

function TeacherStudent:_PushMainInfo(pPlayer)
	local tbResult = self:_GetMainInfo(pPlayer)
	if tbResult then
		pPlayer.CallClientScript("TeacherStudent:OnRefreshMainInfoRsp", tbResult)
	end
end

function TeacherStudent:_PushTargetProgress(pPlayer)
	self:_BroadcastToTeachers(pPlayer, function(pTeacher)
		local tbInfo = self:_GetOtherStatusInfo(pTeacher, pPlayer.dwID)
		if tbInfo then
			pTeacher.CallClientScript("TeacherStudent:OnRefreshOtherStatusInfoRsp", tbInfo)
		end
	end)
end

function TeacherStudent:_PushLevel(pPlayer)
	self:_BroadcastToAll(pPlayer, function(pOther)
		self:_PushToClient(pOther, "TS_LEVEL", {
			nId = pPlayer.dwID,
			nLevel = pPlayer.nLevel,
		})
	end)
end

function TeacherStudent:_PushOnlineStatus(pPlayer, bOnline)
	local nLastOnlineTime = bOnline and 0 or GetTime()
	self:_BroadcastToAll(pPlayer, function(pOther)
		self:_PushToClient(pOther, "TS_ONLINE_STATUS", {
			nId = pPlayer.dwID,
			nLastOnlineTime = nLastOnlineTime,
		})
	end)
end

function TeacherStudent:_ChangeMyTitle(pMe, bImTeacher, nOtherId, szOtherName)
	if not self:_RemoveTitleWith(pMe, nOtherId) then
		return
	end
	self:_AddTitleWith(pMe, bImTeacher, nOtherId, szOtherName)
end

function TeacherStudent:_DoDelayChangeTitle(pPlayer)
	local szMainKey = "TSDelayChangeTitle"
	local nMyId = pPlayer.dwID
	local tbDelay, nSlot = ScriptData:GrpFindSlot(szMainKey, nMyId)
	if not tbDelay then
		return
	end

	for nOtherId, tbInfo in pairs(tbDelay[nMyId] or {}) do
		self:_ChangeMyTitle(pPlayer, tbInfo.bImTeacher, nOtherId, tbInfo.szOtherName)
	end
	tbDelay[nMyId] = nil
	ScriptData:GrpSaveSlot(szMainKey, nSlot)
end

function TeacherStudent:_ChangeTitlePlayerName(nMyId, bImTeacher, nOtherId, szOtherName)
	local pMe = KPlayer.GetPlayerObjById(nMyId)
	if not pMe then
		local szMainKey = "TSDelayChangeTitle"
		local tbDelay, nSlot = ScriptData:GrpFindOrGetFreeSlot(szMainKey, nil, nMyId)

		tbDelay[nMyId] = tbDelay[nMyId] or {}
		tbDelay[nMyId][nOtherId] = {
			bImTeacher = bImTeacher,
			szOtherName = szOtherName,
		}
		ScriptData:GrpSaveSlot(szMainKey, nSlot)
		return
	end

	self:_ChangeMyTitle(pMe, bImTeacher, nOtherId, szOtherName)
end

function TeacherStudent:_CheckBeforeGiveGraduateReward(pTeacher, pStudent, nItemId)
	if not self:_IsRelationValid(pTeacher, pStudent) then
		return false, "Các ngươi không phải quan hệ thầy trò "
	end

	local tbStudent = self:GetPlayerScriptTable(pStudent)
	if not tbStudent.tbTeachers[pTeacher.dwID].bGraduate then
		return false, "Đồ đệ chưa xuất sư"
	end
	if tbStudent.tbTeachers[pTeacher.dwID].nRewardCount>0 then
		return false, "Số lần tặng còn lại không đủ"
	end

	if not self.tbGraduateGiftItemIds[nItemId] then
		return false, "Vật phẩm này không thể đưa tặng"
	end

	if pTeacher.GetItemCountInAllPos(nItemId)<1 then
		return false, "Bạn không có đủ đạo cụ"
	end

	return true
end

function TeacherStudent:_GiveGraduateRewardAfterCheck(pTeacher, pStudent, nItemId, szMsg)
	if pTeacher.ConsumeItemInAllPos(nItemId, 1, Env.LogWay_TS_Graduate)~=1 then
		Log("[x] TeacherStudent:_GiveGraduateRewardAfterCheck, ConsumeItemInAllPos failed", pTeacher.dwID, pStudent.dwID, nItemId)
		return
	end

	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	tbTeacher.tbStudents[pStudent.dwID].nRewardCount = (tbTeacher.tbStudents[pStudent.dwID].nRewardCount or 0)+1
	local tbStudent = self:GetPlayerScriptTable(pStudent)
	tbStudent.tbTeachers[pTeacher.dwID].nRewardCount = (tbStudent.tbTeachers[pTeacher.dwID].nRewardCount or 0)+1

	self:_PushToClient(pTeacher, "TS_GRADUATE_GIFT", {
		nOtherId = pStudent.dwID,
		nRewardCount = tbTeacher.tbStudents[pStudent.dwID].nRewardCount,
	})
	self:_PushToClient(pStudent, "TS_GRADUATE_GIFT", {
		nOtherId = pTeacher.dwID,
		nRewardCount = tbStudent.tbTeachers[pTeacher.dwID].nRewardCount,
	})

	szMsg = szMsg or ""
	if szMsg~="" then
		szMsg = string.format('    Sư phụ để lại tin nhắn："%s"', szMsg)
	end
	Mail:SendSystemMail({
		To = pStudent.dwID,
		Title = "Sư phụ tặng quà",
		Text = string.format("    Sư phụ「%s」tặng bạn một món quà, vui lòng kiểm tra đính kèm.\n\n%s", pTeacher.szName, szMsg),
		From = "Thượng Quan Phi Long",
		tbAttach = {
			{"item", nItemId, 1},
		},
		nLogReazon = Env.LogWay_TS_Graduate,
	})
	Log("TeacherStudent:_GiveGraduateRewardAfterCheck", pTeacher.dwID, pStudent.dwID, nItemId)
end

function TeacherStudent:_TargetForceFinished(pPlayer, nTargetId)
	local tbSetting = self:GetTargetSetting(nTargetId)
	if not tbSetting then
		Log("[x] TeacherStudent:_TargetForceFinished, unknown target", pPlayer.dwID, nTargetId)
		return
	end
	pPlayer.SetUserValue(self.Def.nTargetProgressGroup, nTargetId, tbSetting.nNeed)
end

function TeacherStudent:_IsImityTarget(nTargetId)
	return self.Def.tbImityTargetsIdToLevels[nTargetId]
end

function TeacherStudent:_CustomTargetAddCount(pPlayer, nTargetId, nAdd)
	local tbSetting = self:GetCustomTargetSetting(nTargetId)
	local nPlayerId = pPlayer.dwID
	if not tbSetting then
		Log("[x] TeacherStudent:_CustomTargetAddCount, unknown target", nPlayerId, nTargetId, nAdd)
		return
	end

	local tbStudent = self:GetPlayerScriptTable(pPlayer)
	for nTeacherId, tbTeacher in pairs(tbStudent.tbTeachers) do
		if tbTeacher.bGraduate then
			local tbCustomTasks = tbTeacher.tbCustomTasks or {}
			local tbProgress = tbCustomTasks.tbTasks or {}
			if tbProgress[nTargetId] and tbProgress[nTargetId]<tbSetting.nNeed then
					tbProgress[nTargetId] = math.min(tbProgress[nTargetId]+nAdd, tbSetting.nNeed)
					self:_OnCustomTargetProgressChange(pPlayer, nTeacherId, nTargetId, tbProgress[nTargetId])
				end
			end
		end
	end

function TeacherStudent:_TargetAddCount(pPlayer, nTargetId, nAdd)
	-- 亲密度目标特殊处理，不存盘
	if self:_IsImityTarget(nTargetId) then
		return
	end

	local tbSetting = self:GetTargetSetting(nTargetId)
	if not tbSetting then
		Log("[x] TeacherStudent:_TargetAddCount, unknown target", pPlayer.dwID, nTargetId, nAdd)
		return
	end

	local nCurrent = pPlayer.GetUserValue(self.Def.nTargetProgressGroup, nTargetId)
	if nCurrent>=tbSetting.nNeed then
		return
	end

	local nAdded = math.min(nCurrent+nAdd, tbSetting.nNeed)
	pPlayer.SetUserValue(self.Def.nTargetProgressGroup, nTargetId, nAdded)

	local bFinished = nAdded>=tbSetting.nNeed
	if bFinished then
		self:_OnTargetFinished(pPlayer, nTargetId)
	end
	self:_OnTargetProgressChange(pPlayer, nTargetId, bFinished and self.Def.tbTargetStates.NotReport or -nAdded)
end

-- events

function TeacherStudent:OnLevelUp(pPlayer)
	self:_PushLevel(pPlayer)
	self:_CheckAddToSearchList(pPlayer)
end

function TeacherStudent:OnChangeName(pPlayer)
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	for nTeacherId, tbTeacher in pairs(tbPlayer.tbTeachers) do
		if not tbTeacher.bGraduate then
			self:_ChangeTitlePlayerName(nTeacherId, true, pPlayer.dwID, pPlayer.szName)
		end
	end
	for nStudentId, tbStudent in pairs(tbPlayer.tbStudents) do
		self:_ChangeTitlePlayerName(nStudentId, false, pPlayer.dwID, pPlayer.szName)
	end
end

function TeacherStudent:OnLogin(pPlayer)
	self:_DoDelayChangeTitle(pPlayer)
	self:_DoDelayForceGraduate(pPlayer)
	self:_DoDelayDismiss(pPlayer)

	self:_CheckImityTargetStates(pPlayer)
	self:_CheckTargetStates(pPlayer)
	self:_SyncTargetProgressToTeachers(pPlayer)
	self:_PushMainInfo(pPlayer)
	self:_PushOnlineStatus(pPlayer, true)
	self:_PushTargetProgress(pPlayer)

	self:_CheckShowDismissNotice(pPlayer)
	self:_CheckAddToSearchList(pPlayer)
end

function TeacherStudent:OnLogout(pPlayer)
	self:_PushOnlineStatus(pPlayer, false)
	self:_RemoveFromSearchList(pPlayer.dwID)
end

-- interfaces

function TeacherStudent:DoDaily()
	self:_CheckDismiss()
end

function TeacherStudent:CanDelFriend(nId1, nId2)
	local pPlayer = KPlayer.GetPlayerObjById(nId1) or KPlayer.GetPlayerObjById(nId2)
	if not pPlayer then
		Log("[x] TeacherStudent:CanDelFriend, both nil", nId1, nId2)
		return true
	end

	local nOtherId = pPlayer.dwID==nId1 and nId2 or nId1
	local tbPlayer = self:GetPlayerScriptTable(pPlayer)
	local tbInfo = tbPlayer.tbTeachers[nOtherId] or tbPlayer.tbStudents[nOtherId]
	if not tbInfo then
		return true
	end

	return tbInfo.bGraduate
end

function TeacherStudent:ChuanGongBegan(pTeacher, pStudent)
	local nNow = GetTime()

	local tbTeacher = self:GetPlayerScriptTable(pTeacher)
	table.insert(tbTeacher.tbChuanGong, pStudent.dwID)
	tbTeacher.nLastChuanGong = nNow

	local tbStudent = self:GetPlayerScriptTable(pStudent)
	table.insert(tbStudent.tbChuanGong, pTeacher.dwID)
	tbStudent.nLastChuanGong = nNow

	self:_PushToClient(pTeacher, "TS_CHUANGONG", {
		nLastChuanGong = nNow,
		tbChuanGong = tbTeacher.tbChuanGong,
	})
	self:_PushToClient(pStudent, "TS_CHUANGONG", {
		nLastChuanGong = nNow,
		tbChuanGong = tbStudent.tbChuanGong,
	})

	Log("TeacherStudent:ChuanGongBegan", pTeacher.dwID, pStudent.dwID)
end

function TeacherStudent:OnShopBuy(pPlayer, nTemplateId, nCount, bLimit)
	if not bLimit then
		return
	end

	local tbGoodsIdToType = {
		[212] = "BuyCutOffWhite",
		[222] = "BuyCutOffGreen",
	}
	local szType = tbGoodsIdToType[nTemplateId]
	if not szType then
		return
	end
	self:TargetAddCount(pPlayer, szType, nCount)
end

function TeacherStudent:OnAllEquipInsert(pPlayer, nAchieveLevel)
	local tbLevelToTypes = {
		[1] = "EquipInsert1",
		[2] = "EquipInsert2",
		[3] = "EquipInsert3",
		[4] = "EquipInsert4",
	}
	for i=1, nAchieveLevel do
		local szType = tbLevelToTypes[i]
		if szType then
			self:TargetAddCount(pPlayer, szType, 1)
		end
	end
end

function TeacherStudent:OnJoinBossLeader(pPlayer, szType)
	local nPid = pPlayer.dwID
	if self.tbJoinedPids and self.tbJoinedPids[nPid] then
		return
	end
	self.tbJoinedPids = self.tbJoinedPids or {}
	self.tbJoinedPids[nPid] = true

	if szType=="Boss" then
        TeacherStudent:TargetAddCount(pPlayer, "HistoryBoss", 1)
        TeacherStudent:CustomTargetAddCount(pPlayer, "HistoryBoss", 1)
    elseif szType=="Leader" then
    	Activity:OnPlayerEvent(pPlayer, "Act_JoinFieldBoss")
        TeacherStudent:TargetAddCount(pPlayer, "FieldBoss", 1)
        TeacherStudent:CustomTargetAddCount(pPlayer, "FieldBoss", 1)
    end
end

function TeacherStudent:ClearBossLeaderData()
	self.tbJoinedPids = {}
end

function TeacherStudent:OnStartup()
	local tbTransferKeys = {"TSDelayDismiss", "TSForceGraduate", "TSDelayChangeTitle",}
	for _, szOldKey in ipairs(tbTransferKeys) do
		ScriptData:AddDef(szOldKey)
		local tbOrg = ScriptData:GetValue(szOldKey)
		if next(tbOrg) then
			local _, nSlot = ScriptData:_GrpAddSlot(szOldKey)
			local szSlotKey = ScriptData:_GrpGetSlotKey(szOldKey, nSlot)
			ScriptData:SaveAtOnce(szSlotKey, tbOrg)
			ScriptData:SaveAtOnce(szOldKey, {})
			Log("TeacherStudent:OnStartup", szOldKey, nSlot)
		end
	end
end