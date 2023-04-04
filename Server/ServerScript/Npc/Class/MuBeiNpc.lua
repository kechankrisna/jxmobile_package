local tbNpc = Npc:GetClass("MuBeiNpc");

function tbNpc:OnDialog()
	local tbOptList = {
		{Text = "Xem xét bia đá", Callback = self.TryWorship, Param = {self, him.nId, me.dwID}}
	}
	 Dialog:Show(
    {
        Text    = "Một khối thoạt nhìn dãi dầu sương gió cổ phác bia đá, phía trên văn tự đã có chút mơ hồ, nhưng lại vẫn đứng vững không ngã",
        OptList = tbOptList,
    }, me, him);
end

function tbNpc:TryWorship(nNpcID, dwID)
	local pNpc = KNpc.GetById(nNpcID);
    if not pNpc then
        Log("MuBeiNpc Not Npc", nNpcID, dwID);
        return;
    end

    local pPlayer = KPlayer.GetPlayerObjById(dwID)
    if not pPlayer then
    	return
    end

    local tbInst = Fuben.tbFubenInstance[pNpc.nMapId];
    if tbInst then
    	if tbInst.bStart then
    		pPlayer.CenterMsg("Đã tra xét bia đá")
    		return 
    	end
    	if tbInst.nUsePlayerId ~= dwID then
    		pPlayer.CenterMsg("Cần có được địa đồ tiến vào nơi đây người mới có thể xem xét a")
    		return 
    	end
        tbInst:StartWorship(dwID)
    else
        Log("MuBeiNpc Not tbInst", nNpcID, dwID, pNpc.nMapId);
    end
end