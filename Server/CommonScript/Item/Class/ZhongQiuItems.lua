local tbItem = Item:GetClass("ZhongQiu_HHYY")

tbItem.nAddContrib = 1000	--花好月圆月饼增加的贡献

function tbItem:OnUse(it)
	local nKinId = me.dwKinId
	if not nKinId or nKinId<=0 then
		me.CenterMsg("Đại hiệp chưa có bang hội, không thể dùng")
		return
	end

	me.AddMoney("Contrib", self.nAddContrib, Env.LogWay_ZhongQiuJie)
	me.CenterMsg(string.format("Nhận %d Cống hiến", self.nAddContrib))

	local szMsg = string.format("%s đã tặng【%s】thơm ngon cho các thành viên trong bang, nhận được %d cống hiến bang! Để lại lời chúc: Trung thu sum vầy, chúc bang hội chúng ta ngày càng đoàn kết lớn mạnh!", me.szName, it.szName, self.nAddContrib)
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId)
	return 1
end

-------
local tbItem = Item:GetClass("ZhongQiu_QYQY")

function tbItem:OnUse(it)
	me.CallClientScript("Ui:OpenWindow","GiftSystem");
	me.CallClientScript("Ui:CloseWindow","ItemTips");
end

-------
local tbItem = Item:GetClass("ZhongQiu_MoonCakeBox")

tbItem.tbOpenGiveItems = {6440, 6441}   --晴云秋月，花好月圆
tbItem.tbRandomItems = {
    {9570, 1}, --id, rate(10000为分母)
    {6444, 10},
    {2878, 500},
}

function tbItem:OnUse(it)
	for _, nId in ipairs(self.tbOpenGiveItems) do
		me.SendAward({{"item", nId, 1}}, nil, true, Env.LogWay_ZhongQiuJie)
	end

	local nTotalRate = 0
	for _, tb in ipairs(self.tbRandomItems) do
		local nItemId, nRate = unpack(tb)
		nTotalRate = nTotalRate+nRate
	end
	local nRandom = MathRandom(10000)
	if nRandom<=nTotalRate then
		local nTotalRate = 0
		for _, tb in ipairs(self.tbRandomItems) do
			local nItemId, nRate = unpack(tb)
			nTotalRate = nTotalRate+nRate
			if nRandom<=nTotalRate then
				me.SendAward({{"item", nItemId, 1}}, nil, true, Env.LogWay_ZhongQiuJie)
				self:SendKinMsg(me, nItemId)
				break
			end
		end
	end

	Activity:OnPlayerEvent(me, "Act_UseMoonCakeBox")

	return 1
end

function tbItem:SendKinMsg(pPlayer, nItemId)
	local tbAct = Activity:GetClass("ZhongQiuJie")
	local nMoonCakeBoxId = tbAct.nMoonCakeBoxId

	local szBoxItemName = KItem.GetItemShowInfo(nMoonCakeBoxId, pPlayer.nFaction, pPlayer.nSex)
	local szItemName = KItem.GetItemShowInfo(nItemId, pPlayer.nFaction, pPlayer.nSex)
	
	
	if (pPlayer.nFaction >= 18) then	
		szBoxItemName = Item:GetNewItemShowInfo(nMoonCakeBoxId, pPlayer.nFaction, pPlayer.nSex);
		szItemName = Item:GetNewItemShowInfo(nItemId, pPlayer.nFaction, pPlayer.nSex);
	end

	local szMsg = string.format("「%s」mở [FFFE0D]%s[-] nhận được <%s>, thật may mắn!", pPlayer.szName, szBoxItemName, szItemName)
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Friend, szMsg, pPlayer.dwID)
	local nKinId = pPlayer.dwKinId
	if nKinId and nKinId>0 then
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, nKinId, {
			nLinkType = ChatMgr.LinkType.Item,
			nTemplateId = nItemId,
			nFaction = pPlayer.nFaction,
			nSex = pPlayer.nSex,
		})
	end
end
