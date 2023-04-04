Wedding.tbWeddingTour = Wedding.tbWeddingTour or {} 					-- 所有游行逻辑
Wedding.nWeddingTourId = Wedding.nWeddingTourId or 0 					-- 递增的游行ID
Wedding.tbPlayer2TourId = Wedding.tbPlayer2TourId or {} 				-- 所有参加游行的玩家

Wedding.tbWeddingMap = Wedding.tbWeddingMap or {} 						-- 所有婚礼副本地图ID对应婚礼信息
Wedding.tbWeddingPlayer = Wedding.tbWeddingPlayer or {} 				-- 所有主角对应的副本地图ID

local tbNpcPath = {}
for _, tbPath in ipairs(Wedding.tbPath) do
	for nNcpTID, tbNpcInfo in pairs(tbPath) do
		tbNpcPath[nNcpTID] = tbNpcPath[nNcpTID] or {}
		for _, v in ipairs(tbNpcInfo) do
			table.insert(tbNpcPath[nNcpTID], v)
		end
	end
end
Wedding.tbNpcPath = tbNpcPath

Wedding.tbLoliMsg = {}
for _, nFaction in ipairs(Wedding.tbLoli) do
	Wedding.tbLoliMsg[nFaction] = Wedding.szxLoliGrowUpMsg
end

Wedding.RequestFunc =
{
	WeddingCheckNpc = true; 								-- 游城检查跟随npc
	ProposeResult = true; 									-- 求婚应答
	--CancelPropose = true; 								-- 主动取消求婚

	ChangeTitleReq = true;
	ChangeDressState = true;
	GiveCashGiftReq = true;
	UpdateCashGiftReq = true;

	ApplyEnterWedding = true; 								-- 申请进入婚礼
	SendWelcome = true; 									-- 发送请柬
	SynWelcome = true;										-- 同步婚礼副本相关的数据
	SynSchedule = true; 									-- 同步排期信息
	TryBookWedding = true;									-- 订婚礼
	TryPropose = true; 										-- 尝试发起求婚
	TrySynWeddingMap = true;								-- 同步所有正在举行的婚礼数据
	TrySendPromise = true; 									-- 山盟海誓宣誓
	TryChoosePropose = true; 								-- 打开求婚誓言界面
	TrySendCandy = true; 									-- 手动派喜糖
	TryOpenCashPanel = true; 								-- 打开礼金界面
	TryBless 		 = true; 								-- 送祝福
	GoWeddingFuben = true; 									-- 前往婚礼
	TryEatTableFood = true; 								-- 喜宴吃东西
	ClearWelcomeApply = true; 								-- 清空申请列表
	ReplayWedding = true; 									-- 回放拜堂
	TryDoubleFly = true;
}

Wedding.tbSaveCall =
{
	-- 离婚申请数据（合服需处理）
	["WeddingDismissing"] = function ()
		return ScriptData:GetValue("WeddingDismissing")
	end;
	-- 基础数据（婚礼排期控制等）
	["WWeddingSchedule"] = function ()
		return ScriptData:GetValue("WWeddingSchedule")
	end;
}

function Wedding:GetSaveData(szType)
	assert(Wedding.tbSaveCall[szType], "Save Data Call Unexist!!!")
	return Wedding.tbSaveCall[szType]()
end

function Wedding:ClientRequest(pPlayer, szFunc, ...)
	if Wedding.RequestFunc[szFunc] and Wedding[szFunc] then
		Wedding[szFunc](Wedding, pPlayer, ...)
	else
		Log("WRONG Wedding Request:", szFunc, ...);
	end
end

local function fnAllMember(tbMember, fnSc, ...)
    for _, nPlayerId in pairs(tbMember or {}) do
        local pMember = KPlayer.GetPlayerObjById(nPlayerId);
        if pMember then
            fnSc(pMember, ...);
        else
        	Log("Wedding fnAllMember Player Offline ", nPlayerId)
        end
    end
end

function Wedding:ForeachMapPlayer(nMapId, fnSc, ...)
	local tbPlayer = KPlayer.GetMapPlayer(nMapId)
	for _, pPlayer in ipairs(tbPlayer or {}) do
		fnSc(pPlayer, ...);
	end
end

function Wedding:OnLogin(pPlayer, bReconnect)
	self:AllLoginDeal(pPlayer)
	self:SynWeddingData(pPlayer)
	local tbTour = Wedding.tbWeddingTour[Wedding.tbPlayer2TourId[pPlayer.dwID]]
	if tbTour and tbTour.OnLogin then
		tbTour:OnLogin(pPlayer)
	end
	Wedding.tbDoubleFly:OnLogin(pPlayer)

	if bReconnect then
		self:ChangeDressState(pPlayer, false);
	end
	Lib:CallBack({Wedding.TryFixMarriageTitle, Wedding, pPlayer})
end

-- 玩家登陆需要进行的操作
function Wedding:AllLoginDeal(pPlayer)
	self:BreakPropose(pPlayer)
end

-- 好友数据回调
function Wedding:OnLoadFriendDataFinish(pPlayer)
	local nSex = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyGender);
	-- 对方申请取消订婚关系或者离婚时玩家不在线登陆后清理玩家身上的数据
	if Wedding:IsSingle(pPlayer) and nSex > 0 then
		self:ClearPlayerData(pPlayer)
		local nLover = KFriendShip.GetMarriageRelationRoleId(pPlayer.dwID) or 0
		local tbFriendData, nWeddingState
		if nLover > 0 then
			tbFriendData = FriendShip.fnGetFriendData(pPlayer.dwID, nLover);
			nWeddingState = tbFriendData and tbFriendData[FriendShip:WeddingStateType()]
		end
		
		Log("Wedding ClearPlayerData Delay", pPlayer.dwID, pPlayer.szName, nSex, nLover or -1, tbFriendData and 1 or 0, nWeddingState or -1)
	end
	local tbState = {Wedding.State_Engaged, Wedding.State_Marry}
	for _, nState in ipairs(tbState) do
		local tbSetting = Wedding.tbOperationSetting[nState]
		if tbSetting then
			local nStatePlayerId = tbSetting.fnGet(pPlayer)
			-- 无关系却存在称号说明对方取消关系时玩家不在线
			if not nStatePlayerId and PlayerTitle:GetPlayerTitleByID(pPlayer, tbSetting.nTitleId) then
				pPlayer.DeleteTitle(tbSetting.nTitleId)
				Log("Wedding Delete Engaged Title Delay", pPlayer.dwID, pPlayer.szName, nSex)
			end
		end
	end

    local nLover = Wedding:GetLover(pPlayer.dwID)
    if nLover then
		local tbRoleStayInfo = KPlayer.GetRoleStayInfo(nLover)
		local nSex = pPlayer.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
		local tbTitle = {"Nương Tử", "Phu Quân"}		-- 对方称谓，所以跟自身性别相反

		Item:SetEquipPosString(pPlayer, Item.EQUIPPOS_RING, string.format("「%s」%s", tbTitle[nSex] or "", tbRoleStayInfo.szName))
    end

    self:_CheckSendMemorialMail(pPlayer)
	if not self:GetWeddingMapLevel(pPlayer.nMapTemplateId) then
		self:ChangeDressState(pPlayer, false)
	end
	self:_CheckSendDismissingNotice(pPlayer)
end

function Wedding:ClearPlayerData(pPlayer)
	pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyGender, 0);
	Log("Wedding fnClearPlayerData ", pPlayer.dwID, pPlayer.szName)
end

function Wedding:OnLogout(pPlayer)
	local tbTour = Wedding.tbWeddingTour[Wedding.tbPlayer2TourId[pPlayer.dwID]]
	if tbTour and tbTour.OnLogout then
		tbTour:OnLogout(pPlayer)
	end
	-- 处理求婚过程中掉线
	self:BreakPropose(me)
end

function Wedding:OnEnterMap(nMapTemplateId)
	if nMapTemplateId == Wedding.nTourMapTemplateId then
		self:SynWeddingData(me, true)
	end
end

function Wedding:OnLeaveMap(nMapTemplateId)
	-- 处理求婚过程中离开切地图
	self:BreakPropose(me)
	self.tbDoubleFly:OnLeaveMap(me)
end

function Wedding:DoDaily()
	Lib:CallBack({Wedding.CheckScheduleOverdue, Wedding});
	Lib:CallBack({Wedding.CheckBookMail, Wedding});
	Lib:CallBack({Wedding.LogScheduleData, Wedding});

	self:_CheckDismiss()
	self:_SendMemorialMails()
	self:_CheckRemoveCashGiftCache()
end

function Wedding:GetWeddingMapSetting(nLevel)
	return Wedding.tbWeddingLevelMapSetting[nLevel]
end

-- 同步结婚相关数据
function Wedding:SynLoveData(pPlayer)

end

-- 检查队伍当中只有夫妻两人
function Wedding:CheckLoveTeam(pPlayer, bNeedCaptain)
	local nLove = self:GetLover(pPlayer.dwID)
	local pLover = KPlayer.GetPlayerObjById(nLove or 0)
	if not pLover then
		return false, "Hôn nhân đại sự là quyết định quan trọng, hãy lập tổ đội 2 người rồi đến gặp ta"
	end
	local tbTeam = TeamMgr:GetTeamById(pPlayer.dwTeamID);
	if not tbTeam then
		return false, "Hôn nhân đại sự là quyết định quan trọng, hãy lập tổ đội 2 người rồi đến gặp ta";
	end

	if bNeedCaptain and tbTeam:GetCaptainId() ~= pPlayer.dwID then
		return false, "Đại sự như vậy hãy để đội trưởng thao tác"
	end

	local tbMember = tbTeam:GetMembers();
	local nTeamCount = Lib:CountTB(tbMember);
	if nTeamCount ~= 2 then
		return false, "Hôn nhân đại sự là quyết định quan trọng, hãy lập tổ đội 2 người rồi đến gặp ta";
	end

	local tbPlayerId = {}
	for _, nPlayerId in pairs(tbMember) do
		tbPlayerId[nPlayerId] = true
	end

	if not tbPlayerId[nLove] then
		return false, "Hôn nhân đại sự là quyết định quan trọng, hãy lập tổ đội 2 người rồi đến gặp ta"
	end
	return true
end

-- 检查队伍当中只有夫妻两人
function Wedding:CheckEngagedTeam(pPlayer, bNeedCaptain)
	local nEngaged = self:GetEngaged(pPlayer.dwID)
	local pEngageder = KPlayer.GetPlayerObjById(nEngaged or 0)
	if not pEngageder then
		return false, "Hôn nhân đại sự là quyết định quan trọng, hãy lập tổ đội 2 người rồi đến gặp ta"
	end
	local tbTeam = TeamMgr:GetTeamById(pPlayer.dwTeamID);
	if not tbTeam then
		return false, "Hôn nhân đại sự là quyết định quan trọng, hãy lập tổ đội 2 người rồi đến gặp ta";
	end

	if bNeedCaptain and tbTeam:GetCaptainId() ~= pPlayer.dwID then
		return false, "Đại sự như vậy hãy để đội trưởng thao tác"
	end

	local tbMember = tbTeam:GetMembers();
	local nTeamCount = Lib:CountTB(tbMember);
	if nTeamCount ~= 2 then
		return false, "Hôn nhân đại sự là quyết định quan trọng, hãy lập tổ đội 2 người rồi đến gặp ta";
	end

	local tbPlayerId = {}
	for _, nPlayerId in pairs(tbMember) do
		tbPlayerId[nPlayerId] = true
	end

	if not tbPlayerId[nEngaged] then
		return false, "Hôn nhân đại sự là quyết định quan trọng, hãy lập tổ đội 2 người rồi đến gặp ta"
	end
	return pEngageder
end

-- 》》结婚相关
function Wedding:Marry()

end

function Wedding:IsPlayerTouring(dwID)
	return Wedding.tbPlayer2TourId[dwID]
end

function Wedding:IsPlayerMarring(dwID)
	return Wedding.tbWeddingPlayer[dwID]
end

-- 》》游城相关
function Wedding:StartWeddingTour(pBoy, pGirl, nBookLevel)
	if pBoy.nMapTemplateId ~= Wedding.nTourMapTemplateId or pGirl.nMapTemplateId ~= Wedding.nTourMapTemplateId then
		Log("Wedding fnStartWeddingTour Player Offline", pBoy.dwID, pGirl.dwID, pBoy.nMapTemplateId, pGirl.nMapTemplateId)
		return
	end
	local tbTour = Lib:NewClass(self.WeddingTourBase);	-- 创建活动数据对象
	local nTourId = self:GetNextWeddingTourId()
	Wedding.tbWeddingTour[nTourId] = tbTour
	Wedding.tbPlayer2TourId[pBoy.dwID] = nTourId
	Wedding.tbPlayer2TourId[pGirl.dwID] = nTourId
	tbTour:StartTour(pBoy, pGirl, nTourId, nBookLevel)
	pBoy.SetDelayLogoutTime(Wedding.nTourDelayOfflineTime)
	pGirl.SetDelayLogoutTime(Wedding.nTourDelayOfflineTime)
	local function fnSynData(pPlayer)
       Wedding:SynWeddingData(pPlayer)
    end
	 Wedding:ForeachMapPlayer(Wedding.nTourMapTemplateId, fnSynData)
	Log("Wedding fnStartWeddingTour ", pBoy.dwID, pGirl.dwID, nTourId)
end

function Wedding:GetNextWeddingTourId()
	Wedding.nWeddingTourId = Wedding.nWeddingTourId + 1
	return Wedding.nWeddingTourId
end

function Wedding:ClearCacheData(nPlayerId)
	Wedding.tbWeddingTour[Wedding.tbPlayer2TourId[nPlayerId]] = nil
	Wedding.tbPlayer2TourId[nPlayerId] = nil
end

-- 》》拜堂相关

function Wedding:WeddingCheckNpc(pPlayer, nNpcId)
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc then
		return
	end

	local tbTour = Wedding.tbWeddingTour[Wedding.tbPlayer2TourId[pPlayer.dwID]]
	if tbTour and tbTour.WeddingCheckNpc then
		tbTour:WeddingCheckNpc(pPlayer, nNpcId)
	end
end

function Wedding:GoWeddingFuben(pPlayer, nMapId)
	local bRet, szMsg = self:CheckBeforeGo(pPlayer, nMapId)
	if not bRet then
		pPlayer.CenterMsg(szMsg)
		return
	end

	pPlayer.SwitchMap(nMapId, 0, 0)
end

function Wedding:GoPlayerWeddingFuben(pPlayer, nTargetId)
	local nMapId = Wedding.tbWeddingPlayer[nTargetId]
	if not nMapId then
		pPlayer.CenterMsg("Hôn lễ đã kết thúc")
		return
	end
	local bRet, szMsg = self:CheckBeforeGo(pPlayer, nMapId)
	if not bRet then
		pPlayer.CenterMsg(szMsg)
		return
	end
	pPlayer.SwitchMap(nMapId, 0, 0)
end

function Wedding:CheckBeforeGo(pPlayer, nMapId)
	local tbInst = Fuben.tbFubenInstance[nMapId]
	if not Wedding.tbWeddingMap[nMapId] or not tbInst then
		return false, "Hôn lễ đã kết thúc"
	end
	if Wedding:CheckWeddingOver(nMapId) then
		return false, "Hôn lễ đã kết thúc"
	end
	if pPlayer.nMapId == nMapId then
		return false, "Ngươi đã ở trong hôn lễ"
	end
	if pPlayer.nState ~= Player.emPLAYER_STATE_NORMAL then
 	   return false, "Trạng thái hiện tại không thể vào hôn lễ"
	end
	if not Fuben.tbSafeMap[pPlayer.nMapTemplateId] and Map:GetClassDesc(pPlayer.nMapTemplateId) ~= "fight" and not Wedding:GetWeddingMapLevel(pPlayer.nMapTemplateId) then
		return false, "Bản đồ hiện tại không thể vào hôn lễ";
	end
	if Map:GetClassDesc(pPlayer.nMapTemplateId) == "fight" and pPlayer.nFightMode ~= 0 then
  		return false, "Hãy về khu an toàn để tham gia hôn lễ"
   	end

	-- 暂不做限制
	-- local nPlayerCount = tbInst.nPlayerCount or 0
	-- if nPlayerCount >= tbInst.nMaxPlayer then
	-- 	return false, "婚礼已经达到最大参加人数"
	-- end

	return true
end

function Wedding:CreateWeddingFuben(pBoy, pGirl, nLevel)
	if Wedding.tbWeddingPlayer[pBoy.dwID] or Wedding.tbWeddingPlayer[pGirl.dwID] then
		Log("Wedding fnGoWeddingFuben repeat data ??", pBoy.dwID, pGirl.dwID, nLevel)
		return false, "Đã tổ chức đám cưới? ?"
	end
	local tbSetting = self:GetWeddingMapSetting(nLevel)
	local nMapTID  = tbSetting and tbSetting.nMapTID
	if not nMapTID then
		Log("Wedding fnGoWeddingFuben no  nMapTID", pBoy.dwID, pGirl.dwID, nLevel)
		return false, "Không thể tìm thấy cấu hình đám cưới có liên quan??"
	end

	local tbMember = {pBoy.dwID, pGirl.dwID}
	local function fnSuccessCallback(nMapId)
		Lib:LogTB(tbMember)
        local function fnSucess(pPlayer, nMapId)
            pPlayer.SetEntryPoint();
            pPlayer.SwitchMap(nMapId, 0, 0);
            Log("Wedding fnGoWeddingFuben Pre", pPlayer.dwID, pPlayer.szName, nMapId, nLevel)
        end
        fnAllMember(tbMember, fnSucess, nMapId);
    end

    local function fnFailedCallback()
    	local function fnMsg(pPlayer, szMsg)
		    pPlayer.CenterMsg(szMsg);
		end
        fnAllMember(tbMember, fnMsg, "Không thể tạo một phó bản, vui lòng thử lại sau!");
        Log("Wedding fnGoWeddingFuben fnFailedCallback ", pBoy.dwID, pGirl.dwID, nLevel, nMapTID)
    end

    Fuben:ApplyFuben(pBoy.dwID, nMapTID, fnSuccessCallback, fnFailedCallback, pBoy.dwID, pGirl.dwID, nLevel);
    Log("Wedding fnGoWeddingFuben ok ", pBoy.dwID, pBoy.szName, pGirl.dwID, pGirl.szName, nLevel, nMapTID)
    return true
end

function Wedding:OnCreateFuben(nBoyPlayerId, nGirlPlayerId, nMapId, nLevel, nStartWeddingTime)
	Wedding.tbWeddingMap[nMapId] = {tbPlayer = {nBoyPlayerId, nGirlPlayerId}, nLevel = nLevel, nStartWeddingTime = nStartWeddingTime}
	Wedding.tbWeddingPlayer[nBoyPlayerId] = nMapId
	Wedding.tbWeddingPlayer[nGirlPlayerId] = nMapId

end

function Wedding:OnCloseFuben(nMapId)
	local tbPlayer = Wedding.tbWeddingMap[nMapId] and Wedding.tbWeddingMap[nMapId].tbPlayer
	if not tbPlayer then
		return
	end

	Wedding.tbWeddingMap[nMapId] = nil
	for _, dwID in ipairs(tbPlayer) do
		Wedding.tbWeddingPlayer[dwID] = nil
	end
end

-- 同步音乐婚礼气氛等数据
function Wedding:SynWeddingData(pPlayer, bForce)
	if pPlayer.nMapTemplateId ~= Wedding.nTourMapTemplateId and not bForce then
		return
	end
	local tbData = {}
	tbData.tbSound = {}
	tbData.tbOverdueSound = {}
	local tbSchedule = self:GetSaveData("WWeddingSchedule")
	local nTourTime = tbSchedule.nTourTime or 0
	local bWedding
	local bTouring = next(Wedding.tbPlayer2TourId) and true or false
	if bTouring then
		table.insert(tbData.tbSound, Map.WEDDING_TOUR)
	else
		table.insert(tbData.tbOverdueSound, Map.WEDDING_TOUR)
	end
	if GetTime() < nTourTime + Wedding.nWeddingFeelDay  then
		table.insert(tbData.tbSound, Map.WEDDING_TOUR_AFTER)
		bWedding = true
	else
		table.insert(tbData.tbOverdueSound, Map.WEDDING_TOUR_AFTER)
	end
	local tbTourPlayer
	for nSex, dwID in ipairs(tbSchedule.tbTourPlayer or {}) do
		local pStayInfo = KPlayer.GetPlayerObjById(dwID) or KPlayer.GetRoleStayInfo(dwID)
		tbTourPlayer = tbTourPlayer or {}
		tbTourPlayer[nSex] = tbTourPlayer[nSex] or {}
		tbTourPlayer[nSex].szName = pStayInfo and pStayInfo.szName
	end
	pPlayer.CallClientScript("Wedding:SynData", tbData, bWedding, tbTourPlayer, bTouring)
end
--[[
Wedding.tbWeddingMap = {}
for i=1,250 do
	local nMapId = 10000000+i
	Wedding.tbWeddingMap[nMapId] = {}
	Wedding.tbWeddingMap[nMapId].tbPlayer = {1048591, 1048584}
	Wedding.tbWeddingMap[nMapId].nLevel = i
	Wedding.tbWeddingMap[nMapId].nStartWeddingTime = 10000000+i
end
local nSize, nCompressed = GetTableSize(Wedding.tbWeddingMap)
*目前最大250条左右会超限制
*后面更改同步数据接口时记得相应的修改同步数量
]]
function Wedding:TrySynWeddingMap(pPlayer)
	self:SynWeddingMap(pPlayer)
	pPlayer.CallClientScript("Wedding:OnSynWeddingMapFinish")
end

-- 婚礼是否结束
function Wedding:CheckWeddingOver(nMapId)
	local tbInst = Fuben.tbFubenInstance[nMapId]
	if tbInst and tbInst.nProcess ~= Wedding.PROCESS_END then
		return false
	end
	return true
end

-- 同步所有婚礼信息
function Wedding:SynWeddingMap(pPlayer)
	local nMaxCount = 100 												-- 每100条分包
	local bMerge
	local tbData = {}
	for nMapId, v in pairs(Wedding.tbWeddingMap) do
		if not Wedding:CheckWeddingOver(nMapId) then
			local tbMapInfo = {}
			tbMapInfo.nMapId = nMapId
			tbMapInfo.nLevel = v.nLevel
			tbMapInfo.nStartWeddingTime = v.nStartWeddingTime
			tbMapInfo.tbPlayer = {}
			for nSex, dwID in ipairs(v.tbPlayer) do
				local pStayInfo = KPlayer.GetPlayerObjById(dwID) or KPlayer.GetRoleStayInfo(dwID)
				tbMapInfo.tbPlayer[nSex] =
				{
					dwID = dwID;
					szName = pStayInfo and pStayInfo.szName;
				}
			end
			table.insert(tbData, tbMapInfo)
			if #tbData >= nMaxCount then
				pPlayer.CallClientScript("Wedding:OnSynWeddingMap", tbData, bMerge)
				tbData = {}
				bMerge = true
			end
		end
	end
	pPlayer.CallClientScript("Wedding:OnSynWeddingMap", tbData, bMerge)
end
--[[
local nNowTime = GetTime()
local tbData = {}
for i=1,300 do
	local tbApplyInfo = {
				nPlayerId = 104858000 + i;
				szName = "这是八个字吗我说";
				nHonorLevel = 10 + i;
				nPortrait = 10 + i;
				szKinName = "这是八个字吗我说";
				nApplyTime = nNowTime;
			}
	table.insert(tbData, tbApplyInfo)
end
local nSize, nCompressed = GetTableSize(tbData)
me.CallClientScript("Wedding:OnSynWeddingApply", tbData)
*目前最大300条左右会超限制
*后面更改同步数据接口时记得相应的修改同步数量
]]

-- 同步婚礼副本相关的数据
function Wedding:SynWelcome(pPlayer)
	self:SynWeddingApply(pPlayer)
	self:SynWeddingWelcome(pPlayer)
	pPlayer.CallClientScript("Wedding:OnSynWelcome")
end

-- 同步申请者信息
function Wedding:SynWeddingApply(pPlayer, tbApply, bMerge)
	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst then
		return
	end
	local tbApply = tbApply or tbInst:GetApplyWelcome(pPlayer)
	if not tbApply then
		return
	end
	local nMaxCount = 100 												-- 每100条分包
	local bMerge = bMerge
	local tbData = {}
	for dwID, v in pairs(tbApply) do
		local pPlayer = KPlayer.GetPlayerObjById(dwID)
		-- 过滤不在线的玩家
		if pPlayer then
			local pKinData = Kin:GetKinById(pPlayer.dwKinId or 0) or {};
			local tbApplyInfo = {
				nPlayerId = dwID;
				szName = pPlayer.szName;
				nHonorLevel = pPlayer.nHonorLevel;
				nPortrait = pPlayer.nPortrait;
				szKinName = pKinData.szName;
				nApplyTime = v.nApplyTime;
				nFaction = pPlayer.nFaction;
				nLevel = pPlayer.nLevel;
				nVipLevel = pPlayer.GetVipLevel();

			}
			table.insert(tbData, tbApplyInfo)
			if #tbData >= nMaxCount then
				pPlayer.CallClientScript("Wedding:OnSynWeddingApply", tbData, bMerge)
				tbData = {}
				bMerge = true
			end
		end
	end
	pPlayer.CallClientScript("Wedding:OnSynWeddingApply", tbData, bMerge)
end

-- 同步请柬相关数据
function Wedding:SynWeddingWelcome(pPlayer)
	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst then
		return
	end
	tbInst:SynWelcome(pPlayer)
end

-- 申请进入婚礼现场
function Wedding:ApplyEnterWedding(pPlayer, nMapId)
	local tbInst = Fuben.tbFubenInstance[nMapId]
	if not tbInst then
		pPlayer.CenterMsg("Hôn lễ đã kết thúc", true)
		return
	end
	if Wedding:CheckWeddingOver(nMapId) then
		pPlayer.CenterMsg("Hôn lễ đã kết thúc")
		return
	end
	tbInst:ApplyWelcome(pPlayer)
end

-- 发送请柬
function Wedding:SendWelcome(pPlayer, nType, nInviteId)

	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst then
		pPlayer.CenterMsg("Xin hãy thao tác trong hôn lễ", true)
		return
	end
	if Wedding:CheckWeddingOver(pPlayer.nMapId) then
		pPlayer.CenterMsg("Hôn lễ đã kết thúc")
		return
	end
	tbInst:TrySendWelcome(pPlayer, nType, nInviteId)
end

function Wedding:TrySendPromise(pPlayer, szMsg)
	if not szMsg or szMsg == "" then
		return
	end
	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst then
		pPlayer.CenterMsg("Xin hãy thao tác trong hôn lễ", true)
		return
	end
	tbInst:TryPromise(pPlayer.dwID, szMsg)
end

--》》 求婚相关
function Wedding:TryDelEngaged(pPlayer)
	local nEngaged = Wedding:GetEngaged(pPlayer.dwID)
	if not nEngaged then
		pPlayer.CenterMsg("Tha thứ ta nói thẳng, ngươi hiện là thằng FA ")
		return
	end
	local szSchduleTip = "."
	local nBookLevel, tbPlayerBookInfo, nOpen = self:CheckPlayerHadBook(pPlayer.dwID)
	if nBookLevel then
		local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nBookLevel]
		local szWeddingName = tbMapSetting and tbMapSetting.szWeddingName or "婚禮"
		szSchduleTip = string.format(", Hôn lễ [FFFE0D]%s[-] của các ngươi đã bị hủy.", szWeddingName)
	end
	local nNowTime = GetTime()
	Wedding:ClearPlayerBook(pPlayer.dwID)
	Wedding:ClearPlayerBook(nEngaged)
	local bRet = KFriendShip.SetFriendShipVal(pPlayer.dwID, nEngaged, FriendShip:WeddingStateType(), Wedding.State_None);
	self:DoDelEngaged(pPlayer)
	local pEngaged = KPlayer.GetPlayerObjById(nEngaged)
	local nPlayerSex = pPlayer.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
	local nEngagedSex = 0
	if pEngaged then
		nEngagedSex = pEngaged.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
		self:DoDelEngaged(pEngaged)
		pEngaged.TLog("WeddingFlow", Wedding.nOperationType_CancelPropose, 0, pPlayer.dwID, 0, nEngagedSex, nPlayerSex, nNowTime, pPlayer.dwID)
	end
	-- 玩家不在线时每次登陆检测玩家状态进行删除
	pPlayer.SendBlackBoardMsg("Hủy quan hệ đính hôn thành công", true)
	local tbMail = {
		To = nEngaged;
		Title = "Thông báo hủy đính hôn";
		From = "Hồng Nương";
		Text = string.format("     「%s」đã hủy quan hệ đính hôn với %s\n    [C8FF00]Tình này ôn lại còn thương cảm, một thuở đau lòng chữ nợ duyên[-], kiếp này chưa thể bên nhau, tin rằng phía trước có người thích hợp hơn đang chờ!", pPlayer.szName, szSchduleTip);
		nLogReazon = Env.LogWay_Wedding;
	};
	Mail:SendSystemMail(tbMail);
	Log("Wedding fnTryDelEngaged ok ", pPlayer.dwID, pPlayer.szName, nEngaged, pEngaged and pEngaged.szName or "delay", bRet and "yes" or "no")
	pPlayer.TLog("WeddingFlow", Wedding.nOperationType_CancelPropose, 0, nEngaged, 0, nPlayerSex, nEngagedSex, nNowTime, pPlayer.dwID)
end

function Wedding:DoDelEngaged(pPlayer)
	pPlayer.DeleteTitle(Wedding.ProposeTitleId)
	self:ClearPlayerData(pPlayer)
	Log("Wedding fnDoDelEngaged ok ", pPlayer.dwID, pPlayer.szName)
end

-- 求婚者主动取消求婚(目前不需要主动取消，先放着)
function Wedding:CancelPropose(pPlayer, nBeProposeId)
	pPlayer.tbPropose = pPlayer.tbPropose or {}
	local nProposeTime = pPlayer.tbPropose[nBeProposeId] and pPlayer.tbPropose[nBeProposeId].nProposeTime
	if not nProposeTime or (GetTime() - nProposeTime > Wedding.nProposeDecideTime) then
		pPlayer.CenterMsg("Yêu cầu đối tượng cầu hôn", true)
		return
	end

	pPlayer.tbPropose[nBeProposeId] = nil
	pPlayer.nProposeTime = nil
	pPlayer.CallClientScript("Wedding:OnCancelPropose")
	pPlayer.SendBlackBoardMsg("Ngươi chủ động hủy bỏ cầu hôn", true)

	local pBeProposer = KPlayer.GetPlayerObjById(nBeProposeId)
	if pBeProposer then
		pBeProposer.nBeProposeTime = nil
		pBeProposer.CallClientScript("Wedding:OnCancelPropose")
		pBeProposer.SendBlackBoardMsg("Đối phương chủ động hủy bỏ cầu hôn", true)
	end

end

-- 尝试求婚
function Wedding:TryPropose(pPlayer, nProposeIndex)
	if not Wedding.tbProposePromise[nProposeIndex] then
		pPlayer.CenterMsg("Yêu cầu ngươi ghi ngôn thệ", true)
		return
	end
	local bRet, szMsg, pAccept = self:CheckPropose(pPlayer)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return
	end

	local nTime = GetTime()
	pPlayer.tbPropose = pPlayer.tbPropose or {}
	pPlayer.tbPropose[pAccept.dwID] = {nProposeTime = nTime}                    -- 对谁发起求婚
    pAccept.tbBePropose = pAccept.tbBePropose or {}
    pAccept.tbBePropose[pPlayer.dwID] = {nBeProposeTime = nTime}                -- 谁对你发起求婚
	pAccept.nBeProposeTime = nTime                                         -- 被求婚时间
	pPlayer.nProposeTime = nTime                                                -- 求婚时间

	local nMeNpcId = pPlayer.GetNpc().nId
	local nAcceptNpcId = pAccept.GetNpc().nId
	pPlayer.CallClientScript("Wedding:Propose", pAccept.dwID, nAcceptNpcId, pAccept.szName, nProposeIndex)
	pAccept.CallClientScript("Wedding:BePropose", pPlayer.dwID, nMeNpcId, pPlayer.szName, nProposeIndex)
end

function Wedding:TryChoosePropose(pPlayer)
	local bRet, szMsg, pAccept = self:CheckPropose(pPlayer)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return
	end
	pPlayer.CallClientScript("Wedding:OnChoosePropose", pAccept.szName)
end

function Wedding:CheckPropose(pPlayer)
	local bRet, szMsg = Wedding:CheckProposeC(pPlayer)
	if not bRet then
		return false, szMsg
	end

	if pPlayer.dwTeamID == 0 then
        return false, "Yêu cầu [FFFE0D]tổ đội[-] cùng [FFFE0D]2 người[-] thành đội ngũ"
    end

    local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, "Yêu cầu [FFFE0D]tổ đội[-] cùng [FFFE0D]2 người[-] thành đội ngũ"
    end

    local pAccept

    local tbSecOK = {}
    for nIdx, nPlayerId in ipairs(tbMember) do
     	local pMember = KPlayer.GetPlayerObjById(nPlayerId)
        if not pMember then
            return false, "Người chơi đã offline"
        end

        if pMember.nLevel < Wedding.nProposeLevel then
			return false, string.format("[FFFE0D]「%s」[-]chưa đủ %d cấp", pMember.szName, Wedding.nProposeLevel)
		end

        if not Wedding:IsSingle(pMember) then
            return false, string.format("[FFFE0D]「%s」[-] đã kết hôn hoặc đã có hôn ước khác", pMember.szName)
        end

        if not Map:IsCityMap(pMember.nMapTemplateId) and not Map:IsKinMap(pMember.nMapTemplateId) and not Map:IsHouseMap(pMember.nMapTemplateId) then
            return false, string.format("[FFFE0D]「%s」[-] khu vực này không thể cầu hôn, hãy đến [FFFE0D]Vong Ưu Đảo, Tương Dương, Gia Viên hoặc Bang Hội[-] để tiến hành行", pMember.szName)
        end

		if pMember.dwID ~= pPlayer.dwID then
        	pAccept = pMember
        end

        tbSecOK[nIdx] = pMember.nSex;
    end

    if not pAccept then
    	return false, "Tìm không thấy người chơi "
    end

    if tbSecOK[1] == tbSecOK[2] then
        return false, "Yêu cầu [FFFE0D]tổ đội[-] cùng [FFFE0D]2 người[-] thành đội ngũ"
    end

    if not FriendShip:IsFriend(pPlayer.dwID, pAccept.dwID) then
        return false, "Các ngươi không phải là hảo hữu"
    end

    local nImityLevel = FriendShip:GetFriendImityLevel(pPlayer.dwID, pAccept.dwID) or 0
	if nImityLevel < Wedding.nProposeImitity then
		return false, string.format("Yêu cầu độ thân mật đạt tới[FFFE0D] %s [-]cấp", Wedding.nProposeImitity)
	end

	local nMapId1, nX1, nY1 = pPlayer.GetWorldPos()
    local nMapId2, nX2, nY2 = pAccept.GetWorldPos()
    local fDists = Lib:GetDistsSquare(nX1, nY1, nX2, nY2)
    if fDists > (Wedding.MIN_PROPOSE_DISTANCE * Wedding.MIN_PROPOSE_DISTANCE) or nMapId1 ~= nMapId2 then
        return false, "Các ngươi ở cách xa nhau quá, không thể cầu hôn"
    end

    local nNowTime = GetTime()

    pPlayer.tbPropose = pPlayer.tbPropose or {}
    if Wedding:IsBeProposing(pAccept) then
        return false, "Đối phương đang bị người khác cầu hôn"
    end
    -- 有没有对该人发起求婚
    if pPlayer.tbPropose[pAccept.dwID] and nNowTime - pPlayer.tbPropose[pAccept.dwID].nProposeTime <= Wedding.nProposeDecideTime then
    	return false, "Đã bắt đầu cầu hôn"
    end

    if pAccept.nBeProposeTime and nNowTime - pAccept.nBeProposeTime <= Wedding.nProposeDecideTime then
    	return false, "Đối phương đang bị ngươi cầu hôn"
    end
    -- 防止一人同时对多人求婚
    if Wedding:IsProposing(pPlayer) then
        return false, "Vui lòng hoàn thành đề xuất hiện tại"
    end

    if Wedding:IsBeProposing(pPlayer) then
        return false, "Ngài đang bị cầu hôn "
    end

    if Wedding:IsProposing(pAccept) then
        return false, "Bên kia đang cầu hôn."
    end

	return true, nil, pAccept
end

-- 被求婚者或者系统回应求婚结果
function Wedding:ProposeResult(pPlayer, nProposeId, nWilling)
	if not nProposeId then
		return
	end
	local pProposer = KPlayer.GetPlayerObjById(nProposeId)
	if not pProposer then
		pPlayer.CenterMsg("Đối phương cự tuyệt", true)
		pPlayer.CallClientScript("Wedding:OnProposeResult")
		return
	end
	pProposer.tbPropose = pProposer.tbPropose or {}
	local nProposeTime = pProposer.tbPropose[pPlayer.dwID] and pProposer.tbPropose[pPlayer.dwID].nProposeTime
	if not nProposeTime then
		pPlayer.CenterMsg("Đối phương không nhận cầu hôn với ngươi", true)
		pPlayer.CallClientScript("Wedding:OnProposeResult")
		return
	end
	local function fnMsg(pPlayer, szMsg)
	    pPlayer.SendBlackBoardMsg(szMsg, true);
	end
	local tbPlayer = {pPlayer.dwID, nProposeId}

	local tbAllPlayer = {pPlayer, pProposer}
	for _, pP in ipairs(tbAllPlayer) do
		 if not Wedding:IsSingle(pP) then
		 	fnAllMember(tbPlayer, fnMsg, string.format("[FFFE0D]「%s」[-] đã thành hôn hoặc có hôn ước khác", pP.szName));
		 	return
		 end
	end
	local bOk
	local nNowTime = GetTime()
	local nPassTime = nNowTime - nProposeTime
	if nWilling == Wedding.PROPOSE_OK then
		if nPassTime <= Wedding.nProposeDecideTime then
			local nPlayerSex = pPlayer.nSex;
			local nProposeSex = pProposer.nSex;
			if not nPlayerSex or not nProposeSex or nPlayerSex == nProposeSex then
				fnAllMember(tbPlayer, fnMsg, "2 người phải khác giới mới phối hợp được");
				return
			end
	        if pProposer.ConsumeItemInAllPos(Wedding.ProposeItemId, 1, Env.LogWay_Wedding) < 1 then
	        	fnAllMember(tbPlayer, fnMsg, "Khấu trừ đạo cụ thất bại, xin vui lòng thử lại");
	            return
	        end
	        bOk = true
	      	pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyGender, nPlayerSex);
	      	pProposer.SetUserValue(self.nSaveGrp, self.nSaveKeyGender, nProposeSex);

	      	local bRet = KFriendShip.SetFriendShipVal(pProposer.dwID, pPlayer.dwID, FriendShip:WeddingStateType(), Wedding.State_Engaged);

	        local tbSuffix = {[Gift.Sex.Boy] = "Hôn Thê", [Gift.Sex.Girl] = "Hôn Phu"}
	        pPlayer.AddTitle(Wedding.ProposeTitleId, -1, true, false, string.format("%s %s", pProposer.szName, tbSuffix[nProposeSex]));
	        pProposer.AddTitle(Wedding.ProposeTitleId, -1, true, false, string.format("%s %s", pPlayer.szName, tbSuffix[nPlayerSex]));

			pPlayer.SendBlackBoardMsg(Wedding.szBeProposeSuccessTip, true)
			pProposer.SendBlackBoardMsg(Wedding.szProposeSuccessTip, true)
			KPlayer.SendWorldNotify(1, 999, string.format(Wedding.szProposeSuccessNotify, pProposer.szName, pPlayer.szName), 1, 1)
			Log("Wedding Propose Ok ", pPlayer.dwID, pPlayer.szName, nPlayerSex, pProposer.dwID, pProposer.szName, nProposeSex, bRet and 1 or 0)
			pPlayer.TLog("WeddingFlow", Wedding.nOperationType_Propose, 0, pProposer.dwID, 0, nPlayerSex, nProposeSex, nNowTime, pPlayer.dwID)
			pProposer.TLog("WeddingFlow", Wedding.nOperationType_Propose, 0, pPlayer.dwID, 0, nProposeSex, nPlayerSex, nNowTime, pPlayer.dwID)
		else
			pPlayer.CenterMsg("Đã hết thời gian", true)
		end
	elseif nWilling == Wedding.PROPOSE_REFUSE then
		if nPassTime <= Wedding.nProposeDecideTime then
			pPlayer.SendBlackBoardMsg(string.format(Wedding.szBeProposeFailTip, pProposer.szName), true)
			pProposer.SendBlackBoardMsg(string.format(Wedding.szProposeFailTip, pPlayer.szName), true)
		end
	elseif nWilling == Wedding.PROPOSE_CANCEL then
		fnAllMember(tbPlayer, fnMsg, "Cầu hôn quá thời gian, hệ thống tự động cự tuyệt ");
	else
		return
	end
	Wedding:ClearPropose(pProposer, pPlayer.dwID)
	Wedding:ClearBePropose(pPlayer, pProposer.dwID)

	pPlayer.CallClientScript("Wedding:OnProposeResult", bOk)
	pProposer.CallClientScript("Wedding:OnProposeResult", bOk)
	Log("[Wedding] fnProposeResult >", pPlayer.dwID, pPlayer.szName, pProposer.dwID, pProposer.szName, nWilling or -1, nPassTime)
end

-- 是否正在求婚
function Wedding:IsProposing(pPlayer)
	local nNowTime = GetTime()
	if pPlayer.nProposeTime and nNowTime - pPlayer.nProposeTime <= Wedding.nProposeDecideTime then
    	return true
    end
end

-- 是否正在被求婚
function Wedding:IsBeProposing(pPlayer)
	local nNowTime = GetTime()
	if pPlayer.nBeProposeTime and nNowTime - pPlayer.nBeProposeTime <= Wedding.nProposeDecideTime then
    	return true
    end
end

-- 清理求婚数据
function Wedding:ClearPropose(pPlayer, dwID)
	pPlayer.nProposeTime = nil
	if dwID then
		if pPlayer.tbPropose then
			pPlayer.tbPropose[dwID] = nil
		end
	else
		pPlayer.tbPropose = nil
	end

end

-- 清理被求婚数据
function Wedding:ClearBePropose(pPlayer, dwID)
	pPlayer.nBeProposeTime = nil
	if dwID then
		if pPlayer.tbBePropose then
			pPlayer.tbBePropose[dwID] = nil
		end
	else
		pPlayer.tbBePropose = nil
	end

end

-- 打断求婚
function Wedding:BreakPropose(pPlayer)
	-- 处理求婚过程中打断求婚
	local nNowTime = GetTime()
	if Wedding:IsProposing(pPlayer) then
		for dwID, v in pairs(pPlayer.tbPropose or {}) do
			local pBeProposer = KPlayer.GetPlayerObjById(dwID)
			if pBeProposer then
				if nNowTime - v.nProposeTime <= Wedding.nProposeDecideTime then
					pBeProposer.CallClientScript("Wedding:BeProposeBreak", pPlayer.szName)
				end
				Wedding:ClearBePropose(pBeProposer, pPlayer.dwID)
			end
		end
		pPlayer.CallClientScript("Wedding:ProposeBreak")
		Wedding:ClearPropose(pPlayer)
	elseif Wedding:IsBeProposing(pPlayer) then
		for dwID, v in pairs(pPlayer.tbBePropose or {}) do
			local pProposer = KPlayer.GetPlayerObjById(dwID)
			if pProposer then
				if nNowTime - v.nBeProposeTime <= Wedding.nProposeDecideTime then
					pProposer.CallClientScript("Wedding:BeProposeBreak", pPlayer.szName)
				end
				Wedding:ClearPropose(pProposer, dwID)
			end
		end
		pPlayer.CallClientScript("Wedding:ProposeBreak")
		Wedding:ClearBePropose(pPlayer)
	end
end

-- 》》称号
function Wedding:_CheckBeforeChangeTitle(pCaptain, szHusbandTitle, szWifeTitle)
	local bOk, szErr = self:CheckLoveTeam(pCaptain, true)
	if not bOk then
		return false, szErr
	end
	if pCaptain.GetItemCountInBags(self.nChangeTitleItemId)<=0 and pCaptain.GetMoney("Gold")<self.nChangeTitleCost then
		return false, "Nguyên bảo không đủ"
	end

	local nLen1 = Lib:Utf8Len(szHusbandTitle)
	local nLen2 = Lib:Utf8Len(szWifeTitle)
	if math.max(nLen1, nLen2)>self.nTitleNameMax or math.min(nLen1, nLen2)<self.nTitleNameMin then
		return false, string.format("Danh hiệu từ %d-%d ký tự", self.nTitleNameMin, self.nTitleNameMax)
	end

	if not CheckNameAvailable(szHusbandTitle) or not CheckNameAvailable(szWifeTitle) then
		return false, "Danh hiệu có từ không hợp lệ"
	end

	return true
end

function Wedding:GetTitleId(pPlayer)
	local nLevel = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyWeddingLevel)
	return self.tbTitleIds[nLevel]
end

function Wedding:_SetTitle(pPlayer, szTitle, nTitleId, bNoTip)
	nTitleId = nTitleId or self:GetTitleId(pPlayer)
	if not nTitleId then
		Log("[x] Wedding:_SetTitle", pPlayer.dwID, szTitle)
		return
	end

	local tbTitleData = PlayerTitle:GetPlayerTitleData(pPlayer)
	local bActive = tbTitleData.nActivateTitle==nTitleId
	pPlayer.DeleteTitle(nTitleId, true)
	pPlayer.AddTitle(nTitleId, -1, bActive, false, szTitle, bNoTip)
end

function Wedding:_ChangeTitle(pPlayer, pOther, szHusbandPostfix, szWifePostfix)
	local nGender = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyGender)
	local nOtherGender = pOther.GetUserValue(self.nSaveGrp, self.nSaveKeyGender)
	if nGender==nOtherGender then
		Log("[x] Wedding:_ChangeTitle, same gender", pPlayer.dwID, pOther.dwID, nGender, nOtherGender)
		return
	end

	local szPlayerTitle, szOtherTitle = "", ""
	if nGender==Gift.Sex.Boy then
		szPlayerTitle = string.format("%s %s", pOther.szName, szHusbandPostfix)
		szOtherTitle = string.format("%s %s", pPlayer.szName, szWifePostfix)

		pPlayer.SetStrValue(self.nSaveGrp, self.nSaveKeyTitlePostfix, szHusbandPostfix)
		pOther.SetStrValue(self.nSaveGrp, self.nSaveKeyTitlePostfix, szWifePostfix)
	else
		szPlayerTitle = string.format("%s %s", pOther.szName, szWifePostfix)
		szOtherTitle = string.format("%s %s", pPlayer.szName, szHusbandPostfix)

		pPlayer.SetStrValue(self.nSaveGrp, self.nSaveKeyTitlePostfix, szWifePostfix)
		pOther.SetStrValue(self.nSaveGrp, self.nSaveKeyTitlePostfix, szHusbandPostfix)
	end

	self:_SetTitle(pPlayer, szPlayerTitle)
	self:_SetTitle(pOther, szOtherTitle)

	local szMsg = string.format("[FFFE0D]「%s」[-]và [FFFE0D]「%s」[-]thay thế liễu phu thê danh hiệu ，cho nhau dĩ [FFFE0D]「%s」[-]và [FFFE0D]「%s」[-]khiếu trứ đối phương ，thực sự là tình chàng ý thiếp ，tiện sát người bên ngoài ！", pPlayer.szName, pOther.szName, nGender==Gift.Sex.Boy and szWifePostfix or szHusbandPostfix, nGender==Gift.Sex.Boy and szHusbandPostfix or szWifePostfix)
	KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1)
	pPlayer.CenterMsg("Sửa thành công")
	pOther.CenterMsg("Sửa thành công")

	Log("Wedding:_ChangeTitle", pPlayer.dwID, pOther.dwID, nGender, nOtherGender)
end

function Wedding:_DoChangeTitle(nCaptainId, nOtherId, szHusbandTitle, szWifeTitle)
	local pCaptain = KPlayer.GetPlayerObjById(nCaptainId)
	local pOther = KPlayer.GetPlayerObjById(nOtherId)
	if not pCaptain or not pOther then
		Log("[!] Wedding:_DoChangeTitle, not all online", tostring(pCaptain), tostring(pOther))
		return
	end

	local bOk, szErr = self:_CheckBeforeChangeTitle(pCaptain, szHusbandTitle, szWifeTitle)
	if not bOk then
		pCaptain.CenterMsg(szErr, 1)
		return
	end

	if pCaptain.GetItemCountInBags(self.nChangeTitleItemId)>0 then
		if pCaptain.ConsumeItemInBag(self.nChangeTitleItemId, 1, Env.LogWay_SwornFriends)~=1 then
			Log("[x] Wedding:_DoChangeTitle", nCaptainId, nOtherId, szHusbandTitle, szWifeTitle, self.nChangeTitleItemId)
			return
		end
		self:_ChangeTitle(pCaptain, pOther, szHusbandTitle, szWifeTitle)
		Log("Wedding:_DoChangeTitle, item", nCaptainId, nOtherId, szHusbandTitle, szWifeTitle)
	else
		-- CostGold谨慎调用, 调用前请搜索 _LuaPlayer.CostGold 查看使用说明, 它处调用时请保留本注释
		pCaptain.CostGold(self.nChangeTitleCost, Env.LogWay_Marriage_ChangeTitle, nil, function(nPlayerId, bSuccess)
			if not bSuccess then
				return false
			end

			local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
			if not pPlayer then
				return false, "Trong quá trình sửa đổi danh hiệu phu thê, bạn đã rời mạng."
			end
			local pOther = KPlayer.GetPlayerObjById(nOtherId)
			if not pOther then
				return false, "Trong quá trình sửa đổi danh hiệu phu thê, đối phương đã rời mạng."
			end

			self:_ChangeTitle(pPlayer, pOther, szHusbandTitle, szWifeTitle)
			Log("Wedding:_DoChangeTitle, gold", nCaptainId, nOtherId, szHusbandTitle, szWifeTitle)
			return true
		end)
	end
end

function Wedding:_SetChangeTitleInProgress(nPid1, nPid2)
	self.tbChangeTitleInProgress = self.tbChangeTitleInProgress or {}
	local szKey = self:GetNormalizedIdsKey(nPid1, nPid2)
	self.tbChangeTitleInProgress[szKey] = GetTime()
end

function Wedding:_UnsetChangeTitleInProgress(nPid1, nPid2)
	self.tbChangeTitleInProgress = self.tbChangeTitleInProgress or {}
	local szKey = self:GetNormalizedIdsKey(nPid1, nPid2)
	self.tbChangeTitleInProgress[szKey] = nil
end

function Wedding:_IsChangeTitleInProgress(nPid1, nPid2)
	self.tbChangeTitleInProgress = self.tbChangeTitleInProgress or {}
	local szKey = self:GetNormalizedIdsKey(nPid1, nPid2)
	return (GetTime()-(self.tbChangeTitleInProgress[szKey] or 0)) < self.nChangeTitleWaitTime
end

function Wedding:ChangeTitleReq(pPlayer, szHusbandTitle, szWifeTitle)
	local bOk, szErr = self:_CheckBeforeChangeTitle(pPlayer, szHusbandTitle, szWifeTitle)
	if not bOk then
		pPlayer.CenterMsg(szErr, 1)
		return
	end

	local nMyId = pPlayer.dwID
	local nOtherId = self:GetLover(nMyId)
	local pOther = KPlayer.GetPlayerObjById(nOtherId)
	if not pOther then
		pPlayer.CenterMsg("Đối phương không online", 1)
		return
	end

	if self:_IsChangeTitleInProgress(nMyId, nOtherId) then
		pPlayer.CenterMsg("Đối phương chưa xác nhận, xin chờ đợi ")
		return
	end
	self:_SetChangeTitleInProgress(nMyId, nOtherId)

	local function fConfirm()
		self:_UnsetChangeTitleInProgress(nMyId, nOtherId)
		GameSetting:SetGlobalObj(pPlayer)
		Dialog:OnMsgBoxSelect(1, true)
		GameSetting:RestoreGlobalObj()
		self:_DoChangeTitle(nMyId, nOtherId, szHusbandTitle, szWifeTitle)
	end
	local function fCancel()
		self:_UnsetChangeTitleInProgress(nMyId, nOtherId)
		GameSetting:SetGlobalObj(pPlayer)
		Dialog:OnMsgBoxSelect(1, true)
		GameSetting:RestoreGlobalObj()
		pPlayer.CenterMsg("Đối phương từ chối thay đổi danh hiệu phu thê", 1)
	end

	local szMyTitle, szOtherTitle = "", ""
	local nMyGender = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyGender)
	if nMyGender==Gift.Sex.Boy then
		szMyTitle = string.format("%s %s", pOther.szName, szHusbandTitle)
		szOtherTitle = string.format("%s %s", pPlayer.szName, szWifeTitle)
	else
		szMyTitle = string.format("%s %s", pOther.szName, szWifeTitle)
		szOtherTitle = string.format("%s %s", pPlayer.szName, szHusbandTitle)
	end

	local function fnClose()
		me.CallClientScript("Ui:CloseWindow", "MessageBox")
	end
	local szMsg = string.format("Hiệp lữ của bạn đã sửa Danh hiệu phu thê thành [FFFE0D]「%s」[-]  và [FFFE0D]「%s」[-], bạn có đồng ý hay không? \n(%%d giây sau tự động đồng ý )", szMyTitle, szOtherTitle, self.nChangeTitleWaitTime)
	pOther.MsgBox(szMsg, {{"Đồng ý", fConfirm}, {"Hủy bỏ", fCancel}}, nil, self.nChangeTitleWaitTime, fConfirm)
	pPlayer.MsgBox("Đợi đối phương đồng ý sau： %d", {{"Xác nhận", fnClose}}, nil, self.nChangeTitleWaitTime, fnClose)
end

function Wedding:_CheckSendMemorialMail(pPlayer, nNow)
	local nPid = pPlayer.dwID
	local nOtherId, nWeddingTime = self:GetLover(nPid)
	if not nOtherId then
		return
	end

	local nLast = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyLastMemorialMailMonth)
	if nLast>=self:GetMemorialCfgMaxMonth() then
		return
	end

	nNow = nNow or GetTime()
	local nMax = self:GetMaxMemorialMonth(nWeddingTime, nNow)
	if nMax<=nLast then
		return
	end

	local nRealMax = nLast
	for nMonth=nLast+1, nMax do
		if self.tbMemorialMonthRewards[nMonth] then
			nRealMax = nMonth

			local tbAttach = self.tbMemorialMonthRewards[nMonth].tbMail
			if not next(tbAttach or {}) then
				tbAttach = nil
			end
			Mail:SendSystemMail({
				To = nPid,
				Title = "Kỷ Niệm Kết Hôn",
				Text = string.format("  Hôm nay là ngày kỷ niệm [FFFE0D]thành hôn %s[-]đích kỉ niệm nhật ，đặc biệt vi các ngươi ta hứa khói chi tiêu sinh khánh chúc ，ta hoàn vi các ngươi định chế liễu chuyên chúc đích kỉ niệm nhật tưởng lệ ，hoàn thỉnh các ngươi song phương tổ đội [FF0066][url=npc:tiền lai lĩnh thủ, 2372, 10][-]。mong muốn nhị vị định năng Bách Niên Giai Lão ，vĩnh kết đồng tâm ！", self:_GetMemorialDayName(nMonth)),
				From = "Hồng Nương",
				tbAttach = tbAttach,
				nLogReazon = Env.LogWay_Marriage_Memorial,
			})
			Log("Wedding:_CheckSendMemorialMail", nPid, nMonth, nLast, nOtherId, nWeddingTime, nNow)
		end
	end
	pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyLastMemorialMailMonth, nRealMax)
end

function Wedding:_GetMemorialDayName(nMonth)
	if nMonth%12==0 then
		return string.format("%d  năm", nMonth/12)
	end
	return string.format("%d tháng", nMonth)
end

function Wedding:_SendMemorialMails()
	local tbAllPlayer = KPlayer.GetAllPlayer()
	local nNow = GetTime()
    for _, pPlayer in ipairs(tbAllPlayer) do
    	self:_CheckSendMemorialMail(pPlayer, nNow)
    end
end

function Wedding:_SendMemorialDayRedBags(pPlayer, pOther, tbRedBags)
	if not tbRedBags or not next(tbRedBags) then
		return
	end
	for _, nTypeId in ipairs(tbRedBags) do
		Kin:RedBagOnEvent(pPlayer, nTypeId)
		Kin:RedBagOnEvent(pOther, nTypeId)
		Log("Wedding:_SendMemorialDayRedBags", pPlayer.dwID, pOther.dwID, nTypeId)
	end
end

function Wedding:_SendMemorialDayRewards(pPlayer, pOther, nMonth)
	local tbSetting = self.tbMemorialMonthRewards[nMonth]
	if not tbSetting then
		return false
	end

	self:_SendMemorialDayRedBags(pPlayer, pOther, tbSetting.tbRedBags)

	local tbAttach = tbSetting.tbNpc
	local tbAttachDesc = {}
	if next(tbAttach) then
		pPlayer.SendAward(tbAttach, true, true, Env.LogWay_Marriage_Memorial)
		pOther.SendAward(tbAttach, true, true, Env.LogWay_Marriage_Memorial)

		for _, tb in ipairs(tbAttach) do
			local szType, nId, nCount = unpack(tb)
			if string.lower(szType)=="item" then
				local tbBaseInfo = KItem.GetItemBaseProp(nId)
				if tbBaseInfo then
					table.insert(tbAttachDesc, string.format("%sx%d", tbBaseInfo.szName, nCount or 1))
				end
			end
		end
	end
	local szAttachDesc = next(tbAttachDesc) and table.concat(tbAttachDesc, "、") or ""
	local szMsg = string.format("    Hôm nay là ngày kỷ niệm [FFFE0D]thành hôn %s[-], phần thưởng [FFFE0D](%s)[-] đã gửi vào hành trang. Chúc hai vị bách niên hảo hợp, vĩnh kết đồng tâm!\n\n    [FFFE0D]Ngày kỷ niệm kế tiếp và phần thưởng xem trong Hôn Thư[-]", self:_GetMemorialDayName(nMonth), szAttachDesc)
	local nPid1, nPid2 = pPlayer.dwID, pOther.dwID
	Mail:SendSystemMail({
		To = nPid1,
		Title = "Thưởng Kỷ Niệm Kết Hôn",
		Text = szMsg,
		From = "Hồng Nương",
	})
	Mail:SendSystemMail({
		To = nPid2,
		Title = "Thưởng Kỷ Niệm Kết Hôn",
		Text = szMsg,
		From = "Hồng Nương",
	})
	Log("Wedding:_SendMemorialDayRewards", nPid1, nPid2, nMonth)
	return true
end

function Wedding:ClaimMemorialDayRewardsReq(pPlayer)
	local nPlayerId = pPlayer.dwID
	local nOtherId, nWeddingTime = self:GetLover(nPlayerId)
	if not nOtherId then
		return false, "Ngươi không có hiệp lữ"
	end

	local pOther = KPlayer.GetPlayerObjById(nOtherId)
	if not pOther then
		return false, "Đối phương không online"
	end

	local bOk, szErr = self:CheckLoveTeam(pPlayer, true)
	if not bOk then
		return false, szErr
	end

	local nLast = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyLastMemorialNpcMonth)
	local nLastOther = pOther.GetUserValue(self.nSaveGrp, self.nSaveKeyLastMemorialNpcMonth)
	if nLast~=nLastOther then
		Log("[x] Wedding:ClaimMemorialDayRewards", nPlayerId, nOtherId, nWeddingTime, nLast, nLastOther)
		nLast = math.max(nLast, nLastOther)
	end

	if nLast>=self:GetMemorialCfgMaxMonth() then
		return false, "Không có phần thưởng kỷ niệm kết hôn"
	end

	local nNow = GetTime()
	local nMax = self:GetMaxMemorialMonth(nWeddingTime, nNow)
	if nMax<=nLast then
		return false, "Không có phần thưởng kỷ niệm kết hôn"
	end

	local nRealMax = nLast
	for nMonth=nLast+1, nMax do
		if self:_SendMemorialDayRewards(pPlayer, pOther, nMonth) then
			nRealMax = nMonth
		end
	end
	pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyLastMemorialNpcMonth, nRealMax)
	pOther.SetUserValue(self.nSaveGrp, self.nSaveKeyLastMemorialNpcMonth, nRealMax)

	Log("Wedding:ClaimMemorialDayRewardsReq", nPlayerId, nOtherId, nLast, nMax, nRealMax, nWeddingTime, nNow)
	return true
end

function Wedding:_CheckDismissProtect(nWeddingTime)
	return (GetTime()-nWeddingTime)<self.nDismissProtectTime
end

function Wedding:_SendDismissMail(nPlayerId, nOtherId)
	local pPlayer = KPlayer.GetRoleStayInfo(nPlayerId)
	local pOther = KPlayer.GetRoleStayInfo(nOtherId)
	local tbMail = {
		To = nil,
		Title = "Thông Báo Ly Hôn",
		From = "Hồng Nương",
		Text = nil,
		nLogReazon = Env.LogWay_Marriage_Dismiss,
	}

	tbMail.To = nPlayerId
	tbMail.Text = string.format("    Hiệp sĩ cùng 「%s」đã chính thức Ly hôn.\n    [C8FF00] Hai tình nếu là lâu dài lúc, lại há tại sớm sớm chiều chiều.[-] Mặc dù đời này hai vị bởi vì một ít nguyên nhân mỗi người đi một ngả, tin tưởng có càng đáng giá chờ đợi người tại không xa tương lai.", pOther.szName)
	Mail:SendSystemMail(tbMail)

	tbMail.To = nOtherId
	tbMail.Text = string.format("    Hiệp sĩ cùng 「%s」đã chính thức Ly hôn.\n    [C8FF00] Hai tình nếu là lâu dài lúc, lại há tại sớm sớm chiều chiều.[-] Mặc dù đời này hai vị bởi vì một ít nguyên nhân mỗi người đi một ngả, tin tưởng có càng đáng giá chờ đợi người tại không xa tương lai.", pPlayer.szName)
	Mail:SendSystemMail(tbMail)
end

function Wedding:_DoDismissRecycle(pPlayer, nOtherId)
	local nLevel = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyWeddingLevel)
	local tbSettings = self.tbWeddingLevelMapSetting[nLevel]

	--称号
	local nTitleId = self:GetTitleId(pPlayer)
	if nTitleId then
		pPlayer.DeleteTitle(nTitleId, true)
	end

	--婚服
	self:ChangeDressState(pPlayer, false)
	for _, nId in ipairs(self.tbAllDressIds) do
		pPlayer.ConsumeItemInBag(nId, 1, Env.LogWay_Marriage_Dismiss)
	end

	--婚书
	pPlayer.ConsumeItemInBag(self.nMarriagePaperId, 1, Env.LogWay_Marriage_Dismiss)

	--婚戒
	local tbIds = self.tbRingIds[nLevel] or {}
	for _, nId in ipairs(tbIds) do
		pPlayer.ConsumeItemInBag(nId, 1, Env.LogWay_Marriage_Dismiss)
	end
	Item:SetEquipPosString(pPlayer, Item.EQUIPPOS_RING, "")

	--礼包
	for _, tb in ipairs(tbSettings.tbMarryAward) do
		local _, nId = unpack(tb[1])
		pPlayer.ConsumeItemInBag(nId, 1, Env.LogWay_Marriage_Dismiss)
	end

	Furniture:Delete(pPlayer, Wedding.tbWeddingFurniture, Env.LogWay_Marriage_Dismiss);

	Log("Wedding:_DoDismissRecycle", pPlayer, nOtherId)
end

function Wedding:_DoDismissCommon(nPlayerId, nOtherId)
	KFriendShip.SetFriendShipGroup(nPlayerId, nOtherId, {
		FriendShip:WeddingStateType(), self.State_None,
		FriendShip:WeddingTimeType(), 0,
	})
	self:_UnsetDismissing(nPlayerId)
	self:_UnsetDismissing(nOtherId)
	self:_SendDismissMail(nPlayerId, nOtherId)

	Lib:CallBack({ House.OnDivorce, House, nPlayerId, nOtherId });

	Log("Wedding:_DoDismissCommon", nPlayerId, nOtherId)
end

function Wedding:_DoDismiss(pPlayer, nOtherId)
	local nPlayerId = pPlayer.dwID
	if not nOtherId or nOtherId<=0 then
		Log("[x] Wedding:_DoDismiss, no otherid", nPlayerId, tostring(nOtherId))
		return false
	end

	self:_DoDismissRecycle(pPlayer, nOtherId)

	pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyGender, 0)
	pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyLastMemorialMailMonth, 0)
	pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyLastMemorialNpcMonth, 0)
	pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyWeddingLevel, 0)

	pPlayer.TLog("WeddingFlow", Wedding.nOperationType_Divorce, 0, nOtherId, 0, 0, 0, GetTime(), nPlayerId)
	Log("Wedding:_DoDismiss", nPlayerId, nOtherId)

	return true
end

function Wedding:_DismissReduceImitity(nPid1, nPid2)
	FriendShip:ReduceImitity(nPid1, nPid2, self.nReduceImitity, Env.LogWay_Marriage_Dismiss)
end

function Wedding:DismissReq(pPlayer)
	local nPlayerId = pPlayer.dwID
	local nOtherId, nWeddingTime = self:GetLover(nPlayerId)
	if not nOtherId then
		return false, "Ngươi không có hiệp lữ"
	end

	local pOther = KPlayer.GetPlayerObjById(nOtherId)
	if not pOther then
		return false, "Đối phương không online"
	end

	local bOk, szErr = self:CheckLoveTeam(pPlayer, true)
	if not bOk then
		return false, szErr
	end

	if self:_CheckDismissProtect(nWeddingTime) then
		return false, "Hai người chỉ vừa mới cưới nhau, khó tránh khỏi chuyện bất đồng quan điểm, vợ chồng cải nhau đầu giường cuối giường làm lành. Hãy suy nghĩ lại!\n[FF6464FF] Nhắc nhở: Hôn lễ sau  30 ngày mới có thể Ly hôn [-]"
	end

	self.tbDismissWaiting = self.tbDismissWaiting or {}
	self.tbDismissWaiting[nPlayerId] = self.tbDismissWaiting[nPlayerId] or {}
	local nReqTime = self.tbDismissWaiting[nPlayerId][nOtherId] or 0
	local nNow = GetTime()
	if nNow-nReqTime<self.nDismissWaitingTime then
		return false, "Xin chờ đợi đối phương xác nhận "
	end

	self.tbDismissWaiting[nPlayerId][nOtherId] = nNow

	local function fConfirm()
		self.tbDismissWaiting[nPlayerId] = nil
		GameSetting:SetGlobalObj(pPlayer)
		Dialog:OnMsgBoxSelect(1, true)
		GameSetting:RestoreGlobalObj()
		self:_DoConfirmDismiss(nPlayerId, nOtherId)
	end
	local function fCancel()
		self.tbDismissWaiting[nPlayerId] = nil
		GameSetting:SetGlobalObj(pPlayer)
		Dialog:OnMsgBoxSelect(1, true)
		GameSetting:RestoreGlobalObj()
		pPlayer.CenterMsg("Bên kia từ chối đơn xin ly hôn", 1)
		pOther.CenterMsg("Bạn đã từ chối đơn xin ly hôn")
	end

	local function fnClose()
		me.CallClientScript("Ui:CloseWindow", "MessageBox")
	end
	local szMsg = string.format("[FFFE0D]"%s" [-] Muốn ly hôn, có đồng ý hay không?\n(%%d giây sau tự động cự tuyệt )", pPlayer.szName, self.nDismissWaitingTime)
	pOther.MsgBox(szMsg, {{"Đồng ý", fConfirm}, {"Hủy", fCancel}}, nil, self.nDismissWaitingTime, fCancel)
	pPlayer.MsgBox("Xin chờ đợi đối phương xác nhận: %d", {{"Xác nhận", fnClose}}, nil, self.nDismissWaitingTime, fnClose)

	Log("Wedding:DismissReq", nPlayerId, nOtherId, nWeddingTime)
	return true
end

function Wedding:_DoConfirmDismiss(nPlayerId, nOtherId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		Log("[x] Wedding:_DoConfirmDismiss, player offline", nPlayerId, nOtherId)
		return
	end
	local pOther = KPlayer.GetPlayerObjById(nOtherId)
	if not pOther then
		Log("[x] Wedding:_DoConfirmDismiss, other offline", nPlayerId, nOtherId)
		return
	end

	self:GiveBackDismissCost(nPlayerId)
	self:GiveBackDismissCost(nOtherId)

	self:_DoDismissCommon(nPlayerId, nOtherId)
	self:_DoDismiss(pPlayer, nOtherId)
	self:_DoDismiss(pOther, nPlayerId)

	self:_DismissReduceImitity(nPlayerId, nOtherId)
	Log("Wedding:_DoConfirmDismiss", nPlayerId, nOtherId)
end

function Wedding:_CheckSendDismissingNotice(pPlayer)
	local nPlayerId = pPlayer.dwID
	local nOtherId = self:GetLover(nPlayerId)
	if not nOtherId then
		return
	end

	local tbReq = self:_IsDismissing(nPlayerId) or self:_IsDismissing(nOtherId)
	if not tbReq then
		return
	end

	local nDeadline, nId = unpack(tbReq)
	local tbRealDeadline = os.date("*t", nDeadline)
    tbRealDeadline.day = tbRealDeadline.day+1
    tbRealDeadline.hour = 0
    tbRealDeadline.min = 0
    tbRealDeadline.sec = 1

    local nRealDeadline = os.time(tbRealDeadline)
	local nNow = GetTime()
	if nRealDeadline<nNow then
		return
	end

	local szDeadline = Lib:TimeDesc5(nRealDeadline-nNow)
	local pOther = KPlayer.GetRoleStayInfo(nOtherId) or {szName=""}
	local szMsg = ""
	if nId==nOtherId then
		szMsg = string.format("Ngươi cùng「%s」ly hôn, sau %s  có hiệu lực", pOther.szName, szDeadline)
	else
		szMsg = string.format("「%s」và ngươi ly hôn, sau %s sẽ có hiệu lực", pOther.szName, szDeadline)
	end
	pPlayer.Msg(szMsg)
end

function Wedding:_IsDismissing(nPlayerId)
	local tbDismissing = self:GetSaveData("WeddingDismissing")
	return tbDismissing[nPlayerId]
end

function Wedding:_SetDismissing(nPlayerId, nOtherId)
	local szKey = "WeddingDismissing"
	local tbDismissing = self:GetSaveData(szKey)
	local nDeadline = GetTime()+self.nForceDivorceDelayTime
	local tbData = {nDeadline, nOtherId}
	tbDismissing[nPlayerId] = tbData
	ScriptData:AddModifyFlag(szKey)
	return tbData
end

function Wedding:_UnsetDismissing(nPlayerId)
	local szKey = "WeddingDismissing"
	local tbDismissing = self:GetSaveData(szKey)
	if not tbDismissing[nPlayerId] then
		return
	end

	tbDismissing[nPlayerId] = nil
	ScriptData:AddModifyFlag(szKey)
end

function Wedding:_DoForceDismiss(pPlayer, nOtherId)
	local nPlayerId = pPlayer.dwID
	local tbData = self:_SetDismissing(nPlayerId, nOtherId)
	local nDeadline = unpack(tbData)
	pPlayer.CenterMsg(string.format("Thành công xin cưỡng chế ly hôn,Sau %s có hiệu lực ", Lib:TimeDesc2(nDeadline-GetTime())))
	Dialog:SendBlackBoardMsg(pPlayer, string.format("Tiêu hao %d Nguyên bảo [FFFE0D]( Hủy bỏ xin tự động trả lại )[-]", self.nForceDivorceCost))
	Log("Wedding:_DoForceDismiss", nPlayerId, nOtherId, nNow)
end

function Wedding:ForceDismissReq(pPlayer)
	local nPlayerId = pPlayer.dwID
	local nOtherId, nWeddingTime = self:GetLover(nPlayerId)
	if not nOtherId then
		return false, "Ngươi không có hiệp lữ"
	end

	if self:_CheckDismissProtect(nWeddingTime) then
		return false, "Hai người chỉ vừa mới cưới nhau, khó tránh khỏi chuyện bất đồng quan điểm, vợ chồng cải nhau đầu giường cuối giường làm lành. Hãy suy nghĩ lại!\n[FF6464FF] Nhắc nhở: Hôn lễ sau  30 ngày mới có thể Ly hôn [-]"
	end

	if self:_IsDismissing(nPlayerId) then
		return false, "Đã ở trạng thái xin ly hôn"
	end

	local _, nOfflineSec = Player:GetOfflineDays(nOtherId)
	if nOfflineSec>=self.nForceDivorcePlayerOffline then
		self:_DoDismissCommon(nPlayerId, nOtherId)
		self:_DismissNowOrDelay(nPlayerId, nOtherId)
		self:_DismissNowOrDelay(nOtherId, nPlayerId)

		self:_DismissReduceImitity(nPlayerId, nOtherId)
	else
		if pPlayer.GetMoney("Gold")<self.nForceDivorceCost then
			return false, "Nguyên bảo không đủ"
		end
		-- CostGold谨慎调用, 调用前请搜索 _LuaPlayer.CostGold 查看使用说明, 它处调用时请保留本注释
		pPlayer.CostGold(self.nForceDivorceCost, Env.LogWay_Marriage_Dismiss, nil, function(nPlayerId, bSuccess)
			if not bSuccess then
				return false
			end

			local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
			if not pPlayer then
				return false, "Đang ly hôn, bạn rời mạng"
			end

			self:_DoForceDismiss(pPlayer, nOtherId)
			return true
		end)
	end
	Log("Wedding:ForceDismissReq", nPlayerId, nOtherId, nWeddingTime, nOfflineSec)

	return true
end

function Wedding:CancelDismissReq(pPlayer)
	local nPlayerId = pPlayer.dwID
	if not self:_IsDismissing(nPlayerId) then
		return false, "Bạn đã không nộp đơn xin ly hôn"
	end

	self:GiveBackDismissCost(nPlayerId)
	self:_UnsetDismissing(nPlayerId)
	pPlayer.CenterMsg("Hủy bỏ thành công")
	return true
end

function Wedding:GiveBackDismissCost(nPlayerId)
	local tbRecord = self:_IsDismissing(nPlayerId)
	if not tbRecord then
		return false
	end

	local _, nOtherId = unpack(tbRecord)
	local pOther = KPlayer.GetRoleStayInfo(nOtherId) or {szName=""}
	Mail:SendSystemMail({
		To = nPlayerId,
		Title = "Hủy đơn xin ly hôn",
		Text = string.format("    Đơn xin ly hôn với [FFFE0D]%s[-] đã bị hủy và [FFFE0D]%d Nguyên Bảo[-] được hoàn trả theo yêu cầu.", pOther.szName, self.nForceDivorceCost),
		From = "Hồng Nương",
		tbAttach = {
			{"Gold", self.nForceDivorceCost},
		},
		nLogReazon = Env.LogWay_Marriage_Dismiss,
	})
	return true
end

function Wedding:_DismissNowOrDelay(nPlayerId, nOtherId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if pPlayer then
		self:_DoDismiss(pPlayer, nOtherId)
	else
		KPlayer.AddDelayCmd(nPlayerId, string.format("Wedding:_DismissNowOrDelay(%d, %d)", nPlayerId, nOtherId), "_DismissNowOrDelay")
	end
	Log("Wedding:_DismissNowOrDelay", nPlayerId, nOtherId, pPlayer and "now" or "delay")
end

function Wedding:_CheckDismiss()
	local nNow = GetTime()
	local szKey = "WeddingDismissing"
	local tbDismissing = self:GetSaveData(szKey)
	for nReqPid, tbInfo in pairs(tbDismissing) do
		local nDeadline, nOtherId = unpack(tbInfo)
		if nDeadline<=nNow then
			self:GiveBackDismissCost(nOtherId)
			self:_DoDismissCommon(nReqPid, nOtherId)
			self:_DismissNowOrDelay(nReqPid, nOtherId)
			self:_DismissNowOrDelay(nOtherId, nReqPid)

			self:_DismissReduceImitity(nReqPid, nOtherId)
		end
	end
	ScriptData:AddModifyFlag(szKey)
end

function Wedding:ChangeDressState(pPlayer, bOn)
	local bCurOn = pPlayer.bWeddingDressOn
	if not bOn and bCurOn then
		pPlayer.UpdateAllEquipShow()
	end
	pPlayer.bWeddingDressOn = bOn
	if bOn~=bCurOn then
		pPlayer.CallClientScript("Wedding:OnDressChange", bOn)
	end
end

function Wedding:_CashGiftPrepare(nHost1, nHost2)
	nHost1, nHost2 = self:NormalizeIds(nHost1, nHost2)

	self.tbCashGiftCache = self.tbCashGiftCache or {}
	self.tbCashGiftCache[nHost1] = self.tbCashGiftCache[nHost1] or {}
	self.tbCashGiftCache[nHost1][nHost2] = self.tbCashGiftCache[nHost1][nHost2] or {}
	return nHost1, nHost2
end

function Wedding:_CashGiftGetRemain(pPlayer, nHost1, nHost2)
	local nVip = pPlayer.GetVipLevel()
	local nMax = self:GetCashGiftMax(nVip)
	local tbData = self:_CashGiftHasGiven(nHost1, nHost2, pPlayer.dwID)
	if not tbData then
		return nMax
	end
	local nGiven = unpack(tbData)
	return math.max(nMax-nGiven, 0)
end

function Wedding:_CashGiftHasGiven(nHost1, nHost2, nGuest)
	nHost1, nHost2 = self:_CashGiftPrepare(nHost1, nHost2)
	return self.tbCashGiftCache[nHost1][nHost2][nGuest]
end

function Wedding:_CashGiftGive(nHost1, nHost2, nGuest, nGold)
	nHost1, nHost2 = self:_CashGiftPrepare(nHost1, nHost2)
	local tbData = {nGold, GetTime()}
	local tbOldData = self:_CashGiftHasGiven(nHost1, nHost2, nGuest)
	if tbOldData then
		local nOldGold = unpack(tbOldData)
		tbData[1] = tbData[1]+nOldGold
	end
	self.tbCashGiftCache[nHost1][nHost2][nGuest] = tbData
	self.tbCashGiftCache[nHost1][nHost2].nVer = (self.tbCashGiftCache[nHost1][nHost2].nVer or 0)+1

	Log("Wedding:_CashGiftGive", nHost1, nHost2, nGuest, nGold, tbData[1])
	return tbData[1]
end

function Wedding:GetCashGiveRank(nHost1, nHost2, nRank)
	 nHost1, nHost2 = self:NormalizeIds(nHost1, nHost2)
	 nRank = nRank or 0
	 local tbCashGiftCache = self.tbCashGiftCache or {}
	 local tbCashGift = tbCashGiftCache[nHost1] and tbCashGiftCache[nHost1][nHost2] or {}
	 local tbSeqCashGift = {}
	 for nGuest, v in pairs(tbCashGift or {}) do
	 	if tonumber(nGuest) then
	 		table.insert(tbSeqCashGift, {nGuest = nGuest, nGold = v[1], nGiveTime = v[2]})
	 	end
	 end
	 local fnSort = function (a, b)
	 	if a.nGold == b.nGold then
	 		return a.nGiveTime < b.nGiveTime
	 	end
	 	return a.nGold > b.nGold
	 end
	 if #tbSeqCashGift > 1 then
	 	table.sort(tbSeqCashGift, fnSort)
	 end
	 if nRank == -1 then
	 	return tbSeqCashGift
	 end
	 local tbRankCashGift = {}
	 for i = 1, nRank do
	 	if tbSeqCashGift[i] then
	 		table.insert(tbRankCashGift, tbSeqCashGift[i])
	 	end
	 end
	 return tbRankCashGift
end

function Wedding:GiveCashGiftReq(pGuest, nHost1, nHost2, nGold)
	nHost1, nHost2 = self:NormalizeIds(nHost1, nHost2)
	local nGuest = pGuest.dwID
	if nGuest==nHost1 or nGuest==nHost2 then
		pGuest.CenterMsg("Không thể đưa nó cho chính mình")
		return
	end

	if pGuest.GetMoney("Gold")<nGold then
		pGuest.CenterMsg("Nguyên bảo không đủ")
		return
	end

	local tbSetting = self.tbCashGiftSettings[nGold]
	if not tbSetting then
		Log("[x] Wedding:GiveCashGiftReq, invalid nGold", nGuest, nHost1, nHost2, nGold)
		return
	end

	local nMinVip, bNotice = unpack(tbSetting)
	if nMinVip>pGuest.GetVipLevel() then
		pGuest.CenterMsg("Cấp đặc quyền không đủ")
		return
	end

	local nRemain = self:_CashGiftGetRemain(pGuest, nHost1, nHost2)
	if nGold>nRemain then
		pGuest.CenterMsg("Số tiền không đủ")
		return
	end

	if not self.tbWeddingPlayer[nHost1] or not self.tbWeddingPlayer[nHost2] then
		pGuest.CenterMsg("Đối phương hiện không tổ chức đám cưới")
		return
	end
	local tbInst1 = Fuben.tbFubenInstance[Wedding.tbWeddingPlayer[nHost1]]
	local tbInst2 = Fuben.tbFubenInstance[Wedding.tbWeddingPlayer[nHost2]]
	if not tbInst1 or not tbInst2 or tbInst1.nMapId ~= tbInst2.nMapId or tbInst1.nProcess == Wedding.PROCESS_END or tbInst1.bClose == 1 then
		pGuest.CenterMsg("Hôn lễ đã kết thúc")
		return
	end

	-- CostGold谨慎调用, 调用前请搜索 _LuaPlayer.CostGold 查看使用说明, 它处调用时请保留本注释
	local szTlog = string.format("%d,%d", nHost1, nHost2)
	pGuest.CostGold(nGold, Env.LogWay_Marriage_CashGift, szTlog, function(nGuest, bSuccess)
		if not bSuccess then
			return false
		end

		local pGuest = KPlayer.GetPlayerObjById(nGuest)
		if not pGuest then
			return false, "Đang trong quá trình tặng, bạn offline"
		end

		local nTotalGold = self:_CashGiftGive(nHost1, nHost2, nGuest, nGold)
		self:UpdateCashGiftReq(pGuest, nHost1, nHost2, 0)

		local szGuestName = pGuest.szName
		local szHostMsg = string.format("[FFFE0D]「%s」[-]trong hôn lễ lấy %d Nguyên bảo làm tiền mừng", szGuestName, nGold)
		local pHost1 = KPlayer.GetPlayerObjById(nHost1)
		if pHost1 then pHost1.Msg(szHostMsg) end
		local pHost2 = KPlayer.GetPlayerObjById(nHost2)
		if pHost2 then pHost2.Msg(szHostMsg) end

		if bNotice then
			pHost1 = pHost1 or KPlayer.GetRoleStayInfo(nHost1)
			pHost2 = pHost2 or KPlayer.GetRoleStayInfo(nHost2)
			local szMsg = ""
			if nGold<nTotalGold then
				szMsg = string.format("[FFFE0D]「%s」 [-] Tại [FFFE0D]「%s」 [-]  và [FFFE0D]「%s」 [-] Hôn lễ yến hội đưa ra [FFFE0D]%d Nguyên bảo [-] Làm tiền biếu, đưa ra tiền biếu tổng ngạch đạt đến [FFFE0D]%d Nguyên bảo [-], chúc hai vị người mới bạch niên giai lão ", szGuestName, pHost1 and pHost1.szName or "", pHost2 and pHost2.szName or "", nGold, nTotalGold)
			else
				szMsg = string.format("[FFFE0D]「%s」 [-] Tại [FFFE0D]「%s」 [-] Cùng [FFFE0D]「%s」[-] Hôn lễ yến hội đưa ra [FFFE0D]%d Nguyên bảo [-] Làm tiền biếu, chúc hai vị người mới vĩnh kết đồng tâm ", szGuestName, pHost1 and pHost1.szName or "", pHost2 and pHost2.szName or "", nGold)
			end
			KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1)
		end

		pGuest.CenterMsg(string.format("Thành công tặng %d Nguyên bảo làm tiền biếu ", nGold), 1)
		return true
	end)
end

function Wedding:_GetLatestCashGiftClientData(nHost1, nHost2)
	nHost1, nHost2 = self:NormalizeIds(nHost1, nHost2)

	self.tbCashGiftClientDataCache = self.tbCashGiftClientDataCache or {}
	self.tbCashGiftClientDataCache[nHost1] = self.tbCashGiftClientDataCache[nHost1] or {}
	self.tbCashGiftClientDataCache[nHost1][nHost2] = self.tbCashGiftClientDataCache[nHost1][nHost2] or {}
	local tbData = self.tbCashGiftClientDataCache[nHost1][nHost2]
	local tbOrg = self.tbCashGiftCache[nHost1][nHost2]
	if tbData.nVer~=tbOrg.nVer then
		tbData = {tbList={}}
		local tbSortedIds = {}
		for nPid in pairs(tbOrg) do
			if type(nPid)=="number" then
				table.insert(tbSortedIds, nPid)
			end
		end
		table.sort(tbSortedIds, function(nPid1, nPid2)
			local nGold1, nTime1 = unpack(tbOrg[nPid1])
			local nGold2, nTime2 = unpack(tbOrg[nPid2])
			if nGold1~=nGold2 then
				return nGold1>nGold2
			else
				return nTime1<nTime2 or (nTime1==nTime2 and nPid1<nPid2)
			end
		end)

		for i,nId in ipairs(tbSortedIds) do
			if i>=500 then break end --防止数据包过大，实测最大可承受900个左右

			local nGold = unpack(tbOrg[nId])
			local pPlayer = KPlayer.GetRoleStayInfo(nId) or {szName=""}
			table.insert(tbData.tbList, {pPlayer.szName, nGold})
		end
		tbData.nVer = tbOrg.nVer
		self.tbCashGiftClientDataCache[nHost1][nHost2] = tbData
	end
	return tbData
end

function Wedding:UpdateCashGiftReq(pPlayer, nHost1, nHost2, nVer)
	nHost1, nHost2 = self:NormalizeIds(nHost1, nHost2)

	self.tbCashGiftCache = self.tbCashGiftCache or {}
	if not self.tbCashGiftCache[nHost1] or not self.tbCashGiftCache[nHost1][nHost2] then
		return
	end

	local tbData = self.tbCashGiftCache[nHost1][nHost2]
	if tbData.nVer==nVer then
		return
	end

	local nPlayerId = pPlayer.dwID
	local tbClientData = self:_GetLatestCashGiftClientData(nHost1, nHost2)
	tbClientData.bCanGive = nPlayerId~=nHost1 and nPlayerId~=nHost2
	tbClientData.nRemain = self:_CashGiftGetRemain(pPlayer, nHost1, nHost2)

	pPlayer.CallClientScript("Wedding:OnUpdateCashGift", nHost1, nHost2, tbClientData)
end

function Wedding:CashGiftSendToHost(nHost1, nHost2)
	nHost1, nHost2 = self:_CashGiftPrepare(nHost1, nHost2)
	local tbCache = self.tbCashGiftCache[nHost1][nHost2]
	if tbCache.nFinishTime and tbCache.nFinishTime>0 then
		Log("[x] Wedding:CashGiftSendToHost already finish", nHost1, nHost2, tbCache.nFinishTime)
		return
	end
	tbCache.nFinishTime = GetTime()

	local nTotal = 0
	for nPid, tbData in pairs(tbCache) do
		if type(nPid)=="number" then
			nTotal = nTotal+tbData[1]
		end
	end
	local nAvgGold = math.ceil(nTotal/2)
	if nAvgGold>0 then
		local tbIds = {nHost1, nHost2}
		local szText = string.format("    Chúc mừng hai vị người mới hoàn thành hôn lễ, từ đây dắt tay cùng chung đời này! Từ rày về sau cần lẫn nhau nâng đỡ, lẫn nhau bảo vệ, [FFFE0D] Hai vị có thể tổ đội tiến về Nguyệt lão chỗ từ đặt trước kết hôn xưng hào [-]. Khác lần này yến hội tân khách đưa tặng tiền biếu, Hồng Nương Đã thống kê xong tất, đặc khiển người đưa thư vì hai vị đưa đi, còn xin hai vị người mới cất kỹ.\n                                         [47f005][url=openwnd:Xem xét tiền mừng, WeddingCashGiftPanel, %d, %d][-]", nHost1, nHost2)
		for _, nPid in ipairs(tbIds) do
			Mail:SendSystemMail({
				To = nPid,
				Title = "Hôn lễ tiền mừng",
				Text = szText,
				From = "Hồng Nương",
				tbAttach = {
					{"Gold", nAvgGold},
				},
				nLogReazon = Env.LogWay_Marriage_CashGift,
			})
		end
	end
	Log("Wedding:CashGiftSendToHost", nHost1, nHost2, nTotal, nAvgGold)
end

function Wedding:RemoveCashGiftData(nHost1, nHost2)
	nHost1 = self:NormalizeIds(nHost1, nHost2)

	self.tbCashGiftCache = self.tbCashGiftCache or {}
	self.tbCashGiftCache[nHost1] = nil

	self.tbCashGiftClientDataCache = self.tbCashGiftClientDataCache or {}
	self.tbCashGiftClientDataCache[nHost1] = nil
	Log("Wedding:RemoveCashGiftData", nHost1, nHost2)
end

function Wedding:_CheckRemoveCashGiftCache()
	local nNow = GetTime()
	for nHost1, tb in pairs(self.tbCashGiftCache or {}) do
		for nHost2, tbData in pairs(tb) do
			local nFinishTime = tbData.nFinishTime or 0
			if nFinishTime>0 and (nNow-nFinishTime)>=24*3600 then
				self:RemoveCashGiftData(nHost1, nHost2)
				Log("Wedding:_CheckRemoveCashGiftCache", nHost1, nHost2, nFinishTime)
			end
		end
	end
end

function Wedding:AddMarriagePaper(pHusband, pWife, szHusbandPledge, szWifePledge, nTimestamp, nLevel)
	if not szHusbandPledge or not szWifePledge then
		Log("[x] Wedding:AddMarriagePaper no pledge", tostring(szHusbandPledge), tostring(szWifePledge))
	end

	local function AddItem(pPlayer)
		local pItem = pPlayer.AddItem(self.nMarriagePaperId, 1, 0, Env.LogWay_Wedding, 0)
		if not pItem then
			Log("[x] Wedding:AddMarriagePaper", pPlayer.dwID, pHusband.dwID, pWife.dwID, nTimestamp, self.nMarriagePaperId)
			return false
		end

		pItem.SetStrValue(self.nMPHusbandNameIdx, pHusband.szName)
		pItem.SetStrValue(self.nMPWifeNameIdx, pWife.szName)
		pItem.SetStrValue(self.nMPHusbandPledgeIdx, szHusbandPledge or "")
		pItem.SetStrValue(self.nMPWifePledgeIdx, szWifePledge or "")
		pItem.SetIntValue(self.nMPTimestamp, nTimestamp)
		pItem.SetIntValue(self.nMPLevel, nLevel)  --婚礼档次
		return true
	end

	AddItem(pHusband)
	AddItem(pWife)
end

-- 派喜糖
function Wedding:TrySendCandy(pPlayer)
	local fnAgree, szTip
	local szOnceKey
	local nNowTime = GetTime()
	me.nSendWeddingCandyTime = me.nSendWeddingCandyTime or 0
	local nPlayInterval = nNowTime - me.nSendWeddingCandyTime
	if nPlayInterval < 5 then
		me.CenterMsg(string.format("Kẹo mừng ngay tại chuẩn bị bên trong, [FFFE0D]%s giây [-] nữa mới có thểphát ", 5 - nPlayInterval > 0 and 5 - nPlayInterval or 0))
		return
	end
	-- 游城派喜糖
	if pPlayer.nMapTemplateId == Wedding.nTourMapTemplateId then
		--szOnceKey = "WeddingSendCandyTour_Once"
		local tbTour = Wedding.tbWeddingTour[Wedding.tbPlayer2TourId[me.dwID]]
		if tbTour then
			local bRet, szMsg, nType = tbTour:CheckSendCandy(pPlayer)
			if not bRet then
				pPlayer.CenterMsg(szMsg, true)
				return
			end
			if nType == Wedding.Candy_Type_Free then
				szTip = string.format(Wedding.szCandyFreeTip)
			elseif nType == Wedding.Candy_Type_Pay then
				szTip = string.format(Wedding.szCandyPayTip, Wedding.nCandyTourCost)
			end
			fnAgree = function ()
				local tbTour = Wedding.tbWeddingTour[Wedding.tbPlayer2TourId[me.dwID]]
				if tbTour then
					tbTour:SendCandy(me)
				else
					me.CenterMsg("Diễu hành kết thúc")
				end
			end
		else
			pPlayer.CenterMsg("Diễu hành kết thúc", true)
		end
	-- 婚礼现场派喜糖
	elseif Wedding.tbAllWeddingMap[pPlayer.nMapTemplateId] then
		--szOnceKey = "WeddingSendCandyFuben_Once"
		local tbInst = Fuben.tbFubenInstance[Wedding.tbWeddingPlayer[me.dwID]]
		if tbInst then
			local bRet, szMsg, nType = tbInst:CheckSendCandy(pPlayer)
			if not bRet then
				pPlayer.CenterMsg(szMsg, true)
				return
			end
			if nType == Wedding.Candy_Type_Free then
				szTip = string.format(Wedding.szCandyFreeTip)
			elseif nType == Wedding.Candy_Type_Pay then
				szTip = string.format(Wedding.szCandyPayTip, tbInst.tbCandySetting.nPayCost)
			end
			fnAgree = function ()
				local tbInst = Fuben.tbFubenInstance[Wedding.tbWeddingPlayer[me.dwID]]
				if tbInst then
					tbInst:SendCandy(me)
				else
					me.CenterMsg("Hôn lễ đã kết thúc")
				end
			end
		else
			pPlayer.CenterMsg("Hôn lễ đã kết thúc", true)
		end

	end
	if fnAgree then
		pPlayer.MsgBox(szTip, {{"Phát kẹo mừng", fnAgree}, {"Cự tuyệt "}}, szOnceKey)
	else
		pPlayer.CenterMsg("Hiện tại không thể phát kẹo mừng ")
	end

end

function Wedding:AddCandy(szType, nCount, tbAllPos, nMapId, tbRole)
	local tbNpc = {}
	local fnPosSelect = Lib:GetRandomSelect(#tbAllPos);
	for i = 1, nCount do
		local tbPos = tbAllPos[fnPosSelect()]
		local nX, nY = unpack(tbPos)
		local pNpc = KNpc.Add(Wedding.nCandyNpcTId, 1, 0, nMapId, nX, nY, 0, 0);
		if pNpc then
			pNpc.tbTmp = {}
			pNpc.tbTmp.tbRole = tbRole
			pNpc.tbTmp.szType = szType
			table.insert(tbNpc, pNpc.nId)
		end
	end
	return tbNpc
end

function Wedding:TryOpenCashPanel(pPlayer)
	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst then
		pPlayer.CenterMsg("Xin hãy thao tác trong hôn lễ", true)
		return
	end
	tbInst:OpenCashPanel(pPlayer)
end

function Wedding:TryBless(pPlayer, nIdx)
	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst then
		pPlayer.CenterMsg("Xin hãy thao tác trong hôn lễ", true)
		return
	end
	tbInst:TryBless(pPlayer, nIdx)
end

function Wedding:SetEngagedTitle(nPlayerId, szOtherName)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if pPlayer then
		if not self:GetEngaged(nPlayerId) then
			return
		end

		local nGender = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyGender)
		local tbSuffix = {[Gift.Sex.Boy] = "Vị hôn phu ", [Gift.Sex.Girl] = "Vị hôn thê "}
		self:_SetTitle(pPlayer, string.format("%s của %s", szOtherName, tbSuffix[nGender]), self.ProposeTitleId)
		return
	end

	KPlayer.AddDelayCmd(nPlayerId, string.format("Wedding:SetEngagedTitle(%d, '%s')", nPlayerId, szOtherName), "SetEngagedTitle")
end

function Wedding:SetMarriageTitle(nPlayerId, szOtherOldName, szOtherNewName)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if pPlayer then
		if not self:GetLover(nPlayerId) then
			return
		end

		local szPostfix = pPlayer.GetStrValue(self.nSaveGrp, self.nSaveKeyTitlePostfix)
		local szTitleText = ""
		if not szPostfix or szPostfix=="" then
			local nTitleId = self:GetTitleId(pPlayer)
			szTitleText = PlayerTitle:GetCustomText(pPlayer, nTitleId)
			if not szTitleText then
				Log("[x] Wedding:SetMarriageTitle no title text", nPlayerId, szOtherOldName, szOtherNewName, tostring(nTitleId))
				return
			end

			szTitleText = Lib:StrFilterChars(szTitleText, {szOtherOldName}, szOtherNewName)
			Log("Wedding:SetMarriageTitle old", szTitleText, szOtherOldName, szOtherNewName, tostring(szPostfix))
		else
			szTitleText = string.format("%s của %s", szOtherNewName, szPostfix)
			Log("Wedding:SetMarriageTitle new", szTitleText, szOtherOldName, szOtherNewName, tostring(szPostfix))
		end
		self:_SetTitle(pPlayer, szTitleText)
		return
	end

	KPlayer.AddDelayCmd(nPlayerId, string.format("Wedding:SetMarriageTitle(%d, '%s', '%s')", nPlayerId, szOtherOldName, szOtherNewName), "SetMarriageTitle")
end

function Wedding:TryFixMarriageTitle(pPlayer)
	if version_kor then
		return
	end
	local szSplit = " của "
	if version_vn or version_th then
		szSplit = "-"
	end
	if self:IsSingle(pPlayer) then
		return
	end

	local nPlayerId = pPlayer.dwID
	local nLover = self:GetLover(nPlayerId)
	if not nLover or nLover<=0 then
		return
	end
	local pLover = KPlayer.GetRoleStayInfo(nLover)
	if not pLover then
		return
	end

	local szPostfix = pPlayer.GetStrValue(self.nSaveGrp, self.nSaveKeyTitlePostfix)
	if szPostfix and szPostfix~="" then
		return
	end

	local nTitleId = self:GetTitleId(pPlayer)
	local szTitleText = PlayerTitle:GetCustomText(pPlayer, nTitleId)
	local szLoverName = pLover.szName
	local tbParts = Lib:SplitStr(szTitleText, szSplit)
	local szPostfixPart = table.remove(tbParts)
	if not szPostfixPart or szPostfixPart=="" then
		Log("[x] Wedding:TryFixMarriageTitle, PostfixPart empty", nPlayerId, nLover, szSplit, tostring(szPostfixPart), szTitleText, szLoverName)
		if szTitleText==(szLoverName..szSplit) then
			local nGiveTime = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyGiveTitleItemTime)
			if not nGiveTime or nGiveTime<=0 then
				Mail:SendSystemMail({
					To = nPlayerId,
					Title = "Nguyệt lão tạ lỗi",
					Text = "Thiếu thân mến, do những sai lầm trong công việc của tôi, tiêu đề đám cưới của bạn bị thiếu, xin lỗi, đây là một trật tự thay đổi tiêu đề hôn nhân với bạn, tôi hy vọng bạn hiểu",
					From = "「Chủ trì hôn lễ」Nguyệt Lão",
					tbAttach = {
						{"item", self.nChangeTitleItemId, 1},
					},
					nLogReazon = Env.LogWay_Wedding,
				})
				pPlayer.SetUserValue(self.nSaveGrp, self.nSaveKeyGiveTitleItemTime, GetTime())
				Log("Wedding:TryFixMarriageTitle, send item", nPlayerId, nLover, szSplit, tostring(szPostfixPart), szTitleText, szLoverName, self.nChangeTitleItemId, nGiveTime)
			end
		end
		return
	end

	local szNamePart = tbParts[1] or ""
	local szTestTitle = string.format("%s%s%s", szNamePart, szSplit, szPostfixPart)
	if szTestTitle~=szTitleText then
		Log("[x] Wedding:TryFixMarriageTitle", szSplit, nPlayerId, szLoverName, szNamePart, szPostfixPart, szTestTitle, szTitleText)
		return
	end

	pPlayer.SetStrValue(self.nSaveGrp, self.nSaveKeyTitlePostfix, szPostfixPart)
	Log("Wedding:TryFixMarriageTitle, postfix", szSplit, nPlayerId, szLoverName, szNamePart, szPostfixPart, szTestTitle, szTitleText)
	szTestTitle = string.format("%s%s%s", szLoverName, szSplit, szPostfixPart)
	if szTestTitle~=szTitleText then
		self:_SetTitle(pPlayer, szTestTitle)
		Log("Wedding:TryFixMarriageTitle, fixed", szSplit, nPlayerId, szLoverName, szNamePart, szPostfixPart, szTestTitle, szTitleText)
	end
end

function Wedding:UpdateMarriagePaper(nPlayerId, bOtherChange, szNewName)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if pPlayer then
		local tbItems = pPlayer.FindItemInBag(self.nMarriagePaperId)
		local pPaper = (tbItems or {})[1]
		if not pPaper then
			return
		end

		local tbIdx = {
			[Gift.Sex.Boy] = bOtherChange and self.nMPWifeNameIdx or self.nMPHusbandNameIdx,
			[Gift.Sex.Girl] = bOtherChange and self.nMPHusbandNameIdx or self.nMPWifeNameIdx,
		}
		local nGender = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyGender)
		local nIdx = tbIdx[nGender]
		if not nIdx then
			Log("[x] Wedding:UpdateMarriagePaper", nPlayerId, nGender, szNewName)
			return
		end
		pPaper.SetStrValue(nIdx, szNewName)
		return
	end

	KPlayer.AddDelayCmd(nPlayerId, string.format("Wedding:UpdateMarriagePaper(%d, %s, '%s')", nPlayerId, tostring(bOtherChange), szNewName), "UpdateMarriagePaper")
end

function Wedding:OnChangeName(pPlayer, szOldName)
	if self:IsSingle(pPlayer) then
		return
	end

	local nPlayerId = pPlayer.dwID
	local szNewName = pPlayer.szName
	local nEngaged = self:GetEngaged(nPlayerId)
	if nEngaged then
		self:SetEngagedTitle(nEngaged, szNewName)
		return
	end

	local nLover = self:GetLover(nPlayerId)
	if nLover then
		self:SetMarriageTitle(nLover, szOldName, szNewName)
		self:UpdateMarriagePaper(nPlayerId, false, szNewName)
		self:UpdateMarriagePaper(nLover, true, szNewName)
		return
	end
end

function Wedding:SendRedBag(pHost1, pHost2, nVipLevel)
	local nHost1 = pHost1.dwID
	local nHost2 = pHost2.dwID
	if not Wedding:IsLover(nHost1, nHost2) then
		Log("[x] Wedding:SendRedBag not lover", nHost1, nHost2)
		return
	end

	local nLevel = pHost1.GetUserValue(self.nSaveGrp, self.nSaveKeyWeddingLevel)
	local tbSetting = self.tbRedbags[nLevel]
	if not tbSetting then
		Log("[x] Wedding:SendRedBag invalid level", nHost1, nHost2, nLevel)
		return
	end

	local nCount = tbSetting.nCount or 1
	for i=1, nCount do
		Kin:RedBagOnEvent(pHost1, tbSetting.nEventType, nVipLevel)
		Kin:RedBagOnEvent(pHost2, tbSetting.nEventType, nVipLevel)
	end

	Log("Wedding:SendRedBag", nHost1, nHost2, nVipLevel, nLevel, nCount)
end

function Wedding:TryEatTableFood(pPlayer, nNpcId)
	Npc:GetClass("WeddingTableNpc"):OnEndProgress(pPlayer.dwID, nNpcId)
end

function Wedding:ClearWelcomeApply(pPlayer)
	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst then
		pPlayer.CenterMsg("Hôn lễ đã kết thúc", true)
		return
	end
	if Wedding:CheckWeddingOver(pPlayer.nMapId) then
		pPlayer.CenterMsg("Hôn lễ đã kết thúc")
		return
	end
	tbInst:ClearApplyData(pPlayer)
end

function Wedding:ReplayWedding(pPlayer)
	local tbReplaySetting, szMsg = self:CheckReplayWedding(pPlayer)
	if not tbReplaySetting then
		pPlayer.CenterMsg(szMsg, true)
		return
	end

	local tbMember = {pPlayer.dwID}
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
        fnAllMember(tbMember, fnMsg, "Không thể tạo một phó bản, vui lòng thử lại sau!");
        Log("Wedding fnGoWeddingFuben fnFailedCallback ", pPlayer.dwID, tbReplaySetting[1], tbReplaySetting[2])
    end
    Fuben:ApplyFuben(pPlayer.dwID, tbReplaySetting[2], fnSuccessCallback, fnFailedCallback, pPlayer.dwID, tbReplaySetting[1]);
end

function Wedding:CheckReplayWedding(pPlayer)
	local nLoveId = Wedding:GetLover(pPlayer.dwID)
	local nLevel = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyWeddingLevel)
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]

	if not nLoveId or not tbMapSetting or not tbMapSetting.nReplayMapTId then
		return false, "Không thể tạo lại"
	end

	if Wedding:IsPlayerMarring(pPlayer.dwID) then
		return false, "Bạn đang tổ chức một hôn lễ,không thể đi"
	end
	if Wedding:IsPlayerTouring(pPlayer.dwID) then
		return false, "Bạn đang rước kiệu,không thể đi"
	end
	if not Env:CheckSystemSwitch(pPlayer, Env.SW_ChuangGong) then
		return false, "Tình trạng hiện tại không thể đi"
	end
	if not Env:CheckSystemSwitch(pPlayer, Env.SW_Muse) then
		return false, "Tình trạng hiện tại không thể đi"
	end

	if not AsyncBattle.ASYNC_BATTLE_MAP_TYPE[Map:GetClassDesc(pPlayer.nMapTemplateId)] then
  		return false, "Vui lòng quay lại khu vực an toàn trước khi vào lại bái đường"
   end

	if Map:GetClassDesc(pPlayer.nMapTemplateId) == "fight" and pPlayer.nFightMode ~= 0 then
		return false, "Vui lòng quay lại khu vực an toàn trước khi vào lại bái đường"
	end

	return {nLevel, tbMapSetting.nReplayMapTId}
end

function Wedding:TryDoubleFly(pPlayer)
	Wedding.tbDoubleFly:TryPlayDoubleFly(pPlayer)
end

function Wedding:InitMapCallBack()
	local fnOnPlayerTrap = function (tbMap, nMapId, szTrapName)
		local tbInst = Fuben.tbFubenInstance[nMapId]
		if tbInst then
			tbInst:OnPlayerTrap(me, szTrapName)
		end
	end;
	for _, v in pairs(Wedding.tbWeddingLevelMapSetting) do
		local tbMapClass = Map:GetClass(v.nMapTID)
		tbMapClass.OnPlayerTrap = fnOnPlayerTrap;
	end
end

Wedding:InitMapCallBack()