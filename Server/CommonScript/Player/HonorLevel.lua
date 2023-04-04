
Player.tbHonorLevel = Player.tbHonorLevel or {}
local tbHonorLevel = Player.tbHonorLevel;
tbHonorLevel.nSaveGroupID = 27;
tbHonorLevel.nSaveFightPower = 1;
tbHonorLevel.nSaveFightPowerStar = 2;
tbHonorLevel.nMinOpenLevel = 17; --最少等级开启
tbHonorLevel.szAchievementKey = "HonorLevel_1";
tbHonorLevel.XD_EX_HONOR_ATTRIB_GROUP = 3; --额外的属性

function tbHonorLevel:GetHonorLevelInfo(nHonorLevel)
    return Player.tbHonorLevelSetting[nHonorLevel];
end

function tbHonorLevel:GetHonorName(nHonorLevel)
    local tbInfo = self:GetHonorLevelInfo(nHonorLevel)
    return tbInfo and tbInfo.Name or ""
end

function tbHonorLevel:GetMainLevel(nHonorLevel)
    local tbInfo = self:GetHonorLevelInfo(nHonorLevel)
    return tbInfo and tbInfo.MainLevel or 0
end

function tbHonorLevel:GetSaveHonorLevel(pPlayer)
    if not self.tbLevelTranslate then
        self.tbLevelTranslate = {}
        for nLevel, tbInfo in pairs(Player.tbHonorLevelSetting) do
            self.tbLevelTranslate[tbInfo.MainLevel * 10000 + tbInfo.StarLevel] = nLevel
        end
    end

    local nMainLevel = pPlayer.GetUserValue(self.nSaveGroupID, self.nSaveFightPower)
    local nStarLevel = pPlayer.GetUserValue(self.nSaveGroupID, self.nSaveFightPowerStar)
    return self.tbLevelTranslate[nMainLevel * 10000 + nStarLevel] or 0
end

function tbHonorLevel:SaveHonorLevel(pPlayer, tbHonorInfo)
    pPlayer.SetUserValue(self.nSaveGroupID, self.nSaveFightPower, tbHonorInfo.MainLevel)
    pPlayer.SetUserValue(self.nSaveGroupID, self.nSaveFightPowerStar, tbHonorInfo.StarLevel)
end

function tbHonorLevel:CheckFinishHonorLevel(pPlayer)
    if not pPlayer then
        return false, "Người chơi không tồn tại";
    end

    if self.nMinOpenLevel > pPlayer.nLevel then
        return false, string.format("Chưa đạt cấp %s", self.nMinOpenLevel);
    end

    local nAddHonorLevel = pPlayer.nHonorLevel + 1;
    local tbHonorInfo = self:GetHonorLevelInfo(nAddHonorLevel);
    if not tbHonorInfo then
        return false, "Chưa mở Quân Hàm";
    end

    if GetTimeFrameState(tbHonorInfo.TimeFrame) ~= 1 then
        return false, "Chưa mở Quân Hàm!";
    end

    local pNpc = pPlayer.GetNpc();
    local nFightPower  = pNpc.GetFightPower();
    if tbHonorInfo.NeedPower > nFightPower then
        return false, string.format("Lực chiến không đủ [FFFE0D]%d[-], hãy cố gắng lên!", tbHonorInfo.NeedPower);
    end

    local nTotalStart = PersonalFuben:GetAllSectionStarAllLevel(pPlayer);
    if tbHonorInfo.NeedFubenStar > nTotalStart then
        return false, string.format("Cấp sao ải chưa đạt %d", tbHonorInfo.NeedFubenStar);
    end

    -- if GetTimeFrameState(tbHonorInfo.RepairTimeFrame) == 1 then
    --    return true, "", tbHonorInfo;
    -- end

    local nFightPowerLV = self:GetSaveHonorLevel(pPlayer)
    if nFightPowerLV ~= pPlayer.nHonorLevel then
        return false, "Cần có Anh Hùng Lệnh";
    end

    local bRet, szMsg = self:CheckNeedItem(pPlayer, tbHonorInfo);
    if not bRet then
        return false, szMsg;
    end

    return true, "", tbHonorInfo;
end

function tbHonorLevel:CheckNeedItem(pPlayer, tbHonorInfo)
    if tbHonorInfo.ItemCount <= 0 then
        return true;
    end

    local nTotalCount = pPlayer.GetItemCountInAllPos(tbHonorInfo.ItemID);
    if tbHonorInfo.ItemCount > nTotalCount then
        local tbItemInfo = KItem.GetItemBaseProp(tbHonorInfo.ItemID);
        return false, string.format("Lần tăng cấp này cần [FFFE0D]%s[-] [FFFE0D]%s[-], mau đi thu thập!", tbHonorInfo.ItemCount, tbItemInfo.szName);
    end

    return true;
end

function tbHonorLevel:FinishHonorLevel(pPlayer)
    local bRet, szMsg, tbHonorInfo = self:CheckFinishHonorLevel(pPlayer);
    if not bRet then
        pPlayer.CenterMsg(szMsg);
        return;
    end

    local nFightPowerLV = self:GetSaveHonorLevel(pPlayer)
    local bRet = self:CheckNeedItem(pPlayer, tbHonorInfo);
    local nOldHonorLevel = pPlayer.nHonorLevel
    if bRet and nOldHonorLevel == nFightPowerLV then
        if tbHonorInfo.ItemCount > 0 then
            local nConsumeCount = pPlayer.ConsumeItemInAllPos(tbHonorInfo.ItemID, tbHonorInfo.ItemCount, Env.LogWay_FinishHonorLevel);
            assert(tbHonorInfo.ItemCount == nConsumeCount);
        end

        self:SaveHonorLevel(pPlayer, tbHonorInfo)
        Log("HonorLevel FinishHonorLevel Add FightPower", pPlayer.dwID, pPlayer.szName, nOldHonorLevel);
    end

    pPlayer.SetHonorLevel(tbHonorInfo.Level);
    pPlayer.TLog("HonorLevelFlow", pPlayer.nLevel, nOldHonorLevel, tbHonorInfo.Level)
    Achievement:AddCount(pPlayer, tbHonorLevel.szAchievementKey, 1);

    if pPlayer.dwKinId ~= 0 then
        local szShowMsg = string.format("「%s」tăng thành「%s」", pPlayer.szName, tbHonorInfo.Name);
        ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szShowMsg, pPlayer.dwKinId);
    end

    pPlayer.CallClientScript("Ui:OpenWindow", "SharePanelNew", "HonorLevelUp");
    FightPower:ChangeFightPower("Honor", pPlayer);

    pPlayer.CallClientScript("Player.tbHonorLevel:UpdateInfo");

    if tbHonorInfo.IsNotice == 1 then
        local tbHonorLevelRank = ScriptData:GetValue("HonorLevelRank");
        local nCurRank = tbHonorLevelRank[tbHonorInfo.MainLevel] or 0;
        nCurRank = nCurRank + 1;
        tbHonorLevelRank[tbHonorInfo.MainLevel] = nCurRank;
        local szWorldMsg = nil;
        if nCurRank == 1 then
            szWorldMsg = string.format("「%s」trở thành người đầu tiên tăng đến quân hàm「%s」toàn máy chủ", pPlayer.szName, tbHonorInfo.Name);
        elseif nCurRank >= 2 and nCurRank <= 10 then
            szWorldMsg = string.format("「%s」lọt vào top 10 người tăng đến quân hàm「%s」toàn máy chủ", pPlayer.szName, tbHonorInfo.Name);
        end

        if not Lib:IsEmptyStr(szWorldMsg) then
            KPlayer.SendWorldNotify(1, 999, szWorldMsg, 1, 1);
        end

        ScriptData:AddModifyFlag("HonorLevelRank");
    end

    if pPlayer.dwKinId>0 then
        local kinData = Kin:GetKinById(pPlayer.dwKinId)
        kinData:SetCacheFlag("UpdateMemberInfoList", true)
    end

    Kin:RedBagOnEvent(pPlayer, Kin.tbRedBagEvents.title, tbHonorInfo.Level)
    TeacherStudent:OnAddHonorTitle(pPlayer, tbHonorInfo.Level)

    pPlayer.OnEvent("OnHonorLevelUp", pPlayer.nHonorLevel, nOldHonorLevel);
    pPlayer.CallClientScript("GameSetting.Comment:OnEvent", GameSetting.Comment.Type_HonorLevelChange, tbHonorInfo.Level);
    Activity:OnPlayerEvent(pPlayer, "Act_HonorLevel", tbHonorInfo.Level);
    Achievement:SetCount(pPlayer, "Label", tbHonorInfo.Level);
    Log("HonorLevel FinishHonorLevel", pPlayer.dwID, pPlayer.szName, pPlayer.nHonorLevel, tbHonorInfo.Level);
end


function tbHonorLevel:CheckRepairItem(pPlayer)
    if self.nMinOpenLevel > pPlayer.nLevel then
        return false, string.format("Chưa đạt cấp %s", self.nMinOpenLevel);
    end

    local nFightPowerLV = self:GetSaveHonorLevel(pPlayer)
    nFightPowerLV = nFightPowerLV + 1;

    if nFightPowerLV > pPlayer.nHonorLevel then
        return false, "Quân Hàm chưa đạt cấp nộp bù";
    end

    local tbHonorInfo = self:GetHonorLevelInfo(nFightPowerLV);
    if not tbHonorInfo then
        return false, "Chưa mở Quân Hàm";
    end

    if GetTimeFrameState(tbHonorInfo.RepairTimeFrame) ~= 1 then
       return false, "Chưa mở";
    end

    local bRet, szMsg = self:CheckNeedItem(pPlayer, tbHonorInfo);
    if not bRet then
        return false, szMsg;
    end

    return true, "", tbHonorInfo;
end

-- function tbHonorLevel:RepairItem(pPlayer)
--     local bRet, szMsg, tbHonorInfo = self:CheckRepairItem(pPlayer);
--     if not bRet then
--         pPlayer.CenterMsg(szMsg);
--         return;
--     end

--     if tbHonorInfo.ItemCount > 0 then
--         local nConsumeCount = pPlayer.ConsumeItemInAllPos(tbHonorInfo.ItemID, tbHonorInfo.ItemCount, "HonorRepairItem");
--         assert(tbHonorInfo.ItemCount == nConsumeCount);
--     end

--     pPlayer.SetUserValue(self.nSaveGroupID,  self.nSaveFightPower, tbHonorInfo.Level);
--     FightPower:ChangeFightPower("Honor", pPlayer);
--     Log("HonorLevel RepairItem", pPlayer.dwID, pPlayer.szName, pPlayer.nHonorLevel, tbHonorInfo.Level);
-- end

function tbHonorLevel:CheckTimeFrameRedPoint(pPlayer)
    local nHonorLevel    = pPlayer.nHonorLevel;
    local nAddHonorLevel = nHonorLevel + 1;
    local tbHonorInfo = self:GetHonorLevelInfo(nHonorLevel);
    if not tbHonorInfo then
        return false;
    end

    local tbAddHonorInfo = self:GetHonorLevelInfo(nAddHonorLevel);
    if not tbAddHonorInfo then
        return false;
    end

    if GetTimeFrameState(tbAddHonorInfo.TimeFrame) ~= 1 then
        return false;
    end 

    if tbAddHonorInfo.TimeFrame == tbHonorInfo.TimeFrame then
        return false;
    end    

    local tbUserSet = Client:GetUserInfo("HonorLevelData");
    if tbUserSet.szRedPoint and tbAddHonorInfo.TimeFrame == tbUserSet.szRedPoint then
        return false;
    end    
    
    return true, tbAddHonorInfo;    
end

function tbHonorLevel:UpdateRedPoint()
    local bRet = self:CheckFinishHonorLevel(me);
    local bRet1 = self:CheckTimeFrameRedPoint(me);
    if bRet or bRet1 then
        Ui:SetRedPointNotify("TitleUpgrade")
    else
        Ui:ClearRedPointNotify("TitleUpgrade") 
    end
end

function tbHonorLevel:UpdateInfo()
    if Ui:WindowVisible("HonorLevelPanel") == 1 then
        Ui("HonorLevelPanel"):UpdateInfo();
    end
end

function tbHonorLevel:GetFightLevel(nHonorLevel)
    local tbInfo = self:GetHonorLevelInfo(nHonorLevel)
    if not tbInfo then
        return 0
    end
    return tbInfo.FightLevel
end