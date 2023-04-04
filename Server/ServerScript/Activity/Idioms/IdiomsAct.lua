local tbAct = Activity:GetClass("IdiomsAct")
tbAct.tbTimerTrigger = 
{ 
   
}
tbAct.tbTrigger  = {Init = {}, Start = {}, End = {}}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
    	IdiomFuben:LoadSetting()
        Activity:RegisterNpcDialog(self, 99,  {Text = "Thành ngữ tiếp long", Callback = self.OnNpcDialog, Param = {self}})
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnPlayerLogin")
        self:SynSwitch() 
    elseif szTrigger == "End" then
        self:SynSwitch(true) 
    end
    Log("IdiomsAct OnTrigger:", szTrigger)
end

function tbAct:OnNpcDialog()
    local fnJoin = function(nPlayerId)
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId or 0)
        if not pPlayer then
            return
        end
        IdiomFuben:TryCreateFuben(pPlayer)
    end
    me.MsgBox("Các ngươi nhất định phải tham gia Thành ngữ chơi domino Hoạt động sao?",
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
        pPlayer.CallClientScript("IdiomFuben:SynSwitch",nEndTime)
    end
end

function tbAct:OnPlayerLogin()
    local nStartTime, nEndTime = self:GetOpenTimeInfo()
    me.CallClientScript("IdiomFuben:SynSwitch", nEndTime)
end


