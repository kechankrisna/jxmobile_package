TeamBattle.SAVE_GROUP = 45;
TeamBattle.SAVE_DATE = 1;
TeamBattle.SAVE_USE_COUNT = 2;
TeamBattle.SAVE_HONOR = 3;

TeamBattle.SAVE_LAST_WEEK_DATE = 4;
TeamBattle.SAVE_LAST_WEEK_USE_COUNT = 5;

TeamBattle.SAVE_MONTHLY_INFO = 6;
TeamBattle.SAVE_MONTHLY_INFO_OLD = 7;
TeamBattle.SAVE_QUARTERLY_INFO = 8;
TeamBattle.SAVE_QUARTERLY_INFO_OLD = 9;
TeamBattle.SAVE_YEAR_INFO = 10;
TeamBattle.SAVE_YEAR_INFO_OLD = 11;
TeamBattle.SAVE_MONTHLY_TIP = 12;
TeamBattle.SAVE_QUARTERLY_TIP = 13;
TeamBattle.SAVE_YEAR_TIP = 14;

TeamBattle.TYPE_NORMAL = 1;
TeamBattle.TYPE_MONTHLY = 2;
TeamBattle.TYPE_QUARTERLY = 3;
TeamBattle.TYPE_YEAR = 4;

TeamBattle.szLeagueOpenTimeFrame = "OpenLevel109";

-- 月度赛开启时间，此处用于各种判断，不用做真正开启时间
TeamBattle.nMonthlyOpenWeek = 1;		--当月第几周
TeamBattle.nMonthlyOpenWeekDay = 3;		--周几
TeamBattle.nMonthlyOpenHour = 21;		--当日小时
TeamBattle.nMonthlyOpenMin = 0;			--当日分钟

-- 季度赛开启时间，此处用于各种判断，不用做真正开启时间
TeamBattle.nQuarterlyOpenMonth = 3;		--本季度第几个月
TeamBattle.nQuarterlyOpenWeek = -1;		--本月第几周
TeamBattle.nQuarterlyOpenWeekDay = 3;	--本周几
TeamBattle.nQuarterlyOpenHour = 21;		--当日小时
TeamBattle.nQuarterlyOpenMin = 0;		--当日分钟

-- 年度赛开启时间，此处用于各种判断，不用做真正开启时间
TeamBattle.nYearOpenMonth = 4;			--几月份
TeamBattle.nYearOpenWeek = -1;			--第几周
TeamBattle.nYearOpenWeekDay = 3;		--周几
TeamBattle.nYearOpenHour = 21;			--几点
TeamBattle.nYearOpenMin = 0;			--几分

TeamBattle.nMonthlyAddTitle = 7700;
TeamBattle.nQuarterlyAddTitle = 7701;
TeamBattle.nYearAddTitle = 7702;

TeamBattle.nFloor2Num = 32;			--2层队伍数量

TeamBattle.PRE_MAP_ID = 1040;		--准备场地图ID
TeamBattle.TOP_MAP_ID = 1047;		--七层地图ID
TeamBattle.TOP_MAP_ID_CROSS = 1057;		--八层地图ID

TeamBattle.tbTopPoint =
{
	{1794, 4044},
	{1804, 2505},
}

TeamBattle.nAddImitity = 20;		--结束后好友增加亲密度
TeamBattle.nTopMapTime = 20 * 60;	--顶层停留最大时间
TeamBattle.nPreMapTime = 5 * 60;	--准备场等待时间
TeamBattle.nMinLevel = 30;			--最小参与等级
TeamBattle.nMinTeamCount = 16;		--最小开启队伍数量
TeamBattle.nFightTime = 220;		--每轮耗时
TeamBattle.nTeamMemeber = 3;		--每个队伍玩家数量
TeamBattle.nMaxFightTimes = 5;		--战斗场次数
TeamBattle.nMaxFloor = 7;			--最大层数
TeamBattle.nMaxFloor_Cross = 8;			--跨服通天塔最大层数
TeamBattle.nTryStartCount = 1;		--最大尝试开启次数，不足16个队伍则再次等待一段时间后尝试开启，最大次数尝试后还是失败，则直接失败
TeamBattle.nDeathSkillState = 1520;	--死亡后状态

TeamBattle.nMaxTimes = 3;
TeamBattle.tbRefreshDay = {3, 6, 7};

TeamBattle.szCrossOpenTimeFrame = "OpenLevel89";

TeamBattle.szStartNotifyInfo = "Thông Thiên Tháp đã mở, các đại hiệp mau vượt tháp";
TeamBattle.szTopWorldNotify = "「%s」đã đến Thông Thiên Tháp tầng 7!";
TeamBattle.szTopWorldNotify_Cross = "「%s」đến được Thông Thiên Tháp Liên SV 8!";
TeamBattle.szTopKinNotify = "Thành viên「%s」đã đến Thông Thiên Tháp tầng 7!";
TeamBattle.szTopKinNotify_Cross = "「%s」trong bang đến được Thông Thiên Tháp Liên SV 8!";
TeamBattle.szCloseNotify = "Thông Thiên Tháp đã kết thúc!";

TeamBattle.tbLeagueTopWorldNotify =
{
	[TeamBattle.TYPE_MONTHLY] = "「%s」đã đạt đến tầng 8 Thông Thiên Tháp Tháng";
	[TeamBattle.TYPE_QUARTERLY] = "「%s」đã đạt đến tầng 8 Thông Thiên Tháp Quý";
	[TeamBattle.TYPE_YEAR] = "「%s」đã đạt đến tầng 8 Thông Thiên Tháp Năm";
}

TeamBattle.tbLeagueTopKinNotify =
{
	[TeamBattle.TYPE_MONTHLY] = "Thành viên bang「%s」đã đạt đến tầng 8 Thông Thiên Tháp Tháng";
	[TeamBattle.TYPE_QUARTERLY] = "Thành viên bang「%s」đã đạt đến tầng 8 Thông Thiên Tháp Quý";
	[TeamBattle.TYPE_YEAR] = "Thành viên bang「%s」đã đạt đến tầng 8 Thông Thiên Tháp Năm";
}

TeamBattle.tbLeagueCloseNotify = {
	[TeamBattle.TYPE_MONTHLY] = "Thông Thiên Tháp Tháng đã kết thúc!";
	[TeamBattle.TYPE_QUARTERLY] = "Thông Thiên Tháp Quý đã kết thúc!";
	[TeamBattle.TYPE_YEAR] = "Thông Thiên Tháp Năm đã kết thúc!";
}

TeamBattle.szTopNotifyCrossWin = "「%s」chỉ huy và diệt đội %s-「%s」trong Thông Thiên Tháp Liên SV thành công, đến được tầng 8";
TeamBattle.szTopNotifyCrossLost = "「%s」chỉ huy đội, bị %s-「%s」hạ gục , không thể đến tầng 8";

-- 亲密度
TeamBattle.tbAddImityInfo = {
	[0] = 40,
	[1] = 60,
	[2] = 80,
	[3] = 100,
	[4] = 120,
	[5] = 150,
};

TeamBattle.TeamBattlePanelDescribe =
{
	["Describe"] = [[● Tổ đội 3 người, tỉ thí nhóm 3V3
 - Bắt đầu từ tầng thấp nhất của Thông Thiên Tháp, mỗi lượt sẽ ghép đội ngẫu nhiên cùng tầng
 - Mỗi lượt khiêu chiến gồm trận đầu, trận sau. Đội tích lũy diệt nhiều nhất sẽ chiến thắng
● Người thắng sẽ vào tầng cao hơn để chiến đấu tiếp
● Người thua sẽ tiếp tục ở lại tầng đó để chiến đấu
 - Thông Thiên Tháp có 5 lượt, đội toàn thắng sẽ vào đến tầng 7! Nhận vinh dự cao nhất!
]],
}

-- 准备场出生点，可以配多个，随机取用
TeamBattle.tbPreMapBeginPos =
{
	{6374, 6891};
	{6403, 4430};
	{6403, 4430};
}

-- 战斗场地图配置,随机取用
TeamBattle.tbFightMapBeginPoint =
{
	[1] = {--一层
		--地图ID 	1队：   休息点			出生点 		2队：  休息点		出生点
		{1041, 			{{7960, 6783}, {2698, 5581}}, 		{{7905, 2076}, {2698, 3408}}},
	};
	[2] = {--二层
		--地图ID 	1队：   休息点			出生点 		2队：  休息点		出生点
		{1042, 			{{8283, 6090}, {3155, 3250}}, 		{{8277, 2106}, {3081,5504}}},
	};
	[3] = {--三层
		--地图ID 	1队：   休息点			出生点 		2队：  休息点		出生点
		{1043, 			{{6432, 5391}, {1340, 4845}}, 		{{6439, 1985}, {1402, 2526}}},
	};
	[4] = {--四层
		--地图ID 	1队：   休息点			出生点 		2队：  休息点		出生点
		{1044, 			{{7540, 6009}, {2274, 5082}}, 		{{7393, 1689}, {2311, 2921}}},
	};
	[5] = {--五层
		--地图ID 	1队：   休息点			出生点 		2队：  休息点		出生点
		{1045, 			{{7864, 6297}, {2691, 5381}}, 		{{7711, 2269}, {2720, 3155}}},
	};
	[6] = {--六层
		--地图ID 	1队：   休息点			出生点 		2队：  休息点		出生点
		{1046, 			{{8365, 6431}, {3260, 5244}}, 		{{8323, 1810}, {3304, 3066}}},
	};
	[7] = {--七层
		--地图ID 	1队：   休息点			出生点 		2队：  休息点		出生点
		{1056, 			{{8365, 6431}, {3260, 5244}}, 		{{8323, 1810}, {3304, 3066}}},
	};
}

TeamBattle.nAwardItemId = 2418;
TeamBattle.nAwardItemNeedHonor = 800;

-- 各层奖励
TeamBattle.tbAwardInfo =
{
	[1] = {
		{"BasicExp", 100};
		nTeamBattleHonor = 1000,
	};
	[2] = {
		{"BasicExp", 120};
		nTeamBattleHonor = 1100,
	};
	[3] = {
		{"BasicExp", 140};
		nTeamBattleHonor = 1200,
	};
	[4] = {
		{"BasicExp", 150};
		nTeamBattleHonor = 1500,
	};
	[5] = {
		{"BasicExp", 160};
		nTeamBattleHonor = 1800,
	};
	[6] = {
		{"BasicExp", 180};
		nTeamBattleHonor = 2100,
	};
	[7] = {
		{"BasicExp", 200};
		nTeamBattleHonor = 2400,
	};
	[8] = {
		{"BasicExp", 220};
		nTeamBattleHonor = 3000,
	};
}

-- 月度赛增加亲密度
TeamBattle.nLeagueAddImity = 100;

-- 联赛奖励内容
TeamBattle.tbLeagueAward = {
	[TeamBattle.TYPE_MONTHLY] = {
		[1] = {{"BasicExp", 100}, {"Energy", 1500}},
		[2] = {{"BasicExp", 120}, {"Energy", 1800}},
		[3] = {{"BasicExp", 140}, {"Energy", 2000}},
		[4] = {{"BasicExp", 150}, {"Energy", 2500}},
		[5] = {{"BasicExp", 160}, {"Energy", 3000}},
		[6] = {{"BasicExp", 180}, {"Energy", 4000}},
		[7] = {{"BasicExp", 200}, {"Energy", 5000}},
		[8] = {{"BasicExp", 220}, {"Energy", 7000}},
	};
	[TeamBattle.TYPE_QUARTERLY] = {
		[1] = {{"BasicExp", 100}, {"Energy", 3000}},
		[2] = {{"BasicExp", 120}, {"Energy", 3500}},
		[3] = {{"BasicExp", 140}, {"Energy", 4000}},
		[4] = {{"BasicExp", 150}, {"Energy", 5000}},
		[5] = {{"BasicExp", 160}, {"Energy", 6000}},
		[6] = {{"BasicExp", 180}, {"Energy", 8000}},
		[7] = {{"BasicExp", 200}, {"Energy", 10000}},
		[8] = {{"BasicExp", 220}, {"Energy", 15000}},
	};
	[TeamBattle.TYPE_YEAR] = {
		[1] = {{"BasicExp", 100}, {"Energy", 9000}},
		[2] = {{"BasicExp", 120}, {"Energy", 10500}},
		[3] = {{"BasicExp", 140}, {"Energy", 12000}},
		[4] = {{"BasicExp", 150}, {"Energy", 15000}},
		[5] = {{"BasicExp", 160}, {"Energy", 18000}},
		[6] = {{"BasicExp", 180}, {"Energy", 24000}},
		[7] = {{"BasicExp", 200}, {"Energy", 30000}},
		[8] = {{"BasicExp", 220}, {"Energy", 45000}, {"item", 7320, 1}, {"item", 7321, 1}},
	};
};

TeamBattle.tbStartFailMailInfo = {
	[TeamBattle.TYPE_MONTHLY] = {"Mở Thông Thiên Tháp-Tháng thất bại", "      Số người vào vòng chung cuộc Thông Thiên Tháp tháng này không đủ để tổ chức thi đấu, đại hiệp nhận được phần thưởng cao nhất.\n Hãy tiếp tục cố gắng, chờ đợi đối thủ xứng tầm tháng sau!"},
	[TeamBattle.TYPE_QUARTERLY] = {"Mở Thông Thiên Tháp-Quý thất bại", "      Số người vào vòng chung cuộc Thông Thiên Tháp quý này không đủ để tổ chức thi đấu, đại hiệp nhận được phần thưởng cao nhất.\n Hãy tiếp tục cố gắng, chờ đợi đối thủ xứng tầm quý sau!"},
	[TeamBattle.TYPE_YEAR] = {"Mở Thông Thiên Tháp-Năm thất bại", "      Số người vào vòng chung cuộc Thông Thiên Tháp mùa này không đủ để tổ chức thi đấu, đại hiệp nhận được phần thưởng cao nhất.\n Hãy tiếp tục cố gắng, chờ đợi đối thủ xứng tầm mùa sau!"},
};

TeamBattle.tbSpaceTipsMailInfo = {
	[TeamBattle.TYPE_MONTHLY] = {"Tham gia Thông Thiên Tháp-Tháng thất bại", "      Số đội tham gia Thông Thiên Tháp tháng này không đủ để tổ chức thi đấu, đại hiệp nhận được phần thưởng cao nhất.\n Hãy tiếp tục cố gắng, chờ đợi đối thủ xứng tầm tháng sau!"},
	[TeamBattle.TYPE_QUARTERLY] = {"Tham gia Thông Thiên Tháp-Quý thất bại", "      Số đội tham gia Thông Thiên Tháp quý này không đủ để tổ chức thi đấu, đại hiệp nhận được phần thưởng cao nhất.\n Hãy tiếp tục cố gắng, chờ đợi đối thủ xứng tầm quý sau!"},
	[TeamBattle.TYPE_YEAR] = {"Tham gia Thông Thiên Tháp-Năm thất bại", "      Số đội tham gia Thông Thiên Tháp mùa này không đủ để tổ chức thi đấu, đại hiệp nhận được phần thưởng cao nhất.\n Hãy tiếp tục cố gắng, chờ đợi đối thủ xứng tầm mùa sau!"},
}

TeamBattle.tbAwardMailInfo =
{
	[TeamBattle.TYPE_MONTHLY] = {"Quà Thông Thiên Tháp Tháng", "      Đại hiệp đạt đến tầng %s Thông Thiên Tháp Tháng lần này, được nhận thưởng sau: "},
	[TeamBattle.TYPE_QUARTERLY] = {"Quà Thông Thiên Tháp Quý", "      Đại hiệp đạt đến tầng %s Thông Thiên Tháp Quý lần này, được nhận thưởng sau: "},
	[TeamBattle.TYPE_YEAR] = {"Quà Thông Thiên Tháp Năm", "      Đại hiệp đạt đến tầng %s Thông Thiên Tháp Năm lần này, được nhận thưởng sau: "},
}

TeamBattle.nPreTipTime = 2 * 24 * 3600;			-- 开赛前提示，提前时间

-- 开赛前提示邮件
TeamBattle.tbLeagueTipMailInfo =
{
	[TeamBattle.TYPE_MONTHLY] = {"Thông Thiên Tháp Tháng", "      Đại hiệp nhận quyền tham dự Thông Thiên Tháp Tháng lần này. Thời gian thi đấu là [EACC00]%s[-], hãy đến đúng giờ. Nhiều phần thưởng và vinh dự đang chờ đại hiệp!"},
	[TeamBattle.TYPE_QUARTERLY] = {"Thông Thiên Tháp Quý", "      Đại hiệp nhận quyền tham dự Thông Thiên Tháp Quý lần này. Thời gian thi đấu là [EACC00]%s[-], hãy đến đúng giờ. Nhiều phần thưởng và vinh dự đang chờ đại hiệp!"},
	[TeamBattle.TYPE_YEAR] = {"Thông Thiên Tháp Năm", "      Đại hiệp nhận quyền tham dự Thông Thiên Tháp Năm lần này. Thời gian thi đấu là [EACC00]%s[-], hãy đến đúng giờ. Nhiều phần thưởng và vinh dự đang chờ đại hiệp!"},
}

-- 非程序勿动
TeamBattle.tbTipSaveValue =
{
	[TeamBattle.TYPE_MONTHLY] = TeamBattle.SAVE_MONTHLY_TIP,
	[TeamBattle.TYPE_QUARTERLY] = TeamBattle.SAVE_QUARTERLY_TIP,
	[TeamBattle.TYPE_YEAR] = TeamBattle.SAVE_YEAR_TIP,
}

TeamBattle.szStartMsg = "Dựa vào thực lực đội, lần này bắt đầu từ tầng %s";
TeamBattle.szJoinMsg = "Hiện là tầng %s, đã bắt đầu";
TeamBattle.szWinMsg = "Khiêu chiến thành công, lên tầng %s!";
TeamBattle.szFailMsg = "Thất bại, tiếp tục ở lại tầng %s!";
TeamBattle.szTopMsg = "Thông Thiên Tháp lần này đã lên tầng thứ %s!";

TeamBattle.STATE_TRANS =  --战场流程控制
{
	{nSeconds = 5,   	szFunc = "WaitePlayer",		szDesc = "Chờ mở"},
	{nSeconds = 5,   	szFunc = "ShowTeamInfo",	szDesc = "Chờ mở"},
	{nSeconds = 4,   	szFunc = "PreStart",		szDesc = "Chờ mở"},
	{nSeconds = 86,   	szFunc = "StartFight",		szDesc = "Hiệp đầu"},
	{nSeconds = 20,   	szFunc = "MidRest",			szDesc = "Nghỉ giữa trận"},
	{nSeconds = 4,   	szFunc = "PreStart",		szDesc = "Chờ mở"},
	{nSeconds = 86,   	szFunc = "StartFight",		szDesc = "Hiệp sau"},
	{nSeconds = 20,   	szFunc = "ClcResult",		szDesc = "Đợi ghép"},
}

TeamBattle.STATE_TRANS_CROSS =  --战场流程控制
{
	{nSeconds = 10,   	szFunc = "WaitePlayer",		szDesc = "Chờ mở"},
	{nSeconds = 5,   	szFunc = "ShowTeamInfo",	szDesc = "Chờ mở"},
	{nSeconds = 4,   	szFunc = "PreStart",		szDesc = "Chờ mở"},
	{nSeconds = 86,   	szFunc = "StartFight",		szDesc = "Hiệp đầu"},
	{nSeconds = 20,   	szFunc = "MidRest",			szDesc = "Nghỉ giữa trận"},
	{nSeconds = 4,   	szFunc = "PreStart",		szDesc = "Chờ mở"},
	{nSeconds = 86,   	szFunc = "StartFight",		szDesc = "Hiệp sau"},
	{nSeconds = 20,   	szFunc = "ClcResult",		szDesc = "Đợi ghép"},
}

TeamBattle.emMsgNotTeamCaptain		= 1;
TeamBattle.emMsgNotNeedTeam			= 2;
TeamBattle.emMsgNeedTeam			= 3;
TeamBattle.emMsgTeamMemeberErr		= 4;
TeamBattle.emMsgMemberOffline		= 5;
TeamBattle.emMsgMemberMinLevel		= 6;
TeamBattle.emMsgMemberSafeMap		= 7;
TeamBattle.emMsgMemberAloneState	= 8;
TeamBattle.emMsgMinLevel			= 9;
TeamBattle.emMsgSafeMap				= 10;
TeamBattle.emMsgAloneState			= 11;
TeamBattle.emMsgHasNoBattle			= 12;
TeamBattle.emMsgTimesErr			= 13;
TeamBattle.emMsgMemberTimesErr		= 14;
TeamBattle.emMsgHasFight			= 15;
TeamBattle.emMsgMemberNotSafePoint	= 16;
TeamBattle.emMsgNotSafePoint		= 17;
TeamBattle.emMsgSystemSwitch		= 18;
TeamBattle.emMsgMemberSystemSwitch	= 19;
TeamBattle.emMsgLeagueTicket		= 20;
TeamBattle.emMsgMemberLeagueTicket	= 21;
TeamBattle.emMsgMemberHasLeagueTicket	= 22;

TeamBattle.tbMsg =
{
	[TeamBattle.emMsgNotTeamCaptain]		= "Không là đội trưởng, không thể thao tác!";
	[TeamBattle.emMsgNotNeedTeam]			= "Đang trong đội, không thể báo danh cá nhân!";
	[TeamBattle.emMsgNeedTeam]				= "Không có đội, không thể tổ đội báo danh!";
	[TeamBattle.emMsgTeamMemeberErr]		= "Dạng đội tối đa %s người được báo danh!";
	[TeamBattle.emMsgMemberOffline]			= "Có thành viên không online, không thể báo danh!";
	[TeamBattle.emMsgMemberMinLevel]		= "「%s」chưa đạt Lv%s, không thể báo danh!";
	[TeamBattle.emMsgMemberSafeMap]			= "「%s」ở bản đồ không thể báo danh!";
	[TeamBattle.emMsgMemberAloneState]		= "「%s」đang tham gia hoạt động khác, không thể báo danh!";
	[TeamBattle.emMsgMinLevel]				= "Chưa đạt cấp %s, không thể ham gia!";
	[TeamBattle.emMsgSafeMap]				= "Bản đồ hiện tại không thể báo danh!";
	[TeamBattle.emMsgAloneState]			= "Đang tham gia hoạt động khác, chờ kết thúc rồi báo danh!";
	[TeamBattle.emMsgHasNoBattle]			= "Hoạt động chưa mở!";
	[TeamBattle.emMsgTimesErr]				= "Số lần tham gia không đủ!";
	[TeamBattle.emMsgLeagueTicket]			= "Chưa có tư cách tham gia!";
	[TeamBattle.emMsgMemberTimesErr]		= "Số lần tham gia「%s」không đủ!";
	[TeamBattle.emMsgMemberLeagueTicket]	= "「%s」chưa nhận tư cách dự giải, không thể tham gia.";
	[TeamBattle.emMsgMemberHasLeagueTicket]	= "「%s」đang có tư cách dự giải, không thể tham gia Thông Thiên Tháp Liên SV.";
	[TeamBattle.emMsgHasFight]				= "Thông Thiên Tháp lần này đã mở, lần sau hãy đến";
	[TeamBattle.emMsgMemberNotSafePoint]	= "「%s」không ở khu an toàn, không thể báo danh!";
	[TeamBattle.emMsgNotSafePoint]			= "Không ở khu an toàn, không thể báo danh";
	[TeamBattle.emMsgSystemSwitch]			= "Trạng thái hiện tại không được báo danh";
	[TeamBattle.emMsgMemberSystemSwitch]	= "「%s」trạng thái hiện tại không được báo danh";
}

-- 通天塔奖励配置
TeamBattle.tbReward =
{

	{"Item", 1346, 1},
	{"Item", 1736, 1},
	{"Contrib", 0},

}

-- 是否不开放年度通天塔
TeamBattle.bNotOpenYear = true

TeamBattle.nDelayLimitFloorFight = 25
TeamBattle.nDelayStartCrossFight = 10
TeamBattle.nDelayCrossFight = 3

function TeamBattle:RefreshTimes(pPlayer)
	local nUsedTimes = pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_USE_COUNT);
	local nLastWeekUseCount = pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_LAST_WEEK_USE_COUNT);
	local nSaveDate = pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_DATE);
	local nWeek = Lib:GetLocalWeek();

	if pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_LAST_WEEK_DATE) ~= nWeek - 1 then
		nLastWeekUseCount = self.nMaxTimes;

		if nSaveDate == nWeek - 1 then
			nLastWeekUseCount = nUsedTimes;
		elseif nSaveDate > 0 and nSaveDate < nWeek - 1 then
			nLastWeekUseCount = 0;
		end
		if MODULE_GAMESERVER then
			pPlayer.SetUserValue(self.SAVE_GROUP, self.SAVE_LAST_WEEK_USE_COUNT, nLastWeekUseCount);
			pPlayer.SetUserValue(self.SAVE_GROUP, self.SAVE_LAST_WEEK_DATE, nWeek - 1);
		end
	end

	if nSaveDate ~= nWeek then
		if MODULE_GAMESERVER then
			pPlayer.SetUserValue(self.SAVE_GROUP, self.SAVE_DATE, nWeek);
			pPlayer.SetUserValue(self.SAVE_GROUP, self.SAVE_USE_COUNT, 0);
		end
		nUsedTimes = 0;
	end

	return nUsedTimes, nLastWeekUseCount;
end

function TeamBattle:GetLastTimes(pPlayer)
	local nCostTimes, nLastWeekUseCount = self:RefreshTimes(pPlayer);
	local nMaxTimes = 0;
	local nWeekDay = Lib:GetLocalWeekDay();
	for _, nWDay in pairs(self.tbRefreshDay) do
		if nWDay <= nWeekDay then
			nMaxTimes = nMaxTimes + 1;
		end
	end

	local nLastWeekMaxTimes = math.min(self.nMaxTimes, #self.tbRefreshDay);

	-- 开了攻城战后会周六少开一场
	if GetTimeFrameState("OpenDomainBattle") == 1 then
		nMaxTimes = nMaxTimes - 1;
		nLastWeekMaxTimes = nLastWeekMaxTimes - 1;

		-- 恰好是周日开启攻城战的时间轴，本周六已过，此时攻城战不开，那么本周六还是正常开，所以还有3场
		if nWeekDay == 7 then
			local nOpenTime = CalcTimeFrameOpenTime("OpenDomainBattle");
			local nOpenDay = Lib:GetLocalDay(nOpenTime);
			if nOpenDay == Lib:GetLocalDay() then
				nMaxTimes = nMaxTimes + 1;
			end
		elseif nWeekDay < 6 then
			nMaxTimes = nMaxTimes + 1;
		end
	end

	nMaxTimes = math.min(nMaxTimes, self.nMaxTimes);

	local nLastTimes = nMaxTimes - nCostTimes;
	nLastTimes = math.max(nLastTimes, 0);


	return nLastTimes, nMaxTimes, math.max(nLastWeekMaxTimes - nLastWeekUseCount, 0);
end

function TeamBattle:CostTimes(pPlayer)
	self:RefreshTimes(pPlayer);
	local nCurUseCount = pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_USE_COUNT);
	pPlayer.SetUserValue(self.SAVE_GROUP, self.SAVE_USE_COUNT, math.max(nCurUseCount + 1, 1));
	self:OnPlayedTeamBattle(pPlayer)	
end

function TeamBattle:OnPlayedTeamBattle(pPlayer)
	Achievement:AddCount(pPlayer, "TeamBattle_1", 1);
	TeacherStudent:CustomTargetAddCount(pPlayer, "Tower", 1)
end

function TeamBattle:SendMsgCode(player, nCode, ...)
	local pPlayer = player;
	if type(player) == "number" then
		pPlayer = KPlayer.GetPlayerObjById(player);
	end
	if not pPlayer then
		return;
	end

	if type(nCode) == "string" then
		pPlayer.CenterMsg(nCode)
		return
	end

	pPlayer.CallClientScript("TeamBattle:MsgCode", nCode, ...);
end

function TeamBattle:CheckTicket(pPlayer, nType, nTime)
	nTime = nTime or GetTime();
	local nNextOpenTime = self:GetNextOpenTime(nType, nTime);
	if nType == self.TYPE_MONTHLY then
		local nCheckMonth = Lib:GetLocalMonth(nNextOpenTime);
		nCheckMonth = nCheckMonth - 1;
		if pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_MONTHLY_INFO) == nCheckMonth or
			pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_MONTHLY_INFO_OLD) == nCheckMonth then

			return true;
		end
	elseif nType == self.TYPE_QUARTERLY then
		local nLocalSeason = Lib:GetLocalSeason(nNextOpenTime);
		if pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_QUARTERLY_INFO) == nLocalSeason or
			pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_QUARTERLY_INFO_OLD) == nLocalSeason then

			return true;
		end
	elseif nType == self.TYPE_YEAR then
		local nLocalYear = Lib:GetLocalYear(nNextOpenTime);
		nLocalYear = nLocalYear - 1;
		if pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_YEAR_INFO) == nLocalYear or
			pPlayer.GetUserValue(self.SAVE_GROUP, self.SAVE_YEAR_INFO_OLD) == nLocalYear then

			return true;
		end
	end

	return false;
end

function TeamBattle:GetNextOpenTime(nType, nTime)
	if not MODULE_ZONESERVER and GetTimeFrameState(TeamBattle.szLeagueOpenTimeFrame) ~= 1 then
		return nil;
	end

	local nNow = nTime or GetTime();
	if nType == self.TYPE_MONTHLY then
		local nOpenTime = Lib:GetTimeByWeekInMonth(nNow, TeamBattle.nMonthlyOpenWeek, TeamBattle.nMonthlyOpenWeekDay, TeamBattle.nMonthlyOpenHour, TeamBattle.nMonthlyOpenMin, 0);
		if nOpenTime < nNow then
			local tbTime = os.date("*t", nOpenTime);
			tbTime.month = tbTime.month + 1;
			if tbTime.month > 12 then
				tbTime.month = 1;
				tbTime.year = tbTime.year + 1;
			end

			nOpenTime = os.time(tbTime);
			nOpenTime = Lib:GetTimeByWeekInMonth(nOpenTime, TeamBattle.nMonthlyOpenWeek, TeamBattle.nMonthlyOpenWeekDay, TeamBattle.nMonthlyOpenHour, TeamBattle.nMonthlyOpenMin, 0);
		end

		return nOpenTime;
	elseif nType == self.TYPE_QUARTERLY then
		local tbTime = os.date("*t", nNow);
		local nOpenMonth = math.ceil(tbTime.month / 3) * 3;
		if nOpenMonth ~= tbTime.month then
			tbTime.month = nOpenMonth;
			tbTime.day = 1;
			tbTime.hour = 0;
			tbTime.min = 0;
		end

		local nTime = os.time(tbTime);
		local nOpenTime = Lib:GetTimeByWeekInMonth(nTime, TeamBattle.nQuarterlyOpenWeek, TeamBattle.nQuarterlyOpenWeekDay, TeamBattle.nQuarterlyOpenHour, TeamBattle.nQuarterlyOpenMin, 0);
		if nOpenTime < nNow then
			tbTime.month = nOpenMonth + 3;
			if tbTime.month > 12 then
				tbTime.year = tbTime.year + 1;
				tbTime.month = 3;
			end
		end

		nTime = os.time(tbTime);
		nOpenTime = Lib:GetTimeByWeekInMonth(nTime, TeamBattle.nQuarterlyOpenWeek, TeamBattle.nQuarterlyOpenWeekDay, TeamBattle.nQuarterlyOpenHour, TeamBattle.nQuarterlyOpenMin, 0);
		assert(nOpenTime > nNow);

		return nOpenTime;
	elseif nType == self.TYPE_YEAR then
		local tbTime = os.date("*t", nNow);
		tbTime.month = TeamBattle.nYearOpenMonth;
		tbTime.day = 1;
		tbTime.hour = 0;
		tbTime.min = 0;

		local nTime = os.time(tbTime);
		local nOpenTime = Lib:GetTimeByWeekInMonth(nTime, TeamBattle.nYearOpenWeek, TeamBattle.nYearOpenWeekDay, TeamBattle.nYearOpenHour, TeamBattle.nYearOpenMin, 0);
		if nOpenTime < nNow then
			tbTime.year = tbTime.year + 1;
		end

		nTime = os.time(tbTime);
		nOpenTime = Lib:GetTimeByWeekInMonth(nTime, TeamBattle.nYearOpenWeek, TeamBattle.nYearOpenWeekDay, TeamBattle.nYearOpenHour, TeamBattle.nYearOpenMin, 0);
		assert(nOpenTime > nNow);

		return nOpenTime;
	end
end