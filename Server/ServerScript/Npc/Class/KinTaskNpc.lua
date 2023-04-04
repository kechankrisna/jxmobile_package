local tbNpc = Npc:GetClass("KinTaskNpc");

function tbNpc:OnCreate(szParam)
	him.nTargetNpcId = tonumber(szParam);
	local nMapId, nX, nY = him.GetWorldPos();
	him.nCurMapId = nMapId;
	him.nCurX = nX;
	him.nCurY = nY;
end

function tbNpc:OnDialog()
	local tbPlayerCurTask = Task:GetPlayerCurTask(me);
	local tbTarget = nil;
	for nTaskId in pairs(tbPlayerCurTask or {}) do
		if Task.KinTask.tbTask2Type[nTaskId] then
			local tbTask = Task:GetTask(nTaskId);
			tbTarget = ((tbTask or {}).tbTargetInfo or {})["KillNpc"];
			break;
		end
	end

	local tbDlg = {};
	if tbTarget and tbTarget[him.nTargetNpcId] then
		table.insert(tbDlg, { Text = "Xin chỉ giáo!", Callback = self.CallNpc, Param = {self, me.dwID, him.nId} });
	end

	table.insert(tbDlg, { Text = "Ta chỉ là đi ngang qua."});

	Dialog:Show(
	{
		Text    = "A Di Đà Phật, thí chủ đi lại nhẹ nhàng, chắc hẳn thân thủ bất phàm, không biết nhưng nguyện cùng tiểu tăng so tay một chút?",
		OptList = tbDlg,
	}, me, him);
end

function tbNpc:CallNpc(nPlayerId, nNpcId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if not pPlayer then
		return;
	end

	local pNpc = KNpc.GetById(nNpcId);
	local nMapId, nX, nY = pNpc.GetWorldPos();
	if not pNpc then
		return;
	end

	local pNewNpc = KNpc.Add(pNpc.nTargetNpcId, pPlayer.nLevel, 0, nMapId, nX, nY, 0);
	pNewNpc.nCurNpctemplateId = pNpc.nTemplateId;
	pNewNpc.nCurMapId = pNpc.nCurMapId;
	pNewNpc.nCurX = pNpc.nCurX;
	pNewNpc.nCurY = pNpc.nCurY;
	pNpc.Delete();
end