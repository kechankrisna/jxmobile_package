local tbItem = Item:GetClass("WeddingDress")

tbItem.nParamLevel = 1
tbItem.nParamGender = 2
tbItem.nEmptyWeaponId = 301	--空武器模型id

function tbItem:OnUse(it)
	if not Map:IsCityMap(me.nMapTemplateId) and
		not Map:IsHouseMap(me.nMapTemplateId) and
		not Map:IsKinMap(me.nMapTemplateId) then

		me.CenterMsg("Lễ phục chỉ được sử dụng tại Thành Chính, Tân Thủ Thôn, Lãnh Địa Bang Hội, Gia Viên");
		return 0;
	end

	if not Env:CheckSystemSwitch(me, Env.SW_ChuangGong) then
		me.CenterMsg("Trạng thái hiện tại không thể dùng");
		return
	end

	local nGender = KItem.GetItemExtParam(it.dwTemplateId, self.nParamGender)
	if me.nSex~=nGender then
		me.CenterMsg("Lễ phục này không phù hợp giới tính nhân vật")
		return 0
	end

	if me.bWeddingDressOn then
		me.CenterMsg("Đã mặc lễ phục rồi")
		return 0
	end

	local nWeddingLevel = KItem.GetItemExtParam(it.dwTemplateId, self.nParamLevel)
	local tbResIds = Wedding.tbDressPartResIds[nWeddingLevel]
	if not tbResIds or not next(tbResIds) then
		Log("[x] WeddingDress:OnUse, no resids", tostring(nWeddingLevel))
		return 0
	end

	local szShape = ActionInteract:GetFactionShape(me.nFaction, nGender)
	local tbIds = tbResIds[szShape]
	if not tbIds or not next(tbIds) then
		Log("[x] WeddingDress:OnUse, no shape ids", nWeddingLevel, me.nFaction, nGender, szShape)
		return 0
	end

	local pNpc = me.GetNpc()
	local nHead, nBody = unpack(tbIds)
	if nHead then
		pNpc.ModifyPartFeatureEquip(Npc.NpcResPartsDef.npc_part_head, nHead)
	end
	if nBody then
		pNpc.ModifyPartFeatureEquip(Npc.NpcResPartsDef.npc_part_body, nBody)
	end
	pNpc.ModifyPartFeatureEquip(Npc.NpcResPartsDef.npc_part_weapon, self.nEmptyWeaponId)
	pNpc.ModifyPartFeatureEquip(Npc.NpcResPartsDef.npc_part_weapon, 0, Npc.NpcPartLayerDef.npc_part_layer_effect)

	Wedding:ChangeDressState(me, true)

	return 0
end
