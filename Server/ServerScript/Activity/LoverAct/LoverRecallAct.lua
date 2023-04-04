local tbAct = Activity:GetClass("LoverRecallAct")
tbAct.tbTrigger  = {Init = {}, Start = {}, End = {}}
function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then

	elseif szTrigger == "Start" then
		Activity:RegisterPlayerEvent(self, "Act_SendUseMapAward", "OnSendUseMapAward")
		Activity:RegisterPlayerEvent(self, "Act_SendAssistAward", "OnSendAssistAward")
		Activity:RegisterPlayerEvent(self, "Act_ComposeLoverRecallMap", "OnComposeLoverRecallMap")
		Activity:RegisterPlayerEvent(self, "Act_EverydayTargetGainAward", "OnEverydayTargetGainAward")
		Activity:RegisterPlayerEvent(self, "Act_UseLoverRecallMap", "OnUseLoverRecallMap")
		Activity:RegisterPlayerEvent(self, "Act_AssistOk", "OnAssistOk")
		local _, nEndTime = self:GetOpenTimeInfo()
		-- 注册申请存库数据块,活动结束自动清掉
        self:RegisterDataInPlayer(nEndTime)
        self:FormatAward()
        self:InitMapInfo()
	elseif szTrigger == "End" then

	end
	Log("[LoverRecallAct] OnTrigger:", szTrigger)
end

function tbAct:InitMapInfo()
	self.tbAllMap = {}
	for _, v in ipairs(self.tbMapInfo) do
		self.tbAllMap[v.nMapTID] = true
	end
end

function tbAct:FormatAward()
	local _, nEndTime = self:GetOpenTimeInfo()
	for _,tbInfo in pairs(self.tbActiveAward) do
		for _, v in ipairs(tbInfo) do
			if v[1] and (v[1] == "item" or v[1] == "Item") then
				 v[4] = nEndTime
			end
		end
	end
end

local function fnAllMember(tbMember, fnSc, ...)
    for _, nPlayerId in pairs(tbMember or {}) do
        local pMember = KPlayer.GetPlayerObjById(nPlayerId);
        if pMember then
            fnSc(pMember, ...);
        end
    end
end

function tbAct:OnEverydayTargetGainAward(pPlayer, nAwardIdx)
    local tbAward = self.tbActiveAward[nAwardIdx]
    if not tbAward then
		return 
    end

    if not self:CheckLevel(pPlayer) then
    	return 
    end

   pPlayer.SendAward(tbAward, true, nil, Env.LogWay_LoverRecallAct);
end

function tbAct:OnComposeLoverRecallMap(pPlayer)
	local bRet, szMsg = self:CheckComposeLoverRecallMap(pPlayer);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		return
	end

	local nConsume = pPlayer.ConsumeItemInAllPos(self.nClueItemTID, self.nClueCompose, Env.LogWay_LoverRecallAct);
	if nConsume < self.nClueCompose then
		pPlayer.CenterMsg("Khấu trừ đạo cụ thất bại", true);
		return
	end

	local _, nEndTime = self:GetOpenTimeInfo()
	local pItem = pPlayer.AddItem(self.nMapItemTID, 1, nEndTime, Env.LogWay_LoverRecallAct);
	if pItem then
		pPlayer.CenterMsg(string.format("Chúc mừng! Hợp thành【%s】", KItem.GetItemShowInfo(self.nMapItemTID, pPlayer.nFaction, pPlayer.nSex) or ""));
	else
		pPlayer.CenterMsg("Hợp thành thất bại, không biết sai lầm, mời cùng phục vụ khách hàng liên hệ!");
		Log("[LoverRecallAct] OnComposeLoverRecallMap fail ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel);
	end
	Log("[LoverRecallAct] OnComposeLoverRecallMap ok ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel);
end

function tbAct:CheckComposeLoverRecallMap(pPlayer)
    local bRet, szMsg = pPlayer.CheckNeedArrangeBag()
    if bRet then
        return false, szMsg
    end

	local nHave = pPlayer.GetItemCountInAllPos(self.nClueItemTID);
	if nHave < self.nClueCompose then
		return false, string.format("Ngài manh mối không đủ, còn cần %d Cái manh mối", self.nClueCompose - nHave)
	end

	 if not self:CheckLevel(pPlayer) then
    	return false, string.format("Mời trước tăng lên tới %d Cấp", self.nJoinLevel)
    end

	return true
end

-- 使用地图道具
-- function tbAct:OnUseLoverRecallMap(pPlayer, nMapTID)

-- 	local tbOptList = {}
-- 	for nIndex, tbInfo in ipairs(self.tbMapInfo) do
-- 		local tbOpt = {}
-- 		tbOpt.Text = tbInfo.szText
-- 		tbOpt.Callback = self.TryGoLoverRecallMap
-- 		tbOpt.Param = {self, pPlayer.dwID, tbInfo.nMapTID}
-- 		table.insert(tbOptList, tbOpt)
-- 	end

-- 	Dialog:Show(
-- 	{
-- 		Text = "您想了解哪对情缘？",
-- 		OptList = tbOptList,
-- 	}, pPlayer);
-- end

function tbAct:OnUseLoverRecallMap(pPlayer, nMapTID, nItemTID)
    if not pPlayer or not self.tbAllMap[nMapTID] then
        return
    end

	local bRet, szMsg, pAssist = self:CheckGoLoverRecallMap(pPlayer);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		return
	end
	
	pAssist.MsgBox(string.format("Hiệp sĩ [FFFE0D]%s[-] Muốn mời ngươi tiến đến manh mối địa đồ sở tại địa, phải chăng tiến về?", pPlayer.szName),
			{
				{"Xác nhận", function () self:ConfirmUseGoLoverRecallMap(pPlayer.dwID, pAssist.dwID, nMapTID, true, nItemTID) end},
				{"Cự tuyệt", function () self:ConfirmUseGoLoverRecallMap(pPlayer.dwID, pAssist.dwID, nMapTID, false, nItemTID) end},
			});
end

function tbAct:CheckGoLoverRecallMap(pUsePlayer, nAssistPlayerId)

	local tbTeam = TeamMgr:GetTeamById(pUsePlayer.dwTeamID);
	if not tbTeam then
		return false, "Tạo thành hai người đội ngũ mới có thể sử dụng!";
	end

	local tbMember = tbTeam:GetMembers();
	local nTeamCount = Lib:CountTB(tbMember);
	if nTeamCount ~= 2 then
		return false, "Tạo thành hai người đội ngũ mới có thể sử dụng!";
	end
	local tbSecOK = {}
	local pAssist;
	for nIdx, nPlayerID in pairs(tbMember) do
		local pMember = KPlayer.GetPlayerObjById(nPlayerID);
		if not pMember then
			return false, "Đối phương không tuyến bên trên, không cách nào sử dụng!"
		end
		if not self:CheckLevel(pMember) then
			return false, string.format("%s Đẳng cấp cần đạt tới %d Cấp", pMember.szName, self.nJoinLevel)
		end
		if nPlayerID ~= pUsePlayer.dwID then
			pAssist = pMember;
		end
		table.insert(tbSecOK, pMember.nSex)
	end

	if not pAssist then
		return false, "Tìm không thấy ngài đồng đội"
	end

	if tbSecOK[1] == tbSecOK[2] then
        return false, "Nhất định phải khác phái tổ đội"
    end

    if not FriendShip:IsFriend(pUsePlayer.dwID, pAssist.dwID) then
    	return false, "Ngươi cùng đối phương cũng không phải là hảo hữu, xin xác nhận sau đang tiến hành nếm thử a"
	end

	-- 当A要B协助，发出请求后退出队伍，与C组队，这时如果B确认会直接将A和C传去地图
	if nAssistPlayerId and nAssistPlayerId ~= pAssist.dwID then
		local pOldAssist = KPlayer.GetPlayerObjById(nAssistPlayerId)
		if pOldAssist then
			pOldAssist.CenterMsg("Đội ngũ nhân viên phát sinh biến hóa, mời một lần nữa thử lại")
		end
		return false, "Đội ngũ nhân viên phát sinh biến hóa, mời một lần nữa thử lại"
	end

	if not Map:IsCityMap(pUsePlayer.nMapTemplateId) then
		return false, "Chỉ có thể ở thành thị hoặc Tân Thủ thôn mới có thể sử dụng"
	end

	local nImityLevel = FriendShip:GetFriendImityLevel(pUsePlayer.dwID, pAssist.dwID) or 0
	if nImityLevel < self.nUseMapImityLevel then
		return false, string.format("Song phương độ thân mật đạt tới %s Cấp mới có thể sử dụng", self.nUseMapImityLevel)
	end

	local nMapId1, nX1, nY1 = pUsePlayer.GetWorldPos()
    local nMapId2, nX2, nY2 = pAssist.GetWorldPos()
    local fDists = Lib:GetDistsSquare(nX1, nY1, nX2, nY2)
    if fDists > (self.MIN_DISTANCE * self.MIN_DISTANCE) or nMapId1 ~= nMapId2 then
        return false, "Đồng đội không tại phụ cận"
    end

    self:CheckAssistData(pAssist)

    local tbAssistSaveData = self:GetDataFromPlayer(pAssist.dwID) or {}
	if tbAssistSaveData.nAssistCount >= self.nMaxAssistCount then
		return false, string.format("Đồng đội %s Hiệp trợ số lần không đủ", pAssist.szName)
	end

	return true, "", pAssist, tbMember;
end

function tbAct:ConfirmUseGoLoverRecallMap(nUsePlayerId, nAssistPlayerId, nMapTID, bResult, nItemTID)
	local pUsePlayer = KPlayer.GetPlayerObjById(nUsePlayerId);
	if not pUsePlayer then
		local pOldAssist = KPlayer.GetPlayerObjById(nAssistPlayerId)
		if pOldAssist then
			pOldAssist.CenterMsg("Đối phương đã offline")
		end
		return;
	end

	if not bResult then
		pUsePlayer.CenterMsg("Đối phương cự tuyệt lời mời của ngươi");
		return;
	end

	local bRet, szMsg, pAssist, tbMember = self:CheckGoLoverRecallMap(pUsePlayer, nAssistPlayerId);
	if not bRet then
		pUsePlayer.CenterMsg(szMsg); 
		return;
	end

	local nConsume = pUsePlayer.ConsumeItemInAllPos(nItemTID, 1, Env.LogWay_LoverRecallAct);
	if nConsume < 1 then
		pUsePlayer.CenterMsg(string.format("Khấu trừ đạo cụ %s Thất bại!",KItem.GetItemShowInfo(nItemTID, pUsePlayer.nFaction, pUsePlayer.nSex)));
		 Log("[LoverRecallAct] fnConfirmUseGoLoverRecallMap consume item fail ", pUsePlayer.dwID, pUsePlayer.szName, pAssist.dwID, pAssist.szName, nMapTID, nItemTID)
		return
	end

	local function fnSuccessCallback(nMapId)
        local function fnSucess(pPlayer, nMapId)
            pPlayer.SetEntryPoint();
            pPlayer.SwitchMap(nMapId, 0, 0);
        end
        fnAllMember(tbMember, fnSucess, nMapId);
    end

    local function fnFailedCallback()
    	local function fnMsg(pPlayer, szMsg)
		    pPlayer.CenterMsg(szMsg);
		end
        fnAllMember(tbMember, fnMsg, "Sáng tạo phó bản thất bại, xin sau nếm thử!");
        Log("[LoverRecallAct] fnConfirmUseGoLoverRecallMap fnFailedCallback ", pUsePlayer.dwID, pUsePlayer.szName, pAssist.dwID, pAssist.szName, nMapTID or -1)
    end

    Fuben:ApplyFuben(nUsePlayerId, nMapTID, fnSuccessCallback, fnFailedCallback, nUsePlayerId, nAssistPlayerId);
    Log("[LoverRecallAct] fnConfirmUseGoLoverRecallMap ok ", pUsePlayer.dwID, pUsePlayer.szName, pAssist.dwID, pAssist.szName, nMapTID)
end

function tbAct:CheckAssistData(pPlayer)
	local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbSaveData.nAssistCount = tbSaveData.nAssistCount or 0
    tbSaveData.nAssistTime = tbSaveData.nAssistTime or 0
    local nNowTime = GetTime()
    if Lib:IsDiffDay(self.nAssistRefreshTime, tbSaveData.nAssistTime, nNowTime) then
		tbSaveData.nAssistCount = 0
		tbSaveData.nAssistTime = nNowTime
	end
	self:SaveDataToPlayer(pPlayer, tbSaveData)
end

function tbAct:OnAssistOk(pPlayer, nUsePlayerId)
	local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbSaveData.nAssistCount = (tbSaveData.nAssistCount or 0) + 1
    self:SaveDataToPlayer(pPlayer, tbSaveData)
    Log("[LoverRecallAct] fnOnAssistOk ok ", pPlayer.dwID, pPlayer.szName, tbSaveData.nAssistCount, nUsePlayerId);
end

function tbAct:OnSendUseMapAward(pPlayer)
	local tbMail = {
		To = pPlayer.dwID;
		Title = "Chúng ta thích giang hồ ức tình duyên";
		From = "Công Tôn tiếc hoa";
		Text = "Chúc mừng hiệp sĩ tham dự chúng ta thích giang hồ ức tình duyên hoạt động thu hoạch được ban thưởng";
		tbAttach = self.tbUseMapAward;
		nLogReazon = Env.LogWay_LoverRecallAct;
	};
	Mail:SendSystemMail(tbMail);
	Log("[QingMingAct] fnOnSendUseMapAward ok ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel)
end

function tbAct:OnSendAssistAward(pPlayer)
	local tbMail = {
		To = pPlayer.dwID;
		Title = "Chúng ta thích giang hồ ức tình duyên";
		From = "Công Tôn tiếc hoa";
		Text = "Chúc mừng hiệp sĩ tham dự chúng ta thích giang hồ ức tình duyên hoạt động thu hoạch được hiệp trợ ban thưởng";
		tbAttach = self.tbAssistAward;
		nLogReazon = Env.LogWay_LoverRecallAct;
	};
	Mail:SendSystemMail(tbMail);
	Log("[QingMingAct] fnOnSendAssistAward ok ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel)
end