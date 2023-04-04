
local tbItem = Item:GetClass("NpcLoveToken");
tbItem.tbHouseLoveNpcInfo = tbItem.tbHouseLoveNpcInfo or {};

function tbItem:OnUse(it)
	if not House:IsInOwnHouse(me) then
		me.CenterMsg("Đạo cụ này chỉ được dùng trong Gia Viên của mình! Hãy quay lại Gia Viên để thử!");
		return;
	end

	local nNpcTemplateId = KItem.GetItemExtParam(it.dwTemplateId, 1);
	local szNpcName = KNpc.GetNameByTemplateId(nNpcTemplateId);
	if not szNpcName then
		me.CenterMsg("Đạo cụ vô hiệu!");
		return;
	end

	local nTimeOut = it.GetTimeOut();
	assert(nTimeOut > GetTime());

	local nMapId, nX, nY = me.GetWorldPos();
	local tbSaveInfo = self:GetSaveData(me.dwID) or {};
	tbSaveInfo[it.dwTemplateId] = {nNpcTemplateId, nX, nY, nTimeOut};
	self:SaveData(me.dwID, tbSaveInfo);

	local pNpc = self:AddNpc(me.dwID, it.dwTemplateId, nNpcTemplateId, nMapId, nX, nY, nTimeOut);
	if not pNpc then
		return;
	end

	Log("[NpcLoveToken] add npc: ", me.dwID, it.dwTemplateId, nNpcTemplateId, pNpc.nId);
end

function tbItem:AddNpc(nPlayerId, nItemTemplateId, nNpcTemplateId, nMapId, nX, nY, nTimeOut)
	tbItem.tbHouseLoveNpcInfo[nPlayerId] = tbItem.tbHouseLoveNpcInfo[nPlayerId] or {};
	if tbItem.tbHouseLoveNpcInfo[nPlayerId][nItemTemplateId] then
		local tbInfo = tbItem.tbHouseLoveNpcInfo[nPlayerId][nItemTemplateId];
		local pOldNpc = KNpc.GetById(tbInfo.nNpcId);
		if pOldNpc then
			pOldNpc.Delete();
		end
		Timer:Close(tbInfo.nTimerId);
	end

	local nStayTime = math.max(nTimeOut - GetTime(), 1);
	local pNpc = KNpc.Add(nNpcTemplateId, 10, -1, nMapId, nX, nY, false, 0);
	local nNpcId = pNpc.nId;
	local nTimerId = Timer:Register(nStayTime * Env.GAME_FPS, self.OnNpcTimeOut, self, nPlayerId, nItemTemplateId, nNpcId);
	tbItem.tbHouseLoveNpcInfo[nPlayerId][nItemTemplateId] = { nNpcId = nNpcId, nTimerId = nTimerId };

	return pNpc;
end

function tbItem:OnClientUse()
	Ui:CloseWindow("ItemBox");
	Ui:CloseWindow("ItemTips");
	if not House.bHasHouse then
		me.MsgBox("Hiện không có gia viên, không thể dùng đạo cụ này, hãy đến chỗ [FFFE0D]Triệu Ân Đồng[-] để tìm hiểu thông tin Gia Viên nhé.",
			{
				{"Tìm Triệu Ân Đồng", function () Ui.HyperTextHandle:Handle("[url=npc:testtt, 2279, 10]", 0, 0); end},
				{"Tạm không đi"}
			});
		return 1;
	end

	if not House:IsInOwnHouse(me) then
		me.MsgBox("Đạo cụ này chỉ được dùng cho Gia Viên của mình! Muốn quay lại Gia Viên?",
			{
				{"Quay lại Gia Viên", function () RemoteServer.GoMyHome(); end},
				{"Tạm không đi"}
			});
		return 1;
	end

	return 0;
end

function tbItem:GetSaveData(nPlayerId)
	local tbAllData = ScriptData:GetValue("NpcLoveToken");
	local tbPlayerData = nil;
	if tbAllData[nPlayerId] then
		tbPlayerData = Lib:CopyTB(tbAllData[nPlayerId]);
	end
	return tbPlayerData;
end

function tbItem:SaveData(nPlayerId, tbData)
	local tbAllData = ScriptData:GetValue("NpcLoveToken");
	tbAllData[nPlayerId] = tbData;
	ScriptData:AddModifyFlag("NpcLoveToken");
end

function tbItem:OnCreateHouseMap(nPlayerId, nMapId)
	local tbSaveInfo = self:GetSaveData(nPlayerId);
	if not tbSaveInfo or Lib:CountTB(tbSaveInfo) < 1 then
		return;
	end

	local nTimeNow = GetTime();

	local tbToRemove = nil;
	for nTemplateId, tbInfo in pairs(tbSaveInfo) do
		if nTimeNow < (tbInfo[4] or 0) then
			self:AddNpc(nPlayerId, nTemplateId, tbInfo[1], nMapId, tbInfo[2], tbInfo[3], tbInfo[4]);
		else
			tbToRemove = tbToRemove or {};
			tbToRemove[nTemplateId] = true;
		end
	end

	if tbToRemove then
		for nItemTemplateId in pairs(tbToRemove) do
			tbSaveInfo[nItemTemplateId] = nil;
		end
	end

	if Lib:CountTB(tbSaveInfo) < 1 then
		tbSaveInfo = nil;
	end

	if tbToRemove then
		self:SaveData(nPlayerId, tbSaveInfo);
	end
end

function tbItem:OnNpcTimeOut(nPlayerId, nItemTemplateId, nNpcId)
	local pNpc = KNpc.GetById(nNpcId);
	if pNpc then
		pNpc.Delete();
	end

	tbItem.tbHouseLoveNpcInfo[nPlayerId] = tbItem.tbHouseLoveNpcInfo[nPlayerId] or {};
	local tbInfo = tbItem.tbHouseLoveNpcInfo[nPlayerId][nItemTemplateId];
	if not tbInfo or tbInfo.nNpcId ~= nNpcId then
		Log("[ERROR][NpcLoveToken] unknown time out: ", nPlayerId, nItemTemplateId, nNpcId, tbInfo.nNpcId);
		return;
	end

	tbItem.tbHouseLoveNpcInfo[nPlayerId][nItemTemplateId] = nil;

	local tbSaveInfo = self:GetSaveData(nPlayerId) or {};
	tbSaveInfo[nItemTemplateId] = nil;

	if Lib:CountTB(tbSaveInfo) < 1 then
		tbSaveInfo = nil;
	end

	self:SaveData(nPlayerId, tbSaveInfo);

	Log("[NpcLoveToken] npc time out: ", nPlayerId, nItemTemplateId, nNpcId);
end

function tbItem:OnDestroyHouseMap(nPlayerId, nMapId)
	for _, tbInfo in pairs(tbItem.tbHouseLoveNpcInfo[nPlayerId] or {}) do
		Timer:Close(tbInfo.nTimerId);
	end
	tbItem.tbHouseLoveNpcInfo[nPlayerId] = nil;
end
