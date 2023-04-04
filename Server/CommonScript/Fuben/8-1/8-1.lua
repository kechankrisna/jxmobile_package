
local tbFubenSetting = {};
Fuben:SetFubenSetting(60, tbFubenSetting)		-- 绑定副本内容和地图

tbFubenSetting.szFubenClass 			= "PersonalFubenBase";									-- 副本类型
tbFubenSetting.szName 					= "Phó bản thử nghiệm"											-- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile 			= "Setting/Fuben/PersonalFuben/8_1/NpcPos.tab"			-- NPC点
--tbFubenSetting.szNpcExtAwardPath 		= "Setting/Fuben/PersonalFuben/8_1/ExtNpcAwardInfo.tab"	-- 掉落表
tbFubenSetting.szPathFile 				= "Setting/Fuben/PersonalFuben/8_1/NpcPath.tab"			-- 寻路点
tbFubenSetting.tbBeginPoint 			= {1934, 4965}											-- 副本出生点
tbFubenSetting.nStartDir				= 16;


-- ID可以随便 普通副本NPC数量 ；精英模式NPC数量

tbFubenSetting.ANIMATION = 
{
	[1] = "Scenes/Maps/yw_luoyegu/Main Camera.controller",
}

--NPC模版ID，NPC等级，NPC五行；
tbFubenSetting.NPC = 
{
	[1] = {nTemplate = 1915,	nLevel = -1,	nSeries = -1},	--恶狼
	[2] = {nTemplate = 1916,	nLevel = -1,	nSeries = -1},	--土匪
	[3] = {nTemplate = 1917,	nLevel = -1,	nSeries = -1},	--土匪精英
	[4] = {nTemplate = 1918,	nLevel = -1,	nSeries = -1},	--斗笠剑客
	[5] = {nTemplate = 2532,	nLevel = -1,	nSeries = 0},	--巨剑
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
			{"RaiseEvent", "ShowTaskDialog", 1, 1120, false},
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
			{"ChangeFightState", 1},
			{"TrapUnlock", "trap1", 3},
			{"SetTargetPos", 3388, 5050},
			{"AddNpc", 7, 1, 0, "wall", "men1",false, 42},
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
			{"AddNpc", 1, 8, 4, "gw", "guaiwu1", false, 0, 0.5, 9005, 0.5},
			{"RaiseEvent", "PartnerSay", "Cẩn thận, có sói dữ!!", 3, 1},
		},
		tbUnLockEvent = 
		{
			{"RaiseEvent", "PartnerSay", "Xem ra nơi đây không yên bình đâu...", 3, 1},
			{"BlackMsg", "Tiếp tục tiến lên"},
			{"OpenDynamicObstacle", "obs1"},
			{"DoDeath", "wall"},
		},
	},
	[5] = {nTime = 0, nNum = 1,
		tbPrelock = {4},
		tbStartEvent = 
		{
			{"TrapUnlock", "trap2", 5},
			{"SetTargetPos", 4950, 3050},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"AddNpc", 7, 1, 0, "wall", "men2",false, 64},
		},
	},
	[6] = {nTime = 0, nNum = 10,
		tbPrelock = {5},
		tbStartEvent = 
		{
			{"AddNpc", 2, 9, 6, "gw", "guaiwu2", false, 0, 0.5, 9005, 0.5},
			{"AddNpc", 3, 1, 6, "gw", "guaiwu2", false, 0, 0.5, 9005, 0.5},
			{"NpcBubbleTalk", "gw", "Đây là địa bàn của bọn ta! Mau biến đi chỗ khác!", 4, 1, 1},
		},
		tbUnLockEvent = 
		{
			{"RaiseEvent", "PartnerSay", "Bọn Thổ Phỉ này làm gì ở đây?", 3, 1},
			{"BlackMsg", "Tiếp tục tiến lên"},
			{"OpenDynamicObstacle", "obs2"},
			{"DoDeath", "wall"},
		},
	},
	[7] = {nTime = 0, nNum = 1,
		tbPrelock = {6},
		tbStartEvent = 
		{
			{"TrapUnlock", "trap3", 7},
			{"SetTargetPos", 2510, 2501},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"AddNpc", 2, 9, 0, "gw", "guaiwu3", false, 32, 0.5, 9009, 0.5},
			{"AddNpc", 3, 1, 0, "gw1", "guaiwu3", false, 32, 0.5, 9009, 0.5},
			{"AddNpc", 4, 1, 15, "sl", "shouling", false, 32, 0.5, 9009, 0.5},
			{"NpcBubbleTalk", "gw1", "Gan cũng to nhỉ, dám đến đây gây chuyện!", 4, 2, 1},
		},
	},
	[8] = {nTime = 0, nNum = 1,
		tbPrelock = {14},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"NpcBubbleTalk", "sl", "Tứ Tượng Kiếm Trận! Cho ta sức mạnh!", 4, 0, 1},
			{"PlayerBubbleTalk", "Muốn diệt hắn, phải phá trận trước"},
			{"NpcAddBuff", "sl", 1705, 1, 300},
			{"NpcAddBuff", "sl", 1707, 1, 300},
			{"NpcAddBuff", "sl", 2709, 3, 300},
			{"NpcAddBuff", "sl", 2452, 2, 300},	
			{"AddNpc", 5, 1, 10, "jj1", "jujian1", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 5, 1, 11, "jj2", "jujian2", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 5, 1, 12, "jj3", "jujian3", false, 32, 0.5, 9010, 0.5},
			{"AddNpc", 5, 1, 13, "jj4", "jujian4", false, 32, 0.5, 9010, 0.5},
		},
	},
	[14] = {nTime = 2, nNum = 0,
		tbPrelock = {7},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{	
			{"NpcHpUnlock", "sl", 8, 80},	
		},
	},
	[10] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{	
			{"NpcRemoveBuff", "sl", 1705},	
		},
	},
	[11] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{		
			{"NpcRemoveBuff", "sl", 1707},
		},
	},
	[12] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{	
			{"NpcRemoveBuff", "sl", 2709},	
		},
	},
	[13] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{	
			{"NpcRemoveBuff", "sl", 2452},	
		},
	},
	[15] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{		
		},
	},
	[9] = {nTime = 2.1, nNum = 0,
		tbPrelock = {15},
		tbStartEvent = 
		{
			{"DoDeath", "gw"},
			{"DoDeath", "gw1"},
			{"DoDeath", "jj1"},
			{"DoDeath", "jj2"},
			{"DoDeath", "jj3"},
			{"DoDeath", "jj4"},
			{"SetGameWorldScale", 0.1},		-- 慢镜头开始
		},
		tbUnLockEvent = 
		{
			{"SetGameWorldScale", 1},		-- 慢镜头结束
			{"GameWin"},
		},
	},
}