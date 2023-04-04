local tbNpc = Npc:GetClass("SpokesmanTask")

function tbNpc:OnDialog()
    Dialog:Show(
    {
        Text    = "Tịch mịch song sát võ công cao cường, thiếu hiệp nhưng kết bạn tiến về đuổi bắt. Bản nhân chung thân hạnh phúc nắm với thiếu hiệp, trông mong thiếu hiệp bình an mang lại duyên bánh ngọt trở về.",
        OptList = {
            { Text = "Giúp đỡ anh em", Callback = self.TryAcceptTask, Param = {self, me.dwID, him.nId} },
        },
    }, me, him)
end

function tbNpc:TryAcceptTask(dwID, nNpcId)
    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
        return
    end

    Spokesman:TryAcceptTask(pPlayer, nNpcId)
end