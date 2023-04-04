Require("CommonScript/EnvDef.lua")
Require("CommonScript/Item/Define.lua")
Require("CommonScript/InDifferBattle/InDifferScheNomal.lua")

InDifferBattle.tbRandSkillBook = {3434, 3435, 3436, 3437}; --分别对应四个位置的秘籍


InDifferBattle.tbClass = InDifferBattle.tbClass or {}

function InDifferBattle:CreateClass(szClass, szBaseClass)
	if szBaseClass and self.tbClass[szBaseClass] then
		self.tbClass[szClass] = Lib:NewClass(self.tbClass[szBaseClass])
	else
		self.tbClass[szClass] = {}
	end
	return self.tbClass[szClass]
end

function InDifferBattle:GetClass(szClassName)
  	return self.tbClass[szClassName]
end

function InDifferBattle:GetSettingTypeField( szBattleType, szFileName)
	--注意是否要获取必定有的，未默认初始化的
	if szBattleType then
		local tbBattleTypeSetting = InDifferBattle.tbBattleTypeSetting[szBattleType]
		local tbSetting = tbBattleTypeSetting[szFileName]
		if tbSetting then
			return tbSetting, tbBattleTypeSetting
    elseif tbBattleTypeSetting.szPreferType then
      local tbPrefer = InDifferBattle.tbBattleTypeSetting[tbBattleTypeSetting.szPreferType]
      local tbSetting = tbPrefer[szFileName] 
      if tbSetting then
        return tbSetting, tbPrefer
      end
		end
	end
	return self.tbDefine[szFileName], self.tbDefine
end

InDifferBattle.tbBattleTypeSetting = {
        Normal = { 
            bCostDegree = true;
            szName = "";
            NextType = "Month";
            szScroeDescHelpKey = "InDifferBattleScoreHelp";
            nMinTeamNum = 18; --最小队伍数
            szCalenddayKey = "InDifferBattle";
        };
        Month  = { 
            szName = "Tháng";
            NextType = "Season";
            szOpenTimeFrame = "OpenLevel109";
            nKeyQualifyTime = 7;
            nNeedGrade = 3; --进入月度的评级邀请
            nQualifyTitleId = 7703; --获取资格时获得的称号id

            szOpenTimeFunc = "GetNextOpenTimeMonth";
            OpenTimeWeek    = 1; --第一个周六
            OpenTimeWeekDay = 6;
            OpenTimeHour    = 20;
            OpenTimeMinute  = 25;
            tbLeagueTipMailInfo = {"Tâm Ma Ảo Cảnh Tháng", "       Đại hiệp nhận quyền tham gia Tâm Ma Ảo Cảnh Tháng lần này. Thời gian thi đấu [EACC00]%s[-], hãy đến đúng giờ. Nhiều phần thưởng và vinh dự đang chờ đại hiệp!"};
            szScroeDescHelpKey = "InDifferBattleScoreHelpMonth";
            nMinTeamNum = 12; --最小队伍数
            tbNotOpenAwardIndex  = 3 ; --未开启的补偿奖励,对应第三档，良好
            szNotOpenMailContent = "Đại hiệp thân mến,\nDo lần này số người tham gia Tâm Ma Ảo Cảnh quá ít nên hoạt động không thể mở. Dưới đây là phần thưởng đền bù cho tất cả đại hiệp bị ảnh hưởng. Rất mong đại hiệp lượng thứ."
        };
        Season = { 
            szName = "Quý";
            -- NextType = "Year";
            szOpenTimeFrame = "OpenLevel109";
            nKeyQualifyTime = 8;
            nNeedGrade = 3; 
            nQualifyTitleId = 7704;

            szOpenTimeFunc = "GetNextOpenTimeSeason";
            OpenTimeWeek    = -1; --最后一个周六
            OpenTimeWeekDay = 6;
            OpenTimeHour    = 20;
            OpenTimeMinute  = 25;
            tbLeagueTipMailInfo = {"Tâm Ma Ảo Cảnh Quý", "       Đại hiệp nhận quyền tham gia Tâm Ma Ảo Cảnh Quý lần này. Thời gian thi đấu [EACC00]%s[-], hãy đến đúng giờ. Nhiều phần thưởng và vinh dự đang chờ đại hiệp!"};
            szScroeDescHelpKey = "InDifferBattleScoreHelpMonth";
            nMinTeamNum = 12; --最小队伍数
            tbNotOpenAwardIndex  = 3 ;
            szNotOpenMailContent = "Đại hiệp thân mến,\nDo lần này số người tham gia Tâm Ma Ảo Cảnh quá ít nên hoạt động không thể mở. Dưới đây là phần thưởng đền bù cho tất cả đại hiệp bị ảnh hưởng. Rất mong đại hiệp lượng thứ."
        };

		JueDi = { --绝地版
          szTitle = "Tâm Ma Tuyệt Địa";
          szName = "Tuyệt Địa ";
          bCostDegree = true;
          szCalenddayKey = "InDifferBattleJuedi";
          NextType = "Month";
          szLogicClassName = "BattleBaseJueDi";
          szScroeDescHelpKey = "InDifferBattleScoreHelp";
          nMinTeamNum = 18; --最小队伍数
          nMaxRoomNum = 36; --不填的默认取的define里的设置
          szRandomRoomPosSetFilePath = "Setting/InDifferBattle/RandPosSetJueDi.tab";
          szRooomPosSettingFilePath = "Setting/InDifferBattle/RoomPosJueDi.tab";
          szNpcMovePathFilePath = "Setting/InDifferBattle/NpcPathJueDi.tab"; 
          GRID_SIZE = 120; --范围内只放一个采集npc
          szMonsterRefreshNotiy = "Hung Thú Thượng Cổ hiện xuất hiện ở phòng %d, hãy tránh xa!"; --上古凶兽出来前的提示
          nRefreshMonsterNpcId = 2908; --上古凶兽的npcid
          nReviveItemId     = 7623; -- 重生道具id
          nSafeGateNpcId = 2901; --非瘴气房间的蓝门
          nUnSafeGateNpcId = 2900; --瘴气房间的绿门
          nTempCastSKillNpcId = 2953 ; --释放机关陷阱技能召唤出来的npc
          tbGateNpcDirection = { --处在上下左右的门的朝向
              L = 64;
              B = 16;
              R = 64;
              T = 16;
          }; 
          tbGateNpcGapDistance = { --两个门的偏移
            L = { {0,200},{0,-200} };
            R = { {0,200},{0,-200} };
            B = { {200,0},{-200,0} };
            T = { {200,0},{-200,0} };
          }; 
          szReadyMapLeftKey = "InDifferBattleJuedi"; --准备场左边的key
          szGeneralHelp = "InDifferBattleJueDiHelp";--帮助问号的key
          --报名界面的说明
          szJoinIntro = [[
[FFFE0D]Giới thiệu:[-]
·[FFFE0D]Tâm Ma Tuyệt Địa[-] là cách chơi khác của Tâm Ma Ảo Cảnh.
·Tài nguyên trong Tuyệt Địa gồm [FFFE0D]sức mạnh[-], [FFFE0D]đạo cụ[-] và [FFFE0D]trạng thái[-], xuất hiện trong cảnh dưới hình thức bùa chú [FFFE0D]có thể thu thập[-].
·[FFFE0D]Thủ Lĩnh Ảo Thú[-] và [FFFE0D]Tâm Ma Ảo Tượng[-] trong Tuyệt Địa có [FFFE0D]Đá Hồi Sinh[-] có thể giúp đại hiệp chuyển nguy thành an.
·Tuyệt Địa có [FFFE0D]36[-] khu vực, chia làm 4 giai đoạn, mỗi giai đoạn kết thúc sẽ xuất hiện [FFFE0D]chướng khí[-] ở nhiều khu vực, ở trong đó sẽ chịu sát thương. Cuối cùng sẽ chỉ 1 khu vực không có chướng khí!
]];

		szChooseFactionTip = [[
*Nếu chưa chọn môn phái, ảo cảnh sau khi bắt đầu sẽ tự động chọn ngẫu nhiên
*Trong ảo cảnh chỉ có [FFFE0D]1 mạng[-], đội có nhiều thành viên sống sót nhất sẽ thắng
*Tránh khu vực chướng khí, thu thập tài nguyên từ do thám Tâm Ma Tuyệt Địa, diệt quái và 
 đánh bại đại hiệp khác để tăng sức mạnh
		]];
          tbReportUiStateName = {
            [2] = "Giai đoạn 1";
            [3] = "Giai đoạn 1";
            [4] = "Giai đoạn 2";
            [5] = "Giai đoạn 2";
            [6] = "Giai đoạn 3";
            [7] = "Giai đoạn 3";
            [8] = "Giai đoạn 4";
            [9] = "Giai đoạn 4";
          };
          nShowLeftTeamState = 1; --显示剩余队伍数的阶段
          nDeathDropNpcId = 2942; --玩家死亡后调出的宝箱npc class 需要是 IndifferDeathDropBox
          nDeathDropNpcAliveTime  = 180; --上面宝箱npc存活时间，秒为单位

          nFightMapTemplateId = 3003; --战斗场地图模板 --托管时间需要等于赛事时长
          nPlayerLevel      = 99; --变身后的等级
          szAvatarEquipKey  = "InDiffer"; --初始状态对应装备key ,对应配置在 Setting\Avatar\ 下
          nDefaultStrengthLevel = 40; --默认的强化等级
          nChangeFactionSkillCD = 150;--战斗中切换门派加上的技能cd
          nInitAddBuffId = 3182;--初始状态给的buffid ，等级， 时间（默认拥有一个-89100战力的buff）
          nInitAddBuffLevel = 2;
          nInitAddBuffTime = 3600;

          tbItemBagLNpcGridCount = { --行囊的配置信息 npc 对应的行囊信息
            [10000] = { nCount = 2, szDesc = "Mặc định"} ;
            [2897] = { nCount = 4, szDesc = "Sơ"} ;
            [2898] = { nCount = 6, szDesc = "Cao"} ;
          };
          nDefautItemBagNpcId = 10000; --初始默认的背包对应npcid

          tbFightPowerToTitle = {  --战力对应的称号
            { nTitleId  = 600,    nMinFightPower = 1500;  };
            { nTitleId  = 601,    nMinFightPower = 8000;  };
            { nTitleId  = 602,    nMinFightPower = 15000;  };
            { nTitleId  = 603,    nMinFightPower = 24000;  };
            { nTitleId  = 604,    nMinFightPower = 48000;  };
            { nTitleId  = 605,    nMinFightPower = 80000;  };
            { nTitleId  = 606,    nMinFightPower = 150000;  };
            { nTitleId  = 607,    nMinFightPower = 300000;  };
            { nTitleId  = 608,    nMinFightPower = 600000;  };
            { nTitleId  = 609,    nMinFightPower = 1200000;  };
            { nTitleId  = 610,    nMinFightPower = 2400000;  };
          };

          tbEnhanceNpcLevel = { --强化采集npcId对应强化等级
            [2886] = 50;
            [2887] = 70;
            [2888] = 80;
          };
          tbHorseNpcToEquipId = {  --坐骑采集npc对应坐骑装备id
            [2899] = 2400;
          };
          tbSkillBookNpc = { --秘籍采集npc对应装备的秘籍
            [2889] = { 1,2,3,4  }; -- 初级
            [2890] = {5,6,7,8   }; -- 中级
            [2891] = {9,10,11,12}; -- 高级
          };
          tbGatherGetItemNpc = { --物品采集npc对应获取道具id
            [2892] = 7594;  --金创药
            --[2893] = 7595;  --回天丹
            [2902] = 7596;  --隐身技能
            [2903] = 7597;  --陷阱技能

            [2894] = 7598;  --附魔攻击1
            [2895] = 7599;  --附魔攻击2
            [2896] = 7600;  --附魔攻击3
            [2916] = 7601;  --附魔防御1
            [2917] = 7602;  --附魔防御2
            [2918] = 7603;  --附魔防御3
            [2934] = 7624;  --附魔控制1
            [2935] = 7625;  --附魔控制2
            [2936] = 7626;  --附魔控制3

            [2937] = 7623;  --复活石
          };

          tbAddRandNpcGroup = { -- 流程里添加的npc ，1个组合里的npc 每次添加会随机里面一个npc
            [1] = { --门派
                    2885,
                  };
            [2] = { --行囊1：0
                    2897,
                    --2898,
                  };
            [3] = { --行囊2：1
                    2897,2897,
                    2898,
                  };
            [4] = { --行囊1：1
                    2897,
                    2898,
                  };     
            [5] = { --强化2：1：0
                    2886,2886,
                    2887,
                    --2888,
                  };
            [6] = { --强化2：1：1
                    2886,2886,
                    2887,
                    2888,
                  };
            [7] = { --强化0：2：1
                    --2886,2886,2886,2886,
                    2887,2887,
                    2888,
                  };
            [8] = { --秘籍2：1：0
                    2889,2889,
                    2890,
                    --2891,
                  };
            [9] = { --秘籍2：1：1
                    2889,2889,
                    2890,
                    2891,
                  };
            [10] = { --秘籍0：2：1
                    --2889,2889,2889,2889,
                    2890,2890,
                    2891,
                  };
            [11] = { --坐骑
                    2899,
                  };
            [12] = { --药品和技能1：1：1
                    2892,
                    2902,
                    2903,
                  };
            [13] = { --附魔石2：1：0
                    --攻击
                    2894,2894,
                    2895,
                    --2896,
                    --防御
                    2916,2916,
                    2917,
                    --2918,
                    --控制
                    2934,2934,
                    2935,
                    --2936,
                  };
            [14] = { --附魔石2：1：1
                    --攻击
                    2894,2894,
                    2895,
                    2896,
                    --防御
                    2916,2916,
                    2917,
                    2918,
                    --控制
                    2934,2934,
                    2935,
                    2936,
                  };
            [15] = { --附魔石0：2：1
                    --攻击
                    --2894,2894,2894,2894,
                    2895,2895,
                    2896,
                    --防御
                    --2916,2916,2916,2916,
                    2917,2917,
                    2918,
                    --控制
                    --2934,2934,2934,2934,
                    2935,2935,
                    2936,
                  };

            [16] = { --怪物
                    2096,
                    2097,
                    2098,
                    2099,
                    2100,
                  };
            [17] = { --复活石
                    2937,
                  };
          };
          tbAddRandRoomGroup = { --流程里添加的随机房间组合
            [1] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36}  --全房间

          };


          nChangeFactionNpcId = 2885; -- 门派采集物npc，class 是 IndifferChangeFaction
          nPosionGasSkillStateId  = 3193; --进入毒气房间时获得的毒气buffid，等级根据当前毒气等级
          nPosionGasStateTime = 3600; --毒气的持续时间

          tbBattleNpcDropSetting = { --小怪不同阶段掉落配置，0 是默认掉落配置
            [2] = {{0.1, 3, 120 }, { 0.05, 5, 120 }, { 0.05, 8, 120 }, { 0.2, 12, 120 }, { 0.1, 13, 120 }  }; --掉率概率, npcGroup, 存活时间秒
            [4] = {{0.1, 3, 120 }, { 0.05, 6, 120 }, { 0.05, 9, 120 }, { 0.2, 12, 120 }, { 0.1, 14, 120 }  };
            [6] = {{0.1, 3, 120 }, { 0.05, 6, 120 }, { 0.05, 9, 120 }, { 0.2, 12, 120 }, { 0.1, 14, 120 }  };
          };

        --掉落采集npc的随机奖励配置
        tbDrapList = {
            tbBossAward_2 = { --首领掉落
                { 0.1,  {"DropNpc", 17, 1, 240} }; --复活石
                { 0.1,  {"DropNpc", 1,  1, 240} };
                { 0.1,  {"DropNpc", 4,  1, 240} }; 
                { 0.15, {"DropNpc", 7,  1, 240} }; 
                { 0.15, {"DropNpc", 10, 1, 240} }; 
                { 0.15, {"DropNpc", 11, 1, 240} }; 
                { 0.15, {"DropNpc", 12, 1, 240} }; 
                { 0.1,  {"DropNpc", 15, 1, 240} }; 
            };
            tbSuperBoxAward_1 = { --幻象掉落
                { 0.07, {"DropNpc", 17, 1, 240} }; --复活石
                { 0.1,  {"DropNpc", 1,  1, 240} };
                { 0.1,  {"DropNpc", 3,  1, 240} }; 
                { 0.1,  {"DropNpc", 6,  1, 240} }; 
                { 0.1,  {"DropNpc", 9,  1, 240} }; 
                { 0.1,  {"DropNpc", 11, 1, 240} }; 
                { 0.22, {"DropNpc", 12, 1, 240} }; 
                { 0.21, {"DropNpc", 14, 1, 240} };
            };
        };

        tbSingleRoomNpc = {
        -- 对应单房间只会刷一种npc的配置，现在首领掉落里没有复活石的操作
            [2105] = {
                    nLevel = 90;
                    szName = "Thủ Lĩnh",
                    nRoomGroup = 1,   --房间组, 1是所有房间
                    szIcon = "DreamlandIcon3",  
                    bBoss = false; --是BOss 有*排名第1的队伍所有成员获得随机Buff 和 获得复活石的机制
                    szDropAwardList = {
                                         [2] = "tbBossAward_2"; --不同阶段对应的奖励配置key，在tbDrapList 里设置
                                         [4] = "tbBossAward_2"; --不同阶段对应的奖励配置key，在tbDrapList 里设置
                                         [6] = "tbBossAward_2"; --不同阶段对应的奖励配置key，在tbDrapList 里设置
                                      }; 
                    nDropAwardNum = 8; --随奖励的次数
                };
            [2101] = {
                    nLevel = 1;  --npc等级
                    nDir = 48,
                    szName = "Ảo Tượng",
                    nRoomGroup = 1,   --房间组
                    szIcon = "DreamlandIcon4",  
            }; 
            };

        tbItemUseFunc = { --道具使用后调用的函数
        	[7597] = {
        		{"OnBlackBoardMsg", "Bên cạnh có một Kim Sáng Dược giả!"}; --黑条提示
        		{"OnCallMapNpc", 2938}; --召唤的npcid
        	};
        };

        tbOpenBoxType     = { --打开宝箱Npc模板对应的事件类型， class对应 IndifferBox 
            [2101] = {  --幻象, 不同阶段开启对应的， 满概率是1
                      [0] = 
                      {   
                          { 1, { 
                                   {"OnAddRandNpcNearBy", "tbSuperBoxAward_1", 5, 8 }; --随机掉落5-8份奖励
                                   --{"OnSendAwardTeamAll", {{"RandBuff"}} };  --随机获得buff
                                },};
                      };
                    };  

            [2938] = {  --召唤伪装金创药陷阱技能
                      [0] = 
                      {
                        { 1, { 
                                  {"OnOpenBoxCastSkillCycle", -1, 3199, 50, -1, -1};  --对应位置释放循环技能，释放间隔（帧数，-1为只释放1次），技能Id，技能等级，参数1，参数2
                                  {"OnBlackBoardMsg", "Đáng ghét, Kim Sáng Dược này là cái bẫy!"}; --黑条提示
                              },};
                      };          
                    };
        };


          tbStateGetScore = { --每个阶段的存活得分 
		        [2] = { nSurviveScore = 1, nKillScore = 2 };
		        [3] = { nSurviveScore = 1, nKillScore = 2 };
		        [4] = { nSurviveScore = 2, nKillScore = 4 };
		        [5] = { nSurviveScore = 2, nKillScore = 4 };
            [6] = { nSurviveScore = 3, nKillScore = 6 };
            [7] = { nSurviveScore = 3, nKillScore = 6 };
            [8] = { nSurviveScore = 8, nKillScore = 8 };
		    };
          --绝地的流程
		STATE_TRANS = {
			[1] = {nSeconds = 90,     szFunc = "StartFight1",   szDesc = "Hãy chọn môn phái ban đầu trong ảo cảnh"}, 
			[2] = {nSeconds = 300,    szFunc = "DoNothing",     szDesc = "Do thám ảo cảnh"}, 
			[3] = {nSeconds = 60,     szFunc = "DoNothing",     szDesc = "Chướng khí sắp bao phủ",           szBeginNotify = "Chú ý: Chướng khí 60 giây sau sẽ bao phủ khu không an toàn!"}, 
			[4] = {nSeconds = 300,    szFunc = "DoNothing",     szDesc = "Do thám ảo cảnh",             szBeginNotify = "Khu an toàn mới đã tạo!"}, 
			[5] = {nSeconds = 60,     szFunc = "DoNothing",     szDesc = "Chướng khí sắp bao phủ",       szBeginNotify = "Chú ý: Chướng Khí 60 giây sau sẽ dày đặc và bao phủ khu không an toàn!"},
			[6] = {nSeconds = 300,    szFunc = "DoNothing",     szDesc = "Do thám ảo cảnh",           szBeginNotify = "Khu an toàn mới đã tạo!"},
			[7] = {nSeconds = 60,     szFunc = "DoNothing",     szDesc = "Chướng khí sắp bao phủ",     szBeginNotify = "Chú ý: Chướng Khí 60 giây sau sẽ dày đặc và bao phủ khu không an toàn!"},
			[8] = {nSeconds = 240,    szFunc = "StopFight",     szDesc = "Giai đoạn cuối: Diệt đối thủ khác",     szBeginNotify = "Diệt đối thủ khác, sống sót đến cùng!"}, 
			[9] = {nSeconds = 15,     szFunc = "CloseBattle",   szDesc = "Chờ thoát Ảo Cảnh"},
		};
    };

    ActJueDi = {
      bAct = true;
      szPreferType = "JueDi"; --没有的配置取 JueDi里面的
      szName = "Tuyệt Địa Thí Luyện";
      szTitle = "Tâm Ma Tuyệt Địa Thí Luyện";
      szRankboardKey = "ActJueDi";
      szActName = "JueDiAct";
      szCalenddayKey = "InDifferBattleJuediAct";
      szLogicClassName = "BattleBaseJueDiAct";
      szScroeDescHelpKey = "InDifferBattleScoreHelp";
      nMaxTeamRoleNum   = 1;      --最大队伍内人数
      nGetAwardCount = 3; --前多少次参与有个人奖励
      nCalTotolScoreNum = 3; --取积分最高的多少场算入总积分,现在只能是3，不然最终有效发奖会有问题
      FIRST_SIGNUP_TIME = 4*60; --第一次的匹配时间
      NEXT_SIGNUP_TIME = 10*60;--后面的匹配时间
      tbUiShowItemList = { --报名界面上展示的奖励
        {"Contrib", 0}, {"Energy",0}, {"Coin",0}, {"item",2804,0}
      };
      szJoinIntro = [[
[FFFE0D]Giới thiệu:[-]
·Trong kiểu [FFFE0D]Tâm Ma Tuyệt Địa cá nhân[-] người chơi phải tham gia báo danh [FFFE0D]một mình (Nếu là đội thì đội cũng chỉ được có 1 người)[-].
·Tài nguyên trong Tuyệt Địa gồm [FFFE0D]sức mạnh[-], [FFFE0D]đạo cụ[-] và [FFFE0D]trạng thái[-], xuất hiện trong cảnh dưới hình thức bùa chú [FFFE0D]có thể thu thập[-].
·[FFFE0D]Thủ Lĩnh Ảo Thú[-] và [FFFE0D]Tâm Ma Ảo Tượng[-] trong Tuyệt Địa có [FFFE0D]Đá Hồi Sinh[-] có thể giúp đại hiệp chuyển nguy thành an.
·Tuyệt Địa có [FFFE0D]36[-] khu vực, chia làm 4 giai đoạn, mỗi giai đoạn kết thúc sẽ xuất hiện [FFFE0D]chướng khí[-] ở nhiều khu vực, ở trong đó sẽ chịu sát thương. Cuối cùng sẽ chỉ 1 khu vực không có chướng khí!
      ]];
      szNewInfomation = [[
Tuyệt Địa Thí Luyện đã bắt đầu!
Thời gian: [c8ff00]%s-%s[-]
Trong thời gian hoạt động, chiều mỗi ngày có thể vào chiến trường [FFFE0D]Tâm Ma Tuyệt Địa[-] trong thời gian quy định mà không giới hạn số lần!
[FFFE0D]Tâm Ma Tuyệt Địa cá nhân[-] người chơi phải tham gia báo danh [FFFE0D]một mình (Nếu là đội thì là đội cũng chỉ được có 1 người)[-]
[FFFE0D]13:26[-] mỗi ngày mở báo danh trận 1, [FFFE0D]13:30[-] bắt đầu thi đấu trận 1, sau đó sau [FFFE0D]10 phút[-] chuẩn bị sẽ mở 1 trận đấu, [FFFE0D]15:50[-] mở báo danh trận cuối.
Tham gia [FFFE0D]3[-] lần đầu tiên trong ngày sẽ nhận thưởng. Trong thời gian hoạt động, sẽ lấy  số điểm trong [FFFE0D]3[-] lần thi đấu cao nhất và điểm phải khác [FFFE0D]0[-] làm căn cứ để phát thưởng tổng kết. Quy tắc thưởng như sau
1-5 điểm          2000 Nguyên Khí   10000 Bạc
6-15 điểm         4000 Nguyên Khí   20000 Bạc     
16-31 điểm       5000 Nguyên Khí   40000 Bạc    1 Hòa Thị Bích
32-47 điểm       6000 Nguyên Khí   50000 Bạc    3 Hòa Thị Bích
48-95 điểm       8000 Nguyên Khí   60000 Bạc    5 Hòa Thị Bích
96 điểm trở lên   10000 Nguyên Khí  80000 Bạc   8 Hòa Thị Bích
Khi kết thúc hoạt động, thành tích của [FFFE0D]3[-] lần thi đấu cao nhất sẽ được nhận [FFFE0D]3[-] phần thưởng theo quy tắc thưởng trên
[FFFE0D]Chú ý: Số lần tham gia Tuyệt Địa Thí Luyện không xung đột với Tâm Ma bình thường, không kích hoạt Vinh Dự Võ Lâm, không mở Lì Xì. [-]
      ]];
      szFianalMailContent = "Điểm cao nhất trong Tuyệt Địa Thí Luyện của đại hiệp lần này là %s, đây là phần thưởng, xin hãy nhận."; --最终排名的奖励邮件
      nRankAwardNum = 1000; --能有最终积分奖励的排名数
      tbFinnalAwardSetting = {
        --从高到低
        { nScoreMin = 96,   tbAward = {{"item",10157, 1} } }; 
        { nScoreMin = 48,   tbAward = {{"item",10158, 1} } }; 
        { nScoreMin = 32,   tbAward = {{"item",10159, 1} } };
        { nScoreMin = 16,   tbAward = {{"item",10160, 1} } }; 
        { nScoreMin = 6,   tbAward =  {{"item",10183, 1} } };
        { nScoreMin = 1,   tbAward =  {{"item",10184, 1} } };  
      };
    };
};
--------------以上为绝地版流程-------------------

InDifferBattle.tbBattleTypeList = { "Normal", "JueDi","Month","Season", "ActJueDi"}; --资格赛从低到高的顺序
for i,v in ipairs(InDifferBattle.tbBattleTypeList) do
    InDifferBattle.tbBattleTypeSetting[v].nLevel = i;
end

InDifferBattle.tbDefine = {
    szTitle = "Tâm Ma Ảo Cảnh";
    SAVE_GROUP = 118;
    KEY_CUR_HONOR = 3;
    KEY_WIN_TIMES = 6; --暂时只是记获胜次数
    KEY_USE_FACTION = 10; --记录使用门派的bit，不超过32

    UPDATE_SYNC_DMG_INTERVAL = 10; --更新实时伤害排行间隔
    szDmgUiTips = "Quy tắc phần thưởng:\n· Đội Top 3 sát thương được nhận thưởng\n· Thưởng liên quan đến xếp hạng\n· Kết liễu được thưởng thêm"; --打开伤害输出界面的提示
    szDmgUiTipsBoss = "Quy tắc phần thưởng:\n· Đội Top 5 sát thương được nhận thưởng\n· Thưởng liên quan đến xếp hạng\n· Kết liễu được thưởng thêm"; --打开伤害输出界面的提示
    szMonoeyType = "Jade",--幻玉直接使用已经废弃的 Jade 货币了
    szOpenTimeFrame = "OpenDay118"; --开启的时间轴，开启累积次数
    nPreTipTime = 2 * 24 * 3600;            -- 开赛前提示，提前时间


    nShowAroundNpcDistance = 500; --显示周围的可点击npc列表
    szLogicClassName = "BattleBaseNormal";
    szCalenddayKey = "InDifferBattle"; --日历的key
    nReadyMapTemplateId = 3002; --准备场地图模板
    nFightMapTemplateId = 3001; --战斗场地图模板 --托管时间需要等于赛事时长
    MATCH_SIGNUP_TIME   = 5*60; --匹配时间
    nMinLevel     = 50;     --最小参与等级
    nMaxTeamRoleNum   = 3;      --最大队伍内人数
    nMinTeamNum       = 18;  --最小队伍数
    nMaxTeamNum       = 36;  --最大队伍数
    nPlayerLevel      = 80; --调整后的等级
    nCloseRoomPunishPersent = 0.9; -- 关闭房间时设置该房间玩家的血量百分比（掉当前血量的10%）
    nCloseRoomSkillId = 3083; --关闭房间时播放的技能特效
    nInitAddBuffId = 3182;--初始状态给的buffid ，等级， 时间（默认拥有一个-89100战力的buff）
    nInitAddBuffLevel = 1;
    nInitAddBuffTime = 3600;

    nReviveItemId     = 3309; -- 重生道具id
    nReviveDelayTime  = 20; --死亡延迟复活时长，帧数
    nReviveEffectSkillId = 3084; --死亡重生的技能效果id
    tbReviveSafeBuff = { 1517, 45 }; --复活时保护buff, 状态时间帧数
    szAvatarEquipKey  = "InDiffer"; --初始状态对应装备key
    tbKillGetMoneyRand = { 30, 50, 5};--抢夺幻玉的数量 30%~50%，最少抢夺5幻玉
    tbKillGetItemNumRand = { 30, 50 };--随机抢夺的道具数量 30%~50%
    nTempCastSKillNpcId = 2113 ; --释放机关陷阱技能召唤出来的npc
    nGateNpcId  = 73;--门的npcID
    tbGateDirectionModify = {
        LeftNpc   = { 0, -1};
        RightNpc  = { 0,  1};
        TopNpc    = {-1,  0};
        BottomNpc = {1,  0};
    };
    tbRowColModify = {
        L  = { 0, -1};
        R  = { 0,  1};
        T  = {-1,  0};
        B  = {1,  0};
    };
    szReadyMapLeftKey = "InDifferBattle"; --准备场左边的key
    szGeneralHelp = "InDifferBattleHelp";--帮助问号的key
    szJoinIntro = [[
Giới thiệu: 
·[FFFE0D]Đội 3 người[-] liên server thi đấu không cách biệt, đại hiệp [FFFE0D]Lv50[-] trở lên có thể tham gia.
·Trong ảo cảnh tất cả đại hiệp cố định [FFFE0D]Lv80, không mang theo đồng hành, lúc đầu có lực chiến ngang nhau[-], sẽ chọn [FFFE0D]ngẫu nhiên 1 trong 6 môn phái[-] sau khi ảo cảnh bắt đầu.
·[FFFE0D]Mở Bảo Rương, diệt quái nhỏ và đại hiệp khác[-] để nhận tài nguyên tăng sức mạnh.
·Mỗi đại hiệp trong ảo cảnh chỉ có [FFFE0D]1 mạng[-], phối hợp đồng đội rất quan trọng.
·Ảo cảnh có 25 khu vực, chia làm 4 giai đoạn, kết thúc giai đoạn sẽ nghỉ ngơi và đóng nhiều khu vực. Giai đoạn 4 sẽ quyết chiến ở khu vực cuối cùng, dựa vào [FFFE0D]số người sống sót, tổng điểm, tổng lực chiến của đội[-] sẽ xác định đội thắng.
]];

	szChooseFactionTip = [[
*Nếu chưa chọn môn phái, ảo cảnh sau khi bắt đầu sẽ tự động chọn ngẫu nhiên
*Tất cả đại hiệp cố định [FFFE0D]Lv80, không mang theo đồng hành, ban đầu có lực chiến ngang nhau[-]
*[FFFE0D]Mở Bảo Rương, diệt quái nhỏ, diệt đại hiệp khác[-] để nhận tài nguyên tăng sức mạnh
*Trong ảo cảnh chỉ có [FFFE0D]1 mạng[-], đội có nhiều thành viên sống sót nhất sẽ thắng
		]];

    tbUiShowItemList = { --报名界面上展示的奖励
      {"Item", 3469, 1},
      {"Item", 3468, 1},
      {"Item", 3467, 1},
      {"Item", 3494, 1},
      {"Item", 3854, 1},
      {"Contrib", 0},
    };
    nChangeParamToQueueInterval = 8;--处理选门派变身操作的cd，也是间隔检查所有选择玩家的cd

    tbCastSkillNpcPos = { --每个房间释放技能的npc所在的位置 ，一般在地图外的region，玩家不能主动同步到
        [1]  = {293,294};
        [2]  = {293,294};
        [3]  = {293,294};
        [4]  = {293,294};
        [5]  = {293,294};
        [6]  = {293,294};
        [7]  = {293,294};
        [8]  = {293,294};
        [9]  = {293,294};
        [10] = {293,294};
        [11] = {293,294};
        [12] = {293,294};
        [13] = {293,294};
        [14] = {293,294};
        [15] = {293,294};
        [16] = {293,294};
        [17] = {293,294};
        [18] = {293,294};
        [19] = {293,294};
        [20] = {293,294};
        [21] = {293,294};
        [22] = {293,294};
        [23] = {293,294};
        [24] = {293,294};
        [25] = {293,294};
    };

    tbStateGetScore = { --每个阶段的存活得分 
        [2] = { nSurviveScore = 2, nKillScore = 2 };
        [4] = { nSurviveScore = 4, nKillScore = 4 };
        [6] = { nSurviveScore = 6, nKillScore = 6 };
        [8] = { nSurviveScore = 8, nKillScore = 8 };
    };

    tbWinTeamAddScore = { 60, 40  }; --优胜分，存活\死亡

    tbLastSwitchRandPosSet = { "center", "center_2", "center_3", "center_4", "center_5", "center_6", "center_7", "center_8" };--最后阶段传送的随机点名 TODO 检查里面都在一房间里的
    tbLastSkillBuff = { 1517,1,5*15 };--技能id，等级，帧数（最后一阶段开始时无敌5秒）
    tbFirstSkillBuff = { 1517,1,15*15 };--技能id，等级，帧数（第一阶段开始时无敌8秒）

    nSafeStateSkillBuffId = 1517;   --休息阶段的保护状态

    tbOpenBoxType     = { --打开宝箱Npc模板对应的事件类型， class对应 IndifferBox 
        [1994] = {  --宝箱，不同阶段 不同的概率事件
                    [2] = 
                    {   
                        { 0.2, { 
                                 {"OnOpenBoxCastSkillCycle", -1, 3183, 1, -1, -1};  --对应位置释放循环技能，释放间隔（帧数，-1为只释放1次），技能Id，技能等级，参数1，参数2
                                 {"OnBlackBoardMsg", "Rương trống! Thôi rồi, Ảo Cảnh Cơ Quan xuất hiện."}; --黑条提示
                               },};
                        { 0.8, { 
                                 {"OnSendRandDropAwardToTeam", "tbBoxAward_1", 2, 4 }; --随机赠送2-4 份奖励表给全队伍
                               },};
                    };
                    [4] = 
                    {   
                        { 0.2, { 
                                     {"OnOpenBoxCastSkillCycle", -1, 3183, 1, -1, -1}; 
                                     {"OnBlackBoardMsg", "Rương trống! Thôi rồi, Ảo Cảnh Cơ Quan xuất hiện."}; 
                                 },};
                        { 0.8, { 
                                    {"OnSendRandDropAwardToTeam", "tbBoxAward_2", 2, 4 }; 
                                  },};
                    };
                    [6] = 
                    {   
                        { 0.2, { 
                                     {"OnOpenBoxCastSkillCycle", -1, 3183, 1, -1, -1}; 
                                     {"OnBlackBoardMsg", "Rương trống! Thôi rồi, Ảo Cảnh Cơ Quan xuất hiện."}; 
                                 },};
                        { 0.8, { 
                                    {"OnSendRandDropAwardToTeam", "tbBoxAward_3", 2, 4 }; 
                               },};
                    };
                 };  

        [2101] = {  --幻象
                    [2] = 
                    {   
                        { 1, { 
                                 {"OnSendRandDropAwardToTeam", "tbSuperBoxAward_1", 6, 10 }; --随机赠送6-10 份奖励表给全队伍
                                 {"OnSendAwardTeamAll", {{"RandBuff"}} };  --随机获得buff
                                 {"OnAddRandPosNpcSet", 1994, 1, 4, 6 };--再该npc周围随机放一波箱子，templateid, nlevel, nRandMin, nRandMax
                            },};
                    };
                    [4] = 
                    {   

                        { 1, { 
                                 {"OnSendRandDropAwardToTeam", "tbSuperBoxAward_2", 6, 10 };
                                 {"OnSendAwardTeamAll", {{"RandBuff"}} }; 
                                 {"OnAddRandPosNpcSet", 1994, 1, 4, 6 };
                            },};
                    };
                    [6] = 
                    {   
    
                        { 1, { 
                                 {"OnSendRandDropAwardToTeam", "tbSuperBoxAward_3", 6, 10 };
                                 {"OnSendAwardTeamAll", {{"RandBuff"}} }; 
                                 {"OnAddRandPosNpcSet", 1994, 1, 4, 6 };
                            },};
                    };
                 };  
    }; 

    tbAutoDeleteWhenStateChangeNpc = { --阶段变化时会自动删除的npc模板
        [1994] = 1; --宝箱，因为宝箱是有可能事件里开出来的，容易漏配存活时间
    };  

    tbBattleNpcDropSettingItem = { --小怪的掉落表 先不用了
        --{203,  500  }; --道具id， 随机值，总值10000
    };

    tbBattleNpcDropSetting = { --小怪掉落的货币范围,等概率
        [2] = {{ "RandMoney", 8, 16 }, { "RandItemCount", 3299, 2,4  }  }; --阶段对应奖励
        [4] = {{ "RandMoney", 15, 25 },{ "RandItemCount", 3299, 4,6  } };
        [6] = {{ "RandMoney", 32, 40 },{ "RandItemCount", 3299, 6,12 } };
    };

    tbRandBuffSet = {  --随机buff配置表 ，目前是所有buff等概率的
        --回血：30%
        { 3166, 1, 5*15 }; --buffid ,等级，持续帧数
        { 3166, 1, 5*15 };
        { 3166, 1, 5*15 };
        { 3166, 1, 5*15 };
        { 3166, 1, 5*15 };
        { 3166, 1, 5*15 };
        --攻击力：15%
        { 3167, 1, 60*15*3 };
        { 3167, 1, 60*15*3 };
        { 3167, 1, 60*15*3 };
        --全抗：15%
        { 3168, 1, 60*15*3 };
        { 3168, 1, 60*15*3 };
        { 3168, 1, 60*15*3 };
        --跑速：15%
        { 3169, 1, 60*15*3 };
        { 3169, 1, 60*15*3 };
        { 3169, 1, 60*15*3 };
        --会心：15%
        { 3191, 1, 60*15*3 };
        { 3191, 1, 60*15*3 };
        { 3191, 1, 60*15*3 };
        --无敌：10%
        { 3192, 1, 15*15 };
        { 3192, 1, 15*15 };
    };

    nLastDmgBossHPPercent = 15; --首领  的最后一击加成百分比
    nLastDmgBigBossHPPercent = 10; --boos的最后一击加成

    READY_MAP_POS = {       -- 准备场的随机点
        {2706,5659}; 
        {2666,6319}; 
        {2684,5001}; 
        {6931,5712}; 
        {6947,6462}; 
        {6947,4994}; 
    };     

    tbRandMoney = { 5 , 15 }; --随机给的勾玉范围
    nDefaultStrengthLevel = 40; --默认的强化等级
    nStrengthStep = 10; --每次强化级别
    nEnhanceItemId = 3299; --强化水晶道具id
    tbEnhanceScroll = {
        { szDesc = "Vũ Khí", tbEquipPos = { Item.EQUIPPOS_WEAPON}, tbEnhanceCost = { [50] = 5, [60] = 10, [70] = 20, [80] = 40, [90] = 80, [100] = 160}}; --tbEnhanceCost 对应强化等级和消耗
        { szDesc = "Áo", tbEquipPos = {Item.EQUIPPOS_BODY},   tbEnhanceCost = { [50] = 3, [60] = 6,  [70] = 12, [80] = 24, [90] = 48, [100] = 96} };
        { szDesc = "Trang sức", tbEquipPos = { Item.EQUIPPOS_NECKLACE, Item.EQUIPPOS_RING, Item.EQUIPPOS_PENDANT, Item.EQUIPPOS_AMULET }, tbEnhanceCost = { [50] = 8, [60] = 16, [70] = 32, [80] = 64, [90] = 128, [100] = 256} };
        { szDesc = "Phòng cụ", tbEquipPos = {Item.EQUIPPOS_HEAD, Item.EQUIPPOS_CUFF, Item.EQUIPPOS_BELT, Item.EQUIPPOS_FOOT }, tbEnhanceCost = { [50] = 4, [60] = 8, [70] = 16, [80] = 32, [90] = 64, [100] = 128 } };
    }; 

    --坐骑进化卷轴class 是 IndifferScrollHorse
    tbHorseUpgrade = { 2400, 3012 };
    --秘籍进化道具class 是 IndifferScrollBook
    nMaxSkillBookType = 1; --最大使用中级秘籍

    tbInitGiveItem = {  --初始随机给的道具 ,总概率值10000
      {7000, {"RandItemCount", 3299, 3,5 } };  --随机水晶
      {500,  { "item", 2400, 1 } }; --随机值, 类型，道具id，个数，
      {2000, { "SkillBook", 0 } }; --门派秘籍 ,0是随机，否则是对应的type
      {500,  { "item", 1391, 1 }}; 
    };

    nMaxRoomNum = 25;
    nShowLeftTeamState = 1; 
    szRandomRoomPosSetFilePath = "Setting/InDifferBattle/RandPosSet.tab";
    szRooomPosSettingFilePath = "Setting/InDifferBattle/RoomPos.tab";
    szNpcMovePathFilePath = "Setting/InDifferBattle/NpcPath.tab";



    -----------奖励
    tbExChangeBoxInfo = 
    {
        {3481,  2000, "Rương Hoàng Kim Ảo Cảnh"}, --荣誉兑换的黄金宝箱id, 所需要的荣誉
        {3482, 1000, "Rương Bạch Ngân Ảo Cảnh"} , --白银宝箱Id，需要荣誉
    },
    tbGetHonorSetting = {  --积分获得对应荣誉设定
        { nScoreMin = 0,   
                            tbAwardNormal = { {"IndifferHonor", 1200}, { "BasicExp", 50 } }; 
                            tbAwardJueDi = { {"IndifferHonor", 1200}, { "BasicExp", 50 } }; 
                            tbAwardMonth = { {"IndifferHonor", 4000}, { "BasicExp", 50 } }; 
                            tbAwardSeason = { {"IndifferHonor", 8000}, { "BasicExp", 50 } }; 
                            tbAwardYear = { {"IndifferHonor", 4000}, { "BasicExp", 50 } };    
                            tbAwardActJueDi = { { "BasicExp", 20 } };    
                            };
        { nScoreMin = 6,   
                            tbAwardNormal = { {"IndifferHonor", 1500}, { "BasicExp", 60 } }; 
                            tbAwardJueDi = { {"IndifferHonor", 1500}, { "BasicExp", 60 } }; 
                           tbAwardMonth = { {"IndifferHonor", 6000}, { "BasicExp", 60 } }; 
                           tbAwardSeason = { {"IndifferHonor", 12000}, { "BasicExp", 60 } }; 
                           tbAwardYear = { {"IndifferHonor", 6000}, { "BasicExp", 60 } };  
                           tbAwardActJueDi = { { "BasicExp", 40 } };    
                           };
        { nScoreMin = 16,  
                            tbAwardNormal = { {"IndifferHonor", 2000}, { "BasicExp", 70 } }; 
                            tbAwardJueDi = { {"IndifferHonor", 2000}, { "BasicExp", 70 } }; 
                           tbAwardMonth = { {"IndifferHonor", 8000}, { "BasicExp", 70 } }; 
                           tbAwardSeason = { {"IndifferHonor", 16000}, { "BasicExp", 70 } };
                           tbAwardYear = { {"IndifferHonor", 8000}, { "BasicExp", 70 } };    
                           tbAwardActJueDi = { { "BasicExp", 50 } };    
                           };
        { nScoreMin = 32,  
                            tbAwardNormal = { {"IndifferHonor", 2500}, { "BasicExp", 80 } }; 
                            tbAwardJueDi = { {"IndifferHonor", 2500}, { "BasicExp", 80 } }; 
                           tbAwardMonth = { {"IndifferHonor", 10000}, { "BasicExp", 80 } };
                           tbAwardSeason = { {"IndifferHonor", 20000}, { "BasicExp", 80 } }; 
                           tbAwardYear = { {"IndifferHonor", 10000}, { "BasicExp", 80 } };    
                           tbAwardActJueDi = { { "BasicExp", 60 } };    
                           };
        { nScoreMin = 48,  
                            tbAwardNormal = { {"IndifferHonor", 3000}, { "BasicExp", 100 } };
                            tbAwardJueDi = { {"IndifferHonor", 3000}, { "BasicExp", 100 } };
                           tbAwardMonth = { {"IndifferHonor", 12000}, { "BasicExp", 100 } };
                           tbAwardSeason = { {"IndifferHonor", 24000}, { "BasicExp", 100 } };
                           tbAwardYear = { {"IndifferHonor", 12000}, { "BasicExp", 100 } };   
                           tbAwardActJueDi = { { "BasicExp", 80 } };    
                           };
        { nScoreMin = 96,  
                            tbAwardNormal = { {"IndifferHonor", 4000}, { "BasicExp", 100 } };
                            tbAwardJueDi = { {"IndifferHonor", 4000}, { "BasicExp", 100 } };
                           tbAwardMonth = { {"IndifferHonor", 16000}, { "BasicExp", 100 } };
                           tbAwardSeason = { {"IndifferHonor", 32000}, { "BasicExp", 100 } };
                           tbAwardYear = { {"IndifferHonor", 16000}, { "BasicExp", 100 } };    
                           tbAwardActJueDi = { { "BasicExp", 100 } };    
                           };
    };

    tbWinnerAward = { --最后优胜者的额外奖励：特殊称号，持续3个月
        tbAwardSeason = { {"AddTimeTitle", 7706, 3600 * 24 * 30 * 3} };
    };

    tbEvaluationSetting = { --积分对应评价
        { nScoreMin = 0,  szName = "Thường", szColor = "FFFFFF"   };
        { nScoreMin = 6,  szName = "Thường", szColor = "64db00"   };
        { nScoreMin = 16, szName = "Tốt", szColor = "11adf6"   };
        { nScoreMin = 32, szName = "Ưu Tú", szColor = "aa62fc"   };
        { nScoreMin = 48, szName = "Trác Việt", szColor = "ff578c"   };
        { nScoreMin = 96, szName = "Hoàn Mỹ", szColor = "ff8f06"   };
    };

    tbAddImitySetting = {  --增加亲密度
        [0] = 100; --最终存活
        [2] = 60;
        [4] = 70;
        [6] = 80;
        [8] = 90;
        [12] = 120; --优胜
    };

    --战报上显示的阵亡阶段信息
    tbReportUiStateName = {
      [2] = "Giai đoạn 1";
      [4] = "Giai đoạn 2";
      [6] = "Giai đoạn 3";
      [8] = "Giai đoạn 4";
    };
    
    ------------------商人设置
     --不能买到的也要配置以获取价格
    nSelllPricePercent = 0.5;--出售价格目前为0.5 * nPrice
    nCanBuyDistance = 500; --距离商人购买的最远距离
    tbSellWareSetting = {
        --强化水晶
        [3299] = { nPrice = 4,  nSort = 1  }, 

        --2级附魔石
        [1392] = { nPrice = 60, nSort = 2  }, 
        --1级附魔石
        [1391] = { nPrice = 16, nSort = 3  }, 
        --乌云踏雪
        [2400] = { nPrice = 24, nSort = 4  }, 

        --随机门派秘籍
        [3434] = { nPrice = 20, nSort = 5  }, 
        [3435] = { nPrice = 20, nSort = 6  }, 
        [3436] = { nPrice = 20, nSort = 7  }, 
        [3437] = { nPrice = 20, nSort = 8  }, 

        --坐骑进阶卷轴
        [3307] = { nPrice = 30, nSort = 9  }, 
        --秘籍进阶卷轴
        [3308] = { nPrice = 90, nSort = 10  }, 

    };
    ----商人不同刷新道具设置设定 TODO 出售道具的价格设定检查
    tbSellWarePropSetting = { 
        --第一阶段
        [2] = { 
                { 3299, 300, 600, }; --道具id， 随机最小，最大
                { 2400, 4, 10, };  --乌云踏雪
                { InDifferBattle.tbRandSkillBook, 12, 20, }; --table 的话就先从table里随机 
                { 1391, 4, 10, };  --1级附魔石
              };

        --第二阶段
        [4] = {
                { 3299, 300, 600, };
                { 2400, 2, 4, };  --乌云踏雪
                { 3307, 1, 2, }; 
                { InDifferBattle.tbRandSkillBook, 4, 8, }; --随机门派秘籍
                { 3308, 2, 4, }; 
                { 1391, 2, 4, };  --1级附魔石
                { 1392, 1, 2, };  --2级附魔石
              };

        --第三阶段
        [6] = {
                { 3299, 300, 600, };
                { 2400, 2, 4, };  --乌云踏雪
                { 3307, 2, 4, }; 
                { InDifferBattle.tbRandSkillBook, 4, 8, }; --随机门派秘籍
                { 3308, 4, 8, }; 
                { 1391, 2, 4, };  --1级附魔石
                { 1392, 2, 4, };  --2级附魔石
              };
    };


    ------------------流程 
    STATE_TRANS = {
        [1] = {nSeconds = 90,     szFunc = "StartFight1",   szDesc = "Chọn phái trong Ảo Cảnh "}, 
        [2] = {nSeconds = 360,    szFunc = "ResetTime",     szDesc = "1: Do Thám Ảo Cảnh", szBeginNotify = "Do thám Ảo Cảnh tăng sức mạnh, sống sót đến cùng!"}, 
        [3] = {nSeconds = 90,     szFunc = "ReStartFight",  szDesc = "Nghỉ ngơi",         szBeginNotify = "Giai đoạn này cấm chiến đấu, có thể đến chỗ Thương Nhân mua vật phẩm!"}, 
        [4] = {nSeconds = 360,    szFunc = "ResetTime",     szDesc = "2: Do Thám Ảo Cảnh", szBeginNotify = "Ảo Cảnh biến hóa khôn lường, cổng của một số khu vực đã đổ sụp!"}, 
        [5] = {nSeconds = 90,     szFunc = "ReStartFight",  szDesc = "Nghỉ ngơi",         szBeginNotify = "Giai đoạn này cấm chiến đấu, có thể đến chỗ Thương Nhân mua vật phẩm!"}, 
        [6] = {nSeconds = 360,    szFunc = "ResetTime",     szDesc = "3: Do Thám Ảo Cảnh", szBeginNotify = "Ảo Cảnh biến hóa khôn lường, cổng của một số khu vực đã đổ sụp!"}, 
        [7] = {nSeconds = 90,     szFunc = "ReStartFight",  szDesc = "Nghỉ ngơi",         szBeginNotify = "Giai đoạn này cấm chiến đấu, có thể đến chỗ Thương Nhân mua vật phẩm!"}, 
        [8] = {nSeconds = 240,    szFunc = "StopFight",     szDesc = "Giai đoạn 4: Diệt đối thủ khác",     szBeginNotify = "Diệt đối thủ khác, sống sót đến cùng!"}, 
        [9] = {nSeconds = 60,     szFunc = "CloseBattle",   szDesc = "Chờ thoát Ảo Cảnh"},
    };
    ActiveTrasn = InDifferBattle.tbActiveTransNormal;
    

    --客户端指定阶段时间会执行的函数 这里是剩余时间， 上面的是逝去时间区分下！！
    -- 由于卡帧和同步原因是有可能错过的，放不重要的客户端检测函数
    tbActiveTransClient = {
        [3] = {  
            [30] = { szFunc = "CheckNotSafeRoom",        tbParam = {  }  }; 
            [20] = { szFunc = "CheckNotSafeRoom",        tbParam = {  }  }; 
            [10] = { szFunc = "CheckNotSafeRoom",        tbParam = {  }  }; 
            [2] =  { szFunc = "ShowRoomCloseEffect", tbParam = {  }  }; 
        };
        [5] = 
        {
            [30] = { szFunc = "CheckNotSafeRoom",        tbParam = {  }  }; 
            [20] = { szFunc = "CheckNotSafeRoom", tbParam = {  }  }; 
            [10] = { szFunc = "CheckNotSafeRoom", tbParam = {  }  }; 
            [2] =  { szFunc = "ShowRoomCloseEffect", tbParam = {  }  }; 
        };
        [7] = 
        {
            [30] = { szFunc = "CheckNotSafeRoom",        tbParam = { }  }; 
            [20] = { szFunc = "CheckNotSafeRoom", tbParam = {  }  }; 
            [10] = { szFunc = "CheckNotSafeRoom", tbParam = {  }  }; 
            [2] =  { szFunc = "ShowRoomCloseEffect", tbParam = {  }  }; 
        };
    };

    --宝箱，幻象，boss，首领的掉落表
    tbDrapList = {
        --阶段1的普通宝箱奖励
        tbBoxAward_1 = {
            { 0.625, {"RandItemCount", 3299, 2,4  } }; --随机水晶
            { 0.025, {"item", 2400, 1} };  --乌云踏雪
            { 0.075, {"SkillBook", 0} }; --随机门派秘籍
            { 0.025, {"item", 1391, 1} };  --1级附魔石
            { 0.25,  {"RandMoney", 15, 25} }; --随机的勾玉
        };

        --阶段2的普通宝箱奖励
        tbBoxAward_2 = {
            { 0.71,   {"RandItemCount", 3299, 4,8  } }; --随机水晶
            { 0.015,  {"item", 2400, 1} }; --乌云踏雪
            { 0.0075, {"item", 3307, 1} };
            { 0.05,   {"SkillBook", 0}  }; --随机门派秘籍
            { 0.025,  {"item", 3308, 1} };
            { 0.015,  {"item", 1391, 1} };  --1级附魔石
            { 0.0075, {"item", 1392, 1} };  --2级附魔石
            { 0.17,   {"RandMoney", 20, 40} }; --随机的勾玉
        };

        --阶段3的普通宝箱奖励
        tbBoxAward_3 = {

            { 0.625, {"RandItemCount", 3299, 8,16  } }; --随机水晶
            { 0.025, {"item", 3307, 1} };
            { 0.075, {"item", 3308, 1} };
            { 0.025, {"item", 1392, 1} };  --2级附魔石
            { 0.25,  {"RandMoney", 30, 60} }; --随机的勾玉
        };

        --阶段1的首领掉落奖励
        tbLeaderAward_1 = {
            { 0.6,  {"RandItemCount", 3299, 2,4  } }; --随机水晶
            { 0.02, {"item", 2400, 1} }; --乌云踏雪
            { 0.06, {"SkillBook", 0}  }; --随机门派秘籍
            { 0.02, {"item", 1391, 1} };  --1级附魔石
            { 0.3,  {"RandMoney", 15, 25} }; --随机的勾玉
        };

        --阶段2的首领掉落奖励
        tbLeaderAward_2 = {
            { 0.592, {"RandItemCount", 3299, 4,8  } }; --随机水晶
            { 0.016, {"item", 2400, 1} }; --乌云踏雪
            { 0.008, {"item", 3307, 1} };
            { 0.04,  {"SkillBook", 0}  }; --随机门派秘籍
            { 0.02,  {"item", 3308, 1} };
            { 0.016, {"item", 1391, 1} };  --1级附魔石
            { 0.008, {"item", 1392, 1} };  --2级附魔石
            { 0.3,   {"RandMoney", 20, 40} }; --随机的勾玉
        };

        --阶段3的首领掉落奖励
        tbLeaderAward_3 = {
            { 0.6,  {"RandItemCount", 3299, 8,12  } }; --随机水晶
            { 0.02, {"item", 3307, 1} };
            { 0.06, {"item", 3308, 1} };
            { 0.02, {"item", 1392, 1} };  --2级附魔石
            { 0.3,  {"RandMoney", 40, 80} }; --随机的勾玉
        };

        --阶段1的幻象奖励
        tbSuperBoxAward_1 = {
            { 0.6,  {"RandItemCount", 3299, 2,4  } }; --随机水晶
            { 0.02, {"item", 2400, 1} }; --乌云踏雪
            { 0.06, {"SkillBook", 0}  }; --随机门派秘籍
            { 0.02, {"item", 1391, 1} };  --1级附魔石
            { 0.3,  {"RandMoney", 15, 25} }; --随机的勾玉
        };

        --阶段2的幻象奖励
        tbSuperBoxAward_2 = {
            { 0.592, {"RandItemCount", 3299, 4,8  } }; --随机水晶
            { 0.016, {"item", 2400, 1} }; --乌云踏雪
            { 0.008, {"item", 3307, 1} };
            { 0.04,  {"SkillBook", 0}  }; --随机门派秘籍
            { 0.02,  {"item", 3308, 1} };
            { 0.016, {"item", 1391, 1} };  --1级附魔石
            { 0.008, {"item", 1392, 1} };  --2级附魔石
            { 0.3,   {"RandMoney", 20, 40} }; --随机的勾玉
        };

        --阶段3的幻象奖励
        tbSuperBoxAward_3 = {
            { 0.6,  {"RandItemCount", 3299, 8,12  } }; --随机水晶
            { 0.02, {"item", 3307, 1} };
            { 0.06, {"item", 3308, 1} };
            { 0.02, {"item", 1392, 1} };  --2级附魔石
            { 0.3,  {"RandMoney", 40, 80} }; --随机的勾玉
        };

        --阶段2的Boss奖励
        tbBossAward_2 = {
            { 0.6,   {"RandItemCount", 3299, 4,8  } }; --随机水晶
            { 0.016, {"item", 2400, 1} }; --乌云踏雪
            { 0.008, {"item", 3307, 1} };
            { 0.04,  {"SkillBook", 0}  }; --随机门派秘籍
            { 0.02,  {"item", 3308, 1} };
            { 0.016, {"item", 1391, 1} };  --1级附魔石
            { 0.008, {"item", 1392, 1} };  --2级附魔石
            { 0.292, {"RandMoney", 30, 50} }; --随机的勾玉
        };

        --阶段3的Boss奖励
        tbBossAward_3 = {
            { 0.6,  {"RandItemCount", 3299, 8,16  } }; --随机水晶
            { 0.02, {"item", 3307, 1} };
            { 0.06, {"item", 3308, 1} };
            { 0.02, {"item", 1392, 1} };  --2级附魔石
            { 0.3,  {"RandMoney", 40, 80} }; --随机的勾玉
        };
    };


    --第一次关闭房间时的随机情况 , 防止有角落被锁死就使用配置形式
    tbRandomCloseRoomState1 = {
        {24,25,11,12,14,16,18,22};
        {24,25,12,14,16,19,22,23};
        {10,11,12,13,14,17,21,23};
        {25,10,12,14,17,20,21,22};
        {10,12,14,15,18,21,22,23};
        {25,12,14,15,16,19,20,21};
        {24,11,12,14,17,19,22,23};
        {10,12,14,15,16,19,20,21};
        {24,25,11,12,14,15,18,19};
        {24,25,10,11,12,13,18,17};
        {12,13,14,15,18,20,21,23};
        {10,11,12,17,18,19,22,23};
        {13,14,15,16,18,21,22,23};
        {24,11,15,16,17,18,22,23};
    };

    --- 时间约定， {30 (从第二阶段开始往后的时间, -1随机时间),  40（存活时间, 0则不会自动删除）  } --有重生时间的就不应该有存活时间， 不能填nil,不然unpack 时蛋疼
    --指定某些房间刷新的且每个房间最多只有一个在该group的npc,可多个npc用同个group
    tbSignleRooms = {
        {1},  --3层
        {2,3,4,5,6,7,8,9},  --2层
    };
    --一个房间只会刷出一个npc的npc相关设置
    tbSingleRoomNpc = {
        --第一、二、三阶段3分钟刷出：商人 * 2
        [1987] = {
                    nLevel = 1;  --npc等级
                    nDir = 48,
                    szName = "Thương Nhân",
                    nRoomGroup = 2,   --房间组
                    szIcon = "DreamlandIcon1",  
                }; 

        --第一、二、三阶段3分钟刷出：幻象 * 3
        [2101] = {
                    nLevel = 1;  --npc等级
                    nDir = 48,
                    szName = "Ảo Tượng",
                    nRoomGroup = 2,   --房间组
                    szIcon = "DreamlandIcon4",  
                }; 

        --第一阶段3分钟刷出：幻兽·寒玉鹿王
        [2102] = {
                    nLevel = 80;  --npc等级
                    szName = "Tinh Anh",
                    nRoomGroup = 2,   --房间组
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = { --有这个掉落表的进房间才会显示伤害输出
                                         [2] = "tbLeaderAward_1"; --不同阶段对应的掉落表
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 }; --排名一到3分别获得的奖励次数 
                }; 

        --第一阶段3分钟刷出：幻兽·大地狼王
        [2103] = {
                    nLevel = 80;
                    szName = "Tinh Anh",
                    nRoomGroup = 2,
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = {
                                         [2] = "tbLeaderAward_1";
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 };
                }; 

        --第一阶段3分钟刷出：幻兽·白眉猴王
        [2104] = {
                    nLevel = 80;
                    szName = "Tinh Anh",
                    nRoomGroup = 2,
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = {
                                         [2] = "tbLeaderAward_1";
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 };
                }; 

        --第二阶段3分钟刷出：幻兽·奔焰豹王
        [2105] = {
                    nLevel = 80;
                    szName = "Tinh Anh",
                    nRoomGroup = 2,
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = {
                                         [4] = "tbLeaderAward_2";
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 };
                }; 

        --第二阶段3分钟刷出：幻兽·九尾狐王
        [2106] = {
                    nLevel = 80;
                    szName = "Tinh Anh",
                    nRoomGroup = 2,
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = {
                                         [4] = "tbLeaderAward_2";
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 };
                }; 

        --第二阶段3分钟刷出：幻兽·双首异兽
        [2107] = {
                    nLevel = 80;
                    szName = "Tinh Anh",
                    nRoomGroup = 2,
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = {
                                         [4] = "tbLeaderAward_2";
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 };
                }; 

        --第二阶段3分钟刷出：幻兽·紫背鳄皇（BOSS)
        [2111] = {
                    nLevel = 80;
                    szName = "Thủ Lĩnh",
                    nRoomGroup = 1,
                    szIcon = "DreamlandIcon3",  
                    bBoss = true; --是BOss 有*排名第1的队伍所有成员获得随机Buff 和 获得复活石的机制
                    szDropAwardList = {
                                         [4] = "tbBossAward_2";
                                      }; 
                    tbRankAwardNum = { 18, 12, 8, 6, 4 };
                }; 

        --第三阶段3分钟刷出：幻兽·定海金刚
        [2108] = {
                    nLevel = 80;
                    szName = "Tinh Anh",
                    nRoomGroup = 2,
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = {
                                         [6] = "tbLeaderAward_3";
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 };
                }; 

        --第三阶段3分钟刷出：幻兽·金翅鹏皇
        [2109] = {
                    nLevel = 80;
                    szName = "Tinh Anh",
                    nRoomGroup = 2,
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = {
                                         [6] = "tbLeaderAward_3";
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 };
                }; 

        --第三阶段3分钟刷出：幻兽·银角犀皇
        [2110] = {
                    nLevel = 80;
                    szName = "Tinh Anh",
                    nRoomGroup = 2,
                    szIcon = "DreamlandIcon2",  
                    szDropAwardList = {
                                         [6] = "tbLeaderAward_3";
                                      }; 
                    tbRankAwardNum = { 8, 5, 3 };
                }; 

        --第三阶段3分钟刷出：幻兽·撼天熊皇（BOSS)
        [2112] = {
                    nLevel = 80;
                    szName = "Thủ Lĩnh",
                    nRoomGroup = 1,
                    szIcon = "DreamlandIcon3",  
                    bBoss = true; --是BOss 有*排名第1的队伍所有成员获得随机Buff 和 获得复活石的机制
                    szDropAwardList = {
                                         [6] = "tbBossAward_3";
                                      }; 
                    tbRankAwardNum = { 18, 12, 8, 6, 4 };
                }; 
               
    } ;
}

local tbDefine = InDifferBattle.tbDefine;


function InDifferBattle:CanSignUp(pPlayer, szBattleType)
    if MODULE_GAMESERVER then
        if not Env:CheckSystemSwitch(pPlayer, Env.SW_SwitchMap) then
            return false, string.format("「%s」Trạng thái hiện tại không được đổi bản đồ", pPlayer.szName) 
        end
    end
    if szBattleType then
        local tbBattleTypeSetting = InDifferBattle.tbBattleTypeSetting[szBattleType]
        if tbBattleTypeSetting.bCostDegree then
            if DegreeCtrl:GetDegree(pPlayer, "InDifferBattle") < 1 then
                return false, string.format("「%s」Số lần tham gia không đủ", pPlayer.szName) 
            end
        else
          if not tbBattleTypeSetting.bAct then
            if not self:IsQualifyInBattleType(pPlayer, szBattleType) then
                local szQualifyName = tbBattleTypeSetting.szName
                return false, string.format("「%s」Chưa nhận tư cách thi đấu %s", pPlayer.szName, szQualifyName), szQualifyName
            end
          end
        end    
    end
    
    if Battle.LegalMap[pPlayer.nMapTemplateId] ~= 1 then
        if Map:GetClassDesc(pPlayer.nMapTemplateId) ~= "fight" or pPlayer.nFightMode ~= 0 then
            return false, string.format("「%s」Nơi hiện tại không thể vào Khu Chuẩn Bị Tâm Ma Ảo Cảnh", pPlayer.szName) 
        end
    end
    
    return true
end

function InDifferBattle:GetRoomIndexByRowCol(szBattleType, nRow, nCol)
    local tbRooomPosSetting = self:GetSettingTypeField(szBattleType, "tbRooomPosSetting")
    local tbTemp = tbRooomPosSetting[nRow]
    if not tbTemp then
        return
    end
    local tbCol = tbTemp[nCol]
    if tbCol then
        return tbCol.Index
    end
end

function InDifferBattle:CanEnhance(pPlayer, nIndex)
    local v = self.tbDefine.tbEnhanceScroll[nIndex]
    if not v then
        return
    end
    local nCurLevel = Strengthen:GetStrengthenLevel(pPlayer, v.tbEquipPos[1])
    local nNextLevel = nCurLevel + self.tbDefine.nStrengthStep
    local nCost = v.tbEnhanceCost[nNextLevel]
    if not nCost then
        return
    end

    local nItemCount = pPlayer.GetItemCountInBags(self.tbDefine.nEnhanceItemId)
    if nItemCount < nCost then
        return false, "Thủy Tinh Cường Hóa không đủ"
    end
    return true, nCost,v.tbEquipPos,nNextLevel
end

function InDifferBattle:GetRooomPosSetByType(szBattleType)
	local szFilePath, tbSettingGroup = self:GetSettingTypeField(szBattleType, "szRandomRoomPosSetFilePath")
	local tbRooomPosSet = tbSettingGroup.tbRooomPosSet
	if not tbRooomPosSet then
	    tbRooomPosSet = {}; --[index][posName] = {x1,y1}
	    local tbFile = LoadTabFile(szFilePath, "dsddd", nil, 
	      {"Index", "Name", "PosX", "PosY", "Dir"});
	    for i,v in ipairs(tbFile) do
	        tbRooomPosSet[v.Index] = tbRooomPosSet[v.Index] or {};
	        tbRooomPosSet[v.Index][v.Name] = { v.PosX, v.PosY, v.Dir};
	    end
	    tbSettingGroup.tbRooomPosSet = tbRooomPosSet		
	end
	return tbRooomPosSet
end

function InDifferBattle:Init25RoomTrapPos(tbSettingGroup)
	local tbRooomPosSetting = tbSettingGroup.tbRooomPosSetting
    local tbRoomIndex1 = {}; --最外层的房间编号
	local tbRoomIndex2 = {}; --第二层的房间编号
	local tbRoomTrapToPos = {}

	for i=1,5 do
        for j=1,5 do
            if j > 1 then
                tbRoomTrapToPos["Trap" .. i ..j .. "L"] = tbRooomPosSetting[i][j - 1].R
            end
            if j < 5 then
                tbRoomTrapToPos["Trap" .. i ..j .. "R"] = tbRooomPosSetting[i][j + 1].L
            end
            if i > 1 then
                tbRoomTrapToPos["Trap" .. i ..j .. "T"] = tbRooomPosSetting[i - 1][j].B
            end
            if i < 5 then
                tbRoomTrapToPos["Trap" .. i ..j .. "B"] = tbRooomPosSetting[i + 1][j].T
            end
            if  i == 1  or i == 5 or j == 1  or j == 5 then
               table.insert(tbRoomIndex1, tbRooomPosSetting[i][j].Index ) 
            elseif  i ~= 3 or j ~= 3 then
                table.insert(tbRoomIndex2, tbRooomPosSetting[i][j].Index ) 
            end
        end
    end

    tbSettingGroup.tbRoomTrapToPos = tbRoomTrapToPos
    tbSettingGroup.tbRoomIndex1 = tbRoomIndex1;
    tbSettingGroup.tbRoomIndex2 = tbRoomIndex2; --
end


function InDifferBattle:Init36RoomTrapPos(tbSettingGroup)
	local tbRooomPosSetting = tbSettingGroup.tbRooomPosSetting
	local tbRoomTrapToPos = {}

	for i=1,6 do
        for j=1,6 do
            local nRoomIndex = tbRooomPosSetting[i][j].Index
            tbRoomTrapToPos["Trap" .. i ..j .. "L"] = nRoomIndex
            tbRoomTrapToPos["Trap" .. i ..j .. "R"] = nRoomIndex
            tbRoomTrapToPos["Trap" .. i ..j .. "T"] = nRoomIndex
            tbRoomTrapToPos["Trap" .. i ..j .. "B"] = nRoomIndex
        end
    end

    tbSettingGroup.tbRoomTrapToPos = tbRoomTrapToPos

end

function InDifferBattle:GetRooomPosSetting(szBattleType)
	local szFilePath, tbSettingGroup = self:GetSettingTypeField(szBattleType, "szRooomPosSettingFilePath")
	local tbRooomPosSetting = tbSettingGroup.tbRooomPosSetting
	if not tbRooomPosSetting then
		local tbFile = LoadTabFile(szFilePath, "ddddddddddddddddddd", nil, 
	      {"row","col","Index", "LeftX","LeftY","RightX","RightY","BottomX","BottomY", "TopX", "TopY", "Point1X", "Point1Y", "Point2X", "Point2Y", "Point3X", "Point3Y", "Point4X", "Point4Y"});
	    tbRooomPosSetting = {}
	    local tbRoomIndex = {}
	    local tbRoomRegion = {}
	    
	    for i,v in ipairs(tbFile) do
	        tbRooomPosSetting[v.row] = tbRooomPosSetting[v.row] or {};
	        tbRooomPosSetting[v.row][v.col] = {
	            L = { v.LeftX, v.LeftY, v.Index };
	            R = { v.RightX, v.RightY, v.Index };
	            B = { v.BottomX, v.BottomY, v.Index };
	            T = { v.TopX, v.TopY, v.Index };
	            Index = v.Index;
	        }   
	        tbRoomIndex[v.Index] = {v.row, v.col }
	        tbRoomRegion[v.Index] = { { v.Point1X, v.Point1Y},{v.Point2X, v.Point2Y},{v.Point3X, v.Point3Y},{v.Point4X, v.Point4Y}  }; 
	    end
	    tbSettingGroup.tbRooomPosSetting = tbRooomPosSetting
	    tbSettingGroup.tbRoomIndex = tbRoomIndex
	    tbSettingGroup.tbRoomRegion = tbRoomRegion


    	-- 先计算出来各个trap点对应的传送位置， trap 名 Trap11L Trap12R  这种
	    
	    local nMaxRoomNum = tbSettingGroup.nMaxRoomNum
	    if nMaxRoomNum == 25 then
	    	self:Init25RoomTrapPos(tbSettingGroup)
	    elseif nMaxRoomNum == 36 then
			self:Init36RoomTrapPos(tbSettingGroup)
	    end
	end
	return tbRooomPosSetting
end

function InDifferBattle:GetNpcMovePathByType(szBattleType)
	local szFilePath, tbSettingGroup = self:GetSettingTypeField(szBattleType, "szNpcMovePathFilePath")
	local tbNpcMovePath = tbSettingGroup.tbNpcMovePath
	if not tbNpcMovePath then
		--读取movepath
        local tbFile = LoadTabFile(szFilePath, "sdd", nil, 
          {"ClassName", "X", "Y"});
        tbNpcMovePath = {};
        for i, v in ipairs(tbFile) do
            tbNpcMovePath[v.ClassName] = tbNpcMovePath[v.ClassName] or {};
            table.insert(tbNpcMovePath[v.ClassName], {v.X, v.Y })
        end
        tbSettingGroup.tbNpcMovePath = tbNpcMovePath
	end

	return tbNpcMovePath
end

function InDifferBattle:ComInit()
    --门派秘籍的反向
    self.tbRandSkillBookRevrse = {}
    for i,v in ipairs(self.tbRandSkillBook) do
        self.tbRandSkillBookRevrse[v] = i;
    end

    --绝地心魔的 singleRoom 只有第一个nRoomGroup 是全部房间
    local tbSettingJueDi = InDifferBattle.tbBattleTypeSetting.JueDi
    tbSettingJueDi.tbSignleRooms = { [1] = {} }; 
    local tbRoomGroup = tbSettingJueDi.tbSignleRooms[1]
    for i=1,tbSettingJueDi.nMaxRoomNum do
        table.insert(tbRoomGroup, i)
    end

    if MODULE_ZONESERVER then
        tbDefine.tbAutoDeleteWhenStateChangeNpc[self.tbBattleTypeSetting.JueDi.nRefreshMonsterNpcId] = 1;

        local fnCheckIsStateFight = function (nState)
            if nState == 2 or nState == 4 or nState == 6 or nState == 8 then
                return true
            end
        end
        local fnCheckIsStateFight2 = function (nState) -- 绝地版用
            return true
        end

        local fnCheckAwardParam = function (tbParam)
            local szType, nParam1, nParam2, nParam3 = unpack(tbParam)
            if szType == "item" then
            elseif szType == "Jade" then
            elseif szType == "SkillBook" then
                if nParam1 > 4 and nParam1 < 0 then
                    return false
                end
            elseif szType == "RandMoney" then
            elseif szType == "RandBuff" then
            elseif szType == "RandItemCount" then
                if nParam2 > nParam3 then
                    return false
                end
            elseif szType == "DropNpc" then
            else
                return false
            end
            return  true
        end

        --概率转换
        local fnChangeBoxRate = function (tbOpenBoxType, fnCheckState)
            for k1, v1 in pairs(tbOpenBoxType) do
                for k2,v2 in pairs(v1) do
                    assert(fnCheckState(k2), k2)
                    local nTotal = 0
                    for i3,v3 in ipairs(v2) do
                        nTotal = nTotal + v3[1]
                        v3[1] = nTotal
                        for i4,v4 in ipairs(v3[2]) do
                            -- assert( InDifferBattle.tbBattleBase[v4[1]], k1 .. '.' ..  k2 .. ',' .. i3 .. ',' .. i4)
                            if v4[1] == "OnSendRandDropAwardToTeam" then
                                assert(tbDefine.tbDrapList[ v4[2] ],  k1 .. '.' ..  k2 .. ',' .. i3 .. ',' .. i4)
                            end

                        end
                    end
                    assert(nTotal <= 1.01, k1)
                end    
            end
        end
        fnChangeBoxRate(tbDefine.tbOpenBoxType, fnCheckIsStateFight)
        fnChangeBoxRate(InDifferBattle.tbBattleTypeSetting.JueDi.tbOpenBoxType, fnCheckIsStateFight2)

        for k,v in pairs(InDifferBattle.tbBattleTypeSetting.JueDi.tbBattleNpcDropSetting) do
        	local nTatal = 0
			for i2,v2 in ipairs(v) do
				nTatal = nTatal + v2[1]
				v2[1] = nTatal
			end
			assert(nTatal <= 1)
        end
        
        --掉落表的概率转换
        local fnChangeDropListRate = function (tbDrapList)
            for k1,v1 in pairs(tbDrapList) do
                local nRate = 0;
                for i2,v2 in ipairs(v1) do
                    nRate = nRate + v2[1]
                    v2[1] = nRate
                    assert(fnCheckAwardParam(v2[2]), k1 .. ',' .. i2)
                end
                assert(nRate <= 1.01, k1)
            end    
        end
        fnChangeDropListRate(tbDefine.tbDrapList)
        
        InDifferBattle:GetRooomPosSetting()
        for szBattleType,v1 in pairs(InDifferBattle.tbBattleTypeSetting) do
            if v1.tbDrapList then
                fnChangeDropListRate(v1.tbDrapList)
            end
            if v1.szRooomPosSettingFilePath then
                InDifferBattle:GetRooomPosSetting(szBattleType)
            end
            InDifferBattle:GetRooomPosSetByType(szBattleType)
            InDifferBattle:GetTotalGameFightTime(szBattleType)
        end
        
        
        local tbSingleRoomNpc = InDifferBattle:GetSettingTypeField(nil, "tbSingleRoomNpc")
        local tbSignleRooms = InDifferBattle:GetSettingTypeField(nil, "tbSignleRooms")
        for k1, v1 in pairs(tbSingleRoomNpc) do
            assert( tbSignleRooms[v1.nRoomGroup], k1 .. "nRoomGroup11" );
            if v1.szDropAwardList then
                for k2,v2 in pairs(v1.szDropAwardList) do
                    assert(fnCheckIsStateFight(k2), k1 ..',' .. k2 )
                    assert(tbDefine.tbDrapList[ v2 ],  k1 ..',' .. k2)
                end
                assert(v1.tbRankAwardNum, k1)
                assert(v1.nLevel, k1)
                assert(v1.nRoomGroup, k1)
                assert(v1.szName, k1)
                assert(v1.szIcon, k1)
            end

        end

        --商店配置检查
        for k1,v1 in pairs(tbDefine.tbSellWarePropSetting) do
            assert(fnCheckIsStateFight(k1), k1)
            for i2,v2 in ipairs(v1) do
                local v3 = v2[1]
                if type(v3) == "number" then
                    assert(tbDefine.tbSellWareSetting[v3], v3)
                else
                    for _,v4 in ipairs(v3) do
                        assert(tbDefine.tbSellWareSetting[v4], v4)
                    end
                end
            end
        end

        --绝地版相关设置

        local tbActiveTransJueDi = {};
        for _, v in ipairs(InDifferBattle.tbActiveTransJueDiFormat) do
            local nTime1, nTime2 = v[1], v[2];
            tbActiveTransJueDi[nTime1] = tbActiveTransJueDi[nTime1] or {};
            tbActiveTransJueDi[nTime1][nTime2] = tbActiveTransJueDi[nTime1][nTime2] or {}
            table.insert(tbActiveTransJueDi[nTime1][nTime2], v[3])
        end   
        --todo check 时间范围在 流程的时间范围内

        InDifferBattle.tbBattleTypeSetting.JueDi.ActiveTrasn = tbActiveTransJueDi
    end

	local JueDi = InDifferBattle.tbBattleTypeSetting.JueDi
    local tbNpcIdToFunction = {} --绝地不同npc对应的对话回调函数
    local tbNpcIdToCheckFuctionClient = {};
    for nNpcId,v in pairs(JueDi.tbGatherGetItemNpc) do
      tbNpcIdToFunction[nNpcId] = "GatherItem";
    end
    for nNpcId,v in pairs(JueDi.tbItemBagLNpcGridCount) do
      tbNpcIdToFunction[nNpcId] = "GatherItemBagCount";
      tbNpcIdToCheckFuctionClient[nNpcId] = "CheckGatherItemBagCountClient";
    end
    tbNpcIdToFunction[JueDi.nChangeFactionNpcId] = "ChangePlayerFactionFightByNpc"
    tbNpcIdToCheckFuctionClient[JueDi.nChangeFactionNpcId] = "CheckChangePlayerFactionFightByNpcClient"
    
    for nNpcId,v in pairs(JueDi.tbEnhanceNpcLevel) do
      tbNpcIdToFunction[nNpcId] = "GatherEnhance";
      tbNpcIdToCheckFuctionClient[nNpcId] = "CheckCanGatherEnhanceClient"
    end
    for nNpcId,v in pairs(JueDi.tbSkillBookNpc) do
      tbNpcIdToFunction[nNpcId] = "GatherSkillBook";
      tbNpcIdToCheckFuctionClient[nNpcId] = "CheckGatherSkillBookClinet";

    end
    for nNpcId,v in pairs(JueDi.tbHorseNpcToEquipId) do
      tbNpcIdToFunction[nNpcId] = "GatherHorseEquip";
	  tbNpcIdToCheckFuctionClient[nNpcId] = "CheckGatherHorseEquipClinet";

    end
    JueDi.tbNpcIdToFunction = tbNpcIdToFunction
    JueDi.tbNpcIdToCheckFuctionClient = tbNpcIdToCheckFuctionClient

end

--指定道具id获得对应的门派秘籍id
function InDifferBattle:GetRandSkillBookId( nRandBook, nFaction )
    local nType = self.tbRandSkillBookRevrse[nRandBook]
    if not nType then
        return
    end
    return Item:GetClass("SkillBook"):GetFactionTypeBook(nType, nFaction)
end

function InDifferBattle:GetRandSkillBookOriId(nBookId)
    local nType = Item:GetClass("SkillBook"):GetBookType(nBookId)
    if nType then
      return self.tbRandSkillBook[nType]
    end
end

function InDifferBattle:GetAllCanShowItemId()
    if not self.tbAllCanShowItemId then
        self.tbAllCanShowItemId = {}
        for k,v in pairs(self.tbDefine.tbSellWareSetting) do
            self.tbAllCanShowItemId[k] = 1;
        end
		for szBattleType, tbBattleTypeSetting in pairs(InDifferBattle.tbBattleTypeSetting) do
			if tbBattleTypeSetting.tbGatherGetItemNpc then
				for k, v in pairs(tbBattleTypeSetting.tbGatherGetItemNpc) do
					self.tbAllCanShowItemId[v] = 1;		
				end
			end
			if tbBattleTypeSetting.nReviveItemId then
				self.tbAllCanShowItemId[tbBattleTypeSetting.nReviveItemId] = 1;		
			end
		end

        local tbSkillBook = Item:GetClass("SkillBook")
        for nRandBook,nType in pairs(self.tbRandSkillBookRevrse) do
            for nFaction=1,Faction.MAX_FACTION_COUNT do
                local nBookId = tbSkillBook:GetFactionTypeBook(nType, nFaction)	
                if nBookId then
                    self.tbAllCanShowItemId[nBookId] = 1;		
                    local tbBookInfo = tbSkillBook:GetBookInfo(nBookId);
                    self.tbAllCanShowItemId[tbBookInfo.UpgradeItem] = 1;
                end
            end
        end
        self.tbAllCanShowItemId[self.tbDefine.nReviveItemId] = 1;
    end
    return self.tbAllCanShowItemId
end


function InDifferBattle:GetSellSumPrice(dwTemplateId, nCount)
	if InDifferBattle.IsJueDiVersion and InDifferBattle:IsJueDiVersion() then
		return
	end
    local nOriBook = self:GetRandSkillBookOriId(dwTemplateId)
    if nOriBook then
        dwTemplateId = nOriBook;
    end
    local tbItemInfo = self.tbDefine.tbSellWareSetting[dwTemplateId]
    if tbItemInfo then
        return math.floor(tbItemInfo.nPrice * nCount * self.tbDefine.nSelllPricePercent), tbDefine.szMonoeyType
    end
end

function InDifferBattle:GetBuySumPrice(dwTemplateId, nCount)
   local nOriBook = self:GetRandSkillBookOriId(dwTemplateId)
    if nOriBook then
        dwTemplateId = nOriBook;
    end
    local tbItemInfo = self.tbDefine.tbSellWareSetting[dwTemplateId]
    if tbItemInfo then
        return math.floor(tbItemInfo.nPrice * nCount), tbDefine.szMonoeyType
    end
end

function InDifferBattle:GetEvaluationFromScore( nScore )
    local nGrade = 1
    local tbEvaluationSetting = InDifferBattle.tbDefine.tbEvaluationSetting
    for i,v in ipairs(tbEvaluationSetting) do
        if nScore >= v.nScoreMin then
            nGrade = i
        end
    end
    return nGrade, tbEvaluationSetting[nGrade]
end

function InDifferBattle:GetNextOpenTime(szType, nTime)
    nTime = nTime or GetTime() --如果是判断当前的进入时间时，就是用当前时间前一个小时来判断是不是同一场的时间
    local tbType = self.tbBattleTypeSetting[szType]
    local szFunc = tbType.szOpenTimeFunc
    return self[szFunc](self, tbType, nTime)
end

function InDifferBattle:GetNextOpenTimeMonth(tbType, nTime)
    local nTimeRet = Lib:GetTimeByWeekInMonth(nTime, tbType.OpenTimeWeek, tbType.OpenTimeWeekDay, tbType.OpenTimeHour, tbType.OpenTimeMinute, 0)
    if nTimeRet < nTime  then --对应要求的开启时间是传过来时间之前，就应该是传下个月的时间
        local tbTimeNow = os.date("*t", nTime)    
        local nSec = os.time({year = tbTimeNow.year, month = tbTimeNow.month + 1, day = 1, hour = 1, min = 0, sec = 0});
        nTimeRet = Lib:GetTimeByWeekInMonth(nSec, tbType.OpenTimeWeek, tbType.OpenTimeWeekDay, tbType.OpenTimeHour, tbType.OpenTimeMinute, 0)
    end
    return  nTimeRet
end

function InDifferBattle:GetNextOpenTimeSeason(tbType, nTime)

    local tbTimeNow = os.date("*t", nTime)
    local nSeason = math.ceil(tbTimeNow.month / 3) 
    local nSec = os.time({year = tbTimeNow.year, month = nSeason * 3, day = 1, hour = tbType.OpenTimeHour, min = tbType.OpenTimeMinute, sec = 0});
    local nTimeRet = Lib:GetTimeByWeekInMonth(nSec, tbType.OpenTimeWeek, tbType.OpenTimeWeekDay, tbType.OpenTimeHour, tbType.OpenTimeMinute, 0)
    if nTimeRet < nTime then
    	nSeason =  nSeason + 1
    	local nSec = os.time({year = tbTimeNow.year, month = nSeason * 3, day = 1, hour = tbType.OpenTimeHour, min = tbType.OpenTimeMinute, sec = 0});
    	 nTimeRet = Lib:GetTimeByWeekInMonth(nSec, tbType.OpenTimeWeek, tbType.OpenTimeWeekDay, tbType.OpenTimeHour, tbType.OpenTimeMinute, 0)
    end
    return nTimeRet
end

function InDifferBattle:GetNextOpenTimeYear( tbType, nTime )
    --因为是不确定的，先是写死为 2018年7月，确定后要类似 GetNextOpenTimeMonth 的处理，
    local nSec = os.time({year = 2018, month = 7, day = 1, hour = tbType.OpenTimeHour, min = tbType.OpenTimeMinute, sec = 0});
    return Lib:GetTimeByWeekInMonth(nSec, tbType.OpenTimeWeek, tbType.OpenTimeWeekDay, tbType.OpenTimeHour, tbType.OpenTimeMinute, 0)
end

function InDifferBattle:IsQualifyInBattleType(pPlayer, szType, bNext) --bNext 就是判断是否能参加下次，非next是参与当前的会减少1小时
    local tbType = self.tbBattleTypeSetting[szType]
    local nNowQualifyTime = pPlayer.GetUserValue(self.tbDefine.SAVE_GROUP, tbType.nKeyQualifyTime)
    if nNowQualifyTime == 0 then
        return
    end
    local nNow = GetTime()
    if not bNext then
        nNow = nNow - 360;--大于报名的持续时间
    end
    local nCurOpenBattleTime = self:GetNextOpenTime(szType, nNow)
    local bRet = Lib:GetLocalDay(nNowQualifyTime) == Lib:GetLocalDay(nCurOpenBattleTime)
    return bRet, nCurOpenBattleTime
end


function InDifferBattle:GetCurOpenQualifyType()
    local nNow = GetTime()
    for k,v in pairs(self.tbBattleTypeSetting) do
        if v.nNeedGrade then
            if MODULE_ZONESERVER or (v.szOpenTimeFrame and GetTimeFrameState(v.szOpenTimeFrame) == 1)  then
                local nCurOpenBattleTime = self:GetNextOpenTime(k, nNow - 3600)    
                if math.abs(nCurOpenBattleTime - nNow) < 1800 then
                    return k;
                end
            end
        end
    end
end

function InDifferBattle:GetTopCanSignBattleType(tbPlayers, tbReadyMapList)
    --从高到底的，如果有一个人能参与， 则就是参与该类型的
    for i,v in ipairs(tbReadyMapList) do
        local nReadyMapId, szBattleType, nLevel = unpack(v)
        local tbSetting = self.tbBattleTypeSetting[szBattleType]
        if tbSetting.bCostDegree or tbSetting.bAct then
            return szBattleType, nReadyMapId, ""
        else
            for i, pPlayer in ipairs(tbPlayers) do
                if self:IsQualifyInBattleType(pPlayer, szBattleType) then
                    return  szBattleType, nReadyMapId, pPlayer.szName
                end 
            end
        end
    end
end

function InDifferBattle:GetTotalGameFightTime(szBattleType)
    local STATE_TRANS, tbSettingGroup = self:GetSettingTypeField(szBattleType, "STATE_TRANS")
    if tbSettingGroup.nTotalGameFightTime then
        return tbSettingGroup.nTotalGameFightTime
    end
    local nTotalGameFightTime = 0;
    for i = 2, #STATE_TRANS -1 do
        local v = STATE_TRANS[i]
        nTotalGameFightTime = nTotalGameFightTime + v.nSeconds
    end
    tbSettingGroup.nTotalGameFightTime = nTotalGameFightTime
    return nTotalGameFightTime
end

InDifferBattle.tbCacheAroundGridX = {}
InDifferBattle.tbCacheAroundGridY = {}
function InDifferBattle:GetAroundGridX(n)
    if InDifferBattle.tbCacheAroundGridX[n] then
        return InDifferBattle.tbCacheAroundGridX[n]
    end
    local tbX = {};
    for i = -n,n do
        table.insert(tbX, i)
    end
    for i=1,2*n -1 do
        table.insert(tbX, -n)
        table.insert(tbX, n)
    end
    for i = -n,n do
        table.insert(tbX, i)
    end
    InDifferBattle.tbCacheAroundGridX[n] = tbX
    return tbX
end

function InDifferBattle:GetAroundGridY(n)
    if InDifferBattle.tbCacheAroundGridY[n] then
        return InDifferBattle.tbCacheAroundGridY[n]
    end
    local tbY = {};
    for i=1,2*n + 1 do
        table.insert(tbY, n)
    end
    for i=n-1, -n+1, -1 do
       table.insert(tbY, i) 
       table.insert(tbY, i) 
    end
    
    for i=1,2*n + 1 do
        table.insert(tbY, -n)
    end
    InDifferBattle.tbCacheAroundGridY[n] = tbY
    return tbY
end

function InDifferBattle:CheckGatherItemBagCount(pPlayer, nNpcTemplateId, tbInfo, bNotMsg)
	local nOldItemBagNpcId = tbInfo.nNowItemBagNpcId
	if tbInfo.nNowItemBagNpcId == nNpcTemplateId then
		if not bNotMsg then
			pPlayer.CenterMsg("Cấp Túi giống nhau")
		end
		return
	end

	local nCurCount = pPlayer.GetBagUsedCount();
	local tbSettingGroup = InDifferBattle.tbBattleTypeSetting.JueDi
	local tbBagInfo = tbSettingGroup.tbItemBagLNpcGridCount[nNpcTemplateId]
	if not tbBagInfo then
		if not bNotMsg then
			pPlayer.CenterMsg("Túi chưa thiết lập")
		end
		return
	end
	if tbBagInfo.nCount < nCurCount then
		if not bNotMsg then
			pPlayer.CenterMsg("Đạo cụ có vượt quá không gian túi muốn thay đổi")
		end
		return
	end
	local tbOldBagInfo = tbSettingGroup.tbItemBagLNpcGridCount[nOldItemBagNpcId]
	local szConfirmMsg;
	if tbBagInfo.nCount < tbOldBagInfo.nCount then
		local szOldName = KNpc.GetNameByTemplateId(nOldItemBagNpcId)
		local szNewName = KNpc.GetNameByTemplateId(nNpcTemplateId)
		szConfirmMsg = string.format("Đã có「%s」, đồng ý đổi thành「%s」?", szOldName, szNewName)
	end
	return tbInfo, nOldItemBagNpcId, szConfirmMsg
end

function InDifferBattle:CheckCanGatherEnhance(pPlayer, nTemplateId, bNotMsg)
	local tbSettingGroup = InDifferBattle.tbBattleTypeSetting.JueDi
	local nNextLevel = tbSettingGroup.tbEnhanceNpcLevel[nTemplateId]
	local tbStrengthen = pPlayer.GetStrengthen();
	local nOldStrenLevel = tbStrengthen[1];
	if nOldStrenLevel == nNextLevel then
		if not bNotMsg then
			pPlayer.CenterMsg("Cấp cường hóa giống nhau")
		end
		return
	end
	local szConfirmMsg;
	if nNextLevel < nOldStrenLevel then
		local nFindOldNpcId = self:FindEnhanceNpcByLevel(nOldStrenLevel)
		local szOldName = KNpc.GetNameByTemplateId(nFindOldNpcId)
		local szNewName = KNpc.GetNameByTemplateId(nTemplateId)
		szConfirmMsg = string.format("Đã có「%s」, đồng ý đổi thành「%s」?", szOldName, szNewName)
	end
	return nNextLevel, nOldStrenLevel,szConfirmMsg
end

function InDifferBattle:CheckGatherSkillBook(pPlayer, nNpcTemplateId, bNotMsg)
	local tbSkillBookNpc = InDifferBattle.tbBattleTypeSetting.JueDi.tbSkillBookNpc
	local tbBookType = tbSkillBookNpc[nNpcTemplateId]
	local pCurEquip = pPlayer.GetEquipByPos(Item.EQUIPPOS_SKILL_BOOK)
	local nOldBookType;
	if pCurEquip then
		local tbSkillBook = Item:GetClass("SkillBook")
		nOldBookType = tbSkillBook:GetBookType(pCurEquip.dwTemplateId);		
		for i,v in ipairs(tbBookType) do
			if v == nOldBookType then
				if not bNotMsg then
					pPlayer.CenterMsg("Đã có Bí Kíp cùng cấp")
				end
				return
			end
		end
	end
	local szConfirmMsg;
	if nOldBookType and nOldBookType > tbBookType[1]  then
		local nOldNpcId = self:_GetSkillBookGatherNpcByType(nOldBookType)
		local szOldName = KNpc.GetNameByTemplateId(nOldNpcId)
		local szNewName = KNpc.GetNameByTemplateId(nNpcTemplateId)
		szConfirmMsg = string.format("Đã có「%s」, đồng ý đổi thành「%s」?", szOldName, szNewName)
	end

	return true, true, szConfirmMsg
end

function InDifferBattle:_GetSkillBookGatherNpcByType(nType)
  for k,v in pairs(InDifferBattle.tbBattleTypeSetting.JueDi.tbSkillBookNpc) do
    for i2,v2 in ipairs(v) do
      if nType == v2 then
        return k
      end
    end
  end
end

function InDifferBattle:CheckGatherHorseEquip(pPlayer, nTemplateId, bNotMsg)
	local tbHorseNpcToEquipId = InDifferBattle.tbBattleTypeSetting.JueDi.tbHorseNpcToEquipId
	local nEquipId = tbHorseNpcToEquipId[nTemplateId]
	--先取得现在的强化等级，如果
	local nEquipPos = KItem.GetEquipPos(nEquipId)
	local pCurEquip = pPlayer.GetEquipByPos(nEquipPos)
	if pCurEquip and pCurEquip.dwTemplateId == nEquipId then
		if not bNotMsg then
			pPlayer.CenterMsg("Đã có trang bị tương tự")
		end
		return
	end
	return nEquipId, pCurEquip
end

function InDifferBattle:FindEnhanceNpcByLevel(nOldStrenLevel)
	local tbSettingGroup = InDifferBattle.tbBattleTypeSetting.JueDi
	if nOldStrenLevel ~= tbSettingGroup.nDefaultStrengthLevel then
		for k,v in pairs(tbSettingGroup.tbEnhanceNpcLevel) do
			if v == nOldStrenLevel then
				return k  
			end
		end
	end
end



InDifferBattle:ComInit();


if MODULE_ZONESERVER then
    local fnCheckData = function ( )
        assert(#InDifferBattle.tbDefine.tbRandomCloseRoomState1 > 1) --小于1随机会有问题
        for i,v in ipairs(InDifferBattle.tbDefine.tbRandomCloseRoomState1) do
            assert(#v == 8, i);
            local tbV = {}
            for i2,v2 in ipairs(v) do
                assert(not tbV[v2], i .."," .. i2)
                tbV[v2] = true
            end
        end

        assert(tbDefine.nCloseRoomPunishPersent > 0 and tbDefine.nCloseRoomPunishPersent < 1)

        --预关闭房间的时间要小于 流程结束时间
        local tbRooomPosSet = InDifferBattle:GetRooomPosSetByType()
        local tbNpcMovePath= InDifferBattle:GetNpcMovePathByType()
        for nState, v1 in pairs(InDifferBattle.tbActiveTransNormal) do
            local tbManinTrans = tbDefine.STATE_TRANS[nState]
            for nScends,v2 in pairs(v1) do
                assert(nScends < tbManinTrans.nSeconds,  nState .. ',' .. nScends)
                --检查流程里的函数参数
                for i3, v3 in ipairs(v2) do
                    local szFuncName = v3[1]
                    -- assert( InDifferBattle.tbBattleBase[szFuncName], szFuncName)
                    if szFuncName == "AddRandPosNpcSet" then
                        local szTag = table.concat({nState,nScends,i3,}, ",")
                        for _,v4 in ipairs(v3[5]) do
                            assert(tbRooomPosSet[v3[4]][ v4 ], szTag .. "," .. v4)
                        end
                        local nMin,nMax = unpack( v3[6] )
                        assert(nMin<=nMax, szTag)
                        assert( #v3[5] >= nMax, szTag) --点集合数应小于等于最大随机数
                    elseif szFuncName == "AddRandTypeSet" then
                        local nRate = 0
                        for i4, v4 in ipairs(v3[4]) do
                            nRate = v4[1] + nRate 
                            v4[1] = nRate
                        end
                        assert(nRate <= 1.01, table.concat({nState,nScends,i3, }, ",") )
                    elseif szFuncName == "AddRandTypeSetTimer" then
                        local nRate = 0
                        for i4, v4 in ipairs(v3[5]) do
                            nRate = v4[1] + nRate 
                            v4[1] = nRate
                        end
                        assert(nRate <= 1.01, table.concat({nState,nScends,i3, }, ",") )

                    elseif szFuncName == "AddAutoHideWalkPathNpc" then
                        assert( tbNpcMovePath[ v3[5] ] , table.concat({nState,nScends,i3, }, ",") )
                    end
                end

            end
        end

        local tbSignleRooms, tbSettingGroup = InDifferBattle:GetSettingTypeField(nil, "tbSignleRooms")
        for k, v in pairs(tbSignleRooms) do
            local tbHased = {}
            for i2,v2 in ipairs(v) do
                assert(not tbHased[v2], k .. " tbSignleRooms")
                tbHased[v2] = 1;
            end
        end
        --道具的随机总值小于10000
        local nTotalRate = 0
        for i, v in ipairs(tbDefine.tbBattleNpcDropSettingItem) do
            nTotalRate = nTotalRate + v[2]
            v[2] = nTotalRate
        end
        assert(nTotalRate <= 10000)

        local nTotalRate = 0
        for i, v in ipairs(tbDefine.tbInitGiveItem) do
            nTotalRate = nTotalRate + v[1]
            v[1] = nTotalRate
        end
        assert(nTotalRate <= 10000)

        --每个房间点都有center
        local tbRoomIndex = InDifferBattle:GetSettingTypeField(nil, "tbRoomIndex")
        for nRoomIndex=1,25 do
            local tbPosSet = tbRooomPosSet[nRoomIndex]
            local v = tbPosSet.center;
            assert(v, nRoomIndex)
            local nRow, nCol = unpack(tbRoomIndex[nRoomIndex])
            for szPosName, tbRowCol in pairs(tbDefine.tbGateDirectionModify) do
                local nRowModi, nColModi = unpack(tbRowCol)
                local nTarRoomIndex = InDifferBattle:GetRoomIndexByRowCol(nil, nRow + nRowModi, nCol + nColModi)
                if nTarRoomIndex then
                    assert(tbPosSet[szPosName], nRoomIndex .. ',' ..  szPosName ..',' .. nTarRoomIndex)
                end
            end
        end

        for _, v in ipairs(tbDefine.tbLastSwitchRandPosSet) do
            assert(tbRooomPosSet[1][v], v)
        end
    end
    fnCheckData()

    local fnCheckDataJueDi = function ()
        -- local nMaxAddNpcNum = 0;
        --TODO 检查时间配置 tbActiveTransJueDiFormat 是在大流程的时间范围内的，最好0 和最后时间都能正确设到

        --boss掉落的配置必定生效
        
    end
    fnCheckDataJueDi()
end
