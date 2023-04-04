local tbItem = Item:GetClass("WomensDayItem")

function tbItem:OnUse(it)
	local tbAct = Activity:GetClass("WomenDayFubenAct")
	local nMapTemplateId = tbAct.nFubenMapTID

	if me.nMapTemplateId~=nMapTemplateId then
		me.CenterMsg("Chưa đến lúc dùng")
		return
	end

	local pMonsterNpc = nil
	local nMapId = me.nMapId
	local tbAllNpcs = KNpc.GetMapNpc(nMapId)
	for _, pNpc in ipairs(tbAllNpcs) do
		if pNpc.nTemplateId==tbAct.nBossId then
			pMonsterNpc = pNpc
			break
		end
	end

	if not pMonsterNpc then
		me.CenterMsg("Chưa đến lúc dùng")
		return
	end

	local pMeNpc = me.GetNpc()
	if pMeNpc.GetDistance(pMonsterNpc.nId)>tbAct.nMaxSkillDist then
		me.CenterMsg("Cách mục tiêu quá xa!")
		return
	end

	Activity:OnPlayerEvent(me, "Act_UseWomensDayItem")
	me.CallClientScript("Ui:CloseWindow", "QuickUseItem")

	return 1
end
