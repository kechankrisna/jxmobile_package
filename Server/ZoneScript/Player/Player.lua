local CTeamMgr = GetCTeamMgr();

function Player:TeamUp(tbRoleIds)
	local dwRoleId1, dwRoleId2 = tbRoleIds[1], tbRoleIds[2]
	if not dwRoleId2 then
		local pPlayer = KPlayer.GetPlayerObjById(dwRoleId1)
		if not pPlayer then
			return
		end
		local bRet, szMsg, teamData = TeamMgr:CreateOnePersonTeamByPlayer(pPlayer)
		return teamData
	end
	local bRet, nRet2,nRet3, teamData = TeamMgr:Create(dwRoleId1, dwRoleId2, true);
	if bRet and teamData then
		for j = 3, #tbRoleIds do
			teamData:AddMember(tbRoleIds[j], true);	
		end
		return teamData
	else
		Log("TeamUp Error bRet, nRet2,nRet3", bRet, nRet2,nRet3, dwRoleId1, dwRoleId2)
	end
end

--优先同家族，同服的组队
function Player:MapPlayerTeamUp( tbPlayers, nMaxTeamRoleNum , bALlTeamUp)
	local tbSortPlayers = {}; --暂时没有队伍的玩家
	local tbHasTeams = {};
	for i, pPlayer in ipairs(tbPlayers) do
		if pPlayer.dwTeamID ~= 0 and CTeamMgr.TeamGetMemberCount(pPlayer.dwTeamID) <= 1 then
			TeamMgr:QuiteTeam(pPlayer.dwTeamID, pPlayer.dwID);
		end
		if pPlayer.dwTeamID == 0 then
			table.insert(tbSortPlayers, {dwRoleId = pPlayer.dwID, nSort = (pPlayer.nZoneServerId or 0) * 100000 + pPlayer.dwKinId % 2^20 } )
		else
			if not tbHasTeams[pPlayer.dwTeamID] then
				tbHasTeams[pPlayer.dwTeamID] = { tbRoles = {}, nSort = (pPlayer.nZoneServerId or 0) * 100000 + pPlayer.dwKinId % 2^20 }
			end
			table.insert(tbHasTeams[pPlayer.dwTeamID].tbRoles, pPlayer.dwID)
		end
	end
	local tbHasSortIndex = {} -- [nSort] = {dwTeamID1, dwTeamID2 ...}
	local nCurTotalTeamNum = 0
	for dwTeamID,v in pairs(tbHasTeams) do
		if #v.tbRoles < nMaxTeamRoleNum then
			tbHasSortIndex[v.nSort] = tbHasSortIndex[v.nSort] or {};
			table.insert(tbHasSortIndex[v.nSort], dwTeamID);
		end
		nCurTotalTeamNum = nCurTotalTeamNum + 1;
 	end

 	table.sort( tbSortPlayers, function (a, b)
 		return a.nSort < b.nSort;
 	end )

 	--先是优先将同服同家族的塞到已建立的队伍中去
 	for i = #tbSortPlayers, 1, -1 do
 		local v = tbSortPlayers[i]
 		local tbCurSortTeamIDs = tbHasSortIndex[v.nSort]
 		if tbCurSortTeamIDs then
 			local nCurSortTeamID = tbCurSortTeamIDs[#tbCurSortTeamIDs]
 			table.insert(tbHasTeams[nCurSortTeamID].tbRoles, v.dwRoleId)
 			--组队操作
			local teamData = TeamMgr:GetTeamById(nCurSortTeamID);
			teamData:AddMember(v.dwRoleId, true);
 			table.remove(tbSortPlayers, i)
 			if #tbHasTeams[nCurSortTeamID].tbRoles == nMaxTeamRoleNum then
				table.remove(tbCurSortTeamIDs)	 			
				if not next(tbCurSortTeamIDs) then
					tbHasSortIndex[v.nSort] = nil;
				end
 			end
 		end
 	end
 	--直接将剩余的人塞到已建立的队伍中
 	local bHasRoles = true
 	for nSort, tbTeamIDs in pairs(tbHasSortIndex) do
 		for _, dwTeamID in ipairs(tbTeamIDs) do
 			local tbTeamRoles = tbHasTeams[dwTeamID].tbRoles
	 		for i = #tbTeamRoles + 1, nMaxTeamRoleNum do
	 			local tbRole = table.remove(tbSortPlayers)
	 			if not tbRole then
	 				bHasRoles = false
	 				break;
	 			else
		 			local teamData = TeamMgr:GetTeamById(dwTeamID); 
					teamData:AddMember(tbRole.dwRoleId, true);
					table.insert(tbHasTeams[dwTeamID].tbRoles, tbRole.dwRoleId)
	 			end
	 		end
 		end
 		if not bHasRoles then
 			break;
 		end
 	end

 	--剩余的先同 家族的组队 够3个的才组
 	local nMaxLeftTeam = math.floor(#tbSortPlayers / nMaxTeamRoleNum) 
 	if nMaxLeftTeam > 0 then
 		local tbNewTeamUpRoleIndex = {}; --已经组队的列表
 		local tbSameSortRoles = {};
 		local nLastSort = -1;
 		table.insert(tbSortPlayers, {dwRoleId = 0, nLastSort = -2 }) --为了兼容算法，
 		for i, tbRole in ipairs(tbSortPlayers) do
 			if tbRole.nSort ~= nLastSort then
 				local nCanTeamNum = math.floor(#tbSameSortRoles / nMaxTeamRoleNum)
 				for j = 1, nCanTeamNum do
 					local tbRoleIds = { unpack(tbSameSortRoles, (j - 1) * nMaxTeamRoleNum + 1, (j - 1) * nMaxTeamRoleNum + nMaxTeamRoleNum) };
 					local teamData = self:TeamUp(tbRoleIds) 
 					if teamData then
		 				nCurTotalTeamNum = nCurTotalTeamNum + 1;
		 				tbHasTeams[teamData.nTeamID] = { tbRoles = tbRoleIds }
		 			else
		 				Log(debug.traceback())
		 			end
 				end
				for i3 = i - #tbSameSortRoles , i - #tbSameSortRoles - 1 + nCanTeamNum * nMaxTeamRoleNum  do
 					table.insert(tbNewTeamUpRoleIndex, i3)
 				end

 				tbSameSortRoles = { tbRole.dwRoleId }
 				nLastSort = tbRole.nSort;
 			else
 				table.insert(tbSameSortRoles, tbRole.dwRoleId)
 			end
 		end
 		table.remove(tbSortPlayers) --算法去掉最后多于的

 		--去掉刚组上队的
 		for i = #tbNewTeamUpRoleIndex,1, -1 do
 			table.remove(tbSortPlayers, tbNewTeamUpRoleIndex[i])
 		end
 	end

	--剩余的就直接3个一组进行组队。 边缘的其实是会影响到下个服的，应该还是要类似上面的再做次针对同服的3个一组。
	local fnMath = bALlTeamUp and math.ceil or math.floor
	local nMaxLeftTeam = fnMath(#tbSortPlayers / nMaxTeamRoleNum) 
 	if nMaxLeftTeam > 0 then
 		for i = 1, nMaxLeftTeam do
 			local tbRoleIds = {};
 			for j = 1, nMaxTeamRoleNum do
 				local tbData = tbSortPlayers[(i - 1) * nMaxTeamRoleNum + j]
 				if tbData then
 					table.insert(tbRoleIds, tbData.dwRoleId)
 				else
 					break;
 				end
 			end
 			local teamData = self:TeamUp(tbRoleIds) 
 			if teamData then
 				nCurTotalTeamNum = nCurTotalTeamNum + 1;
 				tbHasTeams[teamData.nTeamID] = { tbRoles = tbRoleIds }
 			else
 				Log(debug.traceback())
 			end
 		end
 	end
 	return nCurTotalTeamNum, tbHasTeams
end