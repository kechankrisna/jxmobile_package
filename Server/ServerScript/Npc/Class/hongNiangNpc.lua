local tbNpc   = Npc:GetClass("hongNiangNpc")
function tbNpc:OnDialog(szParam)
	local nOpenDay, nOpenTime = Wedding:CheckTimeFrame()
    if nOpenDay then
         Dialog:Show(
        {
            Text = string.format("Nguyện bên nhau đến bạc đầu.\n[FFFE0D]Hệ thống kết hôn sẽ mở sau %d ngày![-]", nOpenDay),
            OptList = {},
        }, me, him)
        return 
    end
    local tbOptList = {}
    local nLover = Wedding:GetLover(me.dwID)
    if nLover then
        tbOptList = {
            { Text = "Xử lý ly hôn", Callback = self.DismissMenuDlg, Param = {self} },
            { Text = "Nhận Thưởng Kỷ Niệm Kết Hôn", Callback = self.ClaimMemorialDayRewards, Param = {self} },
        }
    else
        tbOptList = {
           { Text = "Giải trừ quan hệ đính hôn", Callback = self.MakeSureDelEngaged, Param = {self, me.dwID}},
        }
    end
	Dialog:Show(
    {
        Text = "Nguyện bên nhau đến bạc đầu.",
        OptList = tbOptList,
    }, me, him)
end

function tbNpc:MakeSureDelEngaged(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
		return
	end
	if Wedding:IsSingle(pPlayer) then
		pPlayer.CenterMsg("Ngươi không có quan hệ đính hôn")
		return
	end
	local nEngaged = Wedding:GetEngaged(pPlayer.dwID)
	if nEngaged then
		local pStayInfo = KPlayer.GetPlayerObjById(nEngaged) or KPlayer.GetRoleStayInfo(nEngaged)
		local szName = pStayInfo and pStayInfo.szName or ""
		local bHadBook = Wedding:CheckPlayerHadBook(dwID)
        -- 自动换行将颜色代码隔断会导致变色失败
		local szTip = string.format("Xác nhận dùng [FFFE0D]%s[-] giải trừ quan hệ đính hôn? Giải trừ quan hệ sẽ mất [FF6464FF]「Duyên Định Kim Sinh」đạo cụ không hoàn lại[-]", szName)
        local szTipNone = string.format("Xác nhận dùng [FFFE0D]%s[-] giải trừ quan hệ đính hôn?", szName) 
        if bHadBook then
            szTip = string.format("Ngươi đã dự định hôn lễ %s giải trừ quan hệ [FF6464FF] dự định hôn lễ, nguyên bảo không hoàn lại[-]", szTipNone)
        end
		pPlayer.MsgBox(szTip,
			{
				{"Xác nhận giải trừ", function () self:ComfirmDelEngaged(dwID) end},
				{"Suy nghĩ lại đã"},
			});
	else
		pPlayer.CenterMsg("Các ngươi đã thành hôn, nếu duyên đã tận, có thể tìm ta xin ly hôn")
	end
end

function tbNpc:ComfirmDelEngaged(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
		return
	end
	Wedding:TryDelEngaged(pPlayer)
end

---------
function tbNpc:DismissMenuDlg()
    Dialog:Show({
        Text = "Nếu duyên đã tận, xa nhau cũng là một sự khởi đầu tốt.",
        OptList = {
            { Text = "Thỏa thuận ly hôn", Callback = self.Dismiss, Param = {self} },
            { Text = "Cưỡng chế ly hôn", Callback = self.ForceDismiss, Param = {self} },
            { Text = "Hủy xin phép ly hôn", Callback = self.CancelDismiss, Param = {self} },
        },
    }, me, him)
end

function tbNpc:Dismiss()
    local nOtherId = Wedding:GetLover(me.dwID)
    if not nOtherId then
        Npc:ShowErrDlg(me, him, "Ngươi chưa kết hôn")
        return
    end

    local bOk, szErr, szErrType = Npc:IsTeammateNearby(me, him, true)
    if not bOk then
        if szErrType then
            local tbErrs = {
                no_team = "Hãy tổ đội với bạn đời, rồi đến ly hôn",
                not_captain = "Cùng đội trưởng tới ly hôn",
            }
            szErr = tbErrs[szErrType] or szErr
        end
        Npc:ShowErrDlg(me, him, szErr)
        return
    end

    local function fnConfirm()
        local bOk, szErr = Wedding:DismissReq(me)
        if not bOk and szErr then
            Npc:ShowErrDlg(me, him, szErr)
        end
    end

    Dialog:Show({
        Text = "Duyên phận có được không dễ, [FF6464FF]đại hiệp quyết định hủy quan hệ hôn nhân với đối phương?[-]",
        OptList = {
            { Text = "Hủy quan hệ hôn nhân", Callback = fnConfirm, Param = {} },
        },
    }, me, him)
end

function tbNpc:ForceDismiss()
    local function fnConfirm()
        local bOk, szErr = Wedding:ForceDismissReq(me)
        if not bOk and szErr then
            Npc:ShowErrDlg(me, him, szErr)
        end
    end

    local nLover = Wedding:GetLover(me.dwID)
    if not nLover then
        Npc:ShowErrDlg(me, him, "Ngươi không kết hôn")
        return
    end

    local szTxt = ""
    local _, nOfflineSec = Player:GetOfflineDays(nLover)
    if nOfflineSec>=Wedding.nForceDivorcePlayerOffline then
        szTxt = "Đại hiệp xác định hủy quan hệ hôn nhân? Đối phương không online [FFFE0D]14 ngày[-] mới có hiệu lực."
    else
        local nNow = GetTime()
        local tbNow = os.date("*t", nNow)
        tbNow.day = tbNow.day+1
        tbNow.hour = 0
        tbNow.min = 0
        tbNow.sec = 1
        local nDeadline = os.time(tbNow)+Wedding.nForceDivorceDelayTime
        szTxt = string.format("Hủy quan hệ hôn nhân?[-]Xin phép cần tốn [FFFE0D]%d Nguyên Bảo [-], có hiệu lực sau[FFFE0D]%s[-], trong thời gian đó có thể tìm ta hủy yêu cầu.", Wedding.nForceDivorceCost, Lib:TimeDesc2(nDeadline-nNow))
    end
    Dialog:Show({
        Text = szTxt,
        OptList = {
            { Text = "Hủy quan hệ hôn nhân", Callback = fnConfirm, Param = {} },
        },
    }, me, him)
end

function tbNpc:CancelDismiss()
    local tbRecord = Wedding:_IsDismissing(me.dwID)
    if not tbRecord then
        Npc:ShowErrDlg(me, him, "Ngươi không có xin phép ly hôn")
        return
    end

    local function fnConfirm()
        local bOk, szErr = Wedding:CancelDismissReq(me)
        if not bOk and szErr then
            Npc:ShowErrDlg(me, him, szErr)
        end
    end

    local _, nOtherId = unpack(tbRecord)
    local pOther = KPlayer.GetRoleStayInfo(nOtherId) or {szName=""}
    local szTxt = string.format("Đang xin phép hủy quan hệ hôn nhân với [fffe0d]%s[-], hủy xin phép ly hôn?", pOther.szName)
    Dialog:Show({
        Text = szTxt,
        OptList = {
            { Text = "Hủy xin phép ly hôn?", Callback = fnConfirm, Param = {} },
        },
    }, me, him) 
end

function tbNpc:ClaimMemorialDayRewards()
    local nOtherId = Wedding:GetLover(me.dwID)
    if not nOtherId then
        Npc:ShowErrDlg(me, him, "Ngươi chưa kết hôn")
        return
    end

    local bOk, szErr, szErrType = Npc:IsTeammateNearby(me, him, true)
    if not bOk then
        if szErrType then
            local tbErrs = {
                no_team = "Hãy tổ đội với bạn đời, rồi đến nhận thưởng kỷ niệm",
                not_captain = "Cùng đội trưởng tới nhận thưởng kỷ niệm",
            }
            szErr = tbErrs[szErrType] or szErr
        end
        Npc:ShowErrDlg(me, him, szErr)
        return
    end

    local bOk, szErr = Wedding:ClaimMemorialDayRewardsReq(me)
    if not bOk and szErr then
        Npc:ShowErrDlg(me, him, szErr)
    end
end
