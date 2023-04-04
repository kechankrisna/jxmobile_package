local tbAct = Activity:GetClass("ZhongQiuJie")
tbAct.tbTimerTrigger = {
    [1] = {szType = "Day", Time = "23:58" , Trigger = "CheckSendRankRewards"},
}
tbAct.tbTrigger = { 
    Init = {},
    Start = { {"StartTimerTrigger", 1}, },
    CheckSendRankRewards = {},
    End = {},
}

tbAct.szMailText = "Ngài tại [FFFE0D] Trung thu tế nguyệt bảng [-] Trung vị liệt thứ [FFFE0D]%d[-] Tên, phụ kiện vì ban thưởng, mời kiểm tra và nhận!"
tbAct.tbRankAward = {
    {1, { {"Item", 6446, 1}, }},
    {10, { {"Item", 6447, 1}, }},
    {50, { {"Item", 6448, 1}, }},
}
tbAct.nBaseRewardScoreMin = 800 --x分以上的玩家有基础奖励
tbAct.tbBaseReward = {"Item", 6465, 1} --基础奖励

tbAct.nKinGatherExpAddScore = 1    --每次获得烤火经验时加的积分
tbAct.nKinGatherExtraDrinkAddExp = 2    --额外喝酒增加经验百分比
tbAct.nKinGatherExtraDrinkCost = 20 --额外喝酒花费元宝数
tbAct.nKinGatherExtraDrinkMaxCount = 20 --额外喝酒最多人数
tbAct.nKinGatherExtraDrinkScore = 50    --额外喝酒获得积分

tbAct.nReceiveMoonCakeScore = 60   --收到别人赠送月饼增加积分

tbAct.nAnswer10Score = 100  --完成当天10次答题获得积分奖励
tbAct.nAnswerRightScore = 10    --答对得分
tbAct.nAnswerWrongScore = 5     --答错得分
tbAct.tbAnswerTimeScore = { --答题耗时得分
    {5, 5}, --{x秒内, 答对附加得分，答错不给}
}
tbAct.nAnswerAllRightRewardRate = 4000  --全部答对获得礼盒概率（分母10000）

tbAct.nMoonCakeBoxId = 6442 --精美月饼礼盒id
tbAct.nOpenMoonCakeBoxScore = 20    --打开精美月饼礼盒获得积分
tbAct.nMaxMoonCakeBoxScoreTime = 6  --打开礼盒最多获得积分次数

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
        self:ClearRankBoard()
        self:SendStartMail()
    elseif szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_ZhognQiuJieAnswerCallBack", "OnAnswerCallBack")
        Activity:RegisterGlobalEvent(self, "Act_KinGatherAddExp", "OnKinGatherAddExp")
        Activity:RegisterGlobalEvent(self, "Act_KinGatherDrink", "OnKinGatherDrink")
        Activity:RegisterGlobalEvent(self, "Act_KinGatherDrunk", "OnKinGatherDrunk")
        Activity:RegisterPlayerEvent(self, "Act_KinGather_Open", "OnKinGatherOpen")
        Activity:RegisterPlayerEvent(self, "Act_KinGather_Close", "OnKinGatherClose")
        Activity:RegisterPlayerEvent(self, "Act_SendGift", "OnSendGift")
        Activity:RegisterPlayerEvent(self, "Act_UseMoonCakeBox", "OnUseMoonCakeBox")
        Activity:RegisterNpcDialog(self, 99, {Text = "Trung thu bài thi", Callback = self.TryQuestion, Param = {self}})
        DaTi:SetQuestionNum("ZhongQiuJie", self.MAX_QUESTION)
        self:ChangeGatherDrinkData()
    elseif szTrigger == "End" then
        self:RestoreGatherDrinkData()
    elseif szTrigger=="CheckSendRankRewards" then
        self:CheckSendRankRewards()
    end
    Log("ZhongQiuJie OnTrigger:", szTrigger)
end

function tbAct:ChangeGatherDrinkData()
    self.nOldMaxExtraExpBuff = Kin.GatherDef.MaxExtraExpBuff
    Kin.GatherDef.MaxExtraExpBuff = Kin.GatherDef.MaxExtraExpBuff+self.nKinGatherExtraDrinkAddExp*self.nKinGatherExtraDrinkMaxCount
end

function tbAct:RestoreGatherDrinkData()
    Kin.GatherDef.MaxExtraExpBuff = self.nOldMaxExtraExpBuff
end

function tbAct:OnUseMoonCakeBox(pPlayer)
    if self:GetMoonCakeBoxScoreTime(pPlayer)>=self.nMaxMoonCakeBoxScoreTime then
        pPlayer.Msg("Thật có lỗi thiếu hiệp, tinh mỹ bánh Trung thu hộp quà thu hoạch tế nguyệt giá trị đã đạt hạn mức cao nhất.", 1)
        return
    end
    self:AddScore(pPlayer, self.nOpenMoonCakeBoxScore, "Tinh mỹ bánh Trung thu hộp quà")
    self:AddMoonCakeBoxScoreTime(pPlayer, 1)
end

function tbAct:OnSendGift(pPlayer, pAcceptPlayer, nGiftType)
    if nGiftType~=Gift.GiftType.MoonCake then
        return
    end

    self:AddScore(pAcceptPlayer, self.nReceiveMoonCakeScore, "Nhận lấy tinh mây Thu Nguyệt")
end

function tbAct:SendStartMail()
    Mail:SendGlobalSystemMail({
        Title = "Trung thu tế nguyệt hoạt động",
        Text = "Xa gửi tương tư Trung thu mộng, ngàn dặm cố nhân nơi nào gặp. Tượng trưng lấy đoàn viên mỹ mãn Trung thu ngày hội đến lần nữa, hiện đẩy ra một hệ liệt tết Trung thu đặc biệt hoạt động, càng có phong phú mê người ban thưởng chờ lấy chư vị thiếu hiệp![FFFE0D][url=openwnd: Ấn vào đây hiểu rõ tường tình, NewInformationPanel, '___Activity___ZhongQiuJie'][-]",
        From = "Hệ thống",
        tbAttach = {
            {"item", self.nMoonCakeBoxId, 1, GetTime()+3*24*3600},
        },
        LevelLimit = self.nJoinLevel,
    })
    Log("ZhongQiuJie:SendStartMail")
end

function tbAct:TryQuestion()
    local bRet, szMsg = self:CheckCanAnswer(me)
    if not bRet then
        me.CenterMsg(szMsg)
        return
    end
    me.MsgBox("Bài thi quá trình không thể gián đoạn, phải chăng xác nhận bắt đầu bài thi?", {{"Xác nhận", self.ConfirmBeginAnswer, self}, {"Hủy bỏ"}})
end

function tbAct:GetRankAward(nRank, nScore)
    local tbAward = nil
    for _, tbInfo in ipairs(self.tbRankAward) do
        if nRank <= tbInfo[1] then
            tbAward = tbInfo[2]
            break
        end
    end

    if nScore>=self.nBaseRewardScoreMin then
        tbAward = tbAward or {}
        table.insert(tbAward, self.tbBaseReward)
    end
    return tbAward
end

function tbAct:CheckSendRankRewards()
    local nNow = GetTime()
    local _, nEndTime = self:GetOpenTimeInfo()
    if nEndTime<nNow or nEndTime-nNow>=3600 then
        return
    end

    self:BalanceRankBoard()
end

--结算排行榜
function tbAct:BalanceRankBoard()
    RankBoard:Rank(self.szMainKey)

    local tbRankPlayer = RankBoard:GetRankBoardWithLength(self.szMainKey, 99999, 1)
    local tbMail = {Title = "Trung thu tế nguyệt bảng ban thưởng", From = "", nLogReazon = Env.LogWay_ZhongQiuJie}
    local nSendNum = 0
    for nRank, tbRankInfo in ipairs(tbRankPlayer or {}) do
        local tbAward = self:GetRankAward(nRank, tonumber(tbRankInfo.szValue))
        if not tbAward or not next(tbAward) then
            break
        end
        local szMailText = string.format(self.szMailText, nRank)
        tbMail.Text = szMailText
        tbMail.To = tbRankInfo.dwUnitID
        tbMail.tbAttach = tbAward
        Mail:SendSystemMail(tbMail)
        nSendNum = nRank
    end
    Log("ZhongQiuJie BalanceRankBoard", nSendNum)
end

function tbAct:ClearRankBoard()
    RankBoard:ClearRank(self.szMainKey)
end

function tbAct:CommonCheck(pPlayer)
    if pPlayer.nLevel<self.nJoinLevel then
        return false, "Cấp bậc chưa đủ, không cách nào tham gia"
    end
    
    local nCurTime = Lib:GetTodaySec()
    if nCurTime >= self.CLEARING_TIME or nCurTime < self.REFRESH_TIME then
        return false, "Không tại bài thi thời gian bên trong"
    end

    return true
end

function tbAct:CheckCanAnswer(pPlayer)
    local bRet, szMsg = self:CommonCheck(pPlayer)
    if not bRet then
        return bRet, szMsg
    end

    self:RefreshData(pPlayer)
    local nLastBeginTime = pPlayer.GetUserValue(self.nSaveGroup, self.BEGIN_TIME)
    local nCompleteNum = pPlayer.GetUserValue(self.nSaveGroup, self.COMPLETE_NUM)
    if nLastBeginTime > 0 and GetTime() - nLastBeginTime > self.TIME_OUT then
        local nTotalTime = pPlayer.GetUserValue(self.nSaveGroup, self.TOTAL_TIME) + self.TIME_OUT
        nCompleteNum = nCompleteNum + 1
        pPlayer.SetUserValue(self.nSaveGroup, self.COMPLETE_NUM, nCompleteNum)
        pPlayer.SetUserValue(self.nSaveGroup, self.BEGIN_TIME, 0)
        pPlayer.SetUserValue(self.nSaveGroup, self.TOTAL_TIME, nTotalTime)

        local tbAward = {}
        table.insert(tbAward, self.tbQuestionAward_Wrong)
        pPlayer.SendAward(tbAward, nil, true, Env.LogWay_ZhongQiuJie)
        self:AddScore(pPlayer, self.nAnswerWrongScore, "Trả lời sai lầm")
    end
    if nCompleteNum >= self.MAX_QUESTION then
        return false, "Hôm nay bài thi đã hoàn thành"
    end

    return true
end

function tbAct:ConfirmBeginAnswer()
    local bRet, szMsg = self:CheckCanAnswer(me)
    if not bRet then
        me.CenterMsg(szMsg)
        return
    end
    local nBeginTime = me.GetUserValue(self.nSaveGroup, self.BEGIN_TIME)
    if nBeginTime == 0 then
        me.SetUserValue(self.nSaveGroup, self.BEGIN_TIME, GetTime())
    end
    local nEndTime = (nBeginTime == 0 and GetTime() or nBeginTime) + self.TIME_OUT
    DaTi:TryBeginQuestion(me, self.szMainKey, me.GetUserValue(self.nSaveGroup, self.COMPLETE_NUM) + 1, nEndTime)
end

function tbAct:RefreshData(pPlayer)
    local nLastSaveTime = pPlayer.GetUserValue(self.nSaveGroup, self.DATA_TIME)
    if Lib:IsDiffDay(self.REFRESH_TIME, nLastSaveTime) then
        pPlayer.SetUserValue(self.nSaveGroup, self.DATA_TIME, GetTime())
        pPlayer.SetUserValue(self.nSaveGroup, self.BEGIN_TIME, 0)
        pPlayer.SetUserValue(self.nSaveGroup, self.COMPLETE_NUM, 0)
        pPlayer.SetUserValue(self.nSaveGroup, self.TOTAL_TIME, 0)
        pPlayer.SetUserValue(self.nSaveGroup, self.RIGHT_NUM, 0)
        DaTi:Refresh(pPlayer.dwID, self.szMainKey)
        return true
    end
end

function tbAct:_Drink(pPlayer)
    if pPlayer.dwKinId == 0 then
        return false, "Không bang phái";
    end

    if self:HasDrunk(pPlayer) then
        return false, "Ngươi đã xin mọi người từng uống rượu!"
    end

    local memberData = Kin:GetMemberData(pPlayer.dwID);
    if not memberData then
        return false, "Ngươi không phải này bang phái thành viên"
    end
    if memberData:IsRetire() then
        return false, "Thoái ẩn thành viên không tham gia nên hoạt động";
    end

    local kinData = Kin:GetKinById(pPlayer.dwKinId);
    local nKinMapId = kinData:GetMapId();

    if pPlayer.nMapId ~= nKinMapId then
        return false, "Mời đến bang phái quyền sở hữu tham dự sưởi ấm hoạt động";
    end

    local tbGatherData = kinData:GetGatherData();
    if not next(tbGatherData) then
        return false, "Sưởi ấm hoạt động đã kết thúc";
    end

    local nPrice = self.nKinGatherExtraDrinkCost
    local nGold = pPlayer.GetMoney("Gold");
    if nGold < nPrice then
        return false, "Ngươi không có tiền.. Nhanh đến trữ giá trị giới mặt trữ giá trị đi";
    end

    local pFireNpc = KNpc.GetById(tbGatherData.nFireNpcId);
    if not pFireNpc then
        return false, "Đống lửa đi nơi nào...";
    end

    local nCurFireAddExp = pFireNpc.tbTmp.nExtraKinAddRate or 0;
    local nMaxExtraExpBuff = Kin.GatherDef.MaxExtraExpBuff
    if nCurFireAddExp + pFireNpc.tbTmp.nQuotiety >= nMaxExtraExpBuff then
        Kin.Gather:UpdateGatherData(pPlayer.dwKinId, { [Kin.GatherDef.Quotiety] = nMaxExtraExpBuff })
        return false, "Đã đạt tới lớn nhất uống rượu hạn mức cao nhất";
    end

    -- CostGold谨慎调用, 调用前请搜索 _LuaPlayer.CostGold 查看使用说明, 它处调用时请保留本注释
    pPlayer.CostGold(nPrice, Env.LogWay_ZhongQiuJie, nil, function (nPlayerId, bSuccess, szBillNo, kinData)
        if not bSuccess then
            return false;
        end

        local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
        if not pPlayer then
            return false, "Uống rượu thanh toán quá trình bên trong ngài hạ tuyến";
        end

        local tbGatherData = kinData:GetGatherData();
        if not next(tbGatherData) then
            return false, "Bang phái tụ tập hoạt động kết thúc";
        end

        local pFireNpc = KNpc.GetById(tbGatherData.nFireNpcId);
        if not pFireNpc then
            return false, "Đống lửa không thấy";
        end

        local nCurFireAddExp = pFireNpc.tbTmp.nExtraKinAddRate or 0;
        if nCurFireAddExp + pFireNpc.tbTmp.nQuotiety >= nMaxExtraExpBuff then
            Kin.Gather:UpdateGatherData(pPlayer.dwKinId, { [Kin.GatherDef.Quotiety] = nMaxExtraExpBuff })
            return false, "Đã đạt tới lớn nhất uống rượu hạn mức cao nhất";
        end

        pFireNpc.tbTmp.nQuotiety = pFireNpc.tbTmp.nQuotiety + self.nKinGatherExtraDrinkAddExp;
        tbGatherData.nQuotiety   = pFireNpc.tbTmp.nQuotiety
        Kin.Gather:UpdateGatherData(pPlayer.dwKinId, { [Kin.GatherDef.Quotiety] = math.min(pFireNpc.tbTmp.nQuotiety + nCurFireAddExp, nMaxExtraExpBuff) })

        self:SetDrunk(pPlayer)

        local szMsg = string.format("「%s」Mời nhiều người uống hoa quế rượu, cái lồng Hỏa Kinh nghiệm tăng thêm tăng lên %d%%!", pPlayer.szName, self.nKinGatherExtraDrinkAddExp);
        ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, kinData.nKinId);
        self:AddScore(pPlayer, self.nKinGatherExtraDrinkScore, "Mời khách uống hoa quế rượu")
        pPlayer.TLog("KinMemberFlow", pPlayer.dwKinId, Env.LogWay_KinGatherDrink, tbGatherData.nQuotiety, 0)
        Log("ZhongQiuJie:_Drink", pPlayer.dwID, pPlayer.dwKinId, nPrice)
        return true;
    end, kinData);
    return true;
end

function tbAct:OnKinGatherOpen(pPlayer)
    self.tbDrinkCache = {}
end

function tbAct:OnKinGatherClose(pPlayer)
    self.tbDrinkCache = {}
end

function tbAct:SetDrunk(pPlayer)
    local nKinId = pPlayer.dwKinId or 0
    self.tbDrinkCache = self.tbDrinkCache or {}
    self.tbDrinkCache[nKinId] = self.tbDrinkCache[nKinId] or {}
    self.tbDrinkCache[nKinId][pPlayer.dwID] = true
end

function tbAct:HasDrunk(pPlayer)
    local nKinId = pPlayer.dwKinId or 0
    return self.tbDrinkCache and self.tbDrinkCache[nKinId] and self.tbDrinkCache[nKinId][pPlayer.dwID]
end

function tbAct:OnKinGatherDrunk(pPlayer)
    if self:HasDrunk(pPlayer) then
        pPlayer.CenterMsg("Ngươi đã xin mọi người từng uống rượu!")
        return
    end
    self:ShowDrinkMsgbox(pPlayer)
end

function tbAct:OnKinGatherDrink(pPlayer)
    if pPlayer.nLevel<self.nJoinLevel or self:HasDrunk(pPlayer) then
        return
    end
    self:ShowDrinkMsgbox(pPlayer)
end

function tbAct:ShowDrinkMsgbox(pPlayer)
    local function fConfirm()
        local bOk, szErr = self:_Drink(pPlayer)
        if not bOk and szErr then
            pPlayer.CenterMsg(szErr)
        end
    end

    local szMsg = string.format("Phải chăng tốn hao [FFFE0D]%d Nguyên bảo [-] Mời bang phái toàn thể thành viên tại tết Trung thu uống một bình hoa quế rượu?\n( Ngoài định mức gia tăng nướng Hỏa Kinh nghiệm %d%%%%, ngài đem thu hoạch được %d Tế nguyệt giá trị )", 
        self.nKinGatherExtraDrinkCost, self.nKinGatherExtraDrinkAddExp, self.nKinGatherExtraDrinkScore)
    pPlayer.MsgBox(szMsg, {{"Đồng ý", fConfirm}, {"Cự tuyệt"}})
end

function tbAct:OnKinGatherAddExp(pPlayer)
    self:AddScore(pPlayer, self.nKinGatherExpAddScore, "Tham dự bang phái sưởi ấm")
end

function tbAct:OnAnswerCallBack(pPlayer, nQuestionId, bRight, bTimeOut)
    local bRet, szMsg = self:CommonCheck(pPlayer)
    if not bRet then
        pPlayer.CenterMsg(szMsg)
        pPlayer.CallClientScript("DaTi:CloseUi")
        return
    end

    if self:RefreshData(pPlayer) then
        pPlayer.CenterMsg("Cái này vòng bài thi đã kết thúc, mời lại bắt đầu lại từ đầu")
        pPlayer.CallClientScript("DaTi:CloseUi")
        return
    end

    local nBeginTime = pPlayer.GetUserValue(self.nSaveGroup, self.BEGIN_TIME)
    if nBeginTime == 0 then
        Log("ZhongQiuJie OnAnswerCallBack Err", pPlayer.dwID)
        return
    end
    local nCompleteNum = pPlayer.GetUserValue(self.nSaveGroup, self.COMPLETE_NUM)
    nCompleteNum = nCompleteNum + 1
    if nCompleteNum > self.MAX_QUESTION then
        pPlayer.CenterMsg("Hôm nay bài thi đã kết thúc")
        pPlayer.CallClientScript("DaTi:CloseUi")
        return
    end

    local nTime = math.min(GetTime() - nBeginTime, self.TIME_OUT)
    pPlayer.SetUserValue(self.nSaveGroup, self.BEGIN_TIME, 0)
    pPlayer.SetUserValue(self.nSaveGroup, self.TOTAL_TIME, pPlayer.GetUserValue(self.nSaveGroup, self.TOTAL_TIME) + nTime)
    pPlayer.SetUserValue(self.nSaveGroup, self.COMPLETE_NUM, nCompleteNum)
    if bTimeOut then
        pPlayer.CenterMsg("Trả lời đã quá thời gian")
    else
        local szReason = "Trả lời sai lầm"
        local nTotalScore = bRight and self.nAnswerRightScore or self.nAnswerWrongScore
        if bRight then
            pPlayer.SetUserValue(self.nSaveGroup, self.RIGHT_NUM, pPlayer.GetUserValue(self.nSaveGroup, self.RIGHT_NUM) + 1)

            szReason = "Trả lời chính xác"
            for _, tb in ipairs(self.tbAnswerTimeScore) do
                local nSec, nScore = unpack(tb)
                if nTime<=nSec then
                    nTotalScore = nTotalScore+nScore
                    szReason = "Nhanh chóng trả lời chính xác"
                    break
                end
            end
        end
        self:AddScore(pPlayer, nTotalScore, szReason)
    end
    local tbAward = {}
    table.insert(tbAward, bRight and self.tbQuestionAward_Right or self.tbQuestionAward_Wrong)
    pPlayer.SendAward(tbAward, nil, true, Env.LogWay_ZhongQiuJie)
    if nCompleteNum >= self.MAX_QUESTION then
        pPlayer.CenterMsg("Hôm nay bài thi đã kết thúc")

        if self:GetRightNum(pPlayer)>=self.MAX_QUESTION then
            if MathRandom(10000)<=self.nAnswerAllRightRewardRate then
                pPlayer.SendAward({{"item", self.nMoonCakeBoxId, 1}}, nil, true, Env.LogWay_ZhongQiuJie)
            end
        end
        
        self:AddScore(pPlayer, self.nAnswer10Score, "Hoàn thành mỗi ngày đố đèn")
        pPlayer.CallClientScript("DaTi:CloseUi")
        return
    end

    self:ConfirmBeginAnswer()
end