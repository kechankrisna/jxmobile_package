
ActionInteract.tbDef = ActionInteract.tbDef or {};
local tbDef = ActionInteract.tbDef;
tbDef.szNormalShape = "Normal"; --默认的体型
tbDef.nInteractLen = 300; --交互距离
tbDef.tbLimitMap = {[10] = 1, [15] = 1,  [999] = 1, [1000] = 1, [1600] = 1, [8009] = 1,}; --限制地图
tbDef.tbWeddingShape = {["M2"] = "M1"};




function ActionInteract:LoadSetting()
    self.tbAllInteractInfo = {};
    self.tbFactionShapeInfo = {};
    self.tbHorseItemInfo = {};
    self.tbInteractShowInfo = {};

    local tbFileData = Lib:LoadTabFile("Setting/ActionInteract/Interact.tab", {InteractID = 1});
    for _, tbInfo in pairs(tbFileData) do
        local tbInteract = {};
        tbInteract.nInteractID = tbInfo.InteractID;
        tbInteract.szType = tbInfo.Type;
        tbInteract.szMainShape = tbInfo.MainShape;
        tbInteract.szPassivityShape = tbInfo.PassivityShape;
        tbInteract.tbMainParam = Lib:AnalyzeParamStrOne(tbInfo.MainParam);
        tbInteract.tbPassivityParam = Lib:AnalyzeParamStrOne(tbInfo.PassivityParam);
        tbInteract.szSendChat = tbInfo.SendChat;
        tbInteract.szRefuseChat = tbInfo.RefuseChat;
        tbInteract.szAcceptChat = tbInfo.AcceptChat;
        tbInteract.szMsgBoxConent = tbInfo.MsgBoxConent;

        self.tbAllInteractInfo[tbInfo.InteractID] = self.tbAllInteractInfo[tbInfo.InteractID] or {};
        self.tbAllInteractInfo[tbInfo.InteractID][tbInfo.MainShape] = self.tbAllInteractInfo[tbInfo.InteractID][tbInfo.MainShape] or {};
        self.tbAllInteractInfo[tbInfo.InteractID][tbInfo.MainShape][tbInfo.PassivityShape] = tbInteract;

        local tbShowInfo = {};
        tbShowInfo.szName = tbInfo.Name;
        tbShowInfo.szIcon = tbInfo.Icon;
        tbShowInfo.szIconAtlas = tbInfo.IconAtlas;
        tbShowInfo.nInteractID = tbInfo.InteractID;
        tbShowInfo.szType = tbInfo.Type;

        self.tbInteractShowInfo[tbInfo.MainShape] = self.tbInteractShowInfo[tbInfo.MainShape] or {};
        self.tbInteractShowInfo[tbInfo.MainShape][tbInfo.InteractID] = tbShowInfo;
    end

    tbFileData = Lib:LoadTabFile("Setting/ActionInteract/FactionShape.tab", {FactionID = 1, Sex = 1});
    for _, tbInfo in pairs(tbFileData) do
        self.tbFactionShapeInfo[tbInfo.FactionID] = self.tbFactionShapeInfo[tbInfo.FactionID] or {};
        self.tbFactionShapeInfo[tbInfo.FactionID][tbInfo.Sex] = tbInfo; 
    end

    tbFileData = Lib:LoadTabFile("Setting/ActionInteract/HorseItem.tab", {ItemID = 1});
    for _, tbInfo in pairs(tbFileData) do
        self.tbHorseItemInfo[tbInfo.ItemID] = tbInfo;
    end
end

ActionInteract:LoadSetting();

function ActionInteract:CancelInteractC()
    if not self.tbSelfActInteract then
        return;
    end

    me.CenterMsg(string.format("Đã hủy「%s」", self.tbSelfActInteract.szName), true);
    self.tbSelfActInteract = nil;
end

function ActionInteract:SelectPlayerInteract(pNpc)
    if not self.tbSelfActInteract or not pNpc then
        return;
    end

    if pNpc.nKind ~= Npc.KIND.player then
        return;
    end

    if pNpc.dwPlayerID == me.dwID then
        return;
    end

    RemoteServer.SendActInteract(pNpc.dwPlayerID, self.tbSelfActInteract.nID);

    me.CenterMsg(string.format("Đã mời「%s」「%s」", pNpc.szName, self.tbSelfActInteract.szName), true);
    self.tbSelfActInteract = nil;
end

function ActionInteract:GetShowRightPopup(pPlayer)
    local szShape = self:GetPlayerFactionShape(pPlayer);
    local tbInteractInfo = self:GetInteractShowInfo(szShape);
    if not tbInteractInfo then
        return;
    end

    local tbSortList = {};
    for nInteractID, tbShowInfo in pairs(tbInteractInfo) do
        table.insert(tbSortList, tbShowInfo);
    end

    table.sort(tbSortList, function (a, b)
        return a.nInteractID < b.nInteractID;
    end )
    
    local tbSelfPopup = {};
    for _, tbShowInfo in ipairs(tbSortList) do
        if tbShowInfo.szType ~= "HorseRunSt" or not  Map:IsForbidRide(pPlayer.nMapTemplateId) then
            local tbInfo = {};
            tbInfo.fnName = function ()
                return tbShowInfo.szName;
            end;
            tbInfo.fnOnClick = function (self)
                RemoteServer.SendActInteract(self.tbData.dwRoleId, tbShowInfo.nInteractID);
            end;
            tbInfo.fnAvaliable = function (tbData)
                return true;
            end;
            table.insert(tbSelfPopup, tbInfo);    
        end
    end

    return tbSelfPopup;
end

function ActionInteract:GetInteractShowInfo(szShape)
    local tbAllShowInfo = self.tbInteractShowInfo[szShape] or self.tbInteractShowInfo[tbDef.szNormalShape];
    return tbAllShowInfo;
end

function ActionInteract:GetFactionShape(nFaction, nSex)
    local tbInfo = self.tbFactionShapeInfo[nFaction];
    if not tbInfo then
        return tbDef.szNormalShape, "-";
    end

    if not tbInfo[nSex] then
        return tbDef.szNormalShape, "-";
    end

    return tbInfo[nSex].Shape, tbInfo[nSex].Name;
end

function ActionInteract:GetInteractInfo(nInteractID, szShape, szPassivityShape)
    local tbShapeInteract = self.tbAllInteractInfo[nInteractID];
    if not tbShapeInteract then
        return;
    end

    local tbAllInteract = tbShapeInteract[szShape] or tbShapeInteract[tbDef.szNormalShape];
    if not tbAllInteract then
        return;
    end

    local tbInteract  = tbAllInteract[szPassivityShape] or tbAllInteract[tbDef.szNormalShape];
    return tbInteract;
end

function ActionInteract:CheckPlayerState(pPlayer, bDreamMap)
    local pPlayerNpc = pPlayer.GetNpc();
    local nResult = pPlayerNpc.CanChangeDoing(Npc.Doing.skill);
    if nResult == 0 then
        return false, "Đang dùng kỹ năng không thể thao tác";
    end

    if pPlayerNpc.nShapeShiftNpcTID > 0 then
        return false, "Đang biến thân không thể thao tác";
    end

    if self:IsInteract(pPlayer) then
        return false, "Đang tương tác không thể thao tác";
    end
   
    if pPlayer.nFightMode ~= 0 and not bDreamMap then
       return false, "Đang chiến đấu không thể thao tác"
    end

    if pPlayer.nState ~= Player.emPLAYER_STATE_NORMAL then
        return false, "Đang trong trạng thái bất thường không thể thao tác";
    end

    if pPlayer.tbDecorationActStatePos then
        return false, "Trạng thái hiện tại không thể thao tác";
    end

    if pPlayerNpc.GetRefFlag(0) > 0 then
        return false, "Trạng thái hiện tại không thể thao tác";
    end
	
	if MODULE_GAMESERVER then
        if not Toy:IsFree(pPlayer) then
            return false, "Trạng thái hiện tại không thể thao tác"
        end
    end

    return true;
end

function ActionInteract:CheckLimitMap(nMapTID)
    if tbDef.tbLimitMap[nMapTID] or nMapTID == Kin.Def.nKinMapTemplateId or Map:IsHouseMap(nMapTID)  or nMapTID == DrinkHouse.tbDef.NORMAL_MAP  or nMapTID == LoverTask.nTaskDreamFubenMapTId then
        return true
    end
    return false;
end

function ActionInteract:GetPlayerFactionShape(pPlayer)
    local szShape = self:GetFactionShape(pPlayer.nFaction, pPlayer.nSex);
    if pPlayer.bWeddingDressOn and tbDef.tbWeddingShape[szShape] then
        szShape = tbDef.tbWeddingShape[szShape];
    end

    return szShape;
end

function ActionInteract:CheckDoActionInteract(pPlayer, nPassivityID, nInteractID)
    local pPassivityPlayer = KPlayer.GetPlayerObjById(nPassivityID);
    if not pPassivityPlayer then
        return false, "Ngươi chơi không online";
    end

    if pPassivityPlayer.nMapId ~= pPlayer.nMapId then
        return false, "Không ở chung bản đồ không thể tương tác";
    end

    if not self:CheckLimitMap(pPlayer.nMapTemplateId) then
        return false, "Bản đồ này không thể tương tác, hãy quay lại [FFFE0D]「Tương Dương」[-]";
    end

    local szShape = self:GetPlayerFactionShape(pPlayer);
    local szPassivityShape = self:GetPlayerFactionShape(pPassivityPlayer);
    local tbInteractInfo = self:GetInteractInfo(nInteractID, szShape, szPassivityShape);
    if not tbInteractInfo then
        return false, "Không có động tác tương tác";
    end
     local bDreamMap = LoverTask:IsDreamTaskMap(pPlayer)
    local bRet, szMsg = self:CheckPlayerState(pPlayer, bDreamMap);
    if not bRet then
        return false, string.format("「%s」%s", pPlayer.szName, szMsg);
    end

    bRet, szMsg = self:CheckPlayerState(pPassivityPlayer, bDreamMap);
    if not bRet then
        return false, string.format("「%s」%s", pPassivityPlayer.szName, szMsg);
    end
     if bDreamMap then
        local tbInst = Fuben:GetFubenInstance(pPlayer)
        if tbInst and tbInst.bForbidInteract then
            return false, "Hiện không hỗ trợ tương tác"
        end
    end
    local _, nX1, nY1 = pPlayer.GetWorldPos();
    local _, nX2, nY2 = pPassivityPlayer.GetWorldPos();
    if Lib:GetDistsSquare(nX1, nY1, nX2, nY2) > (tbDef.nInteractLen * tbDef.nInteractLen)  then
        return false, "Khoảng cách hai bên quá xa";
    end

    local funCheckCallBack = self[tbInteractInfo.szType.."CheckInteract"];
    if funCheckCallBack then
        bRet, szMsg = funCheckCallBack(self, pPlayer, pPassivityPlayer, tbInteractInfo);
        if not bRet then
            return false, szMsg;
        end
    end

    return true, "", pPassivityPlayer, tbInteractInfo;
end

function ActionInteract:RefuseActionInteract(nPlayerID, nPassivityID, nInteractID)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerID);
    if not pPlayer then
        return;
    end

    local pPassivityPlayer = KPlayer.GetPlayerObjById(nPassivityID);
    if not pPassivityPlayer then
        return;
    end

    local szShape = self:GetPlayerFactionShape(pPlayer);
    local szPassivityShape = self:GetPlayerFactionShape(pPassivityPlayer);
    local tbInteractInfo = self:GetInteractInfo(nInteractID, szShape, szPassivityShape);
    if not tbInteractInfo then
        return;
    end

    self:SendNearPlayerMsg(pPlayer, pPassivityPlayer, tbInteractInfo.szRefuseChat, true, true);
    --pPlayer.CenterMsg(string.format("「%s」拒绝请求！", pPassivityPlayer.szName), true);
end

function ActionInteract:DoActionInteract(nPlayerID, nPassivityID, nInteractID, bNeedAffirm)
    if nPlayerID == nPassivityID then
        return
    end
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerID);
    if not pPlayer then
        Log("ActionInteract DoActionInteract Not Player", nPlayerID, nPassivityID, nInteractID);
        return;
    end

    local bRet, szMsg, pPassivityPlayer, tbInteractInfo = self:CheckDoActionInteract(pPlayer, nPassivityID, nInteractID);
    if not bRet then
        pPlayer.CenterMsg(szMsg, true);
        return;
    end

    if bNeedAffirm then
        if tbInteractInfo.szType == "HorseRunSt" then
            if pPlayer.GetActionMode() == Npc.NpcActionModeType.act_mode_none then
                ActionMode:DoChangeActionMode(pPlayer, Npc.NpcActionModeType.act_mode_ride, true);
            end
        else
            ActionMode:DoForceNoneActMode(pPlayer);
        end

        self:SendNearPlayerMsg(pPlayer, pPassivityPlayer, tbInteractInfo.szSendChat);
        local szShape = self:GetPlayerFactionShape(pPlayer);
        local tbAllShow = self:GetInteractShowInfo(szShape);
        local szMsgBox = tbInteractInfo.szMsgBoxConent or "$M xin「$N」, đồng ý?";
        szMsgBox = string.gsub(szMsgBox, "$M", pPlayer.GetNpc().szName) or szMsgBox;
        szMsgBox = string.gsub(szMsgBox, "$N",  tbAllShow[nInteractID].szName) or szMsgBox;
        pPassivityPlayer.MsgBox(szMsgBox, {{"Chấp nhận", self.DoActionInteract, self, nPlayerID, nPassivityID, nInteractID}, {"Cự tuyệt", self.RefuseActionInteract, self, nPlayerID, nPassivityID, nInteractID}});
        return;
    end
    local funCallBack = self[tbInteractInfo.szType.."Interact"];
    if not funCallBack then
        return;
    end

    funCallBack(self, pPlayer, pPassivityPlayer, tbInteractInfo);
    self:SendNearPlayerMsg(pPlayer, pPassivityPlayer, tbInteractInfo.szAcceptChat, true);
    pPlayer.OnEvent("OnActionInteract", nInteractID);
    pPassivityPlayer.OnEvent("OnActionInteract", nInteractID);
    self:SyncPlayerUiInfo(pPlayer);
    self:SyncPlayerUiInfo(pPassivityPlayer);
    pPlayer.CallClientScript("AutoFight:StopFollowTeammate");
    pPassivityPlayer.CallClientScript("AutoFight:StopFollowTeammate");
    Log("ActionInteract DoActionInteract", nPlayerID, nPassivityID, nInteractID);
end

function ActionInteract:SyncPlayerUiInfo(pPlayer)
    if not pPlayer.tbPlayerInteract then
        return;
    end

    pPlayer.CallClientScript("Ui:OpenWindowListOverLap", "QYHLeavePanel", "ActInteract");
    pPlayer.CallClientScript("Map:SetCloseUiOnLeave", pPlayer.nMapId, "QYHLeavePanel");
    pPlayer.CallClientScript("Player:ServerSyncData", "HideTopButtonLeave",  pPlayer.nMapId);
end

function ActionInteract:SendNearPlayerMsg(pPlayer, pPassivityPlayer, szSendMsg, bPassivity, bMsg)
    if Lib:IsEmptyStr(szSendMsg) then
        return;
    end

    szSendMsg = string.gsub(szSendMsg, "$M", pPlayer.GetNpc().szName) or szSendMsg;
    szSendMsg = string.gsub(szSendMsg, "$P", pPassivityPlayer.GetNpc().szName) or szSendMsg;
    local pSend = pPlayer;
    if bPassivity then
        pSend = pPassivityPlayer;
    end

    if not bMsg then
        ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, pSend.dwID, pSend.GetNpc().szName, pSend.nFaction, pSend.nPortrait, pSend.nSex, pSend.nLevel, szSendMsg);
    else
        pPlayer.Msg(szSendMsg);
    end
end

function ActionInteract:ActRunStInteract(pPlayer, pPassivityPlayer, tbInteract)
    if pPlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoForceNoneActMode(pPlayer, false, true);
    end

    if pPassivityPlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoForceNoneActMode(pPassivityPlayer, false, true);
    end

    local tbPlayerInteract = {};
    tbPlayerInteract.nInteractID = tbInteract.nInteractID;
    tbPlayerInteract.tbPlayer = {};
    tbPlayerInteract.tbPlayer[pPlayer.dwID] = 1;
    tbPlayerInteract.tbPlayer[pPassivityPlayer.dwID] = 1;

    pPlayer.tbPlayerInteract = tbPlayerInteract;
    pPassivityPlayer.tbPlayerInteract = tbPlayerInteract;

    local tbMParam = tbInteract.tbMainParam;
    local pPlayerNpc = pPlayer.GetNpc();
    local nRunAct = Npc:ACTION_TYPE_ID(1, tbMParam["Run"] or 0);
    local nStAct = Npc:ACTION_TYPE_ID(1, tbMParam["St"] or 0);
    pPlayerNpc.InitLinkAttach(Npc.AttachType.npc_attach_npc_self, tbMParam["Speed"] or 0, nRunAct, nStAct);
    pPlayerNpc.SetLinkAttachEvent(tbMParam["RunEvent"] or 0, tbMParam["StEvent"] or 0);
    pPlayerNpc.SetLinkAttachParam(1, 0);
    pPlayerNpc.SetLinkAttachParam(2, tbMParam["X"] or 0);
    pPlayerNpc.SetLinkAttachParam(3, tbMParam["Y"] or 0);
    pPlayerNpc.SetLinkAttachParam(4, tbMParam["X1"] or 0);
    pPlayerNpc.SetLinkAttachParam(5, tbMParam["Y1"] or 0);
    pPlayerNpc.SetLinkAttachParam(6, tbMParam["Height"] or 0);
    pPlayerNpc.EndLinkAttach();
    self:CheckSetFeature(pPlayerNpc, tbMParam)

    local tbPParam = tbInteract.tbPassivityParam;
    local pPassivityNpc = pPassivityPlayer.GetNpc();
    nRunAct = Npc:ACTION_TYPE_ID(1, tbPParam["Run"] or 0);
    nStAct = Npc:ACTION_TYPE_ID(1, tbPParam["St"] or 0);
    pPassivityNpc.InitLinkAttach(Npc.AttachType.npc_attach_npc_pos, tbPParam["Speed"] or 0, nRunAct, nStAct);
    pPassivityNpc.SetLinkAttachEvent(tbPParam["RunEvent"] or 0, tbPParam["StEvent"] or 0);
    pPassivityNpc.SetLinkAttachParam(1, pPlayerNpc.nId);
    pPassivityNpc.SetLinkAttachParam(2, tbPParam["X"] or 0);
    pPassivityNpc.SetLinkAttachParam(3, tbPParam["Y"] or 0);
    pPassivityNpc.SetLinkAttachParam(4, tbPParam["X1"] or 0);
    pPassivityNpc.SetLinkAttachParam(5, tbPParam["Y1"] or 0);
    pPassivityNpc.SetLinkAttachParam(6, tbPParam["Height"] or 0);
    pPassivityNpc.EndLinkAttach();
    self:CheckSetFeature(pPassivityNpc, tbPParam)
    Log("ActionInteract ActRunStInteract", pPlayer.dwID, pPassivityPlayer.dwID);

    return true;
end

function ActionInteract:CheckSetFeature( pPlayerNpc, tbPParam  )
    local nHidePart = tbPParam["HidePart"]
    if not nHidePart then
        return
    end
    local nNpcResID, tbCurFeature = pPlayerNpc.GetFeature()
    local nOldVal = tbCurFeature[nHidePart]
    if not nOldVal or nOldVal == 0 then
        return
    end
    pPlayerNpc.bActionInteractHidePart = true
    for nPart=0,Npc.NpcResPartsDef.npc_res_part_count - 1 do
        local nResId = tbCurFeature[nPart]
        if nResId ~= 0 and nPart ~= nHidePart then
            pPlayerNpc.ChangeFeature(nNpcResID,nPart, nResId)
        end
    end
end

function ActionInteract:GetPlayerHorseEquip(pPlayer)
    local pHorseItem = pPlayer.GetEquipByPos(Item.EQUIPPOS_HORSE);
    local pWaiHorseItem = pPlayer.GetEquipByPos(Item.EQUIPPOS_WAI_HORSE);
    if pHorseItem and pWaiHorseItem then
        return pWaiHorseItem;
    end
    return pHorseItem;
end

function ActionInteract:HorseRunStCheckInteract(pPlayer, pPassivityPlayer, tbInteract)
    local pHorseItem = self:GetPlayerHorseEquip(pPlayer);
    if not pHorseItem then
        return false, "Chưa có thú cưỡi, không thể cùng cưỡi"
    end
    if self.tbHorseItemInfo[pHorseItem.dwTemplateId] then
        return false, "Thú cưỡi hiện tại không thể cùng cưỡi";
    end
    local bRet, szMsg = House:CheckCanRide(pPlayer);
    if not bRet then
        return false, szMsg;
    end

    return true, "";
end

function ActionInteract:HorseRunStInteract(pPlayer, pPassivityPlayer, tbInteract)
    if pPlayer.GetActionMode() == Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoChangeActionMode(pPlayer, Npc.NpcActionModeType.act_mode_ride, true);
    end

    if pPassivityPlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoForceNoneActMode(pPassivityPlayer, false, true);
    end

    local tbPlayerInteract = {};
    tbPlayerInteract.nInteractID = tbInteract.nInteractID;
    tbPlayerInteract.tbPlayer = {};
    tbPlayerInteract.tbPlayer[pPlayer.dwID] = 1;
    tbPlayerInteract.tbPlayer[pPassivityPlayer.dwID] = 1;

    pPlayer.tbPlayerInteract = tbPlayerInteract;
    pPassivityPlayer.tbPlayerInteract = tbPlayerInteract;

    local pPlayerNpc = pPlayer.GetNpc();
    local tbMParam = tbInteract.tbMainParam;
    local nRunAct = Npc:ACTION_TYPE_ID(1, tbMParam["Run"] or 0);
    local nStAct = Npc:ACTION_TYPE_ID(1, tbMParam["St"] or 0);
    pPlayerNpc.InitLinkAttach(Npc.AttachType.npc_attach_npc_self, tbMParam["Speed"] or 0, nRunAct, nStAct);
    pPlayerNpc.SetLinkAttachEvent(tbMParam["RunEvent"] or 0, tbMParam["StEvent"] or 0);
    pPlayerNpc.SetLinkAttachParam(1, tbMParam["HorseSlot"] or 0);
    pPlayerNpc.SetLinkAttachParam(2, tbMParam["HX"] or 0);
    pPlayerNpc.SetLinkAttachParam(3, tbMParam["HY"] or 0);
    pPlayerNpc.SetLinkAttachParam(6, tbMParam["Height"] or 0);
    pPlayerNpc.EndLinkAttach();
    self:CheckSetFeature(pPlayerNpc, tbMParam)

    local tbPParam = tbInteract.tbPassivityParam;
    local pPassivityNpc = pPassivityPlayer.GetNpc();
    nRunAct = Npc:ACTION_TYPE_ID(1, tbPParam["Run"] or 0);
    nStAct = Npc:ACTION_TYPE_ID(1, tbPParam["St"] or 0);
    pPassivityNpc.InitLinkAttach(Npc.AttachType.npc_attach_npc_horse, tbPParam["Speed"] or 0, nRunAct, nStAct);
    pPassivityNpc.SetLinkAttachEvent(tbPParam["RunEvent"] or 0, tbPParam["StEvent"] or 0);
    pPassivityNpc.SetLinkAttachParam(1, pPlayerNpc.nId);
    pPassivityNpc.SetLinkAttachParam(2, tbPParam["HorseSlot"] or 0);
    pPassivityNpc.SetLinkAttachParam(3, tbPParam["HX"] or 0);
    pPassivityNpc.SetLinkAttachParam(4, tbPParam["HY"] or 0);
    pPassivityNpc.SetLinkAttachParam(5, tbPParam["Height"] or 0);
    pPassivityNpc.EndLinkAttach();
    self:CheckSetFeature(pPassivityNpc, tbPParam)

    Log("ActionInteract HorseRunStInteract", pPlayer.dwID, pPassivityPlayer.dwID);

    return true;
end

function ActionInteract:CommonActCheckInteract(pPlayer, pPassivityPlayer, tbInteract)
    local nBothLen = tbInteract.tbMainParam["Len"] or 0;
    if nBothLen <= 0 then
        return true, "";
    end

    local pPlayerNpc = pPlayer.GetNpc();
    local _, nX, nY = pPlayerNpc.GetWorldPos();
    local nDir = pPlayerNpc.GetDir();
    local nTargetX = nX + math.floor(g_DirCos(nDir) * nBothLen / 1024);
    local nTargetY = nY + math.floor(g_DirSin(nDir) * nBothLen / 1024);
    local nRet, nTestBarrier, nMoveLen, nMoveX, nMoveY = pPlayerNpc.TestMovePos(nTargetX, nTargetY, nBothLen);
    if nRet == 0 or nTestBarrier ~= 0 then
        return false, "Vị trí hiện tại không đủ";
    end

    local tbTarget = {nTargetX, nTargetY};
    return true, "", tbTarget;
end

function ActionInteract:CommonActInteract(pPlayer, pPassivityPlayer, tbInteract)
    local bRet, szMsg, tbTarget = self:CommonActCheckInteract(pPlayer, pPassivityPlayer, tbInteract);
    if not bRet then
        return;
    end

    if pPlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoForceNoneActMode(pPlayer, false, true);
    end

    if pPassivityPlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoForceNoneActMode(pPassivityPlayer, false, true);
    end

    local tbPlayerInteract = {};
    tbPlayerInteract.nInteractID = tbInteract.nInteractID;
    tbPlayerInteract.tbPlayer = {};
    tbPlayerInteract.tbPlayer[pPlayer.dwID] = 1;
    tbPlayerInteract.tbPlayer[pPassivityPlayer.dwID] = 1;

    pPlayer.tbPlayerInteract = tbPlayerInteract;
    pPassivityPlayer.tbPlayerInteract = tbPlayerInteract;

    local tbMParam = tbInteract.tbMainParam;
    local pPlayerNpc = pPlayer.GetNpc();
    local nDir = pPlayerNpc.GetDir();
    local _, nX, nY = pPlayerNpc.GetWorldPos();
    pPlayerNpc.SetDir(nDir);
    pPlayerNpc.DoCommonAct(tbMParam["Act"] or 0, tbMParam["ActEvent"] or 0, tbMParam["ActLoop"] or 0, 0, 1);
    pPlayerNpc.InitLinkAttach(Npc.AttachType.npc_attach_npc_self, 0, 0, 0);
    pPlayerNpc.SetLinkAttachEvent(0, 0);
    pPlayerNpc.SetLinkAttachParam(1, 0);
    pPlayerNpc.SetLinkAttachParam(2, tbMParam["X"] or 0);
    pPlayerNpc.SetLinkAttachParam(3, tbMParam["Y"] or 0);
    pPlayerNpc.SetLinkAttachParam(6, tbMParam["Height"] or 0);
    pPlayerNpc.EndLinkAttach();
    self:CheckSetFeature(pPlayerNpc, tbMParam)

    local tbPParam = tbInteract.tbPassivityParam;
    local pPassivityNpc = pPassivityPlayer.GetNpc();
    if tbTarget then
        pPassivityNpc.SetPosition(tbTarget[1], tbTarget[2]);
        local nPDir = g_GetDirIndex(nX - tbTarget[1], nY - tbTarget[2]);
        if nPDir <= -1 then
            nPDir = nDir;
        end
        pPassivityNpc.SetDir(nPDir);
    end
    pPassivityNpc.DoCommonAct(tbPParam["Act"] or 0, tbPParam["ActEvent"] or 0, tbPParam["ActLoop"] or 0, 0, 1);
    pPassivityNpc.InitLinkAttach(Npc.AttachType.npc_attach_npc_self, 0, 0, 0);
    pPassivityNpc.SetLinkAttachEvent(0, 0);
    pPassivityNpc.SetLinkAttachParam(1, 0);
    pPassivityNpc.SetLinkAttachParam(2, tbPParam["X"] or 0);
    pPassivityNpc.SetLinkAttachParam(3, tbPParam["Y"] or 0);
    pPassivityNpc.SetLinkAttachParam(6, tbPParam["Height"] or 0);
    pPassivityNpc.EndLinkAttach();
    self:CheckSetFeature(pPassivityNpc, tbPParam)

    Log("ActionInteract CommonActInteract", pPlayer.dwID, pPassivityPlayer.dwID);
    return true;
end

function ActionInteract:UnbindLinkInteract(pPlayer)
    if not pPlayer.tbPlayerInteract then
        return;
    end

    local tbAllPlayer = pPlayer.tbPlayerInteract.tbPlayer;
    if not tbAllPlayer then
        return;
    end

    for nPlayerID, _ in pairs(tbAllPlayer) do
        local pPlayer = KPlayer.GetPlayerObjById(nPlayerID);
        if pPlayer then
            self:ForceUnbindPlayerLink(pPlayer);
        end
    end
end

function ActionInteract:ForceUnbindPlayerLink(pPlayer)
    if not pPlayer.tbPlayerInteract then
        return;
    end

    pPlayer.tbPlayerInteract = nil;

    local pPlayerNpc = pPlayer.GetNpc();
    local tbAttachParam = pPlayerNpc.GetNpcAttachParam();
    if tbAttachParam.nType ~= Npc.AttachType.npc_attach_type_none then
        pPlayerNpc.InitLinkAttach(Npc.AttachType.npc_attach_type_none, 0, 0, 0);
        pPlayerNpc.SetLinkAttachEvent(0, 0);
        pPlayerNpc.EndLinkAttach();
    end

    if pPlayer.GetActionMode() ~= Npc.NpcActionModeType.act_mode_none then
        ActionMode:DoForceNoneActMode(pPlayer);
    end
    pPlayerNpc.RestoreAction();
    if pPlayerNpc.bActionInteractHidePart then
        pPlayerNpc.bActionInteractHidePart = nil;
        pPlayerNpc.RestoreFeature()
    end
    
    pPlayer.CallClientScript("Ui:CloseWindow", "QYHLeavePanel");
    pPlayer.CallClientScript("Player:ServerSyncData", "HideTopButtonLeave", 0);
    pPlayer.CallClientScript("ActionInteract:OnResetLinkAttach");
    pPlayer.OnEvent("OnCancelActionInteract");
    Log("ActionInteract ForceUnbindPlayerLink", pPlayer.dwID);
end

function ActionInteract:OnResetLinkAttach()
    if self.nResetLinkAttachTimer then
        Timer:Close(self.nResetLinkAttachTimer);
        self.nResetLinkAttachTimer = nil;
    end

    self.nResetLinkAttachCount = 30;
    self.nResetLinkAttachTimer = Timer:Register(5, function()
        self.nResetLinkAttachCount = self.nResetLinkAttachCount or 10;
        self.nResetLinkAttachCount = self.nResetLinkAttachCount - 1;
        if not Loading:IsLoadMapFinish() and self.nResetLinkAttachCount > 0 then
            return true;
        end

        self.nResetLinkAttachTimer = nil;
        if IsAlone() ~= 1 then
            return;
        end

        local pPlayerNpc = me.GetNpc();
        if not pPlayerNpc then
            return;
        end
        
        local tbAttachParam = pPlayerNpc.GetNpcAttachParam();
        if tbAttachParam.nType ~= Npc.AttachType.npc_attach_type_none then
            pPlayerNpc.InitLinkAttach(Npc.AttachType.npc_attach_type_none, 0, 0, 0);
            pPlayerNpc.SetLinkAttachEvent(0, 0);
            pPlayerNpc.EndLinkAttach();
        end
        Log("ActionInteract OnResetLinkAttach");
    end)
end

function ActionInteract:IsInteract(pPlayer)
    if not pPlayer.tbPlayerInteract then
        return false;
    end

    return true;
end

function ActionInteract:OnLogout()
    self:UnbindLinkInteract(me);
end

function ActionInteract:OnLeaveMap()
    self:UnbindLinkInteract(me);
end

function ActionInteract:OnReConnect()
    self:SyncPlayerUiInfo(me);
end

function ActionInteract:EnterClientMap()
    self:UnbindLinkInteract(me);
end

function ActionInteract:OnTransferZone()
    self:UnbindLinkInteract(me);
end

function ActionInteract:OnLogin()
    self:SyncPlayerUiInfo(me);
end

function ActionInteract:OnChangeFightMode()
    if me.nFightMode ~= 0 then
        self:UnbindLinkInteract(me);
    end 
end

function ActionInteract:OnChangePlayerState()
    if me.nState ~= Player.emPLAYER_STATE_NORMAL and me.nState ~= Player.emPLAYER_STATE_OFFLINE then
        self:UnbindLinkInteract(me);
    end
end

if MODULE_GAMESERVER then
PlayerEvent:RegisterGlobal("OnLogout",  ActionInteract.OnLogout, ActionInteract);
PlayerEvent:RegisterGlobal("OnReConnect", ActionInteract.OnReConnect, ActionInteract);
PlayerEvent:RegisterGlobal("OnLeaveMap", ActionInteract.OnLeaveMap, ActionInteract);
PlayerEvent:RegisterGlobal("EnterClientMap", ActionInteract.EnterClientMap, ActionInteract);
PlayerEvent:RegisterGlobal("OnTransferZone", ActionInteract.OnTransferZone, ActionInteract);
PlayerEvent:RegisterGlobal("OnLogin", ActionInteract.OnLogin, ActionInteract);
PlayerEvent:RegisterGlobal("OnChangeFightMode", ActionInteract.OnChangeFightMode, ActionInteract);
PlayerEvent:RegisterGlobal("OnChangePlayerState", ActionInteract.OnChangePlayerState, ActionInteract);
end

