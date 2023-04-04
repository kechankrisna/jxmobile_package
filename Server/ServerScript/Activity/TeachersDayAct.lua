local tbAct = Activity:GetClass("TeachersDayAct")
tbAct.tbTrigger = { 
    Init    = {}, 
    Start   = {}, 
    End     = {}, 
}

tbAct.nItemId = 6232	--师徒信物
tbAct.nFubenMapTID = 7001
tbAct.tbAwardInfo = { {{"Item", 6261, 1}, {"BasicExp", 60}}, {{"Item", 6262, 1}, {"BasicExp", 60}} }
tbAct.tbTeacherAward = { {"Renown", 3000}, {"Renown", 500} } --师父附加奖励，前面首次，后面普通
tbAct.nMaxAwardTimes = 10 --师父最大奖励次数
tbAct.tbBornPos = {{3166, 5248}, {2312, 4520}} --进入副本时的位置，前面师父后面徒弟
tbAct.tbTeatherTitle = {[5] = 2051, [10] = 2052} 
tbAct.tbStudentTitle = {[5] = 2053} 

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_SendGift", "OnSendGift")
        Activity:RegisterGlobalEvent(self, "Act_CompleteTeacherFuben", "OnFubenComplete")

        self:RegisterNpcDialog()
        local _, nEndTime = self:GetOpenTimeInfo()
        self:RegisterDataInPlayer(nEndTime)
    end
end

function tbAct:RegisterNpcDialog()
   	Activity:RegisterNpcDialog(self, "TeacherStudentNpc", {
   		Text = "Tham gia sư đồ tiết hoạt động",
   		Callback = self.TryEnterFuben,
   		Param = {self},
   	})
end

local function fnAllMember(tbMember, fnSc, ...)
    for _, nPlayerId in pairs(tbMember or {}) do
        local pMember = KPlayer.GetPlayerObjById(nPlayerId);
        if pMember then
            fnSc(pMember, ...);
        end
    end
end

function tbAct:TryEnterFuben()
    local tbTeam = TeamMgr:GetTeamById(me.dwTeamID)
    if not tbTeam then
        Npc:ShowErrDlg(me, him, "Mời sư đồ tổ hai người đội đến đây tham gia")
        return
    end

    local tbMembers = tbTeam:GetMembers()
    if Lib:CountTB(tbMembers)~=2 then
        Npc:ShowErrDlg(me, him, "Nhất định phải sư đồ tổ hai người đội mới có thể tham gia")
        return
    end

    local nMyId = me.dwID
    local nOtherId = nil
    for _, nPlayerId in pairs(tbMembers) do
        if nPlayerId~=nMyId then
            nOtherId = nPlayerId
            break
        end
    end
    local pOther = KPlayer.GetPlayerObjById(nOtherId or 0)
    if not pOther then
        Npc:ShowErrDlg(me, him, "Đồng đội không tuyến bên trên")
        return
    end
    if not TeacherStudent:_IsConnected(me, pOther) then
        Npc:ShowErrDlg(me, him, "Ngươi cùng đồng đội không phải quan hệ thầy trò")
        return
    end

    local bOk, szErr = Npc:IsTeammateNearby(me, him, true)
    if not bOk then
        Npc:ShowErrDlg(me, him, szErr)
        return
    end

    local pTeacher, pStudent = TeacherStudent:_GetRelations(me, pOther)
    local nItemId = Activity:GetClass("TeachersDayAct").nItemId
    if pStudent.ConsumeItemInBag(nItemId, 1, Env.LogWay_TeachersDay)~=1 then
        Npc:ShowErrDlg(me, him, "Đồ đệ trong hành trang không có sư đồ tín vật")
        return
    end

    local nTeacher = pTeacher.dwID
    local function fnSuccessCallback(nMapId)
        local function fnSucess(pPlayer, nMapId)
            pPlayer.SetEntryPoint()
            local tbPos = (nTeacher == pPlayer.dwID) and self.tbBornPos[1] or self.tbBornPos[2]
            pPlayer.SwitchMap(nMapId, unpack(tbPos))
            pPlayer.SetTempRevivePos(nMapId, unpack(tbPos))
        end
        fnAllMember(tbMembers, fnSucess, nMapId)
    end
        
    local function fnFailedCallback()
        local function fnMsg(pPlayer, szMsg)
            pPlayer.CenterMsg(szMsg)
        end
        fnAllMember(tbMembers, fnMsg, "Sáng tạo phó bản thất bại, xin sau nếm thử!")
    end

    Fuben:ApplyFuben(pStudent.dwID, self.nFubenMapTID, fnSuccessCallback, fnFailedCallback, pTeacher.dwID, pStudent.dwID)
    Log("TeachersDayAct:TryEnterFuben", pTeacher.dwID, pStudent.dwID)
end


function tbAct:OnSendGift(pPlayer, pAcceptPlayer, nGiftType)
    if nGiftType~=Gift.GiftType.RoseAndGrass then
        return
    end

	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	local nNow = GetTime()
	if nNow<nStartTime or nNow>nEndTime then
		return
	end

    local nSender = pPlayer.dwID
    local nReceiver = pAcceptPlayer.dwID
    if not TeacherStudent:_IsConnected(pPlayer, pAcceptPlayer) then
        return
    end

    if Gift.GiftManager:CheckGiftTimes(pPlayer, nReceiver, 1, nGiftType) or
        Gift.GiftManager:CheckGiftTimes(pAcceptPlayer, nSender, 1, nGiftType) then
        return
    end

    local pTeacher, pStudent = TeacherStudent:_GetRelations(pPlayer, pAcceptPlayer)
    if not pStudent then
        Log("[x] TeachersDayAct:OnSendGift no student", nSender, nReceiver, nGiftType)
        return
    end

    pStudent.AddItem(self.nItemId, 1, nEndTime, Env.LogWay_TeachersDay)
    self:NotifyGetToken(pTeacher, pStudent)
    Log("TeachersDayAct:OnSendGift get item", pPlayer.dwID, pAcceptPlayer.dwID, pStudent.dwID, nGiftType)
end

function tbAct:NotifyGetToken(pTeacher, pStudent)
	pTeacher.Msg(string.format("Ngươi hôm nay cùng đồ đệ [FFFE0D]%s[-] Hỗ tặng hoa hồng / Cỏ may mắn đạt tiêu chuẩn, đồ đệ thu hoạch được sư đồ tín vật một cái, nhưng cùng đồ đệ tổ đội tham gia sư đồ thí luyện", pStudent.szName), 1)
	pStudent.Msg(string.format("Ngươi hôm nay cùng sư phụ [FFFE0D]%s[-] Hỗ tặng hoa hồng / Cỏ may mắn đạt tiêu chuẩn, thu hoạch được sư đồ tín vật một cái, nhưng cùng sư phụ tổ đội tham gia sư đồ thí luyện", pTeacher.szName), 1)
end

function tbAct:OnFubenComplete(nTeacher, nStudent)
    if not nTeacher or not nStudent then
        return
    end

    local tbPlayer = {nTeacher, nStudent}
    for _, nPlayerId in ipairs(tbPlayer) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if pPlayer then
            local tbData = self:GetDataFromPlayer(nPlayerId) or {}
            local bTeacher = nTeacher == nPlayerId
            local szJoinKey = bTeacher and "nJoinTimesAsT" or "nJoinTimesAsS"
            tbData[szJoinKey] = tbData[szJoinKey] or 0
            if not bTeacher or tbData[szJoinKey] < self.nMaxAwardTimes then
                local tbAward = self:GetAward(tbData[szJoinKey] + 1, bTeacher)
                Mail:SendSystemMail({
                    To       = nPlayerId,
                    Title    = "Sư đồ thí luyện ban thưởng thư tín",
                    Text     = "Chúc mừng thiếu hiệp, ngươi đã thành công thông qua sư đồ thí luyện, phía dưới là vì ngươi chuẩn bị thí luyện ban thưởng, mời kiểm tra và nhận. Nhưng chúc mừng sau khi, đừng quên vì ngươi các vị ân sư đưa lên một câu ấm áp chúc phúc a!\n[FFFE0D]( Lần đầu khiêu chiến thành công có thể đạt được lần đầu ban thưởng, toàn bộ hoạt động trong lúc đó sư phụ nhiều nhất có thể đạt được 10 Lần ban thưởng )[-]",
                    From     = "Thượng Quan Phi rồng",
                    tbAttach = tbAward,
                })
                tbData[szJoinKey] = tbData[szJoinKey] + 1
                self:SaveDataToPlayer(pPlayer, tbData)
            end
            Log("TeachersDayAct OnFubenComplete", nPlayerId, bTeacher, tbData[szJoinKey])
        end
    end
end

function tbAct:GetAward(nJoinTimes, bTeacher)
    local tbAward = {}
    local nAwardIdx = math.min(nJoinTimes, 2)
    local nTitleAward
    if bTeacher then
        table.insert(tbAward, self.tbTeacherAward[nAwardIdx])
        nTitleAward = self.tbTeatherTitle[nJoinTimes]
    else
        nTitleAward = self.tbStudentTitle[nJoinTimes]
    end
    if nTitleAward then
        table.insert(tbAward, {"AddTimeTitle", nTitleAward, 0})
    end
    tbAward = Lib:MergeTable(tbAward, self.tbAwardInfo[nAwardIdx])
    return tbAward
end