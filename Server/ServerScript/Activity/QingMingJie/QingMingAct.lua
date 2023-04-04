local tbAct = Activity:GetClass("QingMingAct")
local tbMapItem = Item:GetClass("WorshipMap");

tbAct.tbTrigger  = {Init = {}, Start = {}, End = {}}

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then

	elseif szTrigger == "Start" then
		Activity:RegisterPlayerEvent(self, "Act_SendWorshipAward", "OnSendWorshipAward")
		Activity:RegisterPlayerEvent(self, "Act_SendAssistAward", "OnSendAssistAward")
		Activity:RegisterPlayerEvent(self, "Act_KinDonate", "OnKinDonate")
		Activity:RegisterPlayerEvent(self, "Act_AssistOk", "OnAssistOk")
		Activity:RegisterPlayerEvent(self, "Act_ComposeWorshipMap", "OnComposeWorshipMap")
		Activity:RegisterPlayerEvent(self, "Act_UseWorshipMap", "OnUseWorshipMap")
		Activity:RegisterPlayerEvent(self, "Act_EverydayTargetGainAward", "OnEverydayTargetGainAward")
		local _, nEndTime = self:GetOpenTimeInfo()
		-- 注册申请存库数据块,活动结束自动清掉
        self:RegisterDataInPlayer(nEndTime)
        self:FormatAward()
	elseif szTrigger == "End" then

	end
	Log("[QingMingAct] OnTrigger:", szTrigger)
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
	for _,v in pairs(self.tbDonateAward) do
		if v[1] and (v[1] == "item" or v[1] == "Item") then
			 v[4] = nEndTime
		end
	end
end

function tbAct:OnKinDonate(pPlayer, nMaxDegree, nCurDegree, nCurDonateTimes)
    local nBegin = nMaxDegree - nCurDegree - nCurDonateTimes + 1
    local nEnd = nMaxDegree - nCurDegree
    local nSendTimes = 0
    for i = nBegin, nEnd do
        if i % 5 == 0 then
            nSendTimes = nSendTimes + 1
        end
    end
    if nSendTimes <= 0 then
        return
    end
    for i = 1, nSendTimes do
    	self:TrySendClueAward(pPlayer, self.tbDonateAward, true)
    end
    Log("[QingMingAct] OnKinDonate Success:", pPlayer.dwID, nMaxDegree, nCurDegree, nCurDonateTimes, nSendTimes)
end

function tbAct:OnEverydayTargetGainAward(pPlayer, nAwardIdx)
    local tbAward = self.tbActiveAward[nAwardIdx]
    if not tbAward then
		return 
    end
    self:TrySendClueAward(pPlayer, tbAward)
end

function tbAct:TrySendClueAward(pPlayer, tbAward, bDonate)
	if not self:CheckLevel(pPlayer) then
		return
	end

	if bDonate then
		self:CheckClueAwardData(pPlayer)
		local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
		if tbSaveData.nClueCount >= self.nMaxClueDonatePerDay then
			return
		end
		tbSaveData.nClueCount = tbSaveData.nClueCount + 1
		self:SaveDataToPlayer(pPlayer, tbSaveData)
	end
	
	pPlayer.SendAward(tbAward, true, nil, Env.LogWay_QingMingAct);
	
    Log("[QingMingAct] OnEverydayTargetGainAward ok ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel, bDonate and 1 or 0)
end

function tbAct:CheckClueAwardData(pPlayer)
	local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbSaveData.nClueCount = tbSaveData.nClueCount or 0
    tbSaveData.nClueTime = tbSaveData.nClueTime or 0
    local nNowTime = GetTime()
    if Lib:IsDiffDay(self.nAssistRefreshTime, tbSaveData.nClueTime, nNowTime) then
		tbSaveData.nClueCount = 0
		tbSaveData.nClueTime = nNowTime
	end
	self:SaveDataToPlayer(pPlayer, tbSaveData)
end

local function fnAllMember(tbMember, fnSc, ...)
    for _, nPlayerId in pairs(tbMember or {}) do
        local pMember = KPlayer.GetPlayerObjById(nPlayerId);
        if pMember then
            fnSc(pMember, ...);
        end
    end
end

-- 使用地图道具
function tbAct:OnUseWorshipMap(pPlayer, pItem)
	local bRet, szMsg, pAssist = self:CheckUseWorshipMap(pPlayer, pItem);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		return
	end
	pAssist.MsgBox(string.format("Hiệp sĩ [FFFE0D]%s[-] Muốn mời ngươi tiến đến manh mối địa đồ sở tại địa, phải chăng tiến về?", pPlayer.szName),
			{
				{"Xác nhận", function () self:ConfirmUseWorshipMap(pPlayer.dwID, pAssist.dwID, pItem.dwId, true) end},
				{"Cự tuyệt", function () self:ConfirmUseWorshipMap(pPlayer.dwID, pAssist.dwID, pItem.dwId, false) end},
			});
end

function tbAct:ConfirmUseWorshipMap(nUsePlayerId, nAssistPlayerId, nItemId, bResult)
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

	local pItem = pUsePlayer.GetItemInBag(nItemId);
	if not pItem then
		pUsePlayer.CenterMsg("Đạo cụ không tồn tại!");
		return;
	end

	local bRet, szMsg, pAssist, tbMember = self:CheckUseWorshipMap(pUsePlayer, pItem, nAssistPlayerId);
	if not bRet then
		pUsePlayer.CenterMsg(szMsg);
		return;
	end

	local nMapTID = tbMapItem:GetMapTID(pItem);
	if pUsePlayer.ConsumeItem(pItem, 1, Env.LogWay_QingMingAct) ~= 1 then
		pUsePlayer.CenterMsg("Sử dụng đạo cụ thất bại!");
		return;
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
        Log("[QingMingAct] fnConfirmUseWorshipMap fnFailedCallback ", pUsePlayer.dwID, pUsePlayer.szName, pAssist.dwID, pAssist.szName, nMapTID or -1)
    end

    Fuben:ApplyFuben(nUsePlayerId, nMapTID, fnSuccessCallback, fnFailedCallback, nUsePlayerId, nAssistPlayerId, nMapTID);
    Log("[QingMingAct] fnConfirmUseWorshipMap ok ", pUsePlayer.dwID, pUsePlayer.szName, pAssist.dwID, pAssist.szName, nMapTID or -1)
end

function tbAct:CheckUseWorshipMap(pUsePlayer, pItem, nAssistPlayerId)
	local nMapTID = tbMapItem:GetMapTID(pItem);
	local tbMapSetting = self:GetMapSetting(nMapTID)
	if not tbMapSetting then
		Log("[QingMingAct] fnCheckUseWorshipMap error nMapTID?? ", pUsePlayer.dwID, pUsePlayer.szName, nMapTID or -1)
		return false, "Chưa biết cỗ";
	end

	if not self:CheckLevel(pUsePlayer) then
		return false, string.format("Người sử dụng đẳng cấp cần đạt tới %d Cấp", self.nJoinLevel)
	end

	local tbTeam = TeamMgr:GetTeamById(pUsePlayer.dwTeamID);
	if not tbTeam then
		return false, "Tạo thành hai người đội ngũ mới có thể sử dụng!";
	end

	local tbMember = tbTeam:GetMembers();
	local nTeamCount = Lib:CountTB(tbMember);
	if nTeamCount ~= 2 then
		return false, "Tạo thành hai người đội ngũ mới có thể sử dụng!";
	end

	local pAssist;
	for _, nPlayerID in pairs(tbMember) do
		local pMember = KPlayer.GetPlayerObjById(nPlayerID);
		if not pMember then
			return false, "Đối phương không tuyến bên trên, không cách nào sử dụng!"
		end
		if nPlayerID ~= pUsePlayer.dwID then
			pAssist = pMember;
		end
	end

	if not pAssist then
		return false, "Tìm không thấy ngài đồng đội"
	end

	-- 当A要B协助，发出请求后退出队伍，与C组队，这时如果B确认会直接将A和C传去扫墓
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

	if not self:CheckLevel(pAssist) then
		return false, string.format("Đồng đội cấp bậc chưa đủ %d Cấp", self.nJoinLevel)
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
    local tbSaveData = self:GetDataFromPlayer(pAssist.dwID) or {}
	if tbSaveData.nAssistCount >= self.nMaxAssistCount then
		return false, string.format("Đồng đội %s Hiệp trợ số lần không đủ", pAssist.szName)
	end

	return true, "", pAssist, tbMember;
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

function tbAct:CheckWorshipAwardData(pPlayer)
	local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbSaveData.nWorshipCount = tbSaveData.nWorshipCount or 0
    tbSaveData.nWorshipTime = tbSaveData.nWorshipTime or 0
    local nNowTime = GetTime()
    if Lib:IsDiffDay(self.nAssistRefreshTime, tbSaveData.nWorshipTime, nNowTime) then
		tbSaveData.nWorshipCount = 0
		tbSaveData.nWorshipTime = nNowTime
	end
	self:SaveDataToPlayer(pPlayer, tbSaveData)
end

-- 为玩家随好活动中可能合成的所有地图ID，避免重复
function tbAct:RandomItemMap(pPlayer)
	local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
	tbSaveData.tbUseMap = tbSaveData.tbUseMap or {}
	local tbUseMap = tbSaveData.tbUseMap
	if not next(tbUseMap) then
		local fnSelect = Lib:GetRandomSelect(#self.tbMapInfo)
		for i = 1, self.nMaxUseMap do
			table.insert(tbUseMap, self.tbMapInfo[fnSelect()].nMapTID)
		end
	end
	local nMapTID = tbUseMap[1]
	table.remove(tbUseMap, 1)
	self:SaveDataToPlayer(pPlayer, tbSaveData)
	return nMapTID
end

-- 地图道具合成
function tbAct:OnComposeWorshipMap(pPlayer)
	local bRet, szMsg = self:CheckComposeWorshipMap(pPlayer);
	if not bRet then
		pPlayer.CenterMsg(szMsg);
		return
	end

	local nConsume = pPlayer.ConsumeItemInAllPos(self.nClueItemTID, self.nClueCompose, Env.LogWay_QingMingAct);
	if nConsume < self.nClueCompose then
		pPlayer.CenterMsg("Khấu trừ đạo cụ thất bại");
		return
	end

	local _, nEndTime = self:GetOpenTimeInfo()
	local pItem = pPlayer.AddItem(self.nMapItemTID, 1, nEndTime, Env.LogWay_QingMingAct);
	local nMapTID = self:RandomItemMap(pPlayer);
	pItem.SetIntValue(tbMapItem.PARAM_MAPID, nMapTID);
	pPlayer.CenterMsg(string.format("Chúc mừng! Hợp thành【%s】", KItem.GetItemShowInfo(self.nMapItemTID, pPlayer.nFaction, pPlayer.nSex) or ""));
	Log("[QingMingAct] fnOnComposeWorshipMap ok ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel, nMapTID);
end

function tbAct:CheckComposeWorshipMap(pPlayer)
    local bRet, szMsg = pPlayer.CheckNeedArrangeBag();
    if bRet then
        return false, szMsg
    end

	local nHave = pPlayer.GetItemCountInAllPos(self.nClueItemTID);
	if nHave < self.nClueCompose then
		return false, "Ngài manh mối không đủ"
	end

	return true
end

function tbAct:OnAssistOk(pPlayer, nUsePlayerId, nMapTID)
	local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    tbSaveData.nAssistCount = (tbSaveData.nAssistCount or 0) + 1
    self:SaveDataToPlayer(pPlayer, tbSaveData)
    Log("[QingMingAct] fnOnAssistOk ok ", pPlayer.dwID, pPlayer.szName, nMapTID, tbSaveData.nAssistCount, nUsePlayerId, nMapTID);
end


function tbAct:OnSendAssistAward(pPlayer)
	local tbMail = {
		To = pPlayer.dwID;
		Title = "Tết thanh minh";
		From = "Độc Cô Kiếm";
		Text = "Chúc mừng hiệp sĩ thu hoạch được tết thanh minh hiệp trợ ban thưởng";
		tbAttach = self.tbAssistAward;
		nLogReazon = Env.LogWay_QingMingAct;
	};
	Mail:SendSystemMail(tbMail);
	Log("[QingMingAct] fnOnSendAssistAward ok ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel)
end

function tbAct:OnSendWorshipAward(pPlayer)
	self:CheckWorshipAwardData(pPlayer)
	local tbSaveData = self:GetDataFromPlayer(pPlayer.dwID) or {}
	if tbSaveData.nWorshipCount < self.nMaxWorshipPerDay then
		local tbMail = {
			To = pPlayer.dwID;
			Title = "Tết thanh minh";
			From = "Độc Cô Kiếm";
			Text = "Chúc mừng hiệp sĩ thu hoạch được tết thanh minh nhớ lại ban thưởng, nhận lấy lúc đem tự động mở ra thu hoạch được một phần ngẫu nhiên ban thưởng";
			tbAttach = self.tbWorshipAward;
			nLogReazon = Env.LogWay_QingMingAct;
		};
		Mail:SendSystemMail(tbMail);

		tbSaveData.nWorshipCount = tbSaveData.nWorshipCount + 1
		self:SaveDataToPlayer(pPlayer, tbSaveData)
		Log("[QingMingAct] fnOnSendWorshipAward ok ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel, tbSaveData.nWorshipCount)
	else
		Log("[QingMingAct] fnOnSendWorshipAward fail ", pPlayer.dwID, pPlayer.szName, pPlayer.nFaction, pPlayer.nLevel, tbSaveData.nWorshipCount)
	end
end