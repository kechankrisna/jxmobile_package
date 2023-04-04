Require("CommonScript/GiftSystem/Gift.lua");
-- ServerSaveKey
Wedding.nSaveGrp = 139
Wedding.nSaveKeyLastMemorialMailMonth = 2	--保存上次发送纪念日邮件的月份
Wedding.nSaveKeyLastMemorialNpcMonth = 3	--保存上次领取npc纪念日奖励的月份
Wedding.nSaveKeyGender = 4 	--保存性别：Gift.Sex.Girl-女，Gift.Sex.Boy-男 （为了玩家确立关系转门派不影响）
Wedding.nSaveKeyTitlePostfix = 11	--结婚称号后缀
Wedding.nSaveKeyWeddingLevel = 7 	-- 婚礼档次
Wedding.nSaveKeyGiveTitleItemTime = 8	--发送改名道具时间
Wedding.nSaveKeyOldWeddingAchi = 12 	-- 老成就是否达成

Wedding.nOperationType_Propose = 1 				-- 求婚
Wedding.nOperationType_Book = 2 				-- 订婚礼
Wedding.nOperationType_Open = 3 				-- 开启婚礼
Wedding.nOperationType_CancelPropose = 4 		-- 取消订婚关系
Wedding.nOperationType_Divorce = 5 				-- 离婚

--离婚后回收的家具
Wedding.tbWeddingFurniture =
{
	--家具道具ID，个数
	[5239] = 1,  --金童
	[5240] = 1,  --玉女
	[5241] = 1,  --婚床·晚樱连理
	[5242] = 1,  --婚床·红鸾揽月
	[5243] = 1,  --婚床·乘龙配凤
	[5244] = 1,  --浴盆·晚樱连理
	[5245] = 1,  --浴盆·红鸾揽月
	[5246] = 1,  --浴盆·乘龙配凤
	[5256] = 8,  --永结同心
};

-- 游城相关配置
Wedding.tbAllNpc = { 						-- 所有的npc模板ID，出生点，方向
--	{2385, {16786,12642}, 48}; --红娘
--	{2370, {17010,12641}, 48}; --新郎
--	{2392, {17223,12776}, 48}; --敲锣1
--	{2393, {17204,12518}, 48}; --敲锣2
--	{2390, {17405,12777}, 48}; --吹唢呐1
--	{2391, {17404,12524}, 48}; --吹唢呐2
--	{2386, {17686,12911}, 48}; --花童1
--	{2387, {17691,12305}, 48}; --花童2
--	{2362, {17897,12640}, 48}; --新娘
--	--{2394, {17904,12918}, 48}; --吹唢呐3
--	--{2395, {17904,12305}, 48}; --吹唢呐4
--	{2388, {18106,12911}, 48}; --花童3
--	{2389, {18108,12299}, 48}; --花童4

--固定点花童
	{2374, {15590,13056}, 6};
	{2374, {15596,12205}, 23};
	{2374, {14696,12172}, 38};
	{2374, {14675,13075}, 55};
	{2374, {16009,13448}, 42};
	{2374, {14443,15626}, 48};
	{2374, {13939,15631}, 17};
	{2374, {14886,14991}, 17};
	{2374, {15369,14982}, 48};
	{2374, {13963,17102}, 17};
	{2374, {14274,17523}, 32};
	{2374, {14799,16943}, 48};
	{2374, {13786,18152}, 48};
	{2374, {13781,17804}, 48};
	{2374, {12797,17821}, 3};
	{2374, {11271,17487}, 17};
	{2374, {11271,16981}, 17};
	{2374, {12000,17487}, 48};
	{2374, {11998,16981}, 48};
	{2374, {9254,15694}, 32};
	{2374, {9254,14965}, 0};
	{2374, {9983,15695}, 32};
	{2374, {9983,14965}, 0};
	{2374, {9202,12475}, 32};
	{2374, {9195,11750}, 0};
	{2374, {9704,11748}, 0};
	{2374, {9703,12475}, 32};
	{2374, {14013,12317}, 13};
	{2388, {17404,12443}, 63};--起点的花童
	{2388, {17401,12833}, 32};--起点的花童
	{2374, {12501,16186}, 41};
	{2374, {12359,14372}, 56};
	{2374, {10730,14456}, 11};
	{2374, {10742,16208}, 23};

--固定点吹唢呐
	{2375, {14943,14204}, 0};
	{2375, {15304,14202}, 0};
	{2375, {14473,17777}, 48};
	{2375, {14478,18178}, 48};
	{2375, {11273,17232}, 17};
	{2375, {11999,17235}, 48};
	{2375, {9645,15695}, 32};
	{2375, {9646,14963}, 0};
	{2375, {8537,13316}, 32};
	{2375, {8959,13321}, 32};
	{2375, {9477,12474}, 32};
	{2375, {9481,11745}, 0};
	{2375, {12093,12823}, 48};
	{2375, {12093,12427}, 48};
	{2390, {16957,12860}, 48};--起点的吹唢呐
	{2390, {16967,12442}, 48};--起点的吹唢呐

	--起点的敲锣
	{2376, {16763,12854}, 48};
	{2376, {16756,12427}, 48};


	{2386, {17152,12643}, 48}; --花童1
	{2370, {17377,12640}, 48}; --新郎
	{2362, {17768,12642}, 48}; --花轿
	{2387, {18190,12640}, 48}; --花童2
}
Wedding.nBoyNpcTID = 2370					-- 新郎Npc
Wedding.nGirlNpcTID = 2362					-- 新娘Npc
Wedding.nBoyViewNpcTID = 2370 				-- 新郎视角Npc
Wedding.nGirlViewNpcTID = 2370 				-- 新娘视角Npc
Wedding.nBubbleRangeNpcTID = 2370 			-- 泡泡祝贺基准npc
Wedding.nBubbleDistance = 1000 				-- 祝贺距离(距离泡泡祝贺基准npc多远的npc才会喊话)
Wedding.nBubblePlayerDistance = 1500 		-- 祝贺玩家可见距离(距离祝贺npc多远的npc才会看得见喊话)
Wedding.tbBubbleMsg = 						-- npc模板ID对应的祝贺词
{
	--杨瑛
	[633] = "Ta cũng muốn khoác áo cưới. Chàng có biết nỗi lòng của ta không? #58",
	--月眉儿
	[97] = "Ồ! Con cái nhà ai mà đẹp đôi quá, đúng là một cặp trời sinh!",
	--万金财
	[190] = "Đội rước dâu thật khí thế! Ta cũng muốn tham gia... #6",
	--林更新
	[2326] = "Ta đã nghe tiếng đội rước dâu rồi, mau chuẩn bị thôi. #43",
	--张如梦
	[625] = "Có vài đứa bé đang thậm thụt gì đó gần Ẩn Hương Lầu, đi ngang cẩn thận nhé! #43",
	--祝子虚
	[1528] = "Tân hôn vui vẻ, đại hiệp đi đường nhớ lưu ý nhé! #116",
	--武僧
	[1829] = "Sư phụ thường nói, con gái dưới núi toàn là hổ dữ, hổ mà đẹp thế ta cũng muốn cưới..... #13",
	--赵丽颖
	[2279] = "Mấy ngày trước Hồng Nương đến Gia Cụ Phường đặt một lô gia cụ cao cấp, tặng cho đại hiệp nhân kỷ niệm thành hôn. #43",
}
Wedding.szBubbleTime = "2"
Wedding.nTourMapTemplateId = 10 			-- 游城执行的地图
Wedding.nTourMsgListTimeOut = 180 			-- 感叹号过期时间
Wedding.nTourMsgListGoNpcTId = 2373			-- 点击前往寻找的NPC
Wedding.szTempNpcBubbleTime = "5" 			-- 临时演员喊话时间
Wedding.szTempNpcBubbleRange = 1000 		-- 临时演员喊话范围
Wedding.nWeddingFeelDay = 2 * 24 * 60 * 60	-- 婚礼氛围持续多久(音乐&地毯)
Wedding.nTourDelayOfflineTime = 30 * 60 	-- 游城开始延迟玩家下线时间
Wedding.nTourSynMapPosNpcTId = 2362 		-- 地图显示的基准Npc
-- nTime是隔多久执行下一步, nTime为nil立即寻路下一个点
Wedding.tbPath =
{
--[[
	[1] = {
		[2385] = {{nTime = 10, tbPos = {16786,12642}}, };--红娘
		[2370] = {{nTime = 10, tbPos = {17010,12641}}, };--新郎
		[2392] = {{nTime = 10, tbPos = {17223,12776}}, };--敲锣1
		[2393] = {{nTime = 10, tbPos = {17204,12518}}, };--敲锣2
		[2390] = {{nTime = 10, tbPos = {17405,12777}}, };--吹唢呐1
		[2391] = {{nTime = 10, tbPos = {17404,12524}}, };--吹唢呐2
		[2386] = {{nTime = 10, tbPos = {17686,12911}}, };--花童1
		[2387] = {{nTime = 10, tbPos = {17691,12305}}, };--花童2
		[2362] = {{nTime = 14, tbPos = {17897,12640}}, };--新娘
		--[2394] = {{nTime = 10, tbPos = {17904,12918}}, };--吹唢呐3
		--[2395] = {{nTime = 10, tbPos = {17904,12305}}, };--吹唢呐4
		[2388] = {{nTime = 16, tbPos = {18106,12911}}, };--花童3
		[2389] = {{nTime = 16, tbPos = {18108,12299}}, };--花童4
	},

	[2] = {
		[2385] = {{nTime = nil, tbPos = {15994,12635}}, };--红娘
		[2370] = {{nTime = nil, tbPos = {16218,12634}}, };--新郎
		[2392] = {{nTime = nil, tbPos = {16431,12769}}, };--敲锣1
		[2393] = {{nTime = nil, tbPos = {16412,12511}}, };--敲锣2
		[2390] = {{nTime = nil, tbPos = {16613,12770}}, };--吹唢呐1
		[2391] = {{nTime = nil, tbPos = {16612,12517}}, };--吹唢呐2
		[2386] = {{nTime = nil, tbPos = {17462,12753}}, {nTime = nil, tbPos = {16786,12760}}, };--花童1
		[2387] = {{nTime = nil, tbPos = {17457,12506}}, {nTime = nil, tbPos = {16781,12501}},};--花童2
		[2362] = {{nTime = nil, tbPos = {17205,12633}}, };--新娘
		[2388] = {{nTime = nil, tbPos = {18106,12911}}, {nTime = nil, tbPos = {17601,12735}},};--花童3
		[2389] = {{nTime = nil, tbPos = {18108,12299}}, {nTime = nil, tbPos = {17596,12513}},};--花童4
	},
]]
	--起始点，准备3分钟
	--每1分钟播一次世界公告
	--花轿队伍喊话
	[1] = {
		[2386] = {{nTime = 3*60, tbPos = {17096,12642}, tbTrigger = {1,2,3,4}, nDir = 50}, };--花童1
		[2370] = {{nTime = 3*60, tbPos = {17377,12640}, tbTrigger = {10,11,12,13,10,11,10,13,12,11,14,15}}, };--新郎
		[2362] = {{nTime = 3*60, tbPos = {17768,12642}}, };--花轿
		[2387] = {{nTime = 3*60, tbPos = {18190,12640}}, };--花童2
	},

	--开始走
	[2] = {
		[2386] = {{nTime = nil, tbPos = {16263,12663}}, };
		[2370] = {{nTime = nil, tbPos = {16263,12663}}, };
		[2362] = {{nTime = nil, tbPos = {16263,12663}}, };
		[2387] = {{nTime = nil, tbPos = {16263,12663}}, };
	},

	[3] = {
		[2386] = {{nTime = nil, tbPos = {15597,13593}, tbTrigger = {16}}, };
		[2370] = {{nTime = nil, tbPos = {15597,13593}}, };
		[2362] = {{nTime = nil, tbPos = {15597,13593}}, };
		[2387] = {{nTime = nil, tbPos = {15597,13593}}, };
	},

	[4] = {
		[2386] = {{nTime = nil, tbPos = {15136,13779}}, };
		[2370] = {{nTime = nil, tbPos = {15136,13779}}, };
		[2362] = {{nTime = nil, tbPos = {15136,13779}}, };
		[2387] = {{nTime = nil, tbPos = {15136,13779}}, };
	},

	[5] = {
		[2386] = {{nTime = nil, tbPos = {15138,15325}, tbTrigger = {17}}, };
		[2370] = {{nTime = nil, tbPos = {15138,15325}}, };
		[2362] = {{nTime = nil, tbPos = {15138,15325}}, };
		[2387] = {{nTime = nil, tbPos = {15138,15325}}, };
	},

	[6] = {
		[2386] = {{nTime = nil, tbPos = {14212,15334}}, };
		[2370] = {{nTime = nil, tbPos = {14212,15334}}, };
		[2362] = {{nTime = nil, tbPos = {14212,15334}}, };
		[2387] = {{nTime = nil, tbPos = {14212,15334}}, };
	},

	[7] = {
		[2386] = {{nTime = nil, tbPos = {14208,17280}, tbTrigger = {18}}, };
		[2370] = {{nTime = nil, tbPos = {14208,17280}}, };
		[2362] = {{nTime = nil, tbPos = {14208,17280}}, };
		[2387] = {{nTime = nil, tbPos = {14208,17280}}, };
	},

	[8] = {
		[2386] = {{nTime = nil, tbPos = {14808,17284}}, };
		[2370] = {{nTime = nil, tbPos = {14808,17284}}, };
		[2362] = {{nTime = nil, tbPos = {14808,17284}}, };
		[2387] = {{nTime = nil, tbPos = {14808,17284}}, };
	},

	[9] = {
		[2386] = {{nTime = nil, tbPos = {14780,17983}, tbTrigger = {19}}, };
		[2370] = {{nTime = nil, tbPos = {14780,17983}}, };
		[2362] = {{nTime = nil, tbPos = {14780,17983}}, };
		[2387] = {{nTime = nil, tbPos = {14780,17983}}, };
	},

	[10] = {
		[2386] = {{nTime = nil, tbPos = {12694,18060}}, };
		[2370] = {{nTime = nil, tbPos = {12694,18060}}, };
		[2362] = {{nTime = nil, tbPos = {12694,18060}}, };
		[2387] = {{nTime = nil, tbPos = {12694,18060}}, };
	},

	[11] = {
		[2386] = {{nTime = nil, tbPos = {11646,18020}, tbTrigger = {20}}, };
		[2370] = {{nTime = nil, tbPos = {11646,18020}}, };
		[2362] = {{nTime = nil, tbPos = {11646,18020}}, };
		[2387] = {{nTime = nil, tbPos = {11646,18020}}, };
	},

	--商会老板小剧情：109秒+90秒的派喜糖时间
	[12] = {
		[2386] = {{nTime = 199, tbPos = {11635,16786},
					tbTrigger = {
						--添加NPC，并且喊话：2+12+8*6=62秒
						100,101,102,103,104,105,106,107,
						--放烟花第一轮：2*5=10秒
						130,131,132,133,134,
						--放烟花第二轮：3+2*4=11秒
						136,133,132,131,130,
						--放烟花第三轮：2*4=8秒
						137,138,134,135,
						--NPC离开，并且删除：8+3+7=18秒
						108,109,30,
						--发喜糖环节
						120,121,5,
					}
				},
				};--花童1

		[2370] = {{nTime = 199, tbPos = {11634,17066}, nDir = 32,
					tbTrigger = {
						--184秒提示花轿继续，199秒结束喜糖，并且提示起轿
						122,123,
					}
				},
				};--新郎

		[2362] = {{nTime = 199, tbPos = {11635,17457}, tbTrigger = {5}}, };--花轿
		[2387] = {{nTime = 199, tbPos = {11634,17853}}, };--花童2
	},

	[13] = {
		[2386] = {{nTime = nil, tbPos = {11645,16304}}, };
		[2370] = {{nTime = nil, tbPos = {11645,16304}}, };
		[2362] = {{nTime = nil, tbPos = {11645,16304}}, };
		[2387] = {{nTime = nil, tbPos = {11645,16304}}, };
	},

	[14] = {
		[2386] = {{nTime = nil, tbPos = {10316,15318}, tbTrigger = {18}}, };
		[2370] = {{nTime = nil, tbPos = {10316,15318}}, };
		[2362] = {{nTime = nil, tbPos = {10316,15318}}, };
		[2387] = {{nTime = nil, tbPos = {10316,15318}}, };
	},

	[15] = {
		[2386] = {{nTime = nil, tbPos = {8726,15325}, tbTrigger = {16}}, };
		[2370] = {{nTime = nil, tbPos = {8726,15325}}, };
		[2362] = {{nTime = nil, tbPos = {8726,15325}}, };
		[2387] = {{nTime = nil, tbPos = {8726,15325}}, };
	},

	[16] = {
		[2386] = {{nTime = nil, tbPos = {8719,12159}}, };
		[2370] = {{nTime = nil, tbPos = {8719,12159}}, };
		[2362] = {{nTime = nil, tbPos = {8719,12159}}, };
		[2387] = {{nTime = nil, tbPos = {8719,12159}}, };
	},

	--讨喜糖剧情：166秒+90秒的派喜糖时间
	[17] = {
		[2386] = {{nTime = 256, tbPos = {9927,12107},
				tbTrigger = {
					--剧本喊话：2+18+8*8+3*5=99秒
					200,201,202,203,204,205,206,207,208,209,210,211,212,
					--放烟花：15*2=30秒
					250,251,252,250,251,252,253,250,251,252,254,250,252,253,254,
					--烟花结束的剧本喊话：5+4*8=37秒
					213,214,215,216,217,
					230,231,5
				}
			},
			};
		[2370] = {{nTime = 256, tbPos = {9647,12106},
				tbTrigger = {
					--271秒提示花轿继续，286分钟结束喜糖，并且提示起轿
					232,233,30
				}
			},
			};
		[2362] = {{nTime = 256, tbPos = {9252,12110}, tbTrigger = {5}}, };
		[2387] = {{nTime = 256, tbPos = {8865,12111}}, };
	},

	[18] = {
		[2386] = {{nTime = nil, tbPos = {11633,12111}}, };
		[2370] = {{nTime = nil, tbPos = {11633,12111}}, };
		[2362] = {{nTime = nil, tbPos = {11633,12111}}, };
		[2387] = {{nTime = nil, tbPos = {11633,12111}}, };
	},

	[19] = {
		[2386] = {{nTime = nil, tbPos = {11634,12637}}, };
		[2370] = {{nTime = nil, tbPos = {11634,12637}}, };
		[2362] = {{nTime = nil, tbPos = {11634,12637}}, };
		[2387] = {{nTime = nil, tbPos = {11634,12637}}, };
	},

	[20] = {
		[2386] = {{nTime = nil, tbPos = {14167,12635}}, };
		[2370] = {{nTime = nil, tbPos = {14167,12635}}, };
		[2362] = {{nTime = nil, tbPos = {14167,12635}}, };
		[2387] = {{nTime = nil, tbPos = {14167,12635}}, };
	},

	[21] = {
		[2386] = {{nTime = nil, tbPos = {14515,11625}}, };
		[2370] = {{nTime = nil, tbPos = {14515,11625}}, };
		[2362] = {{nTime = nil, tbPos = {14515,11625}}, };
		[2387] = {{nTime = nil, tbPos = {14515,11625}}, };
	},

	[22] = {
		[2386] = {{nTime = nil, tbPos = {15625,11625}}, };
		[2370] = {{nTime = nil, tbPos = {15625,11625}}, };
		[2362] = {{nTime = nil, tbPos = {15625,11625}}, };
		[2387] = {{nTime = nil, tbPos = {15625,11625}}, };
	},

	[23] = {
		[2386] = {{nTime = nil, tbPos = {16174,12664}}, };
		[2370] = {{nTime = nil, tbPos = {16174,12664}}, };
		[2362] = {{nTime = nil, tbPos = {16174,12664}}, };
		[2387] = {{nTime = nil, tbPos = {16174,12664}}, };
	},

	--终点，传第三档婚礼副本
	[24] = {
		[2386] = {{nTime = 15, tbPos = {17095,12641}, tbTrigger = {300, 301}}, };
		[2370] = {{nTime = 15, tbPos = {16841,12641}}, };
		[2362] = {{nTime = 15, tbPos = {16450,12638}}, };
		[2387] = {{nTime = 15, tbPos = {16057,12640}}, };
	},
	--终点
	[25] = {
		[2386] = {{nTime = nil, tbPos = {17095,12641}}, };
		[2370] = {{nTime = nil, tbPos = {16841,12641}}, };
		[2362] = {{nTime = nil, tbPos = {16450,12638}}, };
		[2387] = {{nTime = nil, tbPos = {16057,12640}}, };
	},
}

-- TourEnd 结束的时候抛出，必须有且只有一个TourEnd
-- SendNotify 发送公告
-- PlayEffect 播放特效
-- AddTempNpc 增加临时npc
-- nTime是隔多久执行当前操作，为nil立即执行
-- {szType = "SendNotify", tbParam = {szMsg = "测试", nMinLevel = 1, nMaxLevel = 999}};
-- {szType = "AddTempNpc", tbParam = {szGroup = "a", nNpcTID = 75, nX = 0, nY = 0, nDir = 0}};   -- 增加临时演员
-- {szType = "TempNpcGoAndTalk", tbParam = {szGroup = "a", nX = 0, nY = 0, szBubble = "aaa"}};   -- 控制临时演员走和说话
-- {szType = "PlayFirework", tbParam = {nId = 1}};      放烟花
-- {szType = "ClearTempNpc"};           清理临时演员
-- {szType = "StartCandy"}; 			开始派喜糖
-- {szType = "EndCandy"};               结束派喜糖
-- {szType = "TourEnd"};                结束游城
-- {szType = "NpcBubbleTalk", tbParam = {nNpcTId = 1, szBubble = "aa", szBubbleTime = "2"}};        --控制NPC喊话
-- {szType = "TempNpcBubbleTalk", tbParam = {szGroup = "a", nNpcTId = 1, szBubble = "aa", szBubbleTime = "2"}};        --控制NPC喊话
Wedding.tbTrigger =
{
	--开启游城时的世界公告
	[1] = {
		nTime = 5,
		tbExe = {
			{szType = "SendNotify", tbParam = {szMsg = "[FFFE0D]「%s」[-] và [FFFE0D]「%s」[-] sắp diễu hành, mọi người mau đến chỗ [FFFE0D]Tương Dương Nguyệt Lão[-] tặng lời chúc, giành kẹo hỉ, [FFFE0D]3 phút[-] nữa bắt đầu.", nMinLevel = 1, nMaxLevel = 999}};
		}
	};

	[2] = {
		nTime = 55,
		tbExe = {
			{szType = "SendNotify", tbParam = {szMsg = "[FFFE0D]「%s」[-] và [FFFE0D]「%s」[-] sắp diễu hành, mọi người mau đến chỗ [FFFE0D]Tương Dương Nguyệt Lão[-] tặng lời chúc, giành kẹo hỉ, [FFFE0D]2 phút[-] nữa bắt đầu.", nMinLevel = 1, nMaxLevel = 999}};
		}
	};

	[3] = {
		nTime = 60,
		tbExe = {
			{szType = "SendNotify", tbParam = {szMsg = "[FFFE0D]「%s」[-] và [FFFE0D]「%s」[-] sắp diễu hành, mọi người mau đến chỗ [FFFE0D]Tương Dương Nguyệt Lão[-] tặng lời chúc, giành kẹo hỉ, [FFFE0D]1 phút[-] nữa bắt đầu.", nMinLevel = 1, nMaxLevel = 999}};
		}
	};

	[4] = {
		nTime = 59,
		tbExe = {
			{szType = "SendNotify", tbParam = {szMsg = "[FFFE0D]「%s」[-] và [FFFE0D]「%s」[-] đang diễu hành ở [FFFE0D]Tương Dương[-], mọi người mau đến tặng lời chúc, giành kẹo hỉ.", nMinLevel = 1, nMaxLevel = 999}};
		}
	};

	--这个用于花轿已经开始游城了发的世界公告
	[5] = {
		nTime = 1,
		tbExe = {
			{szType = "SendNotify", tbParam = {szMsg = "[FFFE0D]「%s」[-] và [FFFE0D]「%s」[-] đang diễu hành ở [FFFE0D]Tương Dương[-], mọi người mau đến tặng lời chúc, giành kẹo hỉ.", nMinLevel = 1, nMaxLevel = 999}};
		}
	};

	--NPC喊话祝福
	[10] = {
		nTime = 15,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Tân hôn vui vẻ, trăm năm hạnh phúc! #66#66#66#66#66#66#66", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Tân hôn vui vẻ, trăm năm hạnh phúc! #66#66#66#66#66#66#66", szBubbleTime = "10"}};
		}
	};

	[11] = {
		nTime = 15,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Kiệu Hoa đã sẵn sàng, chờ giờ lành khởi kiệu. #124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Kiệu Hoa đã sẵn sàng, chờ giờ lành khởi kiệu. #124#124", szBubbleTime = "10"}};
		}
	};

	[12] = {
		nTime = 15,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Tân nương thật xinh đẹp, sau này lớn lên ta cũng muốn xinh đẹp như vậy! #13#13", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Tân nương thật xinh đẹp, sau này lớn lên ta cũng muốn xinh đẹp như vậy! #13#13", szBubbleTime = "10"}};
		}
	};

	[13] = {
		nTime = 15,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Người yêu nhau sẽ đến với nhau! Chúc tân lang tân nương hạnh phúc mỹ mãn! #11#11#11", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Người yêu nhau sẽ đến với nhau! Chúc tân lang tân nương hạnh phúc mỹ mãn! #11#11#11", szBubbleTime = "10"}};
		}
	};

	[14] = {
		nTime = 15,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Giờ lành đã đến, chuẩn bị khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Giờ lành đã đến, chuẩn bị khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2388, szBubble = "Giờ lành đã đến, chuẩn bị khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2376, szBubble = "Giờ lành đã đến, chuẩn bị khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2390, szBubble = "Giờ lành đã đến, chuẩn bị khởi kiệu! #124#124#124", szBubbleTime = "10"}};
		}
	};

	[15] = {
		nTime = 15,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2388, szBubble = "Khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2376, szBubble = "Khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2390, szBubble = "Khởi kiệu! #124#124#124", szBubbleTime = "10"}};
		}
	};

	--游城过程中的祝福
	[16] = {
		nTime = 1,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Kết duyên trăm năm! Chúc tân lang tân nương như ý mỹ mãn! #11#11#11", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Kết duyên trăm năm! Chúc tân lang tân nương như ý mỹ mãn! #11#11#11", szBubbleTime = "10"}};
		}
	};

	[17] = {
		nTime = 1,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Duyên lành trời ban! Chúc tân lang tân nương vui vẻ đầm ấm! #11#11#11", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Duyên lành trời ban! Chúc tân lang tân nương vui vẻ đầm ấm! #11#11#11", szBubbleTime = "10"}};
		}
	};

	[18] = {
		nTime = 1,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Một đời sánh đôi! Chúc tân lang tân nương yêu thương hòa thuận! #11#11#11", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Một đời sánh đôi! Chúc tân lang tân nương yêu thương hòa thuận! #11#11#11", szBubbleTime = "10"}};
		}
	};

	[19] = {
		nTime = 1,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Uyên ương chung tình! Chúc tân lang tân nương mãi mãi bên nhau! #11#11#11", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Uyên ương chung tình! Chúc tân lang tân nương mãi mãi bên nhau! #11#11#11", szBubbleTime = "10"}};
		}
	};

	[20] = {
		nTime = 1,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Xứng đôi vừa lứa! Chúc tân lang tân nương trăm năm hạnh phúc!  #11#11#11", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Xứng đôi vừa lứa! Chúc tân lang tân nương trăm năm hạnh phúc!  #11#11#11", szBubbleTime = "10"}};
		}
	};

	[30] = {
		nTime = 7,
		tbExe = {
			{szType = "ClearTempNpc"};
		}
	};

	--商会小剧情
	[100] = {
		nTime = 2,
		tbExe = {
			--添加剧情人物
			{szType = "AddTempNpc", tbParam = {szGroup = "wanjincai", nNpcTID = 2624, nX = 11353, nY = 16195, nDir = 0}};
			{szType = "AddTempNpc", tbParam = {szGroup = "lingengxin", nNpcTID = 2625, nX = 11357, nY = 16028, nDir = 0}};

			--剧情人物从镜头外移动到玩家镜头内
			{szType = "TempNpcGoAndTalk", tbParam = {szGroup = "wanjincai", nX = 11358, nY = 17207, nDir = 13, szBubble = "Chúc mừng!"}};
			{szType = "TempNpcGoAndTalk", tbParam = {szGroup = "lingengxin", nX = 11354, nY = 16920, nDir = 13, szBubble = "Chúc mừng!"}};
		}
	};

	[101] = {
		nTime = 12,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "wanjincai", nNpcTId = 2624, szBubble = "Đại hiệp đừng lo, ta đến không phải để cướp dâu! #6", szBubbleTime = "8"}};
		}
	};

	[102] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "lingengxin", nNpcTId = 2625, szBubble = "Ha ha! Cũng chỉ có Vạn Thúc mới làm được vậy thôi! #121", szBubbleTime = "8"}};
		}
	};

	[103] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "wanjincai", nNpcTId = 2624, szBubble = "Nghe nói hai vị thành hôn, ta sai người đến bố trí hội pháo hoa chúc mừng... #2", szBubbleTime = "8"}};
		}
	};

	[104] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "lingengxin", nNpcTId = 2625, szBubble = "Ta và Vạn Thúc đã phải chuẩn bị khá vất vả đấy! #23", szBubbleTime = "8"}};
		}
	};

	[105] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "wanjincai", nNpcTId = 2624, szBubble = "Ta chúc hai vị trăm năm hạnh phúc! #58", szBubbleTime = "8"}};
		}
	};

	[106] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "lingengxin", nNpcTId = 2625, szBubble = "Tại hạ cũng chúc hai vị yêu thương hòa thuận! #58", szBubbleTime = "8"}};
		}
	};

	[107] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "wanjincai", nNpcTId = 2624, szBubble = "Đốt pháo hoa #69#69", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "lingengxin", nNpcTId = 2625, szBubble = "Đốt pháo hoa #69#69", szBubbleTime = "8"}};

			--放烟花：心心相映
			{szType = "PlayFirework", tbParam = {nId = 50}};
		}
	};

	[108] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "wanjincai", nNpcTId = 2624, szBubble = "Hội pháo hoa đã kết thúc, ta xin cáo từ!", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "lingengxin", nNpcTId = 2625, szBubble = "Tạm biệt!", szBubbleTime = "8"}};
		}
	};

	[109] = {
		nTime = 3,
		tbExe = {
			--剧情人物从镜头内移动出玩家视线
			{szType = "TempNpcGoAndTalk", tbParam = {szGroup = "wanjincai", nX = 11353, nY = 16195}};
			{szType = "TempNpcGoAndTalk", tbParam = {szGroup = "lingengxin", nX = 11357, nY = 16028}};
		}
	};

	--可以撒喜糖的时候，花童提示
	[120] = {
		nTime = 2,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "[FFFE0D]Kẹo Hỉ [-]đã được chuẩn bị, tân lang và tân nương có thể phát kẹo hỉ! #10#10#10#10", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "[FFFE0D]Kẹo Hỉ [-]đã được chuẩn bị, tân lang và tân nương có thể phát kẹo hỉ! #10#10#10#10", szBubbleTime = "10"}};
			{szType = "RetsetCandyTimes"};
			{szType = "StartCandy"};

		}
	};

	--可以撒喜糖的时候，花童提示
	[121] = {
		nTime = 10,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Thời gian phát kẹo hỉ kéo dài [FFFE0D]90 giây[-], tân lang tân nương hãy mau phát kẹo hỉ! #10#10#10#10", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Thời gian phát kẹo hỉ kéo dài [FFFE0D]90 giây[-], tân lang tân nương hãy mau phát kẹo hỉ! #10#10#10#10", szBubbleTime = "10"}};
		}
	};

	--撒喜糖结束，提示花轿继续
	[122] = {
		nTime = 184,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Chuẩn bị khởi kiệu", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Chuẩn bị khởi kiệu", szBubbleTime = "10"}};
		}
	};
	--撒喜糖结束，提示花轿继续
	[123] = {
		nTime = 15,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Khởi kiệu! #124#124#124", szBubbleTime = "10"}};
			{szType = "EndCandy"};
		}
	};

	--第一个剧情烟花
	[130] = {
		nTime = 2,
		tbExe = {
			--放烟花
			{szType = "PlayFirework", tbParam = {nId = 51}};
		}
	};

	[131] = {
		nTime = 2,
		tbExe = {
			--放烟花
			{szType = "PlayFirework", tbParam = {nId = 52}};
		}
	};

	[132] = {
		nTime = 2,
		tbExe = {
			--放烟花
			{szType = "PlayFirework", tbParam = {nId = 53}};
		}
	};

	[133] = {
		nTime = 2,
		tbExe = {
			--放烟花
			{szType = "PlayFirework", tbParam = {nId = 54}};
		}
	};

	[134] = {
		nTime = 2,
		tbExe = {
			--放烟花：全部一起放
			{szType = "PlayFirework", tbParam = {nId = 55}};
		}
	};

	[135] = {
		nTime = 2,
		tbExe = {
			--放烟花：囍
			{szType = "PlayFirework", tbParam = {nId = 56}};
		}
	};

	[136] = {
		nTime = 3,
		tbExe = {
			--放烟花：心心相映
			{szType = "PlayFirework", tbParam = {nId = 50}};
		}
	};

	[137] = {
		nTime = 2,
		tbExe = {
			--放烟花：1、3
			{szType = "PlayFirework", tbParam = {nId = 51}};
			{szType = "PlayFirework", tbParam = {nId = 53}};
		}
	};


	[138] = {
		nTime = 2,
		tbExe = {
			--放烟花:2、4
			{szType = "PlayFirework", tbParam = {nId = 52}};
			{szType = "PlayFirework", tbParam = {nId = 54}};


		}
	};


	--第二个小剧情：讨喜糖
	[200] = {
		nTime = 2,
		tbExe = {
			--添加剧情人物
			{szType = "AddTempNpc", tbParam = {szGroup = "xiaoziyan", nNpcTID = 2626,  nX = 10404, nY = 11917, nDir = 0}};
			{szType = "AddTempNpc", tbParam = {szGroup = "xiaoyinfang", nNpcTID = 2627, nX = 10600, nY = 11915, nDir = 0}};
			{szType = "AddTempNpc", tbParam = {szGroup = "xiaoyintong", nNpcTID = 2628, nX = 10799, nY = 11914, nDir = 0}};


			--剧情人物从镜头外移动到玩家镜头内
			{szType = "TempNpcGoAndTalk", tbParam = {szGroup = "xiaoziyan",  nX = 9588, nY = 11827, nDir = 0, szBubble = "Hôn lễ thật sang trọng!#10"}};
			{szType = "TempNpcGoAndTalk", tbParam = {szGroup = "xiaoyinfang", nX = 9758, nY = 12280, nDir = 30, szBubble = "Tân nương đẹp quá#13"}};
			{szType = "TempNpcGoAndTalk", tbParam = {szGroup = "xiaoyintong", nX = 9755, nY = 11828, nDir = 0, szBubble = "Ta cũng muốn làm tân nương...#10"}};
		}
	};

	[201] = {
		nTime = 14,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "Thực ra chúng tôi đến để tặng lời phúc, trước tiên là Tiểu Tử Yên.#32", szBubbleTime = "8"}};
		};
	};
	[202] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "Tiểu Tử Yên chúc tân lang ngày càng khôi ngô, tân nương ngày càng duyên dáng!#118", szBubbleTime = "8"}};
		};
	};

	[203] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "Nhớ thường xuyên đến thăm ta nhé!#1", szBubbleTime = "8"}};
		};
	};

	[204] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2626, szBubble = "Tân lang làm sao xứng đôi với tân nương? Có can đảm đến thử sức với ta không?#119", szBubbleTime = "8"}};
		};
	};

	[205] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "#30Tiểu Ân Đồng? Đừng phá rối, hãy làm theo những gì đã bàn bạc...", szBubbleTime = "8"}};
		};
	};

	[206] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2626, szBubble = "Được! Ân Phương cũng chúc tân lang tân nương bạch đầu giai lão!#124", szBubbleTime = "8"}};
		};
	};

	[207] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "Tiểu Ân Đồng chúc tân lang tân nương vĩnh kết đồng tâm!#12", szBubbleTime = "8"}};
		};
	};

	[208] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "#116Hihi, vẫn chưa đến hồi gây cấn, Ân Phương, Tiểu Tử Yên, chuẩn bị thôi...", szBubbleTime = "8"}};
		};
	};

	[209] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "3#8", szBubbleTime = "5"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2626, szBubble = "3#8", szBubbleTime = "5"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "3#8", szBubbleTime = "5"}};
		};
	};

	[210] = {
		nTime = 5,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "2#7", szBubbleTime = "5"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2626, szBubble = "2#7", szBubbleTime = "5"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "2#7", szBubbleTime = "5"}};
		};
	};

	[211] = {
		nTime = 5,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "1#124", szBubbleTime = "5"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2626, szBubble = "1#124", szBubbleTime = "5"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "1#124", szBubbleTime = "5"}};
		};
	};

	[212] = {
		nTime = 5,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "Tân hôn vui vẻ!#66#66", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2626, szBubble = "Tân hôn vui vẻ!#66#66", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "Tân hôn vui vẻ!#66#66", szBubbleTime = "8"}};
		};
	};

	[213] = {
		nTime = 5,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "Ngạc nhiên chưa?#116", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2626, szBubble = "Bất ngờ chưa?#116", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "Hi hi!#116", szBubbleTime = "8"}};
		};
	};

	[214] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "Khó khăn lắm mới giành được pháo hoa từ tay lão Vạn đấy!#115", szBubbleTime = "5"}};
		};
	};

	[215] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "Hi hi! Cuối cùng cũng đã chúc phúc và đốt pháo hoa, giờ thì phải lấy kẹo hỉ thôi!#119", szBubbleTime = "8"}};
		};
	};

	[216] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2627, szBubble = "Đúng vậy, không phát kẹo hỉ chúng tôi sẽ không về.#115", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "Chúng tôi cần kẹo hỉ!#115", szBubbleTime = "8"}};
		};
	};

	[217] = {
		nTime = 8,
		tbExe = {
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoziyan", nNpcTId = 2626, szBubble = "Mau phát kẹo hỉ nào!#125", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyinfang", nNpcTId = 2627, szBubble = "Mau phát kẹo hỉ nào!#125", szBubbleTime = "8"}};
			{szType = "TempNpcBubbleTalk", tbParam = {szGroup = "xiaoyintong", nNpcTId = 2628, szBubble = "Mau phát kẹo hỉ nào!#125", szBubbleTime = "8"}};
		};
	};

	--可以撒喜糖的时候，花童提示
	[230] = {
		nTime = 2,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "[FFFE0D]Kẹo Hỉ [-]đã được chuẩn bị, tân lang và tân nương có thể phát kẹo hỉ! #10#10#10#10", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "[FFFE0D]Kẹo Hỉ [-]đã được chuẩn bị, tân lang và tân nương có thể phát kẹo hỉ! #10#10#10#10", szBubbleTime = "10"}};
			{szType = "RetsetCandyTimes"};
			{szType = "StartCandy"};
		}
	};

	--可以撒喜糖的时候，花童提示
	[231] = {
		nTime = 10,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Thời gian phát kẹo hỉ kéo dài [FFFE0D]90 giây[-], tân lang tân nương hãy mau phát kẹo hỉ! #10#10#10#10", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Thời gian phát kẹo hỉ kéo dài [FFFE0D]90 giây[-], tân lang tân nương hãy mau phát kẹo hỉ! #10#10#10#10", szBubbleTime = "10"}};
		}
	};

	--撒喜糖结束，提示花轿继续
	[232] = {
		nTime = 241,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Chuẩn bị khởi kiệu quay về", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Chuẩn bị khởi kiệu quay về", szBubbleTime = "10"}};
		}
	};
	--撒喜糖结束，提示花轿继续
	[233] = {
		nTime = 15,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Khởi kiệu quay về#124#124#124", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Khởi kiệu quay về#124#124#124", szBubbleTime = "10"}};
			{szType = "EndCandy"};
		}
	};

	--烟花上3、下3
	[250] = {
		nTime = 2,
		tbExe = {
			{szType = "PlayFirework", tbParam = {nId = 250}};
			{szType = "PlayFirework", tbParam = {nId = 250}};
		}
	};

	--烟花上2、下2
	[251] = {
		nTime = 2,
		tbExe = {
			{szType = "PlayFirework", tbParam = {nId = 251}};
			{szType = "PlayFirework", tbParam = {nId = 251}};
		}
	};

	--烟花上1、下1
	[252] = {
		nTime = 2,
		tbExe = {
			{szType = "PlayFirework", tbParam = {nId = 252}};
			{szType = "PlayFirework", tbParam = {nId = 252}};
		}
	};

	--烟花全部一起放
	[253] = {
		nTime = 2,
		tbExe = {
			{szType = "PlayFirework", tbParam = {nId = 253}};
			{szType = "PlayFirework", tbParam = {nId = 253}};
		}
	};

	--烟花心心相映
	[254] = {
		nTime = 2,
		tbExe = {
			{szType = "PlayFirework", tbParam = {nId = 254}};
			{szType = "PlayFirework", tbParam = {nId = 254}};
		}
	};

	--终点，提示准备传副本
	[300] = {
		nTime = 2,
		tbExe = {
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2386, szBubble = "Mời tân lang tân nương lên [FFFE0D]Tam Sinh Phảng[-], tổ chức hôn lễ [FFFE0D]Thuyền-Long Phụng[-].#66#66", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2387, szBubble = "Mời tân lang tân nương lên [FFFE0D]Tam Sinh Phảng[-], tổ chức hôn lễ [FFFE0D]Thuyền-Long Phụng[-].#66#66", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2388, szBubble = "Mời tân lang tân nương lên [FFFE0D]Tam Sinh Phảng[-], tổ chức hôn lễ [FFFE0D]Thuyền-Long Phụng[-].#66#66", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2376, szBubble = "Mời tân lang tân nương lên [FFFE0D]Tam Sinh Phảng[-], tổ chức hôn lễ [FFFE0D]Thuyền-Long Phụng[-].#66#66", szBubbleTime = "10"}};
			{szType = "NpcBubbleTalk", tbParam = {nNpcTId = 2390, szBubble = "Mời tân lang tân nương lên [FFFE0D]Tam Sinh Phảng[-], tổ chức hôn lễ [FFFE0D]Thuyền-Long Phụng[-].#66#66", szBubbleTime = "10"}};
		}
	};

	--终点，结束游城，传婚礼副本
	[301] = {
		nTime = 13,
		tbExe = {
			{szType = "TourEnd"};
		}
	};
}

--游城时的烟花
Wedding.tbTourPlayFireworkSetting =
{
	--商会剧情：心心相印
	[50] ={
			{9183, 11638,17058, 0},
			{9183, 11632,17443, 0},
	};
	--商会剧情-五彩烟花：左1右1
	[51] ={
			{9184, 11358,16840, 0},
			{9185, 11919,16841, 0},
	};
	--商会剧情-五彩烟花：左2右2
	[52] ={
			{9186, 11360,17164, 0},
			{9187, 11920,17160, 0},
	};
	--商会剧情-五彩烟花：左3右3
	[53] ={
			{9188, 11358,17471, 0},
			{9189, 11927,17470, 0},
	};
	--商会剧情-五彩烟花：左4右4
	[54] ={
			{9186, 11356,17848, 0},
			{9187, 11917,17856, 0},
	};
	--商会剧情-五彩烟花：全部一起放
	[55] ={
			{9184, 11358,16840, 0},
			{9185, 11360,17164, 0},
			{9186, 11358,17471, 0},
			{9187, 11356,17848, 0},
			{9188, 11919,16841, 0},
			{9189, 11920,17160, 0},
			{9186, 11927,17470, 0},
			{9187, 11917,17856, 0},
	};
	--商会剧情-囍烟花
	[56] ={
			{9182, 11634,17114, 0},
	};

	--讨喜糖-上3、下3
	[250] ={
			{9184, 9759,12412, 0},
			{9185, 9788,11819, 0},
	};

	--讨喜糖-上2、下2
	[251] ={
			{9186, 9447,12415, 0},
			{9187, 9452,11823, 0},
	};

	--讨喜糖-上1、下1
	[252] ={
			{9188, 9141,12414, 0},
			{9189, 9167,11821, 0},
	};

	--讨喜糖-烟花全部一起放
	[253] ={
			{9184, 9141,12414, 0},
			{9185, 9447,12415, 0},
			{9186, 9759,12412, 0},
			{9187, 9167,11821, 0},
			{9188, 9452,11823, 0},
			{9189, 9788,11819, 0},
	};

	--讨喜糖-烟花心心相映
	[254] ={
			{9183, 9241,12111, 0},
			{9183, 9657,12105, 0},
	};

}

-- 》》流程状态
Wedding.PROCESS_NONE = 0
Wedding.PROCESS_WELCOME = 1 																						-- 迎宾
Wedding.PROCESS_STARTWEDDING = 2 																	 				-- 开始婚礼
Wedding.PROCESS_PROMISE = 3 																						-- 山盟海誓
Wedding.PROCESS_MARRYCEREMONY = 4 																					-- 拜堂
Wedding.PROCESS_FIRECRACKER = 5 																					-- 开心爆竹
Wedding.PROCESS_CONCENTRIC = 6 																						-- 同食同心果
Wedding.PROCESS_WEDDINGTABLE = 7 																					-- 宴席（祝福抽奖）<抽奖取消>
Wedding.PROCESS_CANDY = 8 																							-- 派发喜糖
Wedding.PROCESS_END = 9 																							-- 婚礼结束	
-- 》》求婚		
Wedding.szOpenPropose_version_tx = nil
Wedding.szOpenPropose_version_vn = nil
Wedding.szOpenPropose_version_hk = nil
Wedding.szOpenPropose_version_xm = nil
Wedding.szOpenPropose_version_en = nil
Wedding.szOpenPropose_version_kor = nil
Wedding.szOpenPropose_version_th = nil
Wedding.szProposeTimeFrame = "OpenLevel69" 															-- 开启时间轴
Wedding.nProposeLevel = 50 																			-- 需要等级
Wedding.nProposeImitity = 30 																		-- 需要亲密度
Wedding.MIN_PROPOSE_DISTANCE = 1000 																-- 求婚距离
Wedding.nProposeDecideTime = 60 																	-- 作决定时间
Wedding.PROPOSE_OK = 0 																				-- 同意
Wedding.PROPOSE_REFUSE = 1 																			-- 拒绝
Wedding.PROPOSE_CANCEL = 2 																			-- 取消
Wedding.ProposeItemId = 6155 																		-- 求婚道具
Wedding.ProposeTitleId = 8201 																		-- 订婚称号

Wedding.szProposeTimeoutTip = "「%s」đang chìm đắm trong hạnh phúc, chưa thể phản hồi" 					-- 求婚者超时拒绝提示
Wedding.szBeProposeTimeoutTip = "Đừng quá chìm đắm trong hạnh phúc! Hãy nhớ đồng ý lời cầu hôn của「%s」!"				-- 被求婚者超时拒绝提示
Wedding.szProposeSuccessTip = "Nay trở thành đôi tình nhân hạnh phúc. Chúc hai vị luôn sát cánh bên nhau!" 					-- 求婚者成功提示
Wedding.szBeProposeSuccessTip = "Nay trở thành đôi tình nhân hạnh phúc. Chúc hai vị luôn sát cánh bên nhau!" 				-- 被求婚者同意求婚提示
Wedding.szProposeSuccessNotify = "Tương ngộ tương thức đều là duyên. Chúc mừng[FFFE0D]「%s」[-]cầu hôn[FFFE0D]「%s」[-]thành công, chúc hai vị mãi hạnh phúc!"					-- 求婚成功滚屏公告
Wedding.szProposeFailTip = "「%s」vẫn chưa sẵn sàng để chấp nhận lời cầu hôn"									-- 求婚者拒绝提示
Wedding.szBeProposeFailTip = "Đã từ chối cầu hôn của「%s」" 												-- 被求婚者拒绝求婚提示
Wedding.szProposeBreakTip = "Cầu hôn bị gián đoạn, hãy kiên nhẫn chờ đợi đối phương phản hồi!"								-- 求婚过程中主动打断的提示（切地图，离线，重登等）
Wedding.szProposeBeBreakTip = "「%s」vẫn còn thẹn thùng, thử lại một lần nữa!" 						-- 求婚过程中对方打断的提示（切地图，离线，重登等）
Wedding.tbProposePromise = 																			-- 求婚誓言模板
{
	"[ff72c5]Hỷ kết lương duyên!\n[-][c8fe00]%s [-]yêu dấu, hãy sát cánh cùng ta\nHãy cùng ta ngao du thiên hạ!";
	"[ff72c5]Chỉ cần trong lòng luôn có nhau!\n[-][c8fe00]%s [-]yêu dấu, người mà ta tìm đang ở đây\nNgao du thiên hạ chỉ vì bảo vệ tình duyên!";
	"[ff72c5]Gặp gỡ chính là duyên phận!\n[-][c8fe00]%s [-]yêu dấu, gặp nhau chính là hạnh phúc\nHạnh phúc là luôn sát cánh bên nhau!";
	"[ff72c5]Như chim liền cánh, như cây liền cành!\n[-][c8fe00]%s [-] yêu dấu, bất kể ở đâu nơi nào\nChúng ta cũng sẽ không bao giờ xa cách!";
	"[ff72c5]Cho dù bao xa cũng không thể chia cắt chúng ta!\n[-][c8fe00]%s [-]yêu dấu, ta chỉ là một người phàm\nChỉ muốn chúng ta luôn ở cạnh nhau!";
}
Wedding.tbProposeCloseWnd = {"Task","TeamPanel","NewInformationPanel","AuctionPanel","WelfareActivity", "CalendarPanel", "ItemBox", "AthleticsHonor", "RankBoardPanel", "RoleInformationPanel", "CommonShop", "SkillPanel", "Partner", "KinDetailPanel", "SocialPanel", "ChatLargePanel", "ViewRolePanel", "WeddingChoosePromisePanel", "StrongerPanel", "MarketStallPanel", "ChatSetting", "HonorLevelPanel", "MiniMap", "WorldMap", "NotifyMsgList", "HouseCameraPanel"}
-- 》》结婚相关
Wedding.nMarryMinDistance = 1000 																	-- 结婚时双方同屏距离
Wedding.nMarryOpenStart = "10:00" 																	-- 可开启婚礼开始时间点
Wedding.nMarryOpenEnd = "23:59" 																	-- 可开启婚礼结束时间点（暂不支持跨天）
Wedding.szFubenBase = "WeddingFubenBase" 															-- 副本基类
Wedding.NO_LIMIT = -1 																				-- 目前屌丝婚礼没有做次数检查
Wedding.Level_1 = 1 																				-- 屌丝
Wedding.Level_2 = 2 																				-- 小康
Wedding.Level_3 = 3 																				-- 高富帅
Wedding.nNoMoveBuffId = 1058 																		-- 防止移动的buff
Wedding.nBuffTime = 24 * 60 * 60 																	-- 变身持续时间
Wedding.nHideHeadUiBuff = 3549																		-- 隐藏名字血量等UI buff
Wedding.nHideHeadUiBuffTime =2 * 60																	-- 隐藏名字血量等UI buff时间
Wedding.szWeddingDecorateUiName = "jiehunfengfu01" 													-- 主城结婚装饰UI名字
Wedding.tbLoli = {3, 12} 																			-- 所有萝莉门派
Wedding.szxLoliGrowUpMsg = "Khoác bộ đồ cưới này, từ nay đã trở thành người lớn" 										-- 进婚礼现场之后的提示
Wedding.OPEN_WEDDING_MIN_DISTANCE = 1000 															-- 开启婚礼双方最小距离
Wedding.BOOK_WEDDING_MIN_DISTANCE = 1000 															-- 订婚礼双方最小距离
Wedding.nBookOpenDate = Lib:ParseDateTime("2017-09-01 00:00:00");									-- 开放婚礼预定的时间
Wedding.tbAllWeddingWnd = {"MarriageTitlePanel", "MarriagePaperPanel", "WeddingBookPanel", "WeddingBookDetailPanel", "WeddingCashGiftPanel",
"WeddingChoosePromisePanel", "WeddingEnterPanel", "WeddingWelcomeApplyPanel", "WeddingDatePanel", "WeddingSendPromisePanel", "WeddingWelcomePanel",
 "WeddingBlessingPanel", "RoleHeadPop", "ItemBox", "FloatingWindowDisplay", "NpcDialog", "BuffTip", "ChatLargePanel", "WeddingProcessPanel", "HouseCameraPanel"}
Wedding.nMarryCeremonyAddImitity = 9999 															-- 拜堂增加的亲密度
-- 》》各档次的婚礼对应的配置
Wedding.tbWeddingLevelMapSetting = {
	[Wedding.Level_1] = {
		nMapTID = 5000;
		nMaxTimes = Wedding.NO_LIMIT;
		fnGetDate = function (nBookTime) return Lib:GetLocalDay(nBookTime) end;
		fnGetDateStr = function (nBookTime) return Lib:TimeDesc14(nBookTime) end;
		nNeedVip = 5;
		nCost = "6231;2|2180;1|2181;1";
		nMarryCeremonySound = 1009;
		nBoyBuffId = 3540;
		nGirlBuffId = 3543;
		nDefaultMaxPlayer = 2000;
		szWeddingScene = "jiehun_diji_scene";
		tbMarryCeremonyRolePath = {
			Man = "jiehun_diji_scene/zhujue/jiehunzhujue/man/npc_183a/HeadUiPoint";
			Woman = "jiehun_diji_scene/zhujue/jiehunzhujue/woman/npc_184a/HeadUiPoint";
			Loli = "jiehun_diji_scene/zhujue/jiehunzhujue/woman/npc_185a/HeadUiPoint";
		};
		tbMarryCeremonyGirlRolePath = {
			Woman = "jiehun_diji_scene/zhujue/jiehunzhujue/woman/npc_184a";
			Loli = "jiehun_diji_scene/zhujue/jiehunzhujue/woman/npc_185a";
		};
		nDefaultWelcome = 20;
		szWeddingName = "Trang Viên-Tình Nồng";
		tbInviteAward = {{"item", 6233, 1}};
		nInviteCost = 99;
		nWholeTime = 1800;
		tbMarryAward =
		{
			{{"item", 6167, 1}};
			{{"item", 6282, 1}};
		};
		nStartDay = Lib:ParseDateTime("2017-09-01 00:00:00");  --开放婚礼预定的时间
		szOrderUiTexturePath = "UI/Textures/MarryScene1.png";
		tbShowAward = {
					--V7以下
					{7, {
							{"item", 6156, 1}, --婚服
							{"item", 6157, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6263, 1}, --称号
							{"item", 6243, 1}, --红包
							{"item", 6244, 1}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5241, 1}, --家具
							{"item", 5244, 1}, --家具
							{"item", 5256, 2}, --家具
						};
					};
					--V7~V8
					{9, {
							{"item", 6156, 1}, --婚服
							{"item", 6157, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6263, 1}, --称号
							{"item", 6245, 1}, --红包
							{"item", 6246, 1}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5241, 1}, --家具
							{"item", 5244, 1}, --家具
							{"item", 5256, 2}, --家具
						};
					};
					--V9以上
					{10, {
							{"item", 6156, 1}, --婚服
							{"item", 6157, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6263, 1}, --称号
							{"item", 6247, 1}, --红包
							{"item", 6248, 1}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5241, 1}, --家具
							{"item", 5244, 1}, --家具
							{"item", 5256, 2}, --家具
						};
					};
		};
		szDate = "Trong ngày";
		szFullDate = "Ngày mai";
		szCurDate = "Hôm nay";
		nReplayMapTId = 5003;
		tbTrapInfo =
		{
			TrapIn  = {tbPos = {6021,4961}};
			TrapOut_l = {tbPos = {5648,4952}};
			TrapOut_r = {tbPos = {6282,4971}};
			TrapOut_t = {tbPos = {6038,5247}};
			TrapOut_b = {tbPos = {6043,4668}};
		};
		nWitness = 4;
		nWitnessTitle = 8205;
		tbSchdule = 
		{
			{nProcess = Wedding.PROCESS_WELCOME, szProcess = "Đón khách"};
			{nProcess = Wedding.PROCESS_STARTWEDDING, szProcess = "Chuẩn bị hôn lễ"};
			{nProcess = Wedding.PROCESS_PROMISE, szProcess = "Thề Non Hẹn Biển"};
			{nProcess = Wedding.PROCESS_MARRYCEREMONY, szProcess = "Bái đường"};
			{nProcess = Wedding.PROCESS_FIRECRACKER, szProcess = "Pháo Hoa Vui Vẻ"};
			{nProcess = Wedding.PROCESS_WEDDINGTABLE, szProcess = "Tiệc"};
			{nProcess = Wedding.PROCESS_CANDY, szProcess = "Phát Kẹo Mừng"};
		};
	};
	[Wedding.Level_2] = {
		nMapTID = 5001;
		nMaxTimes = 1; 																						-- 重置期间同时可举行几场婚礼
		nPre = 7;																							-- 可提前几天预订婚礼
		fnCheckBook = function (pPlayer, nBookTime) return Wedding:CheckBookDay(pPlayer, Wedding.Level_2, nBookTime) end;
		fnGetDate = function (nBookTime) return Lib:GetLocalDay(nBookTime) end; 							-- 返回重置时间标志
		fnGetDateStr = function (nBookTime) return Lib:TimeDesc14(nBookTime) end; 							-- 返回时间的字符串描述
		nOverdueClearDay = 60; 																				-- 过期超过几天（按婚期当天开始算）不能重新择日（清理数据的标准）
		nCompleteClearDay = 1;																				-- 婚礼举办之后隔几天清理数据
		fnCheckBookOverdue = function (nBookDay) return nBookDay < Lib:GetLocalDay() end;					-- 检查预订的时间点是不是过期了
		fnCheckBookIsOpen = function (nBookDay) return nBookDay == Lib:GetLocalDay() end; 					-- 检查是否是预订婚礼的当天
		bBook = true;																						-- 是否需要预订
		nNeedVip = 9; 																						-- 预订需要达到的vip等级
		nCost = "6231;19|2180;9|2181;9";																	-- 花费
		nMissCost = "6231;9|2180;4|2181;4"; 																-- 过期后重新预订婚礼的差价
		nMarryCeremonySound = 1008; 																		-- 拜堂音乐
		nBoyBuffId = 3541; 																					-- 变身Buff ID 男
		nGirlBuffId = 3544; 																				-- 变身Buff ID 女
		nDefaultMaxPlayer = 2000; 																			-- 默认可进婚礼人数
		szWeddingScene = "jiehun_zhongji_scene";															-- 拜堂场景动画名字
		tbMarryCeremonyRolePath = {
			Man = "jiehun_zhongji_scene/zhujue/jiehunzhujue/man/npc_183b/HeadUiPoint";    					-- 拜堂男主角npc路径
			Woman = "jiehun_zhongji_scene/zhujue/jiehunzhujue/woman/npc_184b/HeadUiPoint"; 					-- 拜堂女主角正常npc路径
			Loli = "jiehun_zhongji_scene/zhujue/jiehunzhujue/woman/npc_185b/HeadUiPoint"; 					-- 拜堂女主角loli npc路径
		};
		tbMarryCeremonyGirlRolePath = {
			Woman = "jiehun_zhongji_scene/zhujue/jiehunzhujue/woman/npc_184b"; 								-- 拜堂女主角正常npc路径
			Loli = "jiehun_zhongji_scene/zhujue/jiehunzhujue/woman/npc_185b";								-- 拜堂女主角loli npc路径
		};
		nDefaultWelcome = 30; 																				-- 默认请柬数
		szWeddingName = "Hải Tân-Lãm Nguyệt";				 															-- 婚礼名字
		tbInviteAward = {{"item", 6233, 1}}; 																-- 邀请参加婚礼给对方的奖励（随机烟花）
		nInviteCost = 99; 																					-- 请柬价格
		nWholeTime = 1800; 																					-- 婚礼过程持续时间（根据这个时间给奖励加过期时间）
		tbMarryAward = 				  																		-- 结婚奖励
		{
			{{"item", 6168, 1}};																			--新郎结婚奖励
			{{"item", 6283, 1}};																			--新娘结婚奖励
		};
		nStartDay = Lib:ParseDateTime("2017-09-01 00:00:00"); 												-- 预定开始的时间(从某个时间点开始可以预定，为nil则从当前开始)
		szOrderUiTexturePath = "UI/Textures/MarryScene2.png"; 												-- 订婚礼界面图片路径
		tbShowAward = { 																					-- vip n级以下（不包括n）
					--V10以下
					{10, {
							{"item", 6158, 1}, --婚服
							{"item", 6159, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6263, 1}, --称号
							{"item", 6166, 30}, --同心果
							{"item", 6249, 3}, --红包
							{"item", 6250, 3}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5242, 1}, --家具
							{"item", 5245, 1}, --家具
							{"item", 5256, 6}, --家具
						};
					};
					--V10~V11
					{12, {
							{"item", 6158, 1}, --婚服
							{"item", 6159, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6263, 1}, --称号
							{"item", 6166, 30}, --同心果
							{"item", 6251, 3}, --红包
							{"item", 6252, 3}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5242, 1}, --家具
							{"item", 5245, 1}, --家具
							{"item", 5256, 6}, --家具
						};
					};
					--V12以上
					{13, {
							{"item", 6158, 1}, --婚服
							{"item", 6159, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6263, 1}, --称号
							{"item", 6166, 30}, --同心果
							{"item", 6253, 3}, --红包
							{"item", 6254, 3}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5242, 1}, --家具
							{"item", 5245, 1}, --家具
							{"item", 5256, 6}, --家具
						};
					};
		};
		szDate = "Trong ngày";
		szFullDate = "Ngày mai";
		szCurDate = "Hôm nay";																																				--
		szStartWeddingTip = "Đồng ý tổ chức hôn lễ [FFFE0D]Hải Tân-Lãm Nguyệt[-]?\n[FFFE0D]Gợi ý: thời gian hôn lễ khoảng 27 phút [-]";
		nReplayMapTId = 5004;
		tbTrapInfo =
		{
			TrapIn  = {tbPos = {6724,6045}};
			TrapOut_l = {tbPos = {6349,6023}};
			TrapOut_r = {tbPos = {6981,6017}};
			TrapOut_t = {tbPos = {6723,6358}};
			TrapOut_b = {tbPos = {6707,5708}};
		};
		nWitness = 4;
		nWitnessTitle = 8205;
		tbSchdule = 
		{
			{nProcess = Wedding.PROCESS_WELCOME, szProcess = "Đón khách"};
			{nProcess = Wedding.PROCESS_STARTWEDDING, szProcess = "Chuẩn bị hôn lễ"};
			{nProcess = Wedding.PROCESS_PROMISE, szProcess = "Thề Non Hẹn Biển"};
			{nProcess = Wedding.PROCESS_MARRYCEREMONY, szProcess = "Bái đường"};
			{nProcess = Wedding.PROCESS_FIRECRACKER, szProcess = "Pháo Hoa Vui Vẻ"};
			{nProcess = Wedding.PROCESS_CONCENTRIC, szProcess = "Cùng ăn Quả Đồng Tâm"};
			{nProcess = Wedding.PROCESS_WEDDINGTABLE, szProcess = "Tiệc"};
			{nProcess = Wedding.PROCESS_CANDY, szProcess = "Phát Kẹo Mừng"};
		};
		nContinueTime = 27;
	};
	[Wedding.Level_3] = {
		nMapTID = 5002;
		nMaxTimes = 1;
		nPre = 3; 																							-- 可提前几周预订婚礼
		fnCheckBook = function (pPlayer, nBookTime) return Wedding:CheckBookWeek(pPlayer, Wedding.Level_3, nBookTime) end;
		fnGetDate = function (nBookTime) return Lib:GetLocalWeek(nBookTime) end;
		fnGetDateStr = function (nBookTime)
			local nWeek = Lib:GetLocalWeek(nBookTime)
			local nWeekTime1 = Lib:GetTimeByWeek(nWeek, 1, 0, 0, 0)
			local nWeekTime7 = Lib:GetTimeByWeek(nWeek, 7, 0, 0, 0)
			return string.format("%s ~ %s", Lib:TimeDesc14(nWeekTime1), Lib:TimeDesc14(nWeekTime7))
		end;
		nOverdueClearDay = 60;
		nCompleteClearDay = 7;	 																			-- 按周算，7天，为了防止玩家再次预订已经预约过的日期
		fnCheckBookOverdue = function (nBookWeek) return nBookWeek < Lib:GetLocalWeek() end;
		fnCheckBookIsOpen = function (nBookWeek) return nBookWeek == Lib:GetLocalWeek() end;
		bBook = true;
		nNeedVip = 12;
		nCost = "6231;99|2180;19|2181;19";
		nMissCost = "6231;49|2180;9|2181;9";
		nMarryCeremonySound = 1008;
		nBoyBuffId = 3542;
		nGirlBuffId = 3545;
		nDefaultMaxPlayer = 2000;
		bCity = true;																						-- 是否先游城
		szWeddingScene = "jiehun_gaoji_scene";
		tbMarryCeremonyRolePath = {
			Man = "jiehun_gaoji_scene/zhujue/jiehunzhujue/man/npc_183c/HeadUiPoint";
			Woman = "jiehun_gaoji_scene/zhujue/jiehunzhujue/woman/npc_184c/HeadUiPoint";
			Loli = "jiehun_gaoji_scene/zhujue/jiehunzhujue/woman/npc_185c/HeadUiPoint";
		};

		tbMarryCeremonyGirlRolePath = {
			Woman = "jiehun_gaoji_scene/zhujue/jiehunzhujue/woman/npc_184c";
			Loli = "jiehun_gaoji_scene/zhujue/jiehunzhujue/woman/npc_185c";
		};
		nDefaultWelcome = 50;
		szWeddingName = "Thuyền-Long Phụng";
		tbInviteAward = {{"item", 6233, 1}};
		nInviteCost = 99;
		nWholeTime = 1800;
		tbMarryAward =
		{
			{{"item", 6169, 1}};
			{{"item", 6284, 1}};
		};
		nStartDay = Lib:ParseDateTime("2017-09-01 00:00:00");
		szOrderUiTexturePath = "UI/Textures/MarryScene3.png";
		tbShowAward = {
					--V12以下
					{13, {
							{"item", 6160, 1}, --婚服
							{"item", 6161, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6264, 1}, --称号
							{"item", 6166, 50}, --同心果
							{"item", 6255, 5}, --红包
							{"item", 6256, 5}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5243, 1}, --家具
							{"item", 5246, 1}, --家具
							{"item", 5256, 8}, --家具
						};
					};
					--V13~V15
					{16, {
							{"item", 6160, 1}, --婚服
							{"item", 6161, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6264, 1}, --称号
							{"item", 6166, 50}, --同心果
							{"item", 6257, 5}, --红包
							{"item", 6258, 5}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5243, 1}, --家具
							{"item", 5246, 1}, --家具
							{"item", 5256, 8}, --家具
						};
					};
					--V16以上
					{17, {
							{"item", 6160, 1}, --婚服
							{"item", 6161, 1}, --婚服
							{"item", 6163, 1}, --婚戒
							{"item", 6164, 1}, --婚戒
							{"item", 6264, 1}, --称号
							{"item", 6166, 50}, --同心果
							{"item", 6259, 5}, --红包
							{"item", 6260, 5}, --红包
							{"item", 6162, 1}, --婚书
							{"item", 5243, 1}, --家具
							{"item", 5246, 1}, --家具
							{"item", 5256, 8}, --家具
						};
					};
		};
		szDate = "Tuần này";
		szFullDate = "Tuần sau";
		szCurDate = "Tuần này";
		szStartWeddingTip = "Đồng ý tổ chức hôn lễ [FFFE0D]Thuyền-Long Phụng[-]?\n[FFFE0D]Gợi ý: thời gian hôn lễ khoảng 45 phút [-]";
		nReplayMapTId = 5005;
		tbTrapInfo =
		{
			TrapIn    = {tbPos = {7873,6308}};
			TrapOut_l = {tbPos = {7503,6302}};
			TrapOut_r = {tbPos = {8124,6316}};
			TrapOut_t = {tbPos = {7894,6649}};
			TrapOut_b = {tbPos = {7871,5985}};
		};
		nWitness = 4;
		nWitnessTitle = 8205;
		tbSchdule = 
		{
			{nProcess = Wedding.PROCESS_WELCOME, szProcess = "Đón khách"};
			{nProcess = Wedding.PROCESS_STARTWEDDING, szProcess = "Chuẩn bị hôn lễ"};
			{nProcess = Wedding.PROCESS_PROMISE, szProcess = "Thề Non Hẹn Biển"};
			{nProcess = Wedding.PROCESS_MARRYCEREMONY, szProcess = "Bái đường"};
			{nProcess = Wedding.PROCESS_FIRECRACKER, szProcess = "Pháo Hoa Vui Vẻ"};
			{nProcess = Wedding.PROCESS_CONCENTRIC, szProcess = "Cùng ăn Quả Đồng Tâm"};
			{nProcess = Wedding.PROCESS_WEDDINGTABLE, szProcess = "Tiệc"};
			{nProcess = Wedding.PROCESS_CANDY, szProcess = "Phát Kẹo Mừng"};
		};
		nContinueTime = 45;
	};
}

Wedding.tbAllWeddingMap = {}
for nLevel, v in ipairs(Wedding.tbWeddingLevelMapSetting) do
	Wedding.tbAllWeddingMap[v.nMapTID] = nLevel
end																					-- 拍照
-- 》》婚姻状态
Wedding.State_None = 0 																								-- 无婚姻关系
Wedding.State_Engaged = 1 																							-- 订婚关系
Wedding.State_Marry = 2 																							-- 结婚关系
-- 》》迎宾
Wedding.Welcome_Onekey_Frined = 1 																					-- 一键邀请好友
Wedding.Welcome_Onekey_Kin = 2 																						-- 一键邀请家族成员
Wedding.Welcome_Onekey_Apply = 3 																				    -- 一键同意申请
Wedding.Welcome_PersonalApply = 4 																				    -- 同意个人邀请
Wedding.Welcome_PersonalFriend = 5 																				    -- 邀请个人好友
Wedding.Welcome_PersonalKin = 6 																				    -- 邀请个人家族成员

Wedding.nWelcomeItemTId = 6165 																						-- 请柬道具ID
Wedding.nRequestJumpWelcomeTime = 10 																				-- 请求跳过迎宾时间
Wedding.nRequestStartWeddingTime = 10 																				-- 请求跳过开始婚礼时间
-- 》》山盟海誓
Wedding.nPromiseEndTime = 120 																						-- 宣誓过程时间
Wedding.szPromiseStartTip = "Hãy cùng chứng kiến tình yêu bất diệt! Mời「%s」và「%s」ghi lại lời hứa của tình yêu" 									-- 宣誓开始月老喊话
Wedding.szPromiseDefault = "Cùng nhau đi đến cuối đời." 												-- 玩家没自定义默认誓言
Wedding.nVNPromiseMax = 60
Wedding.nVNPromiseMin = 4
Wedding.nTHPromiseMax = 60
Wedding.nTHPromiseMin = 3
Wedding.nKorPromiseMax = 40
Wedding.nKorPromiseMin = 3
Wedding.nPromiseMax = 24
Wedding.nPromiseMin = 3
Wedding.szPromiseNotice = "%s[FFFE0D]「%s」[-] tại hôn lễ [FFFE0D]%s[-] đã cùng %s[FFFE0D]「%s」[-] hứa hẹn lời thề vĩnh hằng: %s"
-- 》》开心爆竹
Wedding.nFirecrackerNpcTId = 2396 																					-- 爆竹NPCTId
Wedding.nFirecrackerDis = 1000 																						-- 奖励范围(半径10米)
Wedding.nFirecrackerBoomTime = 60 																					-- 爆炸时间
Wedding.tbFirecrackerMsg =  																						-- 提示配置（时间-信息）
{
	[1]  = "Pháo Hoa Vui Vẻ đã được đốt tại [FFFE0D]vũ đài[-], cách thời gian đốt còn [FFFE0D]%d giây[-], trong chứa nhiều quà thưởng!";
	[20] = "Pháo Hoa Vui Vẻ đã được đốt tại [FFFE0D]vũ đài[-], cách thời gian đốt còn [FFFE0D]%d giây[-], trong chứa nhiều quà thưởng!";
	[40] = "Pháo Hoa Vui Vẻ đã được đốt tại [FFFE0D]vũ đài[-], cách thời gian đốt còn [FFFE0D]%d giây[-], trong chứa nhiều quà thưởng!";
	[50] = "Pháo Hoa Vui Vẻ đã được đốt tại [FFFE0D]vũ đài[-], cách thời gian đốt còn [FFFE0D]%d giây[-], trong chứa nhiều quà thưởng!";
	[55] = "Pháo Hoa Vui Vẻ đã được đốt tại [FFFE0D]vũ đài[-], cách thời gian đốt còn [FFFE0D]%d giây[-], trong chứa nhiều quà thưởng!";
}
Wedding.tbFirecrackerAwardSetting = 																				-- 爆竹奖励
{
	{{"item", 6272, 1}};
	{{"item", 6273, 1}};
	{{"item", 6274, 1}};
}
Wedding.szFirecrackerBoomMsg = "Tân hôn vui vẻ, bách niên hảo hợp!" 			 													-- 爆炸之后玩家喊话
Wedding.nFirecrackerActionID = 7 																					-- 爆炸之后播放玩家动作id
Wedding.nFirecrackerRoleActionID = 6 																				-- 爆炸之后播放主角动作id
Wedding.nFirecrackerTitle = 8204 																					-- 特殊称号奖励
Wedding.nFirecrackerTitleOverdueTime = 10 * 24 * 60 *60 															-- 特殊称号持续时间
Wedding.nFirecrackerTitleMsg = "[FFFE0D]「%s」[-] tại tiết mục Pháo Hoa Vui Vẻ trong hôn lễ của [FFFE0D]「%s」[-] và [FFFE0D]「%s」[-] may mắn nhận được tú cầu, nhận danh hiệu đặc biệt [FF69B4]「Hoa Rụng Nhà Ta」[-]" 																			-- 特殊称号抽中提示（抽中玩家，男主角，女主角）																			-- 特殊称号没抽中提示（男主角，女主角）
-- 》》同心果
Wedding.nConcentricFruitWaitTime = 5 																				-- 读条等待时间
Wedding.nConcentricFruitHitTime = 1 																				-- 两者间隔几秒之内视为成功
Wedding.nConcentricFruitNpcTId = 2398 																				-- 同心果Npc id
Wedding.nConcentricFruitEndTime = 2*60 																		        -- 持续时间
Wedding.tbConcentricFruitAwardSetting = 			 																-- 成功奖励
{
	{{"item", 6166, 1}};																							--第一档婚礼的同心果奖励
	{{"item", 6166, 30}};
	{{"item", 6166, 50}};
}
Wedding.szConcentricFruitSuccessMsg = "Đôi tân lang và tân nương thật xứng đôi!" 									-- 成功喊话
Wedding.szConcentricFruitFailMsg = "Thật đáng tiếc! Hai vị đừng quá hồi hộp, hãy thử lại!" 									-- 失败喊话
-- 》》喜宴
Wedding.nDinnerWaitTime = 5 																						-- 食用读条时间
Wedding.nMaxDinnerEat = 1 	 																						-- 每轮最多吃几次
Wedding.tbDinnerAwardSetting =  																						    -- 食用奖励
{
	{{"item", 6266, 1}};
	{{"item", 6267, 1}};
	{{"item", 6268, 1}};
}
Wedding.nDinnerActionID = 5 																						-- 食用之后播放玩家动作id
Wedding.nDinnerRoleActionID = 5 																					-- 食用之后播放主角动作id
-- 》》称号
Wedding.tbTitleSuffix =
{
	"Vĩnh Kết Đồng Tâm";
	"Bạch Đầu Giai Lão";
}

-- 》》派发喜糖
Wedding.nCandyNpcTId = 2397
Wedding.nCandyWaitTime = 4
Wedding.Candy_Type_Free = 1
Wedding.Candy_Type_Pay = 2
-- 副本喜糖
Wedding.szFubenCandy = "FubenCandy"
Wedding.szCandyFubenThrowMsg = "Nguyệt Lão đã đặt [FFFE0D]Kẹo Hỉ[-] xung quanh, hy vọng ai cũng được hạnh phúc"
Wedding.szCandyFubenSendMsg = "「%s」và「%s」cảm tạ lời chúc của mọi người, đã chuẩn bị [FFFE0D]Kẹo Hỉ[-] chia sẻ cùng mọi người"
Wedding.tbCandySetting =  																						 -- 派喜糖次数
{
	{
		tbSendTimes = {3, 3};																					 -- {免费，付费}
		nPayCost = 199; 																						 -- 付费喜糖价格
		nCandyCount = 10; 																						 -- 刷喜糖个数
		tbAward = {{"item", 6269, 1}}; 																			 -- 喜糖奖励
		nAwardCount = 10; 																					     -- 最多可拾取喜糖数量
	};
	{
		tbSendTimes = {5, 5};
		nPayCost = 399;
		nCandyCount = 10;
		tbAward = {{"item", 6270, 1}};
		nAwardCount = 15;
	};
	{
		tbSendTimes = {8, 8};
		nPayCost = 399;
		nCandyCount = 10;
		tbAward = {{"item", 6271, 1}};
		nAwardCount = 20;
	};
}
Wedding.szCandyFreeTip = "Đồng ý phát Kẹo Hỉ, để mọi người cùng chia sẻ?\n[FFFE0D](Lần này miễn phí)[-]" 									-- 免费派喜糖弹框提示
Wedding.szCandyPayTip = "Đồng ý dùng [FFFE0D]%d Nguyên Bảo[-] mua Kẹo Hỉ để tặng, và chia sẻ cùng mọi người?" 				-- 付费派喜糖弹框提示

-- 游城喜糖
Wedding.szTourCandy = "TourCandy"
Wedding.nCandyTourCount = 20
Wedding.nCandyTourCost = 599
Wedding.tbCandyTourAward = {{"item", 6271, 1}}
Wedding.szSendCandyTourMsg = "「%s」và「%s」cảm tạ lời chúc và đã chuẩn bị [FFFE0D]Kẹo Hỉ[-] cùng chia sẻ với mọi người" 																     -- 发喜糖黑条
Wedding.tbCandyTourPos = { 							--按停顿的次数走
	--商会剧情喜糖坐标
	{
		{11378,17672},
		{11412,17522},
		{11347,17417},
		{11430,17349},
		{11357,17190},
		{11443,17143},
		{11357,17004},
		{11453,16917},
		{11772,16921},
		{11845,17005},
		{11814,17132},
		{11862,17245},
		{11819,17378},
		{11885,17476},
		{11824,17572},
		{11865,17683},
		{11913,17346},
		{11907,17143},
		{11887,16924},
		{11448,17027},

	};

	--讨喜糖剧情喜糖坐标
	{
		{9097,12377},
		{9218,12383},
		{9340,12354},
		{9483,12340},
		{9559,12373},
		{9717,12330},
		{9122,11858},
		{9311,11878},
		{9162,11954},
		{9381,11919},
		{9517,11897},
		{9615,11914},
		{9718,11899},
		{9814,11902},
		{9303,11962},
		{9753,11989},
		{9885,12227},
		{9925,11999},
		{9030,11979},
		{9937,11902},
	};
}
Wedding.nCandyTourMaxFreeSend = 2 																					-- 可免费派送次数
Wedding.nCandyTourMaxPaySend = 2  																					-- 可付费派送次数

-- 》》祝福
Wedding.tbBlessMsg =
{
	{"Hạnh Phúc", "Nay trở thành đôi tình nhân viên mãn! Chúc「%s」và「%s」luôn hạnh phúc.#124"};
	{"Keo Sơn Gắn Bó", "Trăm năm mới có duyên để đến với nhau! Chúc「%s」và「%s」keo sơn gắn bó.#11"};
	{"Vĩnh Kết Đồng Tâm", "Tân hôn vui vẻ! Chúc「%s」và「%s」vĩnh kết đồng tâm.#58"};
	{"Bạch Đầu Giai Lão", "Uyên ương sát cánh mừng tân hôn! Chúc「%s」và「%s」bạch đầu giai lão.#120"};
	{"Bách Niên Hảo Hợp", "Nguyện làm chim liền cánh, cây liền cành! Chúc「%s」và「%s」bách niên hảo hợp.#66"};
}

-- 》》离婚
Wedding.nDismissProtectTime = 30*24*3600	--离婚保护期天数
Wedding.nForceDivorcePlayerOffline = 14 * 24 * 60 * 60	--若对方离线超过x秒，单方强制离婚无任何消耗，立即生效
Wedding.nForceDivorceDelayTime = 24 * 60 * 60
Wedding.nForceDivorceCost = 1000  --强制离婚费用
Wedding.nReduceImitity = 9999  --离婚扣除亲密度
Wedding.nDismissWaitingTime = 20	--协议离婚最长等待时间（秒）

--夫妻称号
Wedding.tbTitleIds = {
	[Wedding.Level_1] = 8200,
	[Wedding.Level_2] = 8202,
	[Wedding.Level_3] = 8203,
}
Wedding.nChangeTitleWaitTime = 20	--修改称号自动同意等待时间（秒）
Wedding.nChangeTitleCost = 999	--修改称号花费元宝数
Wedding.nTitleNameMin = 1;		-- 最小称号长度
Wedding.nTitleNameMax = 4;		-- 最大称号长度
if version_vn then
	Wedding.nTitleNameMin = 4;	-- 越南版最小称号长度
	Wedding.nTitleNameMax = 20;	-- 越南版最大称号长度
end
if version_th then
	Wedding.nTitleNameMin = 3;	-- 泰国版最小称号长度
	Wedding.nTitleNameMax = 16;	-- 泰国版最大称号长度
end
Wedding.nChangeTitleItemId = 7486	--改名道具

--婚戒
Wedding.tbRingIds = {
	[Wedding.Level_1] = {6163, 6164}, --男，女
	[Wedding.Level_2] = {6163, 6164},
	[Wedding.Level_3] = {6163, 6164},
}

--婚服
Wedding.tbAllDressIds = {6156, 6157, 6158, 6159, 6160, 6161}
Wedding.tbSmallSizeWeddingDress = {3546, 3547, 3548}	--小号婚服，萝莉专用

Wedding.tbDressPartResIds = {
	[Wedding.Level_1] = {
		-- [体型] = {头, 身体}    体型参见：Setting/ActionInteract/FactionShape.tab
		M1 = {6041, 6041},
		M2 = {6041, 6041},
		F1 = {8041, 8041},
		F2 = {9041, 9041},
	},
	[Wedding.Level_2] = {
		M1 = {6042, 6042},
		M2 = {6042, 6042},
		F1 = {8042, 8042},
		F2 = {9042, 9042},
	},
	[Wedding.Level_3] = {
		M1 = {6040, 6040},
		M2 = {6040, 6040},
		F1 = {8040, 8040},
		F2 = {9040, 9040},
	},
}

-- 》》状态类型的操作
Wedding.tbOperationSetting =
{
	[Wedding.State_Engaged] =
	{
		fnGet = function (pPlayer)
			return Wedding:GetEngaged(pPlayer.dwID)
		end;
		nTitleId = Wedding.ProposeTitleId;
	};
	[Wedding.State_Marry] =
	{
		fnGet = function (pPlayer)
			return Wedding:GetLover(pPlayer.dwID)
		end;
		nTitleId = Wedding.nTitleId;
	};
}

-- 》》结婚纪念日
Wedding.tbMemorialMonthRewards = { -- N个月纪念
	-- [第x月] = {...}
	[1] = {
		tbMail = {	--邮件附件
			{"item", 6233, 2},
		},
		tbNpc = {	--npc奖励
			{"item", 5239, 1},
			{"item", 5240, 1},
		},
	},

	[6] = {
		tbMail = {
			{"item", 6233, 2},
		},
		tbNpc = {
			{"item", 6825, 1},
			{"item", 6826, 1},
		},
		tbRedBags = {
			Kin.tbRedBagEvents.marry_month_6,
		},
	},

	--后面的奖励还没出
	--[12] = {
	--	tbMail = {
	--		{"item", 6233, 2},
	--	},
	--	tbNpc = {
	--	},
	--},
}

-- 》》礼金
Wedding.tbCashGiftSettings = {
    --[元宝] = {最小vip等级, 是否发送滚屏}
	[10] = 	 	{0},
	[19] = 		{3},
	[99] = 		{5},
	[199] = 	{6},
	[299] = 	{7},
	[599] = 	{8},
	[999] = 	{9, true},
	[1999] = 	{10, true},
	[2999] = 	{11, true},
	[5999] = 	{12, true},
	[9999] = 	{14, true},
	[19999] = 	{15, true},
	[29999] = 	{16, true},
	[39999] = 	{17, true},
	[59999] = 	{18, true},
}

-- 》》婚书
Wedding.nMarriagePaperId = 6162
Wedding.nMPHusbandNameIdx = 1
Wedding.nMPWifeNameIdx = 2
Wedding.nMPHusbandPledgeIdx = 3
Wedding.nMPWifePledgeIdx = 4
Wedding.nMPTimestamp = 5
Wedding.nMPLevel = 6 --婚礼档次

-- 》》燃放烟花配置
Wedding.tbPlayFireworkSetting =
{
	--第一档婚礼：五彩烟花
	[1] ={
			{9184, 5772,5534, 0},
			{9185, 6269,5517, 0},
			{9186, 6000,5272, 0},
			{9187, 6006,4621, 0},
			{9188, 6295,5024, 0},
			{9189, 5718,4935, 0},
			{9184, 5794,4364, 0},
			{9185, 6283,4390, 0},
			{9186, 5422,5098, 0},
			{9187, 5430,4804, 0},
			{9188, 4970,5096, 0},
			{9189, 4954,4798, 0},
			{9184, 4587,4642, 0},
			{9185, 2826,5267, 0},
			{9186, 2774,4644, 0},
			{9187, 3419,4639, 0},
			{9188, 3423,5249, 0},
			{9189, 4031,5247, 0},
			{9188, 3999,4631, 0},
			{9189, 4580,5240, 0},
	};
	--第一档婚礼：囍烟花
	[2] ={
			{9182, 6188,5302, 0},
			{9182, 6195,4623, 0},
			{9182, 4607,5269, 0},
			{9182, 4593,4641, 0},
			{9182, 2818,5261, 0},
			{9182, 2768,4626, 0},
			{9182, 3701,4639, 0},
			{9182, 3701,5250, 0},
	};

	--第二档婚礼：五彩烟花
	[10] ={
			{9184, 5901,6129, 0},
			{9185, 5894,5884, 0},
			{9186, 4727,5699, 0},
			{9187, 3298,6325, 0},
			{9188, 3298,5707, 0},
			{9189, 4039,5700, 0},
			{9184, 5353,5709, 0},
			{9185, 4722,6325, 0},
			{9186, 4047,6331, 0},
			{9187, 5332,6327, 0},
			{9188, 6756,6021, 0},
			{9189, 6748,6262, 0},
			{9184, 6749,5785, 0},
			{9185, 6731,5251, 0},
			{9186, 6741,6801, 0},
			{9187, 6747,6469, 0},
			{9188, 7042,6019, 0},
			{9189, 6349,6048, 0},
			{9184, 6731,5555, 0},
			{9185, 6159,6641, 0},
			{9186, 7236,6707, 0},
			{9186, 6201,5385, 0},
			{9186, 7212,5350, 0},
			{9186, 6464,5748, 0},
	};
	--第二档婚礼：囍烟花
	[11] ={
			{9182, 6954,5806, 0},
			{9182, 6951,6251, 0},
			{9182, 5358,5699, 0},
			{9182, 4455,5699, 0},
			{9182, 3525,5698, 0},
			{9182, 5343,6333, 0},
			{9182, 4444,6337, 0},
			{9182, 3526,6335, 0},
	};
	--第二档婚礼：心心相印
	[12] ={
			{9183, 6749,6019, 0},
	};

	--第三档婚礼：五彩烟花
	[20] ={
			{9184, 7567,6652, 0},
			{9185, 8181,6666, 0},
			{9186, 7542,5981, 0},
			{9187, 8161,5925, 0},
			{9188, 7912,6881, 0},
			{9189, 7887,5712, 0},
			{9184, 7397,6334, 0},
			{9185, 8181,6288, 0},
			{9186, 7928,6506, 0},
			{9187, 7919,6087, 0},
			{9188, 7049,6461, 0},
			{9189, 7049,6123, 0},
			{9184, 6628,6001, 0},
			{9185, 6189,6599, 0},
			{9186, 5634,5998, 0},
			{9187, 6184,5994, 0},
			{9188, 5660,6607, 0},
			{9189, 6640,6596, 0},
			{9184, 4436,6552, 0},
			{9185, 4440,6007, 0},
			{9186, 5013,6482, 0},
			{9186, 5020,6090, 0},
	};
	--第三档婚礼：囍烟花
	[21] ={
			{9182, 8068,6660, 0},
			{9182, 8088,5994, 0},
			{9182, 6519,6603, 0},
			{9182, 6513,5991, 0},
			{9182, 5911,6601, 0},
			{9182, 5891,5995, 0},
			{9182, 4871,6501, 0},
			{9182, 4875,6058, 0},
			{9182, 3930,6315, 0},
	};
	--第三档婚礼：心心相印
	[22] ={
			{9183, 7915,6289, 0},
	};
}

--红包
Wedding.tbRedbags = {
	[Wedding.Level_1] = {
		nEventType = Kin.tbRedBagEvents.wedding_1,
		nCount = 1,	--每个红包发送几个
	},
	[Wedding.Level_2] = {
		nEventType = Kin.tbRedBagEvents.wedding_2,
		nCount = 3,
	},
	[Wedding.Level_3] = {
		nEventType = Kin.tbRedBagEvents.wedding_3,
		nCount = 5,
	},
}

-- 拜堂回放
Wedding.szReplayFubenBase = "WeddingReplayFubenBase"

-- 双飞
Wedding.szDoubleFlyCameraAnimationObjectName = "lianan_twofly"
Wedding.nDoubleFlyMinDistance = 1000 					-- 双方可双飞最小距离
Wedding.nDoubleFlyWaitTime = 8 						-- 请求双飞等待时间
Wedding.tbDoubleFlyEndPos = {10755, 8439} 				-- 双飞结束设置点
Wedding.tbDoubleFlyCanterPos = {15627, 16025} 			-- 圆台中心点
Wedding.nDoubleFlyMaxDistance = 800 					-- 玩家距离中心tbDoubleFlyCanterPos的半径，在该圆内判定为在台上

function Wedding:GetCashGiftValidList(nVip)
	self.tbCashGiftValidListCache = self.tbCashGiftValidListCache or {}
	if not self.tbCashGiftValidListCache[nVip] then
		local tbRet = {}
		for nGold, tbSetting in pairs(self.tbCashGiftSettings) do
			local nMinVip = tbSetting[1]
			if nMinVip<=nVip then
				table.insert(tbRet, nGold)
			end
		end
		table.sort(tbRet, function(a, b) return a<b end)
		self.tbCashGiftValidListCache[nVip] = tbRet
	end
	return self.tbCashGiftValidListCache[nVip]
end

function Wedding:GetCashGiftMax(nVip)
	self.tbCashGiftMaxCache = self.tbCashGiftMaxCache or {}
	if not self.tbCashGiftMaxCache[nVip] then
		local tbList = self:GetCashGiftValidList(nVip)
		self.tbCashGiftMaxCache[nVip] = #tbList>0 and tbList[#tbList] or 0
	end
	return self.tbCashGiftMaxCache[nVip]
end

-- 返回nNow时刻最大的纪念日月数
function Wedding:GetMaxMemorialMonth(nWeddingTime, nNow)
	local nRet = 0
	local nDiffMonth = Lib:GetDiffMonth(nWeddingTime, nNow)
	if nDiffMonth<=0 then
		return nRet
	end

	for nMonth in pairs(self.tbMemorialMonthRewards) do
		if nRet<nMonth and nDiffMonth>=nMonth then
			nRet = nMonth
		end
	end
	return nRet
end

function Wedding:GetMemorialCfgMaxMonth()
	if not self.nMemorialCfgMaxMonth then
		local nMax = 0
		for nMonth in pairs(self.tbMemorialMonthRewards) do
			if nMax<nMonth then
				nMax = nMonth
			end
		end
		self.nMemorialCfgMaxMonth = nMax
	end
	return self.nMemorialCfgMaxMonth
end

function Wedding:CheckWeddingSex(pPlayer, pEngageder)
	local nPlayerSex = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyGender) or 0;
	local nEngagederSex = pEngageder.GetUserValue(self.nSaveGrp, self.nSaveKeyGender) or 0;
	if nPlayerSex == 0 or nEngagederSex == 0 or nPlayerSex == nEngagederSex then
		return false, "Không cùng giới tính"
	end
	return true
end

-- 结婚关系?结婚者和结婚时间:nil
function Wedding:GetLover(dwID)
	local nLover = Wedding:GetLoverId(dwID)

	if nLover > 0 then
		local tbFriendData = FriendShip.fnGetFriendData(dwID, nLover);
		if tbFriendData and tbFriendData[FriendShip:WeddingStateType()] == Wedding.State_Marry then
			return nLover, tbFriendData[FriendShip:WeddingTimeType()]
		end
	end
end

function Wedding:IsLover(dwRoleId1, dwRoleId2)
	local tbFriendData = FriendShip.fnGetFriendData(dwRoleId1, dwRoleId2);
	if tbFriendData and tbFriendData[FriendShip:WeddingStateType()] == Wedding.State_Marry then
		return true
	end
end

-- 订婚关系?订婚者:nil
function Wedding:GetEngaged(dwID)
	local nLover =  Wedding:GetLoverId(dwID)
	if nLover > 0 then
		local tbFriendData = FriendShip.fnGetFriendData(dwID, nLover);
		if tbFriendData and tbFriendData[FriendShip:WeddingStateType()] == Wedding.State_Engaged then
			return nLover
		end
	end
end

function Wedding:IsEngaged(dwRoleId1, dwRoleId2)
	local tbFriendData = FriendShip.fnGetFriendData(dwRoleId1, dwRoleId2);
	if tbFriendData and tbFriendData[FriendShip:WeddingStateType()] == Wedding.State_Engaged then
		return true
	end
end

-- 是否单身狗
function Wedding:IsSingle(pPlayer)
	local nLover =  Wedding:GetLoverId(pPlayer.dwID)
	if nLover > 0 then
		local tbFriendData = FriendShip.fnGetFriendData(pPlayer.dwID, nLover);
		return not tbFriendData or tbFriendData[FriendShip:WeddingStateType()] == Wedding.State_None
	end
	return true
end

function Wedding:GetLoverId(dwID)
	local nLoverId
	if MODULE_GAMESERVER then
		nLoverId = KFriendShip.GetMarriageRelationRoleId(dwID)
	else
		nLoverId = FriendShip:GetMarriageRoleId()
	end
	return nLoverId or 0
end

-- 返回真正可以预定的时间点
function Wedding:GetStartOpen(tbMapSetting)
	local nOpen = tbMapSetting.fnGetDate()
	local nStartOpen = 0
	if tbMapSetting.nStartDay then
		nStartOpen = tbMapSetting.fnGetDate(tbMapSetting.nStartDay)
	end
	return math.max(nOpen, nStartOpen)
end

function Wedding:NormalizeIds(nId1, nId2)
	if nId1>nId2 then
		nId1, nId2 = nId2, nId1
	end
	return nId1, nId2
end

function Wedding:GetNormalizedIdsKey(nPid1, nPid2)
	nPid1, nPid2 = Wedding:NormalizeIds(nPid1, nPid2)
	return string.format("%s_%s", nPid1, nPid2)
end

function Wedding:CheckProposeC(pPlayer, nPlayerId)
	if not Wedding:CheckOpenProposeTime() then
        return false, "Chưa mở"
    end
	if GetTimeFrameState(Wedding.szProposeTimeFrame) ~= 1 then
		return false, "Chưa mở"
	end
	if not Wedding:IsSingle(pPlayer) then
        return false, string.format("[FFFE0D]「%s」[-] đã kết hôn hoặc đã có đối tượng", pPlayer.szName)
    end
     if pPlayer.nLevel < Wedding.nProposeLevel then
		return false, string.format("[FFFE0D]「%s」[-] phải đạt cấp [FFFE0D]%d[-]", pPlayer.szName, Wedding.nProposeLevel)
	end
	 if not Map:IsCityMap(pPlayer.nMapTemplateId) and not Map:IsKinMap(pPlayer.nMapTemplateId) and not Map:IsHouseMap(pPlayer.nMapTemplateId) then
        return false, string.format("[FFFE0D]「%s」[-] Cảnh này không cho phép cầu hôn, hãy đến [FFFE0D]Vong Ưu Đảo, Thành Chính, Gia Viên, Lãnh Địa Bang Hội[-] tiến hành", pPlayer.szName)
    end
    if nPlayerId then
    	if not FriendShip:IsFriend(pPlayer.dwID, nPlayerId) then
            return false, "Chưa phải hảo hữu"
        end
	    local nImityLevel = FriendShip:GetFriendImityLevel(pPlayer.dwID, nPlayerId) or 0
		if nImityLevel < Wedding.nProposeImitity then
			return false, string.format("Cầu hôn cần thân mật đạt cấp [FFFE0D]%s[-]", Wedding.nProposeImitity)
		end
	end
	return true
end

function Wedding:CheckTimeFrame()
	if GetTimeFrameState(Wedding.szProposeTimeFrame) ~= 1 then
        local _, nOpenTime = TimeFrame:CalcRealOpenDay(Wedding.szProposeTimeFrame)
        local nNowDay = Lib:GetLocalDay()
        local nOpenDay = Lib:GetLocalDay(nOpenTime)
        return nOpenDay - nNowDay, nOpenTime
    end
end

function Wedding:CheckOpen(nLevel, nBookTime)
	if self.bForceOpen then
		return true
	end
	local nNowTime = GetTime()
	local nActStartTime, nActEndTime
	if MODULE_GAMESERVER then
		nActStartTime = Wedding.nOpenStartTime
		nActEndTime = Wedding.nOpenEndTime
	else
		nActStartTime, nActEndTime = Activity:__GetActTimeInfo("WeddingAct")
	end
	if not nActStartTime or not nActEndTime or nNowTime < nActStartTime or nNowTime >= nActEndTime then
		return false
	end

	if nLevel and nBookTime then
		local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
		if not tbMapSetting then
			return false
		end
		local nBook = tbMapSetting.fnGetDate(nBookTime)
		local nEndBook = tbMapSetting.fnGetDate(nActEndTime)
		local nStartBook = tbMapSetting.fnGetDate(nActStartTime)
		if nBook > nEndBook or nBook < nStartBook then
			return false, "Chưa thể đặt trước ngày này"
		end
	end

	if Wedding.nBookOpenDate then
		return nNowTime > Wedding.nBookOpenDate
	end
	return true
end

function Wedding:CheckOpenTime()
	local nStartHour, nStartMin = string.match(Wedding.nMarryOpenStart, "(%d+):(%d+)");
	local nEndHour, nEndMin = string.match(Wedding.nMarryOpenEnd, "(%d+):(%d+)");
	local nTodayTime = Lib:GetTodaySec();
	if nTodayTime < (nStartHour * 3600 + nStartMin * 60) or nTodayTime > (nEndHour * 3600 + nEndMin * 60) then
		return false, "Mỗi ngày, chỉ được cử hành hôn lễ vào lúc [FFFE0D]10:00-24:00[-]"
	end
	return true
end

-- 检查删除好友
function Wedding:CheckDelFriend(dwRoleId1, dwRoleId2)
	if self:IsEngaged(dwRoleId1, dwRoleId2) then
		return false, "Quan hệ đính hôn không thể xóa hảo hữu"
	end
	if self:IsLover(dwRoleId1, dwRoleId2) then
		return false, "Quan hệ kết hôn không thể xóa hảo hữu"
	end
	return true
end

function Wedding:GetCostItemInfo(szItem, bAward)
	local tbResult = {}
	local tbStrItem = Lib:SplitStr(szItem, "|")
	for _, szItemInfo in ipairs(tbStrItem) do
		local tbItem = Lib:SplitStr(szItemInfo, ";")
		local nItemId = tonumber(tbItem[1])
		local nCount = tonumber(tbItem[2])
		local tbInfo = {nItemId, nCount}
		if bAward then
			table.insert(tbInfo, 1, "item")
		end
		table.insert(tbResult, tbInfo)
	end
	return tbResult
end

function Wedding:GetWeddingMapLevel(nMapTID)
	return Wedding.tbAllWeddingMap[nMapTID]
end

function Wedding:CheckOpenProposeTime()
	local nNowTime = GetTime()
	return nNowTime > (Wedding.nProposeOpenDate or 0), "Chưa mở"
end
					
function Wedding:CheckVersion()
	Wedding.nProposeOpenDate = nil 															-- 开放订婚的时间
	local szProposeOpen
	if version_tx then
		szProposeOpen = Wedding.szOpenPropose_version_tx
	elseif version_vn then
		szProposeOpen = Wedding.szOpenPropose_version_vn
	elseif version_hk then
		szProposeOpen = Wedding.szOpenPropose_version_hk
	elseif version_xm then
		szProposeOpen = Wedding.szOpenPropose_version_xm
	elseif version_en then
		szProposeOpen = Wedding.szOpenPropose_version_en
	elseif version_kor then
		szProposeOpen = Wedding.szOpenPropose_version_kor
	elseif version_th then
		szProposeOpen = Wedding.szOpenPropose_version_th
	end
	if szProposeOpen then
		Wedding.nProposeOpenDate = Lib:ParseDateTime(szProposeOpen);
	end
	Log("Wedding fnCheckVersion ", Wedding.nProposeOpenDate or 0)
end

Wedding:CheckVersion()

function Wedding:CheckPromiseValid(szMsg)
	if version_kor then
		local nKorLen = string.len(szMsg);
		if nKorLen > Wedding.nKorPromiseMax or nKorLen < Wedding.nKorPromiseMin then
			return false, string.format("Lời hứa có độ dài từ %d-%d ký tự", Wedding.nKorPromiseMin, Wedding.nKorPromiseMax)
		end
	elseif version_vn then
		local nVNLen = string.len(szMsg);
		if nVNLen > Wedding.nVNPromiseMax or nVNLen < Wedding.nVNPromiseMin then
			return false, string.format("Lời hứa có độ dài từ %d-%d ký tự", Wedding.nVNPromiseMin, Wedding.nVNPromiseMax)
		end
	elseif version_th then
		local nNameLen = Lib:Utf8Len(szMsg);
		if nNameLen > Wedding.nTHPromiseMax or nNameLen < Wedding.nTHPromiseMin then
			return false, string.format("Lời hứa có độ dài từ %d-%d ký tự", Wedding.nTHPromiseMin, Wedding.nTHPromiseMax)
		end
	else
		local nNameLen = Lib:Utf8Len(szMsg);
		if nNameLen > Wedding.nPromiseMax or nNameLen < Wedding.nPromiseMin then
			return false, string.format("Lời hứa có độ dài từ %d-%d ký tự", Wedding.nPromiseMin, Wedding.nPromiseMax)
		end
		if Lib:HasNonChineseChars(szMsg) then
	        return false, "Lời hứa chỉ có thể dùng ký tự"
	    end
	end
	if ReplaceLimitWords(szMsg) then
		return false, "Lời hứa có nội dung không hợp lệ"
	end
	return true
end

function Wedding:GetMaxPromise()
	local nMaxPrimise =  Wedding.nPromiseMax
	if version_kor then
		nMaxPrimise = Wedding.nKorPromiseMax
	elseif version_vn then
		nMaxPrimise = Wedding.nVNPromiseMax
	elseif version_th then
		nMaxPrimise = Wedding.nTHPromiseMax
	end
	return nMaxPrimise
end