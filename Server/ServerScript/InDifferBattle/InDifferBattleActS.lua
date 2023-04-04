if MODULE_ZONESERVER then
    return
end

InDifferBattle.tbAct = InDifferBattle.tbAct or {}
local tbAct = InDifferBattle.tbAct;
local tbSetting = InDifferBattle.tbBattleTypeSetting.ActJueDi
local tbDefine = InDifferBattle.tbDefine;
 

function tbAct:OnActInit(  )
	RankBoard:ClearRank(tbSetting.szRankboardKey)	
end

function tbAct:OnActStart( tbActInst )
	self.tbActInst = tbActInst
end


function tbAct:EndAct( )
    self.tbActInst = nil;
	local pRank = KRank.GetRankBoard(tbSetting.szRankboardKey)
    pRank.Rank()
    
    
    local szTitle = tbSetting.szName .. "Xếp hạng ban thưởng"
    for nPos=1,tbSetting.nRankAwardNum do
        local tbInfo = pRank.GetRankInfoByPos(nPos - 1);
        if not tbInfo then
            break;
        else
            local nLowValue = tbInfo.nLowValue
            local nVal1 = math.floor(nLowValue  / 1000 / 1000) 
            local nVal2 = math.floor(nLowValue % (1000 * 1000) / 1000) 
            local nVal3 = math.floor(nLowValue % 1000) 

            local tbScores = {}
            if nVal1 > 0 then
                table.insert(tbScores, nVal1)
            end
            if nVal2 > 0 then
                table.insert(tbScores, nVal2)
            end
            if nVal3 > 0 then
                table.insert(tbScores, nVal3)
            end
            local szFailBestScore = table.concat( tbScores, "，" )
            local tbAwardAll = {};
            for i, nScore in ipairs(tbScores) do
                local tbAward = self:GetAwardIndexFromScore(nScore)
                if tbAward then
                    Lib:MergeTable(tbAwardAll, tbAward)
                end
            end
            if next(tbAwardAll) then
                Mail:SendSystemMail({
                    To = tbInfo.dwUnitID,
                    Title = szTitle,
                    Text = string.format(tbSetting.szFianalMailContent, szFailBestScore),
                    tbAttach = tbAwardAll,
                    nLogReazon = Env.LogWay_JueDiAct;
                });    
            else
                Log("Warn InDifferBattle.tbAct not award", tbInfo.dwUnitID, nLowValue)
            end
            
        end
    end
end

-- function tbAct:ClearMathInfo(  )
-- 	self.tbNotSaveData = {};
-- end

function tbAct:StartMatchSignUp()
	--类似武林大会那样申请跨服开始创建比赛吧
	Log("InDifferBattle StartMatchSignUp")
	-- self:ClearMathInfo();

	CallZoneServerScript("InDifferBattle.tbAct:StartMatchSignUp");
end

function tbAct:CloseMatchSignUp()
    CallZoneServerScript("InDifferBattle.tbAct:CloseMatchSignUp");
	InDifferBattle:OnServerStopSignUp()
end

function tbAct:MakeNewTopScroe(tbTopScroe, nNewScore, nCalTotolScoreNum)
    if nNewScore == 0 then
        return
    end
    if #tbTopScroe == nCalTotolScoreNum then
        if tbTopScroe[nCalTotolScoreNum] >= nNewScore  then
            return
        end
        table.remove(tbTopScroe)
    end
    table.insert(tbTopScroe, nNewScore)
    table.sort( tbTopScroe, function (a, b)
        return a > b
    end )
    return true
end

function tbAct:GetAwardIndexFromScore(nCurScore)
    for i,tbAwardInfo in ipairs(tbSetting.tbFinnalAwardSetting) do
        if tbAwardInfo.nScoreMin <= nCurScore then
            return tbAwardInfo.tbAward
        end
    end
end


function tbAct:SendPlayerAwardS(dwRoleId, nResult, nMatchTime, nScore, nKillCount, szBattleType, nDeathState)
    local nGrade, tbGradeSetting = InDifferBattle:GetEvaluationFromScore(nScore)
    local tbBattleSetting = InDifferBattle.tbBattleTypeSetting[szBattleType]
    local pPlayer = KPlayer.GetPlayerObjById(dwRoleId)
    if  pPlayer then
        if nResult == Env.LogRound_SUCCESS then
            local dwKinId = pPlayer.dwKinId
            local szNotifyMsg = string.format("Chúc mừng 「%s」tại Tâm Ma Ảo Cảnh %s với kỹ năng sinh tồn mạnh mẽ, tôi đã giành được giải thưởng!", pPlayer.szName, tbBattleSetting.nNeedGrade and tbBattleSetting.szName .. "賽" or "")
            if dwKinId ~= 0 then
                ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szNotifyMsg, dwKinId);     
            end
        end

        pPlayer.TLogRoundFlow(Env.LogWay_JueDiAct, tbBattleSetting.nFightMapTemplateId or tbDefine.nFightMapTemplateId, nScore, nMatchTime, nResult, 0, 0);
    end

    local tbActInst = self.tbActInst
    local tbActData = tbActInst:GetDataFromPlayer(dwRoleId) or {}
    local tbGetAward;
    local szMailContent = string.format("Các hiệp sĩ thân mến:\n\n    %s điểm tích lũy cá nhân được: [FFFE0D]%d[-][%s]（%s）[-].",  nResult == Env.LogRound_SUCCESS and "Chúc mừng ngài giành được chiến thắng trong lần Tâm ma này!" or "" , nScore, tbGradeSetting.szColor, tbGradeSetting.szName);
    if tbActData.nPlayCount <= tbSetting.nGetAwardCount then
         tbGetAward = {};
         szMailContent = string.format("%s phần thưởng tâm ma ảo cảnh, hãy kiểm tra và nhận!! \n\n Lưu ý: Cá nhân điểm tích lũy càng cao ban thưởng càng phong phú![-]", szMailContent)
        for i, v in ipairs(tbDefine.tbGetHonorSetting) do
            if nScore >= v.nScoreMin then
                tbGetAward = Lib:CopyTB(v["tbAward"..szBattleType] ) 
            else
                break;
            end
        end
    end

    local nCalTotolScoreNum = tbBattleSetting.nCalTotolScoreNum
    tbActData.tbTopScroe = tbActData.tbTopScroe or {}; --{ nScore }
    local tbTopScroe = tbActData.tbTopScroe

    local bChanged = self:MakeNewTopScroe(tbTopScroe, nScore, nCalTotolScoreNum)
    if bChanged  then
        if pPlayer then
            tbActInst:SaveDataToPlayer(pPlayer, tbActData)            
        else
            Log("Warn InDifferBattle.tbAct:SendPlayerAwardS player is offline", dwRoleId, nResult, nMatchTime, nScore, nKillCount, szBattleType, nDeathState)
        end
    end
    local nToTalScore = 0
    for i,v in ipairs(tbTopScroe) do
        nToTalScore = nToTalScore + v;
    end

    if  bChanged then
        local pRank = KRank.GetRankBoard(tbSetting.szRankboardKey)
        --直接存要拿的对应的奖励挡位算了
        local nVal1 = tbTopScroe[1] or 0
        local nVal2 = tbTopScroe[2] or 0
        local nVal3 = tbTopScroe[3] or 0
        if nVal1 >= 1000 or nVal2 >= 1000 or nVal3 >= 1000 then
            Log(debug.traceback())
            Log("InDifferBattle tbAct:SendPlayerAwardS", dwRoleId, nVal1, nVal2, nVal3)
        else
            local nLowValue = 1000 * 1000 * nVal1 + 1000 * nVal2 + nVal3
            pRank.UpdateValueByID(dwRoleId, {nToTalScore, nLowValue} )
        end
        Log("InDifferBattleAct ChangeRank", dwRoleId, nScore, nToTalScore, nLowValue)
    end

    local szTopScores = table.concat( tbTopScroe, ", ")
    szMailContent = string.format("%s\n điểm tích lũy cá nhận đạt %d điểm ：%s", szMailContent, nCalTotolScoreNum, szTopScores);

    Mail:SendSystemMail({
        To = dwRoleId,
        Title =  tbBattleSetting.szName ..  "Tâm ma ảo cảnh",
        Text = szMailContent,
        tbAttach = tbGetAward,
        nLogReazon = LogWay_JueDiAct,
    })
    
end

function tbAct:OnPlayedBattle( pPlayer )
    local tbActInst = self.tbActInst
    if not tbActInst then
        Log(debug.traceback())
        return
    end
    local tbActData = tbActInst:GetDataFromPlayer(pPlayer.dwID) or {}
    local nUpdateDay = Lib:GetLocalDay()
    if tbActData.nUpdateDay ~= nUpdateDay then
        tbActData.nUpdateDay = nUpdateDay
        tbActData.nPlayCount = 0        
    end
    tbActData.nPlayCount = (tbActData.nPlayCount or 0) + 1;
    tbActInst:SaveDataToPlayer(pPlayer, tbActData)            
    pPlayer.CallClientScript("Activity:OnSyncActivityCustomInfo", tbActInst.szKeyName, tbActData)
end

function tbAct:UpdateRank()
    local pRank = KRank.GetRankBoard(tbSetting.szRankboardKey)
    pRank.Rank()
end

-- function tbAct:OnServerOnReadyMapCreate( nReadyMapId )
--     if GetTimeFrameState(InDifferBattle.tbDefine.szOpenTimeFrame) ~= 1 then
--         Log("InDifferBattle.tbAct:OnServerOnReadyMapCreate TimeFrameState UnOpen")
--         return
--     end

-- end