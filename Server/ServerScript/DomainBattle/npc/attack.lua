local tbNpc = Npc:GetClass("corss_domain_attack");

function tbNpc:OnDeath(pKillNpc)
	if not him.nKillScore then
		return
	end

	local pPlayer = pKillNpc.GetPlayer();
	if not pPlayer then
		return
	end

	if DomainBattle.tbCross:AddPlayerScore(pPlayer.dwID, him.nKillScore) then
		pPlayer.CenterMsg(string.format("Phá hủy %s Thu được %d Điểm tích lũy!", him.szName, him.nKillScore))
	end
end
