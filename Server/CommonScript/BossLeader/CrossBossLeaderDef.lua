
Require("CommonScript/BossLeader/BossLeaderDef.lua");

BossLeader.nCrossDayTime = 1; --周一更新数据

BossLeader.tbCrossKinJiFenRank = --跨服积分
{
    [1] = 10;
    [2] = 8;
    [3] = 7;
    [4] = 5;
	[5] = 4;
};
BossLeader.nCanCrossFront = 3; --前几名可以跨服

BossLeader.tbCrossKinDmgRankValue =
{
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
            ["Boss"] =  --80级名将·真
            {
                [1] = 30000000;
                [2] = 30000000;
                [3] = 30000000;
                [4] = 30000000;
                [5] = 30000000;
            };
            ["FalseBoss"] =  --80级名将·假
            {
                [1] = 15000000;
                [2] = 15000000;
                [3] = 15000000;
                [4] = 15000000;
                [5] = 15000000;
            }
        };
        [2] =
        {
            ["Boss"] =  --110级名将·真
            {
                [1] = 35000000;
                [2] = 35000000;
                [3] = 35000000;
                [4] = 35000000;
                [5] = 35000000;
            };
            ["FalseBoss"] =  --110级名将·假
            {
                [1] = 20000000;
                [2] = 20000000;
                [3] = 20000000;
                [4] = 20000000;
                [5] = 20000000;
            }
        };
    };
}


BossLeader.tbEndJiFenCrossKinMail =
{
    szTitle = "Nhận tư cách Danh Tướng Liên SV";
    szContent = 
[[
      Chúc mừng đại hiệp, bang [FFFE0D]%s[-] có biểu hiện xuất sắc trong Danh Tướng-Thường, nhận được tư cách tham gia Danh Tướng Liên SV. Thời gian mở Danh Tướng Liên SV: [FFFE0D]%s[-], hãy tham gia đúng giờ, cùng huynh đệ bang hội tiếp tục đứng đầu để nhận phần thưởng phong phú
]];
}

BossLeader.szEndJiFenKinNotice = "Chúc mừng bổn bang đã có biểu hiện xuất sắc trong Danh Tướng-Thường, nhận được tư cách tham gia Danh Tướng Liên SV.#49"; 
BossLeader.szEndJiFenWorldNotice = "Chúc mừng bang [FFFE0D]%s[-] có biểu hiện xuất sắc trong Danh Tướng-Thường, nhận được tư cách tham gia Danh Tướng Liên SV."; 


