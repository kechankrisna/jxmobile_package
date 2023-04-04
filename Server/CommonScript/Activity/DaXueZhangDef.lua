

Activity.tbDaXueZhang = Activity.tbDaXueZhang or {}
local tbDaXueZhang = Activity.tbDaXueZhang;
tbDaXueZhang.tbDef = tbDaXueZhang.tbDef or {};

local tbDef = tbDaXueZhang.tbDef;
tbDef.nSaveGroup = 122;
tbDef.nSaveJoin = 1;
tbDef.nSaveJoinTime = 2;
tbDef.nSaveVersion = 6;

tbDef.nSaveHonor = 5; --保存的雪站荣誉

tbDef.nMaxTeamVS = 2; --队伍数
tbDef.nUpdateDmgTime = 2; --更新伤害的时间
tbDef.tbMatchingCount = --匹配规则
{
    [3] = {1};
    [2] = {2, 1};
    [1] = {1};
}

tbDef.nWinType = 1; --胜利的奖励类型
tbDef.nFailType = 2; --失败的奖励类型
tbDef.nSinleRankType = 3; -- 单人模式排名奖励

--------------策划填写 --------------------------------------------
--tbDef.nActivityVersion = 1; --活动的版本号 注意重新开启要加版本号(改用活动开始时间作为key)
tbDef.nLimitLevel = 20; --最小等级
tbDef.nTeamCount  = 4; --一个队伍的人数

tbDef.nPrepareMapTID = 1700; --准备场地图的ID

tbDef.tbHonorInfo = --兑换荣誉 优先级从上到下
{
    {nNeed = 2000, nItemID = 3538};
    {nNeed = 1000, nItemID = 3537};
};

tbDef.tbPreMapState =  --准备场的的状态
{
    [1] = { nNextTime = 300, szCall = "Freedom", szRMsg = "Chờ hoạt động bắt đầu: "};
    [2] = { nNextTime = 270, szCall = "StartPlay", szRMsg = "Chờ hoạt động bắt đầu: "};
    [3] = { nNextTime = 270, szCall = "StartPlay", szRMsg = "Chờ hoạt động bắt đầu: "};
    [4] = { nNextTime = 10, szCall = "StartPlay", szRMsg = "Hoạt động kết thúc, mời rời khỏi"};
    [5] = { nNextTime = 10, szCall = "GameEnd", szRMsg = "Rời khỏi"};
};

tbDef.nPlayMapTID = 1701; --PK地图的ID

tbDef.tbPlayerAward = --玩家的奖励
{
    tbWin = --胜利的奖励
    {
        tbRankAward =
        {
            [1] =
            {
                {"BasicExp", 90};
                {"DXZHonor", 3000};
            };
            [2] =
            {
                {"BasicExp", 75};
                {"DXZHonor", 2500};
            };
            [3] =
            {
                {"BasicExp", 60};
                {"DXZHonor", 2000};
            };
            [4] =
            {
                {"BasicExp", 45};
                {"DXZHonor", 1500};
            };
        };

        szMailContent = "Đại hiệp giành được 1 trận thắng ở cuộc thi Ném Tuyết, đính kèm là phần quà, hãy kiểm tra thư!";
        szMsg = "Đội đã thắng trận này!";
    };

    tbFail = --失败的奖励
    {
        tbRankAward =
        {
            [1] =
            {
                {"BasicExp", 75};
                {"DXZHonor", 2500};
            };
            [2] =
            {
                {"BasicExp", 60};
                {"DXZHonor", 2000};
            };
            [3] =
            {
                {"BasicExp", 45};
                {"DXZHonor", 1500};
            };
            [4] =
            {
                {"BasicExp", 30};
                {"DXZHonor", 1000};
            };
        };
        szMailContent = "Đại hiệp đã thất bại ở cuộc thi Ném Tuyết, đính kèm là phần quà, hãy kiểm tra thư!";
        szMsg = "Đại hiệp thất bại, cố lên!";
    };
    tbSinlePlayerAward =                    -- 单人模式排名奖励
    {
        tbRankAward =
        {
            [1] =
            {
                {"BasicExp", 90};
                {"DXZHonor", 3000};
            };
            [2] =
            {
                {"BasicExp", 75};
                {"DXZHonor", 2500};
            };
            [3] =
            {
                {"BasicExp", 60};
                {"DXZHonor", 2000};
            };
            [4] =
            {
                {"BasicExp", 50};
                {"DXZHonor", 1500};
            };
            [5] =
            {
                {"BasicExp", 45};
                {"DXZHonor", 1200};
            };
            [6] =
            {
                {"BasicExp", 30};
                {"DXZHonor", 1000};
            };
        };
        szMailContent = "Chúc mừng đạt hạng %d trong trận này, thưởng %d điểm Tuyết Địa Vinh Dự để có thể đổi rương thưởng. Còn có thể nhận %d điểm để vào xếp hạng toàn máy chủ, chúc may mắn.";
        szMsg = "Nhận thưởng hạng";
    };
};

-- 排名获得积分
tbDef.tbRankJiFen = 
{
    [1] = 100;
    [2] = 80;
    [3] = 60;
    [4] = 40;
    [5] = 30;
    [6] = 15;        
}

-- 积分排名对应奖励
tbDef.tbRankJiFenAward = 
{
    [1] = {1,  {{"Item", 10174, 1}}},        -- N名以下（包括N名）的奖励
    [2] = {5,  {{"Item", 10175, 1}}},
    [3] = {10, {{"Item", 10176, 1}}},
    [4] = {20, {{"Item", 10177, 1}}},
    [5] = {50, {{"Item", 10178, 1}}},
    [6] = {100, {{"Item", 10180, 1}}},
    [7] = {200, {{"Item", 10179, 1}}},
    [8] = {201, {{"Item", 10181, 1}}},
}
tbDef.nDogfallJiFen = 10; --平局的额外的积分
tbDef.szMatchEmpyMsg = "Vòng này không có, không có đối thủ để ghép"; --轮空描述
tbDef.szPanelContent = [[Thi Ném Tuyết
·Thời gian hoạt động: 20/12/2018-3/1/2019
·Cá nhân sau khi báo danh sẽ biến thân thành đứa trẻ, vào bản đồ đặc biệt để tham gia thi đấu ném tuyết 6 người.
·Thi đấu chia làm 3 vòng, đánh bại đối thủ sẽ nhận điểm, khi kết thúc, người điểm cao sẽ thắng.
·Chiến trường sẽ xuất hiện đống tuyết và người tuyết ngẫu nhiên, thu thập có thể nhận kỹ năng mạnh.
·Người Tuyết Nâu-Kỹ năng vô địch, Người Tuyết Lam-Kỹ năng nhóm, Người Tuyết Đỏ-Kỹ năng liên kích.
·Ngoài ra, phải chú ý né tránh kỹ năng mạnh có hiệu quả khống chế do Niên Thú thi triển.
]];


tbDef.nPerDayAddCount = 1; --每天可以参加多少次
tbDef.nMaxJoinCount = 3; --最多可以参加多少次
tbDef.szTimeUpdateTime = "4:00"; --每天更新的时间
tbDef.bSingleJoin = true        -- 是否单人参加模式
tbDef.nSingleJoin = 6           -- 单人参加模式人数
tbDef.REVIVE_TIME = 2           -- 复活时间

-- 所有使用一次隐藏的技能
tbDef.tbUseHideSkill = 
{
    [3591] = true;
    [3367] = true;
    [3593] = true;
    [3371] = true;
}

tbDef.nSnowBallBuffId = 3594           -- 扔雪球buffid
tbDef.nSnowBallBuffTime = 200           -- 复活重给扔雪球buffid时间
tbDef.nBuffSkillId = 3398               -- 三技能buff技能

function tbDaXueZhang:GetDXZJoinCount(pPlayer)
    if MODULE_GAMESERVER then
        local nStartTime = Activity:__GetActTimeInfo("DaXueZhang")
        if nStartTime == 0 then
            return 0
        end
        local nVersion = pPlayer.GetUserValue(tbDef.nSaveGroup, tbDef.nSaveVersion);
        --if nVersion ~= tbDef.nActivityVersion and tbDaXueZhang.bHaveDXZ then
        if nVersion ~= nStartTime and tbDaXueZhang.bHaveDXZ then
            pPlayer.SetUserValue(tbDef.nSaveGroup, tbDef.nSaveJoinTime, 0);
            pPlayer.SetUserValue(tbDef.nSaveGroup, tbDef.nSaveJoin, 0);
            pPlayer.SetUserValue(tbDef.nSaveGroup, tbDef.nSaveVersion, nStartTime);
            Log("DaXueZhang GetDXZJoinCount nSaveVersion", pPlayer.dwID, nStartTime);
        end
    end

    local nTime           = GetTime();
    local nLastTime       = pPlayer.GetUserValue(tbDef.nSaveGroup, tbDef.nSaveJoinTime);
    local nParseTodayTime = Lib:ParseTodayTime(tbDef.szTimeUpdateTime);
    local nUpdateDay      = Lib:GetLocalDay((nTime - nParseTodayTime));
    local nUpdateLastDay  = 0;
    if nLastTime == 0 then
        nUpdateLastDay = nUpdateDay - 1;
    else
        nUpdateLastDay  = Lib:GetLocalDay((nLastTime - nParseTodayTime));
    end

    local nJoin   = pPlayer.GetUserValue(tbDef.nSaveGroup, tbDef.nSaveJoin);
    local nAddDay = math.abs(nUpdateDay - nUpdateLastDay);
    if nAddDay == 0 then
        return nJoin;
    end

    if nJoin < tbDef.nMaxJoinCount then
        local nAddResiduTime = nAddDay * tbDef.nPerDayAddCount;
        nJoin = nJoin + nAddResiduTime;
        nJoin = math.min(nJoin, tbDef.nMaxJoinCount);
    end

    if MODULE_GAMESERVER then
        pPlayer.SetUserValue(tbDef.nSaveGroup, tbDef.nSaveJoinTime, nTime);
        pPlayer.SetUserValue(tbDef.nSaveGroup, tbDef.nSaveJoin, nJoin);
    end

    return nJoin;
end

function tbDaXueZhang:GetSingRankHonorByRank(nRank)
    local tbRankAward = tbDef.tbPlayerAward.tbSinlePlayerAward.tbRankAward[nRank] or {}
    for _, tbAward in pairs(tbRankAward) do
        if tbAward[1] == "DXZHonor" then
            return tbAward[2]
        end
    end
    return 0
end

function tbDaXueZhang:OnNpcTimeChange(nAddGatherNpcTime, nNSNpcTime)
    Ui:OpenWindow("QYHLeftInfo", "DaXueZhangFight", {nAddGatherNpcTime, nNSNpcTime})
end