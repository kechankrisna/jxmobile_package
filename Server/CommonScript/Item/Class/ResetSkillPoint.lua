local tbItem = Item:GetClass("ResetSkillPoint");

function tbItem:CheckResetSkillPoint(pPlayer)
    local nToalCostPoint = pPlayer.GetUserValue(FightSkill.nSaveSkillPointGroup, FightSkill.nSaveCostSkillPoint);
    if nToalCostPoint <= 0 then
        return false, "Điểm kỹ năng chưa tạo mới";
    end

    return true, "";    
end

function tbItem:OnUse(it)
    local bRet, szMsg = self:CheckResetSkillPoint(me);
    if not bRet then
        me.CenterMsg(szMsg);
        return;
    end

    FightSkill:ResetSkillPoint(me);
    me.CallClientScript("Ui:OpenWindow", "SkillPanel");
    Log("FightSkill ResetSkillPoint", me.dwID, nToalCostPoint);
    return 1;
end  