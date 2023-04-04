Fuben.KeyQuestFuben = Fuben.KeyQuestFuben or {}
local KeyQuestFuben = Fuben.KeyQuestFuben

KeyQuestFuben.DEFINE = {
    SAVE_GROUP = 157;
    KEY_AWARD_SCORE = {1, 2};
    KEY_PLAY_SCORE = 5; --记录平均分
    KEY_PLAY_COUNT = 6; --记录平均场次

	NAME = "Di Tích Tầm Bảo"; --活动名
	TIME_FRAME = "OpenKeyQuestFuben"; --时间轴
    JOIN_UI_TIME_DESC = "Thời gian mở: 19:50-19:55 thứ 2 đến thứ 4";--报名界面上的时间描述

    READY_MAP_ID = 8007; --准备场地图
    FIGHT_MAP_ID = {
        [1] = 8004; --战斗场地图1
        [2] = 8005; --战斗场地图2
        [3] = 8006; --战斗场地图3
    }; 
    REVIVE_TIME = { --重生时间，单位是秒
        [1] = 10;
        [2] = 20;
        [3] = 50;
    };
    HAVE_KEY_BUFF_ID = { --获取钥匙时是给的一个buffid,分别对应1、2层
        [1] = 5136;
        [2] = 5135;
    };
    HAVE_KEY_TITLE_ID = { --获取钥匙时是给的一个buffid,分别对应1、2层
        [1] = 6806;
        [2] = 6807;
    };
    KEY_DROP_NPC_ID = {
        [1] = 2954; --掉落在地上的钥匙npc，class 是FubenDialogEvent，参数1是开启时间，没填则无时间，2是开启时文字，3是开启后事件 OpenKey
        [2] = 2955;
    };
    KEY_ITEM_ID = { --钥匙道具id
        [1] = 8368; 
        [2] = 8370;
    };
    KEY_TEAM_SPRITE = { --钥匙的图标
        [1] = "DeliverySymbol2";
        [2] = "DeliverySymbol1";
    };

    DROP_KEY_NPC = { --会掉钥匙的怪
        [2958] = 1;
        [2960] = 1;
    };
    BOSS_DROP_SETTING = {
        [3217] = {
            {{ "item",8373,1 },{ "item",8375,1 }}; --排名对应队伍奖励
			{{ "item",8371,1 },{ "item",8372,1 },{ "item",8375,0.5 }}; 
			{{ "item",8372,1 },{ "item",8375,0.25 }}; 
        };
    };


    MAP_NOTIFY_POS_NPCID = {
        [3217]  = "Bản đồ đã xuất hiện [FFFE0D]Vua Khỉ Ăn Vụng[-], các vị đại hiệp có thể đến diệt <Đến>";
    };

    -- SupplementAwardKey = "KeyQuestFuben"; --如果有奖励找回就去掉注释
    -- EverydayTargetKey = "KeyQuestFuben"; --如果有每日目标就去掉注释

    nProtectBuffId = 5137; --死亡保护buffid
    nProtectBuffTime = 40;--死亡保护buff时间
    nDeathProtectTotalTime = 60; --小于该死亡间隔时间总和就加buff
    nRecordDeathTimeCount = 3; --记录最近的几次死亡时间

    DEATH_DROP_KEY_RATE = 0.9; --死亡掉落钥匙概率
    
    SIGNUP_TIME = 60 * 5; --匹配时间

    MIN_LEVEL = 80;--最小参与等级
    MSG_NOTIFY_SIGNUP = "Di Tích Tầm Bảo đã mở báo danh, các vị đại hiệp chuẩn bị vào"; --开始报名时的走马灯
    CALENDAR_KEY = "KeyQuestFuben"; --日历key
    MIN_OPEN_NUM = 32; --最小开启人数
    OPENM_MATCH_GAP = { --划分场次时按照几场为一个战力段
        [1] = 4; 
        [2] = 3;
        [3] = 4;
    };
    OPENM_MATCH_NUM_FROM =  { --单场队伍范围 开启一层活动地图,每层单独配置
        [1] = { 6, 11 };  
        [2] = { 6, 11 };  
        [3] = { 5, 6};  
    }; 
    MAX_TEAM_ROLE_NUM = 4; --最大队伍内人数
    HELP_KEY = "KeyQuestFubenHelp"; --帮助key，准备场显示
    READY_MAP_POS = { --准备场随机点
        {7510, 5724};
        {6655, 4955};
		{6539, 6720};
		{3032, 6990};
		{2214, 5687};
    };

    FIGHT_MAP_RAND_POS = { --三层传入的随机点
    	[1]= {
		{12127, 2662};
		{10199, 2713};
		{7683, 3057};
		{5403, 2698};
		{3590, 3596};
		{4057, 6282};
		{5394, 6676};
		{7180, 6282};
		{9422, 5182};
		{9553, 11184};
		{9583, 9083};
		{6162, 9423};
		{2696, 11630};
		{4495, 10771};
		{5241, 12377};
    	};
    	[2]= {
		{8170, 2102};
		{3913, 2052};
		{834, 3494};
		{3151, 4051};
		{5626, 3424};
		{8233, 4203};
		{8917, 7862};
		{6355, 6990};
		{3523, 6442};
		{2103, 7675};
		{2596, 4995};
    	};
    	[3]= {
		{3453, 3314};
		{1305, 1936};
		{5992, 2039};
		{3533, 1603};
		{1335, 4747};
		{3495, 5212};
		{5839, 4765};
    	};
    };

    AWARD_MAIL_TXT = "Trong hoạt động Di Tích Tầm Bảo lần này nhận được [FFFE0D]%d[-] điểm Bạc và [FFFE0D]%d[-] điểm Hoàng Kim, hệ thống đã tự động đổi thành Bảo Rương, [FFFE0D]số điểm còn lại[-] không đủ để đổi 1 Bảo Rương sẽ [FFFE0D]tích lũy đổi vào lần sau[-], hãy chú ý nhận thưởng đính kèm!";

    EXCEPT_OPEN_BOX_LIMIT_NPC_ID = {
        [2962] = 1;
    };
    GATHER_ITEM_MAX_COUNT = {   --每层采集数上限
        [1]  = 14;
        [2]  = 10;
        [3]  = 6;
    };
    DROP_AWARD_ITEM = { --能兑换积分的道具，对应2种不同积分  
        [8371] = {100, 0};
        [8372] = {200, 0};
		[8373] = {500, 0};
		[8374] = {1000, 0};
        [8375] = {0, 200};
		[8376] = {0, 500};
		[8377] = {0, 1000};
    };

    FLOOR_DEATH_DROP = { --不同层死亡时是否会掉率道具
        [1] = true;
		[2] = true;
	    [3] = true;
    };

    DEATH_DROP_NPC_ID = 2956; --死亡掉落物品的npc  class 是FubenDialogEvent，参数1是开启时间，没填则无时间，2是开启时文字，3是开启后事件 OpenDeathDropItem 
    DEATH_DROP_MSG = "Bị Người Bí Ẩn đánh trọng thương rơi [FFFE0D]%s[-]"; --死亡时掉落道具的系统消息
    DROP_AWARD_ITEM_DEATH = {
        { nItemId = 8375, nDropRate = 0.1 }; --物品对应死亡掉落时概率
        { nItemId = 8376, nDropRate = 0.2 }; --物品对应死亡掉落时概率
		{ nItemId = 8377, nDropRate = 0.3 }; --物品对应死亡掉落时概率
    };

    EX_CHANGE_BOX_INFO = --不同积分兑换的宝箱
    {
        {8379, 500, "Rương Bạch Ngân"}, --道具id，积分、描述
        {8380, 1000, "Rương Hoàng Kim"} , 
    },


};

function KeyQuestFuben:GetMapFloor( nMapTemplateId )
    if not self.tbFloorToMapId then
        self.tbFloorToMapId = {};
        for i,v in ipairs(self.DEFINE.FIGHT_MAP_ID) do
            self.tbFloorToMapId[v] = i
        end
    end
    return self.tbFloorToMapId[nMapTemplateId]
end


function KeyQuestFuben:CanSignUp( pPlayer )
	if MODULE_GAMESERVER then
        if not Env:CheckSystemSwitch(pPlayer, Env.SW_SwitchMap) then
            return false, string.format("「%s」Trạng thái hiện tại không được đổi bản đồ", pPlayer.szName) 
        end
    end

    if DegreeCtrl:GetDegree(pPlayer, "KeyQuestFuben") < 1 then
        return false, string.format("「%s」Số lần tham gia không đủ", pPlayer.szName) 
    end

    if Battle.LegalMap[pPlayer.nMapTemplateId] ~= 1 then
        if Map:GetClassDesc(pPlayer.nMapTemplateId) ~= "fight" or pPlayer.nFightMode ~= 0 then
            return false, string.format("「%s」hiện không thể truyền tống vào Sảnh Chờ", pPlayer.szName) 
        end
    end
    return true
end

function KeyQuestFuben:GetAllCanShowItems()
    if not self.tbAllCanShowItemID then
        self.tbAllCanShowItemID = {}
        for i,v in ipairs(self.DEFINE.KEY_ITEM_ID) do
            self.tbAllCanShowItemID[v] = 1;
        end
        for k,v in pairs(self.DEFINE.DROP_AWARD_ITEM) do
           self.tbAllCanShowItemID[k] = 1; 
        end
    end
    return self.tbAllCanShowItemID
end