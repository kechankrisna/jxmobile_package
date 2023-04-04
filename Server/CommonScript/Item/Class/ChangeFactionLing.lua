
Require("CommonScript/ChangeFaction/ChangeFactionDef.lua");
local tbDef = ChangeFaction.tbDef;
local tbItem = Item:GetClass("ChangeFactionLing");

function tbItem:OnUse(it)
    local nLastTime = me.GetUserValue(tbDef.nSaveGroup, tbDef.nSaveUseCD);
    local nRetTime = nLastTime - GetTime();
    if nRetTime > 0 then
        me.CenterMsg(string.format("%s sau được dùng", Lib:TimeDesc2(nRetTime)), true);
        return;
    end    

    me.MsgBox("Đại Hiệp muốn đến Tẩy Tủy Đảo?\nVào đảo cho dù [FF0000]không chuyển môn phái[-] cũng sẽ [FF0000]tốn 1 Thiên Kiếm Lệnh[-]", {{"Đến", self.Affirm, self, me.dwID}, {"Hủy"}})
end

function tbItem:Affirm(nPlayerID)
    local pPlayer = KPlayer.GetPlayerObjById(nPlayerID);
    if not pPlayer then
        Log("ERROR ChangeFactionLing Not Player");
        return;
    end

    ChangeFaction:ApplyEnterMap(pPlayer);
end

