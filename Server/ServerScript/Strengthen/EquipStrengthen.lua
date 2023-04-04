
function Strengthen:OnStrengthen(pPlayer, nEquipId, nEquipPos, nCurUseAddItemCount)
	local pEquip = pPlayer.GetItemInBag(nEquipId);
	if not pEquip then
		pPlayer.CenterMsg("Trang bị không tồn tại");
		return;
	end

	local bRet, szInfo, tbTotalStone, nCombineCost = self:CanStrengthen(pPlayer, pEquip);
	if not bRet then
		pPlayer.CallClientScript("Strengthen:OnResponse", false, szInfo);
		return;
	end

	local nStrenLevel 	= self:GetStrengthenLevel(pPlayer, nEquipPos);
	local tbSetting 	= self:GetStrenSetting(nStrenLevel);
	local szPrefix 		= self.tbPosPrefixName[nEquipPos]

	local bNeedBreakThrough = self:IsNeedBreakThrough(pPlayer, nEquipPos)
	local nConsumeId, nLogWay,nNeedNum;
	if bNeedBreakThrough then
		nConsumeId 	= KItem.GetTemplateByKind(tbSetting.BreakItem);
		nNeedNum = tbSetting["BreakCount" .. szPrefix]
		nLogWay = Env.LogWay_StrengthenBreak
	else
		nConsumeId  = KItem.GetTemplateByKind(tbSetting.ConsumeItem);
		nNeedNum = tbSetting["ConsumeCount" .. szPrefix]
		nLogWay = Env.LogWay_DoStrengthen
		local nCoin = self:GetStrengthenCost(nStrenLevel, nEquipPos);
		if not pPlayer.CostMoney("Coin", nCoin, Env.LogWay_Strengthen) then
			pPlayer.CenterMsg("Bạc không đủ")
			return
		end

		if nCurUseAddItemCount > 0 then
			local nItemTemplateId =  Strengthen:GetAddScucessProbItemByPos( nEquipPos ) 
			local nMaxUseCount = Strengthen:GetCurMaxUseAddProbItem( pPlayer, nEquipPos )
			nCurUseAddItemCount = math.min(nCurUseAddItemCount, nMaxUseCount)
			if nCurUseAddItemCount > 0 then
				pPlayer.ConsumeItemInAllPos(nItemTemplateId, nCurUseAddItemCount, nLogWay)
				local nOldValue = Strengthen:GetUseItemAddProbTimes(pPlayer,  nEquipPos)
				self:SetUseItemAddProbTimes(pPlayer, nEquipPos, nOldValue + nCurUseAddItemCount)
			end
		end
	end

	local nConsumeIdTotolValue = 0;
	if tbTotalStone then --应该是消耗背包里所有的
		local nHasCount = pPlayer.GetItemCountInAllPos(nConsumeId)
		if nHasCount >= nNeedNum then
			Log(debug.traceback())
			return
		end
		if not pPlayer.CostMoney("Coin", nCombineCost, Env.LogWay_StoneCombine) then
			pPlayer.CenterMsg("Ngân lưỡng không đủ")
			return
		end
		pPlayer.ConsumeItemInAllPos(nConsumeId, nHasCount, nLogWay);
		local tbBaseInfo = KItem.GetItemBaseProp(nConsumeId);

		if not version_tx then
			nConsumeIdTotolValue = 	nConsumeIdTotolValue + tbBaseInfo.nValue * nHasCount
		end

		for i,v in ipairs(tbTotalStone) do
			if not version_tx then
				local tbBaseInfoSub = KItem.GetItemBaseProp(v[1]);
				nConsumeIdTotolValue = 	nConsumeIdTotolValue + tbBaseInfoSub.nValue * v[2]
			end			
			if not pPlayer.ConsumeItemInAllPos(v[1], v[2], nLogWay) then
				Log("StoneMgr:OnStrengthen break del Stone Miss ", v[1], v[2], pPlayer.dwID)
				return
			end
		end
		
		pPlayer.CenterMsg(string.format("Tự động hợp thành %d cái %s", nNeedNum - nHasCount, tbBaseInfo.szName), true)

	else
		if not version_tx then
			local tbBaseInfo = KItem.GetItemBaseProp(nConsumeId);
			nConsumeIdTotolValue = 	nConsumeIdTotolValue + tbBaseInfo.nValue * nNeedNum
		end
		pPlayer.ConsumeItemInAllPos(nConsumeId, nNeedNum, nLogWay);
	end

	--突破
	if bNeedBreakThrough then
		local nBreakCount = self:GetPlayerBreakCount(pPlayer, nEquipPos);
		self:SetPlayerBreakCount(pPlayer, nEquipPos, nBreakCount + 1)
		pPlayer.CallClientScript("Strengthen:OnResponse", true,"Đột phá thành công");

	else
		--强化
		local nToday = Lib:GetLocalDay()
		if nToday ~= pPlayer.GetUserValue(self.USER_VALUE_GROUP, self.SAVE_KEY_LAST_ENHANCE_DAY) then
			for i = Item.EQUIPPOS_HEAD,Item.EQUIPPOS_PENDANT do
				pPlayer.SetUserValue(self.USER_VALUE_GROUP, self.SAVE_KEY_ENHANCE_COUNT_FROM + i, 0)
			end
		end
		pPlayer.SetUserValue(self.USER_VALUE_GROUP, self.SAVE_KEY_LAST_ENHANCE_DAY, nToday)
		pPlayer.SetUserValue(self.USER_VALUE_GROUP, self.SAVE_KEY_ENHANCE_COUNT_FROM + nEquipPos, pPlayer.GetUserValue(self.USER_VALUE_GROUP, self.SAVE_KEY_ENHANCE_COUNT_FROM + nEquipPos) + 1)
		
		local nFailTime = self:GetStrengthenFailTimes(pPlayer, nEquipPos)
		local nUseScucessItemCount = self:GetUseItemAddProbTimes(pPlayer, nEquipPos)

		local nProbility = self:GetStrengthenProb(tbSetting.Probility, nFailTime, nStrenLevel, nUseScucessItemCount)
		local bFail = nProbility < MathRandom(0, 999)
		if not bFail then
			if not version_tx then
				local nRewardValueDebt = Player:GetRewardValueDebt(pPlayer.dwID);
				if nRewardValueDebt > 0 and  nProbility < 800 then
					assert(nConsumeIdTotolValue > 0)
					bFail = true
					local fnParams = nStrenLevel < 100 and 0.9 or 0.8
					local nPoint = math.floor( nConsumeIdTotolValue * fnParams / 1000)
					Player:CostRewardValueDebt(pPlayer.dwID, nPoint, Env.LogWay_Strengthen, nProbility)
					Log("Strengthen:OnStrengthen CostValueDebt", pPlayer.dwID, nRewardValueDebt, nPoint, Player:GetRewardValueDebt(pPlayer.dwID))
				end
			end
		end
		pPlayer.TLog("EnhanceLevelFlow", nEquipPos, nStrenLevel, bFail and nStrenLevel or nStrenLevel + 1, nProbility, bFail and 0 or 1)

		if bFail then
			local nNewFaliTime = nFailTime + 1
			self:SetStrengthenFailTimes(pPlayer, nEquipPos, nNewFaliTime)
			pPlayer.CallClientScript("Strengthen:OnResponse", false,"Cường hóa thất bại");

			if nNewFaliTime == 3 then
				Achievement:AddCount(pPlayer, "EnhanceFailure_1", 1);
			end
			return false;
		end

		if nFailTime ~= 0 then
			self:SetStrengthenFailTimes(pPlayer, nEquipPos, 0)
		end
		if nUseScucessItemCount ~= 0 then
			Strengthen:SetUseItemAddProbTimes(pPlayer,  nEquipPos, 0)
		end


		self:DoStrengthen(pPlayer, nEquipId, nEquipPos, nStrenLevel + 1, true);
	end
end

function Strengthen:DoStrengthen(pPlayer, nEquipId, nEquipPos, nStrenLevel, bNotify)
	local nTotalFightPower = pPlayer.GetFightPower();
	local nOldStrenLevel = self:GetStrengthenLevel(pPlayer, nEquipPos)
	if not pPlayer.SetStrengthen(nEquipPos, nStrenLevel) then
		Log("Strengthen:DoStrengthen Faild!!!", pPlayer.dwID, nEquipId, nEquipPos, nStrenLevel)
		return
	end
	pPlayer.SetUserValue(self.USER_VALUE_GROUP, nEquipPos + 1, nStrenLevel)

    local pAsyncData = KPlayer.GetAsyncData(pPlayer.dwID)
    if pAsyncData then
    	pAsyncData.SetEnhance(nEquipPos + 1, nStrenLevel)
    end

	self:UpdateEnhAtrrib(pPlayer);

	FightPower:ChangeFightPower("Strengthen", pPlayer, true);

	local nCurFightPower = pPlayer.GetFightPower();
	--需要延迟到强化成功的动画播出来
	pPlayer.CallClientScript("Strengthen:OnResponse", true, bNotify, nEquipPos, nStrenLevel, nCurFightPower, nTotalFightPower);

	local tbAcheiSet = {
		{5	, "EnhanceMaster_1"};
		{20	, "EnhanceMaster_2"};
		{40	, "EnhanceMaster_3"};
		{60	, "EnhanceMaster_4"};
		{80	, "EnhanceMaster_5"};
		{100, "EnhanceMaster_6"};
	}
	local tbAddAchieves = {"EnhanceOnce_1"};
	for i,v in ipairs(tbAcheiSet) do
		if nStrenLevel < v[1] then
			break;
		else
			if nOldStrenLevel < v[1] then
				table.insert(tbAddAchieves, v[2])
			end
		end
	end
	for i,szAchieve in ipairs(tbAddAchieves) do
		Achievement:AddCount(pPlayer, szAchieve, 1);
	end

	EverydayTarget:AddCount(pPlayer, "EquipEnhance");

	pPlayer.TLog("EnhanceFlow", nEquipPos, nStrenLevel)

	Log(string.format("Strengthen:DoStrengthen pPlayer:%d, nEquipId:%d, nEquipPos:%d, nStrenLevel:%d", pPlayer.dwID, nEquipId, nEquipPos, nStrenLevel))
end


function Strengthen:OnStrengthenCheckItemExchange(pPlayer, tbItemId )
	local tbAddScucessProbItemExchangeItems = Strengthen:GetAddScucessProbItemExchangeItems()
	for i,v in ipairs(tbItemId) do
		local pItem = pPlayer.GetItemInBag(v)
		if not pItem then
			Log("Error1 Strengthen:OnStrengthenCheckItemExchange", pPlayer.dwID)
			return
		end
		local nReplaceItemid = tbAddScucessProbItemExchangeItems[pItem.dwTemplateId]
		if not nReplaceItemid then
			Log("Error2 Strengthen:OnStrengthenCheckItemExchange", pPlayer.dwID)
			return
		end

		local nCount = pItem.nCount
		local szOldName = pItem.szName
		
		pItem.Delete(Env.LogWay_Strengthen)
		local pNewItem = pPlayer.AddItem(nReplaceItemid, nCount, nil, Env.LogWay_Strengthen)
		if pNewItem then
			pPlayer.CenterMsg(string.format("Bạn đã thay thế %s thành %s", szOldName, pNewItem.szName), true)
		end
	end
end