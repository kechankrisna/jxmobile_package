local tbNpc = Npc:GetClass("NYSnowmanNpc");

local NYSnowman = Kin.NYSnowman

function tbNpc:OnDialog()
	if not NYSnowman:IsRunning() then
		me.CenterMsg("Hoạt động chưa mở",true)
		return
	end

	Activity:OnPlayerEvent(me, "Act_DialogNYSnowman",him);
end