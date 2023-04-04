
local tbFubenSetting = {};
Fuben:SetFubenSetting(27, tbFubenSetting)		-- 绑定副本内容和地图

tbFubenSetting.szFubenClass 			= "PersonalFubenBase";									-- 副本类型
tbFubenSetting.szName 					= "Phó bản thử nghiệm"											-- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile 			= "Setting/Fuben/PersonalFuben/2_4/NpcPos.tab"			-- NPC点
--tbFubenSetting.szNpcExtAwardPath 		= "Setting/Fuben/PersonalFuben/2_5/ExtNpcAwardInfo.tab"	-- 掉落表
tbFubenSetting.szPathFile			    = "Setting/Fuben/PersonalFuben/2_4/NpcPath.tab"			-- 寻路点
tbFubenSetting.tbBeginPoint 			= {5147, 9902}											-- 副本出生点
tbFubenSetting.nStartDir				= 31;



-- ID可以随便 普通副本NPC数量 ；精英模式NPC数量

tbFubenSetting.ANIMATION = 
{
	[1] = "Scenes/Maps/yw_luoyegu/Main Camera.controller",
}

--NPC模版ID，NPC等级，NPC五行；

tbFubenSetting.NPC = 
{
	[1] = {nTemplate = 783,				nLevel = -1, nSeries = -1},  --江湖草莽
	[2] = {nTemplate = 787,				nLevel = -1, nSeries = -1},  --卓非凡幻影
	[3] = {nTemplate = 840,				nLevel = -1, nSeries = -1},  --紫轩
	[4] = {nTemplate = 788,				nLevel = -1, nSeries = -1},  --夺命一点金
	[5] = {nTemplate = 1116,			nLevel = -1, nSeries = -1},  --纳兰潜凛幻影
	[6] = {nTemplate = 1117,			nLevel = -1, nSeries = 0},  --纳兰真
	[7] = {nTemplate = 1118,			nLevel = -1, nSeries = 4},  --心魔
	[8] = {nTemplate = 684,				nLevel = -1, nSeries = 0},  --杨影枫

	[9] = {nTemplate = 104,				nLevel = -1, nSeries = 0},  --动态障碍墙

	[10] = {nTemplate = 1447,			nLevel = -1, nSeries = 0},  --隐藏技能npc
	[11] = {nTemplate = 1446,			nLevel = -1, nSeries = 0},  --喷射机关
	[12] = {nTemplate = 679,			nLevel = -1, nSeries = 0},  --大型喷射机关
}

--是否允许同伴出战
--tbFubenSetting.bForbidPartner = true;

tbFubenSetting.LOCK = 
{
	-- 1号锁不能不填，默认1号为起始锁，nTime是到时间自动解锁，nNum表示需要解锁的次数，如填3表示需要被解锁3次才算真正解锁，可以配置字符串
	[1] = {nTime = 0, nNum = 1,
		--tbPrelock 前置锁，激活锁的必要条件{1 , 2, {3, 4}}，代表1和2号必须解锁，3和4任意解锁一个即可
		tbPrelock = {},
		--tbStartEvent 锁激活时的事件
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 1, 1022, false},	
		},
		--tbStartEvent 锁解开时的事件
		tbUnLockEvent = 
		{
			{"SetShowTime", 19},
			{"AddNpc", 8, 1, 0, "Yangyingfeng", "Stage_1_1", 1, 32, 0, 0, 0},
		},
	},
	[2] = {nTime = 0, nNum = 1,
		tbPrelock = {1},
		tbStartEvent = 
		{	
			{"ChangeFightState", 1},
			{"TrapUnlock", "TrapLock1", 2},
			{"SetTargetPos", 5780, 7509},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"NpcBubbleTalk", "Yangyingfeng", "Tâm Ma Trận có gì đó rất lạ...", 3, 0, 1},
			{"AddNpc", 9, 3, 0, "wall1", "wall_1_1",false, 16},
		},
	},
	[3] = {nTime = 0, nNum = 1,
		tbPrelock = {2},
		tbStartEvent = 
		{	
			{"AddNpc", 2, 1, 5, "Zhuofeifan", "Stage_1_2", 1, 0, 0, 0, 0},
			{"ChangeNpcAi", "Zhuofeifan", "Move", "Path1", 3, 1, 1, 0, 0},
			{"SetNpcProtected", "Zhuofeifan", 1},
			{"SetNpcBloodVisable", "Zhuofeifan", false, 0},
			{"ChangeNpcFightState", "Zhuofeifan", 0, 0},
		},
		tbUnLockEvent = 
		{	
			{"SetAiActive", "Zhuofeifan", 0},
			{"BlackMsg", "Trác Phi Phàm! Sao hắn lại xuất hiện ở đây?"},
			{"NpcBubbleTalk", "Zhuofeifan", "Hiền đệ vẫn khỏe chứ?", 3, 0, 1},
			{"NpcBubbleTalk", "Yangyingfeng", "Trác Phi Phàm! Đừng giả vờ trước mặt ta nữa!", 3, 2, 1},
			{"NpcBubbleTalk", "Zhuofeifan", "Hiền đệ, việc này là sao?", 3, 4, 1},
			{"NpcBubbleTalk", "Yangyingfeng", "Hừ! Trác Phi Phàm, ngươi nhanh quên thật! Hôm nay ta phải bắt ngươi đền tội!", 3, 6, 1},
			{"NpcBubbleTalk", "Zhuofeifan", "Hiền đệ, chúng ta là huynh đệ với nhau, có nhất thiết phải động thủ không?", 4, 8, 1},
			{"NpcBubbleTalk", "Yangyingfeng", "Trác Phi Phàm, khi ngươi mưu đồ hại ta, ngươi có từng nghĩ đến tình nghĩa huynh đệ không?", 4, 10, 1},
			{"NpcBubbleTalk", "Yangyingfeng", "Đừng nhiều lời! Hôm nay chúng ta phải giải quyết cho xong!", 4, 13, 1},
		},
	},
	[4] = {nTime = 10, nNum = 0,
		tbPrelock = {3},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"SetNpcProtected", "Zhuofeifan", 0},
			{"SetNpcBloodVisable", "Zhuofeifan", true, 0},
			{"ChangeNpcFightState", "Zhuofeifan", 1, 0},
			{"SetAiActive", "Zhuofeifan", 1},
		},
	},
	[5] = {nTime = 0, nNum = 1,
		tbPrelock = {4},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"PauseLock", 19},
			{"DoDeath", "wall1"},
			{"OpenDynamicObstacle", "ops1"},
		},
	},
	[6] = {nTime = 0, nNum = 1,
		tbPrelock = {5},
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 6, 1023, false, 1},
		},
		tbUnLockEvent = 
		{
			{"ResumeLock", 19},
			{"SetShowTime", 19},
			{"SetTargetPos", 5304, 3292},
			{"BlackMsg", "Tiếp tục tìm Tâm Ma Trận!"},
			{"NpcBubbleTalk", "Yangyingfeng", "Việc này rốt cuộc là sao?", 6, 0, 1},
		},
	},
	[7] = {nTime = 0, nNum = 1,
		tbPrelock = {6},
		tbStartEvent = 
		{	
			{"TrapUnlock", "TrapLock2", 7},
			{"AddNpc", 3, 1, 0, "Zixuan", "Stage_2_2", 1, 0, 0, 0, 0},

			{"AddNpc", 12, 1, 0, "jg1", "jiguan1_1", false, 16, 0, 0, 0},		--喷火机关
			{"AddNpc", 12, 1, 0, "jg1", "jiguan1_2", false, 48, 0, 0, 0},
			{"CastSkillCycle", "cycle1", "jg1", 2, 2412, 1, 5791, 6067},
			{"AddNpc", 12, 1, 0, "jg2", "jiguan2_1", false, 48, 0, 0, 0},
			{"AddNpc", 12, 1, 0, "jg2", "jiguan2_2", false, 16, 0, 0, 0},
			{"CastSkillCycle", "cycle2", "jg2", 2, 2412, 1, 5636, 5466},
			{"AddNpc", 12, 1, 0, "jg3", "jiguan3_1", false, 16, 0, 0, 0},
			{"AddNpc", 12, 1, 0, "jg3", "jiguan3_2", false, 48, 0, 0, 0},
			{"CastSkillCycle", "cycle3", "jg3", 2, 2412, 1, 5686, 5062},
			{"AddNpc", 12, 1, 0, "jg4", "jiguan4_1", false, 48, 0, 0, 0},
			{"AddNpc", 12, 1, 0, "jg4", "jiguan4_2", false, 16, 0, 0, 0},
			{"CastSkillCycle", "cycle4", "jg4", 2, 2412, 1, 5624, 4554},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"AddNpc", 9, 1, 0, "wall2", "wall_1_2",false, 29},
		},
	},
	[8] = {nTime = 8, nNum = 0,
		tbPrelock = {7},
		tbStartEvent = 
		{
			{"DelNpc", "Yangyingfeng"},
			{"AddNpc", 8, 1, 0, "Yangyingfeng1", "Stage_2_1", 1, 32, 0, 0, 0},
			{"SetNpcProtected", "Zixuan", 1},
			{"SetNpcBloodVisable", "Zixuan", false, 0},

			{"NpcBubbleTalk", "Yangyingfeng1", "Đây là... Ba Tiêu Tiểu Trúc?", 3, 2, 1},
			{"NpcBubbleTalk", "Yangyingfeng1", "Tử.... Tử Hiên!!!", 3, 4, 1},
			{"NpcBubbleTalk", "Zixuan", "Dương đại ca mau cứu ta!", 3, 6, 1},
			{"NpcBubbleTalk", "Yangyingfeng1", "Tử Hiên! Tử Hiên! Ngươi sao rồi?", 3, 8, 1},
		},
		tbUnLockEvent = 
		{
		},
	},

	[9] = {nTime = 0, nNum = 1,
		tbPrelock = {8},
		tbStartEvent = 
		{
			{"AddNpc", 4, 1, 9, "guaiwu", "Stage_2_2", 1, 0, 0, 0, 0},
			{"SetAiActive", "Yangyingfeng1", 1},
			{"BlackMsg", "Cùng Dương Ảnh Phong liên thủ đánh bại Đoạt Mệnh Nhất Điểm Kim!"},
			{"NpcBubbleTalk", "Yangyingfeng1", "Hừ! Các ngươi thật to gan, dám làm càn giữa ban ngày!", 3, 0, 1},
			{"NpcBubbleTalk", "guaiwu", "Dám cản trở bổn đại gia hành sự, các huynh đệ, xông lên!", 3, 2, 1},
			{"AddNpc", 1, 6, 0, "guaiwu", "Stage_2_3", 1, 0, 1, 9005, 0.5},

			{"AddNpc", 10, 5, 0, "xj", "xianjing2", false, 0, 0, 0, 0},		--喷火龙头
			{"CastSkillCycle", "cycle", "xj", 2, 2495, 1, -1, -1},
		},
		tbUnLockEvent = 
		{
			{"PauseLock", 19},
			{"CastSkill", "guaiwu", 3, 1, -1, -1},
			{"DoDeath", "wall2"},
			{"OpenDynamicObstacle", "ops2"},
			{"OpenDynamicObstacle", "ops3"},

			{"DelNpc", "xj"},
			{"CloseCycle", "cycle"},
		},
	},
	[10] = {nTime = 0, nNum = 1,
		tbPrelock = {9},
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 10, 1024, false, 1},
		},
		tbUnLockEvent = 
		{
			{"ResumeLock", 19},
			{"SetShowTime", 19},
			{"DelNpc", "Zixuan"},
			{"SetTargetPos", 4643, 1911},
			{"BlackMsg", "Tiếp tục tìm Tâm Ma Trận!"},
			{"NpcBubbleTalk", "Yangyingfeng1", "Tử Hiên............", 4, 0, 1},
		},
	},
	[11] = {nTime = 0, nNum = 1,
		tbPrelock = {9},
		tbStartEvent = 
		{
			{"TrapUnlock", "TrapLock3", 11},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"SetTargetPos", 3173, 4209},
		},
	},
	[12] = {nTime = 0, nNum = 1,
		tbPrelock = {10},
		tbStartEvent = 
		{
			{"TrapUnlock", "TrapLock4", 12},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"SetAiActive", "Nalanqianlin", 0},
			{"DelNpc", "Yangyingfeng1"},
			{"PauseLock", 19},
			{"RaiseEvent", "CloseDynamicObstacle", "ops3"},	
			{"AddNpc", 9, 1, 0, "wall3", "wall_1_3",false, 46},
		},
	},
	[13] = {nTime = 0, nNum = 1,
		tbPrelock = {12},
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 13, 1025, false},
			{"AddNpc", 8, 1, 0, "Yangyingfeng2", "Stage_3_1", 1, 59, 0, 0, 0},
			{"ChangeNpcAi", "Yangyingfeng2", "Move", "Path3", 0, 1, 1, 0, 0},
		},
		tbUnLockEvent = 
		{
			{"ResumeLock", 19},
			{"SetShowTime", 19},
			{"SetNpcProtected", "Nalanqianlin", 0},
			{"SetNpcBloodVisable", "Nalanqianlin", true, 0},
			{"SetAiActive", "Nalanqianlin", 1},
			{"BlackMsg", "Giúp Dương Ảnh Phong đánh bại Ảo Ảnh Tâm Ma!"},

			{"AddNpc", 10, 4, 0, "xj", "xianjing3", false, 0, 0, 0, 0},		--喷火陷阱
			{"CastSkillCycle", "cycle", "xj", 2, 2495, 1, -1, -1},
		},
	},
	[14] = {nTime = 0, nNum = 1,
		tbPrelock = {10},
		tbStartEvent = 
		{
			{"AddNpc", 5, 1, 14, "Nalanqianlin", "Stage_3_2", 1, 0, 0, 0, 0},
			{"SetNpcProtected", "Nalanqianlin", 1},
			{"SetNpcBloodVisable", "Nalanqianlin", false, 0},
			{"SetAiActive", "Nalanqianlin", 0},
			{"SetNpcDir", "Nalanqianlin", 30},
		},
		tbUnLockEvent = 
		{
			{"DelNpc", "xj"},
			{"CloseCycle", "cycle"},
		},
	},
	[15] = {nTime = 0, nNum = 1,
		tbPrelock = {14},
		tbStartEvent = 
		{
			{"PauseLock", 19},
			{"AddNpc", 6, 1, 0, "Nalanzhen", "Stage_3_2", 1, 0, 1, 0, 0},
			{"MoveCameraToPosition", 15, 1, 2695, 4677, 5},
			{"ChangeNpcAi", "Yangyingfeng2", "Move", "Path6", 0, 1, 1, 0, 0},
			{"SetAllUiVisiable", false},
			{"SetForbiddenOperation", true},

			{"RaiseEvent", "ShowPartnerAndHelper", false},
		},
		tbUnLockEvent = 
		{
		},
	},
	[16] = {nTime = 0, nNum = 1,
		tbPrelock = {23},
		tbStartEvent = 
		{
			{"ResumeLock", 19},
			{"SetShowTime", 19},
			{"AddNpc", 7, 1, 16, "BOSS", "Stage_3_2", 2, 0, 1, 9011, 1},
			{"BlackMsg", "Diệt Tâm Ma thực có thể vượt Tâm Ma Trận!"},

			{"AddNpc", 11, 2, 0, "guaiwu", "jiguan", false, 24, 4, 9011, 1},		--喷射机关
			{"NpcBubbleTalk", "BOSS", "Cảm nhận được cơn thịnh nộ trong lòng ngươi!", 4, 4, 1},
		},
		tbUnLockEvent = 
		{
			{"PauseLock", 19},
			{"StopEndTime"},
			{"SetGameWorldScale", 0.1},		-- 慢镜头开始
			{"CastSkill", "guaiwu", 3, 1, -1, -1},
		},
	},
	[17] = {nTime = 2.1, nNum = 0,
		tbPrelock = {16},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"SetGameWorldScale", 1},		-- 慢镜头开始
		},
	},
	[18] = {nTime = 2, nNum = 0,
		tbPrelock = {17},
		tbStartEvent = 
		{					
		},
		tbUnLockEvent = 
		{
			{"ResumeLock", 19},
			{"SetShowTime", 19},
			{"GameWin"},
		},
	},
	[19] = {nTime = 330, nNum = 0,
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

	[20] = {nTime = 0, nNum = 1,
		tbPrelock = {15},
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 20, 1026, false, 1},
		},
		tbUnLockEvent = 
		{
			{"SetForbiddenOperation", true},
		},
	},
	[21] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
			{"ChangeNpcAi", "Yangyingfeng1", "Move", "Path4", 21, 1, 1, 0, 0},--杨影枫寻路
		},
		tbUnLockEvent = 
		{
			{"SetAiActive", "Yangyingfeng1", 0},
		},
	},
	[22] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
			{"ChangeNpcAi", "Zixuan", "Move", "Path2", 22, 1, 1, 0, 0},
		},
		tbUnLockEvent = 
		{
			{"SetAiActive", "Zixuan", 0},
		},
	},
	[23] = {nTime = 0, nNum = 1,
		tbPrelock = {20},
		tbStartEvent = 
		{
			{"ChangeNpcAi", "Nalanzhen", "Move", "Path5", 23, 0, 0, 1, 0},
			{"NpcBubbleTalk", "Nalanzhen", "Hừ! Mặc kệ ngươi!", 3, 0, 1},
			{"NpcBubbleTalk", "Yangyingfeng2", "Chân Nhi, đợi đã...không đúng...đây là tâm ma của ta...", 3, 1.5, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[24] = {nTime = 3, nNum = 0,
		tbPrelock = {23},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"LeaveAnimationState", true},
			{"SetAllUiVisiable", true},
			{"SetForbiddenOperation", false},

			{"RaiseEvent", "ShowPartnerAndHelper", true},
		},
	},
}
