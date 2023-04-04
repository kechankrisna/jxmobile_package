
local tbFubenSetting = {};
Fuben:SetFubenSetting(42, tbFubenSetting)		-- 绑定副本内容和地图

tbFubenSetting.szFubenClass 			= "PersonalFubenBase";									-- 副本类型
tbFubenSetting.szName 					= "Phó bản thử nghiệm"											-- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile 			= "Setting/Fuben/PersonalFuben/5_1/NpcPos.tab"			-- NPC点
--tbFubenSetting.szNpcExtAwardPath 		= "Setting/Fuben/PersonalFuben/5_1/ExtNpcAwardInfo.tab"	-- 掉落表
tbFubenSetting.szPathFile 				= "Setting/Fuben/PersonalFuben/5_1/NpcPath.tab"					-- 寻路点
tbFubenSetting.tbBeginPoint 			= {2478, 10288}											-- 副本出生点
tbFubenSetting.nStartDir				= 28;


tbFubenSetting.ANIMATION = 
{
	[1] = "Scenes/Maps/yw_luoyegu/Main Camera.controller",
}


tbFubenSetting.NPC = 
{
	[1] = {nTemplate  = 842,		nLevel = 42, nSeries = -1}, --五色教徒
	[2] = {nTemplate  = 843,		nLevel = 42, nSeries = -1}, --五色教杀手
	[3] = {nTemplate  = 844,		nLevel = 44, nSeries = -1}, --五色教头目
	[4] = {nTemplate  = 747,		nLevel = 44, nSeries = 0}, --独孤剑
	[5] = {nTemplate  = 853,		nLevel = 44, nSeries = 0}, --张琳心
	[6] = {nTemplate  = 1383,		nLevel = 44, nSeries = 0}, --张林
	
	[9] = {nTemplate  = 104,		nLevel = -1, nSeries = 0}, --动态障碍墙
}

--是否允许同伴出战
--tbFubenSetting.bForbidPartner = true;
--tbFubenSetting.bForbidHelper = true;

tbFubenSetting.LOCK = 
{
	-- 1号锁不能不填，默认1号为起始锁，nTime是到时间自动解锁，nNum表示需要解锁的次数，如填3表示需要被解锁3次才算真正解锁，可以配置字符串
	[1] = {nTime = 0.5, nNum = 0,
		--tbPrelock 前置锁，激活锁的必要条件{1 , 2, {3, 4}}，代表1和2号必须解锁，3和4任意解锁一个即可
		tbPrelock = {},
		--tbStartEvent 锁激活时的事件
		tbStartEvent = 
		{
			{"BlackMsg", "Phía trước chính là Võ Di Kiếm Phái, hãy đến đó điều tra!"},
		},
		--tbStartEvent 锁解开时的事件
		tbUnLockEvent = 
		{
			{"SetShowTime", 2},
		},
	},
	[2] = {nTime = 600, nNum = 0,		--总计时
		tbPrelock = {1},
		tbStartEvent = 
		{
			{"RaiseEvent", "RegisterTimeoutLock"},
		},
		tbUnLockEvent = 
		{
			{"GameLost"},
		},
	},
	[3] = {nTime = 0, nNum = 1,
		tbPrelock = {1},
		tbStartEvent = 
		{
			{"ChangeFightState", 1},
			{"TrapUnlock", "trap1", 3},
			{"SetTargetPos", 2959, 9313},
			{"AddNpc", 9, 1, 0, "wall", "men1",false, 16},	
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
		},
	},
	[4] = {nTime = 0, nNum = 8,
		tbPrelock = {3},
		tbStartEvent = 
		{
			{"AddNpc", 1, 4, 4, "gw", "guaiwu1", false, 0, 0.5, 9005, 0.5},
			{"AddNpc", 1, 4, 4, "gw", "guaiwu2", false, 0, 2, 9005, 0.5},
			{"AddNpc", 1, 6, 0, "gw", "guaiwu2_1", false, 0, 4, 0, 0},
			{"BlackMsg", "Diệt Ngũ Sắc Giáo Đồ!"},
		},
		tbUnLockEvent = 
		{
			{"OpenDynamicObstacle", "obs1"},
			{"DoDeath", "wall"},
		},
	},
	[5] = {nTime = 0, nNum = 1,
		tbPrelock = {4},
		tbStartEvent = 
		{
			{"TrapUnlock", "trap2", 5},
			{"SetTargetPos", 2996, 4730},
			{"BlackMsg", "Xem ra Ngũ Sắc Giáo đã tới sớm một bước, Võ Di Kiếm Phái e rằng lành ít dữ nhiều!"},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"AddNpc", 9, 1, 0, "wall", "men2",false, 32},
		},
	},
	[6] = {nTime = 0, nNum = 8,
		tbPrelock = {5},
		tbStartEvent = 
		{
			{"AddNpc", 1, 6, 6, "gw", "guaiwu3", false, 0, 0.5, 9005, 0.5},
			{"AddNpc", 2, 2, 6, "gw", "guaiwu4", false, 0, 2, 0, 0},
			{"AddNpc", 1, 8, 0, "gw", "guaiwu4_1", false, 0, 4, 0, 0},
		},
		tbUnLockEvent = 
		{
			{"OpenDynamicObstacle", "obs2"},
			{"DoDeath", "wall"},
		},
	},
	[7] = {nTime = 0, nNum = 1,
		tbPrelock = {6},
		tbStartEvent = 
		{
			{"TrapUnlock", "trap3", 7},
			{"SetTargetPos", 7755, 3310},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"AddNpc", 9, 2, 0, "wall", "men3",false, 16},
		},
	},
	[8] = {nTime = 0, nNum = 14,
		tbPrelock = {7},
		tbStartEvent = 
		{
			{"BlackMsg", "Đạo tặc to gan!"},
			{"AddNpc", 1, 4, 8, "gw", "guaiwu5", false, 0, 0.5, 9005, 0.5},
			{"AddNpc", 2, 4, 8, "gw", "guaiwu6", false, 0, 2, 0, 0},
			{"AddNpc", 1, 6, 8, "gw", "guaiwu6_1", false, 0, 4, 9005, 0.5},
		},
		tbUnLockEvent = 
		{
			{"OpenDynamicObstacle", "obs3"},
			{"OpenDynamicObstacle", "obs4"},
			{"DoDeath", "wall"},
			{"DoDeath", "gw"},
		},
	},
	[9] = {nTime = 0, nNum = 1,
		tbPrelock = {8},
		tbStartEvent = 
		{
			{"BlackMsg", "Có gì khác thường ở phía trước, hãy mau đến điều tra xem!"},
			{"TrapUnlock", "trap4", 9},
			{"SetTargetPos", 7459, 7991},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"RaiseEvent", "CloseDynamicObstacle", "obs4"},
			{"AddNpc", 9, 2, 0, "wall", "men4",false, 16},	
		},
	},
	[10] = {nTime = 0, nNum = 1,
		tbPrelock = {9},
		tbStartEvent = 
		{
			{"AddNpc", 3, 1, 10, "boss", "boss", false, 64, 0, 0, 0},
			{"SetNpcProtected", "boss", 1},
			{"SetNpcBloodVisable", "boss", false, 0},
			{"SetAiActive", "boss", 0},
		},
		tbUnLockEvent = 
		{
		},
	},
	[11] = {nTime = 2.1, nNum = 0,
		tbPrelock = {10},
		tbStartEvent = 
		{
			{"SetGameWorldScale", 0.1},		-- 慢镜头开始
		},
		tbUnLockEvent = 
		{
			{"SetGameWorldScale", 1},		-- 慢镜头结束
		},
	},

	---------------结束剧情------------------
	[12] = {nTime = 0, nNum = 1,
		tbPrelock = {9},
		tbStartEvent = 
		{
			{"MoveCameraToPosition", 12, 1, 7496, 9186, 10},
			{"AddNpc", 6, 1, 0, "npc", "zhanglin", false, 32, 0, 0, 0},
			{"SetNpcBloodVisable", "npc", false, 0},
			{"SetNpcProtected", "npc", 1},
			{"SetAiActive", "npc", 0},
			{"SetForbiddenOperation", true},
			{"SetAllUiVisiable", false},
		},
		tbUnLockEvent = 
		{
		},
	},
	[13] = {nTime = 4, nNum = 0,
		tbPrelock = {12},
		tbStartEvent = 
		{
			{"NpcBubbleTalk", "boss", "Đại đệ tử Võ Di Kiếm Phái chỉ có thế thôi sao?", 4, 0.5, 1},
			{"NpcBubbleTalk", "npc", "Khụ khụ...Muốn thì cứ ra tay... Đừng nói nhiều nữa!", 4, 2, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[14] = {nTime = 0, nNum = 2,
		tbPrelock = {13},
		tbStartEvent = 
		{
			{"AddNpc", 4, 1, 0, "npc1", "dugujian", false, 64, 0, 0, 0},
			{"AddNpc", 5, 1, 0, "npc2", "zhanglinxin", false, 64, 0, 0, 0},
			{"ChangeNpcAi", "npc1", "Move", "path1", 14, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc2", "Move", "path2", 14, 1, 1, 0, 0},
			{"SetNpcBloodVisable", "npc1", false, 0},
			{"SetNpcBloodVisable", "npc2", false, 0},
			{"NpcBubbleTalk", "npc1", "Dừng tay!", 4, 1, 1},
		},
		tbUnLockEvent = 
		{
			{"SetNpcDir", "boss", 32},
		},
	},

	[15] = {nTime = 17, nNum = 1,
		tbPrelock = {14},
		tbStartEvent = 
		{
			{"NpcBubbleTalk", "boss", "Ai đó?", 3, 0, 1},
			{"NpcBubbleTalk", "npc1", "Hành Sơn Độc Cô Kiếm!", 3, 2, 1},
			{"NpcBubbleTalk", "boss", "Sao? Lưu Khinh Châu không phải qua đời rồi sao? Hành Sơn Phái vẫn còn ư?", 3, 4, 1},
			{"NpcBubbleTalk", "npc1", "(Nổi giận) Các ngươi đã hại sư phụ ta! Giờ... lại đến Võ Di Kiếm Phái, có âm mưu gì hả?", 3, 7, 1},
			{"NpcBubbleTalk", "boss", "Ha ha! Con nít thì hiểu gì chứ? Bây giờ đi vẫn còn kịp!", 3, 10, 1},
			{"NpcBubbleTalk", "npc2", "Độc Cô đại ca, người này có vẻ không thành thật, hãy cứu Trương huynh rồi tính!", 3, 13, 1},
			{"NpcBubbleTalk", "boss", "Chán sống hả!", 3, 16, 1},

		},
		tbUnLockEvent = 
		{
			{"SetNpcBloodVisable", "npc1", true, 0},
			{"SetNpcBloodVisable", "npc2", true, 0},
			{"SetNpcBloodVisable", "boss", true, 0},
			{"SetNpcProtected", "boss", 0},
			{"SetAiActive", "boss", 1},
			{"SetForbiddenOperation", false},
			{"SetAllUiVisiable", true},
			{"LeaveAnimationState", true},
			{"BlackMsg", "Diệt Thủ Lĩnh Ngũ Sắc Giáo, cứu Trương Lâm!"},
		},
	},
	[16] = {nTime = 0, nNum = 1,
		tbPrelock = {11},
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 16, 1098, false},
		},
		tbUnLockEvent = 
		{
			{"GameWin"},
		},
	},
}