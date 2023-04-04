local tbNpc = Npc:GetClass("SnowmanNpc");

local Snowman = Kin.Snowman

function tbNpc:OnDialog()
	if not Snowman:IsRunning() then
		me.CenterMsg("Hoạt động chưa mở",true)
		return
	end

	Activity:OnPlayerEvent(me, "Act_DialogSnowman",him);
end