local tbNpc = Npc:GetClass("MonsterNianGatherBox")

--直接执行，不走对话框形式，所以没用Activity:RegisterNpcDialog
function tbNpc:OnDialog()
	if me.nLevel<Kin.MonsterNianDef.nMinJoinLevel then
		me.CenterMsg(string.format("Chưa đủ %d cấp，không thể nhặt", Kin.MonsterNianDef.nMinJoinLevel))
		return
	end
    Activity:OnPlayerEvent(me, "Act_TryOpenMonsterBox", him)
end