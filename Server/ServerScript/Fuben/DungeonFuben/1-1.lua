Require("ServerScript/Fuben/DungeonFuben/DungeonMgr.lua")
local tbFubenSetting = {};
Fuben:SetFubenSetting(Fuben.DungeonFubenMgr.nMapTemplateIdFrist, tbFubenSetting)		-- 绑定副本内容和地图

tbFubenSetting.nReadyTime 				= 600; --准备阶段时长，第一层时长
tbFubenSetting.szFubenClass 			= "DungeonFubenFloor1";									-- 副本类型
tbFubenSetting.szName 					= "Thần bí động quật"											-- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile 			= "Setting/Fuben/DungeonFuben/1_1/NpcPos.tab"			-- NPC点
--tbFubenSetting.szPathFile = "Setting/Fuben/TestFuben/NpcPos.tab"								-- 寻路点
tbFubenSetting.tbBeginPoint 			= {2050, 4800}											-- 副本出生点
tbFubenSetting.tbTempRevivePoint 		= {2050, 4800}											-- 临时复活点，副本内有效，出副本则移除
tbFubenSetting.tbLeavegGatePoint 		= {3369, 4438} 	-- 刷出离开副本的门的位置
tbFubenSetting.tbNextGatePoint	 		= {4724, 4418} 	-- 刷出去下一层的门的位置
tbFubenSetting.tbGuohuoPoint 			= {4071, 5077} 	-- 篝火位置
tbFubenSetting.nLeavegGateNpcId 		= 225 							--传送门npcid 
tbFubenSetting.nNextGateNpcId 			= 226 							--传送门npcid 
tbFubenSetting.nGuohuoNpcId 			= 695		--篝火npcid
tbFubenSetting.nStartDir				= 32;


-- AddNpc						说明：添加NPC 			
--								参数：nIndex npc序号(可用NUM内参数), nNum 添加数量(可用NUM内参数), nLock 死亡解锁Id, szGroup 所在分组名, szPointName 刷新点名, bRevive 是否重生
--								示例：{"AddNpc", "NpcIndex2", "NpcNum2", 3, "Test1", "NpcPos2"},

-- ChangeTrap					说明：更换trap传送点		
--								参数：szClassName Trap点名字, tbPoint 传送点坐标, bFight 传送后是否为战斗状态, bExit 是否离开副本, szEvent 是否调用事件
--								示例：{"ChangeTrap", "Trapname", {1533, 3660}, 0, 1, ""},

-- TrapUnlock					说明：玩家踩Trap 解锁
--								参数：szClassName Trap点名字, nLockId 解锁ID
--								示例：{"TrapUnlock", "Trapname", 1},

-- CloseLock					说明：关闭锁
--								参数：nBeginLockId 起始LockId, nEndLockId 结束Id
--								示例：{"CloseLock", 2, 4}, (关闭了 2，3，4 三个锁)， {"CloseLock", 2}, (只关闭 2号锁)

-- ChangeNpcAi					说明：改变AI, 参数: npc分组名,AI子指令（AI有以下类型可以更改)：
		-- Move 移动， 参数：路径名, 到达解锁ID, 是否主动攻击，是否还击，是否到达删除，例 {"ChangeNpcAi", "guaiwu", "Move", "Path1", 4, 1, 1, 1},

-- GameWin						说明：副本胜利，无参数

-- GameLost						说明：副本失败，无参数

-- RaiseEvent					说明：触发副本事件，不同类型副本所支持事件不同，具体事件说明请直接联系相关程序
--								参数：szEventName 事件名，... 事件所需参数
--								示例：{"RaiseEvent", "Log", "unlock lock 4"},

-- SetPos						说明：改变所有玩家所在坐标
--								参数：nX 设置X坐标, nY 设置Y坐标
--								示例：{"SetPos", 1589, 3188},

-- BlackMsg						说明：给所有副本内玩家黑条提示
--								参数：szMsg
--								示例：{"BlackMsg", "那啥？"},

-- UseSkill						说明：让指定NPC在某个坐标点释放技能
--								参数：szGroup npc组, nSkillId 技能ID, nMpsX, nMpsY
--								示例：{ "CastSkill", "guaiwu", 734, 51224, 101860},

-- OpenDynamicObstacle			说明：打开当前地图的动态障碍
--								参数：szObsName 动态障碍名
--								示例：{"OpenDynamicObstacle", "ops1"},

-- PlayCameraAnimation			说明：播放录制好的摄像机动画，同时摄像机进入动画模式，此模式下，摄像机不跟随玩家移动，播放结束后解锁 nLockId
--								参数：nAnimationId 动画Id 在 tbFubenSetting.ANIMATION 中定义, nLockId 播放结束后解锁的ID
--								示例：{"PlayCameraAnimation", 1, 2},

-- MoveCamera					说明：在nTime时间内平滑移动摄像机到目标位置，同时摄像机进入动画模式，此模式下，摄像机不跟随玩家移动，移动到目标位置时解锁 nLockId
--								参数：nLockId 播放结束后解锁的Id, nTime 移动到目标点需要耗时, 
--										nX 目标点 X 坐标（参数为 0 表示保持原参数）, nY 目标点 Y 坐标（参数为 0 表示保持原参数）, nZ 目标点 Z 坐标（参数为 0 表示保持原参数）, 
--										nrX 目标旋转 X（参数为 0 表示保持原参数）, nrY 目标旋转 Y（参数为 0 表示保持原参数）, nrZ 目标旋转 Z（参数为 0 表示保持原参数）
--								示例：{"MoveCamera", 3, 2, 28.06, 34.81, 20.03, 60.44, 81.254, 178.59},

-- LeaveAnimationState			说明：摄像机离开动画模式，恢复为摄像机跟随玩家，无参数

-- SetTargetPos					说明：设置玩家当前寻路目标点
--								参数：nX, nY
--								示例：{"SetTargetPos", 1000, 2000},

-- 单机副本支持接口
-- AddNpcWithoutAward			说明：添加 Npc，并且此Npc死亡不掉落任何物品，随机分配掉落不会对此Npc进行分配
--								参数：nIndex npc序号(可用NUM内参数), nNum 添加数量(可用NUM内参数), nLock 死亡解锁Id, szGroup 所在分组名, szPointName 刷新点名, bRevive 是否重生
--								示例：{"RaiseEvent", "AddNpcWithoutAward", "NpcIndex2", "NpcNum2", 3, "Test1", "NpcPos2"},

-- AddBoss						说明：添加 BOSS
--								参数：nIndex npc序号(可用NUM内参数), nLock 死亡解锁Id, szGroup 所在分组名, szPointName 刷新点名, szAwardType Boss奖励名
--								示例：{"RasieEvent", "AddBoss", "BossId1", 4, "BossGroup1", "BossPos1", "szBossAward_2"},

-- CheckResult					说明：检测当前副本结果，无参数
--								示例：{"RasieEvent", "CheckResult"},

-- 可用变量 NUM 的地方 
-- 每个 LOCK 的 nTime  nNum  
-- AddNpc 的参数 nIndex 和 nNum
-- 单机副本的 AddNpcWithoutAward 参数 nIndex
-- 单机副本的 AddBoss 参数 nIndex


-- ID可以随便 普通副本NPC数量 ；精英模式NPC数量
tbFubenSetting.NUM = 
{

}

--NPC模版ID，NPC等级，NPC五行；

--[[
664	    地宫首领
1307	  蝎子
1308      蜘蛛
1309      蜜蜂
104 	动态障碍墙
]]

tbFubenSetting.NPC = 
{
	[1] = {nTemplate = 664, nLevel = -1, nSeries = -1},
	[2] = {nTemplate = 1307, nLevel = -1, nSeries = -1},
	[3] = {nTemplate = 1308, nLevel = -1, nSeries = -1},
	[4] = {nTemplate = 104, nLevel = 1, nSeries = 0},
	[5] = {nTemplate = 1309, nLevel = -1, nSeries = -1},
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
		},
		--tbStartEvent 锁解开时的事件
		tbUnLockEvent = 
		{
			--{"RaiseEvent", "AddBoss",}, (nIndex, nLock, szGroup, szPointName, szAwardType)
			--{"RaiseEvent", "AddNpcWithoutAward",}, (nIndex, nNum, nLock, szGroup, szPointName, bRevive)
			{"RaiseEvent", "OwnerShowTaskDialog", 4002, false},
			{"AddNpc", 4, 1, 1, "wall1", "wall_1_1", false, 58},
			{"AddNpc", 4, 1, 1, "wall2", "wall_1_2", false, 33},
			{"AddNpc", 4, 1, 1, "wall3", "wall_1_3", false, 16},
		},
	},
	[2] = {nTime = 0, nNum = 0, 
		tbPrelock = {1},
		tbStartEvent = 
		{ 

		},

		tbUnLockEvent = 
		{
			{"RaiseEvent", "OwnerShowTaskDialog", 4000, true},	--对创建者的剧情对话 
			{"RaiseEvent", "OpenOwnerInvitePanel"},
		},
	},	
	[3] = {nTime = 0, nNum = 1, 
		tbPrelock = {2},
		tbStartEvent = 
		{
			{"ChangeFightState", 1},
			{"SetTargetPos", 4150, 2500},	
			{"TrapUnlock", "TrapLock1", 3},
		},
		tbUnLockEvent = 
		{
			{"BlackMsg", "Trong động lại có như thế nhiều to lớn côn trùng! Nhanh tiêu diệt bọn chúng!"},		
			{"AddNpc", 2, 5, 4, "guaiwu", "DungeonFloor1_1_1", false, 0 , 0, 9005, 0.5},
			{"AddNpc", 5, 5, 4, "guaiwu", "DungeonFloor1_1_2", false, 0 , 3, 9009, 0.5},
		},
	},	
	--刷小怪
	[4] = {nTime = 0, nNum = 10,
		tbPrelock = {3},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"SetTargetPos", 6000, 5050},		
			{"DoDeath", "wall1"},
			{"OpenDynamicObstacle", "ops1"},	
			{"BlackMsg", "Động quật lối vào đang dần dần biến mất! Đến tranh thủ thời gian mời cái khác hiệp sĩ!"},		
		},
	},	
	[5] = {nTime = 0, nNum = 1,
		tbPrelock = {4},
		tbStartEvent = 
		{
			{"TrapUnlock", "TrapLock2", 5},
		},
		tbUnLockEvent = 
		{
			{"AddNpc", 3, 5, 6, "guaiwu", "DungeonFloor1_2_1", false, 0 , 0, 9005, 0.5},
			{"AddNpc", 5, 5, 6, "guaiwu", "DungeonFloor1_2_2", false, 0 , 3, 9009, 0.5},			
		},
	},	
	[6] = {nTime = 0, nNum = 10,
		tbPrelock = {5},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"SetTargetPos", 4000, 4900},	
			{"DoDeath", "wall2"},
			{"OpenDynamicObstacle", "ops2"},
		},
	},	
	[7] = {nTime = 0, nNum = 1,
			tbPrelock = {6},
			tbStartEvent = 
		{
			{"TrapUnlock", "TrapLock3", 7},	
		},
			tbUnLockEvent = 
		{
			{"BlackMsg", "Thủ hộ giả xuất hiện! Đem đánh giết sau đem không cách nào mời cái khác hiệp sĩ!"},
			{"AddNpc", 1, 1, 8, "BOSS", "DungeonFloor1_BOSS", false, 0 , 0.5, 9011, 1},
		},
	},	
	[8] = {nTime = 0, nNum = 1,
		tbPrelock = {7},
		tbStartEvent = 
		{		
		},
		tbUnLockEvent = 
		{
			{"RaiseEvent", "OwnerShowTaskDialog", 4001, false},	--对创建者的剧情对话 
			{"RaiseEvent", "OpenGate"},		
			{"RaiseEvent", "CloseInvite"},		
		},
	},
	[9] = {nTime = tbFubenSetting.nReadyTime, nNum = 0,
		tbPrelock = {1},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"GameLost"},
		},
	},
}