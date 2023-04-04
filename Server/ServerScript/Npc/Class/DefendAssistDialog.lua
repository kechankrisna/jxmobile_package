local tbNpc = Npc:GetClass("DefendAssistDialog");

function tbNpc:OnDialog()
    
    Dialog:Show(
    {
        Text    = "Phải chăng cần ta đến hiệp trợ ngươi đối kháng địch nhân?",
        OptList = {
            { Text = "Xin hãy giúp tôi!", Callback = self.Active, Param = {self, him.nId,me.dwID} },
            { Text = "Tạm thời không cần"},
        };
    }, me, him);
end

function tbNpc:Active(nNpcID,dwID)
    local pNpc = KNpc.GetById(nNpcID);
    if not pNpc then
        Log("DefendAssist Accept Not Npc",nNpcID,dwID);
        return;
    end
    local tbInst = Fuben.tbFubenInstance[pNpc.nMapId];
    if tbInst then
        tbInst:ActiveNpc(nNpcID,dwID)
    else
        Log("DefendAssist Accept Not tbInst",nNpcID,dwID,pNpc.nMapId);
    end
end