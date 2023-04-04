local tbNpc = Npc:GetClass("IndiffeGatherItem")

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
	local tbInst = InDifferBattle.tbMapInst[me.nMapId]
	if not tbInst then
		return
	end
	if not tbInst:CheckGatherItem(me) then
		return
	end
	me.AddSkillState(2783, 1, 0, 1)
	me.DoChangeActionMode(Npc.NpcActionModeType.act_mode_none);
	
	GeneralProcess:StartProcess(me, nTime * Env.GAME_FPS, "Đang mở...", self.EndProcess, self, me.dwID, him.nId);
end

function tbNpc:EndProcess(nPlayerId, nNpcId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if not pPlayer then
		return
	end
	local pNpc = KNpc.GetById(nNpcId);
	if not pNpc then
		pPlayer.CenterMsg("Thu thập đã biến mất")
		return;
	end
	
	local tbInst = InDifferBattle.tbMapInst[pPlayer.nMapId]
	if not tbInst then
		return
	end

	--因为是要替换的，如果单npc则全部一样的随机概率了
	local bRet = tbInst:GatherItem(pPlayer, pNpc.nTemplateId)
	if not bRet then
		return
	end
	pPlayer.CenterMsg(string.format("Ngươi thu được 「%s」！", pNpc.szName), true)
	tbInst:DeleteNpc(nNpcId)
end


