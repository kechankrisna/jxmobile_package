local tbAct = Activity:GetClass("SpecialDealerAct")

tbAct.tbTimerTrigger = {}

tbAct.tbTrigger = {
	Init = {},
	Start = {},
	End = {},
}

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then
		self:OnInit()
	elseif szTrigger == "Start" then
		self:OnStart()
	elseif szTrigger == "End" then
		self:OnEnd()
	end
end

function tbAct:OnInit()
	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	local nTime = Lib:GetTodayZeroHour(nStartTime) + 19 * 3600 + 5 * 60
	local nDay = 0
	while nTime < nEndTime do
		nDay = nDay + 1
		nTime = nTime + 24 * 3600
	end
	Kin.Auction:AddDealerExtraOpenDay(nDay)
	Log("SpecialDealer Act Init ", nDay)
end

function tbAct:OnStart()
	local szDealerActFilePath = self.tbParam[1]
	local tbSetting = Kin.Auction:LoadDealerItemsSetting(szDealerActFilePath)

	Kin.Auction:SetSpecialDealerActSetting(tbSetting)
	Log("SpecialDealer Act Start")
end

function tbAct:OnEnd()
	Kin.Auction:SetSpecialDealerActSetting(nil)
	Log("SpecialDealer Act End")
end