
local tbActivity = Activity:GetClass("DrinkHouseNpcAct");

tbActivity.tbActSetting = {
    nNpcTID = 3315; --摆放的npcid class可不填
    tbPos = { 5167, 17699 ,48}; --坐标
    tbAward = { {"item", 224, 1 } }; --见面礼奖励
}

tbActivity.tbTrigger = 
{
	Init = 
	{
	},
    Start = 
    {
    },
    End = 
    {
    },
}

function tbActivity:OnTrigger(szTrigger)
    if szTrigger == "Init" then

    elseif szTrigger == "Start" then
        local _, nEndTime = self:GetOpenTimeInfo()
        self:RegisterDataInPlayer(nEndTime)

        local tbActSetting = self.tbActSetting
        Activity:RegisterNpcCreate(self, {nNpcTemplateId = tbActSetting.nNpcTID, nMapTemplateId = DrinkHouse.tbDef.NORMAL_MAP, nPosX = tbActSetting.tbPos[1], nPosY = tbActSetting.tbPos[2], nDir = tbActSetting.tbPos[3]})        
        Activity:RegisterNpcDialog(self, tbActSetting.nNpcTID,  {Text = "江湖盛典", Callback = self.OnNpcDialogViewUrl, Param = {self}})
        Activity:RegisterNpcDialog(self, tbActSetting.nNpcTID,  {Text = "見面禮", Callback = self.OnNpcDialogTakeAward, Param = {self}})
    end
end

function tbActivity:OnNpcDialogViewUrl(  )
    me.CallClientScript("Pandora:OpenDrinkHouseWolrdSquare")
end

function tbActivity:OnNpcDialogTakeAward()
    local bFlag = self:GetDataFromPlayer(me.dwID)
    if bFlag then
        me.CenterMsg("你已經領取過見面禮了！")
        return
    end
    self:SaveDataToPlayer(me, true)
    me.SendAward( self.tbActSetting.tbAward , nil, nil, Env.LogWay_JiangHuShengDian)
end