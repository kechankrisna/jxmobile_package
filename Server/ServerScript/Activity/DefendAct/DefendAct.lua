local tbAct = Activity:GetClass("DefendAct")
tbAct.tbTimerTrigger = 
{ 
   
}
tbAct.tbTrigger  = {Init = {}, Start = {}, End = {}}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        Activity:RegisterNpcDialog(self, 99,  {Text = "Ngày mồng một tháng năm giang hồ triển thân thủ", Callback = self.OnNpcDialog, Param = {self}})
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnPlayerLogin")
        self:SynSwitch()
    elseif szTrigger == "End" then
        self:SynSwitch(true) 
    end
    Log("DefendAct OnTrigger:", szTrigger)
end

function tbAct:OnNpcDialog()
    local fnJoin = function(nPlayerId)
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId or 0)
        if not pPlayer then
            return
        end
        DefendFuben:TryCreateFuben(pPlayer)
    end
    me.MsgBox("Các ngươi nhất định phải tham gia Ngày mồng một tháng năm giang hồ triển thân thủ Hoạt động sao?\n(Mỗi ngày có lại chỉ có một lần tham dự cơ hội, một khi tiến vào liền đem tiêu hao số lần)",
                {
                    {"Xác nhận tham gia", fnJoin, me.dwID},
                    {"Hủy bỏ"},
                })
end

-- 同步活动开关
function tbAct:SynSwitch(bClose) 
    local nStartTime, nEndTime
    if not bClose then
        nStartTime, nEndTime = self:GetOpenTimeInfo()
    end
    local tbPlayer = KPlayer.GetAllPlayer()
    for _, pPlayer in pairs(tbPlayer) do
        pPlayer.CallClientScript("DefendFuben:SynSwitch", nEndTime)
    end
end

function tbAct:OnPlayerLogin()
    local nStartTime, nEndTime = self:GetOpenTimeInfo()
    me.CallClientScript("DefendFuben:SynSwitch", nEndTime)
end
