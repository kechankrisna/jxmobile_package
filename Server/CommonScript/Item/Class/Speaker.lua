local tbSpeaker = Item:GetClass("Speaker");

function tbSpeaker:OnUse(it)
	local nBuyChatCount = KItem.GetItemExtParam(it.dwTemplateId, 1);
	local nType = KItem.GetItemExtParam(it.dwTemplateId, 2);

	if nType == ChatMgr.ChannelType.Public then
		ChatMgr:AddPublicChatCount(me, nBuyChatCount);
		me.CenterMsg(string.format("Tăng %d lần cơ hội chat Kênh thế giới", nBuyChatCount));
		return 1;
	elseif nType == ChatMgr.ChannelType.Color then
		ChatMgr:AddColorChatCount(me, nBuyChatCount);
		me.CenterMsg(string.format("Tăng %d lần cơ hội chat Kênh chat màu", nBuyChatCount));
		me.CallClientScript("ChatMgr:UpdateColorMsgCount");
		return 1;
	elseif nType == ChatMgr.ChannelType.Cross then
		ChatMgr:AddCrossChatCount(me, nBuyChatCount);
		me.CenterMsg(string.format("Đã tăng %d lần phát ngôn kênh MC", nBuyChatCount));
		return 1;
	else
		me.CenterMsg("Dạng loa chưa biết");
	end
end