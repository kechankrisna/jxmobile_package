local tbNpc = Npc:GetClass("ToyWineNpc")

function tbNpc:OnDialog()
	if not Toy:IsFree(me) then
		me.CenterMsg("Trạng thái hiện tại không thể thao tác")
		return
	end
	local szParam = string.gsub(him.szScriptParam, "\"", "")
	local tbRet = Lib:SplitStr(szParam, ",")
	local nTime = tonumber(tbRet[1]) or 1
	local szMsg = tbRet[2] or "Đang dùng..."
	GeneralProcess:StartProcessUniq(me, nTime * Env.GAME_FPS, him.nId, szMsg, self.EndProcess, self, me.dwID, him.nId)
end

function tbNpc:EndProcess(nPlayerId, nNpcId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return
	end

	local pNpc = KNpc.GetById(nNpcId);
	if not pNpc then
		return
	end
	Toy:OnTakeWineNpc(pPlayer)
end

