local tbActivity = Activity:GetClass("ExchangeTicketAct")
tbActivity.tbTrigger = 
{
	Init = {}, Start = {}, End = {},
}

tbActivity.tbSourceItem = {8396, 8397, 8398}

tbActivity.tbExchangeInfo = {
	{5, 8501},
	{10, 8503},
	{15, 8502},
	{20, 8504},
}

function tbActivity:OnTrigger(szTrigger)
    if szTrigger == "Start" then
		local _, nEndTime = self:GetOpenTimeInfo()
		self:RegisterDataInPlayer(nEndTime)
		Activity:RegisterGlobalEvent(self, "Act_ExchangeTicketAct", "DoExchange")
    	Activity:RegisterNpcDialog(self, 190, {Text = "兌換禮包", Callback = self.TryExchange, Param = {self}})
    end
end

function tbActivity:GetCount(pPlayer)
	local nCount = 0
	local tbCount = {}
	for nI, nItemTId in pairs(self.tbSourceItem) do
		local nThisCount = pPlayer.GetItemCountInBags(nItemTId)
		tbCount[nI] = nThisCount
		nCount = nCount + nThisCount
	end
	return nCount, tbCount
end

function tbActivity:GetExchangInfo(nCount)
	local nExchangeId, nNeedCount
	for _, tbInfo in ipairs(self.tbExchangeInfo) do
		if nCount < tbInfo[1] then
			break
		end
		nNeedCount = tbInfo[1]
		nExchangeId = tbInfo[2]
	end
	return nExchangeId, nNeedCount
end

function tbActivity:TryExchange()
	local bFlag = self:GetDataFromPlayer(me.dwID)
	if bFlag then
		me.CenterMsg("你已經兌換過禮包了！")
		return
	end

	local nCount = self:GetCount(me)
	local nExchangeId, nNeedCount = self:GetExchangInfo(nCount)
	if not nExchangeId then
		me.CenterMsg("破損的票券數量太少了，去尋求好友幫助再來吧！")
		return
	end
	local szItemName = KItem.GetItemShowInfo(nExchangeId, me.nFaction, me.nSex)
	local szMsg = string.format("你現在擁有破損的票券%d個，可以消耗%d個兌換%s禮包，剩餘%d個，兌換完成之後將不能再兌換別的禮包，確定要兌換嗎？",
		nCount, nNeedCount, szItemName or "", nCount - nNeedCount)
	me.MsgBox(szMsg,
	{
		{"決定了", function (nPlayerId)
			Activity:OnGlobalEvent("Act_ExchangeTicketAct", nPlayerId)
		end, me.dwID},
		{"再想想"},
	}
	);
end

function tbActivity:DoExchange(nPlayerId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end

	local bFlag = self:GetDataFromPlayer(nPlayerId)
	if bFlag then
		pPlayer.CenterMsg("你已經兌換過禮包了！")
		return
	end

	local nCount, tbCount = self:GetCount(pPlayer)
	if nCount <= 0 then
		pPlayer.CenterMsg("破損的票券數量太少了，去尋求好友幫助再來吧！")
		return
	end
	local nExchangeId, nNeedCount = self:GetExchangInfo(nCount)
	if not nNeedCount or not nExchangeId then
		pPlayer.CenterMsg("破損的票券數量太少了，去尋求好友幫助再來吧！")
		return
	end

	for nI, nItemTId in pairs(self.tbSourceItem) do
		local nThisCount = tbCount[nI]
		if nThisCount > 0 and nNeedCount > 0 then
			local nConsumeCount = math.min(nThisCount, nNeedCount)
			local nRet = pPlayer.ConsumeItemInBag(nItemTId, nConsumeCount, Env.LogWay_ExchangeTicketAct)
			if not nRet or nRet ~= nConsumeCount then
				Log("ExchangeTicketAct ConsumeItemInBag Err:", nPlayerId, nItemTId, nConsumeCount)
				return
			end
			nNeedCount = nNeedCount - nConsumeCount
			if nNeedCount <= 0 then
				break
			end
		end
	end
	if nNeedCount > 0 then
		Log("ExchangeTicketAct ConsumeItemInBag Count Err:", nPlayerId, nNeedCount)
		return
	end
	self:SaveDataToPlayer(pPlayer, true)
	pPlayer.SendAward({{"Item", nExchangeId, 1}}, false, true, Env.LogWay_ExchangeTicketAct)
end