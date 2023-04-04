function SwornFriends:GetConnectPids(pPlayer)
	if MODULE_GAMESERVER then
		return self:GetFriendsId(pPlayer.dwID)
	else
		return self.tbConnectIds or {}
	end
end

function SwornFriends:IsConnectedState(pPlayer)
	if MODULE_GAMESERVER then
		return self:_GetConnectInfo(pPlayer.dwID)
	else
		return self.bConnected
	end
end

function SwornFriends:GetMemberCountDesc(nMemberCount)
	local tbDesc = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}
	if version_vn then
		tbDesc = {"Nhất", "Nhị", "Tam", "Tứ", "Ngũ", "Lục", "Thất", "Bát", "Cửu", "Thập"}
	end
	local szRet = tbDesc[nMemberCount]
	if not szRet then
		Log("[x] SwornFriends:GetMemberCountDesc", tostring(nMemberCount))
	end
	return szRet or tostring(nMemberCount)
end