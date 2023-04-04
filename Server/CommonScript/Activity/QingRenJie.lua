if not MODULE_GAMESERVER then
    Activity.QingRenJie = Activity.QingRenJie or {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("QingRenJie") or Activity.QingRenJie
tbAct.DAZUO_SEC = 60         --交互时间
tbAct.EXP_TIMES = 10         --加经验的次数   
tbAct.MAP_TID = 1600         --船的地图ID

if MODULE_GAMESERVER then
    return
end

function tbAct:OnGetInvite(nInviteId, szName)
    local fnAgree = function ()
        if not TeamMgr:HasTeam() then
            me.CenterMsg("Không có đội")
            return
        end

        local tbMember = TeamMgr:GetTeamMember()
        if #tbMember ~= 1 then
            me.CenterMsg("Chỉ có thể 2 người tổ đội")
            return
        end

        if tbMember[1].nPlayerID ~= nInviteId then
            me.CenterMsg("Lời mời đã quá hạn")
            return
        end
        RemoteServer.QingRenJieRespon("Act_QingRenJie_AgreeInvite", nInviteId, true)
    end

    local fnDisagree = function ()
        RemoteServer.QingRenJieRespon("Act_QingRenJie_AgreeInvite", nInviteId)
    end

    local fnClose = function ()
        Ui:CloseWindow("MessageBox")
    end

    local szMsg = string.format("%s mời đại hiệp cùng lên Thuyền Vũ Lâu, đồng ý không?\n(%%d giây sau tự động đóng)", szName)
    me.MsgBox(szMsg, {{"Đồng ý", fnAgree}, {"Từ chối", fnDisagree}}, nil, 20, fnClose)
end

function tbAct:OnGetDazuoInvite(nInviteId, szName)
    local fnAgree = function ()
        if not TeamMgr:HasTeam() then
            me.CenterMsg("Hiện không có Đội")
            return
        end

        local tbMember = TeamMgr:GetTeamMember()
        if #tbMember ~= 1 then
            me.CenterMsg("Trong đội chỉ được có 2 người")
            return
        end

        if tbMember[1].nPlayerID ~= nInviteId then
            me.CenterMsg("Lời mời đã quá hạn")
            return
        end

        RemoteServer.QingRenJieRespon("Act_QingRenJie_AgreeInviteDazuo", nInviteId, true)
    end

    local fnDisagree = function ()
        RemoteServer.QingRenJieRespon("Act_QingRenJie_AgreeInviteDazuo", nInviteId)
    end

    local fnClose = function ()
        Ui:CloseWindow("MessageBox")
    end

    local szMsg = string.format("%s mời đại hiệp cùng ngắm pháo hoa, đồng ý đến bên cạnh người ấy không?\n(%%d giây sau tự đóng)", szName)
    me.MsgBox(szMsg, {{"Đồng ý", fnAgree}, {"Từ chối", fnDisagree}}, nil, 20, fnClose)
end

function tbAct:OnBeginDazuo()
    Ui:OpenWindow("ChuangGongPanel", nil, nil, nil, nil, nil, true)
    Ui:OpenWindow("QingRenJieDazuoPanel")
    Ui:CloseWindow("QingRenJieInvitePanel")
    UiNotify.OnNotify(UiNotify.emNOTIFY_CHUAN_GONG_SEND_ONE, 0)
end

function tbAct:ContinueDazuo(nLastTime)
    if nLastTime%(self.DAZUO_SEC/self.EXP_TIMES) == 0 then
        local nPercent = (self.DAZUO_SEC-nLastTime)/self.DAZUO_SEC
        UiNotify.OnNotify(UiNotify.emNOTIFY_CHUAN_GONG_SEND_ONE, nPercent)
    end

    if nLastTime%12 == 0 then
        UiNotify.OnNotify(UiNotify.emNOTIFY_QINGRENJIE_TEXIAO)
    end
end

function tbAct:OnDazuoEnd(bOpenInvitePanel)
    Ui:CloseWindow("ChuangGongPanel")
    Ui:CloseWindow("QingRenJieDazuoPanel")
    Ui:OpenWindow("QingRenJieInvitePanel")
    if bOpenInvitePanel then
        Ui:OpenWindow("QingRenJieTitlePanel")
    end
end

function tbAct:OnSetApplyPlayer(nApplyPlayer)
    self.nApplyPlayer = nApplyPlayer
end