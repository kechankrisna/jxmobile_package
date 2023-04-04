local tbNpc   = Npc:GetClass("TeacherStudentNpc")

function tbNpc:OnDialog(szParam)
    local szOpenTimeFrame = TeacherStudent.tbTimeFrameSettings[1].szTimeFrame
    local nOpenTime = CalcTimeFrameOpenTime(szOpenTimeFrame)
    local nDaysToOpen = Lib:GetLocalDay(nOpenTime) - Lib:GetLocalDay()
    local szNpcTalk = "[FFFE0D]" .. "Ba người đi tất có thầy ta chỗ này......\n" .. "[-]"
    if nDaysToOpen>0 then
        Dialog:Show({
            Text = string.format(szNpcTalk .. "Hệ thống sư đồ sẽ mở ra sau [FFFE0D]%d ngày[-]", nDaysToOpen),
            OptList = {
                { Text = "Tôi biết rồi" },
            },
        }, me, him)
    else
        Dialog:Show({
            Text = szNpcTalk .. "Muốn xử lý quan hệ thầy trò đều có thể đến đây tìm ta!",
            OptList = {
                { Text = "Xử lý quan hệ thầy trò", Callback = self.DealConnectionDlg, Param = {self} },
                { Text = "Tiến hành xuất sư nghi thức", Callback = self.GraduateDlg, Param = {self} },
            },
        }, me, him)
    end
end

function tbNpc:DealConnectionDlg()
    Dialog:Show({
        Text = "Ngươi muốn như thế nào xử lý quan hệ thầy trò?",
        OptList = {
            { Text = "Giải trừ quan hệ thầy trò", Callback = self.DismissDlg, Param = {self} },
            { Text = "Hủy bỏ giải trừ quan hệ thầy trò", Callback = self.CancelDismissDlg, Param = {self} },
        },
    }, me, him)
end

function tbNpc:DismissDlg()
    local tbMe = TeacherStudent:GetPlayerScriptTable(me)
    local tbCanDismiss = {}

    for nTeacherId, tbTeacher in pairs(tbMe.tbTeachers or {}) do
        local pStay = KPlayer.GetRoleStayInfo(nTeacherId)
        if pStay then
            tbCanDismiss[nTeacherId] = {
                nId = nTeacherId,
                szName = pStay.szName,
                bTeacher = true,
                nLastAccept = tbMe.nAcceptCount>=TeacherStudent.Def.nAddStudentNoCdCount and tbMe.nLastAccept or 0,
                bGraduate = tbTeacher.bGraduate,
            }
        end
    end
    for nStudentId, tbStudent in pairs(tbMe.tbStudents or {}) do
        local pStay = KPlayer.GetRoleStayInfo(nStudentId)
        if pStay then
            tbCanDismiss[nStudentId] = {
                nId = nStudentId,
                szName = pStay.szName,
                bTeacher = false,
                nLastAccept = tbMe.nAcceptCount>=TeacherStudent.Def.nAddStudentNoCdCount and tbMe.nLastAccept or 0,
                bGraduate = tbStudent.bGraduate,
            }
        end
    end

    if not next(tbCanDismiss) then
        self:NoCanDismissDlg()
        return
    end

    self:DismissSelectDlg(tbCanDismiss)
end

function tbNpc:DismissSelectDlg(tbCanDismiss)
    local tbOpt = {}
    for nPlayerId, tbInfo in pairs(tbCanDismiss) do
        table.insert(tbOpt, {
            Text = string.format("Cùng %s「%s」 giải trừ quan hệ thầy trò", tbInfo.bTeacher and "Sư phụ" or "Đồ đệ", tbInfo.szName),
            Callback = self.DismissSelectedDlg,
            Param = {self, tbInfo},
        })
    end

    Dialog:Show({
        Text = "Ngươi muốn cùng ai giải trừ quan hệ thầy trò?",
        OptList = tbOpt,
    }, me, him)
end

function tbNpc:DismissSelectedDlg(tbInfo)
    local bGraduate = tbInfo.bGraduate
    local nNow = GetTime()
    local nDismissDeadline = TeacherStudent:_ComputeDismissDeadline(bGraduate, tbInfo.nId)
    local szTips = ""
    if bGraduate then
        szTips = string.format("[FFFE0D]%s[-] đã xuất sư %s, nên xin cần tốn hao [FFFE0D]%d Nguyên bảo [-],Sau [FFFE0D]%s[-]  có hiệu lực, trong lúc đó có thể tìm ta hủy bỏ.",
            tbInfo.szName, tbInfo.bTeacher and "Sư phụ" or "Đồ đệ", TeacherStudent.Def.nGraduateDismissCost,
            Lib:TimeDesc2(nDismissDeadline-nNow))
    else
        local nCd = tbInfo.nLastAccept+TeacherStudent.Def.nAddStudentInterval-nNow
        local bInCd = nCd>(TeacherStudent.Def.nDismissPunishTime+nDismissDeadline-nNow)
        if bInCd then
            szTips = string.format("Nên xin sẽ tại [FFFE0D]%s[-] Sau có hiệu lực, trong lúc đó tùy thời có thể tìm ta hủy bỏ xin, ngươi ở vào thu đồ khoảng cách kỳ [FFFE0D]%s[-] Bên trong không thể lại %s.",
                Lib:TimeDesc8(nDismissDeadline-nNow), Lib:TimeDesc2(nCd), tbInfo.bTeacher and "Bái sư" or "Thu đồ")
        else
            local _, nOfflineSeconds = Player:GetOfflineDays(tbInfo.nId)
            local bNoPunish = nOfflineSeconds>=TeacherStudent.Def.nForceDissmissTime
            if bNoPunish then
                szTips = string.format("Nên xin sẽ tại [FFFE0D]%s[-] Sau có hiệu lực, trong lúc đó tùy thời có thể tìm ta hủy bỏ xin.",
                    Lib:TimeDesc8(nDismissDeadline-nNow))
            else
                szTips = string.format("Nên xin sẽ tại [FFFE0D]%s[-] Sau có hiệu lực, trong lúc đó tùy thời có thể tìm ta hủy bỏ xin, chính thức giải trừ quan hệ thầy trò sau [FFFE0D]%s[-] Bên trong không thể lại %s.",
                    Lib:TimeDesc8(nDismissDeadline-nNow), string.format("%d giờ", math.ceil(TeacherStudent.Def.nDismissPunishTime/3600)),
                    tbInfo.bTeacher and "Bái sư" or "Thu đồ")
            end
        end
    end

    Dialog:Show({
        Text = szTips,
        OptList = {
            { Text = "Xác định giải trừ quan hệ thầy trò", Callback = self.DismissConfirm, Param = {self, tbInfo.nId} },
        },
    }, me, him)
end

function tbNpc:DismissConfirm(nId)
    TeacherStudent:OnRequest("ReqDismiss", nId)
end

function tbNpc:NoCanDismissDlg()
    Dialog:Show({
        Text = "Ngươi trước mắt không có có thể giải trừ quan hệ thầy trò!",
        OptList = {
            { Text = "Tôi biết" }
        },
    }, me, him)
end

function tbNpc:CancelDismissDlg()
    local tbDismissing = ScriptData:GetValue("TSDismissing")
    local tbMyReq = tbDismissing[me.dwID] or {}
    if not next(tbMyReq) then
        self:NoDismissReqDlg()
        return
    end

    self:CancelDismissSelectDlg(tbMyReq)
end

function tbNpc:NoDismissReqDlg()
    Dialog:Show({
        Text = "Hiện tại không có yêu cầu giải trừ quan hệ sư đồ",
        OptList = {
            { Text = "Ta biết rồi" }
        },
    }, me, him)
end

function tbNpc:CancelDismissSelectDlg(tbMyReq)
    local tbDismissing = {}
    for nOtherId in pairs(tbMyReq) do
        local pStay = KPlayer.GetRoleStayInfo(nOtherId)
        if pStay then
            table.insert(tbDismissing, {
                nId = nOtherId,
                szName = pStay.szName,
                bTeacher = TeacherStudent:IsMyTeacher(me, nOtherId),
            })
        end
    end

    local tbOpt = {}
    for nPlayerId, tbInfo in pairs(tbDismissing) do
        table.insert(tbOpt, {
            Text = string.format("Hủy bỏ cùng %s「%s」 giải trừ quan hệ thầy trò", tbInfo.bTeacher and "Sư phụ" or "Đồ đệ", tbInfo.szName),
            Callback = self.CancelDismiss,
            Param = {self, tbInfo.nId},
        })
    end

    Dialog:Show({
        Text = "Ngươi muốn hủy bỏ cùng ai giải trừ quan hệ thầy trò xin?",
        OptList = tbOpt,
    }, me, him)
end

function tbNpc:CancelDismiss(nOtherId)
    TeacherStudent:OnRequest("CancelDismiss", nOtherId)
end

function tbNpc:GraduateDlg()
    Dialog:Show({
        Text = "Mời lựa chọn xuất sư nghi thức.",
        OptList = {
            { Text = "Đồ đệ xuất sư", Callback = self.GraduateWithStudentDlg, Param = {self} },
            { Text = "Ta muốn cưỡng chế xuất sư", Callback = self.ForceGraduateDlg, Param = {self} },
        },
    }, me, him)
end

function tbNpc:GraduateWithStudentDlg()
    local nTeamId = me.dwTeamID
    local tbTeamMembers = TeamMgr:GetMembers(nTeamId)
    if #tbTeamMembers~=2 then
        Dialog:Show({
            Text = "Mời trước cùng Đồ đệ tổ đội sau lại tới tìm ta xuất sư đi.",
            OptList = {
                { Text = "Ta biết rồi" }
            },
        }, me, him)
        return
    end

    local nStudentId = 0
    for _, nId in ipairs(tbTeamMembers) do
        if nId~=me.dwID then
            nStudentId = nId
            break
        end
    end

    local bIsMyStudent = TeacherStudent:IsMyStudent(me, nStudentId)
    if not bIsMyStudent then
        Dialog:Show({
            Text = "Đồng đội không phải đồ đệ của ngươi",
            OptList = {
                { Text = "Ta biết rồi" }
            },
        }, me, him)
        return
    end

    local pStudent = nil
    local tbPlayer = KNpc.GetAroundPlayerList(him.nId, TeacherStudent.Def.nGraduateDistance) or {}
    for _,pPlayer in pairs(tbPlayer) do
        if pPlayer.dwID==nStudentId then
            pStudent = pPlayer
            break
        end
    end
    if not pStudent then
        Dialog:Show({
            Text = "Hay là chờ đồ đệ đến lại tới tìm ta xuất sư đi.",
            OptList = {
                { Text = "Ta biết rồi" }
            },
        }, me, him)
        return
    end

    local bOk, szErr = TeacherStudent:_CheckBeforeGraduate(me, pStudent)
    if not bOk then
        Dialog:Show({
            Text = string.format("Các ngươi còn chưa đạt thành xuất sư điều kiện (%s)", szErr),
            OptList = {
                { Text = "Ta biết rồi" }
            },
        }, me, him)
        return
    end

    local nFinishedCount = TeacherStudent:_GetTargetFinishedCount(pStudent, me.dwID)
    local tbTeacherReward = {szJudgement="-", szJudgement2="-"}
    for i=#TeacherStudent.Def.tbGraduateTeacherRewards,1,-1 do
        local tbInfo = TeacherStudent.Def.tbGraduateTeacherRewards[i]
        if nFinishedCount>=tbInfo.nMin then
            tbTeacherReward = tbInfo
            break
        end
    end
    Dialog:Show({
        Text = string.format("Đồ đệ「%s」đạt thành [FFFE0D]%d [-] Sư đồ mục tiêu, đánh giá: [FFFE0D]%s[-], sư đồ thu được [FFFE0D]%s[-] Xuất sư ban thưởng, nhất định phải hiện tại xuất sư sao?", pStudent.szName, nFinishedCount, tbTeacherReward.szJudgement, tbTeacherReward.szJudgement2),
        OptList = {
            { Text = "Xác định xuất sư", Callback = self.ReqGraduate, Param = {self, nStudentId} },
            { Text = "Tạm không xuất sư" },
        },
    }, me, him)
end

function tbNpc:ReqGraduate(nOtherId)
    TeacherStudent:OnRequest("ReqGraduate", me.dwID, nOtherId)
end

function tbNpc:ForceGraduateDlg()
    local tbMe = TeacherStudent:GetPlayerScriptTable(me)
    local tbUndergraduates = {}
    for nTeacherId, tbTeacher in pairs(tbMe.tbTeachers) do
        if not tbTeacher.bGraduate then
            tbUndergraduates[nTeacherId] = {
                bTeacher = true,
            }
        end
    end
    for nStudentId, tbStudent in pairs(tbMe.tbStudents) do
        if not tbStudent.bGraduate then
            tbUndergraduates[nStudentId] = {
                bTeacher = false,
            }
        end
    end
    
    local tbOpt = {}
    for nPlayerId, tbInfo in pairs(tbUndergraduates) do
        local pStay = KPlayer.GetRoleStayInfo(nPlayerId)
        if pStay then
            table.insert(tbOpt, {
                Text = string.format("Bị %s「%s」 cưỡng chế xuất sư", tbInfo.bTeacher and "Sư phụ" or "Đồ đệ", pStay.szName),
                Callback = self.ForceGraduateSelectDlg,
                Param = {self, nPlayerId, tbInfo.bTeacher},
            })
        end
    end

    Dialog:Show({
        Text = string.format("Sư phụ hoặc Đồ đệ[FFFE0D]rời mạng %d ngày[-]且[FFFE0D]Phù hợp xuất sư điều kiện [-], liền có thể xin cưỡng chế xuất sư. Cưỡng chế xuất sư không ảnh hưởng xuất sư ban thưởng, ngươi muốn cùng ai mạnh chế được sư?", math.floor(TeacherStudent.Def.nForceGraduateTime/(24*3600))),
        OptList = tbOpt,
    }, me, him)
end

function tbNpc:ForceGraduateSelectDlg(nOtherId, bAmIStudent)
    local nNow = GetTime()
    local bOfflineValid = false
    if not KPlayer.GetPlayerObjById(nOtherId) then
        local _, nOffSeconds = Player:GetOfflineDays(nOtherId)
        if nOffSeconds>=TeacherStudent.Def.nForceGraduateTime then
            bOfflineValid = true
        end
    end

    if not bOfflineValid then
        Dialog:Show({
            Text = string.format("%s  ngươi Offline chưa vượt qua [FFFE0D]%d ngày[-], không thể xin cưỡng chế xuất sư.", bAmIStudent and "Sư phụ" or "Đồ đệ", 
                math.floor(TeacherStudent.Def.nForceGraduateTime/(24*3600))),
            OptList = {
                { Text = "Ta biết rồi" }
            },
        }, me, him)
        return
    end

    local bOk, szErr = TeacherStudent:CheckBeforeForceGraduate(me, nOtherId)
    if not bOk then
         Dialog:Show({
            Text = string.format("Các ngươi còn chưa đạt thành xuất sư điều kiện (%s)", szErr),
            OptList = {
                { Text = "Ta biết rồi" }
            },
        }, me, him)
        return
    end

    local nTargetsCount = TeacherStudent:_GetTargetFinishedCount(me, nOtherId)
    local tbTeacherReward = nil
    for i=#TeacherStudent.Def.tbGraduateTeacherRewards,1,-1 do
        local tbInfo = TeacherStudent.Def.tbGraduateTeacherRewards[i]
        if nTargetsCount>=tbInfo.nMin then
            tbTeacherReward = tbInfo
            break
        end
    end
    
    local pStay = KPlayer.GetRoleStayInfo(nOtherId)
    local szStudentName = bAmIStudent and me.szName or pStay.szName
    Dialog:Show({
        Text = string.format("Đồ đệ「%s」đạt thành [FFFE0D]%d [-] Sư đồ mục tiêu, đánh giá: [FFFE0D]%s[-], sư đồ thu được [FFFE0D]%s[-] Xuất sư ban thưởng, nhất định phải hiện tại xuất sư sao?", szStudentName, nTargetsCount, tbTeacherReward.szJudgement, tbTeacherReward.szJudgement2),
        OptList = {
            { Text = "Xác nhận xuất sư", Callback = self.ForceGraduate, Param = {self, nOtherId} },
            { Text = "Tạm không xuất sư" },
        },
    }, me, him)
end

function tbNpc:ForceGraduate(nOtherId)
    TeacherStudent:OnRequest("ReqForceGraduate", nOtherId)
end