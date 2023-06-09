--[[
	local tbSchedule = self:GetSaveData("WWeddingSchedule")
	tbSchedule.tbBook = tbSchedule.tbBook or {}
	tbSchedule.tbBook[nLevel] = tbSchedule.tbBook[nLevel] or {}
	local tbBookInfo = tbSchedule.tbBook[nLevel]
	local tbPlayerBookInfo = 
	{
		nBookTime = 123456789; 															-- 预订举办婚礼的时间戳
		tbPlayer = {[男主角id] = nSex, [女主角id] = nSex};								-- 主角
		nOpenTime = 123456789; 															-- 开启时间		
		nSendMailTime = 123456789; 														-- 发送提醒邮件的时间
		nSendOverdueMailTime = 123456789; 												-- 发送婚礼过期邮件时间
		tbCost = {[nPalyerID] = 1234}													-- 玩家对应花费，合服退还的时候用到

	}
	local tbDetail = {tbPlayerBookInfo} 												-- 以这种方式存主要是为了防止后面策划改需求（例如每天可以n场婚礼）
	tbBookInfo[nBookDay or nBookWeek] = tbDetail 				
	nLevel = 2 > nBookDay
	nLevel = 3 > nBookWeek
	注意：
	按照当前的存库模式大概可以存2500条数据左右
	以后拓展的话记得存库数据方面的拓展
	目前合服是直接返还旧服的定金
	tbSchedule.nTourTime = 123456789 													-- 游城时间（根据这个时间判定主城的婚庆气氛）
	tbSchedule.tbTourPlayer = {[nSex] = dwID} 											-- 举行游城的玩家


-- 测试存库数据（1400条左右,按目前的中档婚礼每天一条数据，高档婚礼每周一条数据，
1400是足够存的，而且会定时清理过期的数据，合服也是将从服的数据过期数据合并（保留玩家差价权利），未过期的返还，已完成的不处理，不需要
合并数据，所以可以不用分表存储）
/? local tbBook = Wedding:GetScheduleData(2)
local nTime = GetTime() - 2530*24*3600
local nDay = Lib:GetLocalDay(nTime)
for i=1,1400 do
 	tbBook[nDay + i] = tbBook[nDay + i] or {}
 	local tbPlayerBookInfo = 
		{
			nBookTime = nTime; 												
			tbPlayer = {[104888888+i] = true, [104888889+i] = true};
			nOpenTime = nTime;
			nSendMailTime = nTime;
			nSendOverdueMailTime = nTime;
		}

	table.insert(tbBook[nDay + i], tbPlayerBookInfo)
end
ScriptData:AddModifyFlag("WWeddingSchedule")
ScriptData:CheckAndSave()
]]
Wedding.tbMapRegister = Wedding.tbMapRegister or {}
-- 开启需要预订的婚礼
function Wedding:TryStartBookWedding(pPlayer)
	if not Wedding:CheckOpen() then
		pPlayer.CenterMsg("Xin vui lòng chờ")
		return
	end
	local bRet, szMsg = Wedding:CheckOpenTime()
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return
	end
	local nEngaged = Wedding:GetEngaged(pPlayer.dwID)
	if not nEngaged then
		pPlayer.CenterMsg("Chỉ có đính hôn mới có thể tiến hành hôn lễ", true)
		return
	end
	local pEngageder, szMsg = Wedding:CheckEngagedTeam(pPlayer, true)
	if not pEngageder then
		pPlayer.CenterMsg(szMsg, true)
		return
	end
	if pPlayer.nState ~= Player.emPLAYER_STATE_NORMAL then
		pPlayer.CenterMsg("Đang trong trạng thái bất thường, không thể thao tác", true)
        return 
    end
    if pEngageder.nState ~= Player.emPLAYER_STATE_NORMAL then
    	pPlayer.CenterMsg(string.format("「%s」Không thể hoạt động trong trạng thái bất thường", pEngageder.szName), true)
        return 
    end
    local bRet, szMsg = Wedding:CheckWeddingSex(pPlayer, pEngageder)
    if not bRet then
    	pPlayer.CenterMsg(szMsg, true)
    	return
    end
	local nMapId1, nX1, nY1 = pPlayer.GetWorldPos()
    local nMapId2, nX2, nY2 = pEngageder.GetWorldPos()
    local fDists = Lib:GetDistsSquare(nX1, nY1, nX2, nY2)
    if fDists > (Wedding.OPEN_WEDDING_MIN_DISTANCE * Wedding.OPEN_WEDDING_MIN_DISTANCE) or nMapId1 ~= nMapId2 then
    	pPlayer.CenterMsg("Đại sự như thế ngươi cùng người yêu cùng nhau dắt tay lại đây tiến hành", true)
        return
    end

	local nBookLevel, tbPlayerBookInfo, nOpen = self:CheckPlayerHadBook(pPlayer.dwID)
	if not nBookLevel or not tbPlayerBookInfo.tbPlayer[pEngageder.dwID] then
		pPlayer.CenterMsg("Không có hôn lễ đặt trước", true)
		return
	end
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nBookLevel]
	if not tbMapSetting or not tbMapSetting.bBook then
		pPlayer.CenterMsg("Không có hôn lễ đặt trước", true)
		return
	end
	if tbMapSetting.fnCheckBookOverdue(nOpen) then
		pPlayer.CenterMsg("Thông tin đặt trước đã quá hạn", true)
		return
	end

	if tbPlayerBookInfo.nOpenTime then
		pPlayer.CenterMsg("Đặt trước hôn lễ đã hết hạn", true)
		return
	end

	if not tbMapSetting.fnCheckBookIsOpen(nOpen) then
		pPlayer.CenterMsg("Yêu cầu tới ngày dự định hôn lễ quay lại đây", true)
		return
	end
	if tbMapSetting.bCity and (pPlayer.nMapTemplateId ~= Wedding.nTourMapTemplateId or pEngageder.nMapTemplateId ~= Wedding.nTourMapTemplateId) then
		Wedding:SwitchMap(pPlayer, pEngageder)
		return
	end

	-- 谁花的钱
	local tbCost = tbPlayerBookInfo.tbCost or {}
	local pCostPlayer = tbCost[pPlayer.dwID] and pPlayer or pEngageder
	local pNoCostPlayer = tbCost[pPlayer.dwID] and pEngageder or pPlayer
	local bSetFriendShipVal = Wedding:MakeLoveRelation(pCostPlayer, pNoCostPlayer, nBookLevel)
	local pBoy, pGirl
	local nPlayerSex = pPlayer.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
	local nEngagedSex = pEngageder.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
	if nPlayerSex == Gift.Sex.Boy then
		pBoy = pPlayer
		pGirl = pEngageder
	else
		pBoy = pEngageder
		pGirl = pPlayer
	end
	local nNowTime = GetTime()
	if tbMapSetting.bCity then
		local tbSchedule = self:GetSaveData("WWeddingSchedule")
		tbSchedule.nTourTime = nNowTime
		tbSchedule.tbTourPlayer = {pBoy.dwID, pGirl.dwID}
		Wedding:StartWeddingTour(pBoy, pGirl, nBookLevel)
	else
		local bRet, szMsg = Wedding:CreateWeddingFuben(pBoy, pGirl, nBookLevel)
		if not bRet then
			pPlayer.CenterMsg(szMsg, true)
		end
	end
	tbPlayerBookInfo.nOpenTime = nNowTime
	self:ScheduleDataAlter()
	local nBookTime = tbPlayerBookInfo.nBookTime or 0
	Log("Wedding fnTryStartWedding", pPlayer.dwID, pPlayer.szName, nPlayerSex, pEngageder.dwID, pEngageder.szName, tbMapSetting.bCity and 1 or 0, nBookLevel, bSetFriendShipVal and 1 or 0)
	pPlayer.TLog("WeddingFlow", Wedding.nOperationType_Open, nBookLevel, pEngageder.dwID, 0, nPlayerSex, nEngagedSex, nBookTime, pPlayer.dwID)
	pEngageder.TLog("WeddingFlow", Wedding.nOperationType_Open, nBookLevel, pPlayer.dwID, 0, nEngagedSex, nPlayerSex, nBookTime, pPlayer.dwID)
end

function Wedding:SwitchMap(pOperator, pEngageder)
	local nOperatorId = pOperator.dwID
	local nEngaged = pEngageder.dwID
	local fnEncterMapCallBack = function (nMapTemplateId)
		self:OnEnterTourMap(nMapTemplateId, nOperatorId, nEngaged)
	end
	local tbPlayers = {pOperator, pEngageder}
	for i, pPlayer in ipairs(tbPlayers) do
		if pPlayer.nMapTemplateId ~= Wedding.nTourMapTemplateId then
			if self.tbMapRegister[pPlayer.dwID] then
				PlayerEvent:UnRegister(pPlayer, "OnEnterMap", self.tbMapRegister[pPlayer.dwID]);
			end
			self.tbMapRegister[pPlayer.dwID] = PlayerEvent:Register(pPlayer, "OnEnterMap", fnEncterMapCallBack);
			pPlayer.SwitchMap(Wedding.nTourMapTemplateId, 17996, 12657)
		end		
	end
end

function Wedding:OnEnterTourMap(nMapTemplateId, nOperatorId, nEngaged)
	if self.tbMapRegister[me.dwID] then
		PlayerEvent:UnRegister(me, "OnEnterMap", self.tbMapRegister[me.dwID]);
		self.tbMapRegister[me.dwID] = nil;
	end
	if me.nMapTemplateId ~= nMapTemplateId then
		return
	end
	local pOperator, pEngageder;
	if me.dwID == nOperatorId then
		pOperator = me;
		pEngageder = KPlayer.GetPlayerObjById(nEngaged)
		if not pEngageder then
			me.CenterMsg("Xin vui lòng chờ")
			return
		end

		if pEngageder.nMapTemplateId ~= nMapTemplateId then
			return
		end
	else
		pEngageder = me;
		pOperator = KPlayer.GetPlayerObjById(nOperatorId)
		if not pOperator then
			me.CenterMsg("Xin vui lòng chờ")
			return
		end

		if pOperator.nMapTemplateId ~= nMapTemplateId then
			return
		end
	end
	Wedding:TryStartBookWedding(pOperator)
end


-- pPlayer是花钱预订的玩家，pEngageder是没花钱的玩家
function Wedding:MakeLoveRelation(pPlayer, pEngageder, nWeddingLevel)
	local bSetValState = KFriendShip.SetFriendShipVal(pPlayer.dwID, pEngageder.dwID, FriendShip:WeddingStateType(), Wedding.State_Marry);
	local bSetValTime = KFriendShip.SetFriendShipVal(pPlayer.dwID, pEngageder.dwID, FriendShip:WeddingTimeType(), GetTime());
	pPlayer.SetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyWeddingLevel, nWeddingLevel);
	pEngageder.SetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyWeddingLevel, nWeddingLevel);
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nWeddingLevel]
	pPlayer.DeleteTitle(Wedding.ProposeTitleId, true)
	pEngageder.DeleteTitle(Wedding.ProposeTitleId, true)
	local nPlayerSex = pPlayer.GetUserValue(self.nSaveGrp, self.nSaveKeyGender);
	local nEngagederSex = pEngageder.GetUserValue(self.nSaveGrp, self.nSaveKeyGender);
	if tbMapSetting.tbMarryAward[nPlayerSex] then
		pPlayer.SendAward(tbMapSetting.tbMarryAward[nPlayerSex], true, nil, Env.LogWay_WeddingMarryAward);
	end
	if tbMapSetting.tbMarryAward[nEngagederSex] then
		pEngageder.SendAward(tbMapSetting.tbMarryAward[nEngagederSex], true, nil, Env.LogWay_WeddingMarryAward);
	end
	local tbSuffix = {[Gift.Sex.Boy] = "Nương Tử", [Gift.Sex.Girl] = "Phu Quân"}
	self:_SetTitle(pPlayer, string.format("%s của %s", pEngageder.szName, tbSuffix[nEngagederSex] or "Người yêu"), nil, true)
	self:_SetTitle(pEngageder, string.format("%s của %s", pPlayer.szName, tbSuffix[nPlayerSex] or "Người yêu"), nil, true)
	pPlayer.OnEvent("OnMarry", pEngageder);
	Item:SetEquipPosString(pPlayer, Item.EQUIPPOS_RING, string.format("「%s」%s", tbSuffix[nPlayerSex] or "", pEngageder.szName))
	Item:SetEquipPosString(pEngageder, Item.EQUIPPOS_RING, string.format("「%s」%s", tbSuffix[nEngagederSex] or "", pPlayer.szName))
	Wedding:SendRedBag(pPlayer, pEngageder, pPlayer.GetVipLevel())
	FriendShip:AddViewRelationModifyFlag(pPlayer.dwID)
	FriendShip:AddViewRelationModifyFlag(pEngageder.dwID)
	Log("Wedding fnMakeLoveRelation ", pPlayer.dwID, pPlayer.szName, pEngageder.dwID, pEngageder.szName, bSetValState and 1 or 0, bSetValTime and 1 or 0, nPlayerSex, nEngagederSex)
	return bSetValState and bSetValTime
end

-- 订婚礼
function Wedding:TryBookWedding(pPlayer, nLevel, nBookTime)
	local bRet, szMsg = Wedding:CheckOpen(nLevel, nBookTime)
	if not bRet then
		pPlayer.CenterMsg(szMsg or "Xin vui lòng chờ")
		return
	end
	local nWeddingCost, szErrMsg, _, tbMapSetting = self:CheckBeforeBook(pPlayer, nLevel, nBookTime)
	if not nWeddingCost then
		pPlayer.CenterMsg(szErrMsg, true)
		return 
	end
	-- 消耗道具
	if not tonumber(nWeddingCost) then
		local bRet, szMsg = self:CheckConsumeItem(pPlayer, nWeddingCost)
		if not bRet then
			pPlayer.CenterMsg(szMsg)
			return
		end
	else
	-- 消耗元宝
		if pPlayer.GetMoney("Gold") < nWeddingCost then
			pPlayer.CenterMsg("Nguyên bảo không đủ", true)
			return 
		end
	end
	
	local function fnCostCallback(nPlayerId, bSuccess, szBillNo, nLevel, nBookTime, nWeddingCost)
		return self:DoBookWedding(nPlayerId, bSuccess, nLevel, nBookTime, nWeddingCost)
	end

	if not tonumber(nWeddingCost) then
		self:DoBookWedding(pPlayer.dwID, true, nLevel, nBookTime, nWeddingCost)
	else
		local bRet = pPlayer.CostGold(nWeddingCost, Env.LogWay_WeddingBook, nil, fnCostCallback, nLevel, nBookTime, nWeddingCost);
		if not bRet then
			pPlayer.CenterMsg("Trả tiền thất bại hãy kiểm tra lại hành trang!");
		end
	end
end

-- 正式订婚礼
function Wedding:DoBookWedding(nPlayerId, bSuccess, nLevel, nBookTime, nCost)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if not pPlayer then
		return false, "Đang xử lý, bạn đang offline!";
	end
	if not bSuccess then
		pPlayer.CenterMsg("Thanh toán thất bại, vui lòng thử lại sau!", true)
		return false, "Thanh toán thất bại, vui lòng thử lại sau!";
	end
	local nWeddingCost, szErrMsg, pEngageder, tbMapSetting = self:CheckBeforeBook(pPlayer, nLevel, nBookTime)
	if not nWeddingCost then
		pPlayer.CenterMsg(szErrMsg, true)
		return false, szErrMsg
	end

	if not tonumber(nWeddingCost) then
		local bRet, szMsg = self:DoConsumeItem(pPlayer, nWeddingCost)
		if not bRet then
			pPlayer.CenterMsg(szMsg, true)
			return
		end
	end 
	-- 清理玩家的预订数据
	Wedding:ClearPlayerBook(pPlayer.dwID)
	Wedding:ClearPlayerBook(pEngageder.dwID)

	local nPlayerSex = pPlayer.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
	local nEngagedSex = pEngageder.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
	local bSetFriendShipVal
	local nOperationType = 0
	local bOpenMail
	-- 添加玩家预订数据
	if tbMapSetting.bBook then
		local tbBook = self:GetScheduleData(nLevel)
		local nBook = tbMapSetting.fnGetDate(nBookTime)
		tbBook[nBook] = tbBook[nBook] or {}
		local tbPlayerBookInfo = 
		{
			nBookTime = nBookTime; 												
			tbPlayer = {[nPlayerId] = nPlayerSex, [pEngageder.dwID] = nEngagedSex};
			tbCost = {[nPlayerId] = nCost};
		}
		table.insert(tbBook[nBook], tbPlayerBookInfo)
		-- 如果申请的婚期是当天，发提醒邮件
		if tbMapSetting.fnCheckBookIsOpen(nBook) then
			bOpenMail = Wedding:TrySendBookWarnMail(tbBook[nBook][#tbBook[nBook]], tbMapSetting)
		end
		self:ScheduleDataAlter()
		nOperationType = Wedding.nOperationType_Book

		local szDateStr = tbMapSetting.fnGetDateStr(nBookTime) or ""
		local szMsg = string.format("Chúc mừng[FFFE0D]「%s」[-]và[FFFE0D]「%s」[-]ở Nguyệt Lão đã dự định hôn lễ[FFFE0D]「%s」[-]thành công, hôn lễ dự định vào %s", pPlayer.szName, pEngageder.szName, tbMapSetting.szWeddingName, szDateStr)
		KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1)
		if pPlayer.dwKinId ~= 0 then
            szMsg = string.format("Chúc mừng thành viên bang hội[FFFE0D]「%s」[-]và[FFFE0D]「%s」[-]ở Nguyệt Lão đã dự định hôn lễ[FFFE0D]「%s」[-]thành công, hôn lễ dự định vào %s", pPlayer.szName, pEngageder.szName, tbMapSetting.szWeddingName, szDateStr)
            ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, pPlayer.dwKinId);
        end
        if pEngageder.dwKinId ~= 0 and pEngageder.dwKinId ~= pPlayer.dwKinId then
            szMsg = string.format("Chúc mừng[FFFE0D]「%s」[-]và[FFFE0D]「%s」[-]ở Nguyệt Lão đã dự định hôn lễ[[FFFE0D]「%s」[-]thành công, hôn lễ dự định vào %s", pEngageder.szName, pPlayer.szName, tbMapSetting.szWeddingName, szDateStr)
            ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szMsg, pEngageder.dwKinId);
        end
		Log("Wedding fnDoBookWedding Book Ok >>", nBook, tostring(os.date("%c", nBookTime)))
		Lib:LogTB(tbBook)
	else
		-- 直接开启
		bSetFriendShipVal = Wedding:MakeLoveRelation(pPlayer, pEngageder, nLevel)
		local pBoy, pGirl
		if nPlayerSex == Gift.Sex.Boy then
			pBoy = pPlayer
			pGirl = pEngageder
		else
			pBoy = pEngageder
			pGirl = pPlayer
		end
		local bRet, szMsg = Wedding:CreateWeddingFuben(pBoy, pGirl, nLevel)
		if not bRet then
			pPlayer.CenterMsg(szMsg, true)
			Log("Wedding fnDoBookWedding Start Wedding fail >>", pPlayer.dwID, pPlayer.szName, pEngageder.dwID, pEngageder.szName, nWeddingCost, szMsg)
		end
		nOperationType = Wedding.nOperationType_Open
	end
	local szDateStr = tbMapSetting.fnGetDateStr(nBookTime) or ""
	local szWeddingName = tbMapSetting.szWeddingName or ""
	local szDate = tbMapSetting.szDate
	if not bOpenMail and tbMapSetting.bBook then
		local tbPlayerMail = {
			To = pPlayer.dwID;
			Title = "Dự Định Hôn Lễ";
			From = "Nguyệt Lão";
			Text = string.format(" Chúc mừng ngươi và「%s」dự định hôn lễ[FFFE0D]「%s」[-]thành công, đám cưới dự định được tổ chức vào [FFFE0D]%s[-]. Thời gian tiến hành hôn lễ %s vào khoảng thời gian [FFFE0D]10:00~24:00[-], các ngươi tiến hành tổ đội tới gặp ta để tổ chức hôn lễ.\n  [FFFE0D]Nhắc nhở: Nếu không ước định được thời gian hôn lễ, tiêu hao một nữa số phí đã đặt tiệc.[-]", pEngageder.szName, szWeddingName, szDateStr, szDate);
			nLogReazon = Env.LogWay_WeddingBook;
		};
		Mail:SendSystemMail(tbPlayerMail);

		local tbEngagedeMail = {
			To = pEngageder.dwID;
			Title = "Dự Định Hôn Lễ";
			From = "Nguyệt Lão";
			Text = string.format(" Chúc mừng ngươi và「%s」dự định hôn lễ[FFFE0D]「%s」[-]thành công, đám cưới dự định được tổ chức vào [FFFE0D]%s[-]. Thời gian tiến hành hôn lễ %s vào khoảng thời gian [FFFE0D]10:00~24:00[-], các ngươi tiến hành tổ đội tới gặp ta để tổ chức hôn lễ.\n  [FFFE0D]Nhắc nhở: Nếu không ước định được thời gian hôn lễ, tiêu hao một nữa số phí đã đặt tiệc.[-]", pPlayer.szName, szWeddingName, szDateStr, szDate);
			nLogReazon = Env.LogWay_WeddingBook;
		};
		Mail:SendSystemMail(tbEngagedeMail);
	end
	if tbMapSetting.bBook then
		pPlayer.CenterMsg(string.format("Dự định hôn lễ[FFFE0D]「%s」[-]thành công, đám cưới dự định vào [FFFE0D]%s[-]", szWeddingName, szDateStr), true)
		pEngageder.CenterMsg(string.format("Dự định hôn lễ[FFFE0D]「%s」[-]thành công, đám cưới dự định vào [FFFE0D]%s[-]", szWeddingName, szDateStr), true)
	end
	Wedding:SynSchedule(pPlayer)
	Wedding:SynSchedule(pEngageder)
	Log("Wedding fnDoBookWedding ok", pPlayer.szName, nPlayerId, pEngageder.dwID, pEngageder.szName, nLevel, nBookTime, nWeddingCost, nPlayerSex, nEngagedSex, bSetFriendShipVal or 0, bOpenMail or 0)
	pPlayer.TLog("WeddingFlow", nOperationType, nLevel, pEngageder.dwID, 0, nPlayerSex, nEngagedSex, nBookTime, pPlayer.dwID)
	pEngageder.TLog("WeddingFlow", nOperationType, nLevel, pPlayer.dwID, 0, nEngagedSex, nPlayerSex, nBookTime, pPlayer.dwID)
end

function Wedding:CheckConsumeItem(pPlayer, szItem)
	local tbStrItem = Lib:SplitStr(szItem, "|")
	for _, szItemInfo in ipairs(tbStrItem) do
		local tbItem = Lib:SplitStr(szItemInfo, ";")
		local nItemId = tonumber(tbItem[1])
		local nCount = tonumber(tbItem[2])
		local nHave = pPlayer.GetItemCountInAllPos(nItemId);
		if nHave < nCount then
			return false, string.format("【%s】không đủ", KItem.GetItemShowInfo(nItemId, pPlayer.nFaction, pPlayer.nSex) or "")
		end
	end
	return true
end

function Wedding:DoConsumeItem(pPlayer, szItem)
	local tbStrItem = Lib:SplitStr(szItem, "|")
	for _, szItemInfo in ipairs(tbStrItem) do
		local tbItem = Lib:SplitStr(szItemInfo, ";")
		local nItemId = tonumber(tbItem[1])
		local nCount = tonumber(tbItem[2])
		local nConsume = pPlayer.ConsumeItemInAllPos(nItemId, nCount, Env.LogWay_Wedding);
		if nConsume < nCount then
			Log("Wedding fnDoConsumeItem fail", szItem, pPlayer.dwID, pPlayer.szName, nItemId, nCount, nConsume)
			return false, string.format("Tiêu hao đạo cụ 【%s】 thất bại", KItem.GetItemShowInfo(nItemId, pPlayer.nFaction, pPlayer.nSex) or "")
		end
	end
	return true
end

function Wedding:CheckBeforeBook(pPlayer, nLevel, nBookTime)
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
	if not tbMapSetting then
		return false, "Không thể đặt tiệc cưới cấp này"
	end
	local szDebtTip = "「%s」đang nợ tiền, không thể đặt trước hôn lễ"
	if not tbMapSetting.bBook then
		szDebtTip = "「%s」đang nợ tiền, không thể đặt trước hôn lễ"
		local nOpenDay = Wedding:GetStartOpen(tbMapSetting)
		if tbMapSetting.fnGetDate() ~= nOpenDay then
			return false, "Tạm chưa mở ra "
		end
		local bRet, szMsg = Wedding:CheckOpenTime()
		if not bRet then
			return false, szMsg
		end
	end
	if pPlayer.GetMoneyDebt("Gold") > 0 then
		return false, string.format(szDebtTip, pPlayer.szName)
	end
	local nEngaged = Wedding:GetEngaged(pPlayer.dwID)
	if not nEngaged then
		return false, "Chỉ có quan hệ đính hôn mới có thể dự định hôn lễ"
	end
	local pEngageder, szMsg = Wedding:CheckEngagedTeam(pPlayer, true)
	if not pEngageder then
		return false, szMsg
	end
	if pEngageder.GetMoneyDebt("Gold") > 0 then
		return false, string.format(szDebtTip, pEngageder.szName)
	end
	if pPlayer.nState ~= Player.emPLAYER_STATE_NORMAL then
        return false, "Đang trong trạng thái bất thường, không thể thao tác"
    end
    if pEngageder.nState ~= Player.emPLAYER_STATE_NORMAL then
        return false, string.format("「%s」Không thể hoạt động trong trạng thái bất thường", pEngageder.szName)
    end
    local bRet, szMsg = Wedding:CheckWeddingSex(pPlayer, pEngageder)
    if not bRet then
    	return false, szMsg
    end
	local nMapId1, nX1, nY1 = pPlayer.GetWorldPos()
    local nMapId2, nX2, nY2 = pEngageder.GetWorldPos()
    local fDists = Lib:GetDistsSquare(nX1, nY1, nX2, nY2)
    if fDists > (Wedding.BOOK_WEDDING_MIN_DISTANCE * Wedding.BOOK_WEDDING_MIN_DISTANCE) or nMapId1 ~= nMapId2 then
        return false, "Đại sự như thế ngươi cùng người yêu cùng nhau dắt tay lại đây tiến hành"
    end

    if tbMapSetting.nNeedVip and pPlayer.GetVipLevel() < tbMapSetting.nNeedVip then
    	return false, string.format("Kiếm hiệp %s mới có thể đặt trước", tbMapSetting.nNeedVip)
    end

	if tbMapSetting.bBook then
		local bRet, szMsg = self:CheckBook(pPlayer, nLevel, nBookTime)
		if not bRet then
			return false, szMsg
		end
	end
	local nWeddingCost, szCostMsg = self:CheckCost(pPlayer, nLevel, nBookTime)
	if not nWeddingCost then
		return false, szCostMsg
	end
	return nWeddingCost, nil, pEngageder, tbMapSetting
end
--[[
	已经预订婚期处理：
		情况1：所预订的婚礼还没过期
			1> 可以改成较高档的婚礼，费用为较高档的婚礼费用
		情况2：所预订的婚礼已经过期
			1> 可以预订任意一档，若预订同档婚礼可以优惠补交一部分钱即可，
		其它档次按该档次正常收费
	]]
-- 关于收费问题
function Wedding:CheckCost(pPlayer, nLevel, nBookTime)
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
	local nCost = tbMapSetting and tbMapSetting.nCost
	if not nCost then
		return false, "Không thể đặt tiệc cưới cấp này"
	end
	-- nOpen 预定的即将举行婚礼的时间点，bOverdue是否已经过期
	local nBookLevel, tbPlayerBookInfo, nOpen = self:CheckPlayerHadBook(pPlayer.dwID)
	-- 已经预定了婚礼,保证该婚礼是没举办过的（那么肯定是中档或高档婚礼）
	if nBookLevel and not tbPlayerBookInfo.nOpenTime then
		local tbMapBookSetting = Wedding.tbWeddingLevelMapSetting[nBookLevel]
		if not tbMapBookSetting then
			return false, "Có không biết đẳng cấp dự định tư liệu??"
		end
		-- nBook 是想要预定的时间点
		local nBook = tbMapSetting.fnGetDate(nBookTime)
		-- 选择的时间点就是自己已经预定的时间点
		if nBook == nOpen then
	 		return false, "Bạn đã đặt một thời gian đám cưới"
		end
		local bOverdue = tbMapBookSetting.fnCheckBookOverdue(nOpen)
		-- 预订的婚礼已经过期
		if bOverdue then
			if nBookLevel == nLevel then
				-- 一般低档的不会有nMissCost
				nCost = tbMapSetting.nMissCost or nCost
			end
		else
		-- 预订的婚礼还没过期(升档按正常收费，不能降档或者选择同挡)
			if nBookLevel > nLevel then
				return false, "Đã đặt một đám cưới cao hơn"
			end
		end
	end
	return nCost
end

-- 预订检查
function Wedding:CheckBook(pPlayer, nLevel, nBookTime)
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
	if not tbMapSetting then
		return false, "Không thể đặt tiệc cưới cấp này"
	end
	if not tbMapSetting.bBook then
		return false, "Đám cưới của kiểu này không hỗ trợ đặt trước."
	end

	local bRet, szMsg
	if tbMapSetting.fnCheckBook then
		bRet, szMsg = tbMapSetting.fnCheckBook(pPlayer, nBookTime)
		if not bRet then
			return false, szMsg
		end
	end

	return true
end

-- 检查天的限制
function Wedding:CheckBookDay(pPlayer, nLevel, nBookTime)
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
	if not tbMapSetting then
		return false, "Không thể đặt tiệc cưới cấp này"
	end

	local nLocalDay = Wedding:GetStartOpen(tbMapSetting)
	local nBookDay = tbMapSetting.fnGetDate(nBookTime)
	if nBookDay < nLocalDay then
		return false, "Không thể đặt trước đã qua thời gian"
	end

	if nBookDay - nLocalDay + 1 > tbMapSetting.nPre then
		return false, string.format("Không thể đặt trước sau %d ngày", tbMapSetting.nPre)
	end

	local bRet, szMsg = self:CheckOpenTimes(nLevel, nBookDay)
	if not bRet then
		return false, szMsg
	end
	return true
end

-- 检查周的限制
function Wedding:CheckBookWeek(pPlayer, nLevel, nBookTime)
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
	if not tbMapSetting then
		return false, "Không thể đặt tiệc cưới cấp này"
	end
	local nLocalWeek = Wedding:GetStartOpen(tbMapSetting)
	local nBookWeek = tbMapSetting.fnGetDate(nBookTime)
	if nBookWeek < nLocalWeek then
		return false, "Không thể đặt thời điểm đã trôi qua"
	end
	if nBookWeek - nLocalWeek + 1 > tbMapSetting.nPre then
		return false, string.format("Không thể đặt trước sau %d ngày", tbMapSetting.nPre)
	end
	local bRet, szMsg = self:CheckOpenTimes(nLevel, nBookWeek)
	if not bRet then
		return false, szMsg
	end
	return true
end

-- 检查是否有人预订，目前每天或每周只能被一人预订，可扩展
function Wedding:CheckOpenTimes(nLevel, nBookFlag)
	local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
	if not tbMapSetting then
		return false, "Không thể đặt tiệc cưới cấp này"
	end
	local nMaxTimes = tbMapSetting.nMaxTimes or 0
	local tbBookInfo = Wedding:GetScheduleData(nLevel)
	local tbDetail = tbBookInfo[nBookFlag] or {}
	if #tbDetail >= nMaxTimes then
		return false, "Ai đó đã đặt"
	end
	return true
end

-- 检查玩家是否已经预定了婚期(未完成的)
function Wedding:CheckPlayerHadBook(dwID)
	local tbBook = self:GetScheduleData()
	for nLevel, tbBookInfo in pairs(tbBook) do
		for nOpen, tbDetail in pairs(tbBookInfo) do
			for _, tbPlayerBookInfo in ipairs(tbDetail) do
				if tbPlayerBookInfo.tbPlayer[dwID] and not tbPlayerBookInfo.nOpenTime then
					return nLevel, tbPlayerBookInfo, nOpen
				end
			end
		end
	end
end

-- 返回排期数据
function Wedding:GetScheduleData(nLevel)
	local tbSchedule = self:GetSaveData("WWeddingSchedule")
	tbSchedule.tbBook = tbSchedule.tbBook or {}
	local tbBook = tbSchedule.tbBook
	if nLevel then
		tbBook[nLevel] = tbBook[nLevel] or {}
		return tbBook[nLevel]
	end
	return tbBook
end

-- 将已经过期规定时间的数据清理掉(可每天定时清理)
function Wedding:CheckScheduleOverdue()
	local bAlter
	local bAlterData
	local nLocalDay = Lib:GetLocalDay()
	local tbBook = self:GetScheduleData()
	for nLevel, tbBookInfo in pairs(tbBook) do
		local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
		if tbMapSetting then
			for nOpen, tbDetail in pairs(tbBookInfo) do
				for i = #tbDetail, 1, -1 do
					local tbPlayerBookInfo = tbDetail[i]
					local nBookDay = Lib:GetLocalDay(tbPlayerBookInfo.nBookTime)
					if nLocalDay - nBookDay >= tbMapSetting.nOverdueClearDay then
						bAlter = true
						bAlterData = true
						Log("Wedding fnCheckOverdue Overdue >>", nOpen, nBookDay, nLocalDay, self:GetOverdueLog(tbPlayerBookInfo))
					end
					local nOpenTime = tbPlayerBookInfo.nOpenTime
					-- 已经举办过婚礼了
					if nOpenTime then
						-- 中档是一天后清，高档因为是按周算的，七天之后清，延迟清数据是为了不让玩家预约已经举办过婚礼的日期
						local nOpenDay = Lib:GetLocalDay(nOpenTime)
						if nLocalDay - nOpenDay >= tbMapSetting.nCompleteClearDay then
							bAlter = true
							bAlterData = true
							Log("Wedding fnCheckOverdue Complete >>", nOpen, nOpenDay, nLocalDay, self:GetOverdueLog(tbPlayerBookInfo))
						end
					end
					if bAlter then
						table.remove(tbDetail, i)
						bAlter = nil
					end
				end
			end
		end
	end
	if bAlterData then
		self:ScheduleDataAlter()
	end
	self:ClearNilData(tbBook)
	return bAlterData
end

function Wedding:GetOverdueLog(tbPlayerBookInfo)
	local szLog = ""
	for dwID in pairs((tbPlayerBookInfo or {}).tbPlayer or {}) do
		szLog = szLog ..tostring(dwID) .."_"
	end
	szLog = szLog ..tostring(tbPlayerBookInfo.nBookTime or "")
	return szLog
end

-- 清理空table数据
function Wedding:ClearNilData(tbBook)
	local bAlter
	for nLevel, tbBookInfo in pairs(tbBook or {}) do
		for nOpen, tbDetail in pairs(tbBookInfo) do
			if not next(tbDetail) then
				tbBookInfo[nOpen] = nil
				bAlter = true
			end
		end
	end
	if bAlter then
		self:ScheduleDataAlter()
	end
end

-- 清理玩家预订婚礼的数据(只有预订之后还没开启的数据才会清理)
function Wedding:ClearPlayerBook(dwID)
	local bAlter
	local tbBook = self:GetScheduleData()
	for nLevel, tbBookInfo in pairs(tbBook) do
		for nOpen, tbDetail in pairs(tbBookInfo) do
			for i = #tbDetail, 1, -1 do
				local tbPlayerBookInfo = tbDetail[i]
				if tbPlayerBookInfo.tbPlayer[dwID] and not tbPlayerBookInfo.nOpenTime then
					table.remove(tbDetail, i)
					bAlter = true
					Log("Wedding fnClearPlayerBook", dwID, nLevel, nOpen)
				end
			end
		end
	end
	if bAlter then
		self:ScheduleDataAlter()
	end
	self:ClearNilData(tbBook)
end

-- 婚礼当天给玩家发邮件提醒（可每天定点检测）
function Wedding:CheckBookMail()
	local bAlter
	local nNowTime = GetTime()
	local tbBook = self:GetScheduleData()
	for nLevel, tbBookInfo in pairs(tbBook) do
		local tbMapSetting = Wedding.tbWeddingLevelMapSetting[nLevel]
		if tbMapSetting then
			for nOpen, tbDetail in pairs(tbBookInfo) do
				-- 是否婚礼预约当天
				local bWillOpen = tbMapSetting.fnCheckBookIsOpen(nOpen)
				-- 是否预约婚礼已经过期
				local bOverdue = tbMapSetting.fnCheckBookOverdue(nOpen)
				for _, tbPlayerBookInfo in ipairs(tbDetail) do
					if bWillOpen then
						bAlter = Wedding:TrySendBookWarnMail(tbPlayerBookInfo, tbMapSetting)
					end
					if not tbPlayerBookInfo.nOpenTime then 								-- 还没举行婚礼
						if not tbPlayerBookInfo.nSendOverdueMailTime and bOverdue then
							tbPlayerBookInfo.nSendOverdueMailTime = nNowTime
							bAlter = true
							for dwID, nSex in pairs(tbPlayerBookInfo.tbPlayer) do
								local nLoverId = self:GetOtherPlayerId(tbPlayerBookInfo.tbPlayer, dwID)
								local pLoverStayInfo = KPlayer.GetRoleStayInfo(nLoverId or 0) or {}
								local szLoverName = pLoverStayInfo.szName or "Người yêu"
								local tbOverdueMail = {
									To = dwID;
									Title = "Thông Báo Quá Hạn Hôn Lễ";
									From = "Nguyệt Lão";
									Text = string.format("   Ngươi và「%s」đã dự định hôn lễ[FFFE0D]「%s」[-], vì không để ý thời gian, hiện tại đã quá hạn. Ở [FF6464FF]60 ngày [-] này ta hoàn lại [FFFE0D]một nửa số phí[-] dự định hôn lễ[FFFE0D]「%s」[-], có thể dự định hôn lễ khác.", szLoverName, tbMapSetting.szWeddingName, tbMapSetting.szWeddingName);
								};
								Mail:SendSystemMail(tbOverdueMail);
								Log("Wedding SendOverdueBookMail ", dwID, nSex, nOpen, nLoverId, szLoverName)
							end
						end
					end
				end
			end
		end	
	end
	if bAlter then
		self:ScheduleDataAlter()
	end
end

function Wedding:GetOtherPlayerId(tbPlayer, nPlayerId)
	for dwID in pairs(tbPlayer) do
		if dwID ~= nPlayerId then
			return dwID
		end
	end
end

function Wedding:TrySendBookWarnMail(tbPlayerBookInfo, tbMapSetting)
	local bSend
	if not tbPlayerBookInfo.nSendMailTime then
		bSend = true
		tbPlayerBookInfo.nSendMailTime = GetTime()
		for dwID, nSex in pairs(tbPlayerBookInfo.tbPlayer) do
			local nLoverId = self:GetOtherPlayerId(tbPlayerBookInfo.tbPlayer, dwID)
			local pLoverStayInfo = KPlayer.GetRoleStayInfo(nLoverId or 0) or {}
			local szLoverName = pLoverStayInfo.szName or "Người yêu"
			local szCurDate = tbMapSetting.szCurDate or "Hôm nay"
			local szWeddingName = tbMapSetting.szWeddingName or ""
			local tbWarnMail = {
				To = dwID;
				Title = "Nhắc Nhở Hôn Lễ";
				From = "Nguyệt Lão";
				Text = string.format("  %s ngươi và「%s」ước định hôn lễ, các ngươi đã dự định hôn lễ[FFFE0D]「%s」[-], trong %s vào khoảng thời gian [FFFE0D]10:00~24:00[-] như dự định tổ đội lại đây gặp ta tiến hành hôn lễ.\n  [FFFE0D]Nhắc nhở: Nếu trong khoảng thời gian dự định hôn lễ không tới, ta hoàn lại một nữa số tiền đã dự định.[-]", szCurDate, szLoverName, szWeddingName, szCurDate);
			};
			Mail:SendSystemMail(tbWarnMail);
			Log("Wedding SendBookWarnMail ", dwID, nSex, nLoverId, szLoverName, szWeddingName)
		end
	end
	if bSend then
		self:ScheduleDataAlter()
	end
	return bSend
end

function Wedding:ScheduleDataAlter()
	ScriptData:AddModifyFlag("WWeddingSchedule")
end

-- 同步排期数据
function Wedding:SynSchedule(pPlayer)
	local tbData = {}
	tbData.tbAllSchedule = {}
	local tbBook = self:GetScheduleData()
	for nLevel, tbMapSetting in ipairs(Wedding.tbWeddingLevelMapSetting) do
		if tbMapSetting.bBook then
			local tbBookInfo = tbBook[nLevel] or {}
			for i = 0, tbMapSetting.nPre - 1 do
				local nOpen = Wedding:GetStartOpen(tbMapSetting) + i
				if tbBookInfo[nOpen] then
					local tbDetail = Lib:CopyTB(tbBookInfo[nOpen])
					for _, tbPlayerBookInfo in ipairs(tbDetail) do
						local tbPlayer = tbPlayerBookInfo.tbPlayer or {}
						for dwID, nSex in pairs(tbPlayer) do
							tbPlayerBookInfo.tbPlayerInfo = tbPlayerBookInfo.tbPlayerInfo or {}
							local pStayInfo = KPlayer.GetPlayerObjById(dwID) or KPlayer.GetRoleStayInfo(dwID) 
							local szName = pStayInfo and pStayInfo.szName
							tbPlayerBookInfo.tbPlayerInfo[nSex] = {dwID = dwID, szName = szName}
						end
						tbPlayerBookInfo.tbPlayer = nil
					end
					tbData.tbAllSchedule[nOpen] = tbDetail
				end
			end
		end
	end
	tbData.tbMySchedule = {}
	local nBookLevel, tbPlayerBookInfo, nOpen = self:CheckPlayerHadBook(pPlayer.dwID)
	tbData.tbMySchedule.nBookLevel = nBookLevel
	tbData.tbMySchedule.nOpen = nOpen
	tbData.tbMySchedule.tbPlayerBookInfo = tbPlayerBookInfo
	pPlayer.CallClientScript("Wedding:OnSynSchedule", tbData)
end

function Wedding:LogScheduleData()
	Log("Wedding LogScheduleData Start >>>>>")
	local tbSchedule = self:GetSaveData("WWeddingSchedule")
	for nLevel, v in pairs(tbSchedule.tbBook or {}) do
		Log("Wedding LogScheduleData Level Start", nLevel)
		Lib:LogTB(v)
		Log("Wedding LogScheduleData Level End", nLevel)
	end
	Log("Wedding LogScheduleData End >>>>>")
end
