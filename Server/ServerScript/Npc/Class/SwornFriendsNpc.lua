local tbNpc1 = Npc:GetClass("SwornFriendsNpc1")

function tbNpc1:OnDialog(szParam)
    Dialog:Show({
        Text = "Muốn xử lý kết bái quan hệ đều có thể đến đây tìm ta!",
        OptList = {
            { Text = "Chúng ta muốn kết bái", Callback = self.Connect, Param = {self} },
            { Text = "Đoạn tuyệt", Callback = self.Disconnect, Param = {self} },
            { Text = "Sửa đổi danh hiệu", Callback = self.ChangeTitle, Param = {self} },
        },
    }, me, him)
end

function tbNpc1:Connect()
    local bValid, szErr = SwornFriends:CheckBeforeConnect(me)
    if not bValid then
        me.CenterMsg(szErr)
        return
    end

    local tbPlayer = KNpc.GetAroundPlayerList(him.nId, SwornFriends.Def.nConnectDistance) or {}
    local tbAroundPids = {}
    for _,pPlayer in pairs(tbPlayer) do
        tbAroundPids[pPlayer.dwID] = true
    end

    local tbMembers = TeamMgr:GetMembers(me.dwTeamID)
    for _, nId in ipairs(tbMembers) do
        if not tbAroundPids[nId] then
            Dialog:Show({
                Text = "Hay là chờ đồng đội đều đến sau lại tới tìm ta kết bái đi.",
                OptList = {
                    { Text = "Ta biết rồi" }
                },
            }, me, him)
            return
        end
    end

    me.CallClientScript("Ui:OpenWindow", "SwornFriendsTitlePanel")
end

function tbNpc1:Disconnect()
    local bOk, szErr = SwornFriends:CheckBeforeDisconnect(me)
    if not bOk then
        me.CenterMsg(szErr)
        return
    end

    me.CallClientScript("SwornFriends:DisconnectDlg")
end

function tbNpc1:ChangeTitle()
    local bOk, szErr = SwornFriends:CheckBeforeChangePersonalTitle(me)
    if not bOk then
        me.CenterMsg(szErr)
        return
    end

    me.CallClientScript("Ui:OpenWindow", "SwornFriendsPersonalTitlePanel")
end


--------------------------------------------------------------------------
local tbNpc2 = Npc:GetClass("SwornFriendsNpc2")

function tbNpc2:OnDialog(szParam)
    Dialog:Show({
        Text = "Muốn xử lý kết bái quan hệ đều có thể đến đây tìm ta!",
        OptList = {
            { Text = "Rời đi", Callback = self.Quit, Param = {self} },
        },
    }, me, him)
end

function tbNpc2:Quit()
    me.GotoEntryPoint()
end
