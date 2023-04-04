
local tbFubenSetting = {};
Fuben:SetFubenSetting(151, tbFubenSetting)		-- 绑定副本内容和地图

tbFubenSetting.szFubenClass 			= "PersonalFubenBase";									-- 副本类型
tbFubenSetting.szName 					= "Hồn Trung Nghĩa"											-- 单纯的名字，后台输出或统计使用
tbFubenSetting.szNpcPointFile 			= "Setting/Fuben/PersonalFuben/WLDS/NpcPos500-2.tab"			-- NPC点
--tbFubenSetting.szNpcExtAwardPath 		= "Setting/Fuben/PersonalFuben/1_1/ExtNpcAwardInfo.tab"	-- 掉落表
tbFubenSetting.szPathFile 				= "Setting/Fuben/PersonalFuben/WLDS/NpcPath500-2.tab"		    -- 寻路点
tbFubenSetting.tbBeginPoint 			= {2376, 6158}											-- 副本出生点
tbFubenSetting.nStartDir				= 24;



-- ID可以随便 普通副本NPC数量 ；精英模式NPC数量

tbFubenSetting.ANIMATION = 
{
	[1] = "Scenes/camera/fb_canghai02/canghai02_cam1.controller",
	--场景对象：baishuisi_cam1；动画名：baishuisi_cam1；特效：9221
}

--NPC模版ID，NPC等级，NPC五行；


tbFubenSetting.NPC = 
{
	[1] = {nTemplate = 2734,			nLevel = -1,	nSeries = 0},  --金兵
	[2] = {nTemplate = 2735,			nLevel = -1,	nSeries = 0},  --十夫长
	[3] = {nTemplate = 2736,			nLevel = -1,	nSeries = 0},  --刺客
	[4] = {nTemplate = 2737,			nLevel = -1,	nSeries = 0},  --刺客头目
	[5] = {nTemplate = 2738,			nLevel = -1,	nSeries = 0},  --宋朝降卒
	[6] = {nTemplate = 2739,			nLevel = -1,	nSeries = 0},  --boss

	[7] = {nTemplate = 2740,			nLevel = -1,	nSeries = 0},  --虞允文棺椁
	[8] = {nTemplate = 2741,			nLevel = -1,	nSeries = 0},  --霜儿
	[9] = {nTemplate = 2742,			nLevel = -1,	nSeries = 0},  --武林人士1
	[10] = {nTemplate = 2743,			nLevel = -1,	nSeries = 0},  --武林人士2
	[11] = {nTemplate = 2744,			nLevel = -1,	nSeries = 0},  --宋兵

	[20] = {nTemplate = 2731,			nLevel = -1,	nSeries = 0},  --传送门
	[21] = {nTemplate = 104,			nLevel = -1,	nSeries = 0},  --动态障碍墙
}


--是否允许同伴出战
tbFubenSetting.bForbidPartner = true;
tbFubenSetting.bForbidHelper = true;

tbFubenSetting.LOCK = 
{
	-- 1号锁不能不填，默认1号为起始锁，nTime是到时间自动解锁，nNum表示需要解锁的次数，如填3表示需要被解锁3次才算真正解锁，可以配置字符串
	[1] = {nTime = 0, nNum = 1,
		--tbPrelock 前置锁，激活锁的必要条件{1 , 2, {3, 4}}，代表1和2号必须解锁，3和4任意解锁一个即可
		tbPrelock = {},
		--tbStartEvent 锁激活时的事件
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 1, 1144, false},	--剧情1

			{"AddNpc", 7, 1, 100, "npc", "npc", false, 32, 0, 0, 0},
			{"AddNpc", 8, 1, 101, "npc1", "npc1", false, 32, 0, 0, 0},
			{"AddNpc", 9, 1, 0, "npc2", "npc2", false, 32, 0, 0, 0},
			{"AddNpc", 10, 1, 0, "npc3", "npc3", false, 32, 0, 0, 0},
			{"AddNpc", 11, 1, 0, "npc4", "npc4", false, 32, 0, 0, 0},
			{"AddNpc", 11, 1, 0, "npc5", "npc5", false, 32, 0, 0, 0},
		},
		--tbStartEvent 锁解开时的事件
		tbUnLockEvent = 
		{
			{"ChangeFightState", 1},
			{"RaiseEvent", "ChangeAutoFight", false},
		},
	},
	[2] = {nTime = 1800, nNum = 0,
		tbPrelock = {1},
		tbStartEvent = 
		{
			{"SetShowTime", 2},
		},
		tbUnLockEvent = 
		{
			{"GameLost"},
		},
	},
	-----------------npc死亡失败------------------
	[100] = {nTime = 0, nNum = 1,
		tbPrelock = {1},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"BlackMsg", "Quan Tài Ngu Doãn Văn bị hủy hoại, hộ tống thất bại!"},
			{"PlayerBubbleTalk", "Người Kim đã hủy mất quan tài của thừa tướng, chúng ta rút lui thôi!"},
		},
	},
	[101] = {nTime = 0, nNum = 1,
		tbPrelock = {1},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"BlackMsg", "Sương Nhi bị trọng thương, hộ tống thất bại!"},
			{"PlayerBubbleTalk", "Sương Nhi sao rồi? Xem ra Sương Nhi đã bị thương, chúng ta rút lui thôi!"},
		},
	},
	[102] = {nTime = 3, nNum = 0,
		tbPrelock = {{100, 101}},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"GameLost"},
		},
	},
	---------------------npc死亡失败--------------------
	[3] = {nTime = 0, nNum = 1,
		tbPrelock = {1},
		tbStartEvent = 
		{
			{"BlackMsg", "Đến gặp Sương Nhi"},
			{"TrapUnlock", "trap1", 3},	
			{"SetTargetPos", 2584, 5333},
		},
		tbUnLockEvent = 
		{
			{"ClearTargetPos"},
			{"PlayerBubbleTalk", "Sương Nhi, ta đến rồi!"},
		},
	},
	[4] = {nTime = 0, nNum = 1,
		tbPrelock = {3},
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 4, 1145, false},	--剧情2
		},
		tbUnLockEvent = 
		{
		},
	},
	[5] = {nTime = 0, nNum = 2,
		tbPrelock = {4},
		tbStartEvent = 
		{
			{"ChangeNpcAi", "npc", "Move", "xunlu-1", 5, 0, 0, 0, 0},
			{"ChangeNpcAi", "npc1", "Move", "xunlu1-1", 5, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc2", "Move", "xunlu2-1", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc3", "Move", "xunlu3-1", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc4", "Move", "xunlu4-1", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc5", "Move", "xunlu5-1", 0, 1, 1, 0, 0},

			{"BlackMsg", "Cùng Sương Nhi hộ tống quan tài thừa tướng"},
			{"NpcBubbleTalk", "npc1", "Xuất phát nào!", 2, 0, 2},
		},
		tbUnLockEvent = 
		{
		},
	},
	[6] = {nTime = 0, nNum = 13,
		tbPrelock = {5},
		tbStartEvent = 
		{
			{"AddNpc", 1, 12, 6, "gw", "guaiwu1", false, 0, 0.5, 9005, 0.5},
			{"AddNpc", 2, 1, 6, "sl", "shouling1", false, 0, 0.5, 9005, 0.5},
			{"NpcBubbleTalk", "gw", "Các huynh đệ xông lên!", 4, 1.1, 2},
			{"NpcBubbleTalk", "sl", "Hi hi, đừng hòng đi qua đây!", 4, 1.1, 1},
			{"BlackMsg", "Diệt Kim Binh chặn đường!"},

			{"NpcBubbleTalk", "npc3", "Bình tĩnh!", 3, 1, 1},
			{"NpcBubbleTalk", "npc4", "Kim Binh đang bao vây!", 3, 1, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[7] = {nTime = 4, nNum = 0,
		tbPrelock = {6},
		tbStartEvent = 
		{
			{"PlayerBubbleTalk", "Xem ra người Kim đã phát hiện hành tung của chúng ta!"},
			{"NpcBubbleTalk", "npc1", "Con đường phía trước rất nguy hiểm, mọi người cẩn thận!", 3, 0.5, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[8] = {nTime = 0, nNum = 2,
		tbPrelock = {7},
		tbStartEvent = 
		{
			{"ChangeNpcAi", "npc", "Move", "xunlu-2", 8, 0, 0, 0, 0},
			{"ChangeNpcAi", "npc1", "Move", "xunlu1-2", 8, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc2", "Move", "xunlu2-2", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc3", "Move", "xunlu3-2", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc4", "Move", "xunlu4-2", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc5", "Move", "xunlu5-2", 0, 1, 1, 0, 0},

			{"BlackMsg", "Tiếp tục"},
			{"NpcBubbleTalk", "npc1", "Chúng ta tiếp tục lên đường nào!", 3, 0, 1},
			{"NpcBubbleTalk", "npc2", "Được!", 3, 1.5, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[9] = {nTime = 0, nNum = 11,
		tbPrelock = {8},
		tbStartEvent = 
		{
			{"NpcBubbleTalk", "npc1", "Có mai phục!", 3, 0, 1},

			{"AddNpc", 3, 10, 9, "gw", "guaiwu2", false, 0, 0, 0, 0},
			{"AddNpc", 4, 1, 9, "sl", "shouling2", false, 0, 0, 0, 0},
			{"NpcBubbleTalk", "gw", "Tự sa vào rọ!", 4, 2, 2},
			{"NpcBubbleTalk", "sl", "Trứng mà dám chọi với đá à!", 4, 2, 1},
			{"BlackMsg", "Diệt thích khách mai phục!"},
		},
		tbUnLockEvent = 
		{
		},
	},
	[10] = {nTime = 3, nNum = 0,
		tbPrelock = {9},
		tbStartEvent = 
		{
			{"NpcBubbleTalk", "npc1", "Ngông cuồng! Tiếp tục tiến lên nào!", 3, 0.5, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[11] = {nTime = 0, nNum = 2,
		tbPrelock = {10},
		tbStartEvent = 
		{
			{"ChangeNpcAi", "npc", "Move", "xunlu-3", 11, 0, 0, 0, 0},
			{"ChangeNpcAi", "npc1", "Move", "xunlu1-3", 11, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc2", "Move", "xunlu2-3", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc3", "Move", "xunlu3-3", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc4", "Move", "xunlu4-3", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc5", "Move", "xunlu5-3", 0, 1, 1, 0, 0},

			{"BlackMsg", "Tiếp tục"},
			{"NpcBubbleTalk", "npc5", "Lâm An còn bao xa nữa?", 3, 1, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[12] = {nTime = 0, nNum = 13,
		tbPrelock = {11},
		tbStartEvent = 
		{
			{"AddNpc", 1, 12, 12, "gw", "guaiwu3", false, 0, 0.5, 9005, 0.5},
			{"AddNpc", 2, 1, 12, "sl", "shouling3", false, 0, 0.5, 9005, 0.5},
			{"NpcBubbleTalk", "gw", "Ta đang muốn thư giãn gân cốt đây!", 4, 1.1, 3},
			{"NpcBubbleTalk", "sl", "Để ta cho các ngươi biết sự lợi hại của Đại Kim!", 4, 1.1, 1},
			{"BlackMsg", "Diệt Kim Binh đột nhiên xuất hiện"},
		},
		tbUnLockEvent = 
		{
		},
	},
	[13] = {nTime = 3, nNum = 0,
		tbPrelock = {12},
		tbStartEvent = 
		{
			{"PlayerBubbleTalk", "Người Kim hình như ngày càng đông!"},
			{"NpcBubbleTalk", "npc1", "Hừ, hãy nghe tiếng đàn mà an nghỉ!", 3, 1, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[14] = {nTime = 0, nNum = 2,
		tbPrelock = {13},
		tbStartEvent = 
		{
			{"ChangeNpcAi", "npc", "Move", "xunlu-4", 14, 0, 0, 0, 0},
			{"ChangeNpcAi", "npc1", "Move", "xunlu1-4", 14, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc2", "Move", "xunlu2-4", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc3", "Move", "xunlu3-4", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc4", "Move", "xunlu4-4", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc5", "Move", "xunlu5-4", 0, 1, 1, 0, 0},

			{"BlackMsg", "Tiếp tục hộ tống quan tài thừa tướng"},
		},
		tbUnLockEvent = 
		{
		},
	},
	[15] = {nTime = 0, nNum = 11,
		tbPrelock = {14},
		tbStartEvent = 
		{
			{"NpcBubbleTalk", "npc1", "Lại có mai phục?", 3, 0, 1},
			{"PlayerBubbleTalk", "Cách cũ liệu có hiệu quả không?"},

			{"AddNpc", 3, 10, 15, "gw", "guaiwu4", false, 0, 0, 0, 0},
			{"AddNpc", 4, 1, 15, "sl", "shouling4", false, 0, 0, 0, 0},
			{"NpcBubbleTalk", "gw", "Chán sống hả!", 4, 2, 2},
			{"NpcBubbleTalk", "sl", "Đừng hòng qua được ta!", 4, 2, 1},
			{"BlackMsg", "Diệt thích khách mai phục!"},
		},
		tbUnLockEvent = 
		{
		},
	},
	[16] = {nTime = 3, nNum = 0,
		tbPrelock = {15},
		tbStartEvent = 
		{
			--{"PlayerBubbleTalk", "金人似乎越来越多了！"},
			{"NpcBubbleTalk", "npc1", "Phía trước là Lâm An rồi!", 3, 0.5, 1},
			{"NpcBubbleTalk", "npc4", "Cuối cùng!.", 2, 1, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[17] = {nTime = 0, nNum = 2,
		tbPrelock = {16},
		tbStartEvent = 
		{
			{"ChangeNpcAi", "npc", "Move", "xunlu-5", 17, 0, 0, 0, 0},
			{"ChangeNpcAi", "npc1", "Move", "xunlu1-5", 17, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc2", "Move", "xunlu2-5", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc3", "Move", "xunlu3-5", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc4", "Move", "xunlu4-5", 0, 1, 1, 0, 0},
			{"ChangeNpcAi", "npc5", "Move", "xunlu5-5", 0, 1, 1, 0, 0},

			{"BlackMsg", "Tiến về Lâm An"},	
		},
		tbUnLockEvent = 
		{
		},
	},
	[18] = {nTime = 4, nNum = 0,
		tbPrelock = {17},
		tbStartEvent = 
		{
			{"PlayerBubbleTalk", "Ta cảm nhận được cao thủ xuất hiện!"},
			{"NpcBubbleTalk", "npc1", "Đúng vậy, mọi người cẩn thận!", 3, 2, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[19] = {nTime = 0, nNum = 1,
		tbPrelock = {18},
		tbStartEvent = 
		{
			{"AddNpc", 1, 12, 0, "gw", "guaiwu5", false, 0, 0.5, 9005, 0.5},
			{"AddNpc", 6, 1, 19, "sl", "shouling5", false, 0, 0.5, 9005, 0.5},
			--{"NpcBubbleTalk", "gw", "老子正想活动下筋骨呢！", 4, 1.5, 2},
			{"NpcBubbleTalk", "sl", "Ta đợi đã lâu rồi, ha ha ha!", 4, 1.5, 1},
			{"BlackMsg", "Diệt cao thủ cản đường!"},
		},
		tbUnLockEvent = 
		{
			{"DoDeath", "gw"},
			{"DoDeath", "gw1"},
			{"CloseLock", 20},
		},
	},
	[20] = {nTime = 10, nNum = 0,
		tbPrelock = {18},
		tbStartEvent = 
		{
		},
		tbUnLockEvent = 
		{
			{"AddNpc", 5, 12, 0, "gw1", "guaiwu5", false, 0, 0, 0, 0},
			{"NpcBubbleTalk", "sl", "Huynh đệ ra đây nào!", 4, 0, 1},

			{"PlayerBubbleTalk", "Đây là quân Tống?"},
			{"NpcBubbleTalk", "npc1", "Đều là bọn người đã đầu hàng nước Kim!", 3, 2, 1},
			{"NpcBubbleTalk", "gw1", "Không biết điều!", 3, 5, 2},
		},
	},
	[21] = {nTime = 1, nNum = 0,
		tbPrelock = {19},
		tbStartEvent = 
		{
			{"NpcBubbleTalk", "npc1", "Hừ, cuối cùng cũng đánh bại hắn!", 3, 0, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[22] = {nTime = 0, nNum = 1,
		tbPrelock = {21},
		tbStartEvent = 
		{
			{"RaiseEvent", "ShowTaskDialog", 22, 1146, false},	--剧情1
			{"SetNpcBloodVisable", "npc", false, 0},
			{"SetNpcBloodVisable", "npc1", false, 0},
			{"SetNpcBloodVisable", "npc2", false, 0},
			{"SetNpcBloodVisable", "npc3", false, 0},
			{"SetNpcBloodVisable", "npc4", false, 0},
			{"SetNpcBloodVisable", "npc5", false, 0},
		},
		tbUnLockEvent = 
		{
		},
	},
	[23] = {nTime = 0, nNum = 1,
		tbPrelock = {22},
		tbStartEvent = 
		{
			{"NpcBubbleTalk", "npc1", "Xem đi, phía trước chính là Lâm An!", 5, 0, 1},
			{"ChangeNpcAi", "npc1", "Move", "xunlu1-6", 23, 1, 1, 0, 0},

			--{"PlayCameraEffect", 9119},
			--{"SetPos", 5493, 4209},
		},
		tbUnLockEvent = 
		{
			{"SetAiActive", "npc1", 0},
			--{"ClearTargetPos"},
		},
	},
	[24] = {nTime = 0, nNum = 1,
		tbPrelock = {23},
		tbStartEvent = 
		{
			{"SetAllUiVisiable", false},
			{"SetForbiddenOperation", true, false},	
			--{"PlaySceneCameraAnimation", "baishuisi_cam1", "baishuisi_cam1", 23},
			{"PlayCameraAnimation", 1, 24},
			{"PlayEffect", 9220, 0, 0, 0, 1},
		},
		tbUnLockEvent = 
		{
		},
	},
	[25] = {nTime = 5, nNum = 0,
		tbPrelock = {24},
		tbStartEvent = 
		{
			{"OpenWindow", "StoryBlackBg", "Ngươi và Sương Nhi cuối cùng đã hộ tống quan tài của thừa tướng qua nơi hiểm nguy này, Lâm An đang ở phía trước...", nil, 5, 1, 0},
		},
		tbUnLockEvent = 
		{
			{"GameWin"},
		},
	},


}
