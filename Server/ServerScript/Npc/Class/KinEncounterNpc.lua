local tbNpc = Npc:GetClass("KinEncounterNpc")

function tbNpc:OnCreate(szParam)
	for _, nPercent in ipairs(KinEncounter.Def.tbNpcHpNotify) do
		Npc:RegisterNpcHpPercent(him, nPercent, function(nTriggerPercent, nCurPercent)
			self:DoHpEvent(him, nTriggerPercent)
		end)
	end
end

function tbNpc:OnDeath(pKiller)
	if not him.tbCfgTypes then
		Log("[x] KinEncounterNpc:OnDeath, no tbCfgTypes")
		return
	end

	local tbLogic = KinEncounter:GetFightMapLogic(him.nMapId)
	if not tbLogic then
		return
	end
	tbLogic:OnNpcDeath(pKiller, unpack(him.tbCfgTypes))
end

function tbNpc:DoHpEvent(pNpc, nPercent)
	if not pNpc.tbCfgTypes then
		Log("[x] KinEncounterNpc:DoHpEvent, no tbCfgTypes")
		return
	end

	if not pNpc.nOwner or pNpc.nOwner <= 0 then
		return
	end

	local tbLogic = KinEncounter:GetFightMapLogic(pNpc.nMapId)
	if not tbLogic then
		return
	end

	local tbCfg = KinEncounter:GetResNpcCfg(unpack(pNpc.tbCfgTypes))
	local szMsg = string.format("我方%s血量僅剩%d%%，請速速支援！", tbCfg.name or "?", nPercent)
	tbLogic:SendBlackBoardMsgToIdx(pNpc.nOwner, szMsg)
end