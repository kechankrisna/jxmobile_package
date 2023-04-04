
local tbNpc = Npc:GetClass("ChangeFactionDialog");
Require("CommonScript/ChangeFaction/ChangeFactionDef.lua");

local tbDef = ChangeFaction.tbDef;

function tbNpc:OnDialog()
    Dialog:Show(
    {
        Text    = "Nơi này là tẩy tủy đảo, ngươi có thể ở đây tùy ý hoán đổi từng cái môn phái, cùng thiết lập lại điểm kỹ năng ",
        OptList = {
            { Text = "Chuyển Phái", Callback = self.SelectAllFaction, Param = {self, him.nId} },
            { Text = "Ta chọn rồi, muốn rời khỏi", Callback = self.LeaveMap, Param = {self, him.nId} },
        };
    }, me, him);
end

function tbNpc:LeaveMap(nNpcID)
    local pNpc = KNpc.GetById(nNpcID);
    if not pNpc then
        Log("ChangeFactionDialog SelectAllFaction Not Npc");
        return;
    end

    local tbPlayerInfo = ChangeFaction:GetPlayerInfo(me.dwID);
    local nOrgFaction = me.nFaction;
    local nSaveFaction = me.GetUserValue(tbDef.nSaveGroup, tbDef.nSaveEnterFaction);
    if nSaveFaction > 0 then
        nOrgFaction = nSaveFaction;
    elseif tbPlayerInfo then
        nOrgFaction = tbPlayerInfo.nOrgFaction;
    end

    local nOrgSex = me.nSex;
    local nSaveSex = me.GetUserValue(tbDef.nSaveGroup, tbDef.nSaveEnterSex);
    if nSaveSex > 0 then
        nOrgSex = nSaveSex;
    elseif tbPlayerInfo then
        nOrgSex = tbPlayerInfo.nOrgSex;
    end

    local szMsg = "";
    if nOrgFaction == me.nFaction and nOrgSex == me.nSex then
        szMsg = "Phái ngươi đang chọn giống phái lúc ban đầu. Ngươi có chắc chắn muốn [FF0000]tiêu hao số lần dổi phái[-]mà [FF0000]không đổi phái hoặc giới tính[-] chứ?";
    else
        local szFaction = Faction:GetName(me.nFaction);
        szMsg = string.format("Ngươi lựa chọn [FFFE0D]%s[-] làm môn phái mới. Ngươi xác định lựa chọn như vậy? Xác nhận rời khỏi tẩy tủy đảo, sẽ không thể thay đổi", szFaction);
    end

    me.MsgBox(szMsg, {{"Xác nhận", self.ConfirmLeaveMap, self, me.dwID}, {"Hủy"}});  
end

function tbNpc:ConfirmLeaveMap(nPlayerID)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerID);
    if not pPlayer then
        return;
    end

    pPlayer.GotoEntryPoint();
    Log("ChangeFaction ConfirmLeaveMap", nPlayerID);
end

function tbNpc:SelectAllFaction(nNpcID)
    local pNpc = KNpc.GetById(nNpcID);
    if not pNpc then
        Log("ChangeFactionDialog SelectAllFaction Not Npc");
        return;
    end

    -- local tbAllFaction = {};
    -- for nFaction, tbInfo in pairs(Faction.tbFactionInfo) do
    --     tbAllFaction[nFaction] = 1;
    -- end

    me.CallClientScript("Ui:OpenWindow", "ChangeFactionPanel")
end

function tbNpc:AcceptChangeFaction(nNpcID, nChangeFaction)
    local pNpc = KNpc.GetById(nNpcID);
    if not pNpc then
        Log("PunishTask Accept Not Npc");
        return;
    end

    --ChangeFaction:PlayerChangeFaction(me, nChangeFaction);
end