local tbNpc   = Npc:GetClass("ArenaNpc")

local nLimitLevel = 10
function tbNpc:OnDialog(szParam)
    if me.nLevel < nLimitLevel then
         Dialog:Show(
        {
            Text = string.format("Kinh nghiệm của thiếu hiệp còn thấp. Cấp %d mới có thể lên võ đài!",nLimitLevel),
            OptList = {
                { Text = "Ta biết rồi"}
            },
        }, me, him)
        return
    end
    if him.szScriptParam == "ArenaEnterNpc" then
        -- 擂场入口Npc
         Dialog:Show(
        {
            Text = "A Di Đà Phật, thí chủ đi lại nhẹ nhàng, chắc hẳn thân thủ bất phàm......",
            OptList = {
                { Text = "Vào võ đài", Callback = self.EnterArena, Param = {self, me.dwID} }
            },
        }, me, him)
    elseif him.szScriptParam == "ArenaManagerNpc" then
        -- 擂台报名Npc
        Dialog:Show(
        {
            Text = "A Di Đà Phật, thí chủ đi lại nhẹ nhàng, chắc hẳn thân thủ bất phàm, sao không lên lôi đài mở ra oai hùng?",
            OptList = {
                { Text = "Ta muốn lên lôi đài", Callback = self.SignInArena, Param = {self, me.dwID} }
            },
        }, me, him)
    else
        Log("[ArenaBattle] can not find npc",him.szScriptParam)
    end
end

function tbNpc:EnterArena(dwID)
    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
        return
    end
    pPlayer.SetEntryPoint()
    pPlayer.SwitchMap(ArenaBattle.nArenaMapId,unpack(ArenaBattle.defaultEnterMapPos))
end

function tbNpc:SignInArena(dwID)
    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
        return
    end
    pPlayer.CallClientScript("Ui:OpenWindow","ArenaPanel")
end

