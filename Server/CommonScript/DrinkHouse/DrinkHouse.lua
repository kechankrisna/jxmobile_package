DrinkHouse.tbDef = 
{
	SAVE_GROUP = 177;
	SAVE_KEY_DRINK_INVITE = 3;

	NORMAL_MAP = 8011; --普通的进入的地图
	MIN_PLAYER_LEVEL = 20;--进入玩家等级要求
	CHANNEL_NAME = "Tửu Quán";
	CHANNEL_ICON = "#82";
	CHANNEL_COLOR = "ff638b"; --频道文字颜色
	NORMAL_RAND_POS = { --传入随机点
		{2121, 18100};
		{2121, 17644};
		{2628, 178112};
	};

	LEAVE_RAND_POS = {  --离开地图的随机点
		{15, 8529, 16731}; --地图 ，坐标
		{15, 7451, 16621};
		{15, 9337, 16676};
		{15, 6604, 16978};
		{15, 8419, 17604};
		{15, 8452, 15682};
		{15, 8463, 14926};
	};

	WAIYI_HEAD = 6787; --校服第二套头部
	WAIYI_BODY = 6456; --校服第二套外装

	CHAT_SEND_CD = 10; --聊天发送cd
	CHAT_SEND_MAX_COUNT = 1000; --聊天发送次数

	NameSetting = {
		[1] = "ServerSetting/DrinkHouse/MaleName.tab";
		[2] = "ServerSetting/DrinkHouse/FemaleName.tab";
	};

	HIDE_OBJ = { --隐藏的场景物件
		"sn_jiuguan01_jiuzhuo01";
		"sn_jiuguan01_jiuzhuo01 (1)";
		"sn_jiuguan01_jiuzhuo01 (2)";
		"sn_jiuguan01_jiuzhuo01 (3)";
		"xinshou_muzhuo01";
		"xinshou_muzhuo01 (1)";
		"xinshou_muzhuo01 (2)";
		"xinshou_muzhuo01 (3)";
		"xinshou_muzhuo01 (4)";
		"xinshou_muzhuo01 (6)";
		"xinshou_muzhuo01 (9)";
		"xinshou_muzhuo01 (7)";
		"xinshou_muzhuo01 (8)";
		"sn_jiayuan_dengzi01_01";
		"sn_jiayuan_dengzi01_01 (1)";
		"sn_jiayuan_dengzi01_01 (2)";
		"sn_jiayuan_dengzi01_01 (3)";
		"sn_jiayuan_dengzi01_01 (4)";
		"sn_jiayuan_dengzi01_01 (5)";
		"sn_jiayuan_dengzi01_01 (6)";
		"sn_jiayuan_dengzi01_01 (7)";
		"sn_jiayuan_dengzi01_01 (8)";
		"sn_jiayuan_dengzi01_01 (9)";
		"sn_jiayuan_dengzi01_01 (10)";
		"sn_jiayuan_dengzi01_01 (11)";
		"sn_jiayuan_dengzi01_01 (12)";
		"sn_jiayuan_dengzi01_01 (13)";
		"sn_jiayuan_dengzi01_01 (14)";
		"sn_jiayuan_dengzi01_01 (15)";
	};

	AddFurnitureSetting = {--摆放家族配置
		{nTemplate = 1511, nPosX = 5052, nPosY = 5258, nRotation = 255};
		{nTemplate = 1511, nPosX = 5268, nPosY = 5059, nRotation = 360};
		{nTemplate = 1511, nPosX = 5068, nPosY = 4873, nRotation = 90};
		{nTemplate = 1511, nPosX = 4852, nPosY = 5064, nRotation = 180};
		{nTemplate = 1511, nPosX = 4388, nPosY = 5236, nRotation = 255};
		{nTemplate = 1511, nPosX = 4630, nPosY = 5024, nRotation = 360};
		{nTemplate = 1511, nPosX = 4410, nPosY = 4815, nRotation = 90};
		{nTemplate = 1511, nPosX = 4177, nPosY = 5030, nRotation = 180};
		{nTemplate = 1511, nPosX = 6157, nPosY = 8211, nRotation = 255};
		{nTemplate = 1511, nPosX = 6396, nPosY = 8011, nRotation = 360};
		{nTemplate = 1511, nPosX = 6199, nPosY = 7829, nRotation = 90};
		{nTemplate = 1511, nPosX = 6007, nPosY = 8013, nRotation = 180};
		{nTemplate = 1511, nPosX = 6182, nPosY = 8839, nRotation = 255};
		{nTemplate = 1511, nPosX = 6386, nPosY = 8676, nRotation = 360};
		{nTemplate = 1511, nPosX = 6168, nPosY = 8449, nRotation = 90};
		{nTemplate = 1511, nPosX = 5979, nPosY = 8627, nRotation = 180};
		{nTemplate = 10035, nPosX = 3644, nPosY = 6124, nRotation = 90};
		{nTemplate = 10035, nPosX = 3506, nPosY = 6236, nRotation = 180};
		{nTemplate = 10035, nPosX = 3993, nPosY = 5939, nRotation = 90};
		{nTemplate = 10035, nPosX = 3857, nPosY = 6053, nRotation = 180};
		{nTemplate = 10035, nPosX = 4469, nPosY = 6005, nRotation = 90};
		{nTemplate = 10035, nPosX = 4334, nPosY = 6120, nRotation = 180};
		{nTemplate = 10035, nPosX = 4437, nPosY = 6665, nRotation = 255};
		{nTemplate = 10035, nPosX = 4319, nPosY = 6525, nRotation = 180};
		{nTemplate = 10035, nPosX = 4438, nPosY = 6937, nRotation = 90};
		{nTemplate = 10035, nPosX = 4322, nPosY = 7061, nRotation = 180};
		{nTemplate = 10035, nPosX = 4659, nPosY = 7862, nRotation = 90};
		{nTemplate = 10035, nPosX = 4533, nPosY = 7981, nRotation = 180};
		{nTemplate = 10035, nPosX = 5228, nPosY = 7852, nRotation = 90};
		{nTemplate = 10035, nPosX = 5100, nPosY = 7983, nRotation = 180};
		{nTemplate = 10035, nPosX = 5229, nPosY = 8253, nRotation = 90};
		{nTemplate = 10035, nPosX = 5083, nPosY = 8378, nRotation = 180};
		{nTemplate = 10035, nPosX = 4659, nPosY = 8272, nRotation = 90};
		{nTemplate = 10035, nPosX = 4521, nPosY = 8393, nRotation = 180};
	}; 
	AddNpcSetting = {--摆放家族配置
		{nTemplate = 3215, nLevel = 1;  nPosX = 5053, nPosY = 5071, nDir = 0};
		{nTemplate = 3215, nLevel = 1;  nPosX = 4380, nPosY = 5027, nDir = 0};
		{nTemplate = 3215, nLevel = 1;  nPosX = 6171, nPosY = 8005, nDir = 0};
		{nTemplate = 3215, nLevel = 1;  nPosX = 6164, nPosY = 8641, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 3651, nPosY = 6238, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 3992, nPosY = 6062, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 4469, nPosY = 6126, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 4435, nPosY = 6530, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 4437, nPosY = 7069, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 4661, nPosY = 7986, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 5223, nPosY = 7981, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 5221, nPosY = 8380, nDir = 0};
		{nTemplate = 3216, nLevel = 1;  nPosX = 4661, nPosY = 8388, nDir = 0};
	}; 

	nDrinkInviteInterval = 120; --邀请喝酒间隔
	tbDrinkWineRandAction = { --喝酒后的随机反应
		{
			nDuraTime = 20; --持续时间
			nActionID = 26;
			nActionEventID = 5002;
			szNotifyMsg = "%s mới uống một chén đã ngã lăn ra đất.";
			szEndSayMsg = "Tửu lượng cao đấy!";

		};
		{
			nDuraTime = 30; --持续时间
			bFollow = true;
			nFollowDistance = 200;  --跟战距离
			szNotifyMsg = "%s bị %s thôi miên, mơ hồ đi theo %s rồi. ";	
			tbRandSay = {
				"Ta là ai? Ta đang ở đâu? Người trước mặt quen quá, đừng bỏ rơi ta.";
				"Chờ ta với, đừng đi, ta muốn bỏ trốn với ngươi!";
				"Bướm nhiều quá, hoa nhiều quá, ta bay...!";
			};
			szEndSayMsg = "Ơ, đã xảy ra chuyện gì nhỉ? Sao ta lại ở đây?";
		};
	};
}


DrinkHouse.tbRentDef = {
	NAME = "Tiệc Bang Hội";
	CONTRACT_ITEM = 9502;--合同道具id
	MAX_RENT_TIMES = 2; --家族每周最大承包次数
	RENT_TIME_FROM_TO = { 3600 * 12, 3600 * 24 }; --允许承包的时间范围，当天时间对应秒数
	RENT_MAP = 8012; --地图id
	NORMAL_RAND_POS = { --传入随机点
		{3429, 6572};
		{3657, 6559};
		{3879, 6669};
	};
	RENT_NPC_IN_MAP = 15; --酒馆接引人所在地图
	RENT_NPC_ID = 3213; --酒馆接引人npcId
	szUiHelpKey = "DrinkHouseRent"; --副本界面上的帮助key
	tbGetItemSetting = {
		--头衔等级
		[12] = { 								    nTopInKinNum = 3, nTotalInServer = 60  };
		[11] = {szCloseTimeFrame = "OpenLevel129",  nTopInKinNum = 3, nTotalInServer = 60  };
		[10] = {szCloseTimeFrame = "OpenLevel119",  nTopInKinNum = 3, nTotalInServer = 60  };
		[9]	 = {szCloseTimeFrame = "OpenLevel109",  nTopInKinNum = 3, nTotalInServer = 60  };
		[8]  = { szCloseTimeFrame = "OpenLevel99",  nTopInKinNum = 3, nTotalInServer = 60  };
		[7]  = { szCloseTimeFrame = "OpenLevel89",  nTopInKinNum = 2, nTotalInServer = 40  };
		[6]  = { szCloseTimeFrame = "OpenLevel79",  nTopInKinNum = 2, nTotalInServer = 40  };
		[5]  = { szCloseTimeFrame = "OpenLevel69",  nTopInKinNum = 1, nTotalInServer = 20  };
	};

	SendRentItemMail = {
		To = nil; -- 手动填
		Title = "Thưởng Quân Hàm";
		Text = "    Chúc mừng là người thứ %d tăng đến quân hàm [FFFE0D]「%s」[-] trong bang hội, đây là Lời Mời của Vong Ưu Tửu Quán, hãy nhận.";
		tbAttach = { {"item", 9502, 1} };
	};
	szGetRentItemKinMsg = "「%s」là người thứ %d tăng đến quân hàm 「%s」, nhận được [FFFE0D][Lời Mời Tửu Quán][-], có thể mở Tiệc Bang Hội tại Vong Ưu Tửu Quán";


	CREATE_NOTIFY = "Thành viên Bang Hội「%s」được Chủ Quán mời đến <Vong Ưu Tửu Quán> mở Tiệc Bang Hội, 2 phút sau buổi tiệc sẽ bắt đầu, mọi người hãy mau đến thưởng thức!";
	AddNpcSetting = {--摆放家族配置 ,桌子的class是 DrinkHouseTableNpc,显示采集
		{nTemplate = 3236, nLevel = 1;  nPosX = 5053, nPosY = 5071, nDir = 0};
		{nTemplate = 3236, nLevel = 1;  nPosX = 4380, nPosY = 5027, nDir = 0};
		{nTemplate = 3236, nLevel = 1;  nPosX = 6171, nPosY = 8005, nDir = 0};
		{nTemplate = 3236, nLevel = 1;  nPosX = 6164, nPosY = 8641, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 3651, nPosY = 6238, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 3992, nPosY = 6062, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 4469, nPosY = 6126, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 4435, nPosY = 6530, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 4437, nPosY = 7069, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 4661, nPosY = 7986, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 5223, nPosY = 7981, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 5221, nPosY = 8380, nDir = 0};
		{nTemplate = 3237, nLevel = 1;  nPosX = 4661, nPosY = 8388, nDir = 0};
	}; 

	nDinnerActionID = 5;
	nDinnerActionEventID = 10002;
	nDinnerWaitTime = 5;  -- 食用读条时间
	nDiceTimeOutTime = 60;-- 骰子超时时间
	nDiceTopShowNum = 3;--显示前三名
	nDiceBottomShowNum = 4;--显示最后四名
	tbPoolDiceGroup = { --潜规则骰子组合
		{ 1,1,1 };
		{ 1,2,1 };
		{ 1,2,2 };
	}; 
	tbDrinkMsg = {
		"「%s」nhận trừng phạt ném xúc xắc, cầm ly rượu lên và uống.";
		"「%s」tiếp tục nhận trừng phạt ném xúc xắc, cầm ly rượu lên và uống cạn.";
		"「%s」nhận trừng phạt ném xúc xắc lần 3, say đến cầm nhầm ly rượu của người bên cạnh lên và uống cạn.";
		"「%s」nhận trừng phạt ném xúc xắc lần 3, say đến cầm nhầm ly rượu lên đổ cả lên mặt.";
	};
	DicePriceMail = {
		To = nil; -- 手动填
		Title = "Xúc Xắc Tửu Quán";
		Text = "    Chúc mừng đại hiệp nhận thưởng hạng Xúc Xắc trong hoạt động Tiệc Bang Hội, đính kèm là phần thưởng, hãy chú ý nhận. ";
		From = "Bà Chủ Vong Ưu Tửu Quán";
		
	};
	DicePriceMailtbAttach = {
			{{"Coin", 30000}},
			{{"Coin", 20000}},
			{{"Coin", 15000}},
		};
	nPunishDanceRadius = 300;--距离跳舞点范围小于该距离的就被传送开
	tbPunishDanceSafePos = { 4020, 6588 }; --在动态障碍区的被传走的安全点
	PunishDancePos = {	--传送过去跳舞的点, 应该是等于 nDiceBottomShowNum
		{3879, 6704};
		{4158, 6704};
		{3877, 6480};
		{4187, 6448};
	};
	PunishDancePosObstacle = { --跳舞的对应的动态障碍名
		"DynmincObstacle1";
		"DynmincObstacle2";
		"DynmincObstacle3";
		"DynmincObstacle4";
	};
	nPunishDanceTime = 60; --惩罚跳舞时间
	tbPunishWaiYiItemId_Body = 8384; --惩罚跳海草舞的外装衣服
	tbPunishWaiYiItemId_Head = 8388; --惩罚跳海草舞的外装头
	nPunishDanceActionID = 10; --跳舞的动作
	nPunishDanceActionEventID = 10020;
	szPunishDanceMsg = "「%s」uống say mềm, cởi bỏ áo ngoài nhảy nhót!";


	tbFOOD_NPC_ID = { --菜桌的npcId
		[3236] = 1;
		[3237] = 2;
	}; 
	FOOD_NAME = {
		"Món khai vị";
		"Phát Lộc Phát Tài";
		"Đông Phương Minh Phụng";
		"Hồng Vận Đoàn Viên";
	};
	FOOD_AWARD = { --四道菜吃时对应奖励
		{ {"item", 9503,1 },{"BasicExp", 5} };
		{ {"item", 9503,1 },{"BasicExp", 5} };
		{ {"item", 9503,1 },{"BasicExp", 5} };
		{ {"item", 9503,1 },{"BasicExp", 5} };
	};
}


function DrinkHouse:InviteDrinkPopAvaliable(pPlayer)
	return pPlayer.GetUserValue(DrinkHouse.tbDef.SAVE_GROUP, DrinkHouse.tbDef.SAVE_KEY_DRINK_INVITE) == 1
end