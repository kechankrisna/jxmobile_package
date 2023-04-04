local tbNpc = Npc:GetClass("KinEncounterChange")

function tbNpc:OnDialog(szParam)
	local tbLogic = KinEncounter:GetFightMapLogic(me.nMapId)
	if not tbLogic then
		return
	end

	if tbLogic:GetIdx(me.dwID) ~= him.nOwner then
		return
	end

	local _,_ ,szText, nChangeSkillId, nDuraTime= string.find(szParam, "(.*)|(%d+)|(%d+)")
	nChangeSkillId = tonumber(nChangeSkillId)
	nDuraTime = tonumber(nDuraTime)
	Dialog:Show(
	{
		Text = him.szDefaultDialogInfo or "",
		OptList =
		{
			{
				Text = "變身" .. szText, Callback = self.Transform,
				Param = {self, me, him.nId, nChangeSkillId, szText, nDuraTime},
			},
		},
	}, me)

end

function tbNpc:Transform(pPlayer, nNpcId, nChangeSkillId, szText, nDuraSeconds)
	if pPlayer.GetNpc().nShapeShiftNpcTID ~= 0 then
		pPlayer.CenterMsg("您目前已經變身")
		return
	end

	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc then
		return
	end

	local tbLogic = KinEncounter:GetFightMapLogic(pPlayer.nMapId)
	if not tbLogic then
		return
	end

	tbLogic:OnUseTool(pPlayer, pNpc.nTemplateId)

	if nChangeSkillId then
		pPlayer.AddSkillState(nChangeSkillId, KinEncounter.nBuffLevel,  0 , nDuraSeconds * Env.GAME_FPS)
		pPlayer.RestoreAll()
		pPlayer.CenterMsg(string.format("成功變身為「%s」", szText))
	end

	pNpc.Delete()
end