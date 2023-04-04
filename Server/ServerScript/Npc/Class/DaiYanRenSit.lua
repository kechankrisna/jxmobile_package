local tbNpc = Npc:GetClass("DaiYanRenSit");

function tbNpc:OnDialog()
	local tbOptList = {
		{Text = "Ngắm hoa uống rượu", Callback = self.TrySit, Param = {self, him.nId, me.dwID}}
	}
	 Dialog:Show(
    {
        Text    = "Một gốc nở đầy màu hồng hoa lá cây, tản mát ra lãng mạn khí tức, làm lòng người say",
        OptList = tbOptList,
    }, me, him)
end

function tbNpc:TrySit(nNpcID, dwID)
	local pNpc = KNpc.GetById(nNpcID);
    if not pNpc then
        Log("DaiYanRenSit Not Npc", nNpcID, dwID)
        return
    end

    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
    	return
    end

    local tbInst = Fuben.tbFubenInstance[pNpc.nMapId]
    if not tbInst then
        Log("DaiYanRenSit Not tbInst", nNpcID, dwID, pNpc.nMapId)
        return
    end
    tbInst:TryBeginDazuo(dwID)
end