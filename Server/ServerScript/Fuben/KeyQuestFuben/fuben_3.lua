local DEFINE = Fuben.KeyQuestFuben.DEFINE
local tbFubenSetting = {};
local nMapTemplateId = DEFINE.FIGHT_MAP_ID[3]
-- local nPrepareTime   = DEFINE.PREPARE_TIME --准备时间
Fuben:SetFubenSetting(nMapTemplateId, tbFubenSetting)      -- 绑定副本内容和地图

tbFubenSetting.szFubenClass   = "KeyQuestFubenBase";                                  -- 副本类型
tbFubenSetting.szName         = DEFINE.NAME                  -- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile = "Setting/Fuben/KeyQuestFuben/NpcPos3.tab"          -- NPC点

--NPC模版ID，NPC等级，NPC五行；
--[[

]]



tbFubenSetting.NPC = 
{
     -- 采集宝箱：class是 FubenDialogEvent，参数1是开启时间，没填则无时间，2是开启时文字，3是开启后事件 OpenBox ，4是额外参数,对应随机奖励id
    [1] = {nTemplate = 2961,  nLevel = -1, nSeries = -1}, 
    --巨型宝箱， class 是 FubenDeath
    [2] = {nTemplate = 2962,  nLevel = -1, nSeries = -1}, 
}

tbFubenSetting.LOCK = 
{
    -- 1号锁不能不填，默认1号为起始锁，nTime是到时间自动解锁，nNum表示需要解锁的次数，如填3表示需要被解锁3次才算真正解锁，可以配置字符串
    [1] = {nTime = 5, nNum = 0,
        --tbPrelock 前置锁，激活锁的必要条件{1 , 2, {3, 4}}，代表1和2号必须解锁，3和4任意解锁一个即可
        tbPrelock = {},
        --tbStartEvent 锁激活时的事件
        tbStartEvent = 
        {
        },
        --tbStartEvent 锁解开时的事件
        tbUnLockEvent = 
        {
            {"SetShowTime", 8, false, "", true},    
            {"SetTargetInfo", "倒計時至[FFFE0D]4[-]分鐘時，有幾率刷出巨型寶箱",0, false, true }, --倒计时下面的提示信息
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
    [3] = {nTime = 49, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
 	
        },
        tbUnLockEvent = 
        {
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
            {"RaiseEvent", "AddPercetnNpcAndUpdateCount", "剩餘寶箱數", 1, 3, 0, "guaiwu1_1", "box", false, 0}, --刷新宝箱的操作, 同时刷新客户端的界面显示
        },
    },
    [6] = {nTime = 54, nNum = 0,
        tbPrelock = {5},
        tbStartEvent = 
        {                
        },
        tbUnLockEvent = 
        {
             {"Random", {1000000, 9} };  -- 1000/1000000 概率解锁 9号锁
        },
    },

    [7] = {nTime = 349, nNum = 0, --时间是相对前置锁的解锁时间
        tbPrelock = {1}, 
        tbStartEvent = 
        {                
        },
        tbUnLockEvent = 
        {
            {"OpenWindow", "SpecialTips", "本層即將關閉"},  --结束前10s倒计时提示
        },
    },

    [8] = {nTime = 359, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {
            
            {"RaiseEvent", "EndGame"},   --所有人传出
            {"GameWin"}, 
        },
    },

    --概率解锁
    [9] = {nTime = 0, nNum = 0,
        tbPrelock = {},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {
            
          {"RaiseEvent", "WorldNotify", "密室中刷出了巨型寶箱，請注意尋找"},  
          {"AddNpc", 2, 1, 0, "YuanGuGuanMu", "bigbox", false, 0}, --刷新怪物的操作
        },
    },
    

    
}