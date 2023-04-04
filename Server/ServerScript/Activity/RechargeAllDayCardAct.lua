
local tbAct = Activity:GetClass("RechargeAllDayCardAct");

tbAct.tbTimerTrigger = 
{ 
}
tbAct.tbTrigger = { 
	Init 	= { }, 
	Start 	= { }, 
	End 	= { }, 
}

tbAct.SAVE_GROUP = 121;
tbAct.KEY_TAKE_DAY = 1;


function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Start" then
		self.tbAward = Lib:GetAwardFromString(self.tbParam[1])
		self:SendNews()
		Activity:RegisterPlayerEvent(self, "Act_DailyGift", "OnAct_DailyGift");
	end
end

function tbAct:SendNews()
	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	local tbTime1 = os.date("*t", nStartTime)
	local tbTime2 = os.date("*t", nEndTime)

	local szAwadDesc =  table.concat( Lib:GetAwardDesCount2(self.tbAward), "、")

	NewInformation:AddInfomation("RechargeResetDou", nEndTime, {
		string.format([[
            Thời gian hoạt động: [c8ff00]%d Năm %d Nguyệt %d Nhật 4 Điểm -%d Nguyệt %d Nhật 4 Điểm [-]
            Hoạt động nói rõ: Thời gian hoạt động bên trong mua [c8ff00] Bạch ngân / Hoàng kim / Kim cương ba cái [-] Siêu giá trị gói quà sau, còn đem thu hoạch được [c8ff00]%s[-] Khen thưởng thêm, còn chờ cái gì, nhanh đi mua đi!
            Ban thưởng sẽ thông qua bưu kiện cấp cho, xin chú ý kiểm tra và nhận.

        ]], tbTime1.year, tbTime1.month, tbTime1.day, tbTime2.month, tbTime2.day, szAwadDesc)},
         {szTitle = "Mỗi ngày gói quà tăng giá cả đưa", nReqLevel = 1})
end



function tbAct:OnAct_DailyGift(pPlayer)
	local nToday = Lib:GetLocalDay(GetTime() - 3600 * 4)
	local nTakedyDay = pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_TAKE_DAY)
	if nTakedyDay == nToday then
		return
	end
	for nGroupIndex, tbBuyInfo in ipairs(Recharge.tbSettingGroup.DayGift) do
		local nBuyDay = pPlayer.GetUserValue(Recharge.SAVE_GROUP, tbBuyInfo.nBuyDayKey)
		if nBuyDay ~= nToday then
			return
		end
	end
	pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_TAKE_DAY, nToday)


	Mail:SendSystemMail({
		To = pPlayer.dwID,
		Title = "Hoạt động ban thưởng",
		Text = "      Tôn kính hiệp sĩ! Chúc mừng ngài tại mỗi ngày gói quà tăng giá cả đưa trong hoạt động đạt thành yêu cầu, thu hoạch được hoạt động ban thưởng",
		tbAttach = self.tbAward,
		nLogReazon = Env.LogWay_RechargeAllDayCardAct,
	});

end

