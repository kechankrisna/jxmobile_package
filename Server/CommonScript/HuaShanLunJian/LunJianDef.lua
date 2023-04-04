
HuaShanLunJian.tbDef = HuaShanLunJian.tbDef or {};

local tbDef = HuaShanLunJian.tbDef;
tbDef.nPlayStateNone = 0; --赛季的状态没有
tbDef.nPlayStatePrepare = 1; --赛季的状态预选赛
tbDef.nPlayStateFinals = 2; --赛季的状态决赛
tbDef.nPlayStateEnd = 3; --赛季的状态结束
tbDef.nPlayStateMail = 4; --赛季的状态开始发邮件

tbDef.nPlayGameStateNone = 1; --比赛没有
tbDef.nPlayGameStateStart = 2; --比赛开始
tbDef.nPlayGameStateEnd   = 3; --比赛结束

tbDef.nSaveGroupID = 103; --保存的Group
tbDef.nSaveMonth   = 1; --保存月
tbDef.nSaveFightTeamID  = 2; --保存战队
tbDef.nSaveFightTeamTime = 3; --创建战队的时间

tbDef.nSaveGuessGroupID = 105; --保存竞猜的Group
tbDef.nSaveGuessVer = 1; --保存竞猜的版本
tbDef.nSaveGuessTeam = 2; --保存竞猜的队伍
tbDef.nSaveGuessOneNote = 3; --保存竞猜的注数

tbDef.nSaveHonorGroupID = 110; --保存荣誉
tbDef.nSaveHonorValue   = 1; --保存荣誉值

tbDef.nTeamTypeName   = 1; --战队的名称
tbDef.nTeamTypePlayer = 2; --战队的成员
tbDef.nTeamTypeValue  = 3; --战队的参加的值 积分 * 100 * 100 + 胜利场数 * 100 + 总共场数
tbDef.nTeamTypeTime   = 4; --战队的参加的时间
tbDef.nTeamTypePlayDay   = 5; --战队的天的时间
tbDef.nTeamTypePerCount   = 6; --战队的每天的次数
tbDef.nTeamTypeServerIdx = 7; --战队的服务器索引，只在武林大会中用到 --前20强, 因为要传回本服时设置新的队伍id，所以还是设值的
tbDef.nTeamTypeServerName = 8; --战队的服务器名，只在武林大会中用到 --前20强
tbDef.nTeamTypeRank = 9; --战队的排名，跨服上排一次存回本服 武林大会用 

tbDef.nPrePlayTotalTime = 100000; --设置一个最大的时间 

tbDef.nMaxFightTeamVer     = 10000; --最大版本号
tbDef.nMaxFightTeamCount   = 500; --最大战队数
tbDef.nUpateDmgTime        = 2;


tbDef.nGuessTypeTeam    = 1; --竞猜的战队
tbDef.nGuessTypeOneNote = 2; --竞猜的注数
tbDef.nSaveGuessingCount = 1500; --保存玩家竞猜数
tbDef.nMaxGuessingVer    = 1000; --保存最大竞猜数版本

tbDef.nNextPreGamePreMap  = 2; --使用完准备场数加载数
tbDef.nPreGamePreMapTime  = 5; --重新创建地图的时间




-------下面策划填写 ----------------------------------------
tbDef.szRankBoard      = "LunJianRank";
tbDef.szOpenTimeFrame = "HuaShanLunJian"; --开启时间轴
tbDef.fPlayerToNpcDmg = 0.1; --玩家对Npc的伤害占得比例
tbDef.nGameMaxRank    = 1002; --最大排行
tbDef.nMinPlayerLevel = 60; --最小等级开启
tbDef.nFightTeamNameMin = 3; --战队长度最小
tbDef.nFightTeamNameMax = 6; --战队长度最大

if version_vn then
tbDef.bStringLenName = true;
tbDef.nFightTeamNameMin = 4; --越南战队长度最小
tbDef.nFightTeamNameMax = 14; --越南战队长度最大
end

if version_th then
tbDef.nFightTeamNameMin = 6;
tbDef.nFightTeamNameMax = 10;
end    

tbDef.nFightTeamJoinMemebr = 2; --组入队员 两人单独组队

tbDef.nDeathSkillState = 1520; --死亡后状态
tbDef.nPartnerFightPos = 1; --伙伴的出战位置
tbDef.nHSLJCrateLimitTime = 4 * 3600;
tbDef.nChampionshipNewTime = 15 * 60 * 60 * 24;
tbDef.nHSLJHonorBox = 2000; --多少荣誉一个宝箱
tbDef.nHSLJHonorBoxItem = 2853; --荣誉宝箱ID

tbDef.nFightTeamShowTitle = 
{
    [1] = 7006;
    [2] = 7007;
};

tbDef.tbStatueMapID = --雕像的地图ID
{ 
    [10] = 
    {
        nTitleID = 7004;
        tbAllPos = 
        {
            [1] = {11630, 15865, 0};
            [2] = {11079, 15330, 48};
            [3] = {12200, 15323, 16};
            [4] = {11620, 14723, 32};
        };
    };

    [15] = 
    {
        nTitleID = 7004;
        tbAllPos = 
        {
            [1] = {13495, 12170, 40};
            [2] = {13495, 10299, 56};
            [3] = {11645, 10294, 8};
            [4] = {11642, 12149, 24};
        };
    };
};

tbDef.tbFactionStatueNpc = --门派雕像Npc
{
    [1] = --男
    {
        [1] = 1886; --天王
        [2] = 1887; --峨嵋
        [3] = 1888; --桃花
        [4] = 1889; --逍遥
        [5] = 1890; --武当
        [6] = 1891; --天忍
        [7] = 1892; --少林
        [8] = 1893; --翠烟
        [9] = 2118;--唐门
        [10] = 2971;--昆仑
        [11] = 2221;--丐帮
        [12] = 2220;--五毒
        [13] = 2381;--藏剑
        [14] = 2382;--长歌
        [15] = 2677;--天山
        [16] = 2912;--霸刀
        [17] = 2969;--华山
        [18] = 3283;--明教
        [19] = 3443;--段氏
    };
    [2] = --女
    {
        [1] = 3285; --天王
        [2] = 1887; --峨嵋
        [3] = 1888; --桃花
        [4] = 1889; --逍遥
        [5] = 2914; --武当
        [6] = 1891; --天忍
        [7] = 1892; --少林
        [8] = 1893; --翠烟
        [9] = 2118;--唐门
        [10] = 2119;--昆仑
        [11] = 2221;--丐帮
        [12] = 2220;--五毒
        [13] = 2381;--藏剑
        [14] = 2382;--长歌
        [15] = 2678;--天山
        [16] = 2913;--霸刀
        [17] = 2970;--华山
        [18] = 3284;--明教
        [19] = 3444;--段氏
    };
}

--赛制
tbDef.tbGameFormat =
{
    [1] = 
    {
        szName = "Song Đấu";
        nFightTeamCount = 2; --战队的人数
        bOpenPartner = true; --是否开启同伴
        szOpenHSLJMail =
[[  Hoa Sơn Luận Kiếm đã bắt đầu!
    Thể thức Hoa Sơn Luận Kiếm kì này là [FFFE0D]Song Đấu[-], mỗi người có thể dẫn theo 1 Đồng Hành hỗ trợ. Hãy cùng hảo hữu tác chiến, sớm ngày trở thành Võ Lâm Chí Tôn!
    Sau khi Hoa Sơn Luận Kiếm bắt đầu sẽ thay thế cho Thi Đấu Môn Phái vào mỗi chủ nhật.
]];
        szHSLJPanelContent = --比赛面板介绍文字,需要能取到赛制信息
[[
[FFFE0D]Song Đấu của Hoa Sơn Luận Kiếm tháng này đã bắt đầu![-]
    Thành viên trong Chiến Đội Song Đấu là [FFFE0D]2 người[-], mỗi người có thể dẫn theo 1 Đồng Hành để trợ chiến. Có thể nhấp hình đại diện Đồng Hành kế bên [FFFE0D]Đội[-] tại Sảnh Chờ để đổi Đồng Hành trợ chiến.
    Vòng Sơ Tuyển bắt đầu, mỗi tuần có [FFFE0D]16[-] cơ hội thi đấu, tối đa [FFFE0D]32 lần[-].
      Đội phải tham gia ít nhất [FFFE0D]4 trận[-] vòng Sơ Loại, kết thúc mùa đấu mới được nhận thưởng.
    [FFFE0D]Chú ý: [-]Báo danh thi đấu không cần tổ đội, hệ thống sẽ tự động lập đội
]];
    };

    [2] =
    {
        szName = "Tam Đấu";
        nFightTeamCount = 3; --战队的人数
        bOpenPartner = true; --是否开启同伴
        szOpenHSLJMail =
[[  Hoa Sơn Luận Kiếm đã bắt đầu!
    Thể thức Hoa Sơn Luận Kiếm kì này là [FFFE0D]Tam Đấu[-], mỗi người có thể dẫn theo 1 Đồng Hành hỗ trợ. Hãy cùng hảo hữu tác chiến, sớm ngày trở thành Võ Lâm Chí Tôn!
    Sau khi Hoa Sơn Luận Kiếm bắt đầu sẽ thay thế cho Thi Đấu Môn Phái vào mỗi chủ nhật.
]];
        szHSLJPanelContent = --比赛面板介绍文字,需要能取到赛制信息
[[
[FFFE0D]Tam Đấu của Hoa Sơn Luận Kiếm tháng này đã bắt đầu![-]
    Thành viên trong Chiến Đội Tam Đấu là [FFFE0D]3 người[-], mỗi người có thể dẫn theo 1 Đồng Hành để trợ chiến. Có thế nhấp hình đại diện Đồng Hành kế bên [FFFE0D]Đội[-] tại Sảnh Chờ để đổi Đồng Hành trợ chiến.
    Vòng Sơ Tuyển bắt đầu, mỗi tuần có [FFFE0D]16[-] cơ hội thi đấu, tối đa [FFFE0D]32 lần[-].
      Đội phải tham gia ít nhất [FFFE0D]4 trận[-] vòng Sơ Loại, kết thúc mùa đấu mới được nhận thưởng.
    [FFFE0D]Chú ý: [-]Báo danh thi đấu không cần tổ đội, hệ thống sẽ tự động lập đội
]];
    };

    [3] =
    {
        szName = "Tam Quyết Đấu";
        nFightTeamCount = 3; --战队的人数
        bOpenPartner = false; --是否开启同伴
        nPartnerPos  = 4; --上阵的同伴位置
        szPKClass = "PlayDuel"; --决斗赛的类别 新增赛季通知程序
        nFinalsMapCount = 3; --创建决赛地图数量
        szOpenHSLJMail =
[[  Hoa Sơn Luận Kiếm đã bắt đầu!
    Thể thức Hoa Sơn Luận Kiếm kì này là [FFFE0D]Tam Quyết Đấu[-], mỗi người có thể dẫn theo tất cả Đồng Hành đã ra trận để hỗ trợ. Hãy cùng hảo hữu tác chiến, sớm ngày trở thành Võ Lâm Chí Tôn!
    Sau khi Hoa Sơn Luận Kiếm bắt đầu sẽ thay thế cho Thi Đấu Môn Phái vào mỗi chủ nhật.
]];
        szHSLJPanelContent = --比赛面板介绍文字,需要能取到赛制信息
[[
[FFFE0D]Tam Quyết Đấu Hoa Sơn Luận Kiếm tháng này đã bắt đầu![-]
    Thành viên trong Chiến Đội Tam Quyết Đấu là [FFFE0D]3 người[-], căn cứ vào số hiệu thành viên để giao chiến với thành viên của Chiến Đội khác. Đồng hành đã từng trợ chiến đều có thể xuất trận.
    Vòng Sơ Tuyển bắt đầu, mỗi tuần có [FFFE0D]16[-] cơ hội thi đấu, tối đa [FFFE0D]32 lần[-].
      Đội phải tham gia ít nhất [FFFE0D]4 trận[-] vòng Sơ Loại, kết thúc mùa đấu mới được nhận thưởng.
    [FFFE0D]Chú ý: [-]Báo danh thi đấu không cần tổ đội, hệ thống sẽ tự động lập đội
]];
    };

    [4] =
    {
        szName = "Đấu Cá Nhân";
        nFightTeamCount = 1; --战队的人数
        bOpenPartner = false; --是否开启同伴
        nPartnerPos  = 4; --上阵的同伴位置
        szOpenHSLJMail =
[[  Hoa Sơn Luận Kiếm đã bắt đầu!
    Hoa Sơn Luận Kiếm lần này là cơ chế [FFFE0D]đấu cá nhân[-], mỗi người có thể mang đồng hành theo trợ chiến, mọi người mau nhanh chân!
    Sau khi Hoa Sơn Luận Kiếm bắt đầu sẽ thay thế cho Thi Đấu Môn Phái vào mỗi chủ nhật.
]];
        szHSLJPanelContent = --比赛面板介绍文字,需要能取到赛制信息
[[
[FFFE0D]Đấu cá nhân Hoa Sơn Luận Kiếm tháng này đã bắt đầu![-]
    Chiến đội đấu cá nhân chỉ có [FFFE0D]1 người[-], Đồng Hành đã ra trận đều có thể trợ chiến.
    Vòng Sơ Tuyển bắt đầu, mỗi tuần có [FFFE0D]16[-] cơ hội thi đấu, tối đa [FFFE0D]32 lần[-].
      Đội phải tham gia ít nhất [FFFE0D]4 trận[-] vòng Sơ Loại, kết thúc mùa đấu mới được nhận thưởng.
]];
    };

    [5] = 
    {
        szName = "Song Đấu Khắc Hệ";
        nFightTeamCount = 2; --战队的人数
        bOpenPartner = true; --是否开启同伴
        bSeriesLimit = true; --成员五行相克限制
        szOpenHSLJMail =
[[  Hoa Sơn Luận Kiếm đã bắt đầu!
    Hoa Sơn Luận Kiếm lần này theo qui tắc [FFFE0D]Song Đấu Khắc Hệ[-], mỗi người có thể dẫn theo 1 đồng hành để trợ chiến. Ngũ hành chiến đội 2 người phải tương khắc với nhau, ví dụ Kim Mộc, Hỏa Kim, Mộc Thổ. Hãy cùng chiến đấu với đồng hành của mình để trở thành Võ Lâm Chí Tôn!
    Sau khi Hoa Sơn Luận Kiếm bắt đầu sẽ thay thế cho Thi Đấu Môn Phái vào mỗi chủ nhật.
]];
        szHSLJPanelContent = --比赛面板介绍文字,需要能取到赛制信息
[[
[FFFE0D]Hoa Sơn Luận Kiếm Song Đấu Khắc Hệ tháng này đã bắt đầu![-]
    Thành viên chiến đội Song Đấu là [FFFE0D]2 người[-], ngũ hành chiến đội hai người phải tương khắc với nhau, ví dụ Kim Mộc, Hỏa Kim, Mộc Thổ. Hãy cùng chiến đấu với đồng hành của mình nào!
    Vòng Sơ Tuyển bắt đầu, mỗi tuần có [FFFE0D]16[-] cơ hội thi đấu, tối đa [FFFE0D]32 lần[-].
      Đội phải tham gia ít nhất [FFFE0D]4 trận[-] vòng Sơ Loại, kết thúc mùa đấu mới được nhận thưởng.
    [FFFE0D]Chú ý: [-]Báo danh thi đấu không cần tổ đội, hệ thống sẽ tự động lập đội
]];
    };

};

tbDef.tbSkipGameFormat = --更换赛季:暂时关闭单人赛
{
    [4] = 1;
};

-- if version_tx then
--     tbDef.tbSkipGameFormat = --更换赛季
--     {
--         [3] = 4;
--     };
-- end

--冠军竞猜
tbDef.tbChampionGuessing =
{
    nMinLevel = 60; --最小等级
    nOneNoteGold  = 200; --猜中给多少钱
    nMaxOneNote   = 5; -- 最大投注数 废弃
    szAwardMail = "Quán quân Hoa Sơn Luận Kiếm lần này là Chiến Đội %s, đại hiệp đã tham gia và dự đoán chính xác Hoa Sơn Luận Kiếm lần này, nhận %s Nguyên Bảo, hãy nhận đính kèm.";
};


--预选赛
tbDef.tbPrepareGame =
{
    szStartWorldNotify = "3 phút sau Hoa Sơn Luận Kiếm hôm nay sẽ mở báo danh, hãy chuẩn bị!";
    szPreOpenWorldMsg = "Vòng loại Hoa Sơn Luận Kiếm mới đã mở báo danh, thời gian là 3 phút, hãy mau báo danh.";
    bShowMSgWhenEnterMatchTime = true; ---在每次等待下次匹配的时候都世界公告
    nStartMonthDay = 7; --每月开始几号
    nStartOpenTime = 10 * 3600; --每月开始几号的时间

    nPreGamePreMap    = 5; --开始加载准备场数
    
    nStartEndMonthDay = 15; --未超过本月几号开始活动
    nEndMothDay = 27;  --结束时间

    nMaxPlayerJoinCount = 32; --最大参加场数
    nPerWeekJoinCount = 16; --每周获得场数
    nWinJiFen = 3; --胜利积分
    nFailJiFen = 0; --失败积分
    nDogfallJiFen = 1; --平局积分

    nPrepareTime = 180; --准备时间秒
    nPlayGameTime = 150; --比赛时间秒
    nFreeGameTime = 30; --间隔时间
    nKickOutTime = 3 * 60; --踢出去的时间
    nPlayerGameCount = 8; --每天中共开启次数
    nMatchMaxFindCount = 8; --向下寻找多少战队
    nPerDayJoinCount = 6; --每天参加多少次

    nDefWinPercent = 0.5; --默认胜率
    nPrepareMapTID = 1200; --准备场的地图
    nPlayMapTID = 1201; --比赛地图

    nMatchEmptyTime = 1.5 * 60; --轮空的时间
    tbPlayMapEnterPos = --进入比赛地图的位置
    {
        [1] = {1440, 2961};
        [2] = {3697, 2949};
    };

    nShowInfoPlayTeamTime = 8; --显示对阵图的时间
    nPlayDelayTime        = 3; --321延迟多么后开战
    nEndDelayLeaveMap     = 8; --结束延迟多少秒离开地图
    nMaxEnterTeamCount    = 50; --最多进入战队数

    tbAllAward =  --奖励
    {
        tbWin = --赢
        {
            {"BasicExp", 15};
            {"item", 2424, 2};
        };

        tbDogfall = --平
        {
            {"BasicExp", 10};
            {"item", 2424, 1};
        };

        tbFail = --失败
        {
            {"BasicExp", 10};
            {"item", 2424, 1};
        };
    };

    tbAwardMail =
    {
        szWin = "Chiến Đội đã thắng 1 trận trong vòng loại Hoa Sơn Luận Kiếm, hãy nhận thưởng đính kèm!";
        szDogfall = "Chiến Đội ngang tài ngang sức với đối thủ trong vòng loại Hoa Sơn Luận Kiếm, hãy nhận thưởng đính kèm!";
        szFail = "Chiến Đội thất bại trong vòng loại Hoa Sơn Luận Kiếm, hãy nhận thưởng đính kèm!";
    };
};


--决赛
tbDef.tbFinalsGame =
{
    szInformFinals = "Chiến Đội đã vào tứ kết. Chung kết mở vào [FFFE0D]21:30, ngày 28 tháng này[-], hãy tham gia đúng giờ!"; --八强邮件内容
    nMonthDay = 28; --决赛日期
    nFinalsMapTID = 1202; --决赛的地图
    nAudienceMinLevel = 20; --观众最少等级
    nEnterPlayerCount = 300; --进入观众的人数
    nFrontRank = 8; --前几名进入决赛
    nChampionPlan = 2; --冠军赛的对阵表
    nChampionWinCount = 2; --冠军赛最多赢多少场
    nShowInfoPlayTeamTime = 8; --显示对阵图的时间
    nPlayDelayTime = 3; --321延迟多少秒后PK
    nEndDelayLeaveMap  = 8; --结束延迟多少秒离开
    --tbPlayGameAward = {{"BasicExp", 8}};

    tbAgainstPlan = --对阵图
    {
        [8] = --8强
        {
            [1] = {tbIndex = {1, 8},  tbPos = { [1] = {1529, 6364}, [2] = {3643, 6346} } };
            [2] = {tbIndex = {4, 5},  tbPos = { [1] = {9104, 6291}, [2] = {11249, 6279} } };
            [3] = {tbIndex = {2, 7},  tbPos = { [1] = {2505, 3141}, [2] = {4671, 3141} } };
            [4] = {tbIndex = {3, 6},  tbPos = { [1] = {8617, 3277}, [2] = {10774, 3254} } };
        };

        [4] = --4强
        {
            [1] = {tbIndex = {1, 2}, tbPos = { [1] = {1529, 6364}, [2] = {3643, 6346} } };
            [2] = {tbIndex = {3, 4}, tbPos = { [1] = {9104, 6291}, [2] = {11249, 6279} } };
        };

        [2] = --2强
        {
            [1] = {tbIndex = {1, 2},  tbPos = { [1] = {5170, 9474}, [2] = {7765, 9420} } };
        };
    };

    --决赛状态
    tbPlayGameState =
    {
        [1]  = 
        {
            nNextTime = 300,
            szCall = "Freedom", 
            szRMsg = "Thi đấu sắp bắt đầu", 
            szWorld = "Tranh Quán Quân Hoa Sơn Luận Kiếm sẽ mở sau [FFFE0D]5 phút [-] nữa! Có thể vào ủng hộ tuyển thủ mình yêu thích!";
        };
        [2]  = 
        {   
            nNextTime = 150, 
            szCall = "StartPK",  
            szRMsg = "Tứ kết đang diễn ra",
            szWorld = "[FFFE0D]Tứ kết[-] Hoa Sơn Luận Kiếm lần này đã bắt đầu!";
            nPlan = 8;
            tbTeamMsg = 
            {
                tbWin = 
                {
                    szMsg = "Đội của đại hiệp lọt vào bán kết Hoa Sơn Luận Kiếm!";
                    szKinMsg = "Chiến Đội thành viên bang「%s」đã vào chung kết Hoa Sơn Luận Kiếm!";
                    szFriend = "Đội của「%s」lọt vào bán kết Hoa Sơn Luận Kiếm!";
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
            szRMsg = "Bán kết sắp mở";
            --szWorld = "本届华山论剑半决赛将在[FFFE0D]30秒[-]后开始，请大家进场观战并支持心仪的选手！";

        };
        [4]  = 
        {
            nNextTime = 150, 
            szCall = "StartPK",
            szRMsg = "Bán kết đang diễn ra",
            nPlan = 4;
            szWorld = "[FFFE0D]Bán kết[-] Hoa Sơn Luận Kiếm lần này đã bắt đầu!";
            szEndWorldNotify = "%s lọt vào chung kết Hoa Sơn Luận Kiếm, sẽ quyết đấu trên đỉnh Hoa Sơn!";
            tbTeamMsg = 
            {
                tbWin = 
                {
                    szMsg = "Chiến Đội đã vào chung kết Hoa Sơn Luận Kiếm!";
                    szKinMsg = "Chiến Đội thành viên bang「%s」đã vào chung kết Hoa Sơn Luận Kiếm!";
                    szFriend = "Đội của「%s」lọt vào chung kết Hoa Sơn Luận Kiếm, chức quán quân nằm trong tầm tay!";
                };
                tbFail =
                {
                    szMsg = "Chiến Đội đã thất bại, không thể vào chung kết, hãy tiếp tục cố gắng!";
                };
            };

        };
        [5]  = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Chung kết sắp mở";
            --szWorld = "本届华山论剑决赛将在5分钟后开始，谁才是真正的强者？拭目以待！";
        };
        [6]  = 
        {
            nNextTime = 150, 
            szCall = "StartPK", 
            szRMsg = "Chung kết 1 đang diễn ra", 
            szWorld = "[FFFE0D]Chung kết 1[-] Hoa Sơn Luận Kiếm lần này đã bắt đầu!";
            nPlan = 2; 
        };
        [7]  = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Chung kết 2 sắp mở";
        };
        [8]  = 
        {
            nNextTime = 150, 
            szCall = "StartPK", 
            szRMsg = "Chung kết 2 đang diễn ra", 
            szWorld = "[FFFE0D]Chung kết 2[-] Hoa Sơn Luận Kiếm lần này đã bắt đầu!";
            nPlan = 2; 
        };
        [9]  = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Chung kết 3 sắp mở",
            bCanStop = true;
        };
        [10] = 
        {
            nNextTime = 150, 
            szCall = "StartPK", 
            szRMsg = "Chung kết 3 đang diễn ra",
            nPlan = 2;
            bCanStop = true;
            szWorld = "[FFFE0D]Trận chung kết[-] đã bắt đầu, đây là trận đấu quyết định";

        };
        [11] = 
        {
            nNextTime = 60, 
            szCall = "StopPK", 
            szRMsg = "Thi đấu kết thúc";
        };
        [12] = 
        {
            nNextTime = 180, 
            szCall = "SendAward", 
            szRMsg = "Rời khỏi";
        };
        [13] = 
        {
            nNextTime = 300, 
            szCall = "KickOutAllPlayer", 
            szRMsg = "Rời khỏi",
        };
    };
}

tbDef.szEightRankMail =  --八强邮件给全服发
[[  Danh sách tham gia [FFFE0D]Tứ kết[-] Hoa Sơn Luận Kiếm đã xuất hiện, vào [FFFE0D]21:30 ngày 28 tháng này[-] sẽ diễn ra trận chung kết, mọi người có thể vào bản đồ Chung Kết để xem. Hiện đã mở hoạt động [FFFE0D]Dự Đoán Quán Quân[-], hãy xem ở giao diện tin mới tương ứng!
]]


tbDef.tbLunJianMapId = {
    [tbDef.tbPrepareGame.nPrepareMapTID] = 1;
    [tbDef.tbPrepareGame.nPlayMapTID] = 1;
    [tbDef.tbFinalsGame.nFinalsMapTID] = 1;
}