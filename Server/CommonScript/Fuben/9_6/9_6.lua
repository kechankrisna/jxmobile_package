
local tbFubenSetting = {};
Fuben:SetFubenSetting(70, tbFubenSetting)		-- 绑定副本内容和地图

tbFubenSetting.szFubenClass 			= "PersonalFubenBase";									-- 副本类型
tbFubenSetting.szName 					= "Phó bản thử nghiệm"											-- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile 			= "Setting/Fuben/PersonalFuben/9_6/NpcPos.tab"			-- NPC点
--tbFubenSetting.szNpcExtAwardPath 		= "Setting/Fuben/PersonalFuben/9_6/ExtNpcAwardInfo.tab"	-- 掉落表
tbFubenSetting.szPathFile 				= "Setting/Fuben/PersonalFuben/9_6/NpcPath.tab"			-- 寻路点
tbFubenSetting.tbBeginPoint 			= {5002, 3117}											-- 副本出生点
tbFubenSetting.nStartDir				= 32;

-- ID可以随便 普通副本NPC数量 ；精英模式NPC数量

tbFubenSetting.ANIMATION = 
{
	[1] = "Scenes/Maps/yw_luoyegu/Main Camera.controller",
}
 
-- NPC模版ID，NPC等级，NPC五行；
tbFubenSetting.NPC = 
{
	[1] = {nTemplate = 2643,	nLevel = -1,	nSeries = 0},	--完颜洪烈强
	[2] = {nTemplate = 2644,	nLevel = -1,	nSeries = 0},	--完颜洪烈中
	[3] = {nTemplate = 2645,	nLevel = -1,	nSeries = 0},	--完颜洪烈弱
	[4] = {nTemplate = 2646,	nLevel = -1,	nSeries = 0},	--南宫飞云
	[5] = {nTemplate = 2636,	nLevel = -1,	nSeries = -1},	--天忍精英
	[6] = {nTemplate = 2637,	nLevel = -1,	nSeries = -1},	--天忍弟子
	[7] = {nTemplate = 104,		nLevel = -1,	nSeries = 0},	--障碍门
}
tbFubenSetting.LOCK = 
{
	-- 1号锁不能不填，默认1号为起始锁，nTime是到时间自动解锁，nNum表示需要解锁的次数，如填3表示需要被解锁3次才算真正解锁，可以配置字符串
	[1] = {nTime = 0, nNum = 1,
		--tbPrelock 前置锁，激活锁的必要条件{1 , 2, {3, 4}}，代表1和2号必须解锁，3和4任意解锁一个即可
		tbPrelock = {},
		--tbStartEvent 锁激活时的事件
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 1, 1135, false},
		},
		--tbStartEvent 锁解开时的事件
		tbUnLockEvent = 
		{
			{"SetShowTime", 2},
		},
	},
	[2] = {nTime = 300, nNum = 0,
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
			{"TrapUnlock", "trap1", 3},
			{"SetTargetPos", 5065, 1731},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"AddNpc", 7, 1, 0, "wall", "wall_1",false, 32},
		},
	},
	[4] = {nTime = 0, nNum = 1,
		tbPrelock = {3},
		tbStartEvent = 
		{
			{"AddNpc", 3, 1, 4, "boss1", "boss1", false, 0, 0.5, 9010, 0.5},
			{"AddNpc", 6, 8, 0, "guaiwu", "gw1_1", false, 0, 0.5, 9010, 0.5},
			{"AddNpc", 5, 1, 0, "jingying", "gw1_2", false, 0, 0.5, 9010, 0.5},
			{"NpcBubbleTalk", "guaiwu", "Hoàn Nhan giáo chủ, nhất thống giang hồ!", 4, 2, 1},
			{"NpcBubbleTalk", "jingying", "Kẻ nào dám xông vào Thiên Nhẫn Giáo ta?", 4, 2, 1},
		},
		tbUnLockEvent = 
		{
			{"DoDeath", "wall"}, 
			{"DoDeath", "guaiwu"}, 
			{"DoDeath", "jingying"}, 
			{"OpenDynamicObstacle", "obs1"},
			{"SetTargetPos", 2634, 3346},
			{"PlayerBubbleTalk", "Giang hồ truyền rằng, Hoàn Nhan Hồng Liệt võ công cao cường, sao lại tệ hại như vậy?"},
		},
	},
	[5] = {nTime = 2, nNum = 0,
		tbPrelock = {3},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"PlayerBubbleTalk", "Thì ra Hoàn Nhan Hồng Liệt đang ở đây!"},
		},
	},
	[6] = {nTime = 0, nNum = 1,
		tbPrelock = {4},
		tbStartEvent = 
		{
			{"TrapUnlock", "trap2", 6},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"AddNpc", 7, 1, 0, "wall", "wall_2",false, 16},
		},
	},
	[7] = {nTime = 0, nNum = 1,
		tbPrelock = {6},
		tbStartEvent = 
		{
			{"AddNpc", 2, 1, 7, "boss2", "boss2", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 6, 8, 0, "guaiwu", "gw2_1", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 5, 1, 0, "jingying", "gw2_2", false, 32, 0.5, 9010, 0.5},
			{"NpcBubbleTalk", "guaiwu", "Hoàn Nhan giáo chủ, nhất thống giang hồ!", 4, 2, 1},
			{"NpcBubbleTalk", "jingying", "Kẻ nào dám xông vào Thiên Nhẫn Giáo ta?", 4, 2, 1},
		},
		tbUnLockEvent = 
		{
			{"DoDeath", "wall"}, 
			{"DoDeath", "guaiwu"}, 
			{"DoDeath", "jingying"}, 
			{"OpenDynamicObstacle", "obs2"},
			{"SetTargetPos", 4124, 5855},
			{"PlayerBubbleTalk", "Ở đây có gì đó không ổn!"},
		},
	},
	[8] = {nTime = 2, nNum = 0,
		tbPrelock = {6},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"PlayerBubbleTalk", "Sao lại thêm một tên Hoàn Nhan Hồng Liệt nữa?"},
		},
	},
	[9] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
			{"TrapUnlock", "trap3", 9},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"AddNpc", 1, 1, 21, "boss", "boss", false, 48, 0, 0, 0},
			{"SetNpcProtected", "boss", 1},

			{"AddNpc", 4, 1, 0, "nangong", "nangongfeiyun", false, 16, 0, 0, 0},

			{"SetNpcBloodVisable", "boss", false, 0},
			{"SetNpcBloodVisable", "nangong", false, 0},
			{"SetAiActive", "boss", 0},
		},
	},
	[10] = {nTime = 0, nNum = 1,
		tbPrelock = {9},
		tbStartEvent = 
		{
			{"MoveCameraToPosition", 10, 1, 4626, 5834, 5},
			{"SetForbiddenOperation", true},
			{"SetAllUiVisiable", false},
		},
		tbUnLockEvent = 
		{
		},
	},
	[11] = {nTime = 0, nNum = 1,
		tbPrelock = {10},
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 11, 1136, false},
		},
		tbUnLockEvent = 
		{
			{"SetForbiddenOperation", false},
			{"SetAllUiVisiable", true},
			{"LeaveAnimationState", true},

			{"BlackMsg", "Diệt Hoàn Nhan Hồng Liệt!"},

			{"SetNpcProtected", "boss", 0},
			{"SetNpcBloodVisable", "boss", true, 0},
			{"SetNpcBloodVisable", "nangong", true, 0},
			{"SetAiActive", "boss", 1},
			{"NpcHpUnlock", "boss", 13, 50},
		},
	},
	[13] = {nTime = 0, nNum = 1,
		tbPrelock = {11},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"CastSkill", "boss", 1521, 1, -1, -1},
			{"NpcAddBuff", "boss", 2417, 1, 100},
			{"NpcBubbleTalk", "boss", "Hãy xem ta nhất khí hóa tam thanh!", 3, 0, 1},
		},
	},
	[14] = {nTime = 2, nNum = 0,
		tbPrelock = {13},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"CastSkill", "boss", 3105, 1, -1, -1},
		},
	},
	[15] = {nTime = 0.5, nNum = 0,
		tbPrelock = {14},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"DelNpc", "boss"},
			{"Random", {330000, 16}, {330000, 17}, {340000, 18}}
		},
	},
	[16] = {nTime = 0, nNum = 1,
		tbPrelock = {15},
		tbStartEvent = 
		{
			{"UnLock", 16}, 
		},
		tbUnLockEvent = 
		{
			{"AddNpc", 2, 1, 0, "huanxiang1", "huanxiang1", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 2, 1, 0, "huanxiang2", "huanxiang2", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 1, 1, 21, "boss", "boss", false, 32, 0.5, 9010, 0.5},
		},
	},
	[17] = {nTime = 0, nNum = 1,
		tbPrelock = {15},
		tbStartEvent = 
		{
			{"UnLock", 17}, 
		},
		tbUnLockEvent = 
		{
			{"AddNpc", 2, 1, 0, "huanxiang1", "boss", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 2, 1, 0, "huanxiang2", "huanxiang2", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 1, 1, 21, "boss", "huanxiang1", false, 32, 0.5, 9010, 0.5},
		},
	},
	[18] = {nTime = 0, nNum = 1,
		tbPrelock = {15},
		tbStartEvent = 
		{
			{"UnLock", 18}, 
		},
		tbUnLockEvent = 
		{
			{"AddNpc", 2, 1, 0, "huanxiang1", "huanxiang1", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 2, 1, 0, "huanxiang2", "boss", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 1, 1, 21, "boss", "huanxiang2", false, 32, 0.5, 9010, 0.5},
		},
	},
	[19] = {nTime = 1.1, nNum = 0,
		tbPrelock = {{16, 17, 18}},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"SetNpcLife", "boss", 50},
			{"SetNpcLife", "huanxiang1", 50},
			{"SetNpcLife", "huanxiang2", 50},
			{"NpcHpUnlock", "boss", 20, 20},
			{"NpcBubbleTalk", "boss", "Ha ha ha!", 3, 0, 1},
			{"NpcBubbleTalk", "huanxiang1", "Ha ha ha!", 3, 0, 1},
			{"NpcBubbleTalk", "huanxiang2", "Ha ha ha!", 3, 0, 1},
		},
	},
	[20] = {nTime = 0, nNum = 1,
		tbPrelock = {19},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"NpcBubbleTalk", "boss", "Bổn tọa cho ngươi cơ hội cuối cùng, biết điều ta sẽ trọng dụng!", 3, 0, 1},
			{"DelNpc", "huanxiang1"},
			{"DelNpc", "huanxiang2"}, 
		},
	},
	[21] = {nTime = 0, nNum = 1,
		tbPrelock = {9},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
		},
	},
	[22] = {nTime = 2.1, nNum = 0,
		tbPrelock = {21},
		tbStartEvent = 
		{
			{"SetGameWorldScale", 0.1},		-- 慢镜头开始
		},
		tbUnLockEvent = 
		{
			{"SetGameWorldScale", 1},		-- 慢镜头结束
			{"GameWin"},
		},
	},
}