
local tbAct = Activity:GetClass("RechargeSumAct");

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
		local tbFile = LoadTabFile(self.tbParam[1], "dss", nil, {"nMoney", "AwardList", "NameList"});
		local tbAllAward = {};
		for i,v in ipairs(tbFile) do
			table.insert(tbAllAward, { nMoney = v.nMoney, tbAward = Lib:GetAwardFromString(v.AwardList), tbItemName = Lib:SplitStr(v.NameList, "|") })
		end
		self.tbAllAward = tbAllAward;

		Activity:RegisterPlayerEvent(self, "OnRecharge", "OnRecharge");
		Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin");
		local nStartTime = self:GetOpenTimeInfo()
		Recharge:OnSumActStart(nStartTime)
		KPlayer.BoardcastScript(1, "Recharge:OnSumActStart", nStartTime)
	elseif szTrigger == "End" then
		Recharge:OnSumActEnd()
		KPlayer.BoardcastScript(1, "Recharge:OnSumActEnd")
	end
end

function tbAct:OnLogin(pPlayer)
	local nStartTime = self:GetOpenTimeInfo()
	pPlayer.CallClientScript("Recharge:OnSumActStart", nStartTime)
end

function tbAct:OnRecharge(pPlayer, nGoldRMB, nCardRMB , nRechargeGold)
	local nStartTime = self:GetOpenTimeInfo()
	local nLastRestTime = Recharge:GetActRechageSumTime(pPlayer) --pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_SET_TIME)
	if nLastRestTime < nStartTime then
		if nLastRestTime ~= 0 then
			Log("RechargeSumAct Reset", pPlayer.dwID, nLastRestTime, Recharge:GetActRechageSumVal(pPlayer)) --.GetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM)
		end
		Recharge:SetActRechageSumVal(pPlayer, 0)
		Recharge:SetActRechageSumTake(pPlayer, 0)
		Recharge:SetActRechageSumTime(pPlayer, nStartTime)
	end

	local nSumRecharge = Recharge:GetActRechageSumVal(pPlayer) + nRechargeGold
	Recharge:SetActRechageSumVal(pPlayer, nSumRecharge)

	local nTakeVal = Recharge:GetActRechageSumTake(pPlayer)
	local tbBit = KLib.GetBitTB(nTakeVal)
	for i,v in ipairs(self.tbAllAward) do
		if nSumRecharge >= v.nMoney then
			if tbBit[i] == 0 then
				tbBit[i] = 1;
				nTakeVal = KLib.SetBit(nTakeVal, i, 1)
				Recharge:SetActRechageSumTake(pPlayer, nTakeVal)

				Mail:SendSystemMail({
					To = pPlayer.dwID,
					Title = "Hoạt động ban thưởng",
					Text = string.format("      Tôn kính hiệp sĩ! Chúc mừng ngài tại tính gộp lại trữ giá trị trong hoạt động đạt thành yêu cầu, thu hoạch được hoạt động ban thưởng", i),
					tbAttach = v.tbAward,
					nLogReazon = Env.LogWay_RechargeSumAct,
					});
			end
		else
			break;
		end
	end
end

function tbAct:GetUiData()
	if not self.tbUiData then
		local tbUiData = {}
		self.tbUiData = tbUiData
		tbUiData.nShowLevel = 1;
		tbUiData.szTitle = "Tính gộp lại trữ giá trị hoạt động";
		local nStartTime, nEndTime = self:GetOpenTimeInfo()
		local tbTime1 = os.date("*t", nStartTime)
		local tbTime2 = os.date("*t", nEndTime)
		--文字如果前面要空格不要用tab
		tbUiData.szContent = string.format([[Thời gian hoạt động: [c8ff00]%d Năm %d Nguyệt %d Nhật 0 Điểm -%d Nguyệt %d Nhật 24 Điểm [-]
Trong hoạt động cho:
Tôn kính hiệp sĩ, hoạt động trong lúc đó tính gộp lại trữ giá trị đạt tới [FFFF00] Chỉ định Nguyên bảo số ( Có lại chỉ có trữ giá trị kim ngạch trực tiếp hối đoái Nguyên bảo tính toán đi vào, hệ thống đưa tặng Nguyên bảo không đưa vào tính gộp lại trữ giá trị kim ngạch )[-], liền có thể thu hoạch được khen thưởng thêm, hoạt động tại [FFFF00] Rạng sáng 24 Điểm [-] Kết thúc, tuyệt đối không nên bỏ lỡ a!
]], tbTime1.year, tbTime1.month, tbTime1.day, tbTime2.month, tbTime2.day);
		tbUiData.szBtnText = "Tiến đến trữ giá trị"
		tbUiData.szBtnTrap = "[url=openwnd:test, CommonShop, 'Recharge', 'Recharge']";

		local tbSubInfo = {}
		for i,v in ipairs(self.tbAllAward) do
			table.insert(tbSubInfo, 
				{ szType = "Item3", szSub = "Recharge", nParam = v.nMoney, tbItemList = v.tbAward, tbItemName = v.tbItemName}
			)
		end
		tbUiData.tbSubInfo = tbSubInfo
	end
	return self.tbUiData;	
end
