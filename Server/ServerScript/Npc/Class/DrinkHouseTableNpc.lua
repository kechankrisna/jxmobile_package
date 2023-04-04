local tbNpc = Npc:GetClass("DrinkHouseTableNpc")

function tbNpc:OnDialog(szParam)
	local tbInst = Fuben.tbFubenInstance[me.nMapId]
	if not tbInst then
		return
	end
	tbInst:PlayerEatFood(me, him)
end
