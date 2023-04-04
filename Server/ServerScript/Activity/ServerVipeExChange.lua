
local tbAct = Activity:GetClass("ServerVipeExChange");

tbAct.tbTimerTrigger =
{
}
tbAct.tbTrigger = {
	Init 	= { },
	Start 	= { },
	End 	= { },
}

tbAct.SAVE_GROUP = 102
tbAct.SAVE_KEY_ServerSend = 1; --ServerSend 的 key


function tbAct:OnTrigger(szTrigger)

	if szTrigger == "Start" then
		self:LoadSetting();
		-- Activity:RegisterNpcDialog(self, 97,  {Text = "bug补偿", Callback = self.OnNpcDialog, Param = {self}})
	elseif szTrigger == "Init" then
		self:LoadSetting();
		self:SendAllMails();
	end
end

function tbAct:SendAllMails()
	for dwRoldId, nCount in pairs(self.tbLimitServerSend) do
		Mail:SendSystemMail({
			To = dwRoldId;
			Title = "Kiếm hiệp V Gói quà BUG Đền bù";
			Text = string.format("Tôn kính người chơi, bởi vì trước đó VIP Gói quà bên trong 4 Cấp Hồn thạch BUG, dẫn đến ngươi thu hoạch được một chút sai lầm 4 Cấp Hồn thạch. Chúng ta thâm biểu áy náy.\n Hiện cung cấp hối đoái công năng, có thể sử dụng tùy ý một cái 4 Cấp trung cấp Hồn thạch ( Như trung cấp Hồn thạch · Thiếu niên dương ảnh phong chờ ), hối đoái một cái ngẫu nhiên 4 Cấp sơ cấp Hồn thạch.\n Căn cứ trước ngươi VIP Gói quà thu hoạch được tình huống, ngươi có %d Lần hối đoái cơ hội, có thể hối đoái %d Cái 4 Cấp sơ cấp Hồn thạch.\n Mời tiến về Tương Dương thành [url=npc:NPC Nguyệt mi mà, 97, 10] Chỗ hối đoái", nCount, nCount);
		 })
	end
end

function tbAct:LoadSetting()
	if self.tbLimitServerSend then
		return
	end
	local tbLimitServerSend = {}
	local _, _, nServerIdentity = GetWorldConfifParam()
	local file  = LoadTabFile("Setting/Exchange/LimitServerSend.tab", "ddd", nil, {"ServerId", "RoleId", "Count"});
	for i,v in ipairs(file) do
		if v.ServerId == nServerIdentity then
			tbLimitServerSend[v.RoleId] = v.Count
		end
	end
	self.tbLimitServerSend = tbLimitServerSend
end


function tbAct:OnNpcDialog()
	local nTotalCount = self.tbLimitServerSend[me.dwID]
	if not nTotalCount then
		me.CenterMsg("Trước mắt không có bug Đền bù")
		return
	end

	local nUseCount = me.GetUserValue(self.SAVE_GROUP, self.SAVE_KEY_ServerSend)
	Dialog:Show(
	{
	    Text    = string.format("Vì đền bù trước đó BUG, ngươi bây giờ còn có %d/%d Lần hối đoái ngẫu nhiên 4 Cấp sơ cấp Hồn thạch cơ hội. Nhưng sử dụng 4 Cấp trung cấp Hồn thạch hối đoái", (nTotalCount - nUseCount), nTotalCount) ,
	    OptList = {
	        { Text = "Hối đoái 4 Cấp sơ cấp Hồn thạch", Callback = self.AskExchangeItem, Param = {self} },
	    },
	}, me, him)
end

function tbAct:AskExchangeItem()
	if not self:Can_ServerVipeExChange(me) then
		return
	end
	Exchange:AskItem(me, "ServerVipeExChange", self.ExchangeItem, self)
end

function tbAct:Can_ServerVipeExChange(pPlayer, nAddCount)
	local nTotalCount = self.tbLimitServerSend[pPlayer.dwID]
	if not nTotalCount then
		return
	end
	nAddCount = nAddCount or 1
	local nUseCount = pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_KEY_ServerSend)
	if nUseCount + nAddCount > nTotalCount then
		if nUseCount == nTotalCount then
			pPlayer.CenterMsg("Hối đoái số lần đã sử dụng hết")
		else
			pPlayer.CenterMsg(string.format("Hối đoái số lần không đủ %d Lần", nAddCount) )
		end
		return
	end

	return true
end

function tbAct:ExchangeItem(tbItems) --有me 的
	for dwTemplateId, nCount in pairs(tbItems) do
		if me.GetItemCountInAllPos(dwTemplateId) < nCount then
			return
		end
	end

	local tbSetting = Exchange.tbExchangeSetting["ServerVipeExChange"];
	local tbExchangeIndex =  Exchange:DefaultCheck(tbItems, tbSetting)
	if not tbExchangeIndex then
		return
	end

	if not self:Can_ServerVipeExChange(me, #tbExchangeIndex) then
		return
	end
	local tbAllExchange = tbSetting.tbAllExchange
	me.SetUserValue(self.SAVE_GROUP, self.SAVE_KEY_ServerSend, me.GetUserValue(self.SAVE_GROUP, self.SAVE_KEY_ServerSend) + #tbExchangeIndex)
	for _,nIdex in ipairs(tbExchangeIndex) do
		local tbSet = tbAllExchange[nIdex]
		for nItemId,nCount in pairs(tbSet.tbAllItem) do
			if  me.ConsumeItemInAllPos(nItemId, nCount, Env.LogWay_ExchangeSeverSend) ~= nCount then
				Log(debug.traceback(), me.dwID)
				return
			end
		end

		me.SendAward(tbSet.tbAllAward, nil,nil, Env.LogWay_ExchangeSeverSend)
	end
	me.CenterMsg("Hối đoái thành công")
end