
local tbAct = Activity:GetClass("NpcBiWuZhaoQin");

tbAct.nZhaoQinCost = 688;		-- 参与招亲消耗元宝
tbAct.nItemTimeout = 90 * 24 * 3600;
tbAct.nMinLevel = 60;

tbAct.tbTypeInfo = {

		--	活动类型	招亲开启NpcId	冠军奖励道具		参与奖			冠军额外奖励
			[1] = 		{2326, 				4789,			4810,			4811};
			[2] = 		{2279, 				4790,			4812,			4813};
}

-- 按照时间轴不同的最低等级限制
tbAct.tbMinLevel = {
	{"OpenLevel69",  60},
	{"OpenLevel89",  70},
	{"OpenLevel99",  80},
	{"OpenLevel109", 90},
	{"OpenLevel119", 100},
}

tbAct.tbTimerTrigger = {}

tbAct.tbTrigger =
{
	Init = {},
	Start = {},
	End = {},
};

tbAct.nMaxIndex = tbAct.nMaxIndex or 0;
tbAct.bFinish = tbAct.bFinish or false;

function tbAct:OnTrigger(szTrigger, nType)
	nType = tonumber(nType or "");
	if szTrigger == "Init" then
		if tbAct.nMaxIndex <= 0 then
			local _, _, nSubServerId = GetServerIdentity();
			tbAct.nMaxIndex = nSubServerId*2^5;
		end

		tbAct.nMaxIndex = tbAct.nMaxIndex + 1;
		for _, tbInfo in pairs(tbAct.tbMinLevel) do
			if GetTimeFrameState(tbInfo[1]) == 1 then
				tbAct.nMinLevel = math.max(tbAct.nMinLevel, tbInfo[2]);
			end
		end

		BiWuZhaoQin:StartS(tbAct.nMaxIndex, 0, true);
		tbAct.tbAllPlayer = {};
		tbAct.bFinish = false;

		Log("[NpcBiWuZhaoQin] Init ", tbAct.nMaxIndex);
	elseif szTrigger == "Start" then
		if not self.tbTypeInfo[nType] then
			Log("[NpcBiWuZhaoQin] ERROR !! self.tbTypeInfo[nType] is nil !!!", type(nType), nType);
			return;
		end

		self.nEntryNpc = self.tbTypeInfo[nType][1];
		self.nNormalAward = self.tbTypeInfo[nType][3];
		self.nWinnerAward = self.tbTypeInfo[nType][4];

		local szName = KNpc.GetNameByTemplateId(self.nEntryNpc);
		KPlayer.SendWorldNotify(0, 999, string.format("[FFFE0D]%s[-] Luận võ chọn rể bắt đầu báo danh, thời gian [FFFE0D]5 Phút [-], xin mọi người mau chóng tìm [FFFE0D]%s[-] Báo danh tham gia!", szName, szName), 1, 1);

		Activity:RegisterNpcDialog(self, self.nEntryNpc, {Text = "Ta muốn tham dự chọn rể", Callback = function ()
			if tbAct.bFinish then
				me.CenterMsg("Hoạt động đã kết thúc!");
				return;
			else
				me.CallClientScript("Ui:OpenWindow", "NpcBiWuZhaoQinUi", self.nEntryNpc);
			end
		end, Param = {}})

		self.nAwardItemId = self.tbTypeInfo[nType][2];
		Activity:RegisterGlobalEvent(self, "Act_OnCompleteZhaoQinS", "OnCompleteZhaoQinS");
		Activity:RegisterGlobalEvent(self, "Act_OnStartFinalS", "OnStartFinalS");
		Activity:RegisterGlobalEvent(self, "Act_OnEndZhaoQinS", "OnEndZhaoQinS");
		Activity:RegisterGlobalEvent(self, "Act_Act_OnStartZhaoQinS", "OnStartZhaoQinS");
		Activity:RegisterPlayerEvent(self, "Act_NpcBiWuZhaoQinClientCall", "OnBiWuZhaoQinClientCall");

		Log("[NpcBiWuZhaoQin] Start ", tbAct.nMaxIndex, nType);
	elseif szTrigger == "End" then
		self.nEntryNpc = nil;
		tbAct.tbAllPlayer = {};
	end
end

function tbAct:OnBiWuZhaoQinClientCall(pPlayer, szCmd, ...)
	if szCmd == "Enter" then
		self:GoToFight(pPlayer);
	elseif szCmd == "Match" then
		self:GoToMatch(pPlayer);
	end
end

function tbAct:SendNormalAward()
	local nWinerId = self.nWinerId or 0;
	for nPlayerId in pairs(tbAct.tbAllPlayer or {}) do
		if nPlayerId ~= nWinerId then
			local szName = KNpc.GetNameByTemplateId(self.nEntryNpc);
			local tbMail = {
					To = nPlayerId;
					Title = "Luận võ chọn rể ban thưởng";
					From = "Hệ thống";
					Text = string.format("Hiệp sĩ thành công tham dự [FFFE0D]%s[-] Luận võ chọn rể! Đây là nho nhỏ tâm ý, mong rằng hiệp sĩ vui vẻ nhận!", szName);
					tbAttach = {{"item", self.nNormalAward, 1}};
					nLogReazon = Env.LogWay_NpcBiWuZhaoQin;
				};
			Mail:SendSystemMail(tbMail);
		end
	end
end

function tbAct:OnCompleteZhaoQinS(tbAllPlayer, nWinerId, nTargetId)
	self.nWinerId = nWinerId;
	self:SendNormalAward();

	tbAct.bFinish = true;
	local pPlayer = KPlayer.GetPlayerObjById(nWinerId);
	if not pPlayer then
		return;
	end

	local tbAward = {
		{"item", self.nAwardItemId, 1, GetTime() + self.nItemTimeout},

	};
	pPlayer.SendAward(tbAward, false, true, Env.LogWay_NpcBiWuZhaoQin);

	local szItemName = KItem.GetItemShowInfo(self.nAwardItemId, pPlayer.nFaction, pPlayer.nSex);
	local szName = KNpc.GetNameByTemplateId(self.nEntryNpc);
	local tbMail = {
			To = nWinerId;
			Title = "Luận võ chọn rể chiến thắng";
			From = "Hệ thống";
			Text = string.format("Đại hiệp, chúc mừng ngài thắng được [FFFE0D]%s[-] Luận võ chọn rể quán quân, trừ phụ kiện ban thưởng bên ngoài, đặc thù ban thưởng [FFFE0D][url=openwnd:%s, ItemTips,'Item',nil,%d][-] Đã cấp cho đến hiệp sĩ ba lô, có thể tiến về gia viên, thông qua sử dụng đạo cụ đem mời đến gia viên bên trong nghỉ ngơi một thời gian, cũng không nên bỏ lỡ cái này đơn độc ở chung cơ hội a!", szName, szItemName, self.nAwardItemId);
			tbAttach = {{"item", self.nWinnerAward, 1}};
			nLogReazon = Env.LogWay_NpcBiWuZhaoQin;
		};
	Mail:SendSystemMail(tbMail);

	local szMsg = string.format("「%s」Tham gia %s Luận võ chọn rể vượt mọi chông gai, quá quan trảm tướng, thu hoạch được cuối cùng chiến thắng! Thắng được %s Ưu ái! Cẩn thận từng li từng tí tiếp nhận %s Đặt ở trong tay [FFFE0D]<%s>[-]! Thực là tiện sát người bên ngoài!", pPlayer.szName, szName, szName, szName, szItemName);
	KPlayer.SendWorldNotify(0, 999, szMsg, 0, 1);
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.System, szMsg, nil, {nLinkType = ChatMgr.LinkType.Item, nTemplateId = self.nAwardItemId, nFaction = pPlayer.nFaction, nSex = pPlayer.nSex});
	if pPlayer.dwKinId > 0 then
		ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, pPlayer.dwKinId, {nLinkType = ChatMgr.LinkType.Item, nTemplateId = self.nAwardItemId, nFaction = pPlayer.nFaction, nSex = pPlayer.nSex});
	end

	Log("[NpcBiWuZhaoQin] Finish !!", nWinerId, nTargetId);
end

function tbAct:OnStartFinalS()
	local szName = KNpc.GetNameByTemplateId(self.nEntryNpc)
	local szMsg = string.format("[FFFE0D]%s[-] Luận võ chọn rể trận chung kết giai đoạn sắp bắt đầu, hiệp sĩ có thể tìm [FFFE0D]%s[-] Tiến vào sân bãi quan chiến!", szName, szName);
	KPlayer.SendWorldNotify(1,1000, szMsg, ChatMgr.ChannelType.Public, 1);
end

function tbAct:OnEndZhaoQinS(tbAllPlayer, nPreMapId, nTargetId)
	tbAct.bFinish = true;
	local szName = KNpc.GetNameByTemplateId(self.nEntryNpc)
	local szMsg = string.format("Bởi vì không người tham gia, [FFFE0D]%s[-] Luận võ chọn rể thất bại", szName);
	KPlayer.SendWorldNotify(1,1000, szMsg, ChatMgr.ChannelType.Public, 1);

	self:SendNormalAward();
	Log("[NpcBiWuZhaoQin] End !! ", nTargetId);
end

function tbAct:OnStartZhaoQinS()
	local szName = KNpc.GetNameByTemplateId(self.nEntryNpc)
	local szMsg = string.format("[FFFE0D]%s[-] Luận võ chọn rể bắt đầu báo danh, thời gian [FFFE0D]5 Phút [-], xin mọi người mau chóng tìm [FFFE0D]%s[-] Báo danh tham gia!", szName, szName)
	KPlayer.SendWorldNotify(1,1000, szMsg, ChatMgr.ChannelType.Public, 1, 1);
end

function tbAct:CheckZhaoQinCommon(pPlayer, nIdx, bNotCheckLevel)
	if tbAct.bFinish then
		return false, "Chọn rể đã kết thúc!";
	end

	if not bNotCheckLevel and pPlayer.nLevel < tbAct.nMinLevel then
		return false, string.format("Cấp bậc chưa đủ %s, không cách nào tham gia!", tbAct.nMinLevel);
	end

	if not Fuben.tbSafeMap[pPlayer.nMapTemplateId] then
		return false, "Trước mắt địa đồ không thể tham dự, mời tiến về [FFFE0D] Tương Dương thành [-] Hoặc [FFFE0D] Vong ưu đảo [-] Lại nếm thử";
	end

	local tbActData = BiWuZhaoQin:GetActData(tbAct.nMaxIndex);
	if not tbActData or not tbActData.nPreMapId then
		return false, "Bổn tràng chọn rể tranh tài còn không có mở ra!";
	end

	if nIdx and nIdx ~= tbAct.nMaxIndex then
		return false, "Chỉ định buổi diễn đã kết thúc!";
	end

	return true;
end

function tbAct:CheckCanGoToFight(pPlayer, nIdx, bNotCheckMoney)
	local bRet, szMsg = self:CheckZhaoQinCommon(pPlayer, nIdx);
	if not bRet then
		return bRet, szMsg;
	end

	bRet, szMsg = BiWuZhaoQin:CheckCanEnter(pPlayer.dwID, nIdx);
	if not bRet then
		return bRet, szMsg;
	end

	if not bNotCheckMoney and pPlayer.GetMoney("Gold") < self.nZhaoQinCost then
		return false, string.format("Nguyên bảo không đủ %s, không cách nào báo danh!", self.nZhaoQinCost);
	end

	return true;
end

function tbAct:CheckCanGoToMatch(pPlayer, nIdx)
	local bRet, szMsg = self:CheckZhaoQinCommon(pPlayer, nIdx, true);
	if not bRet then
		return bRet, szMsg;
	end

	bRet, szMsg = BiWuZhaoQin:CheckCanEnter(pPlayer.dwID, nIdx, true);
	if not bRet then
		return bRet, szMsg;
	end

	return true;
end

function tbAct:TryZhaoQin_CoseMoney(nPlayerId, bSuccess, szBillNo, nIdx)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if not pPlayer then
		return false, "Tôn kính hiệp sĩ, ngài tại báo danh quá trình bên trong rơi dây! Mời một lần nữa nếm thử!";
	end

	if not bSuccess then
		return false, "Thanh toán thất bại xin sau thử lại!";
	end

	local bRet, szMsg = self:CheckCanGoToFight(pPlayer, nIdx, true);
	if not bRet then
		return false, szMsg;
	end

	bRet = BiWuZhaoQin:Enter(pPlayer.dwID, nIdx);
	if not bRet then
		return false, "Luận võ chọn rể địa đồ nhân số đã đạt hạn mức cao nhất, xin đợi thử lại!";
	end

	tbAct.tbAllPlayer = tbAct.tbAllPlayer or {};
	tbAct.tbAllPlayer[pPlayer.dwID] = true;
	Log("[NpcBiWuZhaoQin] Goto Fight ", pPlayer.szName, pPlayer.szAccount, pPlayer.dwID, nIdx);
	return true;
end

function tbAct:GoToFight(pPlayer)
	local bCanJoin, szMsg = tbAct:CheckCanGoToFight(pPlayer, tbAct.nMaxIndex, tbAct.tbAllPlayer[pPlayer.dwID] and true or false);
	if not bCanJoin then
		pPlayer.CenterMsg(szMsg, true);
		return;
	end

	if tbAct.tbAllPlayer[pPlayer.dwID] then
		local bRet = BiWuZhaoQin:Enter(pPlayer.dwID, tbAct.nMaxIndex);
		if not bRet then
			pPlayer.CenterMsg("Luận võ chọn rể địa đồ nhân số đã đạt hạn mức cao nhất, xin đợi thử lại!");
		end
		return;
	end

	local function fnCostCallback(nPlayerId, bSuccess, szBillNo, nIdx)
		return tbAct:TryZhaoQin_CoseMoney(nPlayerId, bSuccess, szBillNo, nIdx);
	end

	local bRet = pPlayer.CostGold(tbAct.nZhaoQinCost, Env.LogWay_NpcBiWuZhaoQin, nil, fnCostCallback, tbAct.nMaxIndex);
	if not bRet then
		pPlayer.CenterMsg("Thanh toán thất bại xin sau thử lại!");
		return;
	end
end

function tbAct:GoToMatch(pPlayer)
	local bRet, szMsg = tbAct:CheckCanGoToMatch(pPlayer, tbAct.nMaxIndex);
	if not bRet then
		pPlayer.CenterMsg(szMsg, true);
		return;
	end

	local bRet = BiWuZhaoQin:Enter(pPlayer.dwID, tbAct.nMaxIndex, true);
	if not bRet then
		pPlayer.CenterMsg("Mục tiêu đồ số người đã đủ!", true);
	end
	Log("[NpcBiWuZhaoQin] Goto Match ", pPlayer.szName, pPlayer.szAccount, pPlayer.dwID, tbAct.nMaxIndex);
end
