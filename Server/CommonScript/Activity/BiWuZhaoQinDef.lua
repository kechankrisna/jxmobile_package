BiWuZhaoQin.SAVE_GROUP = 125;
BiWuZhaoQin.INDEX_LAST_DATE = 1;
BiWuZhaoQin.INDEX_ID = 2;

BiWuZhaoQin.nOpenZhaoQinCD = 3;		--两次招亲的时间间隔（单位：天）

BiWuZhaoQin.nCostGold_TypeGlobal = 5000;		-- 开启全服招亲消耗元宝
BiWuZhaoQin.nCostGold_TypeKin = 3000;			-- 开启家族招亲消耗元宝

BiWuZhaoQin.nMinPlayerLevel = 50;	-- 招亲活动最低等级限制

BiWuZhaoQin.nTitleId = 6200;			-- 情缘称号ID
BiWuZhaoQin.nTitleNameMin = 3;		-- 最小称号长度
BiWuZhaoQin.nTitleNameMax = 6;		-- 最大称号长度
BiWuZhaoQin.nVNTitleNameMin = 4;	-- 越南版最小称号长度
BiWuZhaoQin.nVNTitleNameMax = 20;	-- 越南版最大称号长度

BiWuZhaoQin.nTHTitleNameMin = 3;	-- 泰国版最小称号长度
BiWuZhaoQin.nTHTitleNameMax = 16;	-- 泰国版最大称号长度

-- 开启招亲的UI内容
BiWuZhaoQin.szUiDesc = [[
·[FFFE0D]Thời gian[-]: 10:00 07/03/2018 - 21:30 01/04/2018
· Mở Tỉ Võ Chiêu Thân, hệ thống sẽ tự động sắp xếp, [FFFE0D]20:30[-] mỗi chủ nhật sẽ thi đấu. [FFFE0D]Số trận mở có hạn, sau khi sắp xếp đủ sẽ không được đặt nữa.[-]
·Khi bắt đầu báo danh, người chơi có thể tìm Yên Nhược Tuyết tham gia thi đấu, tối đa cho phép [FFFE0D]128 người[-] tham gia.
·Người không tham gia có thể tìm Yên Nhược Tuyết để vào [FFFE0D]xem chiến đấu[-].
·Quán Quân có thể nhận [FFFE0D]Vật Định Tình[-], dùng đạo cụ này để kết duyên với người mở Tỉ Võ Chiêu Thân
·Hình thức thi đấu [FFFE0D]không có Ngũ Hành tương khắc[-], sức mạnh nhân vật do hệ thống thiết lập.
]]

-- 最新消息标题
BiWuZhaoQin.szNewInfomationTitle = "Tỉ Võ Chiêu Thân";
-- 最新消息内容
BiWuZhaoQin.szNewInfomation = [[[FFFE0D]Tỉ Võ Chiêu Thân đã bắt đầu![-]

[FFFE0D]Thời gian:[-] 10:00 07/03/2018 - 21:30 01/04/2018
[FFFE0D]Tham gia:[-] Lv50
      Tỉ Võ Chiêu Thân là thi đấu [FFFE0D]không có Ngũ Hành tương khắc[-], người thắng có thể kết duyên với người phát động chiêu thân!

[FFFE0D]1. Mở chiêu thân[-]
      Người chơi [FFFE0D]Lv50[-] trở lên có thể đến Tương Dương tìm [FFFE0D][url=npc:Yên Nhược Tuyết, 631, 10][-] mở Tỉ Võ Chiêu Thân, hệ thống sẽ tự động sắp xếp, thi đấu vào [FFFE0D]20:30[-] mỗi Chủ Nhật.
      Mở chiêu thân có thể thiết lập phạm vi chiêu thân (Toàn máy chủ hoặc bang hội), có thể giới hạn cấp và quân hàm tối thiểu của người tham chiến.
      Toàn máy chủ và mỗi bang hội mỗi tuần có thể mở 1 trận Tỉ Võ Chiêu Thân, [FFFE0D]số trận mở có hạn, sau khi sắp xếp đủ sẽ không được đặt nữa.[-]

[FFFE0D]2. Tham gia thi đấu[-]
      Khi bắt đầu báo danh, người chơi Lv50 trở lên có thể tìm [FFFE0D][url=npc:Yên Nhược Tuyết, 631, 10][-] tham gia Tỉ Võ Chiêu Thân, đủ điều kiện sẽ có thể thi đấu, tối đa cho phép [FFFE0D]128 người[-] tham gia.
      Hình thức thi đấu không chênh lệch, [FFFE0D]sức mạnh do hệ thống thiết lập[-], người chơi sẽ trở thành nhân vật tiêu chuẩn của phái mình, [FFFE0D]Ngũ Hành tương khắc[-] cũng bị hủy.
      Hai người tham gia sẽ đấu cặp với nhau, người thắng sẽ vào vòng trong, khi số người còn lại không nhiều hơn [FFFE0D]8 người[-] sẽ vào giai đoạn chung kết.
      Chung kết thi đấu trên [FFFE0D]Lôi Đài[-], người chơi có thể [FFFE0D]quan chiến[-].

[FFFE0D]3. Kết duyên[-]
      Quán Quân có thể nhận [FFFE0D]Vật Định Tình[-], tổ đội với người chiêu thân rồi sử dụng có thể kết duyên.
      Kết duyên có thể thiết lập [FFFE0D]danh hiệu Tình Duyên[-].
]];

-- 比武招亲最低限制
BiWuZhaoQin.tbLimitByTimeFrame =
{

	-- 时间轴			显示最高头衔    最高能设置的限制等级
	{"OpenLevel39", 		7, 				69};
	{"OpenLevel79", 		8, 				79};
	{"OpenLevel89", 		9, 				89};
	{"OpenLevel99", 		15,				99};
	{"OpenLevel109", 		15,				109};
}

BiWuZhaoQin.szOpenTime = "20:30";			-- 开启时间

BiWuZhaoQin.tbOpenWeekDay = 			-- 周几开启 (1-7)
{
	[7] = 1;
};

----------------------------------------------战斗相关

BiWuZhaoQin.TYPE_GLOBAL = 1;
BiWuZhaoQin.TYPE_KIN = 2;

-- 阶段
BiWuZhaoQin.Process_Pre = 1 											-- 准备阶段，任意进出地图报名
BiWuZhaoQin.Process_Fight = 2 											-- 战斗阶段，不允许报名，允许观战，匹配开打时不在线或不在准备场则失去资格
BiWuZhaoQin.Process_Final = 3 											-- 八强阶段，匹配开打时不在线或不在准备场则失去资格

BiWuZhaoQin.nDealyLeaveTime = 3 										-- 延迟几秒离开对战地图，为了显示结果

BiWuZhaoQin.FIGHT_TYPE_MAP = 1
BiWuZhaoQin.FIGHT_TYPE_ARENA = 2


BiWuZhaoQin.STATE_TRANS = 												--擂台流程控制
{

	{nSeconds = 2,   	szFunc = "PlayerReady",			szDesc = "Chuẩn bị"},
	{nSeconds = 3,   	szFunc = "PlayerAvatar",		szDesc = "Chuẩn bị"},
	{nSeconds = 3,   	szFunc = "StartCountDown",		szDesc = "Chuẩn bị"},
	{nSeconds = 150,    szFunc = "StartFight",			szDesc = "Bắt đầu"},
	{nSeconds = 3,   	szFunc = "ClcResult",			szDesc = "Tổng kết"},
}

BiWuZhaoQin.tbFightState =
{
	NoJoin = 0,
	StandBy = 1,
	Next = 2,
	Out = 3,
}

BiWuZhaoQin.tbFightStateDes =
{
	[BiWuZhaoQin.tbFightState.NoJoin] 	 = "Chưa tham gia",
	[BiWuZhaoQin.tbFightState.StandBy]	 = "Đang chờ",
	[BiWuZhaoQin.tbFightState.Next]		 = "Tiến vào",
	[BiWuZhaoQin.tbFightState.Out]		 = "Loại trực tiếp",
}


-- 下面策划配
BiWuZhaoQin.nPreMapTID = 1301; 											-- 准备场位置
BiWuZhaoQin.tbPreEnterPos = {{6451,6274},{8350,6296},{4420,6273},{6506,8117},{6459,4490}}-- 进入准备场位置（随机）
BiWuZhaoQin.nTaoTaiMapTID = 1300 										-- 淘汰赛地图
BiWuZhaoQin.nFinalNum = 8 			 									-- 剩下几个人开始8强赛阶段
BiWuZhaoQin.nDeathSkillState = 1520 									-- 死亡状态
BiWuZhaoQin.nFirstFightWaitTime = 5*60 									-- 第一次开打等待时间
BiWuZhaoQin.nMatchWaitTime = 30 										-- 匹配赛等待时间
BiWuZhaoQin.nAutoMatchTime = 190										-- 自动匹配的时间（需要计算一下从上次匹配到下一次匹配的时间，再加一些时间）
																		-- 一般不用自动匹配，所有玩家报告完之后就会匹配，这是为了保险（战斗流程时间 + nDealyLeaveTime + more）
BiWuZhaoQin.nDelayKictoutTime = 5*60 									-- 比赛结束后延迟踢走玩家时间
BiWuZhaoQin.nActNpc = 631
BiWuZhaoQin.nMaxJoin = 128 												-- 可参加人数
BiWuZhaoQin.nJoinLevel = 50 											-- 参加等级

BiWuZhaoQin.nBaseExpCount = 15 											-- 每次多少基准经验

BiWuZhaoQin.nFirstMatch = 1
BiWuZhaoQin.nFightMatch = 2
BiWuZhaoQin.nFinalMatch = 3
BiWuZhaoQin.nAutoMatch = 4
BiWuZhaoQin.nAutoMatchFinal = 5

BiWuZhaoQin.tbMatchSetting =
{
	[BiWuZhaoQin.nFirstMatch] = {szUiKey = "BiWuZhaoQinFirst"},
	[BiWuZhaoQin.nFightMatch] = {szUiKey = "BiWuZhaoQinFight"},
	[BiWuZhaoQin.nFinalMatch] = {szUiKey = "BiWuZhaoQinFinal"},
	[BiWuZhaoQin.nAutoMatch]  = {szUiKey = "BiWuZhaoQinAuto"},
	[BiWuZhaoQin.nAutoMatchFinal]  = {szUiKey = "BiWuZhaoQinAutoFinal"},
}

BiWuZhaoQin.tbProcessDes =
{
	[BiWuZhaoQin.Process_Pre] = "Báo Danh",
	[BiWuZhaoQin.Process_Fight] = "Đấu loại trực tiếp",
	[BiWuZhaoQin.Process_Final] = "Chung kết",
}

BiWuZhaoQin.szProcessEndDes = "Tỉ Võ Chiêu Thân đã kết thúc!"

-- 无差别配置(需要至少配一个默认的最小时间轴的配置)
BiWuZhaoQin.tbAvatar =
{
	["OpenLevel39"] =
	{
		nLevel = 50,
		szEquipKey = "InDiffer",
		szInsetKey = "InDiffer",
		nStrengthLevel = 50,
	},
	["OpenLevel59"] =
	{
		nLevel = 50,
		szEquipKey = "ZhaoQin59",
		szInsetKey = "ZhaoQin59",
		nStrengthLevel = 50,
	},
	["OpenLevel69"] =
	{
		nLevel = 60,
		szEquipKey = "ZhaoQin69",
		szInsetKey = "ZhaoQin69",
		nStrengthLevel = 60,
	},
	["OpenLevel79"] =
	{
		nLevel = 70,
		szEquipKey = "ZhaoQin79",
		szInsetKey = "ZhaoQin79",
		nStrengthLevel = 70,
	},
	["OpenLevel89"] =
	{
		nLevel = 80,
		szEquipKey = "ZhaoQin89",
		szInsetKey = "ZhaoQin89",
		nStrengthLevel = 80,
	},
	["OpenLevel99"] =
	{
		nLevel = 90,
		szEquipKey = "ZhaoQin99",
		szInsetKey = "ZhaoQin99",
		nStrengthLevel = 90,
	},
}

BiWuZhaoQin.tbDefaultAvatar =
{
	nLevel = 50,
	szEquipKey = "InDiffer",
	szInsetKey = "InDiffer",
	nStrengthLevel = 50,
}

-- 淘汰赛地图进入点
BiWuZhaoQin.tbTaoTaiEnterPos = {{5276,7432},{3822,8912}}

BiWuZhaoQin.nItemTID = 3592												-- 冠军道具

BiWuZhaoQin.nArenaNum = 4 												-- 准备场擂台个数

BiWuZhaoQin.tbPos =  													-- 准备场上擂台和离开擂台时双方的位置
{
	{
		tbEnterPos = {
			{7711,5167},
			{9130,3701},
		},
		tbLeavePos =
		{
			{6449,5694},
			{6449,5694},
		},
	},
	{
		tbEnterPos = {
			{5268,5176},
			{3870,3697},
		},
		tbLeavePos =
		{
			{5690,6318},
			{5690,6318},
		},
	},
	{
		tbEnterPos = {
			{7688,7406},
			{9075,8893},
		},
		tbLeavePos =
		{
			{7159,6320},
			{7159,6320},
		},
	},
	{
		tbEnterPos = {
			{5276,7432},
			{3822,8912},
		},
		tbLeavePos =
		{
			{6464,6907},
			{6464,6907},
		},
	},
}

BiWuZhaoQin.nReplaceItemId = 9795
BiWuZhaoQin.nReplaceConsume = 1

function BiWuZhaoQin:OnSyncLoverInfo(nLoverId)
	self.nLoverId = nLoverId;
end
