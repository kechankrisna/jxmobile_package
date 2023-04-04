
local tbAct = Activity:GetClass("VipAwardBoxExchange");

tbAct.tbTimerTrigger =
{
}
tbAct.tbTrigger = {
	Init 	= { },
	Start 	= { },
	End 	= { },
}

tbAct.tbVipLevelCount  = {
	[14] = 4;
	[15] = 6;
	[16] = 6;
}

tbAct.SAVE_GROUP = 102
tbAct.SAVE_KEY_Count = 2;

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Start" then
		if not self.nRegisterLogin then
			self.nRegisterLogin = PlayerEvent:RegisterGlobal("OnLogin",  self.OnLogin, self);
		end

		Activity:RegisterNpcDialog(self, 97,  {Text = "Bug Đền bù", Callback = self.OnNpcDialog, Param = {self}})

	elseif szTrigger == "End" then
		if self.nRegisterLogin then
			PlayerEvent:UnRegisterGlobal("OnLogin", self.nRegisterLogin)
			self.nRegisterLogin = nil;
		end
	end
end

function tbAct:OnNpcDialog()
	local nHasCout = me.GetUserValue(self.SAVE_GROUP, self.SAVE_KEY_Count)
	if nHasCout <= 0 then
		me.CenterMsg("Trước mắt không có bug Đền bù")
		return
	end

	Dialog:Show(
	{
	    Text    = string.format("Ngươi bây giờ còn có %d Lần hối đoái 4 Cấp Hồn thạch tùy ý tuyển rương cơ hội. Nhưng sử dụng 4 Cấp sơ cấp Hồn thạch hối đoái", nHasCout) ,
	    OptList = {
	        { Text = "Hối đoái 4 Cấp Hồn thạch tùy ý tuyển rương", Callback = self.AskExchangeItem, Param = {self} },
	    },
	}, me, him)
end

function tbAct:CanChange(pPlayer, nUseCount)
	local nHasCout = pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_KEY_Count)
	if nHasCout <= 0 then
		pPlayer.CenterMsg("Trước mắt không có hối đoái số lần")
		return
	end

	if nUseCount then
		if nUseCount > nHasCout then
			pPlayer.CenterMsg(string.format("Hối đoái số lần không đủ %d Lần", nUseCount))
			return
		end
	end

	return true
end

function tbAct:AskExchangeItem()
	if not self:CanChange(me) then
		return
	end
	Exchange:AskItem(me, "VipAwardBoxExchange", self.ExchangeItem, self)
end

function tbAct:ExchangeItem(tbItems)
	for dwTemplateId, nCount in pairs(tbItems) do
		if me.GetItemCountInAllPos(dwTemplateId) < nCount then
			return
		end
	end

	local tbSetting = Exchange.tbExchangeSetting["VipAwardBoxExchange"];
	local tbExchangeIndex =  Exchange:DefaultCheck(tbItems, tbSetting)
	if not tbExchangeIndex then
		return
	end

	local nHasCout = me.GetUserValue(self.SAVE_GROUP, self.SAVE_KEY_Count)
	if not self:CanChange(me, #tbExchangeIndex) then
		return
	end


	local tbAllExchange = tbSetting.tbAllExchange
	local tbGetItems = {}
	for i,nIdex in ipairs(tbExchangeIndex) do
		local tbSet = tbAllExchange[nIdex]
		for nItemId,nCount in pairs(tbSet.tbAllItem) do
			if  me.ConsumeItemInAllPos(nItemId, nCount, Env.LogWay_VipAwardBoxExchange) ~= nCount then
				Log(debug.traceback(), me.dwID)
				return
			end
		end
		Lib:MergeTable(tbGetItems, tbSet.tbAllAward)
	end

	me.SetUserValue(self.SAVE_GROUP, self.SAVE_KEY_Count, nHasCout - #tbExchangeIndex)
	me.SendAward(tbGetItems, nil,nil, Env.LogWay_VipAwardBoxExchange)

	me.CenterMsg("兑换成功")
end

function tbAct:OnLogin()
	if me.GetUserValue(self.SAVE_GROUP, self.SAVE_KEY_Count) > 0 then
		return
	end

	local nVipLevel = me.GetVipLevel()
	if nVipLevel < 14 then
		return;
	end

	local nBuyedVal = me.GetUserValue(Recharge.SAVE_GROUP, Recharge.KEY_VIP_AWARD)
	local nCount = 0
	local _, nEndTime = self:GetOpenTimeInfo()
	for nNeedVipLevel, nSaveKey in pairs(Recharge.tbVipAwardTakeTimeKey) do
		local nBuydeBit = KLib.GetBit(nBuyedVal, nNeedVipLevel + 1)
		if nBuydeBit == 1 and me.GetUserValue(Recharge.SAVE_GROUP, nSaveKey) == 0 then
			nCount = nCount + self.tbVipLevelCount[nNeedVipLevel]
			me.SetUserValue(Recharge.SAVE_GROUP, nSaveKey, nEndTime)
		end
	end
	if nCount > 0 then
		me.SetUserValue(self.SAVE_GROUP, self.SAVE_KEY_Count, nCount)
		Log("VipAwardBoxExchange AddCount ", me.dwID, nCount, me.GetVipLevel())
		Mail:SendSystemMail({
			To = me.dwID;
			Title = "Kiếm hiệp V Gói quà đền bù";
			Text = string.format("Tôn kính người chơi, bởi vì nguyên VIP Gói quà bên trong 4 Cấp ngẫu nhiên Hồn thạch, điều chỉnh làm 4 Cấp Hồn thạch tùy ý tuyển rương. Vì đền bù ngài tổn thất, hiện cung cấp hối đoái công năng, có thể sử dụng tùy ý một cái 4 Cấp sơ cấp Hồn thạch, hối đoái một cái 4 Cấp Hồn thạch tùy ý tuyển rương.\n Căn cứ trước ngươi VIP Gói quà thu hoạch được tình huống, ngươi có %d Lần hối đoái cơ hội \n Mời tiến về Tương Dương thành [00ff00][url=npc:NPC Nguyệt mi mà, 97, 10][-] Chỗ hối đoái", nCount);
		 })

	end
end