WuLinDaHui.tbDef = {
	nMinPlayerLevel = 60; --参与比赛的最小等级
	nMaxFightTeamCount  = 99; --最大战队数,这样一个块最多就99个战队了， 因为有四人和多的变量，战队数从500减到100 同时方便id的设置
	nMaxFightTeamVer = 1000; --最大版本号--见到1000，就是最多100个scriptdata， 一次武林大会一个服不会超10w的
	nGameTypeInTeamId =  100000 ; -- =nMaxFightTeamVer * nMaxFightTeamCount
	nServerIdxInTeamId = 1000000;--因为是跨服的，要包含serverIdx --目前是不会超过1000的
    nMaxGuessingVer    = 1000; --保存最大竞猜数版本
    nSaveGuessingCount = 500; --保存玩家竞猜数

	--TODO ，代码测试战队id数是不会重的

	nPreGamePreMap = 1;--创建的准备场个数，跨服上就只建一个准备场图了
	nAutoTicketFightPowerRank = 200; --即报名开始时, 时本服战力排名前200的玩家获得参与武林大会的资格。
	--nMaxTicketFightPowerRank = 200; --101-200需要买门派的

	nSellTicketGold = 300; --购买门票资格费用，元宝
	nPreMatchJoinCount = 20; --预选赛的参与次数

    tbNotifyMatchTime = { "15:42", "21:27" };--预告滚动条通知时间
    tbStartMatchTime = {"15:45", "21:30"}; --比赛开启时间
    tbEndMatchTime   = {"16:15", "22:00"}; --比赛结束时间 

    szFinalStartMatchTime = "21:30"; --决赛比赛开启时间
    szFinalEndMatchTime   = "22:00"; --决赛比赛结束时间 

    nOpenPreMatchRound = 4; --初赛每种是开四次，开了四次后才会换下一种

	nMaxJoinTeamNum = 2; --同时最大参与的战队数量
	nDefWinPercent = 0.5; --默认胜率
	nPreRankSaveCount = 20; --初赛保留的战队信息数
    nClientRequestTeamDataInterval = 60; --客户端请求战队数据的时间间隔
    nClientRequestTeamDataIntervalInMap = 5; --在比赛地图内的请求战队数据间隔


    tbUiShowItemIds = { 6007, 6008, 6010, 10153, 6013, 6014, 5238, 6012 }; --界面里展示的道具Id
    nNewsInformationTimeLast = 3600*24*12; --最新消息的持续时间
    szNewsKeyNotify = "WLDHNews"; --武林大会的最新消息key
    szNewsContent1 = [==[
      [eebb01]「Đại Hội Võ Lâm」[-] là giải đấu cấp cao nhất trong giang hồ, người chơi đạt [eebb01]Top 50[-] Hoa Sơn Luận Kiếm ở giai đoạn trước khi tổ chức Đại Hội Võ Lâm lần này mới được lập chiến đội  vào Lôi Đài chiến đấu [eebb01]Liên SV[-], có thể sẽ gặp phải đối thủ cực mạnh, người chiến thắng sau cùng sẽ đoạt được vinh dự Võ Lâm Chí Tôn.
      Đại hội tổng cộng có [eebb01]3[-] hình thức thi đấu, lần lượt là [eebb01]Song Đấu[-], [eebb01]Tam Đấu[-] và [eebb01]Tứ Đấu[-], mỗi hình thức sẽ chọn ra [eebb01]Võ Lâm Chí Tôn[-], mỗi vị đại hiệp có thể chọn tham gia [eebb01]2[-] hình thức thi đấu.
      [eebb01]Chú ý[-]: Trong thời gian thi đấu Đại Hội Võ Lâm, Danh Tướng Liên SV tạm đóng.
[eebb01]1. Tư cách tham gia[-]
      Khi [eebb01]giai đoạn dự báo[-] kết thúc: 
      Đại hiệp đạt Lv60, từng đạt Top 50 Hoa Sơn Luận Kiếm trong năm sẽ được tham gia thi đấu;
      Đã mở cấp tối đa Lv69 nhưng điều kiện nhận tư cách đối với máy chủ trước đây chưa mở Hoa Sơn Luận Kiếm là đạt [eebb01]Top 200[-] BXH Lực Chiến Server.

[eebb01]2. Hình thức và thời gian[-]
      Quy tắc thi đấu Song Đấu, Tam Đấu giống với hoạt động Hoa Sơn Luận Kiếm.
      Tứ Đấu cho phép nhiều nhất 4 người tổ đội, khi chiến đấu Đồng Hành không thể trợ chiến.
      [eebb01]Thời gian thi đấu: [-]
    ]==]; --最新消息里的内容
    szNewsContentTime1 = "3/12, 4/12";
    szNewsContentTime2 = "9/12";
    szNewsContentTime3 = "5/12, 6/12";
    szNewsContentTime4 = "10/12";
    szNewsContentTime5 = "7/12, 8/12";
    szNewsContentTime6 = "11/12";

    szNewsContent2  = [==[
    Thời gian thi đấu mỗi ngày của Vòng Loại là [eebb01]15:45-16:15[-] và [eebb01]21:30-22:00[-]; thời gian thi đấu mỗi ngày của Vòng Chung Kết là [eebb01]21:30-22:00[-].
[eebb01]3. Quy trình[-]
    Đại Hội Võ Lâm chia làm các giai đoạn: 
[eebb01]Giai đoạn dự báo[-]
    Trước khi Đại Hội bắt đầu báo danh sẽ dự báo trước một khoảng thời gian, [eebb01]giai đoạn kết thúc[-] sẽ [eebb01]lập tức[-] thông báo danh sách đại hiệp đủ điều kiện tham gia thi đấu.
[eebb01]Giai đoạn báo danh[-]
    Đại hiệp đủ điều kiện tham gia thi đấu, trong giai đoạn này sẽ tự động cùng đại hiệp khác [eebb01]trong server[-] lập chiến đội báo danh thi đấu trong giao diện Đại Hội Võ Lâm.
    Các vị đại hiệp tối đa tham gia [eebb01]2 hình thức[-] thi đấu và mỗi hình thức thi đấu có thể có chiến đội và đồng đội [eebb01]khác nhau[-].
    Sau khi giai đoạn kết thúc, [eebb01]không cho phép tiếp tục lập chiến đội[-] báo danh thi đấu, các vị đại hiệp nhớ đừng bỏ lỡ!
[eebb01]Giai đoạn Vòng Loại[-]
    Mỗi hình thức thi đấu Vòng Loại chỉ tiến hành trong [eebb01]2 ngày[-] vào lúc 15:45 và 21:30, kéo dài 30 phút, mỗi 3 phút bắt đầu một trận đấu, tổng cộng mở 36 trận.
    Mỗi chiến đội tổng cộng tối đa được phép tham gia [eebb01]20[-] trận đấu, chiến đội lọt vào [eebb01]Top 16[-] ở Vòng Loại cuối cùng sẽ vào Chung Kết.
[eebb01]Gian đoạn Chung Kết[-]
    Chung kết sẽ tiến hành thi đấu chọn ra [eebb01]Top 8[-], [eebb01]Top 4[-], [eebb01]Bán Kết[-] mỗi vòng [eebb01]1[-] trận. Cuối cùng thi đấu tranh Quán qQân sẽ áp dụng thể thức [eebb01]3 trận thắng 2[-].
    Trong chung kết, người chơi có thể [eebb01]dự đoán[-] quán quân, nếu đoán trúng sẽ nhận được phần thưởng [eebb01]300 Nguyên Bảo[-].


    ]==];


    szMailTextYuGao = "  Đại Hội Võ Lâm sắp bắt đầu, hãy giành quyền tham gia rồi cùng hảo hữu tổ đội tham gia thi đấu giành vinh quang!\nChi tiết xem tại [00ff00][url=openwnd:Giao diện Đại Hội Võ Lâm, WLDHJoinPanel][-].";
    szMailTextGetTicket = "  Đại hiệp thần công cái thế, đạt Top [eebb01]50[-] Hoa Sơn Luận Kiếm, Võ Lâm Minh quyết định [eebb01]mời[-] đại hiệp tham gia Đại Hội Võ Lâm sắp đến, khi đó hãy tổ đội với đại hiệp đạt điều kiện khác đến báo danh, tranh đoạt danh hiệu Võ Lâm Chí Tôn!";
    szMailTextGetTicketByRank = "  Đại hiệp thần công cái thế, đạt Top [eebb01]200[-] lực chiến của máy chủ, Võ Lâm Minh quyết định [eebb01]mời[-] đại hiệp tham gia Đại Hội Võ Lâm sắp đến, khi đó hãy tổ đội với đại hiệp đạt điều kiện khác đến báo danh, tranh đoạt danh hiệu Võ Lâm Chí Tôn!";
    --szMailTextBuyTicket = "  恭喜侠士的武功获得武林盟的认可，阁下需要[eebb01]「门票」[-]来获得参与武林大会的资格，请前往[00ff00][url=openwnd:武林大会活动界面, WLDHJoinPanel][-]购买。";

    szEnterFinalQualifyMsgKin = "Chúc mừng chiến đội của thành viên Bang [eebb01]%s[-] lọt vào 16 đội mạnh [eebb01]%s[-] Đại Hội Võ Lâm"; --晋级16强的家族提示
    szEnterFinalQualifyMsgFriend = "Chúc mừng chiến đội của hảo hữu [eebb01]%s[-] lọt vào 16 đội mạnh [eebb01]%s[-] Đại Hội Võ Lâm"; --晋级16强的好友提示

    nPhoneSysNotifyMsgBeforeSec = 60; --推送提醒的对应提前秒数
    szPhoneSysNotifyMsg = "Đại hiệp, Đại Hội Võ Lâm sắp bắt đầu thi đấu"; --手机上的推送提醒消息

    nHSLJTicketRankPos = 50; --前50名的才有资格进武林大会
	SAVE_GROUP = 136; 
	SAVE_KEY_TicketTime = 1; --获取的门票时间, 大于等于报名时间的就是有资格, 
    --因为现在是按华山论剑前50名有资格的形式，所以在华山获取前50名时直接设上值，然后新开一届时记录上次的报名时间，只要 获取前50名的时间大于上次的开启时间则就有资格
	SAVE_KEY_CanBuyTicketTime = 2; --能买门票的时间, 大于等于报名时间的就是有资格
}

local tbDef = WuLinDaHui.tbDef;

tbDef.tbPrepareGame = {
    szBeforeNotifyMsg = "【Đại Hội Võ Lâm】[eebb01]Vòng loại %s[-] sẽ bắt đầu sau [eebb01]3 phút[-], hãy chuẩn bị!";
    szPreOpenWorldMsg = "【Đại Hội Võ Lâm】[eebb01]Vòng loại %s[-] đã bắt đầu, trận đầu tiên sẽ bắt đầu sau 3 phút!";

    szWinNotifyInKin = "【Đại Hội Võ Lâm】Chúc mừng chiến đội của [eebb01]%s[-] đã thắng một trận [eebb01]vòng loại %s[-].";
    -- szWinNotifyInFriend = "【武林大会】您的好友[eebb01]%s[-]所在战队在刚刚结束的[eebb01]%s初赛[-]中取得了胜利。"

    nPreGamePreMap    = 1; --开始加载准备场数，跨服上就只建一个准备场图不能增加了
    nSynTopZoneTeamDataTimeDelay = 20; --每场比赛完最多20秒一次更新数据

    nWinJiFen = 3; --胜利积分
    nFailJiFen = 0; --失败积分
    nDogfallJiFen = 1; --平局积分

    nPrepareTime = 180; --准备时间秒
    nPlayGameTime = 150; --比赛时间秒
    nFreeGameTime = 30; --间隔时间
    nKickOutTime = 30; --踢出去的时间
    nPlayerGameCount = 9; --每天中共开启次数
    nMatchMaxFindCount = 8; --向下寻找多少战队
    nPerDayJoinCount = 20; --每天参加多少次

    nDefWinPercent = 0.5; --默认胜率
    nPrepareMapTID = 1302; --准备场的地图
    nPlayMapTID = 1303; --比赛地图

    nMatchEmptyTime = 1.5 * 60; --轮空的时间
    tbPlayMapEnterPos = --进入比赛地图的位置
    {
        [1] = {2752, 3213};
        [2] = {4665, 3213};
    };

    nShowInfoPlayTeamTime = 8; --显示对阵图的时间
    nPlayDelayTime        = 3; --321延迟多么后开战
    nEndDelayLeaveMap     = 8; --结束延迟多少秒离开地图

    tbAllAward = {};
};

--冠军竞猜
tbDef.tbChampionGuessing =
{
    nMinLevel = 60; --最小等级
    tbWinAward = {{"Gold", 300}};--猜中给的奖励
    szAwardMail = "Quán Quân Đại Hội Võ Lâm %s là chiến đội %s, đại hiệp đã dự đoán chính xác, hãy nhận thưởng đính kèm.";
};

--武林大会主界面的预告说明
-- tbDef.szYuGaoUiTexture = "UI/Textures/GrowInvest02.png"
tbDef.szYuGaoUiDesc = [[
      [eebb01]「Đại Hội Võ Lâm」[-] là giải đấu cấp cao nhất trong giang hồ, người chơi từng đạt [eebb01]Top 50[-] Hoa Sơn Luận Kiếm trong năm đủ điều kiện lập chiến đội  vào Lôi Đài chiến đấu [eebb01]Liên SV[-], người mạnh nhất sẽ nhận được vinh dự Võ Lâm Chí Tôn.
      Đại hội tổng cộng có [eebb01]3[-] hình thức thi đấu, lần lượt là [eebb01]Song Đấu[-], [eebb01]Tam Đấu[-] và [eebb01]Tứ Đấu[-], mỗi hình thức sẽ chọn ra [eebb01]Võ Lâm Chí Tôn[-], mỗi vị đại hiệp có thể chọn tham gia [eebb01]2[-] hình thức thi đấu.
    Khi kết thúc [eebb01]giai đoạn dự báo[-]:
      Đại hiệp đạt Lv60, từng đạt Top 50 Hoa Sơn Luận Kiếm trong năm sẽ được tham gia thi đấu.
      Đã mở cấp tối đa Lv69 nhưng điều kiện nhận tư cách đối với máy chủ trước đây chưa mở Hoa Sơn Luận Kiếm là đạt [eebb01]Top 200[-] BXH Lực Chiến Server.
    Chi tiết Đại Hội hãy xem trang [eebb01]Tin Mới[-]!
]]
tbDef.tbMatchUiDesc = 
{
	[1] = [[
        Song Đấu
        Song Đấu giới hạn thành viên tham gia là [eebb01]2 người[-], mỗi người chơi có thể mang theo một Đồng Hành trợ chiến. Trong Sảnh Chờ có thể nhấp hình đại diện của Đồng Hành trong [eebb01]Đội[-] để đổi Đồng Hành trợ chiến.
	]];
	[2] = [[
        Tam Đấu
        Tam Đấu giới hạn thành viên tham gia là [eebb01]3 người[-], mỗi người chơi có thể mang theo một Đồng Hành trợ chiến. Trong Sảnh Chờ có thể nhấp hình đại diện của Đồng Hành trong [eebb01]Đội[-] để đổi Đồng Hành trợ chiến.
	]];
	-- [3] = [[
	-- 	三人决斗人赛说明
	-- 	三人决斗赛限制战队成员为[eebb01]3名[-]，根据队员编号与其他战队成员分别对战，已上阵同伴均可助战。
	-- ]];
	[3] = [[
        Tứ Đấu
        Tứ Đấu giới hạn thành viên tham gia là [eebb01]4 người[-], không thể mang Đồng Hành trợ chiến.
	]];
}


WuLinDaHui.tbScheduleDay =  {
	 {
		nGameType = 1;
	};
	{
		nGameType = 1;
	};
	{
		nGameType = 2;
	};
	{
		nGameType = 2;
	};
    {
        nGameType = 3;
    };
    {
        nGameType = 3;
    };
	{
		nGameType = 1;
		bFinal = true;
	};
	{
		nGameType = 2;
		bFinal = true;
	};
    {
        nGameType = 3;
        bFinal = true;
    };
}

WuLinDaHui.tbGameFormat = {
	[1] = {
		szName = "Song Đấu";
		nFightTeamCount = 2;
		bOpenPartner = true; --是否开启同伴
        szDescTip = "2 người tổ đội tham gia"; --界面里的简短说明
        szTexture = "UI/Textures/WLDH1.png";
	};
	[2] = {
		szName = "Tam Đấu";
		nFightTeamCount = 3;
		bOpenPartner = true; --是否开启同伴
        szDescTip = "3 người tổ đội tham gia"; 
        szTexture = "UI/Textures/WLDH2.png";
	};
	-- [3] = {
	-- 	szName = "三人决斗赛";
	-- 	nFightTeamCount = 3;
	-- 	szPKClass = "PlayDuel";
	-- 	bOpenPartner = false; --是否开启同伴
 --        nPartnerPos = 4; --上阵同伴数
	-- 	nFinalsMapCount = 3; --会创建三个地图
 --        szDescTip = "三人组队，按照编号分别对战的比赛"; 
        -- szTexture = "UI/Textures/WLDH3.png";
	-- };
	[3] = {
		szName = "Tứ Đấu";
		nFightTeamCount = 4;
		bOpenPartner = false; --是否开启同伴
        szDescTip = "4 người tổ đội tham gia"; 
        szTexture = "UI/Textures/WLDH4.png";
	};
};


tbDef.tbFinalsGame =
{
    szBeforeNotifyMsg = "【Đại Hội Võ Lâm】[eebb01]Quán Quân tranh đoạt chiến %s[-] sẽ bắt đầu sau [eebb01]3 phút[-]!";

    nFinalsMapTID = 1304; --决赛的地图
    nAudienceMinLevel = 20; --观众最少等级
    nEnterPlayerCount = 600; --进入观众的人数
    nFrontRank = 16; --前几名进入决赛
    nChampionPlan = 2; --冠军赛的对阵表
    nChampionWinCount = 2; --冠军赛最多赢多少场
    nShowInfoPlayTeamTime = 8; --显示对阵图的时间
    nPlayDelayTime = 3; --321延迟多少秒后PK
    nEndDelayLeaveMap  = 8; --结束延迟多少秒离开
    --tbPlayGameAward = {{"BasicExp", 8}};

    tbAgainstPlan = --对阵图
    {
        [16] = --16强
        {
            [1] = {tbIndex = {1, 16},  tbPos = { [1] = {9337, 13474},  [2] = {11213, 13480} } };
            [2] = {tbIndex = {8, 9},   tbPos = { [1] = {13667, 13495}, [2] = {15542, 13482} } };
            [3] = {tbIndex = {5, 12},  tbPos = { [1] = {13682, 6310},  [2] = {15531, 6321} } };
            [4] = {tbIndex = {4, 13},  tbPos = { [1] = {9348, 6318},   [2] = {11187, 6307} } };
            [5] = {tbIndex = {2, 15},  tbPos = { [1] = {4944, 8026},   [2] = {6800, 8010} } };
            [6] = {tbIndex = {7, 10},  tbPos = { [1] = {4928, 11860},  [2] = {6799, 11854} } };
            [7] = {tbIndex = {6, 11},  tbPos = { [1] = {18108, 11889}, [2] = {19954, 11881} } };
            [8] = {tbIndex = {3, 14},  tbPos = { [1] = {18076, 8024},  [2] = {19956, 8022} } };
        };

        [8] = --8强
        {
            [1] = {tbIndex = {1, 2},  tbPos = { [1] = {9337, 13474},  [2] = {11213, 13480} } };
            [2] = {tbIndex = {3, 4},  tbPos = { [1] = {13667, 13495}, [2] = {15542, 13482} } };
            [3] = {tbIndex = {5, 6},  tbPos = { [1] = {13682, 6310},  [2] = {15531, 6321} } };
            [4] = {tbIndex = {7, 8},  tbPos = { [1] = {9348, 6318},   [2] = {11187, 6307} } };
        };

        [4] = --4强
        {
            [1] = {tbIndex = {1, 2},  tbPos = { [1] = {9337, 13474},  [2] = {11213, 13480} } };
            [2] = {tbIndex = {3, 4},  tbPos = { [1] = {13667, 13495}, [2] = {15542, 13482} } };
        };

        [2] = --2强
        {
            [1] = {tbIndex = {1, 2},  tbPos = { [1] = {11331, 10095}, [2] = {13594, 10064} } };
        };
    };
    
    --决赛状态
    tbPlayGameState =
    {
        [1]  = 
        {
            nNextTime = 180,
            szCall = "Freedom", 
            szRMsg = "Thi đấu sắp bắt đầu", 
            szWorld = "【Đại Hội Võ Lâm】Quán Quân tranh đoạt chiến [eebb01]%s[-] sẽ bắt đầu sau [eebb01]3 phút[-]!";
        };
         [2]  = 
        {   
            nNextTime = 150, 
            szCall = "StartPK",  
            szRMsg = "Đang đấu Top 16",
            szWorld = "【Đại Hội Võ Lâm】Vòng Top 16 [eebb01]%s[-] chính thức bắt đầu!";
            nPlan = 16;
            tbTeamMsg = 
            {
                tbWin = 
                {
                    szMsg = "Chiến đội của đại hiệp lọt vào tứ kết!";
                    szKinMsg = "【Đại Hội Võ Lâm】Chúc mừng chiến đội của [eebb01]%s[-] đã vào vòng tứ kết [eebb01]%s[-]!";
                    szFriend = "【Đại Hội Võ Lâm】Chúc mừng chiến đội của [eebb01]%s[-] đã vào vòng tứ kết [eebb01]%s[-]!";
                };
                tbFail =
                {
                    szMsg = "Đội của đại hiệp chưa thể vào bán kết, hãy cố gắng hơn nữa!";
                };
            };
        };
        [3]  = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Tứ kết sắp bắt đầu";
            --szWorld = "本届武林大会半决赛将在[eebb01]30秒[-]后开始，请大家进场观战并支持心仪的选手！";

        };
        [4]  = 
        {   
            nNextTime = 150, 
            szCall = "StartPK",  
            szRMsg = "Tứ kết đang diễn ra",
            szWorld = "【Đại Hội Võ Lâm】Tứ kết [eebb01]%s[-] chính thức bắt đầu!";
            nPlan = 8;
            tbTeamMsg = 
            {
                tbWin = 
                {
                    szMsg = "Chiến đội của đại hiệp đã lọt vào bán kết!";
                    szKinMsg = "【Đại Hội Võ Lâm】Chúc mừng chiến đội của thành viên Bang [eebb01]%s[-] đã vào vòng bán kết [eebb01]%s[-]!";
                    szFriend = "【Đại Hội Võ Lâm】Chúc mừng chiến đội của hảo hữu [eebb01]%s[-] đã vào vòng bán kết [eebb01]%s[-]!";
                };
                tbFail =
                {
                    szMsg = "Đội của đại hiệp chưa thể vào bán kết, hãy cố gắng hơn nữa!";
                };
            };
        };
        [5]  = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Bán kết sắp mở";
            --szWorld = "本届武林大会半决赛将在[eebb01]30秒[-]后开始，请大家进场观战并支持心仪的选手！";

        };
        [6]  = 
        {
            nNextTime = 150, 
            szCall = "StartPK",
            szRMsg = "Bán kết đang diễn ra",
            nPlan = 4;
            szWorld = "【Đại Hội Võ Lâm】Bán kết [eebb01]%s[-] chính thức bắt đầu!";
            szEndWorldNotify = "Chúc mừng %s đã vào vòng chung kết [eebb01]%s[-]!";
            tbTeamMsg = 
            {
                tbWin = 
                {
                    szMsg = "Chiến đội của đại hiệp đã vào chung kết Đại Hội Võ Lâm!";
                    szKinMsg = "【Đại Hội Võ Lâm】Chúc mừng chiến đội của thành viên Bang [eebb01]%s[-] đã vào vòng chung kết [eebb01]%s[-]!";
                    szFriend = "【Đại Hội Võ Lâm】Chúc mừng chiến đội của hảo hữu [eebb01]%s[-] đã vào vòng chung kết [eebb01]%s[-]!";
                };
                tbFail =
                {
                    szMsg = "Chiến Đội đã thất bại, không thể vào chung kết, hãy tiếp tục cố gắng!";
                };
            };

        };
        [7]  = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Chung kết sắp mở";
            --szWorld = "本届武林大会决赛将在5分钟后开始，谁才是真正的强者？拭目以待！";
            
        };
        [8]  = 
        {
            nNextTime = 150, 
            szCall = "StartPK", 
            szRMsg = "Chung kết 1 đang diễn ra", 
            szWorld = "【Đại Hội Võ Lâm】Trận 1 chung kết [eebb01]%s[-] đã bắt đầu!";
            szNotifyMyWorldTeamMsg = "%s đang chiến đấu để tranh chức Võ Lâm Chí Tôn, mời các thiếu hiệp đến quan chiến!";
            nPlan = 2; 
        };
        [9]  = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Chung kết 2 sắp mở";
        };
        [10]  = 
        {
            nNextTime = 150, 
            szCall = "StartPK", 
            szRMsg = "Chung kết 2 đang diễn ra", 
            szWorld = "【Đại Hội Võ Lâm】Trận 2 chung kết [eebb01]%s[-] đã bắt đầu!";
            szNotifyMyWorldTeamMsg = "%s đang chiến đấu để tranh chức Võ Lâm Chí Tôn, mời các thiếu hiệp đến quan chiến!";
            nPlan = 2; 
        };
        [11]  = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Chung kết 3 sắp mở",
            bCanStop = true;
        };
        [12] = 
        {
            nNextTime = 150, 
            szCall = "StartPK", 
            szRMsg = "Chung kết 3 đang diễn ra",
            nPlan = 2;
            bCanStop = true;
            szWorld = "【Đại Hội Võ Lâm】Trận cuối chung kết [eebb01]%s[-] đã bắt đầu!";
            szNotifyMyWorldTeamMsg = "%s đang chiến đấu để tranh chức Võ Lâm Chí Tôn, mời các thiếu hiệp đến quan chiến!";
        };
        [13] = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Thi đấu kết thúc";
        };
        [14] = 
        {
            nNextTime = 150, 
            szCall = "SendAward", 
            szRMsg = "Rời khỏi";
        };
        [15] = 
        {
            nNextTime = 0, 
            szCall = "KickOutAllPlayer", 
            szRMsg = "Rời khỏi",
        };
    };
};


function WuLinDaHui:GetMatchIndex(nPlan, nRank)
	local tbMathcInfo = tbDef.tbFinalsGame.tbAgainstPlan[ nPlan ]
	for i,v in ipairs(tbMathcInfo) do
		for i2,v2 in ipairs(v.tbIndex) do
			if nRank == v2 then
				return i2, i, #tbMathcInfo;
			end	
		end
	end
end

WuLinDaHui.szActNameYuGao = "WuLinDaHuiActYuGao"
WuLinDaHui.szActNameBaoMing = "WuLinDaHuiActBaoMing"
WuLinDaHui.szActNameMain = "WuLinDaHuiAct"

WuLinDaHui.nActYuGaoTime = 60;-- 活动开始到预告结束的时间

function WuLinDaHui:IsBaoMingAndMainActTime()
	local bIsAct = Activity:__IsActInProcessByType(self.szActNameBaoMing)
	if bIsAct then
		return true, self.szActNameBaoMing
	end
	bIsAct = Activity:__IsActInProcessByType(self.szActNameMain)
	if bIsAct then
		return true, self.szActNameMain
	end
end

function WuLinDaHui:IsInMap(nMapTemplateId)
    if self.tbDef.tbPrepareGame.nPrepareMapTID == nMapTemplateId or
          self.tbDef.tbPrepareGame.nPlayMapTID == nMapTemplateId or
          self.tbDef.tbFinalsGame.nFinalsMapTID == nMapTemplateId then
          return true
    end
    return false
end

function WuLinDaHui:GetToydayGameFormat()
    local nStartTime, nEndTime = Activity:__GetActTimeInfo(self.szActNameMain)
    if not nStartTime then
        return
    end

    local nToday = Lib:GetLocalDay()
    local nOpenActDay = Lib:GetLocalDay(nStartTime)
    local nActStartDaySec = Lib:GetLocalDayTime(nStartTime)
    local nMatchDay = nToday - nOpenActDay + 1
    local tbScheInfo = self.tbScheduleDay[nMatchDay]
    if not tbScheInfo then
        return
    end
    return tbScheInfo.nGameType
end

function WuLinDaHui:CanOperateParnter()
    local nGameType = self:GetToydayGameFormat()
    if not nGameType then
        return
    end
    local tbGameFormat = self.tbGameFormat[nGameType]
    if tbGameFormat.bOpenPartner or tbGameFormat.nPartnerPos then
        return true
    end
    return false
end

function WuLinDaHui:GetGameTypeByTeamId(nFightTeamID)
    local nLeft = nFightTeamID % tbDef.nServerIdxInTeamId
    return math.floor(nLeft / tbDef.nGameTypeInTeamId)
end

function WuLinDaHui:GetPreEndBaoMingTime(nGameType)
    local nStartTime, nEndTime = Activity:__GetActTimeInfo(self.szActNameMain)
    if nStartTime == 0 then
        return
    end
    if not self.tbCachePreEndBaoMingTime then
        self.tbCachePreEndBaoMingTime = {};
    end
    local nPreEndTime = self.tbCachePreEndBaoMingTime[nGameType]
    if nPreEndTime then
        return nPreEndTime
    end
    local nEndPreMatchDay = 0
    for i,v in ipairs(WuLinDaHui.tbScheduleDay) do
        if v.bFinal then
            break;
        elseif v.nGameType == nGameType then
            nEndPreMatchDay = i;
        end
    end
    local szEndStartTime = WuLinDaHui.tbDef.tbEndMatchTime[#WuLinDaHui.tbDef.tbEndMatchTime]
    local hour1, min1 = string.match(szEndStartTime, "(%d+):(%d+)");
    local tbTime = os.date("*t", nStartTime + 3600 * 24 * (nEndPreMatchDay - 1))
    local nSecBegin = os.time({year = tbTime.year, month = tbTime.month, day = tbTime.day, hour = hour1, min = min1, sec = 0}); 
    self.tbCachePreEndBaoMingTime[nGameType] = nSecBegin
    return nSecBegin
end


function WuLinDaHui:IsBaoMingTime(nGameType)
    if Activity:__IsActInProcessByType(self.szActNameBaoMing) then
        return true
    else
        local nPreEndTime = self:GetPreEndBaoMingTime(nGameType)
        if nPreEndTime and GetTime() < nPreEndTime - 100 then
            return true
        end
    end
    
    return false, "Không trong thời gian báo danh"
end
