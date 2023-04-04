local tbNpc   = Npc:GetClass("YueLaoNpc")
function tbNpc:OnDialog()
    local nOpenDay, nOpenTime = Wedding:CheckTimeFrame()
    if nOpenDay then
         Dialog:Show(
        {
            Text = string.format("Đại hiệp đến đây để tìm một nữa kia của mình?\n[FFFE0D]Hệ thống kết hôn sẽ mở sau %d ngày![-]", nOpenDay),
            OptList = {},
        }, me, him)
        return 
    end
    -- 主城常驻NPC
    if him.szScriptParam == "CityNpc" then
        local tbOptList = {
            { Text = "Đặt trước hôn lễ", Callback = self.OrderWedding, Param = {self, me.dwID} };
            { Text = "Tham gia tiệc cưới", Callback = self.EnterWedding, Param = {self, me.dwID} };
        }
        local nLevel, tbPlayerBookInfo, nOpen = Wedding:CheckPlayerHadBook(me.dwID)
        if nLevel then
            local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
            if tbMapSetting and tbMapSetting.fnCheckBookIsOpen(nOpen) then
                table.insert(tbOptList, 1, { Text = "Bắt đầu hôn lễ", Callback = self.TryStartWedding, Param = {self, me.dwID} })
            end
        end
        local nLover = Wedding:GetLover(me.dwID)
        if nLover then
            table.insert(tbOptList, { Text = "Thay đổi danh hiệu phu thê", Callback = self.ChangeTitle, Param = {self} })
        end
        Dialog:Show(
        {
            Text = "Đại hiệp đến đây để tìm một nữa kia của mình?",
            OptList = tbOptList,
        }, me, him)
    -- 婚礼现场NPC
    elseif him.szScriptParam == "FubenNpc" then
        local tbInst = Fuben.tbFubenInstance[him.nMapId]
        if tbInst then
            tbInst:OnDialogYueLao(me, him)
        end
    end
	
end

function tbNpc:TryStartWedding(dwID)
    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
        return
    end
    local nLevel = Wedding:CheckPlayerHadBook(dwID)
    local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
    if not tbMapSetting then
        return
    end
    if tbMapSetting.szStartWeddingTip then
        pPlayer.MsgBox(tbMapSetting.szStartWeddingTip, {{"Tiến hành hôn lễ", self.StartWedding, self, dwID}, {"Hủy"}})
    else
        self:StartWedding(dwID)
    end
end

function tbNpc:StartWedding(dwID)
    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
        return
    end
    Wedding:TryStartBookWedding(pPlayer)
end

function tbNpc:OrderWedding(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
    	return
	end
    if not Wedding:CheckOpen() then
        pPlayer.CenterMsg("Hôn lễ chưa mở, xin vui lòng đợi!")
        return
    end
	pPlayer.CallClientScript("Ui:OpenWindow", "WeddingBookPanel")
end

function tbNpc:EnterWedding(dwID)
    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
        return
    end
    if not Wedding.tbWeddingMap or not next(Wedding.tbWeddingMap) then
        pPlayer.CenterMsg("Không có hôn lễ đang cử hành", true)
        return
    end
    pPlayer.CallClientScript("Ui:OpenWindow", "WeddingEnterPanel")
end

--------

function tbNpc:ChangeTitle()
    local nOtherId = Wedding:GetLover(me.dwID)
    if not nOtherId then
        Npc:ShowErrDlg(me, him, "Ngươi chưa kết hôn")
        return
    end

    local bOk, szErr = Wedding:CheckLoveTeam(me, true)
    if not bOk then
        Npc:ShowErrDlg(me, him, szErr)
        return
    end

    bOk, szErr = Npc:IsTeammateNearby(me, him, true)
    if not bOk then
        Npc:ShowErrDlg(me, him, szErr)
        return
    end

    local pOther = KPlayer.GetRoleStayInfo(nOtherId)
    local szHusbandName, szWifeName = me.szName, pOther.szName
    if me.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)~=Gift.Sex.Boy then
        szHusbandName, szWifeName = szWifeName, szHusbandName
    end
    me.CallClientScript("Ui:OpenWindow", "MarriageTitlePanel", szHusbandName, szWifeName)
end