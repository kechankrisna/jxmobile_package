local tbItem = Item:GetClass("LabaSoup")

tbItem.nSkillId = 2316
tbItem.nBuffDuration = 23*3600
tbItem.nExpAddRate = 0.6

function tbItem:OnUse(it)
	if self:HasDrank(me) then
		me.CenterMsg("Đại hiệp đã ăn Bánh Chưng, xin hãy chờ thêm")
		return 0
	end

	me.AddSkillState(self.nSkillId, 1, 2, GetTime()+self.nBuffDuration, 1, 1)
	me.CenterMsg("Đại hiệp đã ăn một Bánh Chưng")
	me.Msg("Đại hiệp đã ăn một Bánh Chưng")

	return 1
end

function tbItem:HasDrank(pPlayer)
	return pPlayer.GetNpc().GetSkillState(self.nSkillId)
end

function tbItem:GetExpAddRate(pPlayer)
	return self:HasDrank(pPlayer) and self.nExpAddRate or 0
end