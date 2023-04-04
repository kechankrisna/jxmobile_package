Require("CommonScript/Player/PlayerDef.lua")
Toy.Def = {
	nInterval = 30,	--使用间隔（秒）

	szOpenTimeframe = "OpenLevel39",	--开放时间轴
	nGuideId = 51,	--引导id
	tbValidMaps = {	--生效的地图
		10, 15, 999, 1000, 1004,
		4000, 4001, 4002, 4003, 4004, 4005, 4006, 4007, 4008,
	},

	nHideBuffId = 2321,	--隐身buff

	nWindmillResId = 1249,	--风车ResId
	nChildResId = 1248,	--迎客小童ResId
	nMechaResId = 3219,	--机甲ResId
	nSnowmanResId = 567,	--雪人ResId
	nSnowmanDir = 65,	--雪人朝向
	nDragonHeadResId = 3401,	--龙头ResId
	nDragonBodyResId = 3402,	--龙身ResId
	nDragonTailResId = 3403,	--龙尾ResId

	tbDragonRewards = {	--接龙奖励
		[1] = {nMinMember = 5, nContrib = 2000,
			nLeaderRedbag = 0, nLeaderTitle = 0, nMasterRedbag = 0, nMasterTitle = 0,
			szWorldNotice = ""},
		[2] = {nMinMember = 10, nContrib = 4000,
			nLeaderRedbag = 0, nLeaderTitle = 0, nMasterRedbag = 0, nMasterTitle = 0,
			szWorldNotice = ""},
		[3] = {nMinMember = 20, nContrib = 6000,
			nLeaderRedbag = 215, nLeaderTitle = 10304, nMasterRedbag = 216, nMasterTitle = 10304,
			szWorldNotice = "Bang %s đạt 20 người, hào quang tỏa sáng, chân long hiện thế."},
		[4] = {nMinMember = 30, nContrib = 8000,
			nLeaderRedbag = 217, nLeaderTitle = 0, nMasterRedbag = 218, nMasterTitle = 0,
			szWorldNotice = "Bang %s đạt 30 người, hào quang tỏa sáng, chân long hiện thế."},
		[5] = {nMinMember = 50, nContrib = 10000,
			nLeaderRedbag = 219, nLeaderTitle = 10305, nMasterRedbag = 220, nMasterTitle = 10305,
			szWorldNotice = "Bang %s đạt 50 người, hào quang tỏa sáng, chân long hiện thế."},
		[6] = {nMinMember = 70, nContrib = 20000,
			nLeaderRedbag = 221, nLeaderTitle = 0, nMasterRedbag = 222, nMasterTitle = 0,
			szWorldNotice = "Bang %s đạt 70 người, hào quang tỏa sáng, chân long hiện thế."},
		[7] = {nMinMember = 100, nContrib = 30000,
			nLeaderRedbag = 223, nLeaderTitle = 10306, nMasterRedbag = 224, nMasterTitle = 10306,
			szWorldNotice = "Bang %s đạt 100 người, hào quang tỏa sáng, chân long hiện thế."},
	},

	nPigResId = 20304,	--猪ResId
	szPigBubbleTalk = "Hừm~",	--变成猪后冒泡内容
	nPigLastTime = 10,	--变猪效果持续时间（秒）

	nDragonDisRange = {80, 130},	--龙连接距离范围
	nDragonMaxDir = 10,	--龙连接最大朝向差

	tbDragonConnectBuffIds = {	--连接成功 玩家Buff id
		head = 4752,	--头
		body = 4753,	--身
		tail = 4754,	--尾
	},

	nForbiddenMoveBuffId = 1064,	--禁止移动buff id

	tbStatueId = { --各门派对应的雕像npcid 分别为男女
		[1]	 = {3290, 3291};--天王
		[2]	 = {3292, 3292};--峨嵋
		[3]	 = {3293, 3293};--桃花
		[4]	 = {3294, 3294};--逍遥
		[5]	 = {3295, 3296};--武当
		[6]	 = {3297, 3297};--天忍
		[7]	 = {3298, 3298};--少林
		[8]	 = {3299, 3299};--翠烟
		[9]	 = {3300, 3300};--唐门
		[10] = {3302, 3301};--昆仑
		[11] = {3303, 3303};--丐帮
		[12] = {3305, 3305};--五毒
		[13] = {3304, 3304};--藏剑山庄
		[14] = {3306, 3306};--长歌门
		[15] = {3307, 3308};--天山
		[16] = {3309, 3310};--霸刀
		[17] = {3311, 3312};--华山
		[18] = {3313, 3314};--明教
	},

	nDanceRange = 1000,	--天魔笛作用范围

	nStickId = 9565,	--糖葫芦道具id
	nStickRange = 1000,	--糖葫芦作用范围
	tbStickBuff = {4751, 1, 300},	--糖葫芦buff {id, 等级, 持续时间（秒）}

	nGreenHatId = 9542,	--绿帽子道具id
	nGreenHatGivenId = 9564,	--可穿戴绿帽子道具id

	nLightNpcId = 3252,	--琉璃灯NPC id
	nLightDuration = 10,	--琉璃灯存活时间（秒）

	nWineJarNpcId = 3286,	--酒坛NPC id
	nWineJarDuration = 20,	--酒坛存活时间（秒）
	szWineJarBubble = "Nào, cạn ly!",	--使用酒坛后玩家头顶冒泡文字
	nWineJarDanceBQ = 5,	--使用酒坛后跳舞表情id

	nMaskId = 9566,	--面具道具id
	nMaskLastTime = 30,	--面具效果持续时间（秒）
	nMaskRange = 1000,	--面具对话距离
	tbMasks = {	--面具配置
		[Player.SEX_MALE] = {	--男性玩家变身
			{
				nResId = 5032,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Quốc gia, thiên hạ làm đầu!",
					"Luyện võ như chèo thuyền ngược dòng, không tiến sẽ lùi.",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[5200] = {	--其他玩家变身ResId
						"Có thiên hạ nhưng lại mất nàng, Lâm Nhi, nàng có trách ta không?",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Vãn bối bái kiến minh chủ!",
				},
			},
			{
				nResId = 5027,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Độc chiến thiên hạ chỉ vì nàng!",
					"Cả thiên hạ này là của ta.",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[6129] = {	--其他玩家变身ResId
						"Nhã Tuyết, nàng còn nhớ lần đầu chúng ta gặp nhau không?",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Đại hiệp quả nhiên đáng để người khác ngưỡng mộ.",
				},
			},
			{
				nResId = 6101,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Có ai nhìn thấy My Nhi không?",
					"Không biết gần đây Hiên Nhi thế nào?",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[5177] = {	--其他玩家变身ResId
						"Cô bé là Chân Nhi nghịch ngợm sao?",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Nhân duyên của đại hiệp và các vị cô nương sẽ do ta làm chứng.",
				},
			},
			{
				nResId = 5119,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Ha ha, lừa ngươi đấy.",
					"Thiếu hiệp có muốn du ngoạn Đường Gia không?",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[5158] = {	--其他玩家变身ResId
						"Nụ cười của nàng chính là mùa xuân mà ta tìm kiếm bấy lâu nay.",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Bái kiến đại công tử Đường Môn!",
					"Công tử đang tìm đường đến Thúy Yên sao?",
				},
			},
			{
				nResId = 5193,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Không dám dấn tình sâu, sợ chỉ là giấc mộng.",
					"Đời như mộng ảo, cuối cùng cũng không thoát khỏi số mệnh.",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[5126] = {	--其他玩家变身ResId
						"Cuộc đời này may là có nàng, Thái Hồng.",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Cuộc đời chỉ là một giấc mộng hư ảo.",
					"Chúc mừng đã nên duyên chồng vợ.",
				},
			},
		},
		[Player.SEX_FEMALE] = {	--女性玩家变身
			{
				nResId = 5200,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Cuộc đời này mọi thứ đều do duyên cả.",
					"Nghĩa nặng tình sâu là người, oán hận thâm thù cũng là người.",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[34] = {	--其他玩家变身ResId
						"Độc Cô đại ca, mong đại ca đừng quên ý nguyện năm xưa",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Tấm lòng của cô nương quả khiến người khác kính phục",
				},
			},
			{
				nResId = 6129,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Khoảng cách xa nhất trên thế giới này chính là không thể yêu người.",
					"Giờ đã không còn phân biệt được phải trái, đúng sai nữa",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[5027] = {	--其他玩家变身ResId
						"Tất cả mọi thứ cuối cùng cũng không sánh được ánh mắt người",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Đời này chỉ mong có được người hiểu mình",
				},
			},
			{
				nResId = 5177,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Ngươi có thấy Phong ca không?",
					"Không biết gần đây cha thế nào rồi.",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[6101] = {	--其他玩家变身ResId
						"Có phải Dương đại ca đã chọc ghẹo cô nương nào đó không?",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Nạp Lan Cô Nương khi nào mới rời khỏi Vong Ưu Đảo?",
				},
			},
			{
				nResId = 5158,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Thiếu hiệp có dám đến du ngoạn Thúy Yên không?",
					"Người Thúy Yên ta sinh ra đã đẹp rồi.",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[5119] = {	--其他玩家变身ResId
						"Ảnh ca đã vì ta mà xông vào Thúy Yên, cả đời ta sẽ là của huynh.",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Bái kiến Thúy Yên Môn Chủ. ",
				},
			},
			{
				nResId = 5126,	--变身ResId
				tbTalkSelf = {	--自言自语候选语句列表
					"Cuộc đời biến hóa khôn lường, không ai có thể biết trước được điều gì.",
					"Tâm tịnh, thân an.",
				},
				tbTalkSelfInterval = {10, 20},	--自言自语间隔（秒） {最小, 最大}
				tbSpecialTalk = {	--与其他变身玩家特殊对话
					[5193] = {	--其他玩家变身ResId
						"Như Mộng, chuyện cũ đã qua, chỉ mong có thể bên cạnh người suốt đời.",
					},
				},
				tbOtherTalk = {	--其他非变身玩家对话
					"Xin hỏi phong cảnh ở nơi đó thế nào?",
				},
			},
		},
	},

	--
	-- 以下由程序配置
	--
	nUnlockSaveGrp = 178,
	nUseCountSaveGrp = 179,
	nDragonRewardGrp = 187,
}

Toy.Def.tbMustHaveItem = {
	ToyHat = Toy.Def.nGreenHatId,
	ToyMask = Toy.Def.nMaskId,
	ToyStick = Toy.Def.nStickId,
}

Toy.Def.tbNeedTarget = {
	ToyHat = true,
	ToyLaugh = true,
	ToyStick = true,
	ToyPig = true,
}