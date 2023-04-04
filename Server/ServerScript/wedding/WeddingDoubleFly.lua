Wedding.tbDoubleFly = Wedding.tbDoubleFly or {}
local tbDoubleFly = Wedding.tbDoubleFly
tbDoubleFly.tbTrapInPlayer = tbDoubleFly.tbTrapInPlayer or {}
local nLinAnMapTID = 15
local function fnAllMember(tbMember, fnSc, ...)
    for _, pMember in ipairs(tbMember or {}) do
        fnSc(pMember, ...);
    end
end
function tbDoubleFly:OnPlayerLinAnTrap(pPlayer, szTrapName)
	if szTrapName == "daqinggongIn" then
		self.tbTrapInPlayer[pPlayer.dwID] = true
		pPlayer.CallClientScript("Wedding:OnDoubleFlyTrapIn")
	elseif szTrapName == "daqinggongOut" or szTrapName == "qinggong2_1" then
		self.tbTrapInPlayer[pPlayer.dwID] = nil
		pPlayer.CallClientScript("Wedding:OnDoubleFlyTrapOut")
	end
end

function tbDoubleFly:TryPlayDoubleFly(pPlayer)
	local bRet, szMsg, pLover = self:CheckPlayDoubleFly(pPlayer)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return 
	end
	local tbPlayer = {pPlayer, pLover}
	local function fnStart(pPlayer)
	    pPlayer.CallClientScript("Wedding:StartDoubleFly")
	    if Wedding.tbDoubleFlyEndPos then
	    	pPlayer.SetPosition(unpack(Wedding.tbDoubleFlyEndPos))
	    end
	    pPlayer.tbDoubleFly = nil
	    self.tbTrapInPlayer[pPlayer.dwID] = nil
	end

	local nNowTime = GetTime()
	pPlayer.tbDoubleFly = pPlayer.tbDoubleFly or {}
    local nFlyTime = pPlayer.tbDoubleFly[pLover.dwID] or 0
    -- 是否已经请求了双飞
    if nNowTime - nFlyTime < Wedding.nDoubleFlyWaitTime then
    	pPlayer.CenterMsg("Chờ đối phương đồng ý Khinh công uyên ương")
    	return
    end
    pLover.tbDoubleFly = pLover.tbDoubleFly or {}
    local nLoveFlyTime = pLover.tbDoubleFly[pPlayer.dwID] or 0
    -- 对方是否请求了双飞
    if nNowTime - nLoveFlyTime < Wedding.nDoubleFlyWaitTime then
    	fnAllMember(tbPlayer, fnStart);
    	return 
    end
    pPlayer.tbDoubleFly[pLover.dwID] = nNowTime
    pPlayer.CallClientScript("Wedding:OnRequestDoubleFly")
    pLover.CallClientScript("Wedding:OnBeRequestDoubleFly")
    pPlayer.CenterMsg(string.format("Gửi yêu cầu cùng %s khinh công", pLover.szName))
    pLover.CenterMsg(string.format("%s muốn cùng bạn khinh công", pLover.szName))
    Log("tbDoubleFly fnTryPlayDoubleFly ", pPlayer.dwID, pPlayer.szName, pLover.dwID, pLover.szName, nLoveFlyTime, nFlyTime)
end

function tbDoubleFly:CheckPlayDoubleFly(pPlayer)
	if not self:CheckIsInDoubleFlyArena(pPlayer) then
		return false, "Khu vực không thể khinh công"
	end
	local nLoverId = Wedding:GetLover(pPlayer.dwID)
	if not nLoverId then
		return false, "Kết hôn mới có thể khinh công"
	end
	local pLover = KPlayer.GetPlayerObjById(nLoverId)
	if not pLover then
		return false, "Phu thuê phải trực tuyến mới có thể khinh công"
	end
	if not self.tbTrapInPlayer[pPlayer.dwID] then
		return false, "Không ở khu vực chỉ định không thể khinh công"
	end
	if not self.tbTrapInPlayer[nLoverId] then
		return false, "Hiệp lữ không ở khu vực chỉ định không thể khinh công"
	end
	local tbPlayer = {pPlayer, pLover}
	for _, pP in ipairs(tbPlayer) do
		if not pP.bWeddingDressOn then
			return false, string.format("「%s」 không mặc hôn phục", pP.szName)
		end
	end
	local nMapId1, nX1, nY1 = pPlayer.GetWorldPos()
    local nMapId2, nX2, nY2 = pLover.GetWorldPos()
    local fDists = Lib:GetDistsSquare(nX1, nY1, nX2, nY2)
    if fDists > (Wedding.nDoubleFlyMinDistance * Wedding.nDoubleFlyMinDistance) or nMapId1 ~= nMapId2 then
        return false, "Hiệp lữ không ở gần"
    end

    return true, nil, pLover
end

function tbDoubleFly:CheckIsInDoubleFlyArena(pPlayer)
	local _, nX, nY = pPlayer.GetWorldPos()
	local fDist = Lib:GetDistance(Wedding.tbDoubleFlyCanterPos[1], Wedding.tbDoubleFlyCanterPos[2], nX, nY)
	if (pPlayer.nMapTemplateId == nLinAnMapTID and fDist < Wedding.nDoubleFlyMaxDistance) then
		return true
	end
end

function tbDoubleFly:OnLogin(pPlayer)
	local bInArena = self:CheckIsInDoubleFlyArena(pPlayer)
	if bInArena then
		pPlayer.CallClientScript("Wedding:OnDoubleFlyTrapIn")
	else
		pPlayer.CallClientScript("Wedding:OnDoubleFlyTrapOut")
	end
end

function tbDoubleFly:OnLeaveMap(pPlayer)
	self.tbTrapInPlayer[pPlayer.dwID] = nil
	pPlayer.CallClientScript("Wedding:OnDoubleFlyTrapOut")
end