local tbAct = Activity:GetClass("KinEncounterAct")
tbAct.tbTimerTrigger = {
	[1] = {szType = "Day", Time = "9:00", Trigger = "SendWorldNotify"},
	[2] = {szType = "Day", Time = "12:00", Trigger = "SendWorldNotify"},
	[3] = {szType = "Day", Time = "19:00", Trigger = "SendWorldNotify"},
	[4] = {szType = "Day", Time = "20:59", Trigger = "CheckStart"}
}
tbAct.tbTrigger = {
	Init={},
	Start={
		{"StartTimerTrigger", 1},
		{"StartTimerTrigger", 2},
		{"StartTimerTrigger", 3},
		{"StartTimerTrigger", 4},
	},
	End={},
	SendWorldNotify = { {"WorldMsg", "各位少俠，幫派遭遇戰開始了，大家可通過查看“最新消息”瞭解活動內容！", 20} },
	CheckStart = {},
}

function tbAct:OnTrigger(szTrigger)
	Log("KinEncounterAct:OnTrigger", szTrigger)
	if szTrigger=="Init" then
		KinEncounter:ClearRecords()
	elseif szTrigger == "Start" then
		Activity:RegisterNpcDialog(self, 266, {Text = "參與幫派遭遇戰", Callback = self.TryApply, Param = {self}})
	elseif szTrigger == "End" then
		KinEncounter:SendRecordRewards()
	elseif szTrigger=="CheckStart" then
		self:CheckStart()
	end
end

function tbAct:CheckStart()
	local bStart = KinEncounter:IsOpenToday()
	if bStart then
		CallZoneServerScript("KinEncounter:OnNotifyZoneStart")
	end
	Log("KinEncounterAct:CheckStart", tostring(bStart))
end

function tbAct:TryApply()
	me.CallClientScript("Ui:OpenWindow", "KinEncounterJoinPanel")
end

function tbAct:GetUiData()
	if not self.tbUiData then
		local tbData = {}
		tbData.nShowLevel = 60
		tbData.szTitle = "幫派遭遇戰"
		tbData.nBottomAnchor = 0

		local nStartTime, nEndTime = self:GetOpenTimeInfo()
		local tbTime1 = os.date("*t", nStartTime)
		local tbTime2 = os.date("*t", nEndTime)
		tbData.szContent = string.format([[活動時間：[c8ff00]%s年%s月%s日%d點%d分-%s年%s月%s日%s點%d分[-]
幫派遭遇戰活動開始了！
]], tbTime1.year, tbTime1.month, tbTime1.day, tbTime1.hour, tbTime1.min, tbTime2.year, tbTime2.month, tbTime2.day, tbTime2.hour, tbTime2.min)
		tbData.tbSubInfo = {}
		table.insert(tbData.tbSubInfo, {szType = "Item2", szInfo = [[活動期間每逢[FFFE0D]週一[-]、[FFFE0D]週三[-]、[FFFE0D]週五[-]、[FFFE0D]周日[-]的[FFFE0D]20:59[-]各位擁有幫派的大俠均可通過活動入口進入準備場等待，[FFFE0D]6分鐘[-]準備時間結束後將按照幫派已報名的人員的實力匹配相近的幫派進行對戰。整個活動期間共開放[FFFE0D]8[-]場比賽。
進入對戰後，雙方將針對[FFFE0D]龍柱[-]、[FFFE0D]神木[-]、[FFFE0D]糧倉[-]三種資源進行爭奪，並爭取最終勝利，
[FFFE0D]龍柱爭奪 致勝關鍵[-]
幫派遭遇戰的勝負是由[FFFE0D]積分[-]決定的，而[FFFE0D]積分[-]只能通過佔領龍柱來獲得增長，所以佔領[FFFE0D]龍柱[-]乃是重中之重。
[FFFE0D]上古神木 資源來源[-]
戰場中會有兩處[FFFE0D]神木[-]，佔領之後可使本方[FFFE0D]木材[-]數量持續增長，[FFFE0D]木材[-]可以製造[FFFE0D]作戰[-]器械，由此提升己方戰力。
[FFFE0D]兵精糧足 士氣高漲[-]
戰場中有兩處[FFFE0D]糧倉[-]，佔領之後我方成員可無後顧之憂，士氣高漲，獲得大量增益，實力大增。
[FFFE0D]殺敵排行 論功行賞[-]
本局戰鬥結束後，會按照幫派成員的[FFFE0D]殺敵排行[-]發放獎勵，最終獲勝會獲得更高的獎勵哦！
[FFFE0D]縱觀全域 榮譽授予[-]
最終勝場數達到[FFFE0D]8場[-]、[FFFE0D]7場[-]、[FFFE0D]6場[-]的幫派的總堂主會獲得[ff8f06][url=openwnd:稱號·雄才偉略, ItemTips, "Item", nil, 8458][-]，堂主會獲得[ff8f06][url=openwnd:稱號·古之名將不能及, ItemTips, "Item", nil, 8459][-]
最終勝場數達到[FFFE0D]5場[-]、[FFFE0D]4場[-]、[FFFE0D]3場[-]的幫派的總堂主會獲得[ff578c][url=openwnd:稱號·料敵機先, ItemTips, "Item", nil, 8460][-]，堂主會獲得[ff578c][url=openwnd:稱號·萬軍從我塞上征, ItemTips, "Item", nil, 8461][-]

[FFFE0D]注[-]：活動進行期間與幫派遭遇戰時間衝突的活動（即幫派遭遇戰開啟當晚21：00原應開啟的活動）暫時關閉。
]]})

		self.tbUiData = tbData
	end
	return self.tbUiData
end