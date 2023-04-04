SendBless.nMinLevel = 20; --最小参与等级
SendBless.nStackMax  = 5; -- 每次的叠加上限为5
SendBless.nTimeStep = 1200 -- 20分钟恢复一次次数
SendBless.nMAX_SEND_TIMES = 20; --每天最多送20次
SendBless.TOP_NUM = 10 ;--取前10 玩家
SendBless.COST_GOLD = 88; --元宝祝福
SendBless.nItemDelayDelteTime = 0;--道具是在每轮活动结束后44小时再消失

SendBless.szDefaultWord = "Năm Mới Vui Vẻ"
SendBless.szWordMaxLen = 30;-- 字符限制

SendBless.tbActSetting = {
    [1] = { --普天同庆祝福函
        szActName = "SendBlessAct"; --活动名
        szNotifyUi= "Lantern";
        szOpenUi = "BlessPanel";
        szNormalSprite = false;
        szGoldSprite = false;
        bRank = true;
        bGoldSkipTimes = false;
        nCardItemId = 3066;
        tbGetBlessAward = false;
        nMaxGetBlessAwardTimes = false;
        szItemUseName = "Chúc Phúc Ngày Lễ";
        szMailTitle = "Chúc Phúc Ngày Lễ"; 
        szMailText = "Ngày lễ hãy tặng Chúc Phúc cho võ lâm đồng đạo.【[FFFE0D]Thư Chúc Phúc Ngày Lễ[-]】có thể giúp ngươi thu thập và tặng chúc phúc, hãy nhận. Nội dung chi tiết xem [url=openwnd:Tin-mới, NewInformationPanel, 'SendBlessAct'].";
        szGetBlessMsgNormal = "Nhận Chúc Phúc Ngày Lễ của hảo hữu「%s」";
        szGetBlessMsgGold = "Nhận Chúc Phúc Ngày Lễ đặc biệt của hảo hữu「%s」";
        szSendBlessMsg = "Đại hiệp tặng hảo hữu「%s」Chúc Phúc Ngày Lễ!";
        szColorSendMsg = false;
        szNewsTitle = "Ngày Lễ-Chúc Phúc Ngày Lễ";
        szNewsText = [[
        [FFFE0D]Hoạt động Chúc Phúc ngày lễ【Chúc Phúc Ngày Lễ】bắt đầu[-]

            Dùng đạo cụ Chúc Phúc tặng Chúc Phúc cho hảo hữu, được nhận thưởng theo điểm Chúc Phúc nhận được, tham gia xếp hạng nhận danh hiệu vĩnh viễn. Hoạt động mở [FFFE0D]3 lượt[-], bắt đầu vào 0 giờ các ngày [FFFE0D]1, 4, 7[-] tháng 10, kết thúc vào [FFFE0D]4:00[-] ngày hôm sau.
        [FFFE0D]Thời gian hoạt động lượt này: [-]%s
        [FFFE0D]Cấp tham gia: [-]Lv20

        [FFFE0D]1, Thư Chúc Phúc[-]
            Mở hoạt động, người chơi đủ điều kiện nhận được 1 thư hệ thống, nhận thư xong được nhận [11adf6][url=openwnd:Thư-Chúc-Phúc-Ngày-Lễ, ItemTips, "Item", nil, 3066][-].
            Vào giao diện Chúc Phúc tặng Chúc Phúc cho hảo hữu, đối phương được nhận [FFFE0D]Điểm chúc phúc[-]. Căn cứ vào các điều kiện (Quân hàm của bên Chúc Phúc, độ thân mật hai người, quan hệ Bang Hội và Sư Đồ) được nhận [FFFE0D]Điểm chúc phúc cộng thêm[-], khi gửi [FFFE0D]Chúc Phúc Nguyên Bảo[-] cũng được cộng thêm Điểm chúc phúc.
            Thư Chúc Phúc cộng từ Top[FFFE0D]10[-] hảo hữu nhận chúc phúc, sẽ là bản thân được nhận [FFFE0D]tổng điểm chúc phúc[-].
            Mỗi lượt bắt đầu sẽ xóa hết điểm chúc phúc và tái lập trạng thái Chúc Phúc.
        [FFFE0D]2, Số lần Chúc Phúc[-]
            Tặng Chúc Phúc cho hảo hữu cần tiêu hao số lần Chúc Phúc, mỗi [FFFE0D]20[-] phút được nhận [FFFE0D]1[-] lần Chúc Phúc, tối đa là [FFFE0D]5[-].
            [FFFE0D]Mỗi lượt[-] mỗi hiệp khách tối đa  Chúc Phúc [FFFE0D]20[-] hảo hữu, chỉ được chúc phúc 1 lần với 1 người.
        [FFFE0D]3, Thưởng hoạt động[-]
            Căn cứ tổng điểm Chúc Phúc của Thư Chúc Phúc càng lớn thì được nhận [FFFE0D]thưởng càng nhiều[-], ví dụ:
            -Đạt 5: Được nhận 2 [11adf6][url=openwnd:Rương-Hoàng-Kim, ItemTips, "Item", nil, 786][-]
            -Đạt 10: Được nhận 1000 Cống hiến
            -Đạt 20: Được nhận 2 [11adf6][url=openwnd:Thủy-Tinh-Lam, ItemTips, "Item", nil, 223][-]
            -Đạt 30: Được nhận 200 Nguyên Bảo
            -Đạt 40: Được nhận 3000 Cống hiến
            -Đạt 50:  Được nhận [11adf6][url=openwnd:Rương-Đá-Hồn Lv3, ItemTips, "Item", nil, 2164][-]
            -Đạt 60:  Được nhận [11adf6][url=openwnd:Tàng-Bảo-Đồ-Cao, ItemTips, "Item", nil, 788][-]
            -Đạt 70:  Được nhận [11adf6][url=openwnd:Thủy-Tinh-Tím, ItemTips, "Item", nil, 224][-]
            -Đạt 80:  Được nhận 500 Nguyên Bảo
            -Đạt 90:  Được nhận 5000 cống hiến
            -Đạt 100: Được nhận [11adf6][url=openwnd:Rương-Đá-Hồn-Lv4, ItemTips, "Item", nil, 2165][-]

        [FFFE0D]Mỗi lượt[-] sẽ tiến hành xếp hạng người chơi theo tổng điểm Chúc Phúc trong【Bảng xếp hạng】, kết thúc được nhận [FFFE0D]Danh hiệu vĩnh viễn[-]: 
            -Hạng 1:     Danh hiệu Cam【Hảo Hữu Vô Số】
            -Hạng 2-10: Danh hiệu Hồng【Khách Quý Đông Đúc】
            -Hạng 11-30: Danh hiệu Tím【Đông Như Trẩy Hội】
        ]];
    }; 
    [2] = { ----新年送祝福函
        szActName = "SendBlessActWord"; --活动名
        szNotifyUi= "NewYear";
        szNormalSprite = "NewYear01";
        szGoldSprite = "NewYear02";
        szOpenUi = "BlessPanelWord";
        bRank = false;
        bGoldSkipTimes = true; --消耗元宝不扣次数
        nCardItemId = 3687; --活动道具
        tbGetBlessAward = {{"item", 3712, 1}};--收到祝福方获得的奖励箱子
        nMaxGetBlessAwardTimes = 10;--每轮最多收到的祝福箱子数目
        szItemUseName = "Chúc Phúc Năm Mới";
        szMailTitle = "Chúc Phúc Năm Mới";
        szMailText = "Đại hiệp thân mến, đường giang hồ thênh thang, ắt hẳn đại hiệp đã tìm được không ít đồng đạo võ lâm? Nhân dịp năm mới, hãy cùng gửi đến họ lời chúc phúc chân thành, cùng đón mừng xuân mới. [FFFE0D]Thư Chúc Phúc Năm Mới[-] này có thể giúp thu thập và tặng chúc phúc, xin nhận. Nội dung chi tiết xem tại [url=openwnd:Tin-Mới, NewInformationPanel, 'SendBlessActWord'].";
        szGetBlessMsgNormal = "Chúc mừng nhận được chúc phúc năm mới từ「%s」!";
        szGetBlessMsgGold = "Bất ngờ nhận được chúc phúc năm mới đặc biệt từ「%s」";
        szSendBlessMsg = "Đã tặng chúc phúc năm mới cho hảo hữu「%s」!";
        szColorSendMsg = "Đại hiệp「%s」đã tặng chúc phúc năm mới cho bạn mình là「%s」: %s";
        szNewsTitle = "Chúc Phúc Năm Mới";
        szNewsText = [[
        [FFFE0D]Lượt hoạt động chúc phúc mới nhất đã bắt đầu![-]

        Dùng đạo cụ chúc phúc có thể tặng chúc phúc cho hảo hữu nhận thưởng. Hoạt động chia làm [FFFE0D]3 lượt[-], lần lượt bắt đầu lúc 0 giờ [FFFE0D]28/1, 1/2 và 5/2[-], [FFFE0D]4 giờ hôm sau[-] kết thúc.
        [FFFE0D]Thời gian hoạt động lượt này: [-]%s
        [FFFE0D]Cấp tham gia: [-]Lv20

            Sau khi mở hoạt động, người chơi đạt đủ điều kiện sẽ nhận được thư hệ thống, mở đính kèm có thể nhận [11adf6][url=openwnd:Thư-Chúc-Phúc-Năm-Mới, ItemTips, "Item", nil, 3687][-].
            Sau khi dùng Thư Chúc Phúc, có thể tặng chúc phúc cho hảo hữu từ giao diện chúc phúc, đồng thời đối phương sẽ nhận được [FFFE0D]Rương Chúc Phúc[-]. Mỗi lượt hoạt động, mỗi người được nhận tối đa [FFFE0D]10[-] Rương Chúc Phúc.
            Mỗi lượt hoạt động, mỗi người được tặng chúc phúc cho tối đa [FFFE0D]20[-] hảo hữu, mỗi người được chúc phúc tối đa 1 lần. Tốn Nguyên Bảo sẽ không tốn số lần chúc phúc.
            Có thể nhận thưởng: [11adf6][url=openwnd:Tu Luyện Đơn, ItemTips, "Item", nil, 2301][-], [11adf6][url=openwnd:Truyền Công Đơn, ItemTips, "Item", nil, 2759][-], [11adf6][url=openwnd:Bình-Nhuộm-Ngoại-Trang, ItemTips, "Item", nil, 2569][-], [11adf6][url=openwnd:Thủy-Tinh-Tím, ItemTips, "Item", nil, 224][-].
        ]];
    };
}

SendBless.tbHonorScore = {  --头衔对应的加分
    [6]     = 1;
    [7]     = 2;
    [8]     = 3;
    [9]     = 4;
    [10]    = 5;
}; 

SendBless.tbImityScore = { --亲密度等级 对应分
    {5,  1 },
    {10, 2 },
    {15, 3 },
    {20, 4 },
    {30, 5 },
}

SendBless.tbRankAward = {  --排行奖励
    {nRankEnd = 1,  tbAward = {"AddTimeTitle" , 408, -1} },
    {nRankEnd = 10, tbAward = {"AddTimeTitle" , 407, -1} },
    {nRankEnd = 30, tbAward = {"AddTimeTitle" , 406, -1} },
}

SendBless.tbTakeAwardSet = {  --手动领取奖励
    {nScore = 5,  tbAward = {"item", 786, 2 } },
    {nScore = 10, tbAward = {"Contrib", 1000} },
    {nScore = 20, tbAward = {"item", 223, 2} },
    {nScore = 30, tbAward = {"Gold", 200 } },
    {nScore = 40, tbAward = {"Contrib", 3000 } },
    {nScore = 50, tbAward = {"item", 2164, 1 } },
    {nScore = 60, tbAward = {"item", 788, 1 } },
    {nScore = 70, tbAward = {"item", 224, 1 } },
    {nScore = 80, tbAward = {"Gold", 500 } },
    {nScore = 90, tbAward = {"Contrib", 5000 } },
    {nScore = 100, tbAward = {"item", 2165, 1 } },
};


SendBless.SAVE_GROUP    = 116
SendBless.KEY_RESET_DAY = 1
SendBless.KEY_SEND_TIME = 2
SendBless.KEY_CUR_SEND_TIMES = 3
SendBless.KEY_TakeAwardLevel = 4; --现在领取的奖励档次


--如果服务端判断剩余未6次，则重置对应的时间， 每次重置后使用次数置0，
function SendBless:GetNowMaxSendTimes(pPlayer)
    local nLastSendTime = pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_SEND_TIME) --参加重置为6次的时间
    if nLastSendTime == 0 then
        return self.nStackMax
    end

    local nTimeDiff = GetTime() - nLastSendTime
    local nNowSaveCur = pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_CUR_SEND_TIMES)
    return math.min(nNowSaveCur + math.floor(nTimeDiff / self.nTimeStep), self.nStackMax), nTimeDiff
end

function SendBless:GetScoreInfo(tbData)
    if not tbData then
        return 0;
    end
    local tbSort = {}
    for dwRoleId, nVal in pairs(tbData) do
        table.insert(tbSort, nVal)
    end
    table.sort( tbSort, function (a, b)
        return a > b;
    end )
    local nTotalVal = 0
    for i=1, self.TOP_NUM  do
        if tbSort[i] then
            nTotalVal = nTotalVal + tbSort[i]
        else
            break;
        end
    end
    return nTotalVal
end

function SendBless:GetSendTimes(tbSendData, bGoldSkipTimes)
    local nCount = 0
    for k,v in pairs(tbSendData) do
        if not (bGoldSkipTimes and v == 2) then
            nCount = nCount + 1
        end
    end
    return nCount
end

function SendBless:CheckSendCondition(pPlayer, dwRoleId2, tbData, bUseGold)
    if pPlayer.nLevel < self.nMinLevel then
        pPlayer.CenterMsg("Cấp chưa đạt")
        return
    end

    if tbData[dwRoleId2] then
        pPlayer.CenterMsg("Đã tặng")
        return
    end
    
    local tbActSetting = self:GetActSetting()
    if not tbActSetting.bGoldSkipTimes or not bUseGold then
        if not pPlayer.nSendBlessTimes then
            pPlayer.nSendBlessTimes = self:GetSendTimes(tbData, tbActSetting.bGoldSkipTimes)
        end
        if pPlayer.nSendBlessTimes >= self.nMAX_SEND_TIMES then
            pPlayer.CenterMsg(string.format("Mỗi ngày tối đa tặng %d lần", self.nMAX_SEND_TIMES))
            return
        end
    end
    
    if tbActSetting.bRank then
        local nCurHasCount = SendBless:GetNowMaxSendTimes(pPlayer)
        if nCurHasCount <= 0 then
            pPlayer.CenterMsg("Số lần chúc phúc được dùng không đủ")
            return
        end
    end

    local bInProcess = Activity:__IsActInProcessByType(tbActSetting.szActName)
    if not bInProcess then
        pPlayer.CenterMsg("Hoạt động vòng này đã kết thúc")
        return
    end

    return true, nCurHasCount
end


-- dwRoleId1 送给 dwRoleId2 的
function SendBless:GetSendBlessVal(dwRoleId1, dwRoleId2, pRole1, pRole2)
    local nScore = 1;
    local tbActSetting = self:GetActSetting()
    if not tbActSetting.bRank then
        return nScore
    end
    local nFriendLevel = FriendShip:GetFriendImityLevel(dwRoleId1, dwRoleId2)
    local nAddScore = 0
    for i,v in ipairs(self.tbImityScore) do
        if nFriendLevel >= v[1] then
            nAddScore = v[2]
        else
            break;
        end
    end
    nScore = nScore + nAddScore;

    local nSenderHonorLevel = pRole1.nHonorLevel
    nScore = nScore + (self.tbHonorScore[nSenderHonorLevel] or 0)
    if pRole1.dwKinId ~= 0 and pRole1.dwKinId == pRole2.dwKinId then
        nScore = nScore + 1
    end
    if TeacherStudent:_IsConnected(pRole1, pRole2) then
       nScore = nScore + 1 
    end

    return nScore;
end


function SendBless:GetCurAwardLevel(pPlayer, tbGet)
    local nHasTakedLevel = pPlayer.GetUserValue(self.SAVE_GROUP, self.KEY_TakeAwardLevel)
    local nNewLevel = nHasTakedLevel + 1;
    local tbAwardInfo = self.tbTakeAwardSet[nNewLevel]
    if not tbAwardInfo then
        return
    end
    local nTotalVal = SendBless:GetScoreInfo(tbGet)
    if nTotalVal < tbAwardInfo.nScore then
        return
    end

    return nNewLevel, tbAwardInfo.tbAward
end

function SendBless:GetActSetting()
    if self.TryGetCurType then
        self:TryGetCurType();
    end
        
    return SendBless.tbActSetting[self.nType]
end

