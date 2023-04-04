local tbNpc   = Npc:GetClass("WhiteTiger")

local tbIndex = {"1", "2", "3", "4", "5", "6", "7", "8"}
function tbNpc:OnDialog()
    local nRoomId  = tonumber(him.szScriptParam)
    local szIdx    = tbIndex[nRoomId]
    local szDialog = "Đây là lối vào Bạch Hổ Đường tầng " .. szIdx .. ",đồng ý vào?"
    Dialog:Show(
    {
        Text = szDialog,
        OptList = {
            { Text = "Vào-Lối Vào " .. szIdx, Callback = self.EnterFuben, Param = {self, me.dwID, nRoomId} }
        },
    }, me, him)
end

function tbNpc:EnterFuben(dwID, nRoomId)
    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
        return
    end

    Fuben.WhiteTigerFuben:TryEnterOutSideFuben(pPlayer, nRoomId)
end