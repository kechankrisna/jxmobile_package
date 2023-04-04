local tbAct = Activity:GetClass("ShangShengDian")

tbAct.REAL_GOLD_COUNT = 500000	--活动实际奖池的元宝数量
tbAct.SHOW_GOLD_COUNT = 2000000	--活动展示奖池的元宝数量

tbAct.tbTimerTrigger = {
	[1] = { szType = "Day", Time = "10:30", Trigger = "SendWorldNotify"},
	[2] = { szType = "Day", Time = "13:30", Trigger = "SendWorldNotify"},
	[3] = { szType = "Day", Time = "20:30", Trigger = "SendWorldNotify"},
}
tbAct.tbTrigger = {
	Init = {},
	Start = {
		{"StartTimerTrigger", 1},
	    {"StartTimerTrigger", 2},
	    {"StartTimerTrigger", 3},
	},
	End = {},
	SendWorldNotify = { { "WorldMsg", "各位少俠，我要上盛典活動開始了，大家可通過查詢“最新消息”瞭解活動內容！", 20} }
}

tbAct.NOT_START = 0	--活动未开启
tbAct.START = 1		--活动已开启
tbAct.END = 2		--活动已结束

tbAct.nState = tbAct.nState or tbAct.NOT_START

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then
		self:OnInit()
	elseif szTrigger == "Start" then
		self:OnStart()
	elseif szTrigger == "End" then
		self:OnEnd()
	end
end

function tbAct:OnInit()
	ScriptData:SaveAtOnce("ShengDianLingCount",{})
end

function tbAct:OnStart()
	Activity:RegisterPlayerEvent(self, "Act_SyncShangShengDian_Data", "OnSyncActivityData")
	Activity:RegisterPlayerEvent(self, "Act_ShangShengDian_ExtraAward", "SendExtraAward")
	local _,nEndTime = self:GetOpenTimeInfo()
	if nEndTime > GetTime() then
		--增加“最新消息”
		local szKey = "ShangShengDian"
		--最新消息的内容
		local szNewInfoMsg = [[
        [FFFE0D]我要上盛典活動開始了！[-]
        [FFFE0D]活動時間[-]：[c8ff00]2018年11月16日4點-2018年11月25日24點[-]
        江湖盛典即將來臨，武林盟特為諸位大俠準備總共了高達[FFFE0D]2000000元寶[-]的獎勵！但是想要拿走還是要付出努力的哦!
        活動期間參與盛典禮盒的考驗活動，每天成功回答[FFFE0D]3套題[-]，即可從[aa62fc][url=openwnd:江湖盛典·我字帛書, ItemTips, "Item", nil, 9850][-]、[aa62fc][url=openwnd:江湖盛典·要字帛書, ItemTips, "Item", nil, 9851][-]、[aa62fc][url=openwnd:江湖盛典·上字帛書, ItemTips, "Item", nil, 9852][-]、[aa62fc][url=openwnd:江湖盛典·盛字帛書, ItemTips, "Item", nil, 9853][-]、[aa62fc][url=openwnd:江湖盛典·典字帛書, ItemTips, "Item", nil, 9854][-][FFFE0D]5種[-]帛書中獲得隨機一種，當大俠集齊全部[FFFE0D]5種[-]帛書之後，可合成[ff578c][url=openwnd:盛典令, ItemTips, "Item", nil, 9855][-]，提交後即可在最終結算時與其他提交過的玩家共同瓜分獎池裡的獎勵！大俠若有帛書重複，還可與好友交換互補的哦！
        [FFFE0D]小提示[-]：活動期間參與[FFFE0D]門派競技、通天塔[-]有機會獲得額外的[aa62fc]帛書[-]獎勵哦！
		]]
		local tbSetting = { 
			szTitle = "我要上盛典",
			szBtnName = "即時獎池",
			szBtnTrap = "[url=openwnd:test, CeremonyPartitionGoldPanel]"
		}
		NewInformation:AddInfomation(szKey, nEndTime, {szNewInfoMsg}, tbSetting)
	end
	self.nState = self.START
end

function tbAct:OnEnd()
	--发放奖励
	local tbMail = {
		To = nil,
		Title = "【我要上盛典】",
		From = "系統",
		tbAttach = nil,
		nLogReazon = Env.LogWay_ShangShengDianActGold,
	}
	local tbCounts = ScriptData:GetValue("ShengDianLingCount") or {}
	--计算实际上交的盛典令总数目，更新self.nServerTotalCount
	self:CalcServerTotalCount()
	for nPlayerId, nCount in pairs(tbCounts) do
		tbMail.To = nPlayerId
		local nGold = self:CalcRewardGoldCount(nPlayerId)
		tbMail.tbAttach = {{"Gold", nGold}}
		--邮件文字内容
		local szMailText = string.format("    大俠在【我要上盛典】活動中不僅努力，而且幸運，總共合成並提交了%d個盛典令，這是大俠從獎池中分得的[FFFE0D]%d元寶[-]，請查收！", nCount, nGold)
		tbMail.Text = szMailText
		Mail:SendSystemMail(tbMail)
	end

	ScriptData:SaveAtOnce("ShengDianLingCount",{})
	self.nState = self.END

	Activity:UnRegisterPlayerEvent(self, "Act_SyncShangShengDian_Data")
	Activity:UnRegisterPlayerEvent(self, "Act_ShangShengDian_ExtraAward")
end


--计算当前服务器一共提交的盛典令数目(实际数目)
function tbAct:CalcServerTotalCount()
	self.nServerTotalCount = self.nServerTotalCount or 0
	local tbCounts = ScriptData:GetValue("ShengDianLingCount") or {}

	local nTotalCount = 0
	for _, nCount in pairs(tbCounts) do
		nTotalCount = nTotalCount + nCount
	end

	self.nServerTotalCount = nTotalCount
	return nTotalCount
end

--展示当前服务器一共提交的盛典令数目(展示数目)
function tbAct:CalcShowTotalCount()
	if self.REAL_GOLD_COUNT == 0 then	--实际奖池元宝数为0，检查ShangShengDian.lua中的配置
		Log("ERROR : ShangShengDian RealGoldCount is 0 !!!")
		return -1
	end
	return math.floor(self.SHOW_GOLD_COUNT * self:CalcServerTotalCount() / self.REAL_GOLD_COUNT)
end

--计算当前玩家一共提交的盛典令数目
function tbAct:CalcPlayerTotalCount(nPlayerId)
	local tbCounts = ScriptData:GetValue("ShengDianLingCount") or {}

	local nPlayerToalCount = tbCounts[nPlayerId] or 0
	return nPlayerToalCount
end

--瓜分元宝数
function tbAct:CalcRewardGoldCount(nPlayerId)
	local nServerTotalCount = self.nServerTotalCount or 0
	if nServerTotalCount == 0 then
		return 0
	end

	return math.floor(self.REAL_GOLD_COUNT / nServerTotalCount * self:CalcPlayerTotalCount(nPlayerId))
end


function tbAct:OnSyncActivityData(pPlayer)
	local tbInfo = {}
	local nPlayerId = pPlayer.dwID
	tbInfo.nTotalGoldCount = tbAct.SHOW_GOLD_COUNT
	tbInfo.nServerTotalCount = self:CalcShowTotalCount()
	tbInfo.nPlayerToalCount = self:CalcPlayerTotalCount(nPlayerId)
	tbInfo.nRewardGoldCount = self:CalcRewardGoldCount(nPlayerId)
	pPlayer.CallClientScript("Activity:OnSyncActivityCustomInfo", "ShangShengDian", tbInfo)
end

function tbAct:UseShengDianLing()
	--上交的盛典令数量进行更新存盘
	local tbCounts = ScriptData:GetValue("ShengDianLingCount") or {}

	local nCount = tbCounts[me.dwID] or 0
	nCount = nCount + 1
	tbCounts[me.dwID] = nCount
	ScriptData:SaveValue("ShengDianLingCount", tbCounts)
	ScriptData:AddModifyFlag("ShengDianLingCount")
	
	local tbInfo = {}
	tbInfo.nTotalGoldCount = tbAct.SHOW_GOLD_COUNT
	tbInfo.nServerTotalCount = self:CalcShowTotalCount()
	tbInfo.nPlayerToalCount = nCount
	tbInfo.nRewardGoldCount = self:CalcRewardGoldCount(me.dwID)

	me.CallClientScript("Ui:OpenWindow","CeremonyPartitionGoldPanel")
	Log(string.format("PlayerID : %d hands in one ShengDianLing. Total ShengDianLingCount : %d", me.dwID, nCount))
end


tbAct.tbExtraAwardItem = {
	{
		[1] = "item",	--种类
		[2] = 9877,		--物品ID
		[3] = 1,		--物品数量
		[4] = nil,			--物品有效期
	}
}

function tbAct:SendExtraAward(_, nPlayerId)	--门派竞技16强、通天塔5层及以上的额外奖励
	if self.nState ~= self.START then
		return
	end
	local _, nEndTime = self:GetOpenTimeInfo()
	self.tbExtraAwardItem[1][4] = nEndTime
	--pPlayer.SendAward(self.tbExtraAwardItem, nil, nil, Env.LogWay_ShangShengDianActItem)
	local tbMail = {
		To = nPlayerId,
		From = XT("系統"),
		Title = "【我要上盛典】",
		Text = "    大俠剛剛是不是完成了一件驚天地泣鬼神的壯舉？有份獎勵不由自主地來找大俠了呢！",
		nLogReazon = Env.LogWay_ShangShengDianActItem,
		tbAttach = self.tbExtraAwardItem
	}
	Mail:SendSystemMail(tbMail)
end
