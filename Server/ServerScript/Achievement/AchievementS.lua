function Achievement:OnLogin(pPlayer)
    if MODULE_ZONESERVER then
        return
    end

    local tbData = pPlayer.GetScriptTable("CheckFlagData")
    if tbData.nAchievementVersion == self.VERSION then
        return
    end

    Log("Achievement Combine Data Begin:", pPlayer.dwID)
    local nPoint = 0
    for szKind, tbInfo in pairs(self.tbSetting) do
        local tbOldData = tbInfo.tbOldData
        if tbOldData then
            local nOldCount = pPlayer.GetUserValue(tbOldData.nDataGroup, tbOldData.nDataKey)
            pPlayer.SetUserValue(self.DATA_GROUP, tbInfo.nKeyId, nOldCount)
            Log("---", szKind, nOldCount)

            for nLv, tbLvInfo in ipairs(tbInfo.tbLevel) do
                local tbGainData = tbLvInfo.tbGainData
                if tbGainData then
                    local nOldGainFlag = pPlayer.GetUserValue(self.MAINDATA_GROUD_ID, tbGainData.nGainKey)
                    if KLib.GetBit(nOldGainFlag, tbGainData.nGainLevel) == 1 then
                        local nGainFlag = pPlayer.GetUserValue(self.GAIN_AWARD_GROUP, tbInfo.nKeyId)
                        nGainFlag = KLib.SetBit(nGainFlag, nLv, 1)
                        pPlayer.SetUserValue(self.GAIN_AWARD_GROUP, tbInfo.nKeyId, nGainFlag)
                        if tbLvInfo.nPoint > 0 then
                            nPoint = nPoint + tbLvInfo.nPoint
                        end
                        Log("------", nLv, tbGainData.nGainLevel, nPoint)
                    end
                end
            end
        end
    end

    if nPoint > 0 then
        RankBoard:UpdateRankVal("AchievementPoint", pPlayer.dwID, nPoint)
        Achievement:AddCount(pPlayer, "AchievementPoint", nPoint)
    end

    tbData.nAchievementVersion = self.VERSION
    pPlayer.SaveScriptTable("CheckFlagData")
    Log("Achievement Data Combine Over", pPlayer.dwID)

    self:CheckOldFinishAchievent(pPlayer)
end

function Achievement:CheckOldFinishAchievent( pPlayer )
    PlayerTitle:CheckOldFinishAchievent(pPlayer)
    Lib:CallBack({Partner.CheckOldFinishAchievent, Partner, pPlayer});
    Achievement:SetCount(pPlayer, "Label", pPlayer.nHonorLevel)
    Achievement:SetCount(pPlayer, "PlayerLevel", pPlayer.nLevel)
end

function Achievement:OnUpdateCount(pPlayer, szKind, nCount)
    if self.tbLegal[szKind] then
        self:AddCount(pPlayer, szKind, nCount);
    end
end

--player可以是玩家ID(注意：跨服不支持，因为没有接口获取ConnectIdx)或者玩家对象，真·支持离线
function Achievement:AddCount(player, szKind, nAddCount, bZoneValid)
    nAddCount = nAddCount or 1
    self:__AddCount(player, szKind, nAddCount, bZoneValid, true)
end

function Achievement:SetCount(player, szKind, nCount, bZoneValid)
    self:__AddCount(player, szKind, nCount, bZoneValid)
end

function Achievement:__AddCount(player, szKind, nCount, bZoneValid, bAdd)
    if Server:IsCloseIOSEntry() then
        return
    end
    if not player or not nCount or nCount <= 0 or not szKind or not self.tbSetting[szKind] then
        Log("Achievement AddCount Param Error", szKind, nCount, bZoneValid, bAdd)
        return
    end
    local szFunc = bAdd and "Achievement:AddCount" or "Achievement:SetCount"
    if MODULE_ZONESERVER then
        if bZoneValid then
            if type(player) == "number" then
                Log(debug.traceback())
            else
                CallZoneClientScript(player.nZoneIndex, szFunc, player.dwOrgPlayerId, szKind, nCount)
            end
        end
        return
    end

    local pPlayer = player
    if type(player) == "number" then
        pPlayer = KPlayer.GetPlayerObjById(player)
        if not pPlayer then
            KPlayer.AddDelayCmd(player,
                string.format("%s(me, '%s', %d)", szFunc, szKind, nCount),
                string.format("%s By DelayCmd: %d, %s, %d", szFunc, player, szKind, nCount))
            return
        end
    end
    if not pPlayer then
        Log("Achievement AddCount PlayerErr")
        return
    end

    if self:IsKindCompleted(pPlayer, szKind) then
        return
    end
    local nOldCount = self:GetSubKindCount(pPlayer, szKind)
    if bAdd then
        nCount = nOldCount + nCount
    else
        if nCount <= nOldCount then
            return
        end
    end
    self:SaveSubKindCount(pPlayer, szKind, nCount)
    self:OnCountChange(pPlayer, szKind, nOldCount, nCount)
end

function Achievement:IsKindCompleted(pPlayer, szKind)
    local nCurCount = self:GetSubKindCount(pPlayer, szKind)
    local nMaxCount = self:GetKindMaxCount(szKind)
    return nCurCount >= nMaxCount
end

function Achievement:OnCountChange(pPlayer, szKind, nCurCount, nNewCount)
    local tbCompleteLv = {}
    for nLevel, tbInfo in ipairs(self.tbSetting[szKind].tbLevel) do
        local nCount = tbInfo.nCount
        if nCurCount < nCount and nNewCount >= nCount then
            table.insert(tbCompleteLv, nLevel)
            pPlayer.OnEvent("OnAchievementCompleted", szKind, "", nLevel)

            self:SendCompleteSysMsg(pPlayer, szKind, nLevel)

            pPlayer.TLog("TaskFlow",
                pPlayer.nLevel,
                pPlayer.GetVipLevel(),
                Env.LogWay_AchievementAward,
                self.tbSetting[szKind].nKeyId * 1000 + nLevel,
                1)
            Log("Achievement Complete Level:", pPlayer.dwID, szKind, nLevel)
        end
    end

    if next(tbCompleteLv) then
        pPlayer.CallClientScript("Achievement:OnCompleteLv", szKind, tbCompleteLv)
    end
end

function Achievement:SendCompleteSysMsg(pPlayer, szKind, nLevel)
    local tbLevelInfo = self:GetLevelInfo(szKind, nLevel)
    if not tbLevelInfo or ((tbLevelInfo.nKinMsg == 0 or pPlayer.dwKinId == 0) and tbLevelInfo.nWorldMsg == 0) then
        return
    end

    local szMsg = string.format("「%s」Đạt được <Thành Tựu：%s>", pPlayer.szName, tbLevelInfo.szName)
    local tbData = { nLinkType = ChatMgr.LinkType.Achievement, szComName = pPlayer.szName, szKind = szKind, nLevel = nLevel }
    if pPlayer.dwKinId ~= 0 and tbLevelInfo.nKinMsg > 0 then
        ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, pPlayer.dwKinId, tbData)
    end

    if tbLevelInfo.nWorldMsg > 0 then
        if pPlayer.dwKinId > 0 then
            local tbKin = Kin:GetKinById(pPlayer.dwKinId)
            if tbKin then
                szMsg = string.format("%s Bang hội %s", tbKin.szName or "", szMsg)
            end
        end
        ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.System, szMsg, 0, tbData)
        KPlayer.SendWorldNotify(1, 999, szMsg, 0, 1)
    end
end

function Achievement:TryGainAward(pPlayer, szKind, nGainLevel)
    if not pPlayer or not szKind then
        return;
    end

    if DegreeCtrl:GetDegree(pPlayer, "AchievementGain") <= 0 then
        pPlayer.CenterMsg("Số lượng phần thưởng nhận được hôm nay đã đạt đến giới hạn. Vui lòng thử lại vào ngày mai!")
        return
    end

    nGainLevel = nGainLevel or (self:GetGainLevel(pPlayer, szKind) + 1)
    if not self:CheckCanGainAward(pPlayer, szKind, nGainLevel) then
        return
    end

    local nMaxLevel  = self:GetMaxLevel(szKind)
    if nGainLevel > nMaxLevel then
        return
    end

    local bComplete = self:CheckCompleteLevel(pPlayer, szKind, nGainLevel)
    if not bComplete then
        return
    end

    self:SetGainLevel(pPlayer, szKind, nGainLevel);
    DegreeCtrl:ReduceDegree(pPlayer, "AchievementGain", 1)

    local tbAward = self:GetAwardInfo(szKind, nGainLevel)
    if tbAward and next(tbAward) then
        pPlayer.SendAward(tbAward, false, true, Env.LogWay_AchievementAward);
    end
    pPlayer.CallClientScript("Achievement:OnGainAwardRsp", szKind, nGainLevel);
    Log("Achievement TryGainAward GetAward", pPlayer.dwID, szKind, nGainLevel)

    local tbLvInfo  = self:GetLevelInfo(szKind, nGainLevel)
    local nAddPoint = (tbLvInfo or {}).nPoint or 0
    if nAddPoint > 0 then
        local pRank = KRank.GetRankBoard("AchievementPoint")
        if pRank then
            local tbInfo = pRank.GetRankInfoByID(pPlayer.dwID)
            local nValue = nAddPoint
            if tbInfo then
                nValue = nValue + tonumber(tbInfo.szValue or "0")
            end
            RankBoard:UpdateRankVal("AchievementPoint", pPlayer.dwID, nValue)
        end
        Achievement:AddCount(pPlayer, "AchievementPoint", nAddPoint)
    end
end

function Achievement:SetGainLevel(pPlayer, szKind, nGainLevel)
    if not pPlayer or not szKind or not nGainLevel then
        return;
    end

    local nGroupID = self:GetGroupKey(szKind)
    if not nGroupID then
        Log("Achievement:SetGainLevel >>>>", szKind, nGainLevel)
        return
    end

    local nGainFlag = pPlayer.GetUserValue(self.GAIN_AWARD_GROUP, nGroupID)
    nGainFlag = KLib.SetBit(nGainFlag, nGainLevel, 1)
    pPlayer.SetUserValue(self.GAIN_AWARD_GROUP, nGroupID, nGainFlag)
end

function Achievement:SaveSubKindCount(pPlayer, szKind, nCount)
    if not pPlayer or not szKind or not nCount then
        return;
    end

    local nGroupKey, nValueKey = self:GetCountSaveKey(szKind);
    if not nGroupKey or not nValueKey then
        Log("Achievement ERR: GetSaveKey Fail ", nGroupKey);
        return;
    end

    pPlayer.SetUserValue(nGroupKey, nValueKey, nCount);
    Log("Achievement Count Change", pPlayer.dwID, szKind, nCount)
end

function Achievement:OnRequestCheckAchievementFinish(pPlayer, tbCheckAchi)
    if not tbCheckAchi then
        return
    end

    for i, nKindId in ipairs(tbCheckAchi) do
        local szKind = self:GetKindById(nKindId)
        local bRet, nCount = self:CheckSpecilAchievementFinish(pPlayer, szKind);
        if bRet then
            self:AddCount(pPlayer, szKind, nCount)
            Log("Achievement:OnRequestCheckAchievementFinish", pPlayer.dwID, szKind, nCount)
        end    
    end
end

function Achievement:RefreshLikeList(pPlayer, tbLike, tbUnLike)
    tbLike   = tbLike or {}
    tbUnLike = tbUnLike or {}
    if #tbLike == 0 and #tbUnLike == 0 then
        return
    end
    local tbList, nCount = self:GetLikeList(pPlayer)
    local bChange = false
    for _, nValue in pairs(tbUnLike or {}) do
        if tbList[nValue] then
            tbList[nValue] = false
            nCount         = nCount - 1
            bChange        = true
        end
    end
    local tbFinalList = {}
    for nValue, bLike in pairs(tbList) do
        if bLike then
            table.insert(tbFinalList, nValue)
        end
    end
    if nCount < self.LIKE_MAXCOUNT then
        for _, nValue in pairs(tbLike or {}) do
            if not tbList[nValue] then
                local nId, nLevel = self:GetKindAndLevel(nValue)
                local szKind      = self:GetKindById(nId)
                local _, nFlag    = Achievement:CheckCanGainAward(pPlayer, szKind, nLevel)
                if nFlag == 1 then
                    tbList[nValue] = true
                    nCount         = nCount + 1
                    bChange        = true
                    table.insert(tbFinalList, nValue)
                    if nCount >= self.LIKE_MAXCOUNT then
                        break
                    end
                end
            end
        end
    end
    if not bChange then
        return
    end

    local pAsyncData = KPlayer.GetAsyncData(pPlayer.dwID)
    for i = 1, self.LIKE_MAXCOUNT do
        local nValue = tbFinalList[i] or 0
        if pAsyncData then
            pAsyncData.SetAsyncValue(self.LIKE_ASYNC_BEGIN + i - 1, nValue)
        end
        pPlayer.SetUserValue(self.LIKE_GROUP, i, nValue)
    end
    Log("Achievement RefreshLikeList:", pPlayer.dwID, nCount)
end