local tbAct = Activity:GetClass("GoodVoice")
tbAct.tbTimerTrigger = {}
tbAct.tbTrigger = { 
	Init = { }, 
	Start = { 
	{"StartTimerTrigger", 1}, {"StartTimerTrigger", 2}, {"StartTimerTrigger", 3},
	{"StartTimerTrigger", 4}, {"StartTimerTrigger", 5}, 
	{"StartTimerTrigger", 6}, {"StartTimerTrigger", 7}, {"StartTimerTrigger", 8}, 
	--{"StartTimerTrigger", 9}, {"StartTimerTrigger", 10},{"StartTimerTrigger", 11},
	},
	End = { },
	OnWorldNotify = {},
	CheckSignUpOverdue = {},
	CheckRankGetStart = {},
}
tbAct.tbTimerTrigger = 
{
	--[1] = {szType = "Day", Time = "10:35" , Trigger = "OnWorldNotify" },  --因为发奖是在10点以后，取消该时间点的世界公告
	[1] = {szType = "Day", Time = "12:10" , Trigger = "OnWorldNotify" },
	[2] = {szType = "Day", Time = "16:10" , Trigger = "OnWorldNotify" },
	[3] = {szType = "Day", Time = "19:27" , Trigger = "OnWorldNotify" },
	[4] = {szType = "Day", Time = "22:42" , Trigger = "OnWorldNotify" },
	--[5] = {szType = "Day", Time = "23:50", Trigger = "CheckLocalResultInfo"},-- 如果在本服间歇期中间时间还没公布结果的最新消息这里直接发
	--[6] = {szType = "Day", Time = "23:50", Trigger = "CheckSemiFinalResultInfo"},-- 如果在复赛间歇期中间时间还没公布结果的最新消息这里直接发
	--[7] = {szType = "Day", Time = "23:50", Trigger = "CheckFinalResultInfo"},-- 如果在决赛间歇期中间时间还没公布结果的最新消息这里直接发
	[5] = {szType = "Day", Time = "00:00", Trigger = "CheckSignUpOverdue"},  -- 检查删除过期的报名数据
	[6] = {szType = "Day", Time = "19:18", Trigger = "CheckRankGetStart"}, 	 -- 桃花雨一轮
	[7] = {szType = "Day", Time = "19:21", Trigger = "CheckRankGetStart"},	 -- 桃花雨二轮
	[8] = {szType = "Day", Time = "19:24", Trigger = "CheckRankGetStart"},	 -- 桃花雨三轮
}

--每日礼包赠送投票道具数量
tbAct.DailyGiftVote = 
{
	[Recharge.DAILY_GIFT_TYPE.YUAN_3] = 1,
	[Recharge.DAILY_GIFT_TYPE.YUAN_6] = 2,
}

--周卡月卡赠送投票道具数量
tbAct.DaysCardVote = 
{
	[Recharge.DAYS_CARD_TYPE.DAYS_7] = 6, 			-- 周卡
	[Recharge.DAYS_CARD_TYPE.DAYS_30] = 10,  		-- 月卡
	[3] = 13, 					-- 至尊周卡
}

--充值元宝对应赠送投票道具
tbAct.tbRechargeGold = 
{
	[600] = 3;
	[3000] = 18;
	[9800] = 68;
	[19800] = 148;
	[32800] = 268;
	[64800] = 648;
}

-- 购买黎饰会给黎饰随机箱自动使用，监听相应道具给对应奖励(废弃)
tbAct.tbSilverBoardItem = 
{
	-- [4429] = 68;
	-- [7682] = 238;
	-- [7683] = 648;
}

-- 购买黎饰会给黎饰数量，监听相应数量给对应奖励
tbAct.tbSilverBoardCount = 
{
	[1000] = 68;
	[3100] = 238;
	[6900] = 648;
}

-- 100活跃度获得投票道具
tbAct.nMaxEverydayActiveVote = 2

-- 获奖类型
tbAct.WINNER_TYPE = 
{
	-- 全服决赛排名
	FINAL_1 = 1,
	FINAL_2 = 2,
	FINAL_3 = 3,
	FINAL_4 = 4,
	FINAL_5 = 5,
	FINAL_6 = 6,
	FINAL_7 = 7,
	FINAL_8 = 8,
	FINAL_9 = 9,
	FINAL_10 = 10,
	-- 全服复赛排名
	SEMI_FINAL_1 = 11,
	SEMI_FINAL_2 = 12,
	SEMI_FINAL_3 = 13,
	SEMI_FINAL_4 = 14,
	SEMI_FINAL_5 = 15,
	SEMI_FINAL_6 = 16,
	SEMI_FINAL_7 = 17,
	SEMI_FINAL_8 = 18,
	SEMI_FINAL_9 = 19,
	SEMI_FINAL_10 = 20,
	-- 本服海选排名
	LOCAL_1 = 21,
	LOCAL_2 = 22,
	LOCAL_3 = 23,
	LOCAL_4 = 24,
	LOCAL_5 = 25,
	LOCAL_6 = 26,
	LOCAL_7 = 27,
	LOCAL_8 = 28,
	LOCAL_9 = 29,
	LOCAL_10 = 30,

	-- 参与奖
	PARTICIPATE = 50, 					-- 本服参与
	SEMI_FINAL_PARTICIPATE = 51, 		-- 复赛参与
	FINAL_PARTICIPATE = 52, 			-- 决赛参与

	-- 暂定八个区域冠军
	SEMI_FINAL_AREA_1_1 = 61,				-- 复赛区域冠军（华东地区）
	SEMI_FINAL_AREA_2_1 = 62,				-- 复赛区域冠军（华南地区）
	SEMI_FINAL_AREA_3_1 = 63,				-- 复赛区域冠军（华中地区）
	SEMI_FINAL_AREA_4_1 = 64,				-- 复赛区域冠军（华北地区）
	SEMI_FINAL_AREA_5_1 = 65,				-- 复赛区域冠军（西北地区）
	SEMI_FINAL_AREA_6_1 = 66,				-- 复赛区域冠军（西南地区）
	SEMI_FINAL_AREA_7_1 = 67,				-- 复赛区域冠军（东北地区）
	SEMI_FINAL_AREA_8_1 = 68,				-- 复赛区域冠军（港澳台地区）

	-- 门派冠军
	SEMI_FINAL_FACTION_1_1 = 71, 			-- 复赛门派冠军（天王）
	SEMI_FINAL_FACTION_2_1 = 72, 			-- 复赛门派冠军（峨嵋）
	SEMI_FINAL_FACTION_3_1 = 73, 			-- 复赛门派冠军（桃花）
	SEMI_FINAL_FACTION_4_1 = 74, 			-- 复赛门派冠军（逍遥）
	SEMI_FINAL_FACTION_5_1 = 75, 			-- 复赛门派冠军（武当）
	SEMI_FINAL_FACTION_6_1 = 76, 			-- 复赛门派冠军（天忍）
	SEMI_FINAL_FACTION_7_1 = 77, 			-- 复赛门派冠军（少林）
	SEMI_FINAL_FACTION_8_1 = 78, 			-- 复赛门派冠军（翠烟）
	SEMI_FINAL_FACTION_9_1 = 79, 			-- 复赛门派冠军（唐门）
	SEMI_FINAL_FACTION_10_1 = 80, 		-- 复赛门派冠军（昆仑）
	SEMI_FINAL_FACTION_11_1 = 81, 		-- 复赛门派冠军（丐帮）
	SEMI_FINAL_FACTION_12_1 = 82, 		-- 复赛门派冠军（五毒）
	SEMI_FINAL_FACTION_13_1 = 83, 		-- 复赛门派冠军（藏剑）
	SEMI_FINAL_FACTION_14_1 = 84, 		-- 复赛门派冠军（长歌）
	SEMI_FINAL_FACTION_15_1 = 85, 		-- 复赛门派冠军（天山）
	SEMI_FINAL_FACTION_16_1 = 86, 		-- 复赛门派冠军（霸刀）

	-- 暂定八个区域亚军
	SEMI_FINAL_AREA_1_2 = 91,				-- 复赛区域亚军（华东地区）
	SEMI_FINAL_AREA_2_2 = 92,				-- 复赛区域亚军（华南地区）
	SEMI_FINAL_AREA_3_2 = 93,				-- 复赛区域亚军（华中地区）
	SEMI_FINAL_AREA_4_2 = 94,				-- 复赛区域亚军（华北地区）
	SEMI_FINAL_AREA_5_2 = 95,				-- 复赛区域亚军（西北地区）
	SEMI_FINAL_AREA_6_2 = 96,				-- 复赛区域亚军（西南地区）
	SEMI_FINAL_AREA_7_2 = 97,				-- 复赛区域亚军（东北地区）
	SEMI_FINAL_AREA_8_2 = 98,				-- 复赛区域亚军（港澳台地区）

	-- 暂定八个区域季军
	SEMI_FINAL_AREA_1_3 = 101,				-- 复赛区域季军（华东地区）
	SEMI_FINAL_AREA_2_3 = 102,				-- 复赛区域季军（华南地区）
	SEMI_FINAL_AREA_3_3 = 103,				-- 复赛区域季军（华中地区）
	SEMI_FINAL_AREA_4_3 = 104,				-- 复赛区域季军（华北地区）
	SEMI_FINAL_AREA_5_3 = 105,				-- 复赛区域季军（西北地区）
	SEMI_FINAL_AREA_6_3 = 106,				-- 复赛区域季军（西南地区）
	SEMI_FINAL_AREA_7_3 = 107,				-- 复赛区域季军（东北地区）
	SEMI_FINAL_AREA_8_3 = 108,				-- 复赛区域季军（港澳台地区）

	-- 门派亚军
	SEMI_FINAL_FACTION_1_2 = 111, 			-- 复赛门派亚军（天王）
	SEMI_FINAL_FACTION_2_2 = 112, 			-- 复赛门派亚军（峨嵋）
	SEMI_FINAL_FACTION_3_2 = 113, 			-- 复赛门派亚军（桃花）
	SEMI_FINAL_FACTION_4_2 = 114, 			-- 复赛门派亚军（逍遥）
	SEMI_FINAL_FACTION_5_2 = 115, 			-- 复赛门派亚军（武当）
	SEMI_FINAL_FACTION_6_2 = 116, 			-- 复赛门派亚军（天忍）
	SEMI_FINAL_FACTION_7_2 = 117, 			-- 复赛门派亚军（少林）
	SEMI_FINAL_FACTION_8_2 = 118, 			-- 复赛门派亚军（翠烟）
	SEMI_FINAL_FACTION_9_2 = 119, 			-- 复赛门派亚军（唐门）
	SEMI_FINAL_FACTION_10_2 = 120, 			-- 复赛门派亚军（昆仑）
	SEMI_FINAL_FACTION_11_2 = 121, 			-- 复赛门派亚军（丐帮）
	SEMI_FINAL_FACTION_12_2 = 122, 			-- 复赛门派亚军（五毒）
	SEMI_FINAL_FACTION_13_2 = 123, 			-- 复赛门派亚军（藏剑）
	SEMI_FINAL_FACTION_14_2 = 124, 			-- 复赛门派亚军（长歌）
	SEMI_FINAL_FACTION_15_2 = 125, 			-- 复赛门派亚军（天山）
	SEMI_FINAL_FACTION_16_2 = 126, 			-- 复赛门派亚军（霸刀）

	-- 门派亚军
	SEMI_FINAL_FACTION_1_3 = 131, 			-- 复赛门派季军（天王）
	SEMI_FINAL_FACTION_2_3 = 132, 			-- 复赛门派季军（峨嵋）
	SEMI_FINAL_FACTION_3_3 = 133, 			-- 复赛门派季军（桃花）
	SEMI_FINAL_FACTION_4_3 = 134, 			-- 复赛门派季军（逍遥）
	SEMI_FINAL_FACTION_5_3 = 135, 			-- 复赛门派季军（武当）
	SEMI_FINAL_FACTION_6_3 = 136, 			-- 复赛门派季军（天忍）
	SEMI_FINAL_FACTION_7_3 = 137, 			-- 复赛门派季军（少林）
	SEMI_FINAL_FACTION_8_3 = 138, 			-- 复赛门派季军（翠烟）
	SEMI_FINAL_FACTION_9_3 = 139, 			-- 复赛门派季军（唐门）
	SEMI_FINAL_FACTION_10_3 = 140, 			-- 复赛门派季军（昆仑）
	SEMI_FINAL_FACTION_11_3 = 141, 			-- 复赛门派季军（丐帮）
	SEMI_FINAL_FACTION_12_3 = 142, 			-- 复赛门派季军（五毒）
	SEMI_FINAL_FACTION_13_3 = 143, 			-- 复赛门派季军（藏剑）
	SEMI_FINAL_FACTION_14_3 = 144, 			-- 复赛门派季军（长歌）
	SEMI_FINAL_FACTION_15_3 = 145, 			-- 复赛门派季军（天山）
	SEMI_FINAL_FACTION_16_3 = 146, 			-- 复赛门派季军（霸刀）

	TEAM_LGX 				= 160, 			-- 林更新战队
	TEAM_ZLY 				= 161,			-- 赵丽颖战队
	
	VOTE_RANK_1 			= 201, 			-- 投票排行奖励第一名
	VOTE_RANK_2 			= 202, 			-- 投票排行奖励第二名
	VOTE_RANK_3 			= 203, 			-- 投票排行奖励第三名
	VOTE_RANK_4 			= 204, 			-- 投票排行奖励第四名
	VOTE_RANK_5 			= 205, 			-- 投票排行奖励第五名
	VOTE_RANK_6 			= 206, 			-- 投票排行奖励第六名
	VOTE_RANK_7 			= 207, 			-- 投票排行奖励第七名
	VOTE_RANK_8 			= 208, 			-- 投票排行奖励第八名
	VOTE_RANK_9 			= 209, 			-- 投票排行奖励第九名
	VOTE_RANK_10 			= 210, 			-- 投票排行奖励第十名
}

tbAct.nSemiFinalAreaChampionCount = 8 		-- 几个区域冠军
tbAct.nSemiFinalFactionChampionCount = 16 	-- 几个门派冠军
tbAct.tbAllWinnerType = {}
for _, nWinnerType in pairs(tbAct.WINNER_TYPE) do
	tbAct.tbAllWinnerType[nWinnerType] = true
end

tbAct.tbSemiFinalAreaDes = 
{
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_1_1] = {1,"Hoa Đông địa khu quán quân","Hoa Đông mạnh nhất âm thanh"};  				-- {名次，邮件描述title}
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_2_1] = {1,"Hoa Nam địa khu quán quân","Hoa Nam mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_3_1] = {1,"Hoa Trung địa khu quán quân","Hoa Trung mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_4_1] = {1,"Hoa Bắc địa khu quán quân","Hoa Bắc mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_5_1] = {1,"Tây Bắc địa phương quán quân","Tây Bắc mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_6_1] = {1,"Tây Nam địa khu quán quân","Tây Nam mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_7_1] = {1,"Đông Bắc địa khu quán quân","Đông Bắc mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_8_1] = {1,"Hong Kong bãi đất cao khu quán quân","Hong Kong đài mạnh nhất âm thanh"};

	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_1_2] = {2,"Hoa Đông địa khu á quân","Hoa Đông tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_2_2] = {2,"Hoa Nam địa khu á quân","Hoa Nam tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_3_2] = {2,"Hoa Trung địa khu á quân","Hoa Trung tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_4_2] = {2,"Hoa Bắc địa khu á quân","Hoa Bắc tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_5_2] = {2,"Tây Bắc địa phương á quân","Tây Bắc tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_6_2] = {2,"Tây Nam địa khu á quân","Tây Nam tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_7_2] = {2,"Đông Bắc địa khu á quân","Đông Bắc tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_8_2] = {2,"Hong Kong bãi đất cao khu á quân","Hong Kong đài tốt thanh âm"};

	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_1_3] = {3,"Hoa Đông địa khu quý quân","Hoa Đông tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_2_3] = {3,"Hoa Nam địa khu quý quân","Hoa Nam tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_3_3] = {3,"Hoa Trung địa khu quý quân","Hoa Trung tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_4_3] = {3,"Hoa Bắc địa khu quý quân","Hoa Bắc tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_5_3] = {3,"Tây Bắc địa phương quý quân","Tây Bắc tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_6_3] = {3,"Tây Nam địa khu quý quân","Tây Nam tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_7_3] = {3,"Đông Bắc địa khu quý quân","Đông Bắc tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_8_3] = {3,"Hong Kong bãi đất cao khu quý quân","Hong Kong đài tốt thanh âm"};
}

tbAct.tbSemiFinalFactionDes = 
{
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_1_1] = {1, "Thiên Vương quán quân","Thiên Vương mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_2_1] = {1, "Nga Mi quán quân","Nga Mi mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_3_1] = {1, "Hoa đào quán quân","Hoa đào mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_4_1] = {1, "Tiêu dao quán quân","Tiêu dao mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_5_1] = {1, "Võ Đang quán quân","Võ Đang mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_6_1] = {1, "Thiên nhẫn quán quân","Thiên nhẫn mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_7_1] = {1, "Thiếu Lâm quán quân","Thiếu Lâm mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_8_1] = {1, "Thúy Yên quán quân","Thúy Yên mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_9_1] = {1, "Đường Môn quán quân","Đường Môn mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_10_1]= {1, "Côn Luân quán quân","Côn Luân mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_11_1]= {1, "Cái Bang quán quân","Cái Bang mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_12_1]= {1, "Ngũ độc quán quân","Ngũ độc mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_13_1]= {1, "Giấu kiếm quán quân","Giấu kiếm mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_14_1]= {1, "Dài ca quán quân","Dài ca mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_15_1]= {1, "Thiên Sơn quán quân","Thiên Sơn mạnh nhất âm thanh"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_16_1]= {1, "Bá Đao quán quân","Bá Đao mạnh nhất âm thanh"};

	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_1_2] = {2, "Thiên Vương á quân","Thiên Vương tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_2_2] = {2, "Nga Mi á quân","Nga Mi tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_3_2] = {2, "Hoa đào á quân","Hoa đào tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_4_2] = {2, "Tiêu dao á quân","Tiêu dao tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_5_2] = {2, "Võ Đang á quân","Võ Đang tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_6_2] = {2, "Thiên nhẫn á quân","Thiên nhẫn tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_7_2] = {2, "Thiếu Lâm á quân","Thiếu Lâm tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_8_2] = {2, "Thúy Yên á quân","Thúy Yên tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_9_2] = {2, "Đường Môn á quân","Đường Môn tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_10_2]= {2, "Côn Luân á quân","Côn Luân tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_11_2]= {2, "Cái Bang á quân","Cái Bang tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_12_2]= {2, "Ngũ độc á quân","Ngũ độc tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_13_2]= {2, "Giấu kiếm á quân","Giấu kiếm tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_14_2]= {2, "Dài Geyah quân","Dài ca tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_15_2]= {2, "Thiên Sơn á quân","Thiên Sơn tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_16_2]= {2, "Bá Đao á quân","Bá Đao tốt thanh âm"};

	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_1_3] = {3, "Thiên Vương quý quân","Thiên Vương tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_2_3] = {3, "Nga Mi quý quân","Nga Mi tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_3_3] = {3, "Hoa đào quý quân","Hoa đào tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_4_3] = {3, "Tiêu dao quý quân","Tiêu dao tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_5_3] = {3, "Võ Đang quý quân","Võ Đang tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_6_3] = {3, "Thiên nhẫn quý quân","Thiên nhẫn tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_7_3] = {3, "Thiếu Lâm quý quân","Thiếu Lâm tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_8_3] = {3, "Thúy Yên quý quân","Thúy Yên tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_9_3] = {3, "Đường Môn quý quân","Đường Môn tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_10_3]= {3, "Côn Luân quý quân","Côn Luân tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_11_3]= {3, "Cái Bang quý quân","Cái Bang tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_12_3]= {3, "Ngũ độc quý quân","Ngũ độc tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_13_3]= {3, "Giấu kiếm quý quân","Giấu kiếm tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_14_3]= {3, "Dài ca quý quân","Dài ca tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_15_3]= {3, "Thiên Sơn quý quân","Thiên Sơn tốt thanh âm"};
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_16_3]= {3, "Bá Đao quý quân","Bá Đao tốt thanh âm"};
}

--本服排行奖励
tbAct.tbLocalWinnerAward = 
{
	[1] =  --海选第一
	{
		{"AddTimeTitle", 7210, Lib:ParseDateTime("2019-05-08 12:00:00")},  --称号·声动梁尘
		{"Item", 7875, 1},  --礼包
	},

	[2] =  --海选前十 
	{
		{"AddTimeTitle", 7211, Lib:ParseDateTime("2019-05-08 12:00:00")},  --称号·空谷传声
		{"Item", 7725, 1},  --前缀·空谷传声
		{"Item", 7728, 1},  --头像框·本服十大声音
		{"Item", 7736, 1},  --好声音本服十强人物绘卷
	},
}

--全服复赛排行奖励
tbAct.tbSemiFinalWinnerAward = 
{
	[1] =  --复赛第一
	{
		{"AddTimeTitle", 7209, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·声动四海
		{"Item", 7740, 1},  --<幽炎·螭魅雪狐>坐骑时装·1年
		{"Item", 7807, 1},  --前缀·声动四海
	},
}

--全服决赛排行奖励
tbAct.tbFinalWinnerAward = 
{
	[1] =  --决赛冠军
	{
		{"Item", 7882, 1},  --礼包
	},

	[2] =   --决赛亚军
	{
		{"Item", 7881, 1},  --礼包
	},
	[3] =   --决赛季军
	{
		{"Item", 7880, 1},  --礼包
	},
	[4] =   --决赛4-10名
	{
		{"Item", 7879, 1},  --礼包
	},
}

-- 全服复赛区域奖励
tbAct.tbSemiFinalAreaAward = 
{
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_1_1] = {
		{"AddTimeTitle", 7215, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华东最强声
		{"Item", 7857, 1},  --前缀·华东最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_2_1] = {
		{"AddTimeTitle", 7216, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华南最强声
		{"Item", 7856, 1},  --前缀·华南最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_3_1] = {
		{"AddTimeTitle", 7217, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华中最强声
		{"Item", 7855, 1},  --前缀·华中最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_4_1] = {
		{"AddTimeTitle", 7218, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华北最强声
		{"Item", 7854, 1},  --前缀·华北最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_5_1] = {
		{"AddTimeTitle", 7219, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·西北最强声
		{"Item", 7853, 1},  --前缀·西北最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_6_1] = {
		{"AddTimeTitle", 7220, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·西南最强声
		{"Item", 7852, 1},  --前缀·西南最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_7_1] = {
		{"AddTimeTitle", 7221, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·东北最强声
		{"Item", 7851, 1},  --前缀·东北最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_8_1] = {
		{"AddTimeTitle", 7222, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·港澳台最强声
		{"Item", 7850, 1},  --前缀·港澳台最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_1_2] = {
		{"AddTimeTitle", 7223, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华东好声音
		{"Item", 7849, 1},  --前缀·华东好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_2_2] = {
		{"AddTimeTitle", 7224, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华南好声音
		{"Item", 7848, 1},  --前缀·华南好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_3_2] = {
		{"AddTimeTitle", 7225, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华中好声音
		{"Item", 7847, 1},  --前缀·华中好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_4_2] = {
		{"AddTimeTitle", 7226, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华北好声音
		{"Item", 7846, 1},  --前缀·华北好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_5_2] = {
		{"AddTimeTitle", 7227, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·西北好声音
		{"Item", 7845, 1},  --前缀·西北好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_6_2] = {
		{"AddTimeTitle", 7228, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·西南好声音
		{"Item", 7844, 1},  --前缀·西南好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_7_2] = {
		{"AddTimeTitle", 7229, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·东北好声音
		{"Item", 7843, 1},  --前缀·东北好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_8_2] = {
		{"AddTimeTitle", 7230, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·港澳台好声音
		{"Item", 7842, 1},  --前缀·港澳台好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_1_3] = {
		{"AddTimeTitle", 7223, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华东好声音
		{"Item", 7849, 1},  --前缀·华东好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_2_3] = {
		{"AddTimeTitle", 7224, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华南好声音
		{"Item", 7848, 1},  --前缀·华南好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_3_3] = {
		{"AddTimeTitle", 7225, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华中好声音
		{"Item", 7847, 1},  --前缀·华中好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_4_3] = {
		{"AddTimeTitle", 7226, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·华北好声音
		{"Item", 7846, 1},  --前缀·华北好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_5_3] = {
		{"AddTimeTitle", 7227, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·西北好声音
		{"Item", 7845, 1},  --前缀·西北好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_6_3] = {
		{"AddTimeTitle", 7228, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·西南好声音
		{"Item", 7844, 1},  --前缀·西南好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_7_3] = {
		{"AddTimeTitle", 7229, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·东北好声音
		{"Item", 7843, 1},  --前缀·东北好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_8_3] = {
		{"AddTimeTitle", 7230, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·港澳台好声音
		{"Item", 7842, 1},  --前缀·港澳台好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
}

-- 全服复赛门派冠军奖励
tbAct.tbSemiFinalFactionAward = 
{
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_1_1] = {
		{"AddTimeTitle", 7231, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天王最强声
		{"Item", 7841, 1},  --前缀·天王最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_2_1] = {
		{"AddTimeTitle", 7232, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·峨嵋最强声
		{"Item", 7840, 1},  --前缀·峨嵋最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_3_1] = {
		{"AddTimeTitle", 7233, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·桃花最强声
		{"Item", 7839, 1},  --前缀·桃花最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_4_1] = {
		{"AddTimeTitle", 7234, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·逍遥最强声
		{"Item", 7838, 1},  --前缀·逍遥最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_5_1] = {
		{"AddTimeTitle", 7235, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·武当最强声
		{"Item", 7837, 1},  --前缀·武当最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_6_1] = {
		{"AddTimeTitle", 7236, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天忍最强声
		{"Item", 7836, 1},  --前缀·天忍最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_7_1] = {
		{"AddTimeTitle", 7237, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·少林最强声
		{"Item", 7835, 1},  --前缀·少林最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_8_1] = {
		{"AddTimeTitle", 7238, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·翠烟最强声
		{"Item", 7834, 1},  --前缀·翠烟最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_9_1] = {
		{"AddTimeTitle", 7239, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·唐门最强声
		{"Item", 7833, 1},  --前缀·唐门最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_10_1] = {
		{"AddTimeTitle", 7240, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·昆仑最强声
		{"Item", 7832, 1},  --前缀·昆仑最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_11_1] = {
		{"AddTimeTitle", 7241, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·丐帮最强声
		{"Item", 7831, 1},  --前缀·丐帮最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_12_1] = {
		{"AddTimeTitle", 7242, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·五毒最强声
		{"Item", 7830, 1},  --前缀·五毒最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_13_1] = {
		{"AddTimeTitle", 7243, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·藏剑最强声
		{"Item", 7829, 1},  --前缀·藏剑最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_14_1] = {
		{"AddTimeTitle", 7244, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·长歌最强声
		{"Item", 7828, 1},  --前缀·长歌最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_15_1] = {
		{"AddTimeTitle", 7245, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天山最强声
		{"Item", 7827, 1},  --前缀·天山最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_16_1] = {
		{"AddTimeTitle", 7246, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·霸刀最强声
		{"Item", 7826, 1},  --前缀·霸刀最强声
		{"Item", 7876, 1},  --头像框·洋洋盈耳
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_1_2] = {
		{"AddTimeTitle", 7247, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天王好声音
		{"Item", 7825, 1},  --前缀·天王好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_2_2] = {
		{"AddTimeTitle", 7248, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·峨嵋好声音
		{"Item", 7824, 1},  --前缀·峨嵋好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_3_2] = {
		{"AddTimeTitle", 7249, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·桃花好声音
		{"Item", 7823, 1},  --前缀·桃花好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_4_2] = {
		{"AddTimeTitle", 7250, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·逍遥好声音
		{"Item", 7822, 1},  --前缀·逍遥好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_5_2] = {
		{"AddTimeTitle", 7251, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·武当好声音
		{"Item", 7821, 1},  --前缀·武当好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_6_2] = {
		{"AddTimeTitle", 7252, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天忍好声音
		{"Item", 7820, 1},  --前缀·天忍好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_7_2] = {
		{"AddTimeTitle", 7253, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·少林好声音
		{"Item", 7819, 1},  --前缀·少林好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_8_2] = {
		{"AddTimeTitle", 7254, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·翠烟好声音
		{"Item", 7818, 1},  --前缀·翠烟好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_9_2] = {
		{"AddTimeTitle", 7255, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·唐门好声音
		{"Item", 7817, 1},  --前缀·唐门好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_10_2] = {
		{"AddTimeTitle", 7256, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·昆仑好声音
		{"Item", 7816, 1},  --前缀·昆仑好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_11_2] = {
		{"AddTimeTitle", 7257, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·丐帮好声音
		{"Item", 7815, 1},  --前缀·丐帮好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_12_2] = {
		{"AddTimeTitle", 7258, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·五毒好声音
		{"Item", 7814, 1},  --前缀·五毒好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_13_2] = {
		{"AddTimeTitle", 7259, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·藏剑好声音
		{"Item", 7813, 1},  --前缀·藏剑好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_14_2] = {
		{"AddTimeTitle", 7260, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·长歌好声音
		{"Item", 7812, 1},  --前缀·长歌好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_15_2] = {
		{"AddTimeTitle", 7261, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天山好声音
		{"Item", 7811, 1},  --前缀·天山好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_16_2] = {
		{"AddTimeTitle", 7262, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·霸刀好声音
		{"Item", 7810, 1},  --前缀·霸刀好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_1_3] = {
		{"AddTimeTitle", 7247, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天王好声音
		{"Item", 7825, 1},  --前缀·天王好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_2_3] = {
		{"AddTimeTitle", 7248, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·峨嵋好声音
		{"Item", 7824, 1},  --前缀·峨嵋好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_3_3] = {
		{"AddTimeTitle", 7249, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·桃花好声音
		{"Item", 7823, 1},  --前缀·桃花好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_4_3] = {
		{"AddTimeTitle", 7250, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·逍遥好声音
		{"Item", 7822, 1},  --前缀·逍遥好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_5_3] = {
		{"AddTimeTitle", 7251, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·武当好声音
		{"Item", 7821, 1},  --前缀·武当好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_6_3] = {
		{"AddTimeTitle", 7252, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天忍好声音
		{"Item", 7820, 1},  --前缀·天忍好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_7_3] = {
		{"AddTimeTitle", 7253, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·少林好声音
		{"Item", 7819, 1},  --前缀·少林好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_8_3] = {
		{"AddTimeTitle", 7254, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·翠烟好声音
		{"Item", 7818, 1},  --前缀·翠烟好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_9_3] = {
		{"AddTimeTitle", 7255, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·唐门好声音
		{"Item", 7817, 1},  --前缀·唐门好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_10_3] = {
		{"AddTimeTitle", 7256, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·昆仑好声音
		{"Item", 7816, 1},  --前缀·昆仑好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_11_3] = {
		{"AddTimeTitle", 7257, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·丐帮好声音
		{"Item", 7815, 1},  --前缀·丐帮好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_12_3] = {
		{"AddTimeTitle", 7258, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·五毒好声音
		{"Item", 7814, 1},  --前缀·五毒好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_13_3] = {
		{"AddTimeTitle", 7259, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·藏剑好声音
		{"Item", 7813, 1},  --前缀·藏剑好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_14_3] = {
		{"AddTimeTitle", 7260, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·长歌好声音
		{"Item", 7812, 1},  --前缀·长歌好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_15_3] = {
		{"AddTimeTitle", 7261, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·天山好声音
		{"Item", 7811, 1},  --前缀·天山好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_16_3] = {
		{"AddTimeTitle", 7262, Lib:ParseDateTime("2019-05-15 12:00:00")},  --称号·霸刀好声音
		{"Item", 7810, 1},  --前缀·霸刀好声音
		{"Item", 7737, 1},  --好声音复赛前三人物绘卷
		{"Item", 7858, 1},  --家具·音乐盒
		{"Item", 6535, 2},  --5000真气元气贡献任选礼盒
	},
}

-- 决赛达到某个名次给全服玩家发奖
tbAct.tbFinalRankGlobalAward = 
{
	[tbAct.WINNER_TYPE.FINAL_1] = {{"Item", 7930, 1}},
	[tbAct.WINNER_TYPE.FINAL_2] = {{"Item", 7930, 1}},
	[tbAct.WINNER_TYPE.FINAL_3] = {{"Item", 7930, 1}},
}

--海选赛投票参与奖励（199票）
tbAct.tbParticipateAward = 
{
	{"AddTimeTitle", 7212, Lib:ParseDateTime("2019-05-15 12:00:00")},
	{"Item", 7735, 1},  --好声音人物绘卷
	{"Item", 6535, 3},  --5000真气元气贡献任选礼盒
}

--复赛投票参与奖励（8000票）
tbAct.tbSemiParticipateAward = 
{
	{"AddTimeTitle", 7263, Lib:ParseDateTime("2019-05-15 12:00:00")},
	{"Item", 7858, 1},  --家具·音乐盒
	{"Item", 6535, 4},  --5000真气元气贡献任选礼盒
	{"Item", 7801, 1},  --前缀·金声玉色
}

--决赛投票参与奖励
tbAct.tbFinalParticipateAward = 
{
	{"Item", 6535, 10},  --5000真气元气贡献任选礼盒
}

-- 林更新战队奖励
tbAct.tbTeamLGXAward = 
{
	{"AddTimeTitle", 7267, Lib:ParseDateTime("2019-05-23 12:00:00")},
	{"Item", 6535, 4},
}

-- 赵丽颖战队奖励
tbAct.tbTeamZLYAward = 
{
	{"AddTimeTitle", 7266, Lib:ParseDateTime("2019-05-23 12:00:00")},
	{"Item", 6535, 4},
}
-- 投票总排行榜名次奖励(名次-奖励)
tbAct.tbVoteRankAward = 
{
	[1] = {{"Item", 7860, 1},{"Item", 7727, 1}};
	[2] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
	[3] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
	[4] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
	[5] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
	[6] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
	[7] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
	[8] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
	[9] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
	[10] = {{"Item", 7860, 1},{"Item", 7732, 1},{"Item", 7727, 1},{"AddTimeTitle", 7214, Lib:ParseDateTime("2019-05-23 12:00:00")}};
}

tbAct.tbSignUpMail = 
{
	[tbAct.STATE_TYPE.LOCAL] = 
	{
		Title = "Tốt thanh âm báo danh thông tri",
		Text = "    Chúc mừng đại hiệp! Ngươi thành công báo danh「Kiếm hiệp tốt thanh âm bình chọn」Hải tuyển thi đấu, phụ kiện vì ngươi dự thi tuyên truyền đơn.[FFFE0D] Có thể thông qua nó đang tùy ý nói chuyện phiếm kênh tuyên truyền người tốt thanh âm thông tin, hoặc mở ra mình dự thi giao diện.[-] Nhắc nhở: [FF6464FF] Đã thượng truyền dự thi tư liệu đại bộ phận không thể sửa đổi, đề nghị hoạt động trong lúc đó không muốn sửa đổi nhân vật danh tự a![-]\n    [00FF00][url=openGoodVoiceUrl: Xem xét hoạt động giao diện,1]\n    [url=openGoodVoiceUrl: Xem xét ta giao diện, 3;%s;%s][-]",
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoice_SignUp,
		tbAttach = {{"item", tbAct.SIGNUP_ITEM, 1, tbAct.STATE_TIME[tbAct.STATE_TYPE.LOCAL][2]}},
	},
	[tbAct.STATE_TYPE.SEMI_FINAL] = 
	{
		Title = "Tốt thanh âm nhập vây đấu bán kết thông tri",
		Text = "    Chúc mừng đại hiệp! Ngươi thành công [FFFE0D] Nhập vây tốt thanh âm đấu bán kết [-] Giai đoạn.\n    Đấu bán kết ( Vượt phục bình chọn ) Đem với [FFFE0D]5 Nguyệt 7 Nhật [-] Bắt đầu, đến lúc đó ngươi đem cùng đến từ cái khác server hải tuyển lúc trước 5 Tên cùng số phiếu vượt qua 1 Vạn phiếu người chơi cộng đồng tranh đấu [ff578c] Trận chung kết tư cách [-], phụ kiện vì ngươi trận chung kết tuyên truyền đơn.\n    [00FF00][url=openGoodVoiceUrl: Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl: Xem xét ta giao diện, 3;%s;%s][-]",
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoice_SignUp,
		tbAttach = {{"item", tbAct.SIGNUP_ITEM_SEMI_FINAL, 1, tbAct.STATE_TIME[tbAct.STATE_TYPE.SEMI_FINAL][2]}},
	},
	[tbAct.STATE_TYPE.FINAL] = 
	{
		Title = "Tốt thanh âm nhập vây trận chung kết thông tri",
		Text = "    Chúc mừng đại hiệp! Ngươi thành công [FFFE0D] Nhập vây tốt thanh âm trận chung kết [-] Giai đoạn.\n    Trận chung kết ( Vượt phục bình chọn ) Đem với [FFFE0D]5 Nguyệt 14 Hào [-] Bắt đầu, đến lúc đó ngươi đem cùng đấu bán kết tổng bảng trước 100 Tên người chơi cộng đồng tranh đấu [ff578c] Tổng quán quân [-], phụ kiện vì ngươi trận chung kết tuyên truyền đơn.\n    [00FF00][url=openGoodVoiceUrl: Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl: Xem xét ta giao diện, 3;%s;%s][-]",
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoice_SignUp,
		tbAttach = {{"item", tbAct.SIGNUP_ITEM_FINAL, 1, tbAct.STATE_TIME[tbAct.STATE_TYPE.FINAL][2]}},
	},
}

-- 排行邮件内容
tbAct.tbWinnerMailInfo = 
{
	[1] = {szName="Quán quân", szTitle="Đệ nhất", szContent="    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D] Thứ %d Tên [-].\n    Chúc mừng đại hiệp! Ngươi bị bình chọn vì[ff578c]「Võ lâm %s Ca sĩ 」[-]%s"},
	[2] = {szName="Á quân", szTitle="Đệ nhị", szContent="    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D] Thứ %d Tên [-].\n    Chúc mừng đại hiệp! Ngươi bị bình chọn vì[ff578c]「Võ lâm %s Ca sĩ 」[-]%s"},
	[3] = {szName="Quý quân", szTitle="Đệ tam", szContent="    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D] Thứ %d Tên [-].\n    Chúc mừng đại hiệp! Ngươi bị bình chọn vì[ff578c]「Võ lâm %s Ca sĩ 」[-]%s"},
	[4] = {szName="Thập cường", szTitle="Thập đại", szContent="    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D] Thứ %d Tên [-].\n    Chúc mừng đại hiệp! Ngươi bị bình chọn vì [ff578c]「Võ lâm %s Ca sĩ 」[-]%s"},
}

tbAct.AVAILABLE_CHANNEL = 
{
	[ChatMgr.ChannelType.Public] = 1,
	[ChatMgr.ChannelType.Team] = 1,
	[ChatMgr.ChannelType.Kin] = 1,
	[ChatMgr.ChannelType.Nearby] = 1,
	[ChatMgr.ChannelType.Friend] = 1,
}

--本服冠军雕像有效期3个月
tbAct.nLocalStatueTimeOut = 3*30*24*60*60
-- 复赛冠军雕像有效期6个月
tbAct.nSemiFinalStatueTimeOut = 6*30*24*60*60
-- 雕像
tbAct.tbStatueInfo =
{
	[tbAct.WINNER_TYPE.FINAL_1] =
	{
		--襄阳城总冠军
		{
			nTemplateId = 2940,
			pos = {10, 13350,15062},
			nTitleId = 7206,
			nDir = 0,
		},
		--临安城雕像总冠军
		{
			nTemplateId = 2940,
			pos = {15, 8230,11423},
			nTitleId = 7206,
			nDir = 24,
		},
	},
	[tbAct.WINNER_TYPE.FINAL_2] =
	{
		--襄阳城总亚军
		{
			nTemplateId = 2940,
			pos = {10, 13200,15062},
			nTitleId = 7207,
			nDir = 0,
		},
		--临安城总亚军
		{
			nTemplateId = 2940,
			pos = {15, 8034,11453},
			nTitleId = 7207,
			nDir = 24,
		},
	},
	[tbAct.WINNER_TYPE.FINAL_3] =
	{
		--襄阳城总季军
		{
			nTemplateId = 2940,
			pos = {10, 13050,15062},
			nTitleId = 7208,
			nDir = 0,
		},
		--临安城总季军
		{
			nTemplateId = 2940,
			pos = {15, 8305,11711},
			nTitleId = 7208,
			nDir = 24,
		},
	},

	[tbAct.WINNER_TYPE.SEMI_FINAL_1] =
	{
		--襄阳城复赛冠军
		{
			nTemplateId = 2940,
			pos = {10, 12900,15062},
			nTitleId = 7209,
			nDir = 0,
		},
		--临安城复赛冠军
		{
			nTemplateId = 2940,
			pos = {15, 8308,11865},
			nTitleId = 7209,
			nDir = 24,
		},
	},

	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_1_1] =
	{
		--襄阳城复赛华东冠军
		{
			nTemplateId = 2940,
			pos = {10, 11890,17600},
			nTitleId = 7215,
			nDir = 57,
		},
		--临安城复赛华东冠军
		{
			nTemplateId = 2940,
			pos = {15, 8866,14650},
			nTitleId = 7215,
			nDir = 49,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_2_1] =
	{
		--襄阳城复赛华南冠军
		{
			nTemplateId = 2940,
			pos = {10, 11890,17400},
			nTitleId = 7216,
			nDir = 57,
		},
		--临安城复赛华南冠军
		{
			nTemplateId = 2940,
			pos = {15, 8866,14800},
			nTitleId = 7216,
			nDir = 49,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_3_1] =
	{
		--襄阳城复赛华中冠军
		{
			nTemplateId = 2940,
			pos = {10, 11890,17200},
			nTitleId = 7217,
			nDir = 57,
		},
		--临安城复赛华中冠军
		{
			nTemplateId = 2940,
			pos = {15, 8866,14950},
			nTitleId = 7217,
			nDir = 49,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_4_1] =
	{
		--襄阳城复赛华北冠军
		{
			nTemplateId = 2940,
			pos = {10, 11890,17000},
			nTitleId = 7218,
			nDir = 57,
		},
		--临安城复赛华北冠军
		{
			nTemplateId = 2940,
			pos = {15, 8866,15100},
			nTitleId = 7218,
			nDir = 49,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_5_1] =
	{
		--襄阳城复赛西北冠军
		{
			nTemplateId = 2940,
			pos = {10, 11330,17600},
			nTitleId = 7219,
			nDir = 57,
		},
		--临安城复赛西北冠军
		{
			nTemplateId = 2940,
			pos = {15, 8866,15250},
			nTitleId = 7219,
			nDir = 49,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_6_1] =
	{
		--襄阳城复赛西南冠军
		{
			nTemplateId = 2940,
			pos = {10, 11330,17400},
			nTitleId = 7220,
			nDir = 57,
		},
		--临安城复赛西南冠军
		{
			nTemplateId = 2940,
			pos = {15, 8866,15400},
			nTitleId = 7220,
			nDir = 49,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_7_1] =
	{
		--襄阳城复赛东北冠军
		{
			nTemplateId = 2940,
			pos = {10, 11330,17200},
			nTitleId = 7221,
			nDir = 57,
		},
		--临安城复赛东北冠军
		{
			nTemplateId = 2940,
			pos = {15, 8866,15550},
			nTitleId = 7221,
			nDir = 49,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_8_1] =
	{
		--襄阳城复赛港澳台冠军
		{
			nTemplateId = 2940,
			pos = {10, 11330,17000},
			nTitleId = 7222,
			nDir = 57,
		},
		--临安城复赛港澳台冠军
		{
			nTemplateId = 2940,
			pos = {15, 8866,15700},
			nTitleId = 7222,
			nDir = 49,
		},
	},

	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_1_1] =
	{
		--襄阳城复赛天王冠军
		{
			nTemplateId = 2940,
			pos = {10, 7800,15060},
			nTitleId = 7231,
			nDir = 57,
		},
		--临安城复赛天王冠军
		{
			nTemplateId = 2940,
			pos = {15, 8238,12700},
			nTitleId = 7231,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_2_1] =
	{
		--襄阳城复赛峨嵋冠军
		{
			nTemplateId = 2940,
			pos = {10, 8000,15060},
			nTitleId = 7232,
			nDir = 57,
		},
		--临安城复赛峨嵋冠军
		{
			nTemplateId = 2940,
			pos = {15, 8238,12850},
			nTitleId = 7232,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_3_1] =
	{
		--襄阳城复赛桃花冠军
		{
			nTemplateId = 2940,
			pos = {10, 8200,15060},
			nTitleId = 7233,
			nDir = 57,
		},
		--临安城复赛桃花冠军
		{
			nTemplateId = 2940,
			pos = {15, 8238,13000},
			nTitleId = 7233,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_4_1] =
	{
		--襄阳城复赛逍遥冠军
		{
			nTemplateId = 2940,
			pos = {10, 9100,15060},
			nTitleId = 7234,
			nDir = 57,
		},
		--临安城复赛逍遥冠军
		{
			nTemplateId = 2940,
			pos = {15, 8238,13150},
			nTitleId = 7234,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_5_1] =
	{
		--襄阳城复赛武当冠军
		{
			nTemplateId = 2940,
			pos = {10, 9300,15060},
			nTitleId = 7235,
			nDir = 57,
		},
		--临安城复赛武当冠军
		{
			nTemplateId = 2940,
			pos = {15, 8238,13300},
			nTitleId = 7235,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_6_1] =
	{
		--襄阳城复赛天忍冠军
		{
			nTemplateId = 2940,
			pos = {10, 9500,15060},
			nTitleId = 7236,
			nDir = 57,
		},
		--临安城复赛天忍冠军
		{
			nTemplateId = 2940,
			pos = {15, 8238,13450},
			nTitleId = 7236,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_7_1] =
	{
		--襄阳城复赛少林冠军
		{
			nTemplateId = 2940,
			pos = {10, 9700,15060},
			nTitleId = 7237,
			nDir = 57,
		},
		--临安城复赛少林冠军
		{
			nTemplateId = 2940,
			pos = {15, 8238,13600},
			nTitleId = 7237,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_8_1] =
	{
		--襄阳城复赛翠烟冠军
		{
			nTemplateId = 2940,
			pos = {10, 9900,15060},
			nTitleId = 7238,
			nDir = 57,
		},
		--临安城复赛翠烟冠军
		{
			nTemplateId = 2940,
			pos = {15, 8238,13750},
			nTitleId = 7238,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_9_1] =
	{
		--襄阳城复赛唐门冠军
		{
			nTemplateId = 2940,
			pos = {10, 7800,15660},
			nTitleId = 7239,
			nDir = 57,
		},
		--临安城复赛唐门冠军
		{
			nTemplateId = 2940,
			pos = {15, 8703,12700},
			nTitleId = 7239,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_10_1] =
	{
		--襄阳城复赛昆仑冠军
		{
			nTemplateId = 2940,
			pos = {10, 8000,15660},
			nTitleId = 7240,
			nDir = 57,
		},
		--临安城复赛昆仑冠军
		{
			nTemplateId = 2940,
			pos = {15, 8703,12850},
			nTitleId = 7240,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_11_1] =
	{
		--襄阳城复赛丐帮冠军
		{
			nTemplateId = 2940,
			pos = {10, 8200,15660},
			nTitleId = 7241,
			nDir = 57,
		},
		--临安城复赛丐帮冠军
		{
			nTemplateId = 2940,
			pos = {15, 8703,13000},
			nTitleId = 7241,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_12_1] =
	{
		--襄阳城复赛五毒冠军
		{
			nTemplateId = 2940,
			pos = {10, 9100,15660},
			nTitleId = 7242,
			nDir = 57,
		},
		--临安城复赛五毒冠军
		{
			nTemplateId = 2940,
			pos = {15, 8703,13150},
			nTitleId = 7242,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_13_1] =
	{
		--襄阳城复赛藏剑冠军
		{
			nTemplateId = 2940,
			pos = {10, 9300,15660},
			nTitleId = 7243,
			nDir = 57,
		},
		--临安城复赛藏剑冠军
		{
			nTemplateId = 2940,
			pos = {15, 8703,13300},
			nTitleId = 7243,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_14_1] =
	{
		--襄阳城复赛长歌冠军
		{
			nTemplateId = 2940,
			pos = {10, 9500,15660},
			nTitleId = 7244,
			nDir = 57,
		},
		--临安城复赛长歌冠军
		{
			nTemplateId = 2940,
			pos = {15, 8703,13450},
			nTitleId = 7244,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_15_1] =
	{
		--襄阳城复赛天山冠军
		{
			nTemplateId = 2940,
			pos = {10, 9700,15660},
			nTitleId = 7245,
			nDir = 57,
		},
		--临安城复赛天山冠军
		{
			nTemplateId = 2940,
			pos = {15, 8703,13600},
			nTitleId = 7245,
			nDir = 39,
		},
	},
	[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_16_1] =
	{
		--襄阳城复赛霸刀冠军
		{
			nTemplateId = 2940,
			pos = {10, 9900,15660},
			nTitleId = 7246,
			nDir = 57,
		},
		--临安城复赛霸刀冠军
		{
			nTemplateId = 2940,
			pos = {15, 8703,13750},
			nTitleId = 7246,
			nDir = 39,
		},
	},

	[tbAct.WINNER_TYPE.LOCAL_1] =  --海选赛第一名
	{
		--襄阳城海选冠军
		{
			nTemplateId = 2940,
			pos = {10, 12741,15062},
			nTitleId = 7210,
			nDir = 0,
		},
		--临安城海选冠军
		{
			nTemplateId = 2940,
			pos = {15, 7873,11507},
			nTitleId = 7210,
			nDir = 24,
		},
	},
}

-- 喊话
tbAct.tbNpcBubble = 
{
	[tbAct.STATE_TYPE.SIGN_UP] = --报名阶段
	{
		--襄阳
		--纳兰真
		{nNpcTemplate=90, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Kiếm hiệp tốt thanh âm」Lửa nóng tiếp nhận báo danh bên trong, hải tuyển giai đoạn tùy thời đều có thể gia nhập!"},
		--小紫烟
		{nNpcTemplate=95, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Tại sao tiểu hài tử không thể báo danh「Kiếm hiệp tốt thanh âm」, hừ hừ ~"},
		--张琳心
		{nNpcTemplate=621, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nghe nói「Kiếm hiệp tốt thanh âm」Hải tuyển thi đấu đã bắt đầu báo danh, ta cũng phải lên đường tiến đến dự thi."},
		--唐影
		{nNpcTemplate=620, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Kiếm hiệp tốt thanh âm」Tuyển thủ dự thi bên trong, phái Thiên Sơn những cái kia tiểu tỷ tỷ đã có thể đạn lại biết hát."},
		--小殷方
		{nNpcTemplate=623, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Ta cũng muốn báo danh「Kiếm hiệp tốt thanh âm」, ta muốn hát hai con lão hổ!."},
		--杨瑛
		{nNpcTemplate=633, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nếu có cơ hội, ta cũng muốn tới kiến thức một chút võ lâm lập tức thịnh sự「Kiếm hiệp tốt thanh âm」."},
		--紫轩
		{nNpcTemplate=622, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Một khúc「Tam sinh tam thế」,「Kiếm hiệp tốt thanh âm」Quán quân nhất định là ta"},
		--月眉儿
		{nNpcTemplate=97, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Thanh âm của ta, có thể đánh động ngươi sao?"},
		--杨影枫
		{nNpcTemplate=624, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nếu như ta tham gia「Kiếm hiệp tốt thanh âm」, nhất định sẽ còn mê đảo một đám cô nương đi, ha ha ha ha......"},
		--万金财
		{nNpcTemplate=190, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc hắc ~ Năm nay「Kiếm hiệp tốt thanh âm」Từ ta Vạn mỗ người thương hội nhà tài trợ duy nhất, ban thưởng phong phú, cố ý đại hiệp mau mau tiến đến báo danh đi."},
		--公孙惜花
		{nNpcTemplate=99, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Gần đây trong chốn võ lâm ngay tại tổ chức「Kiếm hiệp tốt thanh âm」 , ta cái này「Ẩn hương lâu」 Nhưng góp nhặt không ít thi đấu sự tình báo nha ~"},
		--秋依水
		{nNpcTemplate=694, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Phái Thiên Sơn thực lực không thể khinh thường, nhưng chúng ta Thúy Yên môn đệ tử cũng không sợ tham gia「Kiếm hiệp tốt thanh âm」 "},
		--武僧
		{nNpcTemplate=1829, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="A Di Đà Phật, nếu như ta cũng tham gia「Kiếm hiệp tốt thanh âm」 , nên niệm cái nào bản trải qua đâu......"},
		--祝子虚
		{nNpcTemplate=1528, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hồng trần làm bạn, tiêu tiêu sái sái. Giục ngựa hát vang, cùng múa thiên nhai.——[FFFE0D]「Kiếm hiệp tốt thanh âm」 [-]"},
		--黄暮云
		{nNpcTemplate=1530, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hì hì ha ha, ta la lỵ âm, ngươi thích không?"},

		--临安
		--纳兰真
		{nNpcTemplate=90, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="「Kiếm hiệp tốt thanh âm」 Lửa nóng tiếp nhận báo danh bên trong, hải tuyển giai đoạn tùy thời đều có thể gia nhập!"},
		--小紫烟
		{nNpcTemplate=95, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Tại sao tiểu hài tử không thể báo danh「Kiếm hiệp tốt thanh âm」 , hừ hừ ~"},
		--张琳心
		{nNpcTemplate=621, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Nghe nói「Kiếm hiệp tốt thanh âm」 Hải tuyển thi đấu đã bắt đầu báo danh, ta cũng phải lên đường tiến đến dự thi."},
		--唐影
		{nNpcTemplate=620, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="「Kiếm hiệp tốt thanh âm」 Tuyển thủ dự thi bên trong, phái Thiên Sơn những cái kia tiểu tỷ tỷ đã có thể đạn lại biết hát."},
		--小殷方
		{nNpcTemplate=623, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Ta cũng muốn báo danh「Kiếm hiệp tốt thanh âm」 , ta muốn hát hai con lão hổ!."},
		--杨瑛
		{nNpcTemplate=633, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Nếu có cơ hội, ta cũng muốn tới kiến thức một chút võ lâm lập tức thịnh sự「Kiếm hiệp tốt thanh âm」 ."},
		--紫轩
		{nNpcTemplate=622, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Một khúc「Tam sinh tam thế」 ,「Kiếm hiệp tốt thanh âm」 Quán quân nhất định là ta"},
		--月眉儿
		{nNpcTemplate=97, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Thanh âm của ta, có thể đánh động ngươi sao?"},
		--杨影枫
		{nNpcTemplate=624, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Nếu như ta tham gia「Kiếm hiệp tốt thanh âm」 , nhất định sẽ còn mê đảo một đám cô nương đi, ha ha ha ha......"},
		--万金财
		{nNpcTemplate=190, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc hắc ~ Năm nay「Kiếm hiệp tốt thanh âm」 Từ ta Vạn mỗ người thương hội nhà tài trợ duy nhất, ban thưởng phong phú, cố ý đại hiệp mau mau tiến đến báo danh đi."},
		--公孙惜花
		{nNpcTemplate=99, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Gần đây trong chốn võ lâm ngay tại tổ chức「Kiếm hiệp tốt thanh âm」 , ta cái này「Ẩn hương lâu」Nhưng góp nhặt không ít thi đấu sự tình báo nha ~"},
		--秋依水
		{nNpcTemplate=694, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Phái Thiên Sơn thực lực không thể khinh thường, nhưng chúng ta Thúy Yên môn đệ tử cũng không sợ tham gia「Kiếm hiệp tốt thanh âm」 "},
		--武僧
		{nNpcTemplate=1829, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="A Di Đà Phật, nếu như ta cũng tham gia「Kiếm hiệp tốt thanh âm」 , nên niệm cái nào bản trải qua đâu......"},
		--祝子虚
		{nNpcTemplate=1528, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Hồng trần làm bạn, tiêu tiêu sái sái. Giục ngựa hát vang, cùng múa thiên nhai.——[FFFE0D]「Kiếm hiệp tốt thanh âm」 [-]"},
		--黄暮云
		{nNpcTemplate=1530, nMapId=15, szDateTime={"00:00:00", "23:59:59"}, szContent="Hì hì ha ha, ta la lỵ âm, ngươi thích không?"},

	};
}

-- 公告
tbAct.tbWorldNotify = 
{
	--报名阶段
	[tbAct.STATE_TYPE.SIGN_UP] = "「Kiếm hiệp tốt thanh âm」Ngay tại lửa nóng tiếp nhận báo danh bên trong, chư vị đại hiệp nhưng tiến về chủ thành Nạp Lan thật chỗ báo danh",  
	--海选赛
	[tbAct.STATE_TYPE.LOCAL] = "「Kiếm hiệp tốt thanh âm」Hải tuyển thi đấu ( Bản phục bình chọn ) Đang tiến hành bên trong, nhanh đi cho các ngươi trong suy nghĩ đẹp nhất thanh âm ném bên trên một phiếu đi! Chưa báo danh đại hiệp nhưng tiến về chủ thành Nạp Lan thật chỗ báo danh.",  
	--海选赛展示
	[tbAct.STATE_TYPE.LOCAL_REST] = "「Kiếm hiệp tốt thanh âm」Hải tuyển thi đấu ( Bản phục bình chọn ) Trước mười đã sinh ra, bản phục quán quân pho tượng đã ở chủ thành Nạp Lan thật chỗ dựng nên, nhanh đi cúng bái một phen đi!",
	--复赛
	[tbAct.STATE_TYPE.SEMI_FINAL] = "「Kiếm hiệp tốt thanh âm」Đấu bán kết ( Vượt phục bình chọn ) Đang tiến hành bên trong, nhanh đi cho các ngươi trong suy nghĩ đẹp nhất thanh âm ném bên trên một phiếu đi!",
	--复赛展示
	[tbAct.STATE_TYPE.SEMI_FINAL_REST] = "「Kiếm hiệp tốt thanh âm」Đấu bán kết ( Vượt phục bình chọn ) Từng cái khu vực quán quân cùng áp phái quán quân đã sinh ra, quán quân pho tượng đã ở chủ thành bên trong dựng nên, nhanh đi cúng bái một phen đi!",
	--决赛
	[tbAct.STATE_TYPE.FINAL] = "「Kiếm hiệp tốt thanh âm」Trận chung kết ( Vượt phục bình chọn ) Đang tiến hành bên trong, nhanh đi cho các ngươi trong suy nghĩ đẹp nhất thanh âm ném bên trên một phiếu đi!",
	--决赛展示
	[tbAct.STATE_TYPE.FINAL_REST] = "「Kiếm hiệp tốt thanh âm」Trận chung kết ( Vượt phục bình chọn ) Trước mười đã sinh ra, ba vị trí đầu pho tượng đã ở chủ thành Nạp Lan thật chỗ dựng nên, nhanh đi cúng bái một phen đi!",
}

-- 桃花雨
tbAct.szRankGetNextTime = "19:18" 		-- 这个时间点过后算下一天
tbAct.nRankGetNextTime = Lib:HourMinTimeDesc2Second(tbAct.szRankGetNextTime)
tbAct.nRankGet1 = 520 					-- 第一档票数
tbAct.nRankGet2 = 1600 					-- 第二档票数
tbAct.nRankGet3 = 2800 					-- 第三档票数
tbAct.tbRankGet = {tbAct.nRankGet1,tbAct.nRankGet2,tbAct.nRankGet3}
tbAct.tbRankGetCount = {}
tbAct.nRankGetCreateNpcRate = 3 		-- 创建npc数 = 人数*3
for i,v in ipairs(tbAct.tbRankGet) do
	tbAct.tbRankGetCount[v] = i
end
tbAct.tbRankGetNpcInfo = 
{
	[tbAct.nRankGet1] = {tbPos = {
	{4657,3766},
    {4922,5011},
    {5311,3529},
    {5740,3611},
    {4246,4752},
    {4300,4310},
    {4205,3548},
    {5955,4796},
    {6132,4278},
    {6034,3946},
    {4325,5428},
    {4025,5077},
    {5074,5450},
    {5456,5437},
    {5800,5279},
    {3892,4537},
    {3911,4205},
    {4600,4038},
    {4764,4632},
    {5099,4708},
    {5140,3823},
    {3943,3744},
    {4306,3924},
    {5545,3867},
    {5627,4231},
    {4600,5254},
    {4663,5602},
    {5263,5728},
    {4158,5794},
    {3934,5542},
    {5775,5750},
    {3665,3915},
    {3580,4335},
    {3513,4689},
    {3637,3567},
    {4913,3425},
    {6217,3738},
    {6448,4158},
    {5898,4509},
    {5510,4597},
    {5475,4979},
    {4818,5940},
    {6454,4572},
    }};
	[tbAct.nRankGet2] = {tbPos = {
	{4657,3766},
    {4922,5011},
    {5311,3529},
    {5740,3611},
    {4246,4752},
    {4300,4310},
    {4205,3548},
    {5955,4796},
    {6132,4278},
    {6034,3946},
    {4325,5428},
    {4025,5077},
    {5074,5450},
    {5456,5437},
    {5800,5279},
    {3892,4537},
    {3911,4205},
    {4600,4038},
    {4764,4632},
    {5099,4708},
    {5140,3823},
    {3943,3744},
    {4306,3924},
    {5545,3867},
    {5627,4231},
    {4600,5254},
    {4663,5602},
    {5263,5728},
    {4158,5794},
    {3934,5542},
    {5775,5750},
    {3665,3915},
    {3580,4335},
    {3513,4689},
    {3637,3567},
    {4913,3425},
    {6217,3738},
    {6448,4158},
    {5898,4509},
    {5510,4597},
    {5475,4979},
    {4818,5940},
    {6454,4572},
    }};
	[tbAct.nRankGet3] = {tbPos = {
	{4657,3766},
    {4922,5011},
    {5311,3529},
    {5740,3611},
    {4246,4752},
    {4300,4310},
    {4205,3548},
    {5955,4796},
    {6132,4278},
    {6034,3946},
    {4325,5428},
    {4025,5077},
    {5074,5450},
    {5456,5437},
    {5800,5279},
    {3892,4537},
    {3911,4205},
    {4600,4038},
    {4764,4632},
    {5099,4708},
    {5140,3823},
    {3943,3744},
    {4306,3924},
    {5545,3867},
    {5627,4231},
    {4600,5254},
    {4663,5602},
    {5263,5728},
    {4158,5794},
    {3934,5542},
    {5775,5750},
    {3665,3915},
    {3580,4335},
    {3513,4689},
    {3637,3567},
    {4913,3425},
    {6217,3738},
    {6448,4158},
    {5898,4509},
    {5510,4597},
    {5475,4979},
    {4818,5940},
    {6454,4572},
    }};
}
tbAct.nMaxTaoHuaNpcGet = 7 					    -- 最多可捡多少个
tbAct.nRefreshTaoHuaNpcGetTime = "00:00" 		-- 可捡取个数刷新时间
tbAct.nTaoHuaNpcTId = 2944
tbAct.szRankGetNotify = "Mùi thơm toàn thành, ca tận hoa đào, bản phục tốt thanh âm đấu bán kết tuyển thủ thâm thụ yêu thích thu hoạch %s Hoa đào tiên, toàn bộ server rơi ra lãng mạn hoa đào mưa."
tbAct.szRankGetSystem = "Mùi thơm toàn thành, ca tận hoa đào, bản phục tốt thanh âm người chơi <%s> Thâm thụ yêu thích thu hoạch %s Hoa đào tiên, điểm kích nhưng xem xét."
tbAct.nDelayDelayTaoHuaTime = 90 				-- 烤火结束后延迟删除桃花npc时间
tbAct.tbTaoHuaAward = {{"item", 7883, 1}} 		-- 桃花奖励

-- 报名公告
tbAct.tbSignUpMsg = 
{
	[tbAct.STATE_TYPE.LOCAL] = "Bang phái thành viên「%s」Đã báo danh Kiếm hiệp tốt thanh âm Bình chọn hoạt động < Tuyển thủ: %s>";
}

-- 距离间歇期结束多久前自动发结果最新消息
tbAct.tbResultNewInfoAutoSendTime = 
{
	[tbAct.STATE_TYPE.LOCAL_REST] = 15*60;
	[tbAct.STATE_TYPE.SEMI_FINAL_REST] = 15*60;
	[tbAct.STATE_TYPE.FINAL_REST] = 15*60;
}

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then
		ScriptData:SaveValue(self.szScriptDataKey, {})
		local tbData = self:GetActivityData();
		tbData.szFurnitureAwardFrame = Lib:GetMaxTimeFrame(self.tbFurnitureSelectAward)

		-- 预埋记录时间轴信息
		local szCurMainTimeFrame, nCurMainFrameOpenTime = TimeFrame:GetCurMainTimeFrameInfo()
		tbData.szCurMainTimeFrame = szCurMainTimeFrame
		tbData.nCurMainFrameOpenTime = nCurMainFrameOpenTime
		tbData.nActStartTime = GetTime()
		Log("[Info]", "GoodVoice", "Init Set FurnitureAwardFrame", tbData.szFurnitureAwardFrame)

		local nStartTime, nEndTime = self:GetOpenTimeInfo()
		NewInformation:AddInfomation("BeautyReward", nEndTime,
						 {nStartTime, nEndTime},
						 {szTitle="Tốt thanh âm bỏ phiếu thưởng", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 1, szUiName = "BeautyReward", szCheckRpFunc="fnGoodVoiceRewardCheckRp"})

		NewInformation:AddInfomation("GoodVoiceSelection", nEndTime, {szKey = self.szNewInfoFansKey}, {szTitle=self.szNewInfoFansTtile, szUiName = "GoodVoiceSelection"})
	elseif szTrigger == "Start" then
		Activity:RegisterNpcDialog(self, 90, {Text = "Tốt thanh âm giải thi đấu chủ hội trường", Callback = self.TryEnterMain, Param = {self}})
		Activity:RegisterNpcDialog(self, 90, {Text = "Tốt thanh âm báo danh", Callback = self.TrySignUp, Param = {self}})
		Activity:RegisterNpcDialog(self, 90, {Text = "Tốt thanh âm hảo hữu đề cử", Callback = self.TryRecommend, Param = {self}})
		Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin")
		-- 每日礼包不给
		Activity:RegisterPlayerEvent(self, "Act_DailyGift", "OnBuyDailyGift")
		Activity:RegisterPlayerEvent(self, "Act_BuyDaysCard", "OnBuyDaysCard")
		Activity:RegisterPlayerEvent(self, "Act_OnRechargeGold", "OnRechargeGold")
		Activity:RegisterPlayerEvent(self, "Act_OnAddOrgMoney", "OnAddOrgMoney")
		--Activity:RegisterPlayerEvent(self, "Act_OnRandomItemUse", "OnRandomItemUse")
		Activity:RegisterPlayerEvent(self, "Act_SendGoodVoiceChannelMsg", "SendChannelMsg")
		Activity:RegisterGlobalEvent(self, "Act_KinGather_Close", "OnKinGatherStop")
		Activity:RegisterPlayerEvent(self, "Act_EverydayTarget_Award", "OnAddEverydayAward")
		Activity:RegisterPlayerEvent(self, "Act_TryGetTaoHua", "TryGetTaoHua")
		Activity:RegisterPlayerEvent(self, "Act_SendGoodVoiceChannelMsg", "SendChannelMsg")
		Activity:RegisterPlayerEvent(self, "Act_GoodVoiceVotedAwardReq", "OnGoodVoiceVotedAwardReq")
		Activity:RegisterPlayerEvent(self, "Act_GoodVoiceRequestSignUpFriend", "OnRequestSignUpFriend")
		Activity:RegisterPlayerEvent(self, "Act_GoodVoiceRequestUnSignUpFriend", "OnRequestUnSignUpFriend")
		Activity:RegisterPlayerEvent(self, "Act_GoodVoiceRecommendFriend", "OnGoodVoiceRecommendFriend")

		-- 最新消息发送
		Activity:RegisterGlobalEvent(self, "Act_AddLocalResultInfo", "AddLocalResultInfo")
		Activity:RegisterGlobalEvent(self, "Act_AddSemiFinalResultInfo", "AddSemiFinalResultInfo")
		Activity:RegisterGlobalEvent(self, "Act_AddFinalResultInfo", "AddFinalResultInfo")
		Activity:RegisterGlobalEvent(self, "Act_AddSemiFinalAreaResultInfo", "AddSemiFinalAreaResultInfo")
		Activity:RegisterGlobalEvent(self, "Act_AddSemiFinalFactionResultInfo", "AddSemiFinalFactionResultInfo")

		-- 测试
		Activity:RegisterGlobalEvent(self, "Act_OnRankGetResult", "OnRankGetResult")
		Activity:RegisterGlobalEvent(self, "Act_CheckRankGetStart", "CheckRankGetStart")
		Activity:RegisterGlobalEvent(self, "Act_OnSignUp", "OnSignUp")
		Activity:RegisterGlobalEvent(self, "Act_CheckSignUpOverdue", "CheckSignUpOverdue")
		
		Timer:Register(Env.GAME_FPS, self.AddNpcBubbleTalk, self)
		local _, nEndTime = self:GetOpenTimeInfo()
		self:RegisterDataInPlayer(nEndTime)

		local tbPlayer = KPlayer.GetAllPlayer();
		for _, pPlayer in pairs(tbPlayer) do
			if pPlayer.nLevel >= self.LEVEL_LIMIT then
				self:OnLogin(pPlayer)
			end
		end
	elseif szTrigger == "OnWorldNotify" then
		self:OnWorldNotify()
	elseif szTrigger == "CheckSignUpOverdue" then
		self:CheckSignUpOverdue()
	elseif szTrigger == "CheckRankGetStart" then
		self:CheckRankGetStart()
	elseif szTrigger == "CheckLocalResultInfo" then
		local tbInfoData = NewInformation:GetInformation("GoodVoiceAct_LocalResult")
		if not tbInfoData and self:GetCurState() == self.STATE_TYPE.LOCAL_REST and self:GetStateLeftTime() <= self.tbResultNewInfoAutoSendTime[self.STATE_TYPE.LOCAL_REST] then
			-- 如果在间歇期中间时间还没公布结果的最新消息这里直接发
			self:AddLocalResultInfo();
			Log("[GoodVoice] AddLocalResultInfo Auto..")
		end
	elseif szTrigger == "CheckSemiFinalResultInfo" then
		local tbInfoData = NewInformation:GetInformation("GoodVoiceAct_SemiFianlResult")
		if not tbInfoData and self:GetCurState() == self.STATE_TYPE.SEMI_FINAL_REST and self:GetStateLeftTime() <= self.tbResultNewInfoAutoSendTime[self.STATE_TYPE.SEMI_FINAL_REST] then
			-- 如果在间歇期中间时间还没公布结果的最新消息这里直接发
			self:AddSemiFinalResultInfo();
			Log("[GoodVoice] AddSemiFinalResultInfo Auto..")
		end
	elseif szTrigger == "CheckFinalResultInfo" then
		local tbInfoData = NewInformation:GetInformation("GoodVoiceAct_FinalResult")
		if not tbInfoData and self:GetCurState() == self.STATE_TYPE.FINAL_REST and self:GetStateLeftTime() <= self.tbResultNewInfoAutoSendTime[self.STATE_TYPE.FINAL_REST] then
			-- 如果在间歇期中间时间还没公布结果的最新消息这里直接发
			self:AddFinalResultInfo();
			Log("[GoodVoice] AddFinalResultInfo Auto..")
		end
	elseif szTrigger  == "End" then
	end
end

function tbAct:OnGoodVoiceVotedAwardReq(pPlayer, nIndex)
	local tbAward, nCanGet, nGotCount, bIsShow, tbAwardInfo = self:GetVotedAward(pPlayer, nIndex);
	if not tbAward or not nCanGet or nCanGet <= 0 or not bIsShow then
		return
	end
	
	pPlayer.SetUserValue(self.SAVE_GROUP, tbAwardInfo.nSaveKey, nGotCount + nCanGet);
	pPlayer.SendAward({tbAward}, true, true, Env.LogWay_GoodVoice_Vote);

	pPlayer.CallClientScript("Activity.GoodVoice:OnRefreshVotedAward");
end

function tbAct:GetFurnitureAwardFrame()
	local tbData = self:GetActivityData();
	
	return tbData.szFurnitureAwardFrame or "-1"
end

function tbAct:OnLogin(pPlayer)
	self:CheckPlayerData(pPlayer);
	local bIsSignUp, nSignUpTimeOut = self:IsSignUp(pPlayer.dwID);
	if bIsSignUp then
		pPlayer.CallClientScript("Activity.GoodVoice:SyncIsSignUp", nSignUpTimeOut);
	end
	pPlayer.CallClientScript("Activity.GoodVoice:SyncFurnitureAwardFrame", self:GetFurnitureAwardFrame());
end

function tbAct:OnServerStart()
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local tbLocalWinnerList = tbData.tbLocalWinnerList
	local tbSemiFinalWinnerList = tbData.tbSemiFinalWinnerList
	local tbSemiFinalAreaWinnerList = tbData.tbSemiFinalAreaWinnerList
	local tbSemiFinalFactionWinnerList = tbData.tbSemiFinalFactionWinnerList
	local nNow = GetTime()
	--如果有冠军数据立雕像
	for _,tbWinnerInfo in pairs(tbFinalWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList then
			for _, tbStatueInfo in pairs( tbStatueInfoList ) do
				self:AddStatue(tbWinnerInfo, tbStatueInfo)
			end
		end
	end
	-- 本服冠军有过期时间
	for _,tbWinnerInfo in pairs(tbLocalWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nLocalStatueTimeOut > nNow then
			for _, tbStatueInfo in pairs( tbStatueInfoList ) do
				self:AddStatue(tbWinnerInfo, tbStatueInfo)
			end
		end
	end
	-- 复赛冠军有过期时间
	for _,tbWinnerInfo in pairs(tbSemiFinalWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nSemiFinalStatueTimeOut > nNow  then
			for _, tbStatueInfo in pairs( tbStatueInfoList ) do
				self:AddStatue(tbWinnerInfo, tbStatueInfo)
			end
		end
	end
	-- 复赛区域冠军有过期时间
	for _,tbWinnerInfo in pairs(tbSemiFinalAreaWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nSemiFinalStatueTimeOut > nNow   then
			for _, tbStatueInfo in pairs( tbStatueInfoList ) do
				self:AddStatue(tbWinnerInfo, tbStatueInfo)
			end
		end
	end
	-- 复赛门派冠军有过期时间
	for _,tbWinnerInfo in pairs(tbSemiFinalFactionWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nSemiFinalStatueTimeOut > nNow   then
			for _, tbStatueInfo in pairs( tbStatueInfoList ) do
				self:AddStatue(tbWinnerInfo, tbStatueInfo)
			end
		end
	end
end

function tbAct:GetActivityData()
	local tbData = ScriptData:GetValue(self.szScriptDataKey)
	tbData.tbSignList = tbData.tbSignList or {} 												-- 报名玩家列表（每天定时清理过期玩家）
	tbData.tbFinalWinnerList = tbData.tbFinalWinnerList or {} 									-- 决赛排名获奖玩家
	tbData.tbSemiFinalWinnerList = tbData.tbSemiFinalWinnerList or {} 							-- 复赛排名获奖玩家
	tbData.tbLocalWinnerList = tbData.tbLocalWinnerList or {} 									-- 海选排名获奖玩家
	tbData.tbRankGetData = tbData.tbRankGetData or {} 											-- 桃花雨达标玩家（每次触发都会清理过期玩家）
	tbData.tbSemiFinalAreaWinnerList = tbData.tbSemiFinalAreaWinnerList or {} 					-- 复赛区域冠军获奖玩家
	tbData.tbSemiFinalFactionWinnerList = tbData.tbSemiFinalFactionWinnerList or {} 			-- 复赛门派冠军获奖玩家
	return tbData
end

function tbAct:SaveActivityData()
	 ScriptData:AddModifyFlag(self.szScriptDataKey)
end

function tbAct:GetOverdueTime()
	return self.STATE_TIME[self.STATE_TYPE.FINAL_REST][2]
end

function tbAct:OnBuyDailyGift(pPlayer, nGroupIndex, nBuyCount)
	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end
	local nCount = self.DailyGiftVote[nGroupIndex];
	if not nCount or nCount <= 0 then
		Log("[Error]", "GoodVoice", "Wrong Daily Gift Vote Count", pPlayer.dwID, pPlayer.szName, nGroupIndex, nBuyCount);
		return
	end
	local nEndTime = self:GetOverdueTime()
	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount * nBuyCount, nEndTime}}, true, true, Env.LogWay_GoodVoiceRecharge);
end

function tbAct:OnBuyDaysCard(pPlayer, nGroupIndex)
	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end
	local nCount = self.DaysCardVote[nGroupIndex];
	if not nCount or nCount <= 0 then
		Log("[Error]", "GoodVoice", "Wrong Days Card Vote Count", pPlayer.dwID, pPlayer.szName, nGroupIndex);
		return
	end
	local nEndTime = self:GetOverdueTime()
	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount, nEndTime}}, true, true, Env.LogWay_GoodVoiceRecharge);
	Log("[Ok]", "GoodVoice", "OnBuyDaysCard", pPlayer.dwID, pPlayer.szName, nGroupIndex, nCount);
end

function tbAct:OnRechargeGold(pPlayer, nRMB)
	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end
	local nCount = self.tbRechargeGold[nRMB]
	if not nCount or nCount <= 0 then
		Log("[Error]", "GoodVoice", "Wrong Recharge Gold Vote Count", pPlayer.dwID, pPlayer.szName, nRMB);
		return
	end
	local nEndTime = self:GetOverdueTime()
	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount, nEndTime}}, true, true, Env.LogWay_GoodVoiceRecharge);
	Log("[Ok]", "GoodVoice", "fnOnRechargeGold", pPlayer.dwID, pPlayer.szName, nRMB, nState);
end

function tbAct:OnAddOrgMoney(pPlayer, szType, nPoint, nLogReazon, nLogReazon2)
	if szType ~= "SilverBoard" then
		return
	end
	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end
	local nCount = self.tbSilverBoardCount[nPoint]
	if not nCount then
		Log("[Error]", "GoodVoice", "fnOnAddOrgMoney no count", pPlayer.dwID, pPlayer.szName, nPoint, nLogReazon, nLogReazon2);
		return
	end
	local nEndTime = self:GetOverdueTime()
	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount, nEndTime}}, true, true, Env.LogWay_GoodVoiceRecharge);
	Log("[Ok]", "GoodVoice", "fnOnAddOrgMoney", pPlayer.dwID, pPlayer.szName, nCount, szType, nPoint, nLogReazon, nLogReazon2);
end

function tbAct:OnRandomItemUse(pPlayer, nItemTId)
	local nCount = self.tbSilverBoardItem[nItemTId]
	if not nCount then
		Log("[Error]", "GoodVoice", "fnOnRandomItemUse no count", pPlayer.dwID, pPlayer.szName, nItemTId);
		return
	end
	local nEndTime = self:GetOverdueTime()
	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount, nEndTime}}, true, true, Env.LogWay_GoodVoiceRecharge);
	Log("[Ok]", "GoodVoice", "fnOnRandomItemUse", pPlayer.dwID, pPlayer.szName, nItemTId, nCount);
end

function tbAct:OnAddEverydayAward(pPlayer, nAwardIdx)
	--活跃度100才给奖励
	if nAwardIdx ~= 5 then
		return
	end
	if pPlayer.nLevel < self.LEVEL_LIMIT then
		return
	end
	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end
	local nEndTime = self:GetOverdueTime()
	pPlayer.SendAward({{"item", self.VOTE_ITEM, self.nMaxEverydayActiveVote, nEndTime}}, true, true, Env.LogWay_GoodVoiceEveryTarget);
	Log("[Ok]", "GoodVoice", "fnOnAddEverydayAward", pPlayer.dwID, pPlayer.szName, nState);
end

function tbAct:TryEnterMain()
	local bRet, szMsg = self:CheckJoin(me)
	if not bRet then
		me.CenterMsg(szMsg, true)
		return 
	end
	me.CallClientScript("Activity.GoodVoice:MainEnter")
end

function tbAct:TrySignUp()
	local bRet, szMsg = self:CheckJoin(me)
	if not bRet then
		me.CenterMsg(szMsg, true)
		return 
	end
	me.CallClientScript("Activity.GoodVoice:SingUpEnter")
end

function tbAct:TryRecommend()
	local bRet, szMsg = self:CheckJoin(me)
	if not bRet then
		me.CenterMsg(szMsg, true)
		return 
	end
	me.CallClientScript("Activity.GoodVoice:DoRecommend")
end

function tbAct:GetWinnerList(nWinnerType, nRank)
	local nKey
	local tbData = self:GetActivityData();
	local tbWinnerList
	if self:IsFinalRankWinnerType(nWinnerType) then
		tbWinnerList = tbData.tbFinalWinnerList
		nKey = nRank
	elseif self:IsSemiRankFinalWinnerType(nWinnerType) then
		tbWinnerList = tbData.tbSemiFinalWinnerList
		nKey = nRank
	elseif self:IsLocalRankWinnerType(nWinnerType) then
		tbWinnerList = tbData.tbLocalWinnerList
		nKey = nRank
	elseif self:IsSemiFinalAreaWinnerType(nWinnerType) then
		tbWinnerList = tbData.tbSemiFinalAreaWinnerList
		nKey = nWinnerType
	elseif self:IsSemiFinalFactionWinnerType(nWinnerType) then
		tbWinnerList = tbData.tbSemiFinalFactionWinnerList
		nKey = nWinnerType
	end
	return tbWinnerList, nKey
end

function tbAct:UpdateStatueInfo(pPlayer, nWinnerType, nRank)
	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	if not tbStatueInfoList then
		Log("[GoodVoice] UpdateStatueInfo no tbStatueInfoList", pPlayer.dwID, pPlayer.szName, nWinnerType, nRank)
		return
	end

	local tbWinnerList, nKey = self:GetWinnerList(nWinnerType, nRank)
	local tbWinnerInfo = (tbWinnerList or {})[nKey or -1]
	if not tbWinnerInfo then
		Log("[GoodVoice] UpdateStatueInfo no tbWinnerInfo", pPlayer.dwID, pPlayer.szName, nWinnerType, nRank)
		return
	end

	tbWinnerInfo.szPlayerName = pPlayer.szName;
	tbWinnerInfo.nFaction = pPlayer.nFaction
	tbWinnerInfo.nSex = pPlayer.nSex
	local tbEquipInfo = KPlayer.GetInfoFromAsyncData(pPlayer.dwID);

	if tbEquipInfo then
		local tbWeapon = tbEquipInfo[Item.EQUIPPOS_WEAPON]
		local tbArmor = tbEquipInfo[Item.EQUIPPOS_BODY]
		local tbHead = tbEquipInfo[Item.EQUIPPOS_HEAD]

		local tbWaiWeapon = tbEquipInfo[Item.EQUIPPOS_WAI_WEAPON]
		local tbWaiArmor = tbEquipInfo[Item.EQUIPPOS_WAIYI]
		local tbWaiHead = tbEquipInfo[Item.EQUIPPOS_WAI_HEAD]
		local _ , tbPartRes = KPlayer.GetNpcResId(tbWinnerInfo.nFaction, pPlayer.nSex);
		if tbWaiWeapon then
			tbWinnerInfo.nWeaponResId = tbWaiWeapon.nShowResId
		elseif tbWeapon then
			tbWinnerInfo.nWeaponResId = tbWeapon.nShowResId
		else
			tbWinnerInfo.nWeaponResId = tbPartRes[Npc.NpcResPartsDef.npc_part_weapon] or 0
		end
		if tbWaiArmor then
			tbWinnerInfo.nArmorResId = tbWaiArmor.nShowResId
		elseif tbArmor then
			tbWinnerInfo.nArmorResId = tbArmor.nShowResId
		else
			tbWinnerInfo.nArmorResId = tbPartRes[Npc.NpcResPartsDef.npc_part_body] or 0;
		end

		if tbWaiHead then
			tbWinnerInfo.nHeadResId = tbWaiHead.nShowResId
		elseif tbHead then
			tbWinnerInfo.nHeadResId = tbHead.nShowResId
		else
			tbWinnerInfo.nHeadResId = tbPartRes[Npc.NpcResPartsDef.npc_part_head] or 0;
		end
	end

	for _, tbStatueInfo in pairs( tbStatueInfoList ) do
		self:RemoveStatue(tbWinnerInfo, tbStatueInfo)
		self:AddStatue(tbWinnerInfo, tbStatueInfo)
	end
	pPlayer.SendBlackBoardMsg("Thành công đổi mới pho tượng hình tượng");
	Log("[GoodVoice] UpdateStatueInfo ok..", pPlayer.dwID, pPlayer.szName, nWinnerType, nRank, nKey)
end

function tbAct:AddNpcBubbleTalk()
	for nState,tbNpcList in pairs(self.tbNpcBubble) do
		local tbTimeRange = tbAct.STATE_TIME[nState];
		for _,tbInfo in pairs(tbNpcList) do
			NpcBubbleTalk:Add(tbInfo.nMapId, tbInfo.nNpcTemplate,
						tbInfo.szContent,
						 Lib:GetTimeStr4(tbTimeRange[1]),
						 Lib:GetTimeStr4(tbTimeRange[2]),
						 tbInfo.szDateTime[1], tbInfo.szDateTime[2])
		end
	end
end

function tbAct:OnWorldNotify()
	local nState = self:GetCurState();
	local szNotify = self.tbWorldNotify[nState]
	if szNotify then
		KPlayer.SendWorldNotify(self.LEVEL_LIMIT, 1000,
					szNotify,
					ChatMgr.ChannelType.Public, 1);
	end
end

function tbAct:CheckPlayerData(pPlayer)
	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	if pPlayer.GetUserValue(self.SAVE_GROUP, self.VERSION) == nStartTime then
		return
	end
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VERSION, nStartTime)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_COUNT, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_1, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_2, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_3, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_4, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_5, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_6, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_7, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_8, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_9, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_10, 0)
end

function tbAct:AddStatue(tbWinnerInfo, tbStatueInfo)
	local tbPos = tbStatueInfo.pos;

	local pNpc = KNpc.Add(tbStatueInfo.nTemplateId, 1, -1, tbPos[1], tbPos[2], tbPos[3], false, tbStatueInfo.nDir);
	if not pNpc then
		Lib:LogTB(tbWinnerInfo)
		Lib:LogTB(tbStatueInfo)
		Log("[Error]", "GoodVoice", "AddStatue Failed");
		return
	end

	pNpc.tbWinnerInfo = tbWinnerInfo;
	pNpc.tbStatueInfo = tbStatueInfo;

	pNpc.SetName(tbWinnerInfo.szPlayerName);
	pNpc.SetTitleID(tbStatueInfo.nTitleId);

	--[[if not tbWinnerInfo.bNewRes then
		tbWinnerInfo.bNewRes = true
		local tbResReplace = LoadTabFile("Setting/Npc/Res/ReplacePartBody.tab", "ddd", "OldBodyResID", {"OldBodyResID", "NewBodyResID", "NewHeadResID"});
		if tbWinnerInfo.nArmorResId and tbWinnerInfo.nArmorResId > 0 then
			local OldBodyResID = tbWinnerInfo.nArmorResId;
			if tbResReplace[OldBodyResID] then
				tbWinnerInfo.nArmorResId = tbResReplace[OldBodyResID].NewBodyResID;
				tbWinnerInfo.nHeadResId = tbResReplace[OldBodyResID].NewHeadResID;
			else
				tbWinnerInfo.nArmorResId = nil
			end
		end
		self:SaveActivityData()
	end]]

	local nSex = tbWinnerInfo.nSex or Player.SEX_NONE
	if nSex ~= Player.SEX_MALE and nSex ~= Player.SEX_FEMALE then
		nSex = Player:Faction2Sex(tbWinnerInfo.nFaction);
	end
	local nResId , tbPartRes = KPlayer.GetNpcResId(tbWinnerInfo.nFaction, nSex);
	local nBodyResId = tbPartRes[Npc.NpcResPartsDef.npc_part_body] or 0;
	local nWeaponResId = tbPartRes[Npc.NpcResPartsDef.npc_part_weapon] or 0;
	local nHeadResId = tbPartRes[Npc.NpcResPartsDef.npc_part_head] or 0;
	if tbWinnerInfo.nArmorResId and tbWinnerInfo.nArmorResId > 0 then
		nBodyResId = tbWinnerInfo.nArmorResId;
	end

	if tbWinnerInfo.nWeaponResId and tbWinnerInfo.nWeaponResId > 0 then
		nWeaponResId = tbWinnerInfo.nWeaponResId;
	end

	if tbWinnerInfo.nHeadResId and tbWinnerInfo.nHeadResId > 0 then
		nHeadResId = tbWinnerInfo.nHeadResId;
	end

	pNpc.ChangeFeature(nResId, Npc.NpcResPartsDef.npc_part_body, nBodyResId);
	pNpc.ChangeFeature(nResId, Npc.NpcResPartsDef.npc_part_weapon, nWeaponResId);
	pNpc.ChangeFeature(nResId, Npc.NpcResPartsDef.npc_part_head, nHeadResId);
	if tbStatueInfo.nDir then
		pNpc.SetDir(tbStatueInfo.nDir);
	end
end

function tbAct:RemoveStatue(tbWinnerInfo, tbStatueInfo)
	local tbPosInfo = tbStatueInfo.pos;

	local tbNpcList,_ = KNpc.GetMapNpc(tbPosInfo[1])

	for _, pNpc in pairs(tbNpcList) do
		if pNpc.nTemplateId == tbStatueInfo.nTemplateId and 
			pNpc.tbWinnerInfo and pNpc.tbWinnerInfo.nServerId == tbWinnerInfo.nServerId and
			pNpc.tbWinnerInfo.nPlayerId == tbWinnerInfo.nPlayerId and pNpc.tbWinnerInfo.nWinnerType == tbWinnerInfo.nWinnerType then

			pNpc.Delete();
			Log("[GoodVoice] RemoveStatue..", pNpc.nId, pNpc.nTemplateId, pNpc.tbWinnerInfo.nServerId, pNpc.tbWinnerInfo.nPlayerId, pNpc.tbWinnerInfo.nWinnerType)
		end
	end
end

function tbAct:RedBagOnEvent(nPlayerId, nEvent, nCount)
	if nEvent then
		Kin:RedBagOnEvent(nPlayerId, nEvent, nCount)
	end
end

function tbAct:GetRankDes(nWinnerType)
	local szDes = ""
	if nWinnerType == self.WINNER_TYPE.FINAL_1 
		or nWinnerType == self.WINNER_TYPE.SEMI_FINAL_1 
		or nWinnerType == self.WINNER_TYPE.LOCAL_1 then
		szDes = "Quán quân"

	elseif nWinnerType == self.WINNER_TYPE.FINAL_2 
		or nWinnerType == self.WINNER_TYPE.SEMI_FINAL_2 
		or nWinnerType == self.WINNER_TYPE.LOCAL_2 then
		szDes = "Á quân"

	elseif nWinnerType == self.WINNER_TYPE.FINAL_3 
		or nWinnerType == self.WINNER_TYPE.SEMI_FINAL_3 
		or nWinnerType == self.WINNER_TYPE.LOCAL_3 then
		szDes = "Quý quân"
	end
	return szDes
end

function tbAct:GetAreaDes(nWinnerType)
	return self.tbSemiFinalAreaDes[nWinnerType] or {0, "Không biết", "Không biết"}
end

function tbAct:GetFactionDes(nWinnerType)
	return self.tbSemiFinalFactionDes[nWinnerType] or {0, "Không biết", "Không biết"}
end

function tbAct:AddLocalResultInfo()
	local tbData = self:GetActivityData();
	local tbLocalWinnerList = tbData.tbLocalWinnerList
	local  szContent = [[
        「Kiếm hiệp tốt thanh âm Bình chọn」[FFFE0D]Hải tuyển thi đấu ( Bản phục bình chọn )[-] Đã kết thúc, chúc mừng trở xuống thập cường tốt thanh âm tuyển thủ 
		]]

	for nRank,tbWinnerInfo in ipairs(tbLocalWinnerList) do
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[#self.tbWinnerMailInfo]
		local pStayInfo = KPlayer.GetRoleStayInfo(tbWinnerInfo.nPlayerId)
		local pKinData = Kin:GetKinById((pStayInfo and pStayInfo.dwKinId) or 0);
		szContent = string.format("%s\n[FFFE0D]%s[-]Tuyển thủ: [C8FF00]%s[-] Bang phái: [C8FF00]%s[-][00FF00][url=openGoodVoiceUrl:Xem xét tư liệu, 3;%s;%s][-]", szContent, Lib:StrFillL(string.format("Thứ %s Tên", Lib:TransferDigit2CnNum(nRank)), 18, " "), Lib:StrFillL(tbWinnerInfo.szPlayerName, 18, " "), Lib:StrFillL((pKinData and pKinData.szName) or "--", 18, " "), tbWinnerInfo.nPlayerId, pStayInfo.szAccount)
	end

	szContent = string.format("%s\n\n[FFFE0D]「Bản phục đệ nhất tốt thanh âm」[-]Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 12763, 15247][-][00ff00][url=pos:Lâm An thành, 15, 7894, 11271][-]Dựng nên, các vị hiệp sĩ nhanh đi cúng bái đi\n\nChúc mừng [FFFE0D]Trước 5 Tên[-]Đại hiệp hoặc là phiếu vượt qua 10000 Phiếu đại hiệp nhập vây đấu bán kết, đấu bán kết đem với [FFFE0D]%s[-] Bắt đầu.", szContent, Lib:TimeDesc10(self.STATE_TIME[self.STATE_TYPE.SEMI_FINAL][1]))

	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("GoodVoiceAct_LocalResult", nEndTime, {szContent},{szTitle="Bản phục thập đại tốt thanh âm", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 3})	
end

function tbAct:AddSemiFinalResultInfo()
	local tbData = self:GetActivityData();
	local tbSemiFinalWinnerList = tbData.tbSemiFinalWinnerList
	local  szContent = [[
        「Kiếm hiệp tốt thanh âm Bình chọn」[FFFE0D]Đấu bán kết ( Vượt phục bình chọn ) Đã kết thúc [-], chúc mừng nên tốt thanh âm tuyển thủ!
		]]

	for nRank,tbWinnerInfo in ipairs(tbSemiFinalWinnerList) do
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[#self.tbWinnerMailInfo]
		szContent = string.format("%s\n[FFFE0D]%s[-]Tuyển thủ: [C8FF00]%s[-] Đến từ: [C8FF00]%s[-][00FF00][url=openGoodVoiceUrl:Xem xét tư liệu, 3;%s;%s][-]", szContent, Lib:StrFillL(string.format("Thứ %s Tên", Lib:TransferDigit2CnNum(nRank)), 18, " "), Lib:StrFillL(tbWinnerInfo.szPlayerName, 18, " "), Lib:StrFillL(tbWinnerInfo.szServerName, 24, " "), tbWinnerInfo.nPlayerId, tbWinnerInfo.szAccount)
	end

	szContent = string.format("%s\n\n[FFFE0D]「Đấu bán kết đệ nhất tốt thanh âm」[-]Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 12763, 15247][-][00ff00][url=pos:Lâm An thành, 15, 7894, 11271][-]Dựng nên, các vị hiệp sĩ nhanh đi nhanh đi cúng bái đi", szContent)

	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("GoodVoiceAct_SemiFianlResult", nEndTime, {szContent},{szTitle="Đấu bán kết đệ nhất tốt thanh âm", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 4})	
end

function tbAct:AddFinalResultInfo()
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local  szContent = [[
        「Kiếm hiệp tốt thanh âm Bình chọn」[FFFE0D]Trận chung kết ( Vượt phục bình chọn ) Đã kết thúc [-], chúc mừng trở xuống thập cường tuyển thủ!
		]]

	for nRank,tbWinnerInfo in ipairs(tbFinalWinnerList) do
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[#self.tbWinnerMailInfo]
		szContent = string.format("%s\n[FFFE0D]%s[-]Tuyển thủ: [C8FF00]%s[-] Đến từ: [C8FF00]%s[-][00FF00][url=openGoodVoiceUrl:Xem xét tư liệu, 3;%s;%s][-]", szContent, Lib:StrFillL(string.format("Thứ %s Tên", Lib:TransferDigit2CnNum(nRank)), 18, " "), Lib:StrFillL(tbWinnerInfo.szPlayerName, 18, " "), Lib:StrFillL(tbWinnerInfo.szServerName, 24, " "), tbWinnerInfo.nPlayerId, tbWinnerInfo.szAccount)
	end

	szContent = string.format("%s\n\n[FFFE0D]「Võ lâm đệ nhất tốt thanh âm」[-]Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 12763, 15247][-][00ff00][url=pos:Lâm An thành, 15, 7894, 11271][-]Dựng nên, các vị hiệp sĩ nhanh đi cúng bái đi", szContent)

	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("GoodVoiceAct_FinalResult", nEndTime, {szContent},{szTitle="Võ lâm thập đại tốt thanh âm", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 4})	
end

function tbAct:AddSemiFinalAreaResultInfo()
	local tbData = self:GetActivityData();
	local tbSemiFinalAreaWinnerList = tbData.tbSemiFinalAreaWinnerList
	local  szContent = [[
        「Kiếm hiệp tốt thanh âm Bình chọn」[FFFE0D]Đấu bán kết khu vực ( Vượt phục bình chọn ) Đã kết thúc [-], chúc mừng trở xuống tuyển thủ!
		]]

	for nWinnerType,tbWinnerInfo in pairs(tbSemiFinalAreaWinnerList) do
		local nRank, szRankDes =  unpack(self:GetAreaDes(nWinnerType))
		if nRank == 1 then

			local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[#self.tbWinnerMailInfo]
			szContent = string.format("%s\n[FFFE0D]%s[-]Tuyển thủ: [C8FF00]%s[-] Đến từ: [C8FF00]%s[-][00FF00][url=openGoodVoiceUrl:Xem xét tư liệu, 3;%s;%s][-]", szContent, Lib:StrFillL(string.format("%s", szRankDes or "Quán quân"), 18, " "), Lib:StrFillL(tbWinnerInfo.szPlayerName, 18, " "), Lib:StrFillL(tbWinnerInfo.szServerName, 24, " "), tbWinnerInfo.nPlayerId, tbWinnerInfo.szAccount)
		end
	end

	szContent = string.format("%s\n\n[FFFE0D]「Võ lâm khu vực mạnh nhất âm thanh」[-]Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 11611, 17263][-][00ff00][url=pos:Lâm An thành, 15, 8645, 15120][-]Dựng nên, các vị hiệp sĩ nhanh đi cúng bái đi", szContent)

	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("GoodVoiceAct_SemiFinalAreaResult", nEndTime, {szContent},{szTitle="Võ lâm khu vực tốt thanh âm", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 4})	
end

function tbAct:AddSemiFinalFactionResultInfo()
	local tbData = self:GetActivityData();
	local tbSemiFinalFactionWinnerList = tbData.tbSemiFinalFactionWinnerList
	local  szContent = [[
        「Kiếm hiệp tốt thanh âm Bình chọn」[FFFE0D]Phục Simon phái ( Vượt phục bình chọn ) Đã kết thúc [-], chúc mừng trở xuống tuyển thủ!
		]]

	for nWinnerType, tbWinnerInfo in pairs(tbSemiFinalFactionWinnerList) do
		local nRank, szFactionDes =  unpack(self:GetFactionDes(nWinnerType))
		if nRank == 1 then
			local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[#self.tbWinnerMailInfo]
			szContent = string.format("%s\n[FFFE0D]%s[-]Tuyển thủ: [C8FF00]%s[-] Đến từ: [C8FF00]%s[-][00FF00][url=openGoodVoiceUrl:Xem xét tư liệu, 3;%s;%s][-]", szContent, Lib:StrFillL(string.format("%s", szFactionDes or "Quán quân"), 18, " "), Lib:StrFillL(tbWinnerInfo.szPlayerName, 18, " "), Lib:StrFillL(tbWinnerInfo.szServerName, 24, " "), tbWinnerInfo.nPlayerId, tbWinnerInfo.szAccount)
		end
	end

	szContent = string.format("%s\n\n[FFFE0D]「Môn phái võ lâm mạnh nhất âm thanh」[-]Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 9303, 15341][-][00ff00][url=pos:Lâm An thành, 15, 8465, 12909][-]Dựng nên, các vị hiệp sĩ nhanh đi cúng bái đi", szContent)

	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("GoodVoiceAct_SemiFinalFactionResult", nEndTime, {szContent},{szTitle="Môn phái võ lâm tốt thanh âm", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 4})	
end

-- >>>桃花雨
-- 玩家在某个阶段达到某个票数（桃花雨）
function tbAct:OnRankGetResult(nPlayerId, nRankGet)
	local nCurState = self:GetCurState()
	if nCurState ~= tbAct.STATE_TYPE.SEMI_FINAL then
		Log("[Warning]", "GoodVoice", "OnRankGetResult", "no current state", nCurState, nPlayerId, nRankGet)
		return 
	end
	if not self.tbRankGetCount[nRankGet] then
		Log("[Warning]", "GoodVoice", "OnRankGetResult", "no current rank", nCurState, nPlayerId, nRankGet)
		return 
	end
	local pStayInfo = KPlayer.GetRoleStayInfo(nPlayerId)
	if not pStayInfo then
		Log("[Warning]", "GoodVoice", "OnRankGetResult", "no pStayInfo", nCurState, nPlayerId, nRankGet)
		return 
	end
	local tbData = self:GetActivityData();
	local tbRankGetData = tbData.tbRankGetData
	local nToday = Lib:GetLocalDay()
	local tbTime = Lib:LocalDate("*t", GetTime());
	if tbTime.hour * 3600 + tbTime.min * 60 + tbTime.sec > self.nRankGetNextTime then
		nToday = nToday + 1
	end
	tbRankGetData[nToday] = tbRankGetData[nToday] or {}
	tbRankGetData[nToday][nRankGet] = tbRankGetData[nToday][nRankGet] or {}
	if self:CheckRankGetPlayerRepeat(tbRankGetData[nToday][nRankGet], nPlayerId) then
		Log("[GoodVoice] OnRankGetResult repeat", nPlayerId, nRankGet, nToday)
	else
		table.insert(tbRankGetData[nToday][nRankGet], {nPlayerId = nPlayerId})
		self:SaveActivityData()
		Log("[GoodVoice] OnRankGetResult ok", nPlayerId, nRankGet, nToday)
	end
end

function tbAct:CheckRankGetPlayerRepeat(tbPlayer, dwID)
	local bRepeat = false
	for _,v in pairs(tbPlayer or {}) do
		if v.nPlayerId == dwID then
			bRepeat = true
			break
		end
	end
	return bRepeat
end

-- 检查过期桃花雨数据
function tbAct:CheckRankGetOverdue()
	local tbData = self:GetActivityData();
	local tbRankGetData = tbData.tbRankGetData
	local nToday = Lib:GetLocalDay()
	for nDay, v in pairs(tbRankGetData) do
		if nDay < nToday then
			tbRankGetData[nDay] = nil
			Log("[GoodVoice] fnCheckRankGetOverdue Clear ", nDay, nToday)
		end
	end
end

-- 检查触发桃花雨
function tbAct:CheckRankGetStart()
	self:CheckRankGetOverdue()
	local nCurState = self:GetCurState()
	if nCurState ~= tbAct.STATE_TYPE.SEMI_FINAL then
		return
	end
	local nToday = Lib:GetLocalDay()
	local tbData = self:GetActivityData();
	local tbRankGetData = tbData.tbRankGetData
	local tbTodayRankGetData = tbRankGetData[nToday] or {}
	local nRankGetStart
	for _, nRankGet in ipairs(self.tbRankGet) do
		local tbRankGetPlayer = tbTodayRankGetData[nRankGet] or {}
		if next(tbRankGetPlayer) then
			nRankGetStart = nRankGet
			break
		end
	end

	if nRankGetStart then
		self:DoAddRankGetNpc(nRankGetStart)
		local tbPlayer = tbTodayRankGetData[nRankGetStart]
		tbTodayRankGetData[nRankGetStart] = nil
		self:SaveActivityData()
		local tbMsgPlayer = {}
		for i,v in ipairs(tbPlayer) do
			local nPlayerId = v.nPlayerId or 0
			local pStayInfo = KPlayer.GetPlayerObjById(nPlayerId) or KPlayer.GetRoleStayInfo(nPlayerId)
			local szName = pStayInfo and pStayInfo.szName
			if szName then
				table.insert(tbMsgPlayer, {nPlayerId, szName})
			else
				Log("[GoodVoice] fnDoRankGetStart No pStayInfo", nToday, nPlayerId)
			end
		end
		local szWorldNotify = string.format(self.szRankGetNotify, nRankGetStart)
		KPlayer.SendWorldNotify(self.LEVEL_LIMIT, 1000,
					szWorldNotify,
					ChatMgr.SystemMsgType.System, 1);
		for _, v in ipairs(tbMsgPlayer) do
			local nPlayerId = v[1]
			local szPlayerName = v[2]
			local pStayInfo = KPlayer.GetPlayerObjById(nPlayerId) or KPlayer.GetRoleStayInfo(nPlayerId)
			local tbLinkData = {nLinkType = ChatMgr.LinkType.HyperText, linkParam = {szHyperText = string.format(self:GetPlayerPage(nPlayerId, pStayInfo.szAccount))}}
			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.System, string.format(self.szRankGetSystem, szPlayerName, nRankGetStart), 0, tbLinkData)
		end
		
		local szLog = self:GetRankGetPlayerLog(tbPlayer)
		Log("[GoodVoice] fnDoRankGetStart ok", nRankGetStart, szLog, nToday)
	else
		Log("[GoodVoice] fnDoRankGetStart No RankGet Player", nToday)
	end
end

function tbAct:GetRankGetPlayerLog(tbPlayer)
	local tbPlayerId = {}
	for _,v in pairs(tbPlayer or {}) do
		table.insert(tbPlayerId, v.nPlayerId or 0)
	end
	local szLog = table.concat(tbPlayerId, ";")
	return szLog
end

function tbAct:DoAddRankGetNpc(nRankGet)
	local tbNpcInfo = self.tbRankGetNpcInfo[nRankGet]
	if not tbNpcInfo then
		Log("[GoodVoice] fnDoAddRankGetNpc No tbNpcInfo", nRankGet)
		return 
	end
	self.tbTaoHuaNpc = self.tbTaoHuaNpc or {}
	 Kin:TraverseKinInDiffTime(1, function (kinData)
        self:CreateRankGetNpc(kinData.nKinId, tbNpcInfo)
    end);
	 Log("[GoodVoice] fnDoAddRankGetNpc ok", nRankGet)
end

function tbAct:CreateRankGetNpc(nKinId, tbNpcInfo)
    local kinData = Kin:GetKinById(nKinId)
    if not kinData then
    	Log("GatherBox fnCreateRankGetNpc fail no KinData", nKinId)
        return
    end
    local nMapId = kinData:GetMapId()
    if not nMapId then
    	Log("GatherBox fnCreateRankGetNpc fail no MapId", nKinId)
        return
    end
     local tbPlayer, nPlayerCount = KPlayer.GetMapPlayer(nMapId)
    local nCreateNpcCount = nPlayerCount * self.nRankGetCreateNpcRate
    local tbAllPos = tbNpcInfo.tbPos or {}
    if nCreateNpcCount <= 0 or not next(tbAllPos) then
    	Log("GatherBox fnCreateRankGetNpc fail no count", nKinId, nMapId, nPlayerCount)
    	return
    end
    local fnSelect = Lib:GetRandomSelect(#tbAllPos)
    for i = 1, nCreateNpcCount do
        local tbPos = tbAllPos[fnSelect()]
        local nX, nY = unpack(tbPos)
        local pNpc = KNpc.Add(self.nTaoHuaNpcTId, 1, 0, nMapId, nX, nY)
        table.insert(self.tbTaoHuaNpc, pNpc.nId)
    end
    Log("GatherBox fnCreateRankGetNpc", nKinId, nCreateNpcCount, nPlayerCount)
end

function tbAct:CheckGetTaoHua(pPlayer, pNpc)
	local bRet, szMsg = pPlayer.CheckNeedArrangeBag()
    if bRet then
        return false, szMsg
    end
    local tbTaoHuaData = self:GetPlayerTaoHuaSaveData(pPlayer)
    if tbTaoHuaData.nGetTaoHuaCount >= self.nMaxTaoHuaNpcGet then
    	return false, "Hôm nay đã không thể lại nhặt"
    end
    return true, "", tbTaoHuaData
end

function tbAct:TryGetTaoHua(pPlayer, pNpc)
	 local bRet, szMsg = self:CheckGetTaoHua(pPlayer, pNpc)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end
    GeneralProcess:StartProcess(pPlayer, Env.GAME_FPS, "Nhặt lấy trúng", self.DoGetTaoHua, self, pPlayer.dwID, pNpc.nId)
end

function tbAct:DoGetTaoHua(dwID, nNpcId)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
    local pNpc    = KNpc.GetById(nNpcId)
    if not pPlayer then
        return
    end

    if not pNpc or pNpc.IsDelayDelete() then
        pPlayer:CenterMsg("Đã bị những người khác vượt lên trước mở ra rồi")
        return
    end
    local bRet, szMsg, tbTaoHuaData = self:CheckGetTaoHua(pPlayer, pNpc)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        return
    end
    tbTaoHuaData.nGetTaoHuaCount = tbTaoHuaData.nGetTaoHuaCount + 1
    local tbData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbData.tbTaoHuaData = tbTaoHuaData
    self:SaveDataToPlayer(pPlayer, tbData)
    pPlayer.SendAward(self.tbTaoHuaAward, false, true, Env.LogWay_GoodVoice_TaoHuaRain)
    pNpc.Delete()
end

function tbAct:OnKinGatherStop()
	self.tbTaoHuaNpc = self.tbTaoHuaNpc or {}
    Timer:Register(Env.GAME_FPS + Env.GAME_FPS * self.nDelayDelayTaoHuaTime, self.ClearTaoHuaNpc, self)
end

function tbAct:ClearTaoHuaNpc()
    if #self.tbTaoHuaNpc == 0 then
        return
    end
    for _, nId in ipairs(self.tbTaoHuaNpc) do
        local pNpc = KNpc.GetById(nId)
        if pNpc then
            pNpc.Delete()
        end
    end
    self.tbTaoHuaNpc = {}
    Log("GatherBox fnClearTaoHuaNpc ok")
end

function tbAct:GetPlayerTaoHuaSaveData(pPlayer)
	local tbData = self:GetDataFromPlayer(pPlayer.dwID) or {}
	tbData.tbTaoHuaData = tbData.tbTaoHuaData or {}
	local tbTaoHuaData = tbData.tbTaoHuaData
	local nGetTaoHuaDay = tbTaoHuaData.nGetTaoHuaDay or 0
	local nGetTaoHuaCount = tbTaoHuaData.nGetTaoHuaCount or 0
	local nToday = Lib:GetLocalDay()
	if nToday ~= nGetTaoHuaDay then
		tbData.tbTaoHuaData.nGetTaoHuaDay = nToday
		tbData.tbTaoHuaData.nGetTaoHuaCount = 0
		self:SaveDataToPlayer(pPlayer, tbData)
	end
	return tbData.tbTaoHuaData
end


-->>>报名
function tbAct:OnSignUp(nStateType, nPlayerId)
	local nValidTime = self.STATE_TIME[nStateType] and self.STATE_TIME[nStateType][2]
	if not nValidTime then
		Log("[Error]", "GoodVoice", "fnOnSignUp valid nStateType", nPlayerId, nStateType);
		return
	end
	local pStayInfo = KPlayer.GetRoleStayInfo(nPlayerId)
	if not pStayInfo then
		Log("[Error]", "GoodVoice", "fnOnSignUp valid nPlayerId", nPlayerId, nStateType);
		return
	end
	-- 潘多拉有可能会多次上报，以第一次上报为准
	local bHadSignUp, nTime = self:IsSignUp(nPlayerId)
	if bHadSignUp then
		Log("[Warnning]", "GoodVoice", "fnOnSignUp repeat signup", nPlayerId, nStateType);
		return
	end

	local tbData = self:GetActivityData();
	--有效时间到比赛结束时间
	tbData.tbSignList[nPlayerId] = nValidTime
	self:SaveActivityData();
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if pPlayer then
		pPlayer.CallClientScript("Activity.GoodVoice:SyncIsSignUp", tbData.tbSignList[nPlayerId]);
		local dwKinId = pPlayer.dwKinId
		if dwKinId > 0 then
			local szMsg = self.tbSignUpMsg[nStateType]
			if szMsg then
				local szName = pPlayer.szName
				local tbLinkData = {nLinkType = ChatMgr.LinkType.HyperText, linkParam={szHyperText = string.format(self:GetPlayerPage(pPlayer.dwID,pPlayer.szAccount))}}
				ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin,
					string.format(XT(szMsg),
						szName, szName),
						dwKinId, tbLinkData);
			end
		end
	end
	self:SendSignUpItem(nPlayerId, nStateType, pStayInfo.szAccount)
	Log("[GoodVoice] fnOnSignUp ok", nPlayerId, nStateType, pPlayer and 1 or 0)
end

function tbAct:SendSignUpItem(nPlayerId, nType, szAccount)
	local tbMailInfo = tbAct.tbSignUpMail[nType]
	if not tbMailInfo then
		Log("[Error]", "GoodVoice", "SendSignUpItem No Mail Info", nPlayerId, nType);
		return
	end
	local tbMail = Lib:CopyTB(tbMailInfo)
	if not next(tbMail) then
		Log("[Error]", "GoodVoice", "SendSignUpItem No Mail Template", nPlayerId, nType);
		return
	end
	tbMail.To = nPlayerId;
	tbMail.Text = string.format(tbMail.Text, nPlayerId, szAccount)

	Mail:SendSystemMail(tbMail);
end

function tbAct:IsSignUp(nPlayerId)
	local tbData = self:GetActivityData();
	local nSignUpTimeOut = tbData.tbSignList[nPlayerId];
	return nSignUpTimeOut ~= nil and GetTime() < nSignUpTimeOut, nSignUpTimeOut
end

-- 清理无效的报名数据
function tbAct:CheckSignUpOverdue()
	local nNowTime = GetTime()
	local tbData = self:GetActivityData();
	local bAlter
	for dwID, nSignUpTimeOut in pairs(tbData.tbSignList) do
		if nSignUpTimeOut < nNowTime then
			bAlter = true
			tbData.tbSignList[dwID] = nil
		end
	end
	if bAlter then
		self:SaveActivityData()
	end
end

function tbAct:OnRequestSignUpFriend(pPlayer)
	local tbList = {}
	local tbAllFriends, _ = KFriendShip.GetFriendList(pPlayer.dwID);
	for nPlayerId, nImity in pairs(tbAllFriends) do
		if self:IsSignUp(nPlayerId) then
			local pStayInfo = KPlayer.GetPlayerObjById(nPlayerId) or KPlayer.GetRoleStayInfo(nPlayerId)
			if pStayInfo then
				table.insert(tbList, {nPlayerId, pStayInfo.szAccount});
			end
		end
	end
	if Lib:CountTB(tbList) > 0 then
		pPlayer.CallClientScript("Activity.GoodVoice:SyncSignUpFriendList", tbList);
	end
end

function tbAct:OnRequestUnSignUpFriend(pPlayer)
	local tbList = {}
	local tbAllFriends, _ = KFriendShip.GetFriendList(pPlayer.dwID);
	local tbRecommendData = self:GetPlayerRecommendData(pPlayer)
	for nPlayerId, nImity in pairs(tbAllFriends) do
		if not tbRecommendData.tbPlayer[nPlayerId] and not self:IsSignUp(nPlayerId) then
			table.insert(tbList, nPlayerId);
		end
	end
	if Lib:CountTB(tbList) > 0 then
		pPlayer.CallClientScript("Activity.GoodVoice:SyncUnSignUpFriendList", tbList);
	end
end

-- 返回推荐数据
function tbAct:GetPlayerRecommendData(pPlayer)
	local tbData = self:GetDataFromPlayer(pPlayer.dwID) or {}
	tbData.tbRecommendData = tbData.tbRecommendData or {}
	local tbRecommendData = tbData.tbRecommendData
	tbRecommendData.nRecommendDay = tbRecommendData.nRecommendDay or 0
	tbRecommendData.tbPlayer = tbRecommendData.tbPlayer or {}
	local nToday = Lib:GetLocalDay()
	if nToday ~= tbRecommendData.nRecommendDay then
		tbData.tbRecommendData.nRecommendDay = nToday
		tbData.tbRecommendData.tbPlayer = {}
		self:SaveDataToPlayer(pPlayer, tbData)
	end
	return tbData.tbRecommendData, tbData
end

function tbAct:OnGoodVoiceRecommendFriend(pPlayer, nPlayerId)
	local tbRecommendData, tbData = self:GetPlayerRecommendData(pPlayer)
	if tbRecommendData.tbPlayer[nPlayerId] then
		pPlayer:CenterMsg("Ngươi hôm nay đã đề cử qua nên bạn tốt", true)
		return 
	end
	local tbMail = 
	{
		To = nPlayerId,
		Title = "Tốt thanh âm hảo hữu đề cử",
		Text =string.format("Ngài hảo hữu[FFFE0D]「%s」[-]Đề cử ngài báo danh Kiếm hiệp tốt thanh âm, nhanh đi mở ra giọng hát đi [FFFE0D]%s[-].", pPlayer.szName, self:GetSignUpPage("Báo danh liên kết")),
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoiceCommond,
	}
	Mail:SendSystemMail(tbMail);
	tbData.tbRecommendData.tbPlayer[nPlayerId] = true
	self:SaveDataToPlayer(pPlayer, tbData)
	pPlayer.CenterMsg("Đã hướng đối phương gửi đi thư đề cử", true)
end

function tbAct:SendChannelMsg(pPlayer, nType, nParam)
	if not self:IsSignUp(pPlayer.dwID) then
		return
	end

	if not nType then
		return
	end

	if nType ~= tbAct.MSG_CHANNEL_TYPE.NORMAL and 
		nType ~= tbAct.MSG_CHANNEL_TYPE.FACTION and
		nType ~= tbAct.MSG_CHANNEL_TYPE.PRIVATE then

		return
	end

	local szMsg, tbLinkData = self:GetSendMsg(pPlayer)

	if nType == tbAct.MSG_CHANNEL_TYPE.NORMAL then
		local nChannel = nParam or 0;
		if not tbAct.AVAILABLE_CHANNEL[nChannel] then
			return
		end

		if nChannel == ChatMgr.ChannelType.Public then
			if not ChatMgr:ReducePublicChatCount(pPlayer, 1) then
				return
			end
		end

		ChatMgr:SendPlayerMsg(nChannel, pPlayer.dwID, pPlayer.szName,
						 pPlayer.nFaction, pPlayer.nPortrait, pPlayer.nSex,
						 pPlayer.nLevel, szMsg, tbLinkData)

	elseif nType == tbAct.MSG_CHANNEL_TYPE.FACTION then
		local nChannel = Faction.tbChatChannel[pPlayer.nFaction]
		if not nChannel then
			return
		end

		ChatMgr:SendPlayerMsg(nChannel, pPlayer.dwID, pPlayer.szName,
						 pPlayer.nFaction, pPlayer.nPortrait, pPlayer.nSex,
						 pPlayer.nLevel, szMsg, tbLinkData)

	elseif nType == tbAct.MSG_CHANNEL_TYPE.PRIVATE then
		local nToRoleId = nParam or 0

		local pToStayInfo = KPlayer.GetRoleStayInfo(nToRoleId)
		if not pToStayInfo then
			return
		end

		SendPrivateMsg(pPlayer.dwID, nToRoleId, szMsg, tbLinkData)
	end
end

-- 是否是决赛冠军类型
function tbAct:IsFinalRankWinnerType(nWinnerType)
	if self.WINNER_TYPE.FINAL_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.FINAL_10 then
		return true
	end
	return false
end

-- 是否是复赛冠军类型
function tbAct:IsSemiRankFinalWinnerType(nWinnerType)
	if self.WINNER_TYPE.SEMI_FINAL_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_10 then
		return true
	end
	return false
end

-- 是否是本服冠军类型
function tbAct:IsLocalRankWinnerType(nWinnerType)
	if self.WINNER_TYPE.LOCAL_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.LOCAL_10 then
		return true
	end
	return false
end

-- 是否是区域类型
function tbAct:IsSemiFinalAreaWinnerType(nWinnerType)
	if self.WINNER_TYPE.SEMI_FINAL_AREA_1_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_AREA_8_1 or 
		self.WINNER_TYPE.SEMI_FINAL_AREA_1_2 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_AREA_8_2 or 
		self.WINNER_TYPE.SEMI_FINAL_AREA_1_3 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_AREA_8_3 then
		return true
	end
	return false
end

-- 是否是区域冠军类型
function tbAct:IsSemiFinalAreaWinnerChampionType(nWinnerType)
	if self.WINNER_TYPE.SEMI_FINAL_AREA_1_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_AREA_8_1 then
		return true
	end
	return false
end

-- 是否是门派类型
function tbAct:IsSemiFinalFactionWinnerType(nWinnerType)
	if self.WINNER_TYPE.SEMI_FINAL_FACTION_1_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_FACTION_16_1 or 
		self.WINNER_TYPE.SEMI_FINAL_FACTION_1_2 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_FACTION_16_2 or 
		self.WINNER_TYPE.SEMI_FINAL_FACTION_1_3 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_FACTION_16_3 then
		return true
	end
	return false
end

-- 是否是门派冠军类型
function tbAct:IsSemiFinalFactionWinnerChampionType(nWinnerType)
	if self.WINNER_TYPE.SEMI_FINAL_FACTION_1_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.SEMI_FINAL_FACTION_16_1 then
		return true
	end
	return false
end

-- >>>>发奖
function tbAct:OnWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)

	if self:IsFinalRankWinnerType(nWinnerType) then

		self:_OnFinalWinnerResult(nWinnerType, nServerId,
				 szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)

	elseif self:IsSemiRankFinalWinnerType(nWinnerType) then

		self:_OnSemiFinalWinnerResult(nWinnerType, nServerId,
				 szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)

	elseif self:IsLocalRankWinnerType(nWinnerType) then

		self:_OnLocalWinnerResult(nWinnerType, nServerId,
				 szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)

	elseif nWinnerType == self.WINNER_TYPE.PARTICIPATE then

		self:_OnParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName,
				 nFaction, nArmorResId, nWeaponResId, szAccount)

	elseif nWinnerType == self.WINNER_TYPE.SEMI_FINAL_PARTICIPATE then

		self:_OnSemiFinalParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName,
				 nFaction, nArmorResId, nWeaponResId, szAccount)

	elseif nWinnerType == self.WINNER_TYPE.FINAL_PARTICIPATE then

		self:_OnFinalParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName,
				 nFaction, nArmorResId, nWeaponResId, szAccount)

	elseif self:IsSemiFinalAreaWinnerType(nWinnerType) then

		self:_OnSemiFinalAreaWinnerResult(nWinnerType, nServerId,
				 szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
	elseif self:IsSemiFinalFactionWinnerType(nWinnerType) then

		self:_OnSemiFinalFactionWinnerResult(nWinnerType, nServerId,
				 szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)

	elseif nWinnerType == self.WINNER_TYPE.TEAM_LGX then
		self:_OnTeamLGXWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName,
				 nFaction, nArmorResId, nWeaponResId, szAccount)
	elseif nWinnerType == self.WINNER_TYPE.TEAM_ZLY then
		self:_OnTeamZLYWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName,
				 nFaction, nArmorResId, nWeaponResId, szAccount)
	else
		Log("[Error]", "GoodVoice", "OnWinnerResult", "vaild winner type", nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nSex)
	end
end

function tbAct:OnSendVoteRankResult(nPlayerId, nRank)
	local pStayInfo = KPlayer.GetRoleStayInfo(nPlayerId)
	if not pStayInfo then
		Log("[Error]", "GoodVoice", "OnWinnerResult", "vaild nPlayerId", nPlayerId, nRank)
		return
	end
	local tbRankAward = self.tbVoteRankAward[nRank]
	if not tbRankAward then
		Log("[Error]", "GoodVoice", "OnWinnerResult", "vaild tbRankAward", nPlayerId, nRank)
		return
	end
	local tbMail = 
	{
		To = nPlayerId,
		Title = "Tốt thanh âm bỏ phiếu bảng",
		Text = string.format("Cảm tạ đại hiệp đối bản giới tốt thanh âm ủng hộ, ngươi tại bỏ phiếu bảng cuối cùng xếp hạng vì Thứ %s Tên, tốt thanh âm đại hội vì đáp tạ ngươi, đặc biệt vì ngươi chuẩn bị trở xuống lễ vật.", nRank),
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoiceVoteRank,
		tbAttach = tbRankAward,
	}
	Mail:SendSystemMail(tbMail);
end

-- 决赛结果
function tbAct:_OnFinalWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
	local nRank = nWinnerType - self.WINNER_TYPE.FINAL_1 + 1; 			-- 排名
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local bAwarded = false;
	local tbOldWinnerInfo = tbFinalWinnerList[nRank]
	if tbOldWinnerInfo then
		bAwarded = tbOldWinnerInfo.bAwarded
		Lib:LogTB(tbOldWinnerInfo);
		Log("[Warning]", "GoodVoice", "_OnFinalWinnerResult", "Over Write Cur Data", nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded), szAccount, nHeadResId, nSex)
	end

	tbFinalWinnerList[nRank] = 
	{
		nWinnerType = nWinnerType,
		nRank = nRank,
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
		nTime = GetTime(),
		szAccount = szAccount,
		nHeadResId = nHeadResId,
		nSex = nSex,
	}

	local nThisServerId = GetServerIdentity()

	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	local nStatusTemplate
	if tbStatueInfoList then
		for _, tbStatueInfo in pairs( tbStatueInfoList ) do
			nStatusTemplate = tbStatueInfo.nTemplateId
			if tbOldWinnerInfo then
				self:RemoveStatue(tbOldWinnerInfo, tbStatueInfo)
			end
			self:AddStatue(tbFinalWinnerList[nRank], tbStatueInfo)
		end
	end

	if nThisServerId == nServerId and not bAwarded then
		if nWinnerType == self.WINNER_TYPE.FINAL_1 then
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_final_1)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_final_1)
		else
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_final_10)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_final_10)
		end
		local tbAward = self.tbFinalWinnerAward[nRank] or self.tbFinalWinnerAward[#self.tbFinalWinnerAward]
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[#self.tbWinnerMailInfo]
		if tbAward then
			local tbMail = 
			{
				To = nPlayerId,
				Title = string.format("Tốt thanh âm trận chung kết %s", tbMailInfo.szName),
				Text = string.format("    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D]Thứ %s Tên[-]\n    Chúc mừng đại hiệp! Ngươi tiếng trời đạt được võ lâm tán thành, bị bình chọn vì[FF69B4]「Võ lâm %s Tốt thanh âm」[-]%s\n    [FFFE0D]Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.[-]\n    [00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl:Xem xét ta giao diện, 3;%s;%s][-]", "Trận chung kết ( Vượt phục bình chọn )", 
							Lib:Transfer4LenDigit2CnNum(nRank), tbMailInfo.szTitle,
							nStatusTemplate and string.format(", Ngươi Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 12763, 15247][-][00ff00][url=pos:Lâm An thành, 15, 7894, 11271][-]Dựng nên, lấy cung cấp người khác cúng bái.", nStatusTemplate) or ".",
							nPlayerId, szAccount),
				From = "「Tranh tài người chủ trì」Nạp Lan Chân",
				nLogReazon = Env.LogWay_GoodVoice_Winner,
				tbAttach = tbAward,
			}

			Mail:SendSystemMail(tbMail);
			tbFinalWinnerList[nRank].bAwarded = true;
		else
			Log("[Error]", "GoodVoice", "_OnFinalWinnerResult", "Not Award", nRank, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
		end

		-- 决赛前三甲玩家所在服给全服玩家发奖励
		local tbGlobalAward = self.tbFinalRankGlobalAward[nWinnerType]
		if tbGlobalAward then
			local tbMail = {};
		    tbMail.Title = "Tốt thanh âm có phúc cùng hưởng";
		    tbMail.Text = string.format("Chúc mừng bản phục[FFFE0D]%s[-]Thu được tốt thanh âm tổng quyết tái %s, ở đây ta vì mọi người đưa lên tinh mỹ quà tặng một phần lấy đó chúc mừng.\n    [00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]", szPlayerName or "-", self:GetRankDes(nWinnerType),
		    	nPlayerId, szAccount);
		    tbMail.From = "「Tranh tài người chủ trì」Nạp Lan Chân";
		    tbMail.nLogReazon = Env.LogWay_GoodVoice_RankGlobal;
		    tbMail.tbAttach = tbGlobalAward;
		    Mail:SendGlobalSystemMail(tbMail);
		end
	end
	
	self:SaveActivityData();

	local nWinnerCount = Lib:CountTB(tbFinalWinnerList)
	--如果名单齐了发最新消息
	if nWinnerCount >= 10 then
		self:AddFinalResultInfo()
		Log("[GoodVoice] Final Winner >>")
		Lib:LogTB(tbFinalWinnerList)
	end
	Log("[Log]", "GoodVoice", "_OnFinalWinnerResult", "Ok", tostring(bAwarded), nWinnerCount, nRank, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
end

-- 复赛区域冠军结果
function tbAct:_OnSemiFinalAreaWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
	local tbData = self:GetActivityData();
	local tbSemiFinalAreaWinnerList = tbData.tbSemiFinalAreaWinnerList
	local bAwarded = false;
	local tbOldWinnerInfo = tbSemiFinalAreaWinnerList[nWinnerType]
	if tbOldWinnerInfo then
		bAwarded = tbOldWinnerInfo.bAwarded
		Lib:LogTB(tbOldWinnerInfo);
		Log("[Warning]", "GoodVoice", "_OnSemiFinalAreaWinnerResult", "Over Write Cur Data", nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded), szAccount, nHeadResId, nSex)
	end
	local nRank, szRankDes, szTitleDes =  unpack(self:GetAreaDes(nWinnerType))
	tbSemiFinalAreaWinnerList[nWinnerType] = 
	{
		nRank = nRank or 0,
		nWinnerType = nWinnerType,
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
		nTime = GetTime(),
		szAccount = szAccount,
		nHeadResId = nHeadResId,
		nSex = nSex,
	}

	local nThisServerId = GetServerIdentity()

	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	local nStatusTemplate
	if tbStatueInfoList then
		for _, tbStatueInfo in pairs( tbStatueInfoList ) do
			nStatusTemplate = tbStatueInfo.nTemplateId
			if tbOldWinnerInfo then
				self:RemoveStatue(tbOldWinnerInfo, tbStatueInfo)
			end
			self:AddStatue(tbSemiFinalAreaWinnerList[nWinnerType], tbStatueInfo)
		end
	end

	if nThisServerId == nServerId and not bAwarded then
		if self:IsSemiFinalAreaWinnerChampionType(nWinnerType) then
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_SemiFinalArea)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_SemiFinalArea)
		else
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_SemiFinalArea_normal)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_SemiFinalArea_normal)
		end
		
		local tbAward = self.tbSemiFinalAreaAward[nWinnerType]
		if tbAward then
			local tbMail = 
			{
				To = nPlayerId,
				Title = string.format("Tốt thanh âm %s", szRankDes or ""),
				Text = string.format("    Ngươi tại đấu bán kết ( Địa vực vượt phục bình chọn ) Cuối cùng xếp hạng: [FFFE0D]%s[-]\n    Chúc mừng đại hiệp! Ngươi tiếng trời đạt được võ lâm tán thành, bị bình chọn vì[FF69B4]「%s」[-]%s\n    [FFFE0D]Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.\n    [-][00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl:Xem xét ta giao diện, 3;%s;%s][-]", 
							szRankDes or "", szTitleDes or "", nStatusTemplate and string.format(", Ngươi Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 11611, 17263][-][00ff00][url=pos:Lâm An thành, 15, 8645, 15120][-]Dựng nên, lấy cung cấp người khác cúng bái.", nStatusTemplate) or "。",
							nPlayerId, szAccount),
				From = "「Tranh tài người chủ trì」Nạp Lan Chân",
				nLogReazon = Env.LogWay_GoodVoice_SemiFinalArea,
				tbAttach = tbAward,
			}

			Mail:SendSystemMail(tbMail);
			tbSemiFinalAreaWinnerList[nWinnerType].bAwarded = true;
		else
			Log("[Error]", "GoodVoice", "_OnSemiFinalAreaWinnerResult", "Not Award", nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
		end

	end
	
	self:SaveActivityData();
	local nCount = self:CheckAddSemiFinalAreaFactionResultInfo(tbSemiFinalAreaWinnerList)
	--如果名单齐了发最新消息
	if nCount >= self.nSemiFinalAreaChampionCount then
		self:AddSemiFinalAreaResultInfo()
		Log("[GoodVoice] SemiFinal Area Winner >>")
		Lib:LogTB(tbSemiFinalAreaWinnerList)
	end
	Log("[Log]", "GoodVoice", "_OnSemiFinalAreaWinnerResult", "Ok", tostring(bAwarded), nRank, nCount, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
end

function tbAct:CheckAddSemiFinalAreaFactionResultInfo(tbSemiFinalAreaWinnerList)
	local nCount = 0
	for _,v in pairs(tbSemiFinalAreaWinnerList) do
		if v.nRank == 1 then
			nCount = nCount + 1
		end
	end
	return nCount
end

-- 复赛门派冠军结果
function tbAct:_OnSemiFinalFactionWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
	local tbData = self:GetActivityData();
	local tbSemiFinalFactionWinnerList = tbData.tbSemiFinalFactionWinnerList
	local bAwarded = false;
	local tbOldWinnerInfo = tbSemiFinalFactionWinnerList[nWinnerType]
	if tbOldWinnerInfo then
		bAwarded = tbOldWinnerInfo.bAwarded
		Lib:LogTB(tbOldWinnerInfo);
		Log("[Warning]", "GoodVoice", "_OnSemiFinalFactionWinnerResult", "Over Write Cur Data", nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded), szAccount, nHeadResId, nSex)
	end
	local nRank, szRankDes, szTitleDes = unpack(self:GetFactionDes(nWinnerType))
	tbSemiFinalFactionWinnerList[nWinnerType] = 
	{
		nRank = nRank or 0,
		nWinnerType = nWinnerType,
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
		nTime = GetTime(),
		szAccount = szAccount,
		nHeadResId = nHeadResId,
		nSex = nSex,
	}

	local nThisServerId = GetServerIdentity()

	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	local nStatusTemplate
	if tbStatueInfoList then
		for _, tbStatueInfo in pairs( tbStatueInfoList ) do
			nStatusTemplate = tbStatueInfo.nTemplateId
			if tbOldWinnerInfo then
				self:RemoveStatue(tbOldWinnerInfo, tbStatueInfo)
			end
			self:AddStatue(tbSemiFinalFactionWinnerList[nWinnerType], tbStatueInfo)
		end
	end

	if nThisServerId == nServerId and not bAwarded then
		if self:IsSemiFinalFactionWinnerChampionType(nWinnerType) then
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_SemiFinalFaction)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_SemiFinalFaction)
		else
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_SemiFinalFaction_normal)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_SemiFinalFaction_normal)
		end
		
		local tbAward = self.tbSemiFinalFactionAward[nWinnerType]
		if tbAward then
			local tbMail = 
			{
				To = nPlayerId,
				Title = string.format("Tốt thanh âm %s", szRankDes or ""),
				Text = string.format("    Ngươi tại đấu bán kết ( Môn phái vượt phục bình chọn ) Cuối cùng xếp hạng: [FFFE0D]%s[-]\n    Chúc mừng đại hiệp! Ngươi tiếng trời đạt được võ lâm tán thành, bị bình chọn vì[FF69B4]「%s」[-]%s\n    [FFFE0D]Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.\n    [-][00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl:Xem xét ta giao diện, 3;%s;%s][-]", 
							szRankDes or "", szTitleDes or "", nStatusTemplate and string.format(", Ngươi Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 9303, 15341][-][00ff00][url=pos:Lâm An thành, 15, 8465, 12909][-]Dựng nên, lấy cung cấp người khác cúng bái.", nStatusTemplate) or "。",
							nPlayerId, szAccount),
				From = "「Tranh tài người chủ trì」Nạp Lan Chân",
				nLogReazon = Env.LogWay_GoodVoice_SemiFinalFaction,
				tbAttach = tbAward,
			}

			Mail:SendSystemMail(tbMail);
			tbSemiFinalFactionWinnerList[nWinnerType].bAwarded = true;
		else
			Log("[Error]", "GoodVoice", "_OnSemiFinalFactionWinnerResult", "Not Award", nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
		end

	end
	
	self:SaveActivityData();
	local nCount = self:CheckAddSemiFinalAreaFactionResultInfo(tbSemiFinalFactionWinnerList)
	--如果名单齐了发最新消息
	if nCount >= self.nSemiFinalFactionChampionCount then
		self:AddSemiFinalFactionResultInfo()
		Log("[GoodVoice] SemiFinal Faction Winner >>")
		Lib:LogTB(tbSemiFinalFactionWinnerList)
	end
	Log("[Log]", "GoodVoice", "_OnSemiFinalFactionWinnerResult", "Ok", tostring(bAwarded), nRank, nCount, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
end

-- 复赛结果
function tbAct:_OnSemiFinalWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
	local nRank = nWinnerType - self.WINNER_TYPE.SEMI_FINAL_1 + 1; 			-- 排名
	local tbData = self:GetActivityData();
	local tbSemiFinalWinnerList = tbData.tbSemiFinalWinnerList
	local bAwarded = false;
	local tbOldWinnerInfo = tbSemiFinalWinnerList[nRank]
	if tbOldWinnerInfo then
		bAwarded = tbOldWinnerInfo.bAwarded
		Lib:LogTB(tbOldWinnerInfo);
		Log("[Warning]", "GoodVoice", "_OnSemiFinalWinnerResult", "Over Write Cur Data", nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded), szAccount, nHeadResId, nSex)
	end

	tbSemiFinalWinnerList[nRank] = 
	{
		nWinnerType = nWinnerType,
		nRank = nRank,
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
		nTime = GetTime(),
		szAccount = szAccount,
		nHeadResId = nHeadResId,
		nSex = nSex,
	}

	local nThisServerId = GetServerIdentity()

	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	local nStatusTemplate
	if tbStatueInfoList then
		for _, tbStatueInfo in pairs( tbStatueInfoList ) do
			nStatusTemplate = tbStatueInfo.nTemplateId
			if tbOldWinnerInfo then
				self:RemoveStatue(tbOldWinnerInfo, tbStatueInfo)
			end
			self:AddStatue(tbSemiFinalWinnerList[nRank], tbStatueInfo)
		end
	end

	if nThisServerId == nServerId and not bAwarded then
		if nWinnerType == self.WINNER_TYPE.SEMI_FINAL_1 then
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_SemiFinal_1)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_SemiFinal_1)
		else
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_SemiFinal_10)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_SemiFinal_10)
		end
		local tbAward = self.tbSemiFinalWinnerAward[nRank] or self.tbSemiFinalWinnerAward[#self.tbSemiFinalWinnerAward]
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[#self.tbWinnerMailInfo]
		if tbAward then
			local tbMail = 
			{
				To = nPlayerId,
				Title = string.format("Tốt thanh âm đấu bán kết %s", tbMailInfo.szName),
				Text = string.format("    Ngươi tại %s Cuối cùng xếp hạng:[FFFE0D]Thứ %s Tên[-]\n    Chúc mừng đại hiệp! Ngươi tiếng trời đạt được võ lâm tán thành, bị bình chọn vì[FF69B4]「Đấu bán kết %s Tốt thanh âm」[-]%s\n    [FFFE0D]Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.\n    [-][00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl:Xem xét ta giao diện, 3;%s;%s][-]\n", "Tốt thanh âm đấu bán kết ( Vượt phục bình chọn )", 
							Lib:Transfer4LenDigit2CnNum(nRank), tbMailInfo.szTitle,
							nStatusTemplate and string.format(", Ngươi Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 12763, 15247][-][00ff00][url=pos:Lâm An thành, 15, 7894, 11271][-]Dựng nên, lấy cung cấp người khác cúng bái.", nStatusTemplate) or "。",
							nPlayerId, szAccount),
				From = "「Tranh tài người chủ trì」Nạp Lan Chân",
				nLogReazon = Env.LogWay_GoodVoice_Winner,
				tbAttach = tbAward,
			}

			Mail:SendSystemMail(tbMail);
			tbSemiFinalWinnerList[nRank].bAwarded = true;
		else
			Log("[Error]", "GoodVoice", "_OnSemiFinalWinnerResult", "Not Award", nRank, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
		end
	end
	
	self:SaveActivityData();
	local nWinnerCount = Lib:CountTB(tbSemiFinalWinnerList)
	--如果名单齐了发最新消息
	if nWinnerCount >= 10 then
		self:AddSemiFinalResultInfo()
		Log("[GoodVoice] SemiFinal Winner >>")
		Lib:LogTB(tbSemiFinalWinnerList)
	end
	Log("[Log]", "GoodVoice", "_OnSemiFinalWinnerResult", "Ok", tostring(bAwarded), nWinnerCount, nRank, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
end

function tbAct:_OnLocalWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "GoodVoice", "_OnLocalWinnerResult", "Not This Server", nThisServerId, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
		return
	end

	local nRank = nWinnerType - self.WINNER_TYPE.LOCAL_1 + 1;
	local tbData = self:GetActivityData();
	local tbLocalWinnerList = tbData.tbLocalWinnerList
	local bAwarded = false;
	local tbOldWinnerInfo = tbLocalWinnerList[nRank]

	if tbOldWinnerInfo then
		bAwarded = tbOldWinnerInfo.bAwarded
		Lib:LogTB(tbOldWinnerInfo);
		Log("[Warning]", "GoodVoice", "_OnLocalWinnerResult", "Over Write Cur Data", nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded), szAccount, nHeadResId, nSex)
	end

	tbLocalWinnerList[nRank] =
	{
		nWinnerType = nWinnerType,
		nRank = nRank,
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
		nTime = GetTime(),
		szAccount = szAccount,
		nHeadResId = nHeadResId,
		nSex = nSex,
	}
	local szAccount = ""

	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	local nStatusTemplate
	if tbStatueInfoList then
		for _, tbStatueInfo in pairs( tbStatueInfoList ) do
			nStatusTemplate = tbStatueInfo.nTemplateId
			if tbOldWinnerInfo then
				self:RemoveStatue(tbOldWinnerInfo, tbStatueInfo)
			end
			self:AddStatue(tbLocalWinnerList[nRank], tbStatueInfo)
		end
	end

	-- --前3名进入决赛
	-- if nRank <= 3 then
	-- 	local tbData = self:GetActivityData();
	-- 	--有效时间到决赛比赛结束时间
	-- 	tbData.tbSignList[nPlayerId] = self.STATE_TIME[self.STATE_TYPE.FINAL][2]
	-- 	self:SaveActivityData();
	-- 	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	-- 	if pPlayer then
	-- 		pPlayer.CallClientScript("Activity.BeautyPageant:SyncIsSignUp", tbData.tbSignList[nPlayerId]);
	-- 	end
	-- 	self:SendSignUpItem(nPlayerId, self.STATE_TYPE.FINAL)
	-- end

	if not bAwarded then
		if nWinnerType == self.WINNER_TYPE.LOCAL_1 then
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_hx_1)
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_hx_1)
		else
			self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_hx_10)
		end

		local tbAward = self.tbLocalWinnerAward[nRank] or self.tbLocalWinnerAward[#self.tbLocalWinnerAward]
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[#self.tbWinnerMailInfo]
		if tbAward then
			local tbMail = 
			{
				To = nPlayerId,
				Title = string.format("Tốt thanh âm hải tuyển thi đấu %s", tbMailInfo.szName),
				Text = string.format("    Ngươi tại %s Cuối cùng xếp hạng:[FFFE0D]Thứ %s Tên[-]\n    Chúc mừng đại hiệp! Ngươi tiếng trời đạt được võ lâm tán thành, bị bình chọn vì[FF69B4]「Bản phục %s Tốt thanh âm」[-]%s\n\n    [00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl:Xem xét ta giao diện, 3;%s;%s][-]", "Hải tuyển thi đấu ( Bản phục bình chọn )", 
							Lib:Transfer4LenDigit2CnNum(nRank), tbMailInfo.szTitle,
							nStatusTemplate and string.format(", Ngươi Pho tượng đã ở [00ff00][url=pos:Tương Dương thành, 10, 12763, 15247][-][00ff00][url=pos:Lâm An thành, 15, 7894, 11271][-]Dựng nên, lấy cung cấp người khác cúng bái.", nStatusTemplate) or "。",
							nPlayerId, szAccount),
				From = "「Tranh tài người chủ trì」Nạp Lan Chân",
				nLogReazon = Env.LogWay_GoodVoice_Winner,
				tbAttach = tbAward,
			}

			Mail:SendSystemMail(tbMail);

			tbLocalWinnerList[nRank].bAwarded = true;
		else
			Log("[Error]", "GoodVoice", "_OnLocalWinnerResult", "Not Award", nRank, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nSex)
		end
	end

	self:SaveActivityData();

	--如果名单齐了发最新消息
	local nWinnerCount = Lib:CountTB(tbLocalWinnerList)
	if nWinnerCount >= 10 then
		self:AddLocalResultInfo()
		Log("[GoodVoice] Local Winner >>")
		Lib:LogTB(tbLocalWinnerList)
	end
	Log("[Log]", "GoodVoice", "_OnLocalWinnerResult", "Ok", tostring(bAwarded), nWinnerCount, nRank, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount, nHeadResId, nSex)
end

-- 参与奖玩家数据不存盘
function tbAct:_OnParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "GoodVoice", "_OnParticipateWinnerResult", "Not This Server", nThisServerId, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
		return
	end

	local tbMail = 
	{
		To = nPlayerId,
		Title = "Tốt thanh âm lấy được ném 199 Phiếu ban thưởng",
		Text = string.format("    Ngươi tại hải tuyển thi đấu ( Bản phục bình chọn ) Đến số phiếu vượt qua [FFFE0D]199[-]\n    Chúc mừng đại hiệp! Ngươi tại hải tuyển thi đấu bên trong nhận lấy đông đảo hiệp sĩ hâm mộ, tốt thanh âm đại hội riêng ngươi chuẩn bị một chút ban thưởng, mời kiểm tra và nhận phụ kiện.\n    [FFFE0D]Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.[-]\n    [00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl:Xem xét ta giao diện, 3;%s;%s][-]",
			nPlayerId, szAccount),
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoice_Winner,
		tbAttach = self.tbParticipateAward,
	}

	Mail:SendSystemMail(tbMail);

	self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_hx_vote, 199)
	Log("[Log]", "GoodVoice", "_OnParticipateWinnerResult", "Ok", nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
end

function tbAct:_OnFinalParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "GoodVoice", "_OnFinalParticipateWinnerResult", "Not This Server", nThisServerId, nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
		return
	end
	local tbMail = 
	{
		To = nPlayerId,
		Title = "Tốt thanh âm trận chung kết tham dự ban thưởng",
		Text = string.format("    Tốt thanh âm đại hội cho tất cả tiến vào trận chung kết người chơi đưa tặng ban thưởng, vô luận kết cục thành bại, các ngươi đều là nhất bổng! Bên thắng không kiêu kẻ bại không nỗi, lần tiếp theo tiếp tục cố lên!\n    [00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl:Xem xét ta giao diện, 3;%s;%s][-]",
			nPlayerId, szAccount),
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoice_Winner,
		tbAttach = self.tbFinalParticipateAward,
	}

	Mail:SendSystemMail(tbMail);

	self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_final_vote, 8000)
	self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_final_vote, 8000)

	Log("[Log]", "GoodVoice", "_OnFinalParticipateWinnerResult", "Ok", nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
end

function tbAct:_OnSemiFinalParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "GoodVoice", "_OnSemiFinalParticipateWinnerResult", "Not This Server", nThisServerId, nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
		return
	end
	local tbMail = 
	{
		To = nPlayerId,
		Title = "Tốt thanh âm lấy được ném 8000 Phiếu ban thưởng",
		Text = string.format("    Ngươi tại đấu bán kết ( Vượt phục bình chọn ) Đến số phiếu vượt qua [FFFE0D]8000[-]\n    Chúc mừng đại hiệp! Ngươi tại đấu bán kết bên trong nhận lấy đông đảo hiệp sĩ hâm mộ, tốt thanh âm đại hội riêng ngươi chuẩn bị một chút ban thưởng, mời kiểm tra và nhận phụ kiện.\n    [FFFE0D]Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.[-]\n    [00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]\n    [url=openGoodVoiceUrl:Xem xét ta giao diện, 3;%s;%s][-]",
			nPlayerId, szAccount),
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoice_Winner,
		tbAttach = self.tbSemiParticipateAward,
	}

	Mail:SendSystemMail(tbMail);
	self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_SemiFinal_vote, 8000)
	self:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.GoodVoice_g_SemiFinal_vote, 8000)

	Log("[Log]", "GoodVoice", "_OnSemiFinalParticipateWinnerResult", "Ok", nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
end

function tbAct:_OnTeamLGXWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "GoodVoice", "_OnTeamLGXWinnerResult", "Not This Server", nThisServerId, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
		return
	end

	local tbMail = 
	{
		To = nPlayerId,
		Title = "Dương đại hiệp chiến đội ban thưởng",
		Text = string.format("    Thật đáng mừng![FFFE0D] Dương đại hiệp chiến đội học viên [-] Thu được cuối cùng quán quân. Bởi vậy chiến đội bên trong tất cả mọi người thu hoạch được ban thưởng một phần.\n    [00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]",
			nPlayerId, szAccount),
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoiceLGX,
		tbAttach = self.tbTeamLGXAward,
	}

	Mail:SendSystemMail(tbMail);
	Log("[Log]", "GoodVoice", "_OnTeamLGXWinnerResult", "Ok", nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
end

function tbAct:_OnTeamZLYWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "GoodVoice", "_OnTeamZLYWinnerResult", "Not This Server", nThisServerId, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
		return
	end

	local tbMail = 
	{
		To = nPlayerId,
		Title = "Chân nhi chiến đội ban thưởng",
		Text = string.format("    Thật đáng mừng![FFFE0D] Chân nhi chiến đội học viên [-] Thu được cuối cùng quán quân. Bởi vậy chiến đội bên trong tất cả mọi người thu hoạch được ban thưởng một phần.\n    [00FF00][url=openGoodVoiceUrl:Xem xét bình chọn kết quả,1]",
			nPlayerId, szAccount),
		From = "「Tranh tài người chủ trì」Nạp Lan Chân",
		nLogReazon = Env.LogWay_GoodVoiceZLY,
		tbAttach = self.tbTeamZLYAward,
	}

	Mail:SendSystemMail(tbMail);
	Log("[Log]", "GoodVoice", "_OnTeamZLYWinnerResult", "Ok", nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, szAccount)
end

function tbAct:AddVoteCount(pPlayer, nCount)
	self:CheckPlayerData(pPlayer);
	local nCurCount = pPlayer.GetUserValue(self.SAVE_GROUP, self.VOTE_COUNT)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_COUNT, nCurCount + nCount)
	pPlayer.CallClientScript("Activity.GoodVoice:OnRefreshVotedAward");
end

function tbAct:OnEnterMap(pPlayer, nMapTemplateId, nMapId)
	if nMapTemplateId ~= 10 and nMapTemplateId ~= 15 then
		return
	end
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local tbLocalWinnerList = tbData.tbLocalWinnerList
	local tbSemiFinalWinnerList = tbData.tbSemiFinalWinnerList
	local tbSemiFinalAreaWinnerList = tbData.tbSemiFinalAreaWinnerList
	local tbSemiFinalFactionWinnerList = tbData.tbSemiFinalFactionWinnerList
	local bRankStatue = false
	local bAreaStatue = false
	local bFactionStatue = false
	local nNow = GetTime()
	--如果有冠军数据立雕像
	for _,tbWinnerInfo in pairs(tbFinalWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList then
			bRankStatue = true
			break
		end
	end
	-- 本服冠军有过期时间
	for _,tbWinnerInfo in pairs(tbLocalWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nLocalStatueTimeOut > nNow then
			bRankStatue = true
			break
		end
	end
	-- 复赛冠军有过期时间
	for _,tbWinnerInfo in pairs(tbSemiFinalWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nSemiFinalStatueTimeOut > nNow  then
			bRankStatue = true
			break
		end
	end
	-- 复赛区域冠军有过期时间
	for _,tbWinnerInfo in pairs(tbSemiFinalAreaWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nSemiFinalStatueTimeOut > nNow   then
			bAreaStatue = true
			break
		end
	end
	-- 复赛门派冠军有过期时间
	for _,tbWinnerInfo in pairs(tbSemiFinalFactionWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType] or {}
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nSemiFinalStatueTimeOut > nNow   then
			bFactionStatue = true
			break
		end
	end

	if bRankStatue or bAreaStatue or bFactionStatue then
		pPlayer.CallClientScript("Activity.GoodVoice:OnSynMiniMainMapInfo", bRankStatue, bAreaStatue, bFactionStatue)
	end
end