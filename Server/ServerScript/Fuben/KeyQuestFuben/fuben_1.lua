local DEFINE = Fuben.KeyQuestFuben.DEFINE
local tbFubenSetting = {};
local nMapTemplateId = DEFINE.FIGHT_MAP_ID[1]
Fuben:SetFubenSetting(nMapTemplateId, tbFubenSetting)      -- 绑定副本内容和地图

tbFubenSetting.szFubenClass   = "KeyQuestFubenBase";                                  -- 副本类型
tbFubenSetting.szName         = DEFINE.NAME                  -- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile = "Setting/Fuben/KeyQuestFuben/NpcPos1.tab"          -- NPC点

--NPC模版ID，NPC等级，NPC五行；
--[[

]]



tbFubenSetting.NPC = 
{
-- 采集宝箱：class是 FubenDialogEvent，参数1是开启时间，没填则无时间，2是开启时文字，3是开启后事件 OpenBox ，4是额外参数,对应随机奖励id
    [1] = {nTemplate = 2957,  nLevel = -1, nSeries = -1}, 
    --钥匙怪， class 是 FubenDeath
    [2] = {nTemplate = 2958,  nLevel = -1, nSeries = -1}, 
    --BOSS， class 是 FubenDeath
    [3] = {nTemplate = 3217,  nLevel = -1, nSeries = -1}, 
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
            {"SetShowTime", 10, false, "", true},    --参数：锁Id,是否下一帧执行，描述
            {"SetTargetInfo", "倒計時結束後，沒有傳送符將無法進入下一層",0, false, true}, --参数：szInfo 内容， nLockId 要嵌入的锁
        },
    },
	
    [2] = {nTime = 1, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {
			{ "RaiseEvent","UpdateScoreTimerInfo", "下一輪刷新時間", 5}; --界面上刷新指定锁的倒计时时间
        },
    },
	
    [3] = {nTime = 48, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {
            -- {"OpenWindow", "ReadyGo15"},      --15秒倒计时显示倒计时界面
			{"OpenWindow", "SpecialTips", "即將切換戰鬥模式"},  --切换PK模式10s倒计时提示

        },
    },
	[4] = {nTime = 10, nNum = 0,
        tbPrelock = {3},
        tbStartEvent = 
        {                 
        },
        tbUnLockEvent = 
        { 
			{"BlackMsg", "戰鬥開啟"}, 		
            {"ChangeFightState", 1},
        },
    },
	
    [5] = {nTime = 65, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {                
        },
        tbUnLockEvent = 
        {
        --npcIndex, nPercent 在场人数乘的系数 , nLock 死亡解锁Id,szGroup 所在分组名,szPointName 刷新点名,bRevive 是否重生,nDir 添加的Npc方向
            --增加npc的个是计算出来的，其他的和 AddNpc 一样
            {"RaiseEvent", "AddPercetnNpc", 1, 1, 0, "guaiwu1_1", "box", false, 0}, --刷新宝箱的操作
            {"RaiseEvent", "AddPercetnNpc", 2, 0.175, 0, "guaiwu1_2", "trans", false, 0}, --刷新怪物的操作
		    {"RaiseEvent","UpdateScoreTimerInfo", "下一輪刷新時間", 6}; --界面上刷新指定锁的倒计时时间
        },
    },
	
    [6] = {nTime = 185, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {                
        },
        tbUnLockEvent = 
        {
        --npcIndex, nPercent 在场人数乘的系数 , nLock 死亡解锁Id,szGroup 所在分组名,szPointName 刷新点名,bRevive 是否重生,nDir 添加的Npc方向
            --增加npc的个是计算出来的，其他的和 AddNpc 一样
            {"RaiseEvent", "AddPercetnNpc", 1, 2, 0, "guaiwu1_1", "box", false, 0}, --刷新宝箱的操作
            {"RaiseEvent", "AddPercetnNpc", 2, 0.175, 0, "guaiwu1_2", "trans", false, 0}, --刷新怪物的操作
		    {"RaiseEvent","UpdateScoreTimerInfo", "下一輪刷新時間", 7}; --界面上刷新指定锁的倒计时时间
        },
    },
	
    [7] = {nTime = 305, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {                
        },
        tbUnLockEvent = 
        {
        --npcIndex, nPercent 在场人数乘的系数 , nLock 死亡解锁Id,szGroup 所在分组名,szPointName 刷新点名,bRevive 是否重生,nDir 添加的Npc方向
            --增加npc的个是计算出来的，其他的和 AddNpc 一样
            {"RaiseEvent", "AddPercetnNpc", 1, 2, 0, "guaiwu1_1", "box", false, 0}, --刷新宝箱的操作
            {"RaiseEvent", "AddPercetnNpc", 2, 0.175, 0, "guaiwu1_2", "trans", false, 0}, --刷新怪物的操作
		    {"RaiseEvent","UpdateScoreTimerInfo", "下一輪刷新時間", 8}; --界面上刷新指定锁的倒计时时间
        },
    },
	
    [8] = {nTime = 425, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {                
        },
        tbUnLockEvent = 
        {
        --npcIndex, nPercent 在场人数乘的系数 , nLock 死亡解锁Id,szGroup 所在分组名,szPointName 刷新点名,bRevive 是否重生,nDir 添加的Npc方向
            --增加npc的个是计算出来的，其他的和 AddNpc 一样
            {"RaiseEvent", "AddPercetnNpc", 1, 2, 0, "guaiwu1_1", "box", false, 0}, --刷新宝箱的操作
            {"RaiseEvent", "AddPercetnNpc", 2, 0.175, 0, "guaiwu1_2", "trans", false, 0}, --刷新怪物的操作
			{"AddNpc", 3, 1, 0, "boss", "boss", false},--刷新怪物的操作
        },
    },
	
    [9] = {nTime = 648, nNum = 0, --时间是相对前置锁的解锁时间
        tbPrelock = {1}, 
        tbStartEvent = 
        {                
        },
        tbUnLockEvent = 
        {
            {"OpenWindow", "SpecialTips", "本層即將關閉"},  --结束前10s倒计时提示
        },
    },

    [10] = {nTime = 658, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {
            --传入下层操作, 没有钥匙的则传出
            {"RaiseEvent", "SendKeyTeamToNextFloor"},
        },
    },
    [11] = {nTime = 10, nNum = 0,
        tbPrelock = {10},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {
            {"GameWin"},  --关闭房间操作
        },
    },
    

    
}