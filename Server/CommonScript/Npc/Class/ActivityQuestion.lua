local tbNpc = Npc:GetClass("ActivityQuestion");

function tbNpc:OnDialog()
    if ActivityQuestion:CheckSubmitTask() then
        Dialog:Show(
        {
            Text    = "Đã thăm hỏi hết các đại hiệp khác hôm nay chưa? Chuyện giang hồ đã hiểu nhiều hơn rồi chứ?",
            OptList = {
                { Text = "Trả lời xong", Callback = function ()
                    ActivityQuestion:TrySubmitTask()
                end},
            },
        }, me, him)
    else
        Npc:ShowDefaultDialog()
    end
end