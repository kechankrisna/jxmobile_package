 Require("CommonScript/SdkDef.lua");

Recharge.IS_OPEN = true;
Recharge.IS_OPEN_INVEST = true;--是否开启一本万利
Recharge.IS_OPEN_BUY_ENHANCE = true;--是否开启强化直够
Recharge.IS_OPEN_BUY_DRESS = true;--是否开启购买外装货币

Recharge.nExtInterConnectVipGetGoldPercent = 0.005;  --获得VIP 经验的同时获得其额外元宝赠送

local Define_WeekCard = 1
local Define_MonthCard = 2
local Define_SuperWeekCard = 3


Recharge.SAVE_GROUP 	= 20;
Recharge.KEY_TOTAL_ONLY_GOLD = 1; -- 买金币的累积充值金额，实际总额要加上KEY_TOTAL_CARD --有异步数据进行同步
Recharge.KEY_TOTAL_ONLY_GOLD2 = 57; --超过21亿部分的 买金币的累积充值金额
Recharge.TOTAL_RECHARGE_LARGE = 2^31;

Recharge.KEY_VIP_AWARD  = 3; --玩家已购买哪个档次的礼包，用标识位，从0开始
Recharge.KEY_BUYED_FLAG = 4; -- 玩家已买过的哪个档次的充值，首冲奖励用

Recharge.tbKeyGrowBuyed = {5, 23, 31, 38, 50,59, 65, 74, 75, 79} --一本万利是否购买了
Recharge.tbKeyGrowTaked = {6, 24, 32, 39, 51,60, 66, 76, 77, 80} -- 拿了几档的一本万利奖励 用bit位存
Recharge.KEY_INVEST_ACT_TAKEDAY = 48;
Recharge.KEY_INVEST_BACK_TAKEDAY = 72;

Recharge.tbDayCardTakeKey = {
	[Define_WeekCard] 	= 9; --周卡
	[Define_MonthCard] 	= 8; --月卡
	[Define_SuperWeekCard] = 83;--至尊周卡
}

Recharge.KEY_TOTAL_CARD = 10; --卡类的充值总额

Recharge.KEY_GET_FIRST_RECHARGE = 12; --是否获得了首冲礼包

Recharge.KEY_VIP_AWARD_EX  = 18; --后面对vip的内容又改了所以换了标识 --在一个月后就不检查这个的不同了
Recharge.KEY_BUYED_FLAG_TIME = 19;--上次购买哪个档次的充值的时间，用于活动重置每挡的首冲用

--累计充值
Recharge.KEY_ACT_SUM_R = 25
Recharge.KEY_ACT_SUM_SET_TIME_R = 26
Recharge.KEY_ACT_SUM_TAKE_R = 27
--累计消耗
Recharge.KEY_ACT_SUM_C = 28
Recharge.KEY_ACT_SUM_SET_TIME_C = 29
Recharge.KEY_ACT_SUM_TAKE_C = 30

Recharge.KEY_ACT_CONTINUAL_DATA_DAY = 33 --连续充值相关存储
Recharge.KEY_ACT_CONTINUAL_DAYS = 34
Recharge.KEY_ACT_CONTINUAL_FLAG = 35
Recharge.KEY_ACT_CONTINUAL_RECHARGE = 36
Recharge.KEY_ACT_CONTINUAL_SESSION_TIME = 37

Recharge.KEY_ONE_DAY_CARD_PLUS_COUNT = { --剩余的可领取一键礼包次数
	 62, 86
}
Recharge.KEY_ONE_DAY_CARD_PLUS_DAY = { --领取一键礼包的天数，每天只能领取一次
	63,
	87
};
Recharge.DayGiftTypeGroups = { --两种每日礼包套包，数量不同
	{1,2,3};
	{1,2,3,4};
}


Recharge.KEY_ACT_NEWYEARGIFT_RESET = 58 --新年大礼包的活动开启时间，区分版本清除玩家是否已经购买
Recharge.KEY_ACT_INVEST_RESET = 64 --新年一本万利的活动开启时间，区分版本清除玩家是否已经购买

Recharge.RATE 			= 0.1; --1分 与元宝的兑换比例是10：1
Recharge.tbMoneyRMBRate = { --不同币种 分 * rate = 对应RMB 分，决定vip经验，运营后不能改变
    ["RMB"] = 1,
    ["VND"] = 3, --越南币元 对应 0.01分
    ["HKD"] = 0.76, --港币分 对应 1分
    ["TWD"] = 0.2, --台币
    ["USD"] = 6.8, --美元    
    ["THB"] = 0.25, --泰铢
    ["KRW"] = 60 / 13200, --韩币 ,含税
}

if version_kor then
	Recharge.tbMoneyRMBRate["USD"] = 60 / 11;  --含税是1.1
end

--第三个参数是 界面上显示的字符格式
Recharge.tbMoneyName = {
    ["RMB"] = {"Tệ", "¥", "%d", 0.01}, --第四个值是存盘值 与显示值（界面） 的转换比率
    ["VND"] = {" VNĐ", "VND", "%d", 100},
    ["HKD"] = {"HK","HKD", "%d", 0.01},
    ["TWD"] = {"Đài tệ", "TWD", "%d", 0.01},
    ["USD"] = {"USD", "$", "%.2f", 0.01},
    ["THB"] = {"Baht Thái", "THB", "%d", 0.01},
    ["KRW"] = {"Won", "₩", "%d", 0.01},
}

--第三方支付的货币分 与元宝的兑换比例
Recharge.tbMoneyThirdRate = {
	["RMB"] = 0.1,
	["TWD"] = 0.022,
	["HKD"] = 0.022 * 3.8,
	["USD"] = 0.022 * 34,
	["VND"] = 0.4, --这里是100越南盾对应的元宝数
	["THB"] = 0.025,
	["KRW"] = 60/132000, 
}

if version_vn and IOS then
	Recharge.tbRechareBuyGoldShowPrice = {
		"45,000";
		"69,000";
		"129,000";
		"699,000";
		"1,299,000";
		"1,999,000";
	}
end

if version_xm then
	Recharge.tbMoneyThirdRate["USD"] = 0.77 --只是已购买项重复买时 1：70 再乘额外的1.1
elseif version_kor then
	Recharge.tbMoneyThirdRate["USD"] = 60/110 --
end


--泰国不同第三方充值渠道对应不同的元宝兑换比率
Recharge.tbMoneyThirdRatePlatform = {
	["PlatformPay"] = 1;
	["PlatformPay_B2"] = 1;
	["PlatformPay_D1"] = 1;
	["PlatformPay_E1"] = 1;
	["PlatformPay_I1"] = 1;
	["PlatformPay_I2"] = 1;
	["PlatformPay_L3"] = 1;
	["PlatformPay_N1"] = 1;
	["PlatformPay_N2"] = 1;
	["PlatformPay_P1"] = 1;
	["PlatformPay_S1"] = 1;
	["PlatformPay_T1"] = 1;
	["PlatformPay_T2"] = 1;
	["PlatformPay_U1"] = 1;
	["PlatformPay_W"] = 1;
};



Recharge.THIRD_GET_GOLD_RATE = 1.1; --新马版的根据传过来的元宝数对应实际赠送元宝数倍率


Recharge.tbDaysCardBuyLimitDay = {
	3, 5, 3 --周卡剩余天数《=3才可重新购买，  --月卡剩余天数《=5才可重新购买
}

Recharge.nFirstAwardItem = 1240--首冲奖励

Recharge.tbDressMoneyBuySetting = {
	{ 
		PropId = {
			[0] = "39336"; --IOS
			[1] = "39258"; --android
		};
		ActionId = "4837";
		ProductId = "com.tencent.jxqy.clothing98";
		nCostRMB = 98;
		nGetMoney = 1000;
	};
	{ 
		PropId = {
			[0] = "74771"; --IOS
			[1] = "74770"; --android
		};
		ActionId = "4837";
		ProductId = "com.tencent.jxqy.clothing298";
		nCostRMB = 298;
		nGetMoney = 3100;
	};
	{ 
		PropId = {
			[0] = "74773"; --IOS
			[1] = "74772"; --android
		};
		ActionId = "4837";
		ProductId = "com.tencent.jxqy.clothing648";
		nCostRMB = 648;
		nGetMoney = 6900;
	};
}

Recharge.MAX_COMPENSATION = 6 -- 晚进服补偿
Recharge.tbCompensationAward = {
	{"Item", 1458, 1},
	{"Item", 1459, 1},
	{"Item", 1460, 1},
	{"Item", 1461, 1},
	{"Item", 1462, 1},
	{"Item", 2275, 1},
}

Recharge.fActivityCardAwardParam = 100; --周月卡的奖励百分比

Recharge.tbDaysCardkeyActiviy = {
	[Define_WeekCard] 		= {14, 8}; --周卡
	[Define_MonthCard] 		= {14, 7}; --月卡
	[Define_SuperWeekCard] 	= {20, 84}; --至尊周卡

}

Recharge.tbSaveKeySuperDaysCard = { --至尊周卡资格的购买次数
	[Define_SuperWeekCard] = 81;
}

--月卡，每天领取奖励
Recharge.tbDayCardAward = {
	[Define_WeekCard] = {
	    { {{"Gold", 150000   }}, "OpenLevel39"};
	    { {{"Gold", 150000   }}, "OpenLevel79"};
		{ {{"Gold", 150000   }}, "OpenLevel89"};
		{ {{"Gold", 150000   }}, "OpenLevel99"};
		{ {{"Gold", 150000   }}, "OpenLevel109"};
		{ {{"Gold", 150000   }}, "OpenLevel119"};
	}; 
	[Define_MonthCard] = {
		{ {{"Gold", 150000   }}, "OpenLevel39"};
		{ {{"Gold", 150000   }}, "OpenLevel79"};
		{ {{"Gold", 150000   }}, "OpenLevel89"};
		{ {{"Gold", 150000   }}, "OpenLevel99"};
		{ {{"Gold", 150000   }}, "OpenLevel109"};
		{ {{"Gold", 150000   }}, "OpenLevel119"};
	};
	[Define_SuperWeekCard] = {
		{ {{"Gold", 300000   }}, "OpenLevel39"};
	    { {{"Gold", 300000   }}, "OpenLevel89"};
		{ {{"Gold", 300000   }}, "OpenLevel99"};
		{ {{"Gold", 300000   }}, "OpenLevel109"};
		{ {{"Gold", 300000   }}, "OpenLevel119"};
	};
};

if version_hk or version_tw then
	--周卡，每天领取奖励
	Recharge.tbDayCardAward[Define_WeekCard] = 
	{
		{ {{"Gold", 150000   }}, "OpenLevel39"};
	}
elseif version_vn then
	Recharge.tbDayCardAward[Define_MonthCard] = 
	{
		{ {{"Gold", 150000   }}, "OpenLevel39"};
	}
end

--活动一本万利配置
Recharge.tbGrowInvestActSetting = {
	szNameInPanel = "Quà Phiên Bản";
	szTextureInPanel = "UI/Textures/GrowInvest_Box.png";
	szBuyTimeLimit = "Thời hạn: 28/1 đến 3/2/2019"
};
if version_xm then
	Recharge.tbGrowInvestActSetting.szNameInPanel = "Năm Mới";
	Recharge.tbGrowInvestActSetting.szBuyTimeLimit = "Thời hạn: 16/2-28/2/2018"
end

-- 活动充值礼包配置
Recharge.tbNewYearBuyGiftActSetting = {
	szNameInPanel = "Quà Xuân Mới";
	szPanelLine1  = "Trân Bảo Hoa Thể";
	szPanelLine2  = "Quà Mừng Năm Mới";
	szTextureInPanel = "UI/Textures/GrowInvest02.png";
	szBugNotifyMsg = "";
};

if version_vn then
	Recharge.tbNewYearBuyGiftActSetting.szNameInPanel = "Quà Thiên Long"
	Recharge.tbNewYearBuyGiftActSetting.szPanelLine1  = "Hoa nở khắp bắc nam";
	Recharge.tbNewYearBuyGiftActSetting.szPanelLine2  = "Phượng long vui bay lượn";
	Recharge.tbNewYearBuyGiftActSetting.szTextureInPanel = "UI/Textures/PresentBoxBG.png";
end

---活动充值礼包的配置项
Recharge.tbNewYearBuySetting =
{
	{ nBuyCount = 5, nCanBuyDay = 0,  nSaveCountKey = 49 }; 
	{ nBuyCount = 1, nCanBuyDay = 0,  nSaveCountKey = 78 }; --活动开启后nCanBuyDay天才可购买
	{ nBuyCount = 1, nCanBuyDay = 0, };
	{ nBuyCount = 1, nCanBuyDay = 0, nSaveCountKey = 85}; 
}

--领取这些vip礼包的时间key，方便后期奖励调整时进行补偿
Recharge.tbVipAwardTakeTimeKey = {
	[14] = 20, --V14 --saveKey
	[15] = 21,
	[16] = 22,
}

Recharge.tbDirectEnhanceSetting = { --强化直升道具购买的配置
	{OpenTimeFrame = "OpenLevel59", nPlayerLevel = 20; nEnhanceLevel = 20; };
	{OpenTimeFrame = "OpenLevel69", nPlayerLevel = 30; nEnhanceLevel = 30; };
	{OpenTimeFrame = "OpenLevel79", nPlayerLevel = 40; nEnhanceLevel = 40; };
	{OpenTimeFrame = "OpenLevel89", nPlayerLevel = 50; nEnhanceLevel = 50; };
};




--一本万利的推送等级
Recharge.tbProptGrowInvestLevel = {
 	{ 60, 50, 40 },
 	{ 85, 75 },
 	{ 96, 90},
 	{ 999, 999}, --新年的是不推送的
 	{ 106, 100},
 	{ 116, 110},
 	{ 999, 999}, --老玩家回归一本万利
 	{ 126, 130},
 	{ 136, 140},
 	{ 146, 150},
}



--- VIP的设置 ,以分为单位
Recharge.tbVipSetting = {
	--累积充值人民币数
	600,				--V1
	3000,				--V2
	6000,				--V3
	15000,				--V4
	30000,				--V5
	60000,				--V6
	90000,				--V7
	150000,				--V8
	300000,				--V9
	600000,				--V10
	900000,				--V11
	1500000,			--V12
	3000000,			--V13
	6000000,			--V14
	9000000,			--V15
	12000000,			--V16
	16000000,			--V17
	20000000,			--V18
}

Recharge.tbVipTimeFrameSetting =
{
	[15] = "OpenLevel69"; --OpenLevel69才开放VIP15
	[16] = "OpenLevel69"; --OpenLevel69才开放VIP16
	[17] = "OpenLevel89";
	[18] = "OpenLevel89";
}

Recharge.nMaxVip = #Recharge.tbVipSetting

Recharge.VIP_SHOW_LEVEL = { --vip特效标识显示
	[1] = "V_Blue_",
	[2] = "V_Blue_",
	[3] = "V_Blue_",
	[4] = "V_Blue_",
	[5] = "V_Blue_",

	[6] = "V_Purple_",
	[7] = "V_Purple_",
	[8] = "V_Purple_",

	[9] = "V_Pink_",
	[10] = "V_Pink_",
	[11] = "V_Pink_",

	[12] = "V_Orange_",
	[13] = "V_Orange_",
	[14] = "V_Orange_",
	[15] = "V_Orange_",
	[16] = "V_Golden_",
	[17] = "V_Golden_",
	[18] = "V_Golden_",
}

assert( #Recharge.VIP_SHOW_LEVEL == #Recharge.tbVipSetting)

--vip特权礼包 ,不能超过32档
Recharge.tbVipAward = {
	--从vip 0 开始
	{
		nShowPrice  = 200,
		nRealPrice  = 8,
		nGiveItemId = 1317, --实际给的道具id
	},

	--VIP1
	{
		nShowPrice  = 400,
		nRealPrice  = 18,
		nGiveItemId = 1318,
	},

	--VIP2
	{
		nShowPrice  = 480,
		nRealPrice  = 28,
		nGiveItemId = 1319,
	},

	--VIP3
	{
		nShowPrice  = 650,
		nRealPrice  = 48,
		nGiveItemId = 1320,
	},

	--VIP4
	{
		nShowPrice  = 1600,
		nRealPrice  = 98,
		nGiveItemId = 1321,
	},

	--VIP5
	{
		nShowPrice  = 1550,
		nRealPrice  = 118,
		nGiveItemId = 1322,
	},

	--VIP6
	{
		nShowPrice  = 1675,
		nRealPrice  = 148,
		nGiveItemId = 1323,
	},

	--VIP7
	{
		nShowPrice  = 2650,
		nRealPrice  = 278,
		nGiveItemId = 1324,
	},

	--VIP8
	{
		nShowPrice  = 6000,
		nRealPrice  = 648,
		nGiveItemId = 1325,
	},

	--VIP9
	{
		nShowPrice  = 7600,
		nRealPrice  = 848,
		nGiveItemId = 1326,
	},

	--VIP10
	{
		nShowPrice  = 7850,
		nRealPrice  = 948,
		nGiveItemId = 1327,
	},

	--VIP11
	{
		nShowPrice  = 7650,
		nRealPrice  = 1048,
		nGiveItemId = 1328,
	},

	--VIP12
	{
		nShowPrice  = 8450,
		nRealPrice  = 1148,
		nGiveItemId = 1329,
	},

	--VIP13
	{
		nShowPrice  = 9400,
		nRealPrice  = 1288,
		nGiveItemId = 1330,
	},

	--VIP14
	{
		nShowPrice  = 14400,
		nRealPrice  = 2388,
		nGiveItemId = 1331,
	},

	--VIP15
	{
		nShowPrice  = 16400,
		nRealPrice  = 2988,
		nGiveItemId = 1332,
	},

	--VIP16
	{
		nShowPrice  = 18500,
		nRealPrice  = 3688,
		nGiveItemId = 1333,
	},

	--VIP17
	{
		nShowPrice  = 24000,
		nRealPrice  = 4688,
		nGiveItemId = 3076,
	},

	--VIP18
	{
		nShowPrice  = 29800,
		nRealPrice  = 5888,
		nGiveItemId = 3077,
	},
}

--VIP的特权设置参数, 具体调用自定义吧
Recharge.tbVipExtSetting = {
	["ExFriendNum"] = {{4, 50}, {18, 50} }, --额外的好友上限, 是累计的

	["public_chat"] = { 6, 15 }, --VIP6 以后公聊间隔变15s

	["ChuangGongLevelMinus"] = { --传功等级差要求
		--vip 等级， 等级差要求
		{0, 	3},
		{9, 	2},
		{15, 	1},
	},

	--vip等级对应家族捐献获得贡献加成
	KinDonateContributeInc = {
		{14, 0.2},	-- vip >= 14,加成20%
	},

	--亲密度提升速度+20%
	AddImity = { 11, 1.2 };

	TeacherStudentConnectLvDiff = {	--师徒拜师收徒最小等级差
		{0, 5},	-- vip>=0, LvDiff=5
		{6, 4},
		{9, 3},
		{12, 2},
	},

	KinGiftBoxInc = {	--vip等级增加家族礼盒数量
		{7, 1},	-- vip>=7, 增加1个（绝对值）
	},
}

--上面的固定描述
Recharge.tbVipDescFix = {
	--VIP0
[[
]],

--VIP1
[[

]],

--VIP2
[[

]],

--VIP3
[[

]],

--VIP4
[[

]],

--VIP5
[[

]],

--VIP6
[[

]],

--VIP7
[[

]],

--VIP8
[[

]],

--VIP9
[[

]],

--VIP10
[[

]],

--VIP11
[[

]],

--VIP12
[[

]],

--VIP13
[[

]],

--VIP14
[[

]],

--VIP15
[[

]],

--VIP16
[[

]],

--VIP17
[[

]],

--VIP18
[[

]],
}

--特权说明, 从0 级开始
Recharge.tbVipDesc = {
--VIP0
[[
●  Góp bang hội mỗi ngày: [fefb1a]10[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]10[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]10[-] lần
]],

--VIP1
[[
●  Được mua gói siêu giá trị [fefb1a]5,000[-] VNĐ
●  Truyền công mỗi ngày tăng: [fefb1a]1→2[-]lần
●  Góp bang hội mỗi ngày: [fefb1a]10→20[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]10→20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　     [fefb1a]    10[-] lần
]],

--VIP2
[[
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]0→5[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]10→20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000[-] VNĐ
●  Truyền công mỗi ngày tăng: [fefb1a]2[-]lần
●  Góp bang hội mỗi ngày: [fefb1a]20[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]10[-] lần
]],

--VIP3
[[
●  Góp bang hội mỗi ngày: [fefb1a]20→25[-] lần
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]5[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000[-] VNĐ
●  Truyền công mỗi ngày tăng: [fefb1a]2[-]lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]10[-] lần
]],

--VIP4
[[
●  Giới hạn hảo hữu tăng: [fefb1a]  50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]5[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Truyền công mỗi ngày tăng: [fefb1a]2[-]lần
●  Góp bang hội mỗi ngày: [fefb1a]25[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]10[-] lần
]],

--VIP5
[[
●  Nhận đặc quyền tổ chức hôn lễ [fefb1a]Trang Viên[-]
●  Số lần cầu cứu nhiệm vụ thương hội: [fefb1a]3→4[-]
●  Giới hạn hảo hữu tăng:   [fefb1a] 50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]5[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Truyền công mỗi ngày tăng: [fefb1a]2[-]lần
●  Góp bang hội mỗi ngày: [fefb1a]25[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]10[-] lần
]],

--VIP6
[[
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Cấp chênh lệch bái sư/nhận đệ tử: [fefb1a] 5→4[-]
●  Giãn cách chat kênh thế giới:     [fefb1a]   30→15[-] giây
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]5→10[-]lần
●  Góp bang hội mỗi ngày: [fefb1a]25→50[-] lần
●  Có đặc quyền tổ chức hôn lễ [fefb1a]Trang Viên[-]
●  Mỗi ngày được cầu cứu Thương Hội: [fefb1a]           4[-] lần
●  Số hảo hữu tối đa tăng thêm: [fefb1a]         50[-] người
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Truyền công mỗi ngày tăng: [fefb1a]2[-]lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Mỗi ngày được tìm Kho Báu: 　　[fefb1a]        10[-] lần
]],

--VIP7
[[
●  Đổi hộp quà bang hội: [fefb1a]   4→5[-]
●  Mỗi ngày được tìm Kho Báu: [fefb1a]     10→15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                   Không→Đồng ý[-]
●  Có đặc quyền tổ chức hôn lễ [fefb1a]Trang Viên[-]
●  Cấp chênh lệch bái sư/nhận đệ tử: [fefb1a]    4[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:     [fefb1a]        15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội: [fefb1a]        4[-]
●  Giới hạn hảo hữu tăng: [fefb1a]      50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]10[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Truyền công mỗi ngày tăng: [fefb1a]2[-]lần
●  Góp bang hội mỗi ngày: [fefb1a]50[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
]],

--VIP8
[[
●  Số lần truyền công/nhận truyền công:       [fefb1a] 2→3[-]
●  EXP ủy thác rời mạng: [fefb1a]100%→110%[-]
●  Có đặc quyền tổ chức hôn lễ [fefb1a]Trang Viên[-]
● Đổi hộp quà bang hội: [fefb1a]         5[-]
● Cấp chênh lệch bái sư/nhận đệ tử: [fefb1a]     4[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:     [fefb1a]        15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội: [fefb1a]        4[-]
● Giới hạn hảo hữu tăng: [fefb1a]       50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]10[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Góp bang hội mỗi ngày: [fefb1a]50[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]      15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP9
[[
●  Có quyền tổ chức hôn lễ trên [fefb1a]Hải Tân[-]
● Cấp chênh lệch truyền công/nhận truyền công: [fefb1a] 3→2[-]
● Cấp chênh lệch bái sư/nhận đệ tử: [fefb1a] 4→3[-]
●  Góp bang hội mỗi ngày: [fefb1a]50→200[-] lần
●  Có đặc quyền tổ chức hôn lễ [fefb1a]Trang Viên[-]
● Số lần truyền công/nhận truyền công:        [fefb1a]      3[-]
● EXP ủy thác rời mạng:       [fefb1a]      110%[-]
● Đổi hộp quà bang hội: [fefb1a]          5[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
● Giãn cách chat kênh thế giới:     [fefb1a]          15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội: [fefb1a]          4[-]
●  Giới hạn hảo hữu tăng: [fefb1a]        50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]10[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
● Số lần tìm kho báu mỗi ngày: 　　[fefb1a]        15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],
--VIP10
[[
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]10→15[-]lần
● Hiển thị vật phẩm bày bán +[fefb1a]50%[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân[-]
● Cấp chênh lệch truyền công/nhận truyền công:     [fefb1a]2[-]
●  Số lần truyền công/nhận truyền công:            [fefb1a]3[-]
●  EXP ủy thác rời mạng:           [fefb1a]110%[-]
●  Số lần đổi Hộp Quà Bang Hội:      [fefb1a]   5[-]
●  Cấp chênh lệch bái sư/nhận đệ tử:     [fefb1a]3[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:             [fefb1a]15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội:       [fefb1a]  4[-]
●  Giới hạn hảo hữu tăng:       [fefb1a]50[-]
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Góp bang hội mỗi ngày: [fefb1a]200[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　    [fefb1a]  15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP11
[[
●  Tốc độ thân mật hảo hữu +[fefb1a]20%[-] 
● Hiển thị vật phẩm bày bán +[fefb1a]50%[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân[-]
●  Cấp chênh lệch truyền công/nhận truyền công:    [fefb1a]2[-]
●  Số lần truyền công/nhận truyền công:           [fefb1a]3[-]
●  EXP ủy thác rời mạng:          [fefb1a]110%[-]
●  Số lần đổi Hộp Quà Bang Hội:     [fefb1a]   5[-]
●  Cấp chênh lệch bái sư/nhận đệ tử:    [fefb1a]3[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:            [fefb1a]15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội:      [fefb1a]  4[-]
●  Giới hạn hảo hữu tăng:       [fefb1a]50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]15[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Góp bang hội mỗi ngày: [fefb1a]200[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　   　[fefb1a]  15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP12
[[
●  Có quyền tổ chức hôn lễ trên [fefb1a]Thuyền[-]
●  EXP ủy thác rời mạng: [fefb1a]110%→120%[-]
●  Góp bang hội mỗi ngày: [fefb1a]200→500[-] lần
●  Cấp chênh lệch bái sư/nhận đệ tử: [fefb1a]3→2[-]
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân[-]
●  Tốc độ thân mật hảo hữu +[fefb1a]20%[-] 
● Hiển thị vật phẩm bày bán +[fefb1a]50%[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
●  Cấp chênh lệch truyền công/nhận truyền công:      [fefb1a]2[-]
●  Số lần truyền công/nhận truyền công:             [fefb1a]3[-]
●  Số lần đổi Hộp Quà Bang Hội:       [fefb1a]   5[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:              [fefb1a]15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội:        [fefb1a]  4[-]
●  Giới hạn hảo hữu tăng:         [fefb1a]50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]15[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　     　[fefb1a]  15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP13
[[
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]15→20[-]lần
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân, Thuyền[-]
●  EXP Đồng Hành +[fefb1a]20%[-] 
●  Tốc độ thân mật hảo hữu +[fefb1a]20%[-] 
● Hiển thị vật phẩm bày bán +[fefb1a]50%[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
●  Cấp chênh lệch truyền công/nhận truyền công:   [fefb1a]2[-]
●  Số lần truyền công/nhận truyền công:          [fefb1a]3[-]
●  EXP ủy thác rời mạng:         [fefb1a]120%[-]
●  Cấp chênh lệch bái sư/nhận đệ tử:   [fefb1a]2[-]
●  Số lần đổi Hộp Quà Bang Hội:    [fefb1a]   5[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:           [fefb1a]15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội:     [fefb1a]  4[-]
●  Giới hạn hảo hữu tăng:      [fefb1a]50[-]
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Góp bang hội mỗi ngày: [fefb1a] 500[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　  [fefb1a]  15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP14
[[
●  Số lần dùng Tu Luyện Đơn:   [fefb1a]1→2[-]
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân, Thuyền[-]
●  EXP Đồng Hành +[fefb1a]20%[-] 
●  Tốc độ thân mật hảo hữu +[fefb1a]20%[-] 
● Hiển thị vật phẩm bày bán +[fefb1a]50%[-]
●  Cấp chênh lệch truyền công/nhận truyền công: [fefb1a]2[-]
●  Số lần truyền công/nhận truyền công:        [fefb1a]3[-]
●  EXP ủy thác rời mạng:       [fefb1a]120%[-]
●  Cấp chênh lệch bái sư/nhận đệ tử: [fefb1a]2[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
●  Số lần đổi Hộp Quà Bang Hội: [fefb1a]    5[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:         [fefb1a]15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội: [fefb1a]    4[-]
●  Giới hạn hảo hữu tăng:    [fefb1a]50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]20[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Góp bang hội mỗi ngày: [fefb1a]500[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP15
[[
●  Cấp chênh lệch truyền công/nhận truyền công: [fefb1a]2→1[-]
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân, Thuyền[-]
●  Số lần dùng Tu Luyện Đơn:             [fefb1a]2[-]
●  EXP Đồng Hành +[fefb1a]20%[-] 
●  Tốc độ thân mật hảo hữu +[fefb1a]20%[-] 
● Hiển thị vật phẩm bày bán +[fefb1a]50%[-]
●  Số lần truyền công/nhận truyền công:             [fefb1a]3[-]
●  EXP ủy thác rời mạng:            [fefb1a]120%[-]
●  Cấp chênh lệch bái sư/nhận đệ tử:      [fefb1a]2[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
● Đổi hộp quà bang hội: [fefb1a]         5[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:              [fefb1a]15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội:        [fefb1a]  4[-]
●  Giới hạn hảo hữu tăng:         [fefb1a]50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]20[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Góp bang hội mỗi ngày: [fefb1a]500[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　    　 [fefb1a]  15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP16
[[
●  Số lần truyền công/nhận truyền công:        [fefb1a]3→4[-]
●  EXP ủy thác rời mạng: [fefb1a]120%→130%[-]
●  Góp bang hội mỗi ngày: [fefb1a]500→3000[-] lần
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân, Thuyền[-]
●  Cấp chênh lệch truyền công/nhận truyền công:      [fefb1a]1[-]
●  Số lần dùng Tu Luyện Đơn:             [fefb1a]2[-]
●  EXP Đồng Hành +[fefb1a]20%[-] 
●  Tốc độ thân mật hảo hữu +[fefb1a]20%[-] 
● Hiển thị vật phẩm bày bán +[fefb1a]50%[-]
●  Cấp chênh lệch bái sư/nhận đệ tử:      [fefb1a]2[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
●  Số lần đổi Hộp Quà Bang Hội:       [fefb1a]   5[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:              [fefb1a]15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội:        [fefb1a]  4[-]
●  Giới hạn hảo hữu tăng:         [fefb1a]50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]20[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　     　[fefb1a]  15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP17
[[
●  Hiển thị vật phẩm bày bán +[fefb1a]50%→100%[-]
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân, Thuyền[-]
●  Số lần truyền công/nhận truyền công:           [fefb1a]4[-]
●  EXP ủy thác rời mạng:           [fefb1a]130%[-]
●  Cấp chênh lệch truyền công/nhận truyền công:    [fefb1a]1[-]
●  Số lần dùng Tu Luyện Đơn:           [fefb1a]2[-]
●  EXP Đồng Hành +[fefb1a]20%[-] 
●  Tốc độ thân mật hảo hữu +[fefb1a]20%[-] 
●  Cấp chênh lệch bái sư/nhận đệ tử:    [fefb1a]2[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
●  Số lần đổi Hộp Quà Bang Hội: [fefb1a]       5[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
●  Giãn cách chat kênh thế giới:            [fefb1a]15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội:      [fefb1a]  4[-]
●  Giới hạn hảo hữu tăng:       [fefb1a]50[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]20[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Góp bang hội mỗi ngày: [fefb1a]3000[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]     15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],

--VIP18
[[
●  Hiển thị vật phẩm bày bán +[fefb1a]100%[-]
●  Giới hạn hảo hữu tăng:  [fefb1a]50→100[-]
●  Có quyền tổ chức hôn lễ trên [fefb1a]Trang Viên, Hải Tân, Thuyền[-]
●  Số lần truyền công/nhận truyền công:              [fefb1a]4[-]
●  EXP ủy thác rời mạng:              [fefb1a]130%[-]
●  Cấp chênh lệch truyền công/nhận truyền công:       [fefb1a]1[-]
●  Số lần dùng Tu Luyện Đơn:              [fefb1a]2[-]
●  EXP Đồng Hành +[fefb1a]20%[-] 
●  Tốc độ thân mật hảo hữu +[fefb1a]20%[-] 
●  Cấp chênh lệch bái sư/nhận đệ tử:       [fefb1a]2[-]
●  Bạc rung Cây Tiền +[fefb1a]20%[-] 
● Đổi hộp quà bang hội: [fefb1a]          5[-]
●  Dùng Đại Bạch Câu Hoàn nhận [fefb1a]x2.5[-] EXP rời mạng
● Giãn cách chat kênh thế giới:     [fefb1a]          15[-] giây
●  Số lần cầu cứu nhiệm vụ thương hội: [fefb1a]          4[-]
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]20[-]lần
●  Số lần hỗ trợ Thương Hội mỗi ngày: [fefb1a]20[-] lần
●  Được mua gói siêu giá trị [fefb1a]5,000/10,000/20,000[-] VNĐ
●  Được dùng tính năng [fefb1a]tạo mới[-] bày bán
●  Có thể mua hàng của [fefb1a]Thương Nhân Tây Vực[-]
●  Góp bang hội mỗi ngày: [fefb1a]3000[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
● Số lần tìm kho báu mỗi ngày: 　　[fefb1a]        15[-] lần
●  Đá Hồn có thể tách: [fefb1a]                         Đồng ý[-]
]],
}

if version_vn then --越南版vip特权里没有对应的每日礼包
Recharge.tbVipDesc[2] =
--VIP1
[[
●  Biểu Tượng Kiếm Hiệp Lam
●  Truyền công +[fefb1a]1[-] lần
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]10[-] lần
●  Góp bang hội mỗi ngày: [fefb1a]20[-] lần
]];

Recharge.tbVipDesc[4] =
--VIP3
[[
●  Phát Lì Xì x2
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]10[-] lần
●  Góp bang hội mỗi ngày: [fefb1a]25[-] lần
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]5[-]lần
]];

Recharge.tbVipDesc[6] =
--VIP5
[[
●  Phát Lì Xì x3
●  Chat kênh thế giới mỗi ngày: [fefb1a]20[-] lần
●  Số lần tìm kho báu mỗi ngày: 　　[fefb1a]10[-] lần
●  Góp bang hội mỗi ngày: [fefb1a]25[-] lần
●  Số lần mua Võ Thần Điện mỗi ngày: [fefb1a]5[-]lần
]];
end

Recharge.DAILY_GIFT_TYPE = 
{
	["YUAN_1"] = 1,
	["YUAN_3"] = 2,
	["YUAN_6"] = 3,
	["YUAN_10"] = 4,
}

Recharge.DAYS_CARD_TYPE = 
{
	["DAYS_7"] = 1,
	["DAYS_30"] = 2,
}

Recharge.tbVipPrivilegeDesc = {
	KinDonate = {
		[0]  = "Kiếm Hiệp 1 mỗi ngày được góp 20 lần",
		[1]  = "Kiếm Hiệp 2 mỗi ngày được góp 25 lần",
		[2]  = "Kiếm Hiệp 2 mỗi ngày được góp 25 lần",
		[3]  = "Kiếm Hiệp 3 mỗi ngày được góp 50 lần",
		[4]  = "Kiếm Hiệp 3 mỗi ngày được góp 50 lần",
		[5]  = "Kiếm Hiệp 3 mỗi ngày được góp 50 lần",
		[6]  = "Kiếm Hiệp 3 mỗi ngày được góp 50 lần",
		[7]  = "Kiếm Hiệp 9 mỗi ngày được góp 200 lần",
		[8]  = "Kiếm Hiệp 9 mỗi ngày được góp 200 lần",
		[9]  = "Kiếm Hiệp 12 mỗi ngày được góp 500 lần",
		[10] = "Kiếm Hiệp 12 mỗi ngày được góp 500 lần",
		[11] = "Kiếm Hiệp 12 mỗi ngày được góp 500 lần",
		[12] = "Kiếm Hiệp 14 góp nhận cống hiến +20%",
		[13] = "Kiếm Hiệp 14 góp nhận cống hiến +20%",
		[14] = "Kiếm Hiệp 16 tối đa góp 3000 lần mỗi ngày",
		[15] = "Kiếm Hiệp 16 tối đa góp 3000 lần mỗi ngày",
	},
	MoneyTree = {
		[8] = "Kiếm Hiệp 10 rung cây tiền nhận Bạc +20%",
		[9] = "Kiếm Hiệp 10 rung cây tiền nhận Bạc +20%",
	},
	WaiYi = {
		[7] = "Kiếm Hiệp 10 được tặng ngoại trang cho hảo hữu",
		[8] = "Kiếm Hiệp 10 được tặng ngoại trang cho hảo hữu",
		[9] = "Kiếm Hiệp 10 được tặng ngoại trang cho hảo hữu",
	},
	OnHook = {
		[3]  = "Kiếm Hiệp 6 được dùng Đại Bạch Câu Hoàn ủy thác (EXP rời mạng x2.5) ",
		[4]  = "Kiếm Hiệp 6 được dùng Đại Bạch Câu Hoàn ủy thác (EXP rời mạng x2.5) ",
		[5]  = "Kiếm Hiệp 6 được dùng Đại Bạch Câu Hoàn ủy thác (EXP rời mạng x2.5) ",
		[6]  = "Kiếm Hiệp 8 EXP ủy thác rời mạng +10%",
		[7]  = "Kiếm Hiệp 8 EXP ủy thác rời mạng +10%",
		[9]  = "Kiếm Hiệp 12 EXP ủy thác rời mạng +20%",
		[10] = "Kiếm Hiệp 12 EXP ủy thác rời mạng +20%",
		[11] = "Kiếm Hiệp 12 EXP ủy thác rời mạng +20%",
		[13] = "Kiếm Hiệp 16 EXP ủy thác rời mạng +30%",
		[14] = "Kiếm Hiệp 16 EXP ủy thác rời mạng +30%",
		[15] = "Kiếm Hiệp 16 EXP ủy thác rời mạng +30%",
	},
	FriendImity = {
		[8]  = "Kiếm Hiệp 11 tốc độ tăng độ thân mật hảo hữu +20%",
		[9]  = "Kiếm Hiệp 11 tốc độ tăng độ thân mật hảo hữu +20%",
		[10] = "Kiếm Hiệp 11 tốc độ tăng độ thân mật hảo hữu +20%",
	},
	KinGift = {
		[4] = "Kiếm Hiệp 7 tăng 1 lần đổi Hộp Quà Bang Hội mỗi ngày",
		[5] = "Kiếm Hiệp 7 tăng 1 lần đổi Hộp Quà Bang Hội mỗi ngày",
		[6] = "Kiếm Hiệp 7 tăng 1 lần đổi Hộp Quà Bang Hội mỗi ngày",
	},
}

function Recharge:OnSumActStart(nStartTime)
	self.nSumActStartTime = nStartTime
end
function Recharge:OnSumActEnd()
	self.nSumActStartTime = nil
end
function Recharge:GetActRechageSumVal(pPlayer)
	if not self.nSumActStartTime then
		return 0
	end
	local nLastRestTime = Recharge:GetActRechageSumTime(pPlayer)
	if nLastRestTime < self.nSumActStartTime then
		return 0
	end
	return pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_R)
end
function Recharge:SetActRechageSumVal(pPlayer, nVal)
	 pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_R, nVal)
end
function Recharge:GetActRechageSumTime(pPlayer)
	return pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_SET_TIME_R)
end
function Recharge:SetActRechageSumTime(pPlayer, nVal)
	 pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_SET_TIME_R, nVal)
end
function Recharge:GetActRechageSumTake(pPlayer)
	return pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_TAKE_R)
end
function Recharge:SetActRechageSumTake(pPlayer, nVal)
	 pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_TAKE_R, nVal)
end

function Recharge:OnConsumeSumActStart(nStartTime)
	self.nConsumeSumStartTime = nStartTime
end
function Recharge:OnConsumeSumActEnd()
	self.nConsumeSumStartTime = nil
end
function Recharge:GetActConsumeSumVal(pPlayer)
	if self.nConsumeSumStartTime <= 0 then
		return 0
	end
	local nLastRestTime = Recharge:GetActConsumeSumTime(pPlayer)
	if nLastRestTime < self.nConsumeSumStartTime then
		return 0
	end
	return pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_C)
end
function Recharge:SetActConsumeSumVal(pPlayer, nVal)
	 pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_C, nVal)
end
function Recharge:GetActConsumeSumTime(pPlayer)
	return pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_SET_TIME_C)
end
function Recharge:SetActConsumeSumTime(pPlayer, nVal)
	 pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_SET_TIME_C, nVal)
end
function Recharge:GetActConsumeSumTake(pPlayer)
	return pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_TAKE_C)
end
function Recharge:SetActConsumeSumTake(pPlayer, nVal)
	 pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_ACT_SUM_TAKE_C, nVal)
end

--连续充值活动
function Recharge:SetActContinualData(pPlayer, nKey, nValue)
	if nKey < self.KEY_ACT_CONTINUAL_DATA_DAY or nKey > self.KEY_ACT_CONTINUAL_SESSION_TIME then
		return
	end
	pPlayer.SetUserValue(self.SAVE_GROUP, nKey, nValue)
end
function Recharge:GetActContinualData(pPlayer, nKey)
	return pPlayer.GetUserValue(self.SAVE_GROUP, nKey)
end


--这里面是分为单位， val是充值sdk里显示的名字
function Recharge:Init()
	local tbSettingGroup = {};
	local tbProductionSettingAll = {}
	local tbFile = LoadTabFile("Setting/Recharge/Recharge.tab", "sssddsdssssssdsddssss", nil,
			{"ProductId", "szDesc", "szServiceCode", "nLastingDay", "nMoney", "szMoneyType", "nNeedVipLevel","szAward", "szFirstAward","szThirdAward", "szFourthAward",	"szFifthAward", "szGroup","nGroupIndex", "szVersion","nEndTimeKey","nBuyDayKey", "szSprite", "szFirstDesc","szNoromalDesc","Plat"});
	local fnCheck;
	if MODULE_GAMESERVER and (version_hk or version_tw) then
		fnCheck = function (v)
			return(v.szVersion == "version_hk" or v.szVersion == "version_tw")
		end
	else
		fnCheck = function (v)
			if not _G[v.szVersion] then
				return
			end
			if MODULE_GAMECLIENT  and not Lib:IsEmptyStr(v.Plat) then
				if not _G[v.Plat] then
					return
				end
			end
			return true;
		end
	end

	for i,v in ipairs(tbFile) do
		if fnCheck(v) then
			if v.szAward ~= "" then
				v.tbAward = Lib:GetAwardFromString(v.szAward)
			end
			if v.szFirstAward  ~= "" then
				v.tbFirstAward = Lib:GetAwardFromString(v.szFirstAward)
			end
			if v.szThirdAward ~= "" then
				v.tbThirdAward = Lib:GetAwardFromString(v.szThirdAward)
			end
			if v.szFourthAward ~= "" then
				v.szFourthAward = Lib:GetAwardFromString(v.szFourthAward)
			end
			if v.szFifthAward ~= "" then
				v.tbFifthAward = Lib:GetAwardFromString(v.szFifthAward)
			end
			tbProductionSettingAll[v.ProductId] = v
			if v.szGroup ~= "" then
				tbSettingGroup[v.szGroup] = tbSettingGroup[v.szGroup] or {};
				tbSettingGroup[v.szGroup][v.nGroupIndex] = v;
			end
		end
	end

	local tbGrowInvestGroup = {}
	local tbFile = LoadTabFile("Setting/Recharge/GrowInvest.tab", "dddddddddddd", nil,
			{"nGroup", "nIndex",	"nLevel",	"nAwardGold",	"nDay",	"version_tx",	"version_vn",	"version_hk",	"version_xm",	"version_en",	"version_kor",	"version_th"});
	for i,v in ipairs(tbFile) do
		if Lib:CheckVersion(v) then
			tbGrowInvestGroup[v.nGroup] = tbGrowInvestGroup[v.nGroup] or {};
			local tbData = { nLevel = v.nLevel, nAwardGold = v.nAwardGold }
			if v.nDay ~= 0 then
				tbData.nDay = v.nDay
			end
			tbGrowInvestGroup[v.nGroup][v.nIndex] =  tbData
		end
	end

	Recharge.tbGrowInvestGroup = tbGrowInvestGroup

	self.tbProductionSettingAll = tbProductionSettingAll
	self.tbSettingGroup = tbSettingGroup

	--todo 一个版本的vip经验以对应的货币标准为准
	self.szDefMoneyType = self.tbSettingGroup.BuyGold[1].szMoneyType;
	if version_kor then
		if MODULE_GAMESERVER then
			assert(self.szDefMoneyType == "KRW"); --韩国的ios和安卓客户端使用了不同的货币， 但是服务端统一用krw,存盘值也是KRW
		end
		self.szDefMoneyType = "KRW";
	end
	if not version_tx  then
		local nRate = self.tbMoneyRMBRate[self.szDefMoneyType]
		for i,v in ipairs(Recharge.tbVipSetting) do
			if version_kor then
				Recharge.tbVipSetting[i] = v / nRate
			else
				Recharge.tbVipSetting[i] = math.ceil(v / nRate)
			end
			
		end
	end

end
Recharge:Init()



function Recharge:GetDaysCardLeftDay(pPlayer, nIndex)
	if not self.tbSettingGroup.DaysCard then
		return 0;
	end
	local tbBuyInfo = self.tbSettingGroup.DaysCard[nIndex]
	if not tbBuyInfo then
		return 0
	end
	return Lib:GetLocalDay(pPlayer.GetUserValue(self.SAVE_GROUP, tbBuyInfo.nEndTimeKey) - 3600 * 4) - Lib:GetLocalDay(GetTime() - 3600 * 4)
end

function Recharge:GetDaysCardLeftTime(pPlayer, nIndex)
	if not self.tbSettingGroup.DaysCard then
		return 0;
	end
	local tbBuyInfo = self.tbSettingGroup.DaysCard[nIndex]
	if not tbBuyInfo then
		return 0
	end
	return pPlayer.GetUserValue(self.SAVE_GROUP, tbBuyInfo.nEndTimeKey) - GetTime()
end

function Recharge:GetDaysCardEndTime(pPlayer, nIndex)
	if not self.tbSettingGroup.DaysCard then
		return 0;
	end
	local tbBuyInfo = self.tbSettingGroup.DaysCard[nIndex]
	if not tbBuyInfo then
		return 0
	end
	return pPlayer.GetUserValue(self.SAVE_GROUP, tbBuyInfo.nEndTimeKey);
end

function Recharge:GetTotoalRecharge(pPlayer)
	return self:GetTotoalRechargeGold(pPlayer) + pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_TOTAL_CARD) ;
end

function Recharge:GetTotoalRechargeGold(pPlayer)
	return self.TOTAL_RECHARGE_LARGE * pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_TOTAL_ONLY_GOLD2) + pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_TOTAL_ONLY_GOLD)
end

function Recharge:SetTotoalRechargeGold(pPlayer, nTotal)
	local nHigh = math.floor(nTotal / self.TOTAL_RECHARGE_LARGE) 
	local nLow = nTotal % self.TOTAL_RECHARGE_LARGE
	pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_TOTAL_ONLY_GOLD2, nHigh)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_TOTAL_ONLY_GOLD, nLow)
end

function Recharge:OnCardActStart(nCardActExtAmount, szCardActName)
	self.nCardActExtAmount = nCardActExtAmount
	self.szCardActName = szCardActName
end
function Recharge:OnCardActEnd()
	self.nCardActExtAmount = nil
	self.szCardActName = nil
end
function Recharge:IsOnActvityDay()
	local nWeekDay = Lib:GetLocalWeekDay(GetTime() - 3600 * 4)
	local nWeekExt;
	if nWeekDay == 6 or nWeekDay == 7 then
		nWeekExt = self.fActivityCardAwardParam
	end
	local nTotal = 0
	if nWeekExt then
		nTotal = nTotal + nWeekExt
	end
	if self.nCardActExtAmount then
		nTotal = nTotal + self.nCardActExtAmount
	end
	return nWeekExt, self.nCardActExtAmount, nTotal
end

function Recharge:GetRefreshDay()
	return Lib:GetLocalDay(GetTime() - 3600 *4)
end

function Recharge:CheckBuyGoldGetNum(pPlayer, szProductId)
	local tbBuyInfo = self.tbProductionSettingAll[szProductId]
	if not tbBuyInfo then
		return 0
	end
	local nMoney = tbBuyInfo.nMoney
	local szGroup = tbBuyInfo.szGroup
	if szGroup ==  "BuyGold" then
		local nSellIdx = tbBuyInfo.nGroupIndex
		local nBuyedFlag = Recharge:GetBuyedFlag(pPlayer);
		local nBuydeBit = KLib.GetBit(nBuyedFlag, nSellIdx)
		if nBuydeBit == 1 then
			return self:GetGoldNumFromAward(tbBuyInfo.tbAward)
		else
			return self:GetGoldNumFromAward(tbBuyInfo.tbFirstAward) --每一项首冲双倍
		end
	elseif szGroup == "DaysCard" then
		return self:GetGoldNumFromAward(tbBuyInfo.tbAward)
	elseif szGroup == "GrowInvest" then
		local tbInfo = self.tbGrowInvestGroup[tbBuyInfo.nGroupIndex][1]
		return tbInfo.nAwardGold
	elseif szGroup == "DayGift" then
		return self:GetGoldNumFromAward(tbBuyInfo.tbAward)
	end
	return 0
end

function Recharge:GetGoldNumFromAward(tbAward)
	if not tbAward then
		return 0
	end
	local nGetGold = 0
	if type(tbAward[1]) ~= "table" then
		if tbAward[1] == "Gold" then
			nGetGold = tbAward[2]
		end 
		return nGetGold
	end
	
	for _,v2 in ipairs(tbAward) do
		if v2[1] == "Gold" then
			nGetGold = nGetGold + v2[2]
		end
	end
	return nGetGold
end



function Recharge:CanBuyProduct(pPlayer, szProductId)
	local tbBuyInfo = Recharge.tbProductionSettingAll[szProductId]
	if not tbBuyInfo then
		return
	end
	local szGroup = tbBuyInfo.szGroup
	local bRet,szMsg = true;
	if szGroup == "DaysCard" then
		if not self:CanBuyDaysCard(pPlayer, tbBuyInfo.nGroupIndex) then
			return
		end
	elseif szGroup == "GrowInvest" then
		if not self:CanBuyGrowInvest(pPlayer,tbBuyInfo.nGroupIndex) then
			return
		end
	elseif szGroup == "DayGift" then
		bRet,szMsg = self:CanBuyOneDayCard(pPlayer, szProductId)
	elseif szGroup == "DayGiftSet" then
		bRet,szMsg = self:CanBuyOneDayCardSet(pPlayer)
	elseif szGroup == "YearGift" then
		bRet,szMsg = self:CanBuyYearGift(pPlayer, szProductId)
	elseif szGroup == "DirectEnhance" then
		bRet,szMsg = self:CanBuyDirectEnhance(pPlayer, szProductId)
	elseif szGroup == "DayGiftPlus" then
		bRet,szMsg = self:CanBuyOneDayCardPlusType(pPlayer, szProductId)
	elseif szGroup == "DressMoney" then
		bRet, szMsg = self:CanBuyDressMoney()
	elseif szGroup == "BackGift" then
		bRet, szMsg = RegressionPrivilege:CheckCanRecharge(pPlayer)
	end
	if szMsg then
		pPlayer.CenterMsg(szMsg,true)
	end
	return bRet
end

function Recharge:CanBuyYearGift(pPlayer, szProductId)
	local tbBuyInfo = Recharge.tbProductionSettingAll[szProductId]
	if not tbBuyInfo then
		return
	end

	if not Activity:__IsActInProcessByType("RechargeNewYearBuyGift") then
		return false, "Không trong hoạt động, không thể mua"
	end
	if pPlayer.GetVipLevel() < tbBuyInfo.nNeedVipLevel then
        return false, string.format("Đạt Kiếm Hiệp %d có thể mua", tbBuyInfo.nNeedVipLevel)
    end

	local tbLimitInfo = self.tbNewYearBuySetting[tbBuyInfo.nGroupIndex]
	if tbLimitInfo.nSaveCountKey and  tbLimitInfo.nBuyCount > 1 then
		if pPlayer.GetUserValue(Recharge.SAVE_GROUP, tbLimitInfo.nSaveCountKey) >= tbLimitInfo.nBuyCount then
			return false, string.format("Mua tối đa %d lần", tbLimitInfo.nBuyCount)
		else
			if pPlayer.GetUserValue(Recharge.SAVE_GROUP, tbBuyInfo.nBuyDayKey) == Recharge:GetRefreshDay() then
				return false, "Hôm nay đã mua"
			end
		end
	else
		if pPlayer.GetUserValue(Recharge.SAVE_GROUP, tbBuyInfo.nBuyDayKey) > 0 then
			return false, "Tối đa mua 1 lần"
		end
	end

	local szAwardKey;
	--有的购买项对应时间轴没有的
	if MODULE_GAMESERVER then
		szAwardKey = self.szYearGiftAwardKey
	else
		local tbUiData, tbActData = Activity:GetActUiSetting("RechargeNewYearBuyGift")
		szAwardKey = tbUiData and tbUiData.szAwardKey
	end

	if not szAwardKey then
		return false, "Hoạt động đã kết thúc"
	end
	local tbInfo = tbBuyInfo[szAwardKey]
	if not tbInfo then
		return false, "Chưa mở phần thưởng tương ứng"
	end

	return true
end

function Recharge:CanBuyDirectEnhance(pPlayer, szProductId)
	if not self.IS_OPEN_BUY_ENHANCE then
		return false, "Hiện đã đóng"
	end
	local tbBuyInfo = Recharge.tbProductionSettingAll[szProductId]
	if not tbBuyInfo then
		return 
	end
	if pPlayer.GetUserValue(self.SAVE_GROUP, tbBuyInfo.nEndTimeKey) ~= 0 then
		return false, "Hiện đã mua"
	end
	local tbLimitSetting = self.tbDirectEnhanceSetting[tbBuyInfo.nGroupIndex]
	if not tbLimitSetting then
		return 
	end
	if GetTimeFrameState(tbLimitSetting.OpenTimeFrame) ~= 1 then
		return 
	end
	if pPlayer.nLevel < tbLimitSetting.nPlayerLevel then
		return false, "Cấp không đủ"
	end
	local nMoreCount = 0;
	local tbStrengthen 	= pPlayer.GetStrengthen();
	for nEquipPos = 1,10 do
		local nStrenLevel 	= tbStrengthen[nEquipPos]
		if nStrenLevel >= tbLimitSetting.nEnhanceLevel then
			nMoreCount = nMoreCount + 1;
		end
	end
	if nMoreCount >= 10 then
		return false, string.format("Trên người không có vị trí cường hóa thấp hơn Lv%d", tbLimitSetting.nEnhanceLevel)
	end
	return true;
end

function Recharge:CanBuyOneDayCard(pPlayer, szProductId)
	local tbBuyInfo = Recharge.tbProductionSettingAll[szProductId]
	if not tbBuyInfo then
		return
	end

	if pPlayer.GetVipLevel() < tbBuyInfo.nNeedVipLevel then
        return false, string.format("Đạt Kiếm Hiệp %d có thể mua", tbBuyInfo.nNeedVipLevel)
    end
    local nToday = Recharge:GetRefreshDay()
	if pPlayer.GetUserValue(self.SAVE_GROUP, tbBuyInfo.nBuyDayKey) >= nToday then
		return false, "Hôm nay đã mua"
	end
	if self.tbSettingGroup.DayGiftSet then
		local tbBuyInfoSet = self.tbSettingGroup.DayGiftSet[1];
		local nBuySetDay = pPlayer.GetUserValue(self.SAVE_GROUP, tbBuyInfoSet.nBuyDayKey)
		if nBuySetDay >= nToday then
			return false, "Đã mua gói Combo"
		end
	end
	local bRet,szMsg, nBuyedIndex = self:IsNotTakeOrBuyedOneDayCardPlus(pPlayer)
	if not bRet then
		if nBuyedIndex then
			local tbGroup = Recharge.DayGiftTypeGroups[nBuyedIndex]
			for i,v in ipairs(tbGroup) do
				if v == tbBuyInfo.nGroupIndex then
					return bRet,szMsg		
				end
			end
		else
			return bRet,szMsg		
		end
	end

	return true
end

function Recharge:IsNotTakeOrBuyedOneDayCardPlus(pPlayer)
	for i,v in pairs(self.KEY_ONE_DAY_CARD_PLUS_COUNT) do
		if pPlayer.GetUserValue(self.SAVE_GROUP , v) > 0 then
			return false, "Đã mua Quà Tích Lũy 136", i
		end	
	end
	local nRefreshDay = self:GetRefreshDay()
	for i,v in pairs(self.KEY_ONE_DAY_CARD_PLUS_DAY) do
		if pPlayer.GetUserValue(self.SAVE_GROUP, v) >= nRefreshDay then
			return false, "Đã nhận Quà Tích Lũy 136", i
		end 	
	end
	
	return true
end

function Recharge:CanBuyOneDayCardSet(pPlayer)
	local tbGroup = self.tbSettingGroup.DayGiftSet
	if not tbGroup then
		return false, "Không có cấu hình", false
	end
	local tbBuyInfo = tbGroup[1]
	if not tbBuyInfo then
		return false, "Không có cấu hình", false
	end

	if MODULE_GAMECLIENT and Sdk:IsPCVersion() then
		return false, "Bản PC không thể mua", false
	end

	if pPlayer.GetVipLevel() < tbBuyInfo.nNeedVipLevel then
        return false, string.format("Đạt Kiếm Hiệp %d có thể mua", tbBuyInfo.nNeedVipLevel), true
    end
    local nToday = Recharge:GetRefreshDay()
	if pPlayer.GetUserValue(self.SAVE_GROUP, tbBuyInfo.nBuyDayKey) >= nToday then
		return false, "Hôm nay đã mua", false
	end
	for i,v in ipairs(self.tbSettingGroup.DayGift) do
		if pPlayer.GetUserValue(self.SAVE_GROUP, v.nBuyDayKey) >= nToday then
			return false, "Đã mua quà tách", false
		end
	end
	local bRet,szMsg = self:IsNotTakeOrBuyedOneDayCardPlus(pPlayer)
	if not bRet then
		return bRet,szMsg, false
	end
	return true, nil, true
end

function Recharge:CanBuyDaysCard(pPlayer, nIndex)
	local tbBuyInfo = self.tbSettingGroup.DaysCard[nIndex]
	if not tbBuyInfo then
		return
	end
	local nLeftDay = self:GetDaysCardLeftDay(pPlayer, nIndex)
	
	if nLeftDay and nLeftDay - 1 >= self.tbDaysCardBuyLimitDay[nIndex] then
		return false, string.format("Chỉ được mua mới khi thời gian còn %s và ít hơn %d ngày", tbBuyInfo.szDesc, self.tbDaysCardBuyLimitDay[nIndex])
	end
	local bRet, szMsg = self:IsCanBuySuperDaysCard(nIndex)
	return bRet, szMsg
end

function Recharge:CanBuyGrowInvest(pPlayer, nGroupIndex)
	if nGroupIndex == 4 then
		if not Activity:__IsActInProcessByType("RechargeNewyearGrowInvest") then
			return
		end
	end
	if nGroupIndex == 7 then
		if not RegressionPrivilege:IsShowGrowInvest(pPlayer) then
			return
		end
	end
	if pPlayer.nLevel < Recharge.tbGrowInvestGroup[nGroupIndex][1].nLevel then
		return
	end
	if pPlayer.GetUserValue(Recharge.SAVE_GROUP, Recharge.tbKeyGrowBuyed[nGroupIndex]) ~= 0 then
		return
	end
	return true
end

function Recharge:CanBuyDressMoney()
	if not Recharge.IS_OPEN_BUY_DRESS then
		return
	end
	if  version_tx then
		if MODULE_GAMECLIENT  then
			if Sdk:IsLoginByGuest() then
				return
			end
		end

	else
		local tbGroup = self.tbSettingGroup.DressMoney
		if not tbGroup then
			return
		end
		if not tbGroup[1] then
			return
		end
	end
	return true
end

function Recharge:GetBuyedFlag(pPlayer)
	return pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_BUYED_FLAG)
end

function Recharge:ClearBuyedFlag(pPlayer)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.KEY_BUYED_FLAG, 0)
end

function Recharge:GetRechareRMBToGold(nRechareRMB, bCeil) 
	if bCeil then
		return math.ceil(Recharge.tbMoneyThirdRate[self.szDefMoneyType] * nRechareRMB) 	
	else
		return math.floor(Recharge.tbMoneyThirdRate[self.szDefMoneyType] * nRechareRMB) 	
	end
end

function Recharge:GetRechareMoneyToGold(nRechareRMB, szMoneyType, bCeil)
	local fnMath = bCeil and math.ceil or math.floor
	return fnMath(Recharge.tbMoneyThirdRate[szMoneyType] * nRechareRMB) 	
end

function Recharge:GetActRechareRMBToGold(nRechareRMB) --活动用的充值对应元宝数,不计算额外赠送的
	return math.ceil(Recharge.tbMoneyRMBRate[self.szDefMoneyType] *  nRechareRMB / 10)  --tbMoneyRMBRate对应的是vip经验所以除以10
end

--获取领取天数保存的Key
function Recharge:GetDayInvestTaskedDayKey(nGroupIndex)
	if nGroupIndex == 4 then
		return self.KEY_INVEST_ACT_TAKEDAY
	end
	if nGroupIndex == 7 then
		return self.KEY_INVEST_BACK_TAKEDAY
	end
end

--获取活动一本万利，回归一本万利当前可以领的天数
function Recharge:GetActGrowInvestTakeDay(pPlayer, nGroupIndex)
	local nSaveKey = self:GetDayInvestTaskedDayKey(nGroupIndex)
	if not nSaveKey then
		return 0
	end

	local nTakedDay = pPlayer.GetUserValue(self.SAVE_GROUP, nSaveKey)
	local nRefreshDay = Recharge:GetRefreshDay()
	local nNowMinus = nRefreshDay  - nTakedDay
	if nNowMinus > 0  then --放回第一个可领的
		local nTaked = pPlayer.GetUserValue(Recharge.SAVE_GROUP, Recharge.tbKeyGrowTaked[nGroupIndex])
		local tbSetting = self.tbGrowInvestGroup[nGroupIndex]
		for i, v in ipairs(tbSetting) do
			if KLib.GetBit(nTaked, i) == 0 then
				if i == 1 then
					return i ;
				else
					local nDayMinus = v.nDay - tbSetting[i - 1].nDay
					if nNowMinus >= nDayMinus then
						return i;		
					end
				end
				break;
			end
		end
	end
	return 0;
end


--这是是否可一键领取，还有是否可一键购买
function Recharge:CanTakeOneDayCardPlusAward(pPlayer)
	local nBuyIndex;
	local nOldCount ;
	for i,v in pairs(self.KEY_ONE_DAY_CARD_PLUS_COUNT) do
		nOldCount = pPlayer.GetUserValue(self.SAVE_GROUP, v)
		if nOldCount > 0 then
			nBuyIndex = i;
			break;
		end
	end
	if not nBuyIndex then
		return false, "Không có lượt nhận"
	end
	local nTakedDay = pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_ONE_DAY_CARD_PLUS_DAY[nBuyIndex])
	if self:GetRefreshDay() == nTakedDay then
		return false, "Hôm nay đã nhận, [FFFE0D]4:00 sáng mai[-] hãy quay lại", nOldCount,nBuyIndex
	end
	return true, nil, nOldCount , nBuyIndex
end

function Recharge:CanBuyOneDayCardPlusType( pPlayer, szProductId )
	local tbBuyInfo = self.tbProductionSettingAll[szProductId]
	if not tbBuyInfo then
		return false, "Không có mục mua tương ứng", false
	end
	if MODULE_GAMECLIENT and Client:IsCloseIOSEntry() then
        return false, "Tạm ẩn", false
    end

	local nIndex = tbBuyInfo.nGroupIndex
	if nIndex == 2 and GetTimeFrameState("OpenLevel119") ~= 1 then
		return false, "Tạm chưa mở mua nhanh, hãy thử lại sau khi mở Lv119", false
	end

	if GetTimeFrameState("OpenLevel49") ~= 1 then --时间轴限制是后面加的，如果还有可领的就不做这个限制了
		return false, "Tạm chưa mở mua nhanh, đại hiệp hãy mở giới hạn cấp 49 rồi thử lại", false
	end
	--同时只能买一种每日礼包，但是领取是对应不同的
	for _,nKey in pairs(self.KEY_ONE_DAY_CARD_PLUS_COUNT) do
		if pPlayer.GetUserValue(self.SAVE_GROUP, nKey) > 0 then
			return false, "Vẫn còn lượt nhận", true	
		end
	end

	if pPlayer.GetVipLevel() < tbBuyInfo.nNeedVipLevel then
        return false, string.format("Đạt Kiếm Hiệp %d có thể mua", tbBuyInfo.nNeedVipLevel), true
    end

	--如果当前已经有买每日礼包 或者一键每日礼包的 都不鞥买了
	local nToday = self:GetRefreshDay()
	if self.tbSettingGroup.DayGiftSet then
		local tbBuyInfoSet = self.tbSettingGroup.DayGiftSet[1];
		local nBuySetDay = pPlayer.GetUserValue(self.SAVE_GROUP, tbBuyInfoSet.nBuyDayKey)
		if nBuySetDay >= nToday then
			return false, "Đã mua gói Combo", true
		end
	end


	for _,i in ipairs(self.DayGiftTypeGroups[nIndex]) do
		local v = self.tbSettingGroup.DayGift[i]
		if pPlayer.GetUserValue(self.SAVE_GROUP, v.nBuyDayKey) >= nToday then
			return false, "Đã mua túi quà, không thể mua nhanh, [FFFE0D]4:00 sáng mai[-] hãy thử lại", true
		end
	end
    return true, nil, true;
end


function Recharge:GetDayCardAward(nIndex)
	local tbAward = {}
	for i,v in ipairs(Recharge.tbDayCardAward[nIndex]) do
		if GetTimeFrameState(v[2]) == 1 then
			tbAward = v[1];
		end 
	end
	return tbAward;
end

function Recharge:IsCanBuySuperDaysCard(pPlayer, nIndex)
	local nSavceKey = self.tbSaveKeySuperDaysCard[nIndex]
	if not nSavceKey then
		return true
	end
	if pPlayer.GetUserValue(self.SAVE_GROUP, nSavceKey) <= 0 then
		return false, "Không có quyền mua Thẻ Tuần Chí Tôn"
	end
	return true
end

