
Require("CommonScript/Npc/NpcDefine.lua");
Require("CommonScript/Item/Define.lua");


ActionMode.nFightRideTime = 10; --战斗状态读条时间

ActionMode.tbChangeActModeEquip =
{
    [Npc.NpcActionModeType.act_mode_ride] = {nEquipPos = Item.EQUIPPOS_HORSE; szName = "Cưỡi ngựa"};
};

function ActionMode:GetActModeEquip(nActMode)
    return self.tbChangeActModeEquip[nActMode];
end

function ActionMode:CheckDoChangeActionMode(pPlayer, nActMode)
    if ActionInteract:IsInteract(pPlayer) then
        return false, "Động tác tương tác không thể sử dụng"
    end
    if not nActMode then
        return false, "Không thể sửa cưỡi";
    end
    local nCurActMode = pPlayer.GetActionMode();
    if nCurActMode == nActMode then
        return false, "Không thể đổi thú cưỡi!";
    end

    if nActMode == Npc.NpcActionModeType.act_mode_none then
        return true, "";
    end

    if OnHook:IsOnLineOnHook(pPlayer) and not OnHook:IsOnLineOnHookForce(pPlayer) then
        return false, "Đang ủy thác online không thể dùng";
    end

    local tbActModeInfo = self:GetActModeEquip(nActMode);
    if not tbActModeInfo then
        return false, "Không thể thay đổi động tác!";
    end

    local pPlayerNpc = pPlayer.GetNpc();
    local nResult = pPlayerNpc.CanChangeDoing(Npc.Doing.skill);
    if nResult == 0 then
        return false, string.format("Đang dùng kỹ năng không thể %s", tbActModeInfo.szName);
    end

    local nMapTID = pPlayer.nMapTemplateId;
    if Map:IsForbidRide(nMapTID) then
        return false, string.format("Bản đồ hiện tại không được %s", tbActModeInfo.szName);
    end

    local pEquip = pPlayer.GetEquipByPos(tbActModeInfo.nEquipPos);
    if not pEquip then
        return false, "Chưa xuất trận";
    end

    local pNpc = pPlayer.GetNpc();
    if not pNpc then
        return false, "Không thể cưỡi ngựa";
    end

    if pNpc.nShapeShiftNpcTID > 0 then
        return false, string.format("Trạng thái biến thân không thể %s", tbActModeInfo.szName);
    end

    if not pPlayer.nLastRideTime then
        pPlayer.nLastRideTime = 0;
    end

    local nCurTime = GetTime();
    if pPlayer.nFightMode ~= Npc.FIGHT_MODE.emFightMode_None and (nCurTime - pPlayer.nLastRideTime) <= ActionMode.nFightRideTime then
        return false, string.format("%s quá mệt, hãy nghỉ ngơi", tbActModeInfo.szName);
    end

    if pPlayer.bTempForbitMount then
        return false, "Tạm không thể cưỡi ngựa"
    end

    local bRet, szMsg = House:CheckCanRide(pPlayer);
    if not bRet then
        return false, szMsg;
    end

    return true, "";
end

function ActionMode:DoChangeActionMode(pPlayer, nActMode, bNotMsg, bBroadcast)
    local bRet, szMsg = self:CheckDoChangeActionMode(pPlayer, nActMode);
    if not bRet then
        if not bNotMsg then
            pPlayer.CenterMsg(szMsg);
        end
        return;
    end

    pPlayer.DoChangeActionMode(nActMode, bBroadcast or false);
    if nActMode ~= Npc.NpcActionModeType.act_mode_none then
        pPlayer.nLastRideTime = GetTime();
    end
end

function ActionMode:OnEnterMap(pPlayer, nMapTemplateId)
    local nCurActMode = pPlayer.GetActionMode();
    if nCurActMode == Npc.NpcActionModeType.act_mode_none then
        return;
    end

    if not Map:IsForbidRide(nMapTemplateId) then
        return;
    end

    ActionMode:DoForceNoneActMode(pPlayer, "Bản đồ hiện tại không được cưỡi ngựa!");
end

function ActionMode:DoForceNoneActMode(pPlayer, szMsg, bBroadcast)
    local nCurActMode = pPlayer.GetActionMode();
    if nCurActMode == Npc.NpcActionModeType.act_mode_none then
        return;
    end

    self:DoChangeActionMode(pPlayer, Npc.NpcActionModeType.act_mode_none, false, bBroadcast);
    if szMsg then
        pPlayer.CenterMsg(szMsg);
    end
end

function ActionMode:ServerSendActMode(pPlayer)
    local nActMode = pPlayer.GetActionMode();
    pPlayer.CallClientScript("ActionMode:ClientActionMode", nActMode);
end

function ActionMode:ClientActionMode(nActMode)
    local nCurActMode = me.GetActionMode();
    if nCurActMode == nActMode then
        return;
    end

    me.DoChangeActionMode(nActMode);
end

function ActionMode:CallDoActionMode(nActionMode, bMsg)
    local nCurAction = me.GetActionMode();
    if nCurAction == nActionMode then
        return;
    end

    local bAuto = AutoFight:IsAuto();
    if bAuto and nActionMode ~= Npc.NpcActionModeType.act_mode_none then
        if bMsg then
            me.CenterMsg("Tự chiến đấu không thể cưỡi ngựa");
        end
        return;
    end

    if not Toy:IsFree() and nActionMode ~= Npc.NpcActionModeType.act_mode_none then
        me.CenterMsg("Trạng thái biến thân, không thể cưỡi ngựa")
        return
    end

    if IsAlone() == 1 then
        ActionMode:DoChangeActionMode(me, nActionMode);
    else
        RemoteServer.ChangeActionMode(nActionMode);
    end
end