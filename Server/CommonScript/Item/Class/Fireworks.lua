local tbItem = Item:GetClass("Fireworks")

function tbItem:OnUse(it)
	if me.nMapTemplateId~=Kin.Def.nKinMapTemplateId then
		me.CenterMsg("Chỉ có thể dùng trong bản đồ bang hội")
		return
	end

	local nKinId = me.dwKinId
	local tbKin = Kin:GetKinById(nKinId)
	if not tbKin then
		me.CenterMsg("Đại hiệp chưa có Bang Hội")
		return
	end

	local pMonsterNpc = nil
	local nMapId = tbKin:GetMapId()
	local tbAllNpcs = KNpc.GetMapNpc(nMapId)
	for _, pNpc in ipairs(tbAllNpcs) do
		if pNpc.nTemplateId==Kin.MonsterNianDef.nMonsterId then
			pMonsterNpc = pNpc
			break
		end
	end

	if not pMonsterNpc then
		me.CenterMsg("Không có Niên Thú")
		return
	end

	local pMeNpc = me.GetNpc()
	if pMeNpc.GetDistance(pMonsterNpc.nId)>Kin.MonsterNianDef.nMaxFireworkSkillDist then
		me.CenterMsg("Niên Thú cách quá xa!")
		return
	end

	local nNow = GetTime()
	if nNow-(me.nLastUseFireworks or 0)<=(Kin.MonsterNianDef.nFireworkCD-1) then
		return
	end
	me.nLastUseFireworks = nNow

	local _, nX, nY = pMonsterNpc.GetWorldPos()
	
	me.CallClientScript("Fuben:DoCommonAct", {pMeNpc.nId}, 16, 0, 0, 12)
	pMeNpc.SetDirToPos(nX, nY)

	local nRandom = MathRandom(#Kin.MonsterNianDef.nFireworkSkillIds)
	pMeNpc.CastSkill(Kin.MonsterNianDef.nFireworkSkillIds[nRandom], 1, nX, nY)
	me.CallClientScript("Item:OnUse", it.dwTemplateId, it.dwId)

	Activity:OnPlayerEvent(me, "Act_UseFirework")

	me.CenterMsg("Đã đốt một pháo hoa tuyệt đẹp!")

	return 1
end
