local tbAct = Activity:GetClass("WinterAct")
tbAct.tbTimerTrigger = 
{ 
   
}
tbAct.tbTrigger  = {Init = {}, Start = {}, End = {}}

tbAct.tbGatherAnswerAward = {}

local Winter = Activity.Winter

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Start" then
		Activity:RegisterPlayerEvent(self, "Act_GatherFirstJoin", "OnGatherFirstJoin")
		Activity:RegisterPlayerEvent(self, "Act_GatherAnswerWrong", "OnGatherAnswerWrong")
		Activity:RegisterPlayerEvent(self, "Act_GatherAnswerRight", "OnGatherAnswerRight")
	elseif szTrigger == "End" then
		self:OnWinterEnd()
	end
	Log("WinterAct OnTrigger:", szTrigger)
end

function tbAct:OnWinterEnd()
	local nTangYuanCount = SupplementAward:GetMaxSupplementCount()
	local nNowTime = GetTime()
	local tbMail =
		{
			Title = "Chân nhi đông chí ấm thư",
			Text = "    Hừ hừ, cái kia nói muốn dương danh võ lâm đại hiệp, không biết vào đông trôi qua vừa vặn rất tốt? Từ biệt mấy năm, ngươi có thể biến đổi thành người bận rộn rồi, ngày hội cũng chưa từng về đảo thăm viếng, ta nhưng dù sao nhớ thương ngươi, ủy thác nhanh như gió thay ta mang hộ đi tự mình làm một chén canh tròn, một bàn sủi cảo, vô luận ngươi đêm qua dùng ăn cỡ nào sơn trân hải vị, đều muốn ngoan ngoãn ăn hết! Nếu không ta sẽ tức giận! Được rồi, phải nhớ đến nhân lúc còn nóng, [FFFE0D] Trôi qua hôm nay, liền không thể ăn dùng [-].\n    Vào đông ngày hội, duy nguyện quân khỏe mạnh mạnh khỏe, bình an mà tới.",
			From = 'Nạp Lan Chân',
			LevelLimit = Winter.nLimitLevel,
			tbAttach = {
			{'item', Winter:GetTangYuanItemId(), nTangYuanCount,nNowTime + Winter.nTangYuanValidTime},
			{'item', Winter:GetJiaoZiItemId(), Winter.nSendJiaoZiCount,nNowTime + Winter.nJiaoZiValidTime},
			},
			nLogReazon = Env.LogWay_WinterAct,
		};

	Mail:SendGlobalSystemMail(tbMail);
	Log("[WinterAct] OnWinterEnd Mail ",nTangYuanCount)
end

function tbAct:OnGatherAnswerWrong(pPlayer)
	EverydayTarget:AddActExtActiveValue(pPlayer, Winter.nGatherAnswerWrongActive, "WinterActGatherAnswerWrong")
	Log("[WinterAct] OnGatherAnswerWrong ",pPlayer.dwID,pPlayer.szName,pPlayer.nLevel,pPlayer.dwKinId)
end

function tbAct:OnGatherAnswerRight(pPlayer)
	EverydayTarget:AddActExtActiveValue(pPlayer, Winter.nGatherAnswerRightActive, "WinterActGatherAnswerRight")
	Log("[WinterAct] OnGatherAnswerRight ",pPlayer.dwID,pPlayer.szName,pPlayer.nLevel,pPlayer.dwKinId)
end

function tbAct:OnGatherFirstJoin(pPlayer)
	EverydayTarget:AddActExtActiveValue(pPlayer, Winter.nGatherFirstJoinActive, "WinterActGatherFirstJoin")
	Log("[WinterAct] OnGatherFirstJoin ",pPlayer.dwID,pPlayer.szName,pPlayer.nLevel,pPlayer.dwKinId)
end