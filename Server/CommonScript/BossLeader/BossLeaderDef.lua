

BossLeader.nMJHonorID = 1394; --名将令
BossLeader.nItemAwardValueParam = 0.5; --道具奖励系数

BossLeader.nShowMaxRank = 5;
BossLeader.nBaoDiAwardValue = 40000;
BossLeader.nFirstLastDmgMJHPPercent = 10; --首摸和最后一击额外血量百分比
BossLeader.nHPPercentParam = 1 / 1.2; -- 血量的百分比参数
BossLeader.nMinHPPercent = 1; --最少血量百分比
BossLeader.tbComboSkillCount = {[20] = 1, [30] = 1, [40] = 1, [50] = 1, [60] = 1, [70] = 1, [80] = 1, [90] = 1, [100] = 1}; --连斩数

BossLeader.tbTimePlayerValue = --一轮一个参加玩家的价值量
{
    ["OpenLevel39"] = 200000;
    ["OpenDay89"] = 300000;
};

BossLeader.tbKinDmgRankValue =
{
    ["OpenLevel39"] =
    {
        [-1] = 
        {
            ["Boss"] = 
            {
                [1] = 4000000;
                [2] = 4000000;
                [3] = 4000000;
                [4] = 4000000;
                [5] = 4000000;
            };
            ["FalseBoss"] =
            {
                [1] = 2000000;
                [2] = 2000000;
                [3] = 2000000;
                [4] = 2000000;
                [5] = 2000000;
            }
        };
        [1] =
        {
            ["Boss"] = 
            {
                [1] = 6000000;
                [2] = 6000000;
                [3] = 6000000;
                [4] = 6000000;
                [5] = 6000000;
            };
            ["FalseBoss"] =
            {
                [1] = 3000000;
                [2] = 3000000;
                [3] = 3000000;
                [4] = 3000000;
                [5] = 3000000;
            }
        };
    };

    ["OpenDay89"] =
    {
        [-1] = 
        {
            ["Boss"] = 
            {
                [1] = 4000000 * 1.5;
                [2] = 4000000 * 1.5;
                [3] = 4000000 * 1.5;
                [4] = 4000000 * 1.5;
                [5] = 4000000 * 1.5;
            };
            ["FalseBoss"] =
            {
                [1] = 2000000 * 1.5;
                [2] = 2000000 * 1.5;
                [3] = 2000000 * 1.5;
                [4] = 2000000 * 1.5;
                [5] = 2000000 * 1.5;
            }
        };
        [1] =
        {
            ["Boss"] = 
            {
                [1] = 6000000 * 1.5;
                [2] = 6000000 * 1.5;
                [3] = 6000000 * 1.5;
                [4] = 6000000 * 1.5;
                [5] = 6000000 * 1.5;
            };
            ["FalseBoss"] =
            {
                [1] = 3000000 * 1.5;
                [2] = 3000000 * 1.5;
                [3] = 3000000 * 1.5;
                [4] = 3000000 * 1.5;
                [5] = 3000000 * 1.5;
            }
        };
    };

    ["OpenLevel119"] =
    {
        [-1] = 
        {
            ["Boss"] = 
            {
                [1] = 4000000 * 1.5;
                [2] = 4000000 * 1.5;
                [3] = 4000000 * 1.5;
                [4] = 4000000 * 1.5;
                [5] = 4000000 * 1.5;
            };
            ["FalseBoss"] =
            {
                [1] = 2000000 * 1.5;
                [2] = 2000000 * 1.5;
                [3] = 2000000 * 1.5;
                [4] = 2000000 * 1.5;
                [5] = 2000000 * 1.5;
            }
        };
        [1] =
        {
            ["Boss"] = 
            {
                [1] = 6000000 * 1.5;
                [2] = 6000000 * 1.5;
                [3] = 6000000 * 1.5;
                [4] = 6000000 * 1.5;
                [5] = 6000000 * 1.5;
            };
            ["FalseBoss"] =
            {
                [1] = 3000000 * 1.5;
                [2] = 3000000 * 1.5;
                [3] = 3000000 * 1.5;
                [4] = 3000000 * 1.5;
                [5] = 3000000 * 1.5;
            }
        };
        [2] =
        {
            ["Boss"] = 
            {
                [1] = 6000000 * 1.5;
                [2] = 6000000 * 1.5;
                [3] = 6000000 * 1.5;
                [4] = 6000000 * 1.5;
                [5] = 6000000 * 1.5;
            };
            ["FalseBoss"] =
            {
                [1] = 3000000 * 1.5;
                [2] = 3000000 * 1.5;
                [3] = 3000000 * 1.5;
                [4] = 3000000 * 1.5;
                [5] = 3000000 * 1.5;
            }
        };
    };
}

BossLeader.tbBaoDiKinAward =
{
    ["Boss"] = true;
};


BossLeader.tbSinglePlayerRank = --玩家单独排行奖励
{
    ["Leader"] = true;
}

BossLeader.tbKinAwardDesc =
{
    ["Boss"]   = "Danh Tướng";
    ["Leader"] = "Thủ Lĩnh";
}


BossLeader.tbSendMailTxt = 
{
    ["Boss"] = "Thưởng Danh Tướng";
    ["Leader"] = "Thưởng Thủ Lĩnh Dã Ngoại";
}


BossLeader.tbJoinPrestige = --参加家族威望
{
    ["Boss"] = 0;
    ["Leader"] = 0;
}

BossLeader.tbDmgRankPrestige  = --伤害排行威望
{
    ["Boss"] = 
    {
        [1] = 50;
        [2] = 35;
        [3] = 25;
        [4] = 15;
        [5] = 10;

    };

    ["Leader"] = 
    {
        [1] = 0;
        [2] = 0;
        [3] = 0;
    };
}

BossLeader.tbTouchImitityTeam = --摸到增加亲密度
{
    ["Boss"]   = 30;
    ["Leader"] = 20;
};

BossLeader.tbKillImitityTeam = --杀死增加亲密度
{
    ["Boss"]   = 30;
    ["Leader"] = 30;
}

BossLeader.tbStartWorldNotice = 
{
    ["Boss"]   = "Danh Tướng xuất hiện, các đại hiệp mau khiêu chiến!";
    ["Leader"] = "Thủ Lĩnh Dã Ngoại xuất hiện, các đại hiệp hãy tới khiêu chiến!";
}

BossLeader.tbEndWorldNotice = 
{
    ["Boss"]   = "Danh Tướng đã kết thúc";
    ["Leader"] = "Thủ Lĩnh Dã Ngoại đã kết thúc";
}

BossLeader.tbMapAllKillNotice =
{
    ["Leader"] = "Thủ Lĩnh của %s bị diệt toàn bộ!";
}

BossLeader.tbNpcKillNotice =
{
    ["Boss"] = "%s (Chân Thân) bị đội %s tiêu diệt";
}

BossLeader.tbWorldPreNotic = 
{
    ["Boss"] = "Danh Tướng sắp xuất hiện, các đại hiệp mau khiêu chiến!";
}

BossLeader.tbMapBackNotic = 
{
    ["Boss"] = "Đã vào bản đồ ẩn danh tướng, cưỡng chế vào dạng PK bang hội";
}

BossLeader.tbJoinAchievement = 
{
    ["Boss"]   = {szKey = "FieldBoss_1", nValue = 1},
    ["Leader"] = {szKey = "FieldLeader_1", nValue = 1},
}

BossLeader.tbFirstAttackAchievement = 
{
    ["Boss"] = {szKey = "FieldBoss_First", nValue = 1},
}

BossLeader.tbAttackTenAchievement = 
{
    ["Boss"] = {szKey = "Mystic_10InHouse", nValue = 1},
}

BossLeader.nAchievementRank = 1;
BossLeader.tbKillNpcAchievementRank =
{
    ["Leader"] = {szKey = "FieldLeader_2", nValue = 1},
}

BossLeader.nAchievementKinRank = 1; 
BossLeader.tbKillKinAchievement = 
{
    ["Boss"]   = {szKey = "FieldBoss_2", nValue = 1},
}

--每日目标
BossLeader.tbEveryDayTarget = 
{
    ["Boss"] = "FieldBoss";
}
