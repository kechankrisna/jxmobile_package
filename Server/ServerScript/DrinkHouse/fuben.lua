local tbRentDef = DrinkHouse.tbRentDef
local tbFubenSetting = {};
local nMapTemplateId = tbRentDef.RENT_MAP
Fuben:SetFubenSetting(nMapTemplateId, tbFubenSetting)      -- 绑定副本内容和地图

tbFubenSetting.szFubenClass   = "DrinkRentFubenBase";                                  -- 副本类型
tbFubenSetting.szName         = tbRentDef.NAME                  -- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile = "Setting/Fuben/DrinkHouse/NpcPos.tab"          -- NPC点

tbFubenSetting.NPC = 
{
    -- 篝火npc
    [1] = {nTemplate = 3238,  nLevel = -1, nSeries = -1},  
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
            {"SetShowTime", 2, false, "", true},    --参数：锁Id,是否下一帧执行，描述
            {"SetTargetInfo", "Chờ đợi yến hội bắt đầu",0, false, true}, --参数：szInfo 内容， nLockId 要嵌入的锁
        },
    },
	
    [2] = {nTime = 120, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    

        },
        tbUnLockEvent = 
        {
            {"AddNpc", 1, 1, 0, "box", "box"},
            {"SetTargetInfo", "[Khai vị] đang đánh giá",0, false, true}, --参数：szInfo 内容， nLockId 要嵌入的锁
            {"RaiseEvent", "ServeFood"}; --每调一次代表开始下一轮上菜
            {"RaiseEvent", "MapNotify", "Món khai vị đã lên, xin mọi người chậm rãi nhấm nháp!"};
            {"SetShowTime", 5, false, "", true},    --参数：锁Id,是否下一帧执行，描述
        },
    },
    [3] = {nTime = 20, nNum = 0,
        tbPrelock = {2},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {        
            {"RaiseEvent", "OpenDice"}; --投掷骰子
        },
    },
	[4] = {nTime = 70, nNum = 0,
        tbPrelock = {3},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {
            {"RaiseEvent", "EndDice"}; --结束投掷骰子
        },
    },
    
    [5] = {nTime = 240, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
             
        },
        tbUnLockEvent = 
        {
            {"SetTargetInfo", "[Niên Niên Hữu Dư] đang đánh giá",0, false, true}, --参数：szInfo 内容， nLockId 要嵌入的锁                  
            {"RaiseEvent", "ServeFood"}; 
            {"RaiseEvent", "MapNotify", "Món thứ 2, xin hãy từ từ nếm thử!"};                
            {"SetShowTime", 8, false, "", true},    --参数：锁Id,是否下一帧执行，描述      
        },
    },
    [6] = {nTime = 20, nNum = 0,
        tbPrelock = {5},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {        
            {"RaiseEvent", "OpenDice"}; --投掷骰子
        },
    },
    [7] = {nTime = 70, nNum = 0,
        tbPrelock = {6},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {
            {"RaiseEvent", "EndDice"}; --结束投掷骰子
        },
    },
    
    [8] = {nTime = 360, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {
            {"SetTargetInfo", "[Đông Phương Minh Phượng] đang đánh giá",0, false, true}, --参数：szInfo 内容， nLockId 要嵌入的锁                  
            {"RaiseEvent", "ServeFood"}; 
            {"RaiseEvent", "MapNotify", "Món thứ 3 Đông Phương Minh phượng, xin mọi người đánh giá!"};                 
            {"SetShowTime", 11, false, "", true},    --参数：锁Id,是否下一帧执行，描述       
        },
    },
    [9] = {nTime = 20, nNum = 0,
        tbPrelock = {8},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {          
            {"RaiseEvent", "OpenDice"}; --投掷骰子
        },
    },
    [10] = {nTime = 70, nNum = 0,
        tbPrelock = {9},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {
            {"RaiseEvent", "EndDice"}; --结束投掷骰子
        },
    },

    [11] = {nTime = 480, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {
            {"SetTargetInfo", "[Vận May Đoàn Viên] đang đánh giá",0, false, true}, --参数：szInfo 内容， nLockId 要嵌入的锁                                    
            {"RaiseEvent", "ServeFood"}; 
            {"RaiseEvent", "MapNotify", "Món thứ tư vận may đoàn viên, chúc bang phái hưng thịnh, toàn gia đoàn viên!"};   
            {"SetShowTime", 14, false, "", true},    --参数：锁Id,是否下一帧执行，描述        
        },
    },
    [12] = {nTime = 20, nNum = 0,
        tbPrelock = {11},
        tbStartEvent = 
        {    
            
        },
        tbUnLockEvent = 
        {          
            {"RaiseEvent", "OpenDice"}; --投掷骰子
        },
    },
    [13] = {nTime = 70, nNum = 0,
        tbPrelock = {12},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {
            {"RaiseEvent", "EndDice"}; --结束投掷骰子
            {"CloseWindow", "KinDicePanel"},
            {"SetTargetInfo", "Đang tiến hành ném xúc xắc",0, false, true}, --参数：szInfo 内容， nLockId 要嵌入的锁
        },
    },

    [14] = {nTime = 630, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {
            {"RaiseEvent", "MapNotify", "Bổn tràng yến hội đã kết thúc, hoan nghênh lần sau trở lại!"};
            {"RaiseEvent", "KinMessage", "「%s」tổ chức yến hội đã kết thúc!"};
            {"SetShowTime", 15, false, "", true},    --参数：锁Id,是否下一帧执行，描述
            {"SetTargetInfo", "Gian phòng sắp đóng",0, false, true}, --参数：szInfo 内容， nLockId 要嵌入的锁  
        },
    },
    [15] = {nTime = 750, nNum = 0,
        tbPrelock = {1},
        tbStartEvent = 
        {    
        },
        tbUnLockEvent = 
        {
            {"GameWin"},  --关闭房间操作
        },
    },   
}