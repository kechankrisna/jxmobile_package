local tbNpc = Npc:GetClass("KinRobber");

function tbNpc:OnCreate(szParam)
	
end

function tbNpc:OnDialog(szParam)
	Dialog:Show(
	{
	    Text    = "Nhìn cái gì nhìn? Lại không rời đi đừng trách ta đối ngươi không khách khí!",
	    OptList = {
	        { Text = "Tiểu tặc, nhìn đánh!", Callback = self.StartFightRobber, Param = {self, me.dwID, him.nId}},
			{ Text = "Tặc phỉ hung hãn, nên rời đi trước"},
	    },
	}, me, him)
end

function tbNpc:StartFightRobber(nPlayerId, nNpcId)
	local player = KPlayer.GetPlayerObjById(nPlayerId or 0);
	local pNpc = KNpc.GetById(nNpcId or 0);
	if not pNpc or not player then
		return;
	end

	local team = TeamMgr:GetTeamById(player.dwTeamID);
	if not team then
		player.CenterMsg("Đội ngũ nhân số cần [FFFE0D]≥2 Người [FFFE0D]");
		return;
	end

	if player.dwID ~= team:GetCaptainId() then
		player.CenterMsg("Ngài không phải đội trưởng");
		return;
	end

	local nInMapMemberCount = 0;
	local tbTeamMembers = team:GetMembers();
	for _, nMemberId in pairs(tbTeamMembers) do
		local member = KPlayer.GetPlayerObjById(nMemberId);
		if member then
			if member.nMapId == player.nMapId and member.dwKinId == player.dwKinId then
				nInMapMemberCount = nInMapMemberCount + 1;
			end
		end
	end

	if nInMapMemberCount < 2 then
		player.CenterMsg("Cần đội ngũ bản địa đồ nhân số ≥2 Người");
		return;
	end
	
	local function fDo()
		local nKinId = pNpc.nRobberKinId;
		local kinData = nKinId and Kin:GetKinById(nKinId);
		local bSuccess = Kin.KinNest:OnKinRobberActivate(pNpc, player.dwTeamID, player.dwKinId, player);
		if bSuccess == false and kinData then
			kinData:OnKinRobberActivate(pNpc, player.dwTeamID, player);
		end
	end

	if player.nMapTemplateId~=Kin.Def.nKinNestMapTemplateId and DegreeCtrl:GetDegree(player, "KinRobReward")<1 then
		player.MsgBox("Hôm nay đã mất còn thừa lĩnh thưởng số lần, có thể đem cơ hội lưu cho trong bang phái cần huynh đệ, phải chăng vẫn muốn tiếp tục khiêu chiến?",
					{{"Xác nhận", fDo}, {"Hủy"}})
	else
		fDo()
	end
end

function tbNpc:OnDeath(pKiller)
	local nKinId = him.nRobberKinId;
	local kinData = nKinId and Kin:GetKinById(nKinId);
	if not kinData then
		local tbFubenDeath = Npc:GetClass("FubenDeath");
		tbFubenDeath:OnDeath(pKiller);
		return;
	end

	kinData:OnRobberDeath(him, pKiller.dwPlayerID);
end