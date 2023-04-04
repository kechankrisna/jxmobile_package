local tbAct = Activity:GetClass("QingRenJie")
tbAct.tbTrigger = { Init = { }, Start = { }, End = { }, }

tbAct.GROUP = 68
tbAct.VERSION = 11
tbAct.INVITE = 12
tbAct.BE_INVITE = 13
tbAct.TICKET_FLAG = 14
tbAct.TITLE_FLAG = 15
tbAct.SIT_FLAG = 16
tbAct.ACCEPT_DAY = 17
tbAct.ACCEPT_TIMES = 18
tbAct.tbMapInfo = {}

----------------------------以下为配置项----------------------------
tbAct.TICKET_TID = 3790      --船票ID
tbAct.GIFT_TID = 3787        --赠送礼物时赠送方得到的了礼物
tbAct.GIFT_TID_ACCEPT = 3791 --赠送礼物是对方得到的了礼物
tbAct.RANDOM_GIFT_TID = 3793 --从礼物开出的道具ID
tbAct.TICKET_RATE = 10000    --max is 1000000
tbAct.LEVEL = 40             --参与等级
tbAct.tbGift = {
    3788,
    3789,
}
tbAct.TITLE_ENDTIME = Lib:ParseDateTime("2018/3/14")
tbAct.BE_SEND_GIFT = 5      --每天接受礼物时只能有5有奖励
tbAct.HEAD_BG = 25          --头像框ID
tbAct.CHOOSE_TITLE_ID = 3792
tbAct.BASIC_EXP = 120
tbAct.IMITITY = 999
tbAct.tbPos = {
    {1450, 1700},
    {350,1700},
}
tbAct.TICKET_PRICE = 999
tbAct.NEED_IMITITY_LV = 1
----------------------------以上为配置项----------------------------

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
        self:SendMail("    Có bằng hữu từ phương xa tới, quên cả trời đất? Có thuyền từ phương xa tới, không chơi trò chơi hồ? Nay giang hồ khác thường quốc chi bang đến thăm, tùy theo mà đến còn có yêu diễm đóa hoa cùng tinh xảo thuyền phường, hiệp sĩ chỉ cần hoàn thành [FFFE0D] Mỗi ngày mục tiêu sinh động độ [-] Liền có thể thu hoạch được lễ vật, người hữu duyên càng có thể thu hoạch được hi hữu [FFFE0D] Hai người vé tàu [-], cùng ngưỡng mộ trong lòng người thấy lầu nhỏ nghe mưa phảng phong thái! Như cùng vé tàu bỏ lỡ cơ hội, chỉ cần tiến về [FFFE0D] Tương Dương thành [-] Tìm kiếm [c8ff00][url=npc: Tiểu Tử khói, 95, 10][-] Liền có thể trực tiếp mua vé tàu! Đội tàu đem với mấy ngày sau rời đi, đừng bỏ qua a!")
    elseif szTrigger == "Start" then 
        Activity:RegisterPlayerEvent(self, "Act_EverydayTarget_Award", "OnGainEverydayAward")
        Activity:RegisterPlayerEvent(self, "Act_QingRenJie_AgreeInvite", "AgreeInvite")
        Activity:RegisterPlayerEvent(self, "Act_QingRenJie_TryDazuo", "TryDazuo")
        Activity:RegisterPlayerEvent(self, "Act_QingRenJie_AgreeInviteDazuo", "AgreeInviteDazuo")
        Activity:RegisterPlayerEvent(self, "Act_QingRenJie_ChooseTitle", "TryChooseTitle")
        Activity:RegisterPlayerEvent(self, "Act_TryUseQingRenJieGift", "OnUseGift")
        Activity:RegisterPlayerEvent(self, "Act_SendGift", "OnSendGift")
        Activity:RegisterPlayerEvent(self, "Act_OnLeaveMap", "OnLeaveMap")
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogout", "OnLogout")
        Activity:RegisterNpcDialog(self, 95, {Text = "Tiến đến mua vé tàu", Callback = self.BuyTicket, Param = {self}})
        Activity:RegisterNpcDialog(self, 95, {Text = "Tiến về lầu nhỏ nghe mưa phảng", Callback = self.TryInteract, Param = {self}})
        Activity:RegisterNpcDialog(self, 95, {Text = "Tiến đến được mời thuyền phảng", Callback = self.TryEnterAlong, Param = {self}})
        self.tbMapInfo = {}
        local tbItem = Item:GetClass("QingRenJieTitleItem")
        self.tbTitle = tbItem.tbTitle
    elseif szTrigger == "End" then
        self:SendMail("    Chư vị hiệp sĩ, Trung Nguyên võ lâm quả nhiên thú vị, các vị tình thâm ý trọng, cũng làm ta mở rộng tầm mắt, bây giờ đội tàu đã rời đi, mong rằng chư vị bảo trọng! Năm sau gặp lại!")
    end
end

function tbAct:SendMail(szContent)
    Mail:SendGlobalSystemMail({
        Title = "Chèo thuyền du ngoạn giang hồ tình nhân kết",
        Text = szContent,
        From = "Tiểu Tử Yên",
        LevelLimit = self.LEVEL
        })
end

function tbAct:OnGainEverydayAward(pPlayer)
    if pPlayer.nLevel < self.LEVEL then
        return
    end

    local nSex = pPlayer.nSex
    local _, nEndTime = self:GetOpenTimeInfo()
    pPlayer.SendAward({{"Item", self.tbGift[nSex], 1, nEndTime}}, true, false, Env.LogWay_QingRenJie)
    Log("QingRenJie OnGainEverydayAward", pPlayer.dwID)
end

function tbAct:CheckGainTicket(pPlayer)
    self:CheckPlayerData(pPlayer)
    return pPlayer.GetUserValue(self.GROUP, self.TICKET_FLAG) <= 0, "Hoạt động trong lúc đó mỗi danh hiệp sĩ chỉ có thể thu hoạch được một trương vé tàu"
end

function tbAct:BuyTicket(bConfirm)
    local pPlayer = me
    local bRet, szMsg = self:CheckGainTicket(pPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end

    if not bConfirm then
        me.MsgBox("Mỗi vị hiệp sĩ chỉ có thể thu hoạch được một trương vé tàu, phải chăng xác nhận tốn hao [FFFE0D]999 Nguyên bảo [-] Tiến hành mua?", {{"Xác nhận", self.BuyTicket, self, true}, {"Hủy bỏ"}})
        return
    end

    if pPlayer.GetMoney("Gold") < self.TICKET_PRICE then
        pPlayer.CenterMsg("Nguyên bảo không đủ! Mời trước trữ giá trị")
        pPlayer.CallClientScript("Ui:OpenWindow", "CommonShop", "Recharge", "Recharge")
        return
    end
    pPlayer.CostGold(self.TICKET_PRICE, Env.LogWay_QingRenJie, nil, function (nPlayerId, bSuccess)
            local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
            if not pPlayer then
                return false, "Offline"
            end

            if not bSuccess then
                return false, "Trữ giá trị thất bại"
            end

            local bRet, szMsg = self:CheckGainTicket(pPlayer)
            if not bRet then
                return false, szMsg
            end

            local _, nEndTime = self:GetOpenTimeInfo()
            pPlayer.SetUserValue(self.GROUP, self.TICKET_FLAG, 1)
            pPlayer.SendAward({{"Item", self.TICKET_TID, 1, nEndTime}}, true, nil, Env.LogWay_QingRenJie)
            Log("QingRenJie BuyTicket Success", pPlayer.dwID)
            return true
    end)
end

function tbAct:OnUseGift(pPlayer, pItem)
    if Item:Consume(pItem, 1) < 1 then
        return
    end

    local _, nEndTime = self:GetOpenTimeInfo()
    local bRet = self:CheckGainTicket(pPlayer)
    if bRet and MathRandom(1000000) <= self.TICKET_RATE then
        pPlayer.SetUserValue(self.GROUP, self.TICKET_FLAG, 1)
        pPlayer.SendAward({{"Item", self.TICKET_TID, 1, nEndTime}}, true, false, Env.LogWay_QingRenJie)
        local szMsg = string.format("Hiệp sĩ「%s」Mở ra đáp lễ hộp quà sau phát hiện trong đó hai người vé tàu · Chèo thuyền du ngoạn giang hồ, ít ngày nữa liền có thể mang theo ngưỡng mộ trong lòng người đồng hành, cùng thuyền chung độ, thật là khiến người sinh lòng ghen tị!", pPlayer.szName)
        KPlayer.SendWorldNotify(1, 1000, szMsg, ChatMgr.ChannelType.Public, 1)
        Log("QingRenJie OnUseGift GetTicket", pPlayer.dwID)
    end
    pPlayer.SendAward({{"Item", self.RANDOM_GIFT_TID, 1, nEndTime}}, true, false, Env.LogWay_QingRenJie)
    Log("QingRenJie UseGift", pPlayer.dwID)
end

function tbAct:OnSendGift(pPlayer, pAcceptPlayer, nGiftType)
    if nGiftType ~= Gift.GiftType.Lover then
        return
    end

    local _, nEndTime = self:GetOpenTimeInfo()
    local tbAward = {{"Item", self.GIFT_TID, 1, nEndTime}}
    pPlayer.SendAward(tbAward, true, false, Env.LogWay_QingRenJie)
    if pAcceptPlayer.GetUserValue(self.GROUP, self.ACCEPT_DAY) ~= Lib:GetLocalDay() then
        pAcceptPlayer.SetUserValue(self.GROUP, self.ACCEPT_DAY, Lib:GetLocalDay())
        pAcceptPlayer.SetUserValue(self.GROUP, self.ACCEPT_TIMES, 0)
    end
    local nHadAcc = pAcceptPlayer.GetUserValue(self.GROUP, self.ACCEPT_TIMES)
    if nHadAcc < self.BE_SEND_GIFT then
        pAcceptPlayer.SetUserValue(self.GROUP, self.ACCEPT_TIMES, nHadAcc + 1)
        local tbAward = {{"Item", self.GIFT_TID_ACCEPT, 1, nEndTime}}
        pAcceptPlayer.SendAward(tbAward, true, false, Env.LogWay_QingRenJie)

        local nGiftTID = Gift:GetItemId(nGiftType, pAcceptPlayer.nSex)
        local szItemName = KItem.GetItemShowInfo(nGiftTID)
        local szMsg = string.format("    Ngày hội sắp tới, tình duyên chưa xa. Giá trị này ngày hội,[FFFE0D]「%s」[-]Đem chuẩn bị đã lâu[FFFE0D]「%s」[-]Cẩn thận giao đến trong tay của ngươi, ngươi tiếp nhận xem xét, phía dưới lại còn có giấu một cái nho nhỏ hộp quà, mau mở ra nhìn xem bên trong chứa cái gì đi!", pPlayer.szName, szItemName)
        local tbMail = {Title = "Chèo thuyền du ngoạn giang hồ tình nhân kết", Text = szMsg, nLogReazon = Env.LogWay_QingRenJie, To = pAcceptPlayer.dwID}
        Mail:SendSystemMail(tbMail)
        Log("QingRenJie OnBeSendGift", pAcceptPlayer.dwID, nHadAcc)
    end
    Log("QingRenJie OnSendGift", pPlayer.dwID, pAcceptPlayer.dwID)
end

function tbAct:CheckPlayerData(pPlayer)
    local nStartTime = self:GetOpenTimeInfo()
    local nVersion = pPlayer.GetUserValue(self.GROUP, self.VERSION)
    if nVersion ~= nStartTime then
        pPlayer.SetUserValue(self.GROUP, self.VERSION, nStartTime)
        for i = self.VERSION + 1, self.SIT_FLAG do
            pPlayer.SetUserValue(self.GROUP, i, 0)
        end
    end
end

function tbAct:CheckEnterSelfMap(pPlayer)
    self:CheckPlayerData(pPlayer)
    if not Env:CheckSystemSwitch(me, Env.SW_SwitchMap) then
        pPlayer.CenterMsg("Trước mắt trạng thái không cho phép hoán đổi địa đồ")
        return
    end
    return pPlayer.GetUserValue(self.GROUP, self.INVITE) > 0
end

function tbAct:CheckInvite(pPlayer, pLover)
    if pPlayer.nLevel < self.LEVEL then
        return false, "Đẳng cấp cần lớn hơn bằng 40 Cấp mới có thể tham dự"
    end

    if pPlayer.GetUserValue(self.GROUP, self.INVITE) > 0 then
        return false, "Mỗi cái hiệp sĩ chỉ có thể mời một lần"
    end

    if not pPlayer.dwTeamID or pPlayer.dwTeamID == 0 then
        return false, "Ngươi còn không có đội ngũ"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, "Nhất định phải tạo thành hai người đội ngũ"
    end

    if pPlayer.GetItemCountInAllPos(self.TICKET_TID) <= 0 then
        return false, "Không có vé tàu chèo thuyền du ngoạn giang hồ, mời trước thu hoạch vé tàu"
    end

    local dwLover = tbMember[1] == pPlayer.dwID and tbMember[2] or tbMember[1]
    if pLover then
        if pLover.dwID ~= dwLover then
            return false
        end
    else
        pLover = KPlayer.GetPlayerObjById(dwLover)
    end
    if not pLover then
        return false, "Không tìm được đồng đội"
    end

    if pPlayer.nSex == pLover.nSex or not FriendShip:IsFriend(pPlayer.dwID, dwLover) then
        return false, "Ngươi cùng đối phương cũng không phải là khác phái hảo hữu, xin xác nhận sau đang tiến hành nếm thử a"
    end

    if pLover.nLevel < self.LEVEL then
        return false, "Được mời hiệp sĩ cấp bậc chưa đủ"
    end

    self:CheckPlayerData(pLover)
    if pLover.GetUserValue(self.GROUP, self.BE_INVITE) > 0 then
        local szMsg = "Mỗi danh hiệp sĩ chỉ có thể tiếp nhận một lần mời"
        pLover.CenterMsg(szMsg)
        return false, szMsg, pLover
    end

    local nMapId1 = pPlayer.GetWorldPos()
    local nMapId2 = pLover.GetWorldPos()
    if nMapId1 ~= nMapId2 or pPlayer.GetNpc().GetDistance(pLover.GetNpc().nId) > Npc.DIALOG_DISTANCE * 3 then
        return false, "Có đội viên khoảng cách tiểu Tử khói quá xa, mời tới trước tiểu Tử khói bên người a", pLover
    end

    if FriendShip:GetFriendImityLevel(pPlayer.dwID, pLover.dwID) < self.NEED_IMITITY_LV then
        return false, string.format("Song phương độ thân mật đẳng cấp cần đạt tới %d Cấp", self.NEED_IMITITY_LV), pLover
    end

    for _, pNeedCheck in ipairs({pPlayer, pLover}) do
        if not Fuben.tbSafeMap[pNeedCheck.nMapTemplateId] and Map:GetClassDesc(pNeedCheck.nMapTemplateId) ~= "fight" and
            pNeedCheck.nMapTemplateId ~= self.PREPARE_MAPID and pNeedCheck.nMapTemplateId ~= self.OUTSIDE_MAPID then
            return false, string.format("「%s」Sở tại địa đồ không cho phép tiến vào phó bản!", pNeedCheck.szName), pLover
        end

        if Map:GetClassDesc(pNeedCheck.nMapTemplateId) == "fight" and pNeedCheck.nFightMode ~= 0 then
            return false, string.format("「%s」Không phải khu vực an toàn không cho phép tiến vào phó bản!", pNeedCheck.szName), pLover
        end
    end

    return true, nil, pLover
end

function tbAct:TryInteract()
    local pPlayer = me
    if self:CheckEnterSelfMap(pPlayer) then
        local nMapId = self.tbMapInfo[pPlayer.dwID]
        self:EnterMap(pPlayer.dwID, nMapId)
        return
    end

    local bRet, szMsg, pLover = self:CheckInvite(pPlayer)
    if not bRet then
        if szMsg then
            pPlayer.CenterMsg(szMsg)
            if pLover then
                pLover.CenterMsg(szMsg)
            end
        end
        return
    end

    pLover.CallClientScript("Activity.QingRenJie:OnGetInvite", pPlayer.dwID, pPlayer.szName)
end

function tbAct:AgreeInvite(pBeInvitePlayer, nInvitePlayer, bAgree)
    if not nInvitePlayer then
        return
    end

    local pPlayer = KPlayer.GetPlayerObjById(nInvitePlayer)
    if not pPlayer then
        pBeInvitePlayer.CenterMsg("Đối phương chưa online")
        return
    end

    if not bAgree then
        pPlayer.CenterMsg("Đối phương cự tuyệt lời mời của ngươi")
        return
    end

    local bRet, szMsg = self:CheckInvite(pPlayer)
    if not bRet then
        if szMsg then
            pPlayer.CenterMsg(szMsg)
            pBeInvitePlayer.CenterMsg(szMsg)
        end
        return
    end

    local nPlayer1 = pPlayer.dwID
    local nPlayer2 = pBeInvitePlayer.dwID
    local fnSuccessCallback = function (nMapId)
        local pPlayer = KPlayer.GetPlayerObjById(nPlayer1)
        local pLover = KPlayer.GetPlayerObjById(nPlayer2)
        if not pPlayer or not pLover then
            return
        end

        pPlayer.ConsumeItemInAllPos(self.TICKET_TID, 1, Env.LogWay_QingRenJie)
        pPlayer.SetUserValue(self.GROUP, self.INVITE, pLover.dwID)
        pLover.SetUserValue(self.GROUP, self.BE_INVITE, pPlayer.dwID)
        self:SwitchMap(pPlayer, nMapId, 0, 0, pPlayer.dwID)
        self:SwitchMap(pLover, nMapId, 0, 0, pPlayer.dwID)
        self.tbMapInfo[pPlayer.dwID] = nMapId
        local szMsg = string.format("%s Cùng %s Dắt tay cùng nhau leo lên lầu nhỏ nghe mưa phảng, chèo thuyền du ngoạn trên hồ, cùng nhau thưởng thức giang hồ cảnh đẹp! Thật sự là tiện sát người bên ngoài!", pPlayer.szName, pLover.szName)
        KPlayer.SendWorldNotify(1, 1000, szMsg, ChatMgr.ChannelType.Public, 1)
        Log("QingRenJie Invite Success", pPlayer.dwID, pLover.dwID)
    end

    local fnFailedCallback = function ()
        local pPlayer = KPlayer.GetPlayerObjById(nPlayer1)
        local pLover = KPlayer.GetPlayerObjById(nPlayer2)
        if not pPlayer or not pLover then
            return
        end
        pPlayer.CenterMsg("Tiến vào thất bại, mời thử lại")
        pLover.CenterMsg("Tiến vào thất bại, mời thử lại")
        Log("QingRenJie Invite CreateMap Fail", pPlayer.dwID, pLover.dwID)
    end

    Fuben:ApplyFuben(pPlayer.dwID, self.MAP_TID, fnSuccessCallback, fnFailedCallback)
end

function tbAct:TryEnterAlong()
    local pPlayer = me
    self:CheckPlayerData(pPlayer)
    local nInvitePlayer = pPlayer.GetUserValue(self.GROUP, self.BE_INVITE)
    if nInvitePlayer <= 0 then
        pPlayer.CenterMsg("Không bị mời")
        return
    end

    local nMapId = self.tbMapInfo[nInvitePlayer]
    self:EnterMap(pPlayer.dwID, nMapId, nInvitePlayer)
end

function tbAct:EnterMap(dwID, nMapId, nInvitePlayer)
    if not nMapId or not GetMapInfoById(nMapId) then
        local fnSuccessCallback = function (nMapId)
            local nPlayerID = nInvitePlayer or dwID
            self.tbMapInfo[nPlayerID] = nMapId
            local pPlayer = KPlayer.GetPlayerObjById(dwID)
            if not pPlayer then
                return
            end
            self:SwitchMap(pPlayer, nMapId, 0, 0, nInvitePlayer or dwID)
        end
    
        local fnFailedCallback = function ()
            local pPlayer = KPlayer.GetPlayerObjById(nPlayer1)
            if not pPlayer then
                return
            end
            pPlayer.CenterMsg("Tiến vào thất bại, mời thử lại")
        end
        Fuben:ApplyFuben(dwID, self.MAP_TID, fnSuccessCallback, fnFailedCallback)
    else
        local pPlayer = KPlayer.GetPlayerObjById(dwID)
        self:SwitchMap(pPlayer, nMapId, 0, 0, nInvitePlayer or dwID)
    end
end

function tbAct:SwitchMap(pPlayer, nMapId, nX, nY, nApplyID)
    if pPlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoChangeActionMode(pPlayer, Npc.NpcActionModeType.act_mode_none)
    end
    pPlayer.SetEntryPoint()
    pPlayer.SwitchMap(nMapId, nX or 0, nY or 0)
    pPlayer.CallClientScript("Activity.QingRenJie:OnSetApplyPlayer", nApplyID)
end

function tbAct:CheckCanDazuo(pPlayer)
    if pPlayer.GetUserValue(self.GROUP, self.SIT_FLAG) > 0 then
        return false, "Chỉ có thể làm một lần hỗ động"
    end

    if pPlayer.nMapTemplateId ~= self.MAP_TID then
        return false, "Trong đội ngũ có thành viên không tại lầu nhỏ nghe mưa phảng trong địa đồ"
    end

    if pPlayer.nQingRenDazuo then
        return false, "Đang tiến hành hỗ động"
    end

    if not pPlayer.dwTeamID or pPlayer.dwTeamID == 0 then
        return false, "Ngươi còn không có đội ngũ"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, "Nhất định phải cùng trong đội ngũ một tên khác khác phái hảo hữu ở vào bản địa đồ bên trong"
    end

    local dwLover = tbMember[1] == pPlayer.dwID and tbMember[2] or tbMember[1]
    local pLover = KPlayer.GetPlayerObjById(dwLover)
    if pLover.nMapTemplateId ~= self.MAP_TID then
        return false, "Trong đội ngũ có thành viên không tại lầu nhỏ nghe mưa phảng trong địa đồ"
    end
    
    if pLover.nMapId ~= pPlayer.nMapId then
        return false, "Đối phương không tại lầu nhỏ nghe mưa phảng trong địa đồ"
    end

    if pLover.nQingRenDazuo then
        return false, "Ngay tại thưởng thức cảnh đẹp"
    end
    return true, nil, pLover
end

function tbAct:TryDazuo(pPlayer)
    local bRet, szMsg, pLover = self:CheckCanDazuo(pPlayer)
    if not bRet then
        if szMsg then
            pPlayer.CenterMsg(szMsg)
        end
        return
    end

    pLover.CallClientScript("Activity.QingRenJie:OnGetDazuoInvite", pPlayer.dwID, pPlayer.szName)
end

function tbAct:AgreeInviteDazuo(pBeInvitePlayer, nInvitePlayer, bAgree)
    if not nInvitePlayer then
        return
    end

    local pPlayer = KPlayer.GetPlayerObjById(nInvitePlayer)
    if not pPlayer then
        pBeInvitePlayer.CenterMsg("Đối phương chưa online")
        return
    end

    if not bAgree then
        pPlayer.CenterMsg("Đối phương cự tuyệt lời mời của ngươi")
        return
    end

    local bRet, szMsg = self:CheckCanDazuo(pPlayer)
    if not bRet then
        if szMsg then
            pPlayer.CenterMsg(szMsg)
            pBeInvitePlayer.CenterMsg("Mời đã qua kỳ")
        end
        return
    end

    if ActionInteract:IsInteract(pPlayer) then
        ActionInteract:UnbindLinkInteract(pPlayer)
        pPlayer.CallClientScript("Ui:CloseWindow", "QYHLeavePanel")
    end
    if ActionInteract:IsInteract(pBeInvitePlayer) then
        ActionInteract:UnbindLinkInteract(pBeInvitePlayer)
        pBeInvitePlayer.CallClientScript("Ui:CloseWindow", "QYHLeavePanel")
    end

    Env:SetSystemSwitchOff(pPlayer, Env.SW_All)
    Env:SetSystemSwitchOff(pBeInvitePlayer, Env.SW_All)

    if pPlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoChangeActionMode(pPlayer, Npc.NpcActionModeType.act_mode_none)
    end
    if pBeInvitePlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoChangeActionMode(pBeInvitePlayer, Npc.NpcActionModeType.act_mode_none)
    end

    pPlayer.SetPosition(830,1135)
    pBeInvitePlayer.SetPosition(790,1110)
    pPlayer.GetNpc().CastSkill(1083, 1, self.tbPos[1][1], self.tbPos[1][2])
    pBeInvitePlayer.GetNpc().CastSkill(1083, 1, self.tbPos[2][1], self.tbPos[2][2])

    pPlayer.SetUserValue(self.GROUP, self.SIT_FLAG, 1)

    pPlayer.nQingRenDazuo = self.DAZUO_SEC
    pPlayer.CallClientScript("Activity.QingRenJie:OnBeginDazuo")
    ValueItem.ValueDecorate:SetValue(pPlayer, self.HEAD_BG, ChatMgr.ChatDecorate.Valid_Type.FOREVER)
    pPlayer.CenterMsg("Chúc mừng hiệp sĩ sử dụng vé tàu leo lên lầu nhỏ nghe mưa phảng, giải tỏa「Chèo thuyền du ngoạn giang hồ tình nhân kết」Ảnh chân dung khung!")
    pBeInvitePlayer.nQingRenDazuo = self.DAZUO_SEC
    pBeInvitePlayer.CallClientScript("Activity.QingRenJie:OnBeginDazuo")
    Timer:Register(Env.GAME_FPS, function ()
        return self:ContinueDazuo(pPlayer.dwID, pBeInvitePlayer.dwID)
    end)
end

function tbAct:ContinueDazuo(nPlayer, nLover)
    for _, nPlayerID in ipairs({nPlayer, nLover}) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerID)
        if pPlayer and pPlayer.nQingRenDazuo and pPlayer.nQingRenDazuo >= 1 then
            pPlayer.nQingRenDazuo = pPlayer.nQingRenDazuo - 1
            local bAddExp = pPlayer.nQingRenDazuo%(self.DAZUO_SEC/self.EXP_TIMES) == 0
            if bAddExp or pPlayer.nQingRenDazuo%12 == 0 then
                if bAddExp then
                    pPlayer.SendAward({{"BasicExp", self.BASIC_EXP/self.EXP_TIMES}}, false, false, Env.LogWay_QingRenJie)
                end
                pPlayer.CallClientScript("Activity.QingRenJie:ContinueDazuo", pPlayer.nQingRenDazuo)
            end
        else
            self:RestoreState(nPlayer, nLover)
            return
        end
    end
    return true
end

function tbAct:RestoreState(nPlayer, nLover)
    for _, nPlayerID in ipairs({nPlayer, nLover}) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerID)
        if pPlayer then
            Env:SetSystemSwitchOn(pPlayer, Env.SW_All)
            pPlayer.GetNpc().RestoreAction()
            pPlayer.nQingRenDazuo = nil
            pPlayer.CallClientScript("Activity.QingRenJie:OnDazuoEnd", nPlayer == nPlayerID)
        end
    end
    FriendShip:AddImitity(nPlayer, nLover, self.IMITITY, Env.LogWay_QingRenJie)
end

function tbAct:TryChooseTitle(pPlayer, nTitleId, nItemID)
    if nItemID then
        self:ChooseTitleByItem(pPlayer, nTitleId, nItemID)
        return
    end

    if pPlayer.GetUserValue(self.GROUP, self.SIT_FLAG) <= 0 then
        pPlayer.CenterMsg("Chưa thưởng thức cảnh đẹp, không cách nào tiến hành xưng hào lựa chọn")
        return
    end

    if pPlayer.GetUserValue(self.GROUP, self.TITLE_FLAG) > 0 then
        pPlayer.CenterMsg("Đã chọn xưng hào")
        return
    end

    local nInvite = pPlayer.GetUserValue(self.GROUP, self.INVITE)
    if nInvite <= 0 then
        pPlayer.CenterMsg("Chưa tiến vào ụ tàu")
        return
    end

    if not self.tbTitle[nTitleId] then
        pPlayer.CenterMsg("Không thể lựa chọn nên xưng hào")
        return
    end

    pPlayer.SetUserValue(self.GROUP, self.TITLE_FLAG, 1)
    self:SendTitleMail(pPlayer.dwID, nInvite, {{"AddTimeTitle", nTitleId, self.TITLE_ENDTIME}})
    pPlayer.CenterMsg("Chúc mừng hiệp sĩ thu hoạch được chèo thuyền du ngoạn giang hồ tình nhân kết hạn lúc xưng hào")
    local pLover = KPlayer.GetPlayerObjById(nInvite)
    if pLover then
        pLover.CenterMsg("Chúc mừng hiệp sĩ thu hoạch được chèo thuyền du ngoạn giang hồ tình nhân kết hạn lúc xưng hào")
    end
    Log("QingRenJie TryChooseTitle", pPlayer.dwID, nInvite)
end

function tbAct:ChooseTitleByItem(pPlayer, nTitleId, nItemID)
    if not self.tbTitle[nTitleId] then
        return
    end

    local pItem = KItem.GetItemObj(nItemID)
    if not pItem then
        return
    end

    if Item:Consume(pItem, 1) < 1 then
        pPlayer.CenterMsg("Đạo cụ tiêu hao thất bại, mời thử lại")
        return
    end

    local tbAward = {{"AddTimeTitle", nTitleId, self.TITLE_ENDTIME}}
    pPlayer.SendAward(tbAward, true, true, Env.LogWay_QingRenJie)
end

function tbAct:OnLeaveMap(pPlayer, nMapTID)
    self:SendTitleItem(pPlayer, nMapTID)
end

function tbAct:OnLogout(pPlayer)
    self:SendTitleItem(pPlayer, pPlayer.nMapTemplateId)
end

function tbAct:SendTitleItem(pPlayer, nMapTID)
    if nMapTID ~= self.MAP_TID then
        return
    end

    pPlayer.CallClientScript("Ui:CloseWindow", "QingRenJieInvitePanel")
    if pPlayer.GetUserValue(self.GROUP, self.SIT_FLAG) <= 0 then
        return
    end
    if pPlayer.GetUserValue(self.GROUP, self.TITLE_FLAG) > 0 then
        return
    end

    pPlayer.SetUserValue(self.GROUP, self.TITLE_FLAG, 1)
    local nLover = pPlayer.GetUserValue(self.GROUP, self.INVITE)
    local tbAward = {{"Item", self.CHOOSE_TITLE_ID, 1, self.TITLE_ENDTIME}}
    self:SendTitleMail(pPlayer.dwID, nLover, tbAward)
    Log("QingRenJie SendTitleItem", pPlayer.dwID, nLover)
end

function tbAct:SendTitleMail(dwID1, dwID2, tbAward)
    local tbMail = {Title = "Chèo thuyền du ngoạn giang hồ tình nhân kết", From = "Tiểu Tử Yên", nLogReazon = Env.LogWay_QingRenJie}
    tbMail.tbAttach = tbAward
    tbMail.Text = "    Chúc mừng hiệp sĩ sử dụng vé tàu leo lên lầu nhỏ nghe mưa phảng, thu hoạch được「Chèo thuyền du ngoạn giang hồ tình nhân kết」Hạn lúc xưng hào! Chúc hai vị tình ý trường tồn!"
    for _, nPlayerID in ipairs({dwID1, dwID2}) do
        tbMail.To = nPlayerID
        Mail:SendSystemMail(tbMail)
    end
end