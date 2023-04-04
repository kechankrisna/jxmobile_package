
local tbAct = Activity:GetClass("RechargeCardActExt");

tbAct.tbTimerTrigger = 
{ 
}
tbAct.tbTrigger = { 
	Init 	= { }, 
	Start 	= { }, 
	End 	= { }, 
}


function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Start" then
		Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin");
		local szParam1, szParam2 = self.tbParam[1], self.tbParam[2];
		self.nExtWeekAmount = tonumber(szParam1)
		if self.nExtWeekAmount == 0 then
			self.nExtWeekAmount = nil;
		end
		self.nExtMonAmount = tonumber(szParam2)
		if self.nExtMonAmount == 0 then
			self.nExtMonAmount = nil;
		end

		--self:SendNews()
		Recharge:OnCardActStart({self.nExtWeekAmount, self.nExtMonAmount})
		KPlayer.BoardcastScript(1, "Recharge:OnCardActStart", {self.nExtWeekAmount, self.nExtMonAmount})
	elseif szTrigger == "End" then
		self.nExtWeekAmount = nil;
		self.nExtMonAmount = nil;
		Recharge:OnCardActEnd()
		KPlayer.BoardcastScript(1, "Recharge:OnCardActEnd")
	end
end

function tbAct:OnLogin(pPlayer)
	pPlayer.CallClientScript("Recharge:OnCardActStart", {self.nExtWeekAmount, self.nExtMonAmount})
end

function tbAct:SendNews()
	if not self.nExtMonAmount and not self.nExtWeekAmount then
		return
	end

	local nIndex = 0

	local strContent = "[FFFE0D]Cuối tuần tiến đến, chúc mừng võ lâm [-]\n      Chư vị hiệp sĩ, vui nghênh cuối tuần, võ lâm sắp mở ra chúc mừng hoạt động!\n\n";

	if self.nExtWeekAmount then
		nIndex = nIndex + 1
		strContent = strContent .. string.format("Hoạt động %s: \n", Lib:Transfer4LenDigit2CnNum(nIndex)) ;
		strContent = strContent .. string.format("Kim thu tháng chín, Ngũ Cốc Phong Đăng; Phúc lợi cuồng hoan, Nguyên bảo vì lân cận; Hoạt động trong lúc đó, phúc lợi giao diện trung nguyên bảo đại lễ 7 Nhật gói quà nhưng ngoài định mức nhận lấy [FFFE0D] %d%% Nguyên bảo [-]\n\n", self.nExtWeekAmount)	
	end

	if self.nExtMonAmount then
		nIndex = nIndex + 1
		strContent = strContent .. string.format("Hoạt động %s: \n", Lib:Transfer4LenDigit2CnNum(nIndex)) ;
		strContent = strContent .. string.format("Kim thu tháng chín, Ngũ Cốc Phong Đăng; Phúc lợi cuồng hoan, Nguyên bảo vì lân cận; Hoạt động trong lúc đó, phúc lợi giao diện trung nguyên bảo đại lễ 30 Nhật gói quà nhưng ngoài định mức nhận lấy [FFFE0D] %d%% Nguyên bảo [-]\n\n", self.nExtMonAmount)	
	end
	strContent = strContent .. "\n  [url=openwnd:Tiến về trữ giá trị, CommonShop, 'Recharge', 'Recharge']"

	local _, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("RechargeCardActExt", nEndTime, {strContent}, {szTitle = "Cuối tuần cuồng hoan", nReqLevel = 1})
end

function tbAct:GetUiData()
	return {self.nExtWeekAmount, self.nExtMonAmount}
end