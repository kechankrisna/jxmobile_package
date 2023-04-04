local tbAct = Activity:GetClass("PartnerCardPickAct");

tbAct.tbTimerTrigger = { }
tbAct.tbTrigger = { Init = { }, Start = { }, End = { }, }

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Start" then
		Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnPlayerLogin")
		Activity:RegisterPlayerEvent(self, "Act_SynPartnerCardPickData", "SynPickData")
		Activity:RegisterPlayerEvent(self, "Act_AddGoldTenPickTimes", "AddGoldTenPickTimes")
		self:OnStart();
	elseif szTrigger == "End" then
		self:OnEnd();
	end
end

function tbAct:OnStart()
	local _, nEndTime = self:GetOpenTimeInfo()
    -- 注册申请存库数据块,活动结束自动清掉
    self:RegisterDataInPlayer(nEndTime)
	CardPicker:RegisterPartnerCardPickAct(self.GetGoldTenPickTimes, self)

	local tbPlayer = KPlayer.GetAllPlayer()
    for _, pPlayer in pairs(tbPlayer) do
        self:SynPickData(pPlayer)
    end
end

function tbAct:OnEnd()
	CardPicker:RegisterPartnerCardPickAct()
end

function tbAct:OnPlayerLogin()
	self:SynPickData(me)
end

function tbAct:SynPickData(pPlayer)
	local nPickCount = self:GetGoldTenPickTimes(pPlayer)
	pPlayer.CallClientScript("PartnerCard:OnSynPickData", nPickCount)
end

function tbAct:GetGoldTenPickTimes(pPlayer)
	local tbData = self:GetDataFromPlayer(pPlayer.dwID) or {}
	tbData.nGoldTenPickUpdateTime = tbData.nGoldTenPickUpdateTime or 0
	tbData.nGoldTenPickCount = tbData.nGoldTenPickCount or 0
	local nNowTime = GetTime()
	if  Lib:IsDiffDay(4*60*60, tbData.nGoldTenPickUpdateTime) then
		tbData.nGoldTenPickUpdateTime = nNowTime
		tbData.nGoldTenPickCount = 0
		self:SaveDataToPlayer(pPlayer, tbData)
	end
	return tbData.nGoldTenPickCount
end

function tbAct:AddGoldTenPickTimes(pPlayer, nCount)
	nCount = nCount or 1
	local tbData = self:GetDataFromPlayer(pPlayer.dwID) or {}
	tbData.nGoldTenPickCount = (tbData.nGoldTenPickCount or 0) + nCount
	self:SaveDataToPlayer(pPlayer, tbData)
	self:SynPickData(pPlayer)
	Log("PartnerCardPickAct fnSetGoldTenPickTimes ok", pPlayer.dwID, pPlayer.szName, nCount, tbData.nGoldTenPickUpdateTime)
end
