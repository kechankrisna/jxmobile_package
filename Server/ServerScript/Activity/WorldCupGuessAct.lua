local tbAct = Activity:GetClass("WorldCupGuessAct")
tbAct.tbTimerTrigger = {
	[1] = {szType = "Day", Time = "9:00" , Trigger = "SendWorldNotify" },
	[2] = {szType = "Day", Time = "12:00" , Trigger = "SendWorldNotify" },
	[3] = {szType = "Day", Time = "19:00" , Trigger = "SendWorldNotify" },
}
tbAct.tbTrigger = {
	Init={},
	Start={
		{"StartTimerTrigger", 1},
		{"StartTimerTrigger", 2},
		{"StartTimerTrigger", 3},
	},
	End={},
	SendWorldNotify = { {"WorldMsg", "Các vị thiếu hiệp, Đại lực thần chén cạnh đoán hoạt động bắt đầu, mọi người có thể thông qua xem xét tin tức mới nhất hiểu rõ trong hoạt động cho!", 20} },
	OpenAct = {},
	CloseAct = {},
}

function tbAct:OnTrigger(szTrigger)
	Log("WorldCupGuessAct:OnTrigger", szTrigger)
	if szTrigger=="Init" then
		ScriptData:SaveAtOnce("WorldCupGuessAct", {})
	elseif szTrigger=="Start" then
		Activity:RegisterPlayerEvent(self, "Act_WorldCupReq", "OnClientReq")
	elseif szTrigger=="End" then
	end
end

tbAct.tbValidReqs = {
	UpdateData = true,
	Guess = true,
}
function tbAct:OnClientReq(pPlayer, szType, ...)
	if not self.tbValidReqs[szType] then
		return
	end

	local fn = self["OnReq_"..szType]
	if not fn then
		return
	end

	local bOk, szErr = self:CheckPlayer(pPlayer)
	if not bOk then
		if szErr and szErr~="" then
			pPlayer.CenterMsg(szErr)
		end
		return
	end

	local bOk, szErr = fn(self, pPlayer, ...)
	if not bOk then
		if szErr and szErr~="" then
			pPlayer.CenterMsg(szErr)
		end
		return
	end
end

function tbAct:OnReq_UpdateData(pPlayer)
	local tbScriptData = ScriptData:GetValue("WorldCupGuessAct")
	local tbSaveData = tbScriptData[pPlayer.dwID] or {{}, {}}

	local tbData = Lib:CopyTB(tbSaveData)
	tbData[3] = {}
	if tbScriptData.nRewarded1 and tbScriptData.nRewarded1 > 0 then
		tbData[3][1] = tbData[1][1] == self.tbTop1[1]
	end
	if tbScriptData.nRewarded4 and tbScriptData.nRewarded4 > 0 then
		for i=1, 4 do
			tbData[3][1+i] = Lib:IsInArray(self.tbTop4, tbData[1][1+i])
		end
	end
	pPlayer.CallClientScript("Activity.WorldCupGuessAct:OnUpdateData", tbData)
	return true
end

--[nPlayerId] = {{nTemplate1, ...}, {nTimeIdx1, ...}}
function tbAct:OnReq_Guess(pPlayer, nIdx, nTemplateId)
	if nIdx<1 or nIdx>5 then
		Log("[x] WorldCupGuessAct:OnReq_Guess", pPlayer.dwID, nIdx, nTemplateId)
		return false
	end

	local tbData = ScriptData:GetValue("WorldCupGuessAct")
	local tbSaveData = tbData[pPlayer.dwID] or {{}, {}}
	if tbSaveData[1][nIdx] then
		return false, "Lúc này đưa đã cạnh đoán qua"
	end
	
	if nIdx > 1 then
		for i=2, 5 do
			if tbSaveData[1][i]==nTemplateId then
				return false, "Này đội ngũ đã cạnh đoán qua, xin chớ lặp lại cạnh đoán!"
			end
		end
	end

	local tbTimeCfg = nIdx > 1 and self.tbTop4Cfg or self.tbTop1Cfg
	local nTimeIdx = self:GetTimeIdx(tbTimeCfg)
	if nTimeIdx <= 0 then
		return false, "Trước mắt giai đoạn không thể cạnh đoán"
	end

	local nCost = self.tbGuessCost[nIdx]
	if not nCost then
		Log("[x] WorldCupGuessAct:OnReq_Guess, no cost cfg", pPlayer.dwID, nIdx, nTemplate1)
		return false
	end
	local nHave = pPlayer.GetMoney("Gold") or 0
	if nHave < nCost then
		return false, "Nguyên bảo không đủ"
	end
	pPlayer.CostGold(nCost, Env.LogWay_WorldCupAct, nil, function(nPlayerId, bSuccess)
		if not bSuccess then
            return false, "Khấu trừ Nguyên bảo thất bại"
        end

        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
        if not pPlayer then
            return false, "Khấu trừ Nguyên bảo quá trình bên trong ngươi rơi dây"
        end

		tbSaveData[1][nIdx] = nTemplateId
		tbSaveData[2][nIdx] = nTimeIdx

		tbData[pPlayer.dwID] = tbSaveData

		pPlayer.CenterMsg("Cạnh đoán thành công")
		self:OnReq_UpdateData(pPlayer)

		return true
	end)
	return true
end

--在指令中调用，必须给出对应的胜出列表(self.tbTop1, self.tbTop4)
function tbAct:SendRewards(nTop)
	if not nTop or (nTop ~= 1 and nTop ~= 4) then
		Log("[x] WorldCupGuessAct:SendRewards", nTop)
		return
	end

	local tbTopList = nTop==1 and self.tbTop1 or self.tbTop4
	if not next(tbTopList or {}) then
		Log("[x] WorldCupGuessAct:SendRewards, empty toplist", nTop)
		return
	end

	local tbTimeCfg = nTop==1 and self.tbTop1Cfg or self.tbTop4Cfg
	if GetTime() <= tbTimeCfg[#tbTimeCfg][2] then
		Log("[x] WorldCupGuessAct:SendRewards, not finish", nTop)
		return
	end

	local tbData = ScriptData:GetValue("WorldCupGuessAct")
	local szKey = "nRewarded"..nTop
	if tbData[szKey] then
		Log("[x] WorldCupGuessAct:SendRewards, sent before", nTop)
		return
	end

	local tbTopMap = {}
	for _, nWinTemplateId in ipairs(tbTopList) do
		tbTopMap[nWinTemplateId] = true
	end

	local szGuessName = nTop==1 and "Quán quân" or "Tứ cường"
	local tbIdxs = nTop==1 and {1} or {2, 3, 4, 5}
	local tbMail = {Title = "Đại lực thần chén cạnh đoán", From = "Hệ thống", nLogReazon = Env.LogWay_WorldCupAct}
	for nPlayerId, tb in pairs(tbData) do
		if type(nPlayerId) == "number" then
			local nTotalTimes = 0
			local tbRight = {}
			for _, nIdx in ipairs(tbIdxs) do
				local nGuessTemplateId = tb[1][nIdx]
				if tbTopMap[nGuessTemplateId] then
					local nGuessTimeIdx = tb[2][nIdx]
					local tbCfg = tbTimeCfg[nGuessTimeIdx]
					local nTimes = tbCfg[3]
					nTotalTimes = nTotalTimes + nTimes
					table.insert(tbRight, {"item", nGuessTemplateId, nTimes})
					Log("WorldCupGuessAct:SendRewards, step", nTop, nPlayerId, nGuessTemplateId, nGuessTimeIdx, nTimes)
				end
			end
			if nTotalTimes > 0 then
				local tbAttach = {}
				local tbBaseReward = nTop == 1 and self.tbBaseReward1 or self.tbBaseReward4
				for i=1, nTotalTimes do
					for _, tb in ipairs(tbBaseReward) do
						table.insert(tbAttach, tb)
					end
				end
				tbAttach = KPlayer:MgrAward(nil, tbAttach)
				tbRight = self:FormatAward(tbRight)
				for _, tb in ipairs(tbRight) do
					table.insert(tbAttach, tb)
				end

				local tbDetails = {}
				for _, tb in ipairs(tbRight) do
					local _, nTemplateId, nTimes = unpack(tb)
					local szName = self.tbTeamCfg[nTemplateId][1]
					table.insert(tbDetails, string.format("%s (%d Lần ban thưởng )", szName, nTimes))
				end

				local szMailText = string.format("Ngài tại [FFFE0D] Đại lực thần chén %s Cạnh đoán [-] Bên trong đoán đúng [FFFE0D]%d[-] Cái, bao quát %s, phụ kiện vì ban thưởng, mời kiểm tra và nhận!", szGuessName, #tbRight, table.concat(tbDetails, "、"))
				tbMail.Text = szMailText
				tbMail.To = nPlayerId
				tbMail.tbAttach = tbAttach
				Mail:SendSystemMail(tbMail)
				Log("WorldCupGuessAct:SendRewards", nTop, nPlayerId, #tbRight, nTotalTimes)
			end
		end
	end

	tbData[szKey] = GetTime()
	ScriptData:SaveAtOnce("WorldCupGuessAct", tbData)
end

function tbAct:FormatAward(tbAward)
	if not MODULE_GAMESERVER or not Activity:__IsActInProcessByType("WorldCupGuessAct") then
		return tbAward
	end
	local tbFormatAward = Lib:CopyTB(tbAward or {})
	if not self.nMedalExpire then
		local _, nEndTime = self:GetOpenTimeInfo()
		self.nMedalExpire = nEndTime
	end
	for _, v in ipairs(tbFormatAward) do
		if v[1] == "item" or v[1] == "Item" then
			v[4] = self.nMedalExpire
		end
	end
	return tbFormatAward
end

function tbAct:GetUiData()
	if not self.tbUiData then
		local tbData = {}
		tbData.nShowLevel = 20
		tbData.szTitle = "Đại lực thần chén cạnh đoán"
		tbData.nBottomAnchor = 0

		local nStartTime, nEndTime = self:GetOpenTimeInfo()
		local tbTime1 = os.date("*t", nStartTime)
		local tbTime2 = os.date("*t", nEndTime)
		tbData.szContent = string.format([[Thời gian hoạt động: [c8ff00]%s Năm %s Nguyệt %s Nhật %d Điểm -%s Năm %s Nguyệt %s Nhật %s Điểm [-]
Đại lực thần chén cạnh đoán hoạt động bắt đầu!
]], tbTime1.year, tbTime1.month, tbTime1.day, tbTime1.hour, tbTime2.year, tbTime2.month, tbTime2.day, tbTime2.hour)
		tbData.tbSubInfo = {}
		table.insert(tbData.tbSubInfo, {szType = "Item2", szInfo = [[[FFFE0D] Vui vẻ cạnh đoán Ban thưởng lấy ra [-]
Hoạt động trong lúc đó đại hiệp có thể thông qua [FFFE0D] Tin tức mới nhất [-] Giao diện cùng [e6d012][url=openwnd:2018 Thế giới bôi huy chương thu thập sách, ItemTips, "Item", nil, 8216][-] Bên trong tiến về cạnh đoán giới mặt, tại quy định thời hạn cuối cùng trước tham dự năm nay thế giới bôi [FFFE0D] Quán quân [-] Cùng [FFFE0D] Tứ cường [-] Cạnh đoán ( Cạnh đoán đội vô địch cần tiêu hao [FFFE0D]300 Nguyên bảo [-], cạnh đoán mỗi cái tứ cường đội bóng đồng đều cần tiêu hao [FFFE0D]100 Nguyên bảo [-]), cạnh đoán thành công sau ban thưởng như sau:
Thành công cạnh đoán 1 Cái tứ cường đội bóng ban thưởng: [FFFE0D]1 Cái đối ứng tứ cường đội bóng huy chương [-], [FFFE0D]5000 Cống hiến [-]
Thành công cạnh đoán 1 Cái đội vô địch ban thưởng: [FFFE0D]1 Cái đối ứng đội vô địch huy chương [-], [FFFE0D]15000 Cống hiến [-]
[ff578c] Chú [-]: Tứ cường cạnh đoán thời hạn cuối cùng vì [ff578c]2018 Năm 07 Nguyệt 06 Nhật 21:59:59[-], quán quân cạnh đoán thời hạn cuối cùng vì [ff578c]2018 Năm 07 Nguyệt 15 Nhật 22:59:59[-].
[FFFE0D] Sớm cạnh đoán Ban thưởng gấp bội [-]
Đại hiệp tham dự cạnh đoán đúng thời gian càng sớm, cuối cùng cạnh đoán thành công thu hoạch được ban thưởng càng phong phú! Cạnh đoán thời gian cùng cuối cùng ban thưởng bội số quan hệ như sau:
[ff578c] Cạnh đoán tứ cường [-]:
2018-06-29 04:00:00~2018-06-30 21:59:59         2 Lần
2018-06-30 22:00:00~2018-07-06 21:59:59         1 Lần
[ff578c] Cạnh đoán quán quân [-]:
2018-06-29 04:00:00~2018-06-30 21:59:59         5 Lần
2018-06-30 22:00:00~2018-07-06 21:59:59         3 Lần
2018-07-06 22:00:00~2018-07-11 01:59:59         2 Lần
2018-07-11 02:00:00~2018-07-15 22:59:59         1 Lần
[ff578c] Tri kỷ nhắc nhở [-]: Sớm cạnh đoán mặc dù ban thưởng phong phú, nhưng là xác suất trúng cũng sẽ thấp hơn a!
[FFFE0D] Công bố kết quả Ban thưởng cấp cho [-]
Tứ cường kết quả đem với [ff578c]2018 Năm 7 Nguyệt 9 Nhật [-] Công bố, quán quân kết quả đem với [ff578c]2018 Năm 7 Nguyệt 16 Nhật [-] Công bố, ban thưởng sẽ tại công bố kết quả ngày đó lấy thư tín phương thức cấp cho cho các vị cạnh đoán thành công đại hiệp.
[ff578c] Tri kỷ nhắc nhở [-]: Đại hiệp nhớ kỹ kịp thời thu thập trong phong thư cấp cho huy chương, không phải huy chương hoạt động kết thúc liền quá thời hạn!
]]})
		tbData.szBtnText = "Tiến về cạnh đoán"
		tbData.szBtnTrap = "[url=openwnd:Tiến về cạnh đoán, WorldCupGuessPanel]"

		self.tbUiData = tbData
	end
	return self.tbUiData
end