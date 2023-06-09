function Pet:CheckFeedCount(pPlayer)
	local nLastTime = pPlayer.GetUserValue(self.Def.SaveGrp, self.Def.SaveKeyTime)
	if Lib:IsDiffDay(0, nLastTime, GetTime()) then
		return true, 0
	end
	local nCount = pPlayer.GetUserValue(self.Def.SaveGrp, self.Def.SaveKeyCount)
	return nCount<self.Def.FeedCfg.nDailyLimit, nCount
end

function Pet:CheckNameAvailable(szPetName)
	local nLen = Lib:Utf8Len(szPetName)
	if nLen>self.Def.nNameLenMax or nLen<self.Def.nNameLenMin then
		return false, string.format("Tên thú cưng %d-%d ký tự", self.Def.nNameLenMin, self.Def.nNameLenMax)
	end

	if not CheckNameAvailable(szPetName) then
		return false, "Có từ không hợp lệ, sửa rồi thử lại"
	end
	return true
end