local tbFubenSetting = {};
Fuben:SetFubenSetting(6001, tbFubenSetting)

tbFubenSetting.szFubenClass 			= "PersonalFubenBase";									-- 副本类型
tbFubenSetting.szNpcPointFile 			= "Setting/Fuben/PersonalFuben/jm_1/NpcPos.tab"			-- NPC点
tbFubenSetting.tbBeginPoint 			= {3310, 4250}											-- 副本出生点
tbFubenSetting.nStartDir				= 48;

tbFubenSetting.NPC = 
{
	[1] = {nTemplate = 2506,		nLevel = -1, nSeries = 0},	--方位
	[2] = {nTemplate = 2507,		nLevel = -1, nSeries = 0},	--石碑
}

tbFubenSetting.LOCK = 
{
	-- 1号锁不能不填，默认1号为起始锁，nTime是到时间自动解锁，nNum表示需要解锁的次数，如填3表示需要被解锁3次才算真正解锁，可以配置字符串
	[1] = {nTime = 1, nNum = 0,
		--tbPrelock 前置锁，激活锁的必要条件{1 , 2, {3, 4}}，代表1和2号必须解锁，3和4任意解锁一个即可
		tbPrelock = {},
		--tbStartEvent 锁激活时的事件
		tbStartEvent = 
		{
			{"BlackMsg", "Nơi này hình như hơi kỳ lạ"},
		},
		--tbStartEvent 锁解开时的事件
		tbUnLockEvent = 
		{
			{"SetFubenProgress", 10, "Thăm Dò"},
			{"SetTargetPos", 2261, 4615},
		},
	},
	[2] = {nTime = 0, nNum = 1,
		tbPrelock = {1},
		tbStartEvent = 
		{
			{"TrapUnlock", "TrapLock1", 2},
		},
			tbUnLockEvent = 
		{
			{"BlackMsg", "Nơi này bố trí khá hợp lý"},
			{"AddNpc", 1, 1, 0, "Circle_1", "qiyu_1", false, 0, 0, 0, 0},
			{"NpcFindEnemyUnlock", "Circle_1", 3, 0},
			{"SetFubenProgress", 20, "Bước vào Đại Hữu Vị"},

		},
	},
	[3] = {nTime = 0, nNum = 1,
		tbPrelock = {2},
		tbStartEvent = 
		{
		},
			tbUnLockEvent = 
		{
			{"DelNpc", "Circle_1"},
			{"SetFubenProgress", 40, "Bước vào Phệ Hạp Vị"},
			{"AddNpc", 1, 1, 0, "Circle_2", "qiyu_2", false, 0, 0, 0, 0},
			{"NpcFindEnemyUnlock", "Circle_2", 4, 0},
		},
	},
	[4] = {nTime = 0, nNum = 1,
		tbPrelock = {3},
		tbStartEvent = 
		{
		},
			tbUnLockEvent = 
		{
			{"DelNpc", "Circle_2"},
			{"SetFubenProgress", 60, "Bước vào Vị Tế Vị"},
			{"AddNpc", 1, 1, 0, "Circle_3", "qiyu_3", false, 0, 0, 0, 0},
			{"NpcFindEnemyUnlock", "Circle_3", 5, 0},
		},
	},
	[5] = {nTime = 0, nNum = 1,
		tbPrelock = {4},
		tbStartEvent = 
		{
		},
			tbUnLockEvent = 
		{
			{"DelNpc", "Circle_3"},
			{"SetFubenProgress", 80, "Bước vào Đồng Nhân Vị"},
			{"AddNpc", 1, 1, 0, "Circle_4", "qiyu_4", false, 0, 0, 0, 0},
			{"NpcFindEnemyUnlock", "Circle_4", 6, 0},
		},
	},
	[6] = {nTime = 0, nNum = 1,
		tbPrelock = {5},
		tbStartEvent = 
		{
		},
			tbUnLockEvent = 
		{

			{"DelNpc", "Circle_4"},
			{"BlackMsg", "Quả nhiên có phát hiện!"},
			{"AddNpc", 2, 1, 7, "shibei", "qiyu_5", false, 0, 1, 9011, 1},
			{"SetFubenProgress", 90, "Điều tra Bia Đá"},
		},
	},
	[7] = {nTime = 0, nNum = 1,
		tbPrelock = {6},
		tbStartEvent = 
		{
		},
			tbUnLockEvent = 
		{
			{"OpenWindowAutoClose", "JingMaiMapPanel"},	
			{"RaiseEvent", "ShowTaskDialog", 9, 3207, true, 1},
		},
	},
	[9] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{
		},
			tbUnLockEvent = 
		{
			{"CloseWindow", "JingMaiMapPanel"},
			{"SetFubenProgress", 100, "Thoát sơn động"},
			{"GameWin"},
		},
	},
	[18] = {nTime = 600, nNum = 0,
		tbPrelock = {1},
		tbStartEvent = 
		{
			{"RaiseEvent", "RegisterTimeoutLock"},
			{"SetShowTime", 18},
		},
		tbUnLockEvent = 
		{
			{"GameLost"},
		},
	},
}