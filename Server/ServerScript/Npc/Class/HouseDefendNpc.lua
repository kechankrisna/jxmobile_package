local tbNpc = Npc:GetClass("HouseDefendNpc");

function tbNpc:OnDialog()
    local szDialog = "Ai, nói ra có chút xấu hổ, chúng ta bị người hạ độc, võ công tạm mất, chỗ ở chi địa bây giờ làm người chiếm lấy, mong rằng hiệp sĩ làm viện thủ";
    local tbOpt = {};
    local dwOwnerId = House:GetHouseInfoByMapId(him.nMapId);
    if not dwOwnerId then
        Dialog:Show(
        {
            Text = szDialog,
            OptList = tbOpt,
        }, me, him)
        return;
    end

    if dwOwnerId == me.dwID then
        table.insert(tbOpt, { Text = "Mở ra mới lạ tiểu trúc đoạt lại chiến", Callback = function ()
            Activity:OnPlayerEvent(me, "Act_HouseDefend_OpenFuben");
        end, Param = {} });
    end

    table.insert(tbOpt, { Text = "Tiến về mới lạ tiểu trúc đoạt lại chiến", Callback = function ()
        Activity:OnPlayerEvent(me, "Act_HouseDefend_EnterFuben", dwOwnerId);
    end, Param = {} });

    Dialog:Show(
    {
        Text = szDialog,
        OptList = tbOpt,
    }, me, him)
end