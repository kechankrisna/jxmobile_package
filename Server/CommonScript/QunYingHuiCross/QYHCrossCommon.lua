QunYingHuiCross.nPreMapTID = 1008 					-- 准备场地图
QunYingHuiCross.nFightMapTID = 1009 				-- 战斗场地图
QunYingHuiCross.nJoinLevel = 70 					-- 参加等级
QunYingHuiCross.nChooseFaction = 8 					-- 可选门派数量
QunYingHuiCross.MIN_DISTANCE = 1000 				-- 参加队友之间距离
QunYingHuiCross.nRequestChooseFactionTime = 10 		-- 请求选门派参加倒计时
QunYingHuiCross.nFightPlayerNum = 2 				-- 暂只支持2VS2(暂不兼容其他数量的对战)
QunYingHuiCross.nMaxFight = 16 						-- 活动期间最多可以打几场
QunYingHuiCross.szOpenTimeFrame = "OpenLevel79" 	-- 活动开启时间轴
-- 模式
QunYingHuiCross.TYPE_NONE = 0 						-- 无模式
QunYingHuiCross.TYPE_SINGLE = 1 					-- 单人
QunYingHuiCross.TYPE_TEAM = 2 						-- 组队
-- 状态
QunYingHuiCross.STATE_NONE = 0 						-- 无状态
QunYingHuiCross.STATE_MATCHING = 1 					-- 匹配中
QunYingHuiCross.STATE_FIGHT = 2 					-- 战斗中

-- 匹配状态
QunYingHuiCross.MATCH_NONE = 0 						-- 无状态
QunYingHuiCross.MATCH_OPEN = 1 						-- 开放匹配
QunYingHuiCross.MATCH_CLOSE = 2 					-- 关闭匹配
QunYingHuiCross.MATCH_END = 3 						-- 结算完成

QunYingHuiCross.nMatchTime = 20 					-- 每n秒进行一次匹配

QunYingHuiCross.nNearFightCount = 2 				-- 近两场未打过的优先
QunYingHuiCross.nNotMatchWarnTime = 60 				-- 多久未进行匹配给提示
QunYingHuiCross.nWaitFightTime = 3 				    -- 匹配完成之后等待多久开始战斗(暂时不需要延迟不配置)
QunYingHuiCross.nDeathSkillState = 1520 			-- 死亡状态
QunYingHuiCross.nDealyLeaveTime = 10 				-- 延迟几秒离开对战地图，为了显示结果
QunYingHuiCross.nTeamInfoStayTime = 7 				-- 对战结果界面显示几秒(不要大于延迟离开地图的时间nDealyLeaveTime)
QunYingHuiCross.nRankRefreshTime = 40 				-- 排行刷新间隔时间
QunYingHuiCross.nKeepTeamWaitTime = 7 				-- 请求继续组队战斗时间
QunYingHuiCross.nShowRankNum = 50 		 			-- 排行显示个数
QunYingHuiCross.tbPreMapEnterPos = {{2685, 5673}, {6856, 6638}, {6856, 4806}, {3060, 6968}, {3060, 4467}, {7797, 5713}}     -- 准备场进入点
QunYingHuiCross.nChooseFactionTime = 60 			-- 选择门派时间
QunYingHuiCross.szStartMatchTip = "Bắt đầu ghép"
QunYingHuiCross.szQuiteMatchTip = "Hủy ghép"
QunYingHuiCross.szStopMatchNotice = "Hoạt động đã kết thúc, hãy chờ tổng kết" 			-- 停止匹配公告、停止匹配的公告内容
-- 界面显示奖励
QunYingHuiCross.nShowWinCount = 1 										 -- n胜
QunYingHuiCross.nShowJoinCount = 10 						   			 -- n战
QunYingHuiCross.tbFightStartPos = 
{
	{{{1985, 1379}, 60}, {{2425, 1379}, 60}};
	{{{1985, 3057}, 30}, {{2425, 3057}, 30}};
}
-- 打斗场流程
QunYingHuiCross.STATE_TRANS = 												--擂台流程控制
{

	{nSeconds = 2,   	szFunc = "PlayerReady",			szDesc = "Chuẩn bị"},
	{nSeconds = 5,   	szFunc = "ShowTeamInfo",		szDesc = "Chuẩn bị"},
	{nSeconds = 3,   	szFunc = "StartCountDown",		szDesc = "Chuẩn bị"},
	{nSeconds = 150,    szFunc = "StartFight",			szDesc = "Bắt đầu"},
	{nSeconds = 3,   	szFunc = "ClcResult",			szDesc = "Tổng kết"},
}

QunYingHuiCross.PRE_STATE_WAITMATCH = 1 				-- 等待活动开启
QunYingHuiCross.PRE_STATE_STARTMATCH = 2 				-- 匹配剩余时间
QunYingHuiCross.PRE_STATE_STOPMATCH = 3 				-- 等待活动结算
QunYingHuiCross.PRE_STATE_ENDACT = 4 					-- 活动已结束
-- 准备场流程
QunYingHuiCross.PRE_STATE_TRANS = 												--擂台流程控制
{

	{nSeconds = 60,   szFunc = "WaitMatch",		nType = QunYingHuiCross.PRE_STATE_WAITMATCH},
	{nSeconds = 20*60, szFunc = "StartMatch",	nType = QunYingHuiCross.PRE_STATE_STARTMATCH},
	{nSeconds = 2*60,   szFunc = "StopMatch",	nType = QunYingHuiCross.PRE_STATE_STOPMATCH},
	{nSeconds = 30,   szFunc = "EndAct",		nType = QunYingHuiCross.PRE_STATE_ENDACT},
	{nSeconds = 3,    szFunc = "KickOutPlayer",	nType = QunYingHuiCross.PRE_STATE_ENDACT},
}

QunYingHuiCross.NPC_SETTING = 
{
	-- {nNpcTId = 2827, nNpcLevel = 1, tbPos = {1735, 2857}, nSkillId = nil};
	-- {nNpcTId = 2827, nNpcLevel = 1, tbPos = {2575, 2857}, nSkillId = nil};
	-- {nNpcTId = 2827, nNpcLevel = 1, tbPos = {1735, 1279}, nSkillId = nil};
	-- {nNpcTId = 2827, nNpcLevel = 1, tbPos = {2575, 1279}, nSkillId = nil};
	-- {nNpcTId = 2827, nNpcLevel = 1, tbPos = {1303, 1735}, nSkillId = nil};
	-- {nNpcTId = 2827, nNpcLevel = 1, tbPos = {1303, 2575}, nSkillId = nil};
	-- {nNpcTId = 2827, nNpcLevel = 1, tbPos = {2987, 1735}, nSkillId = nil};
	-- {nNpcTId = 2827, nNpcLevel = 1, tbPos = {2987, 2575}, nSkillId = nil};
}

QunYingHuiCross.NPC_TRANS = 												--擂台流程控制
{

	-- {nSeconds = 30,   	szFunc = "PlayerReady",		tbParam = {nCount = 1}},
	-- {nSeconds = 30,   	szFunc = "RandomNpc",		tbParam = {nCount = 1}},
	-- {nSeconds = 30,   	szFunc = "RandomNpc",		tbParam = {nCount = 1}},
	-- {nSeconds = 30,     szFunc = "RandomNpc",		tbParam = {nCount = 1}},
	-- {nSeconds = 3,      szFunc = "RandomNpc",		tbParam = {nCount = 1}},
}

QunYingHuiCross.tbFightWinAward = {{"item", 2424, 2}, {"BasicExp", 15}}; -- 参与胜场奖励
QunYingHuiCross.tbFightLostAward = {{"item", 2424, 1}, {"BasicExp", 10}};-- 参与败场奖励
QunYingHuiCross.tbWinAward = 						  					-- n胜奖励
{
	{nCount = QunYingHuiCross.nShowWinCount; tbAward = {{"ZhenQi", 500}}};
}
QunYingHuiCross.tbWinAwardIdx = {}
for _, v in ipairs(QunYingHuiCross.tbWinAward) do
	QunYingHuiCross.tbWinAwardIdx[v.nCount] = v.tbAward
end
QunYingHuiCross.tbJoinAward = 						  					-- n场奖励
{
	{nCount = QunYingHuiCross.nShowJoinCount; tbAward = {{"ZhenQi", 500}}};
}
QunYingHuiCross.tbJoinAwardIdx = {}
for _, v in ipairs(QunYingHuiCross.tbJoinAward) do
	QunYingHuiCross.tbJoinAwardIdx[v.nCount] = v.tbAward
end
QunYingHuiCross.tbRankAward = 						  					-- 排名奖励
{
	{nRank = 1; tbAward = {{"item", 7380, 8}}};
	{nRank = 10; tbAward = {{"item", 7380, 5}}};
	{nRank = 50; tbAward = {{"item", 7380, 3}}};
	{nRank = 100; tbAward = {{"item", 7380, 2}}};
	{nRank = 200; tbAward = {{"item", 7380, 1}}};
}
QunYingHuiCross.tbJoinAVAward = {{"ZhenQi", 500}}   -- 上榜奖励 N名以下（包括N名）的奖励
QunYingHuiCross.tbContinueWinTip =  								    -- 连胜公告
{
	[5] = {szKinMsg = "Thành viên [FFFE0D]「%s」[-] trong Quần Anh Hội [FFFE0D]thắng 5 trận liên tục[-]!#49"};
	[10] = {szKinMsg = "Thành viên [FFFE0D]「%s」[-] trong Quần Anh Hội [FFFE0D]thắng 10 trận liên tục[-]!#49#49"};
	[20] = {szKinMsg = "Thành viên [FFFE0D]「%s」[-] trong Quần Anh Hội [FFFE0D]thắng 20 trận liên tục[-]!#49#49#49"};
}
QunYingHuiCross.tbRankNotify =  										-- 第n名世界公告
{
	{nRank = 1; szMsg = "Chúc mừng [FFFE0D]「%s」[-] trong Quần Anh Hội đạt [FFFE0D]hạng 1[-]!";};
}
QunYingHuiCross.nRankKinMsg = 10 										-- 前n名家族公告
QunYingHuiCross.szRankKinMsg = "Chúc mừng [FFFE0D]「%s」[-] trong Quần Anh Hội đạt [FFFE0D]hạng %d[-]!#49#49#49"

QunYingHuiCross.nNewInfoShowRank = 50 									-- 最新消息最大显示n名
QunYingHuiCross.nNewInfoValidTime = 3 * 3600 * 24 						-- 最新消息过期时间
QunYingHuiCross.tbRankRedBag = { 										-- 排名红包id
	[1] = 99;
}
QunYingHuiCross.szStartWorldNotify = "Quần Anh Hội đã mở, các vị đại hiệp hãy vào phần Lịch hoạt động báo danh!"
-- 季度赛扩展
QunYingHuiCross.TYPE_NORMAL = 1
-- 无差别配置(需要至少配一个默认的最小时间轴的配置)
QunYingHuiCross.tbAvatar =
{
	["OpenLevel39"] =
	{
		nLevel = 69,
		szEquipKey = "ZhaoQin69",
		szInsetKey = "ZhaoQin69",
		nStrengthLevel = 50,
		tbBookType = {1,2,3,4},
	},

	["OpenLevel69"] =
	{
		nLevel = 69,
		szEquipKey = "ZhaoQin69",
		szInsetKey = "ZhaoQin69",
		nStrengthLevel = 50,
		tbBookType = {1,2,3,4},
	},

	["OpenLevel79"] =
	{
		nLevel = 79,
		szEquipKey = "ZhaoQin79",
		szInsetKey = "ZhaoQin79",
		nStrengthLevel = 60,
		tbBookType = {5,6,7,8},
	},

	["OpenLevel89"] =
	{
		nLevel = 89,
		szEquipKey = "ZhaoQin89",
		szInsetKey = "ZhaoQin89",
		nStrengthLevel = 70,
		tbBookType = {5,6,7,8},
	},

	["OpenLevel99"] =
	{
		nLevel = 99,
		szEquipKey = "ZhaoQin99",
		szInsetKey = "ZhaoQin99",
		nStrengthLevel = 80,
		tbBookType = {9,10,11,12},
	},
	
	["OpenLevel109"] =
	{
		nLevel = 109,
		szEquipKey = "ZhaoQin109",
		szInsetKey = "ZhaoQin109",
		nStrengthLevel = 90,
		tbBookType = {9,10,11,12},
	},
}

QunYingHuiCross.tbDefaultAvatar = 
{
	nLevel = 50,
	szEquipKey = "InDiffer",
	szInsetKey = "InDiffer",
	nStrengthLevel = 50,
}

QunYingHuiCross.tbRelateUi ={"QYHChoicePanel", "ChatLargePanel", "ArenaBattleInfo", "ArenaAccount", "QYHLeavePanel", "QYHMatchingPanel", "MessageBox"}

QunYingHuiCross.tbShowAward = {
	{{"ZhenQi", 500}, "[FFFE0D]Mục tiêu-Thắng lần đầu[-]\nGiành 1 trận thắng\nChân Khí x500"};
	{{"ZhenQi", 500}, "[FFFE0D]Mục tiêu-10 trận[-]\nHoàn thành 10 trận\nChân Khí x500"};	
	{{"item", 2424, 1}, "[FFFE0D]Phần thưởng-Thắng[-]\nTín Vật Môn Phái x2\nNhiều EXP"};
	{{"item", 2424, 1}, "[FFFE0D]Phần thưởng-Thua[-]\nTín Vật Môn Phái x1\nNhiều EXP"};	
	{{"item", 7380, 1}, "[FFFE0D]Thưởng hạng[-]\nRương Hoàng Kim Quần Anh Hội"};
}

QunYingHuiCross.tbAchievement = {
	[1] = "QunYingHui_1";
    [3] = "QunYingHui_2";
    [6] = "QunYingHui_3";
}

-- 战斗系数
QunYingHuiCross.nPkDmgRate = 50
QunYingHuiCross.nMaxFightTeamPerRound = 200 																			-- 每轮最多匹配多少队（偶数）
QunYingHuiCross.nMaxFightPlayerPerRound = QunYingHuiCross.nFightPlayerNum * QunYingHuiCross.nMaxFightTeamPerRound 		-- 每轮最多匹配多少人
function QunYingHuiCross:CheckCommonJoin(pPlayer)
	if pPlayer.nLevel < QunYingHuiCross.nJoinLevel then
		return false, string.format("「%s」 chưa đạt cấp báo danh [FFFE0D]%d[-]", pPlayer.szName, QunYingHuiCross.nJoinLevel)
	end
	-- if not Map:IsCityMap(pPlayer.nMapTemplateId) then
	-- 	return false, string.format("「%s」不在安全区，无法参加", pPlayer.szName)
	-- end
	if Map:IsFieldFightMap(pPlayer.nMapTemplateId) and pPlayer.nFightMode == 1 then
		return false, string.format("%s hiện không được tham gia, hãy quay lại khu an toàn", pPlayer.szName)
	end
	if Map:IsHouseMap(pPlayer.nMapTemplateId) or pPlayer.nMapTemplateId == Kin.Def.nKinMapTemplateId then
		return false, string.format("Khu vực của %s không được tham gia", pPlayer.szName)
	end
	return true
end

function QunYingHuiCross:RankReward(nRank)
	local tbAllReward = {}
	for _, v in ipairs(QunYingHuiCross.tbRankAward) do
		if nRank <= v.nRank and v.tbAward then
			tbAllReward = v.tbAward
			break
		end
	end
	return tbAllReward
end

function QunYingHuiCross:FormatReward(tbAllReward)
	tbAllReward = tbAllReward or {}

	local tbFormatReward = {}
	for _, tbReward in ipairs(tbAllReward) do
		local tbTempReward
		if tbReward[1] == "AddTimeTitle" then
			tbTempReward = Lib:CopyTB(tbReward) 
			tbTempReward[3] = tbTempReward[3] + GetTime()
		end
		table.insert(tbFormatReward, tbTempReward or tbReward)
	end

	return tbFormatReward
end

function QunYingHuiCross:GetTimesAward(tbAward, nTimes)
	local tbTimesAward = Lib:CopyTB(tbAward or {})
	for _, v in ipairs(tbTimesAward) do
		if v[1] then
			if v[1] == "item" or v[1] == "Item" then
				v[3] = v[3] * nTimes
			elseif v[1] == "BasicExp" then
				v[2] = v[2] * nTimes
			end
		end
	end
	return tbTimesAward
end

function QunYingHuiCross:GetWinAward(nWin)
	for nId, v in ipairs(self.tbWinAward) do
		if v.nCount == nWin then
			return v.tbAward, nId
		end
	end
end

function QunYingHuiCross:GetJoinAward(nJoin)
	for nId, v in ipairs(self.tbJoinAward) do
		if v.nCount == nJoin then
			return v.tbAward, nId
		end
	end
end

function QunYingHuiCross:CheckFaction(nFaction)
	if not nFaction or nFaction <= 0 or nFaction > Faction.MAX_FACTION_COUNT then
        return false, "Chưa rõ môn phái"
    end
    return true
end

function QunYingHuiCross:GetAwardDes(nCount, tbAward)
	local szContent = ""
	local tbDes = {}
	for _, v in ipairs(tbAward) do
		local szDes
		if v[1] then
			if v[1] == "item" or v[1] == "Item" then
				local szItemName = KItem.GetItemShowInfo(v[2])
				if szItemName then
					szDes = string.format("%s*%d", szItemName, nCount * v[3])
				end
			elseif v[1] == "BasicExp" or v[1] == "Exp" or v[1] == "exp" then
				szDes = "Nhiều EXP"
			end
		end
		if szDes then
			table.insert(tbDes, szDes)
		end
	end
	if next(tbDes) then
		szContent = table.concat(tbDes, ", ")
	end
	return szContent
end

function QunYingHuiCross:CheckOpen()
	if GetTimeFrameState(QunYingHuiCross.szOpenTimeFrame) ~= 1 then
		return false
	end
	return true
end

function QunYingHuiCross:GetFightDes(nWinCount, nFightCount)
	local szWinDes = ""
	for nWin = 1, nWinCount do
		if QunYingHuiCross.tbWinAwardIdx[nWin] then
			if not Lib:IsEmptyStr(szWinDes) then
				szWinDes = szWinDes ..","
			end
			local szWin = ""
			if nWin == 1 then
				szWin = "Thắng lần đầu"
			else
				szWin = string.format("Phần thưởng %s thắng", Lib:Transfer4LenDigit2CnNum(nWin))
			end
			szWinDes = szWinDes ..szWin
		end
	end
	if not Lib:IsEmptyStr(szWinDes) then
		szWinDes = "[FFFE0D]" ..szWinDes .."[-]"
	end
	local szFightDes = ""
	for nFight = 1, nFightCount do
		if QunYingHuiCross.tbJoinAwardIdx[nFight] then
			if not Lib:IsEmptyStr(szFightDes) then
				szFightDes = szFightDes ..","
			end
			local szFight = ""
			if nFight == 1 then
				szFight = "Phần thưởng chiến đầu"
			else
				szFight = string.format("Phần thưởng trận chiến %s", Lib:Transfer4LenDigit2CnNum(nFight))
			end
			szFightDes = szFightDes ..szFight
		end
	end
	if not Lib:IsEmptyStr(szFightDes) then
		szFightDes = "[FFFE0D]" ..szFightDes .."[-]"
	end
	local szDes = szWinDes ..szFightDes
	if not Lib:IsEmptyStr(szFightDes) and not Lib:IsEmptyStr(szWinDes) then
		szDes = szWinDes .." và " ..szFightDes
	end
	return szDes
end

function QunYingHuiCross:CombineUniqId(nServerId, dwID)
	return Lib:CombineUniqId(nServerId, dwID)
end

function QunYingHuiCross:RestoreUniqId(nUniqId)
	return Lib:RestoreUniqId(nUniqId)
end