local tbNpc = Npc:GetClass("IndifferChangeFaction")

function tbNpc:OnCreate()
	local nChangeToFactionId = MathRandom(1, Faction.MAX_FACTION_COUNT)
	him.nChangeToFactionId = nChangeToFactionId
	him.SetName( string.format("Phái %s", Faction:GetName(nChangeToFactionId)) )
end

function tbNpc:OnDialog()
	local nTime = tonumber(him.szScriptParam)
	if (nTime <= 0) then
		Log(debug.traceback())
		return
	end
	if me.nFightMode == 2 then
		me.CenterMsg("Ngài đã bỏ mình, không cách nào tiến hành thao tác")
		return
	end
	if not him.nChangeToFactionId then
		me.CenterMsg("Vô hiệu npc")
		return
	end
	if me.nFaction == him.nChangeToFactionId then
		me.CenterMsg("Môn phái giống nhau")
		return
	end
	me.DoChangeActionMode(Npc.NpcActionModeType.act_mode_none);
	me.AddSkillState(2783, 1, 0, 1)
	
	GeneralProcess:StartProcess(me, nTime * Env.GAME_FPS, "Đang mở...", self.EndProcess, self, me.dwID, him.nId);
end

function tbNpc:EndProcess(nPlayerId, nNpcId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if not pPlayer then
		return
	end
	local pNpc = KNpc.GetById(nNpcId);
	if not pNpc then
		pPlayer.CenterMsg("Rương kho báu đã biến mất")
		return;
	end

	local nChangeToFactionId = pNpc.nChangeToFactionId
	if not nChangeToFactionId then
		return
	end
	
	local tbInst = InDifferBattle.tbMapInst[pPlayer.nMapId]
	if not tbInst then
		return
	end

	local bRet = tbInst:ChangePlayerFactionFight(pPlayer, nChangeToFactionId)
	if not bRet then
		return
	end
	tbInst:DeleteNpc(nNpcId)
end
