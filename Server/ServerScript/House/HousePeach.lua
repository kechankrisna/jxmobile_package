local tbPeach = House.tbPeach;

tbPeach.tbFairylandMapInfo = tbPeach.tbFairylandMapInfo or {}; -- 当前开启的地图信息
tbPeach.tbFairylandCacheData = tbPeach.tbFairylandCacheData or {};
tbPeach.tbMapId2FairyId = tbPeach.tbMapId2FairyId or {};

function tbPeach:EnterFairyland(nPlayerId, nOwerId, bInvited)
	nOwerId = nOwerId or nPlayerId;

	if not self:HasFairyland(nOwerId) then
		return false, "Huyễn cảnh không tồn tại";
	end

	local nMapId = tbPeach:GetFairylandMapId(nOwerId);
	if nMapId and self:GetFairylandPlayerCount(nMapId) >= tbPeach.FAIRYLAND_MAX_ENTER_PLAYER then
		return false, "Vì một loại nhân tố nào đó bất khả kháng bạn tạm thời không thể vào huyễn cảnh!";
	end

	if bInvited then
		local pInviter = KPlayer.GetPlayerObjById(nOwerId);
		if not pInviter or pInviter.nMapId ~= nMapId then
			return false, "Mời đã hết hạn!";
		end
	else
		if nPlayerId ~= nOwerId then
			return false, "Bạn không có quyền vào huyễn cảnh!";
		end
	end

	self:CallWithFairylandLoaded(nOwerId, function ()
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
		local nMapId = tbPeach:GetFairylandMapId(nOwerId);
		if not pPlayer or pPlayer.nMapId == nMapId then
			return;
		end

		pPlayer.SetEntryPoint();

		local nX, nY = Map:GetDefaultPos(tbPeach.FAIRYLAND_MAP_TEMPLATE_ID);
		pPlayer.SwitchMap(nMapId, nX, nY);
	end);
	return true;
end

function tbPeach:GoFairyland(pPlayer)
	local nOwerId = House:GetHouseInfoByMapId(pPlayer.nMapId);
	if not nOwerId then
		return false, "Bạn không ở nhà trong vườn, không thể vào huyễn cảnh!";
	end

	if not Env:CheckSystemSwitch(pPlayer, Env.SW_SwitchMap) then
		return false, "Trạng thái hiện tại không được đổi bản đồ";
	end

	return self:EnterFairyland(pPlayer.dwID, nOwerId);
end

function tbPeach:InvitedIntoFairyland(pPlayer, nInviterId)
	if not Env:CheckSystemSwitch(pPlayer, Env.SW_SwitchMap) then
		return false, "Trạng thái hiện tại không được đổi bản đồ";
	end

	return self:EnterFairyland(pPlayer.dwID, nInviterId, true);
end

function tbPeach:Water(pPlayer)
	local nOwerId = House:GetHouseInfoByMapId(pPlayer.nMapId);
	if not nOwerId then
		return false, "Bạn không ở nhà trong vườn, không thể tưới nước!";
	end

	local tbPeachData = self:GetPeachData(nOwerId);
	if not tbPeachData.nFertilizerId then
		return false, "Hãy bón phân cho cây con trước!";
	end

	if pPlayer.dwID == nOwerId or pPlayer.dwID == tbPeachData.nFairyId then
		return false, "Không thể tưới cây đào của riêng bạn!";
	end

	if not FriendShip:IsFriend(pPlayer.dwID, nOwerId) then
		return false, "Bạn không phải là bạn của chủ vườn, bạn không thể tưới nước!";
	end

	local nToday = Lib:GetLocalDay();
	if nToday == tbPeachData.nWaterDay then
		return false, "Hôm nay nó đã được tưới nước!";
	end

	if tbPeachData.nWater >= tbPeach.WATER_STATE_MATRUE_COUNT then
		return false, "Cây đào đã trưởng thành và không cần phải tưới nước!";
	end

	local pItemBottle = unpack(pPlayer.FindItemInBag(tbPeach.WATER_BOTTLE_ITEM_ID));
	if not pItemBottle then
		return false, "Bạn không có ấm nước!";
	end

	local nWaterDay = pItemBottle.GetIntValue(tbPeach.WATER_BOTTLE_INT_VALUE_DAY);
	if nToday == nWaterDay then
		return false, "Bạn đã sử dụng ấm nước ngày hôm nay!";
	end

	pItemBottle.SetIntValue(tbPeach.WATER_BOTTLE_INT_VALUE_DAY, nToday);

	local nBottleWaterCount = pItemBottle.GetIntValue(tbPeach.WATER_BOTTLE_INT_VALUE_COUNT);
	nBottleWaterCount = nBottleWaterCount + 1;
	if nBottleWaterCount >= tbPeach.WATER_BOTTLE_MAX_USE_COUNT then
		pItemBottle.Delete(Env.LogWay_UseItem, nBottleWaterCount);
	else
		pItemBottle.SetIntValue(tbPeach.WATER_BOTTLE_INT_VALUE_COUNT, nBottleWaterCount);
	end

	tbPeachData.nWater = tbPeachData.nWater + 1;
	tbPeachData.nWaterDay = nToday;

	if tbPeachData.nWater >= tbPeach.WATER_STATE_MATRUE_COUNT then
		local nFertilizerId = tbPeachData.nFertilizerId;
		local tbFertilizerData = self:GetPeachData(nFertilizerId);
		if tbFertilizerData.nFairyId and tbFertilizerData.nFairyId ~= 0 then
			tbPeachData.nFairyId = tbFertilizerData.nFairyId;
		else
			tbPeachData.nFairyId = nOwerId;
		end

		tbPeachData.nWaterDay = 0; -- 养成后可立即进行护持，此处清零

		Mail:SendSystemMail({
			To = nOwerId;
			Title = "Cây đào trưởng thành trong nhà của họ";
			Text = "Cây đào của những anh hùng vừa mới lớn, hãy đi xem nào!";
		});
	end

	self:Save(nOwerId);

	FriendShip:AddImitity(pPlayer.dwID, nOwerId, tbPeach.WATER_FRIEND_IMITY_AWARD, Env.LogWay_HousePeachWater);
	KPlayer.MapBoardcastScript(pPlayer.nMapId, "House.tbPeach.OnSyncPeachData", tbPeachData);
	pPlayer.CenterMsg("Tưới nước thành công! Cây đào nhỏ mọc lại!");
	return true;
end

function tbPeach:Fertilizer(pPlayer, bNoConfirm)
	local nOwerId = House:GetHouseInfoByMapId(pPlayer.nMapId);
	if not nOwerId then
		return false, "Bạn không ở nhà, bạn không thể tưới nước!";
	end

	local tbPeachData = self:GetPeachData(nOwerId);
	if tbPeachData.nFertilizerId then
		return false, "Cây giống đã được thụ tinh!";
	end

	if pPlayer.dwID ~= nOwerId and not FriendShip:IsFriend(pPlayer.dwID, nOwerId) then
		return false, "Bạn không phải là bạn của chủ vườn, bạn không thể thụ tinh!";
	end

	local pItem = unpack(pPlayer.FindItemInBag(tbPeach.FERTILIZE_ITEM_ID));
	if not pItem then
		return false, "Bạn không có phân bón!";
	end

	if bNoConfirm then
		pItem.Delete(Env.LogWay_UseItem, nOwerId);
		tbPeachData.nFertilizerId = pPlayer.dwID;
		self:Save(nOwerId);

		FriendShip:AddImitity(pPlayer.dwID, nOwerId, tbPeach.FERTILIZER_FRIEND_IMITY_AWARD, Env.LogWay_HousePeachFertilizer);
		KPlayer.MapBoardcastScript(pPlayer.nMapId, "House.tbPeach.OnSyncPeachData", tbPeachData);
		pPlayer.CenterMsg("Đã bón phân");

		if pPlayer.dwID ~= nOwerId then
			local tbMyPeachData = self:GetPeachData(pPlayer.dwID);
			if tbMyPeachData.nFertilizerId == nOwerId then
				local szMail = "Đại hiệp cùng %s lẫn nhau vì đối phương cây hoa đào mầm non bón phân, tạo thành một loại nào đó thần bí quan hệ, mau mau đem nuôi lớn phát hiện cái này chỗ thần bí đến tột cùng vì sao đi!";
				Mail:SendSystemMail({
					To = nOwerId;
					Title = "Cây hoa đào thần bí quan hệ";
					Text = string.format(szMail, pPlayer.szName);
				});

				local pOwer = KPlayer.GetRoleStayInfo(nOwerId);
				if pOwer then
					Mail:SendSystemMail({
						To = pPlayer.dwID;
						Title = "Cây hoa đào thần bí quan hệ";
						Text = string.format(szMail, pOwer.szName);
					});
				end
			end
		end
	else
		local function fnFertilizer()
			tbPeach:Fertilizer(me, true);
		end
		local szTip = "Lẫn nhau cho đối phương mầm non bón phân song phương có thể kết thành một loại thần bí đặc thù quan hệ, xác nhận vì mình mầm non bón phân?";
		if pPlayer.dwID ~= nOwerId then
			local tbRoleStayInfo = KPlayer.GetRoleStayInfo(nOwerId) or {};
			szTip = string.format("Lẫn nhau cho đối phương mầm non bón phân song phương có thể kết thành một loại thần bí đặc thù quan hệ, xác định là「%s」mầm non bón phân?", tbRoleStayInfo.szName or "??");
		end
		pPlayer.MsgBox(szTip, {{"Xác định", fnFertilizer}, {"Hủy"}})
	end

	return true;
end

function tbPeach:BringUpFairylandPeach(pPlayer)
	local nTeamId = pPlayer.dwTeamID;
	local tbTeamData = TeamMgr:GetTeamById(nTeamId);
	if not tbTeamData then
		return false, "Đại hiệp hiện tại không có đội ngũ!";
	end

	if tbTeamData:GetMemberCount() ~= tbPeach.FAIRYLAND_BRINGUP_TEAM_MEMBER_COUNT then
		return false, "Đội ngũ nhân số không phải hai người!";
	end

	local nMapId = me.nMapId;
	local nFairyId = self:GetFairyIdByMap(nMapId);
	if not nFairyId then
		return false, "Ngươi không phải huyễn cảnh chủ nhân không thể thao tác!";
	end

	local tbPeachData = self:GetPeachData(pPlayer.dwID);
	if tbPeachData.nFairyId ~= nFairyId then
		return false, "Ngươi không phải huyễn cảnh chủ nhân không thể thao tác!";
	end

	local nToday = Lib:GetLocalDay();
	local tbMember = tbTeamData:GetMembers();
	for _, nPlayerId in pairs(tbMember) do
		local pMember = KPlayer.GetPlayerObjById(nPlayerId);
		if not pMember or pMember.nMapId ~= nMapId then
			return false, "Có đội viên không tại bên trong ảo cảnh!";
		else
			local nBringUpDay = pMember.GetUserValue(tbPeach.PEACH_BRINGUP_IN_VALUE_GROUP, tbPeach.PEACH_BRINGUP_IN_VALUE_KEY);
			if nBringUpDay == nToday then
				return false, string.format("「%s」hôm nay đã không có bảo vệ số lần!", pMember.szName);
			end
		end
	end

	local tbFairyPeachData = self:GetPeachData(nFairyId);
	if tbFairyPeachData.nWater >= (tbPeach.FAIRYLAND_MAX_TREE_COUNT * tbPeach.WATER_STATE_MATRUE_COUNT) then
		return false, "Cây hoa đào đã thành quen, không cần bảo vệ!";
	end

	if tbFairyPeachData.nWaterDay == nToday then
		return false, "Cây hoa đào một ngày chỉ có thể lấy bị bảo vệ 1 lần!";
	end

	return self:DoTeamBringUp(tbTeamData, nFairyId);
end

function tbPeach:DoTeamBringUp(tbTeamData, nFairyId)
	local tbFairyPeachData = self:GetPeachData(nFairyId);
	local nTreeIdx = math.floor(tbFairyPeachData.nWater / tbPeach.WATER_STATE_MATRUE_COUNT) + 1;
	local tbPosInfo = tbPeach.FAIRYLAND_BRINGUP_POS_DIR[nTreeIdx];
	local nToday = Lib:GetLocalDay();

	if tbFairyPeachData.nTryBringUpDay == nToday then
		return false, "Cây hoa đào đang bị bảo vệ bên trong!";
	end
	tbFairyPeachData.nTryBringUpDay = nToday;

	local tbMember = tbTeamData:GetMembers();
	for i, nPlayerId in pairs(tbMember) do
		Decoration:ExitPlayerActState(nPlayerId);

		local nX, nY, nDir = unpack(tbPosInfo[i]);
		local pMember = KPlayer.GetPlayerObjById(nPlayerId);
		pMember.SetPosition(nX, nY);
		pMember.GetNpc().SetDir(nDir);
		Env:SetSystemSwitchOff(pMember, Env.SW_All);

		pMember.GetNpc().CastSkill(tbPeach.FAIRYLAND_BRINGUP_SKILL, 1, nX, nY);
		ActionMode:DoForceNoneActMode(pMember);

		if tbPeach.FAIRYLAND_BRINGUP_EFFECTID then
			pMember.AddSkillState(tbPeach.FAIRYLAND_BRINGUP_EFFECTID, 1, 0, Env.GAME_FPS * tbPeach.FAIRYLAND_BRINGUP_TIME);
		end

		pMember.CallClientScript("Ui:CloseWindow", "PeachPanel");
		pMember.CallClientScript("Ui:OpenWindow", "ChuangGongPanel", false, false, false, false, false, false, "PeachBringUp");
		Log("DoTeamBringUp", tbTeamData.nTeamID, nPlayerId);
	end

	Timer:Register(Env.GAME_FPS * tbPeach.FAIRYLAND_BRINGUP_TIME, self.AfterBringUpFairylandPeach, self, tbTeamData.nTeamID, nFairyId);
end

function tbPeach:AfterBringUpFairylandPeach(nTeamId, nFairyId)
	local tbFairyPeachData = self:GetPeachData(nFairyId);
	tbFairyPeachData.nTryBringUpDay = nil;

	local tbTeamData = TeamMgr:GetTeamById(nTeamId);
	if not tbTeamData then
		Log("AfterBringUpFairylandPeach Fail.", nTeamId);
		return;
	end

	local nToday = Lib:GetLocalDay();
	local tbMember = tbTeamData:GetMembers();
	for _, nPlayerId in pairs(tbMember) do
		local pMember = KPlayer.GetPlayerObjById(nPlayerId);
		if pMember then
			pMember.SetUserValue(tbPeach.PEACH_BRINGUP_IN_VALUE_GROUP, tbPeach.PEACH_BRINGUP_IN_VALUE_KEY, nToday);
			pMember.SendAward(tbPeach.FAIRYLAND_BRINGUP_AWARD, true, false, Env.LogWay_HousePeachBringUp);
			pMember.CallClientScript("Ui:CloseWindow", "ChuangGongPanel");
			pMember.GetNpc().RestoreAction();
			if tbPeach.FAIRYLAND_BRINGUP_EFFECTID then
				pMember.RemoveSkillState(tbPeach.FAIRYLAND_BRINGUP_EFFECTID);
			end
			Env:SetSystemSwitchOn(pMember, Env.SW_All);
		end
	end

	tbFairyPeachData.nWater = tbFairyPeachData.nWater + 1;
	tbFairyPeachData.nWaterDay = nToday;
	self:Save(nFairyId);

	if tbFairyPeachData.nWater % tbPeach.WATER_STATE_MATRUE_COUNT == 0 then
		local nTree = tbFairyPeachData.nWater / tbPeach.WATER_STATE_MATRUE_COUNT;
		local tbAward = tbPeach.FAIRYLAND_TREE_MATRUE_AWARD[nTree];
		if tbAward then
			local szOwerName = self:GetFairylandOwerName(nFairyId);
			local szBroadcast = string.format("%s tại mình hoa đào huyễn cảnh bên trong thành công dưỡng thành %d gốc cây hoa đào, huyễn cảnh bên trong hoa đào bay múa, có chút lãng mạn, thật là khiến người cực kỳ hâm mộ!", szOwerName, nTree);
			local szTitle = string.format("Dưỡng thành %d gốc cây hoa đào", nTree);
			local szMail = string.format("Thành công tại huyễn cảnh bên trong dưỡng thành cây hoa đào %d gốc, nhanh đi lĩnh thưởng đi!", nTree);

			local nBroadcastKinId = nil;
			local tbOwerIds = self:GetFairylandOwerIds(nFairyId);
			for _, nPlayerId in ipairs(tbOwerIds) do
				Mail:SendSystemMail({
					To = nPlayerId;
					Title = szTitle;
					Text = szMail;
				});

				local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
				if pPlayer then
					if pPlayer.dwKinId ~= nBroadcastKinId then
						nBroadcastKinId = pPlayer.dwKinId;
						ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, szBroadcast, nBroadcastKinId);
					end

					pPlayer.CenterMsg(szMail);
				end
			end

			KPlayer.SendWorldNotify(1, 1000, szBroadcast, ChatMgr.ChannelType.Public, 1);
		end
	end

	local nMapId = self:GetFairylandMapId(nFairyId);
	KPlayer.MapBoardcastScript(nMapId, "House.tbPeach.OnSyncPeachData", tbFairyPeachData);
	self:UpdateFairylandPeachState(nMapId);
end

function tbPeach:GetFairylandOwerIds(nOwerId)
	local tbPeachData = self:GetPeachData(nOwerId);
	if tbPeachData.nFertilizerId == nOwerId then
		return {nOwerId};
	end

	local tbFertilizerPeach = self:GetPeachData(tbPeachData.nFertilizerId) or {};
	if tbFertilizerPeach.nFertilizerId == nOwerId then
		return {nOwerId, tbPeachData.nFertilizerId};
	end
	return {nOwerId};
end

function tbPeach:GetFairylandOwerName(nOwerId)
	local tbOwerIds = self:GetFairylandOwerIds(nOwerId);
	local tbName = {};
	for _, nPlayerId in ipairs(tbOwerIds) do
		local tbRoleStayInfo = KPlayer.GetRoleStayInfo(nPlayerId);
		if tbRoleStayInfo then
			table.insert(tbName, tbRoleStayInfo.szName);
		end
	end
	return table.concat(tbName, " và ");
end

function tbPeach:TakeTreeAward(pPlayer, nTreeAwardIdx)
	local nMapId = pPlayer.nMapId;
	local nFairyId = self:GetFairyIdByMap(nMapId);
	if not nFairyId then
		return false, "Ngươi không phải huyễn cảnh chủ nhân không thể thao tác!";
	end

	local tbPeachData = self:GetPeachData(pPlayer.dwID);
	if tbPeachData.nFairyId ~= nFairyId then
		return false, "Không thể nhận lấy không phải mình huyễn cảnh ban thưởng!";
	end

	if tbPeachData.nAwardIdx and nTreeAwardIdx <= tbPeachData.nAwardIdx then
		return false, "Ban thưởng đã nhận lấy qua!";
	end

	local tbFairyPeachData = self:GetPeachData(tbPeachData.nFairyId);
	local nTree = math.floor(tbFairyPeachData.nWater / tbPeach.WATER_STATE_MATRUE_COUNT);
	if nTreeAwardIdx > nTree then
		return false, "Còn chưa đạt tới lĩnh thưởng điều kiện!";
	end

	local tbAward = tbPeach.FAIRYLAND_TREE_MATRUE_AWARD[nTreeAwardIdx];
	if not tbAward then
		return false, "Không tồn tại cái này ban thưởng a!";
	end

	local nPreAwardIdx = tbPeach.FAIRYLAND_TREE_AWARD_PRE[nTreeAwardIdx];
	if nPreAwardIdx and nPreAwardIdx ~= tbPeachData.nAwardIdx then
		return false, "Mời trước nhận lấy trước một ngăn ban thưởng";
	end

	tbPeachData.nAwardIdx = nTreeAwardIdx;
	self:Save(pPlayer.dwID);

	pPlayer.SendAward(tbAward, true, false, Env.LogWay_HousePeachTree);
	pPlayer.CenterMsg("Thành công nhận lấy hoa đào huyễn cảnh ban thưởng!");

	pPlayer.CallClientScript("House.tbPeach.OnSyncMyPeachData", tbPeachData.nFairyId, tbPeachData.nAwardIdx);
	self:UpdateFairylandEffect(nMapId);
	return true;
end

function tbPeach:GetPeachData(nOwerId, bNoCreate)
	local tbHouseData = House:GetHouse(nOwerId);
	if not tbHouseData then
		return {};
	end

	if not tbHouseData.tbPeach and not bNoCreate then
		tbHouseData.tbPeach = {
			nFairyId      = nil;
			nFertilizerId = nil;
			nWater        = 0;
			nWaterDay     = 0;
			nAwardIdx     = 0;
		};
	end

	return tbHouseData.tbPeach;
end

function tbPeach:GetFairylandDataByOwerId(nOwerId)
	local tbPeachData = self:GetPeachData(nOwerId) or {};
	local nFairyId = tbPeachData.nFairyId;
	if nFairyId then
		if not self.tbFairylandCacheData[nFairyId] then
			self.tbFairylandCacheData[nFairyId] = {
				nMapId = nil;
				tbPeachNpcInfo = {};
				nEffectIdx = 0;
			};
		end

		return self.tbFairylandCacheData[nFairyId];
	end
end

function tbPeach:MarkDirty(nOwerId)
	House:MarkDirty(nOwerId);
end

function tbPeach:Save(nOwerId)
	House:Save(nOwerId);
end

-------------------------------------------------------------
function tbPeach:OnEnterHouseMap(pPlayer, nOwerId, nMapId)
	local tbPeachData = self:GetPeachData(nOwerId, true);
	if tbPeachData then
		pPlayer.CallClientScript("House.tbPeach.OnSyncPeachData", tbPeachData);
	end
end

--------------------Fairyland-------------------------------
function tbPeach:GetFairyId(nOwerId)
	local tbPeachData = self:GetPeachData(nOwerId) or {};
	return tbPeachData.nFairyId;
end

function tbPeach:GetFairyIdByMap(nMapId)
	return self.tbMapId2FairyId[nMapId];
end

function tbPeach:HasFairyland(nOwerId)
	local tbPeachData = self:GetPeachData(nOwerId);

	-- 修复先前bug导致的nFairyId没设置上的问题
	if not tbPeachData.nFairyId and tbPeachData.nWater >= tbPeach.WATER_STATE_MATRUE_COUNT then
		tbPeachData.nFairyId = nOwerId;
	end

	return tbPeachData.nWater >= tbPeach.WATER_STATE_MATRUE_COUNT;
end

function tbPeach:GetFairylandPlayerCount(nMapId)
	return self.tbFairylandMapInfo[nMapId] and self.tbFairylandMapInfo[nMapId].nPlayerCount or 0;
end

function tbPeach:GetFairylandMapId(nOwerId)
	if not self:HasFairyland(nOwerId) then
		return;
	end

	local tbFairylandData = self:GetFairylandDataByOwerId(nOwerId);
	if tbFairylandData and tbFairylandData.nMapId then
		if GetMapInfoById(tbFairylandData.nMapId) then
			return tbFairylandData.nMapId;
		else
			tbFairylandData.nMapId = nil;
			tbFairylandData.tbPeachNpcInfo = {};
		end
	end
end

function tbPeach:SetFairylandMapId(nOwerId, nMapId)
	local nFairyId = self:GetFairyId(nOwerId);
	if nFairyId then
		local tbFairylandData = self:GetFairylandDataByOwerId(nOwerId);
		tbFairylandData.nMapId = nMapId;

		self.tbMapId2FairyId[nMapId] = nFairyId;
	end
end

function tbPeach:CallWithFairylandLoaded(nOwerId, fnCallback, ...)
	if not self:HasFairyland(nOwerId) then
		return;
	end

	local nMapId = self:GetFairylandMapId(nOwerId);
	if nMapId and self:IsFairylandLoaded(nMapId) then
		fnCallback(...);
	else
		if not nMapId then
			nMapId = CreateMap(tbPeach.FAIRYLAND_MAP_TEMPLATE_ID);
			self:SetFairylandMapId(nOwerId, nMapId);
		end
		self:CallAfterFairylandLoaded(nMapId, {fnCallback, ...});
	end
end

function tbPeach:IsFairylandLoaded(nMapId)
	return self.tbFairylandMapInfo[nMapId] and true or false;
end


tbPeach.tbFairylandLoadedCallbacks = tbPeach.tbFairylandLoadedCallbacks or {};
function tbPeach:CallAfterFairylandLoaded(nMapId, tbCallback)
	self.tbFairylandLoadedCallbacks[nMapId] = self.tbFairylandLoadedCallbacks[nMapId] or {};
	table.insert(self.tbFairylandLoadedCallbacks[nMapId], tbCallback);
end

function tbPeach:OnFairylandCreate(nMapId)
	if self.tbFairylandLoadedCallbacks[nMapId] then
		for _, tbCallback in ipairs(self.tbFairylandLoadedCallbacks[nMapId]) do
			Lib:CallBack(tbCallback);
		end
		self.tbFairylandLoadedCallbacks[nMapId] = nil;
	end

	local nFairyId = self:GetFairyIdByMap(nMapId);
	self.tbFairylandMapInfo[nMapId] = {
		nPlayerCount = 0;
		tbPlayers = {};
		nFairyId = nFairyId;
	};

	self:UpdateFairylandPeachState(nMapId);
	self:UpdateFairylandEffect(nMapId, true);

	for i, tbFurnitureInfo in ipairs(tbPeach.FAIRYLAND_FURNITURE_SETTING) do
		Decoration:NewDecoration(nMapId, tbFurnitureInfo.nPosX, tbFurnitureInfo.nPosY, tbFurnitureInfo.nRotation, tbFurnitureInfo.nTemplate, true);
	end
end

function tbPeach:UpdateFairylandPeachState(nMapId)
	local nFairyId = self:GetFairyIdByMap(nMapId);
	local tbPeachData = self:GetPeachData(nFairyId);
	local tbFairylandData = self:GetFairylandDataByOwerId(nFairyId);

	local nBringupCount = tbPeachData.nWater;
	if tbPeachData.nWaterDay == Lib:GetLocalDay() then
		nBringupCount = math.max(nBringupCount - 1, 0);
	end

	local tbNpcInfo = tbFairylandData.tbPeachNpcInfo;
	local nTreeIdx = 1;
	while nBringupCount >= 0 and tbPeach.FAIRYLAND_TREE_POS[nTreeIdx] do
		local nState = tbPeach.PEACH_STATE_WATER_MAP[nBringupCount] or tbPeach.PEACH_STATE_MATRUE;
		local nNpcTemplateId = tbPeach.PEACH_STATE_NPC_TEMPLATE[nState];

		if not tbNpcInfo[nTreeIdx] or tbNpcInfo[nTreeIdx].nNpcTemplateId ~= nNpcTemplateId then
			if tbNpcInfo[nTreeIdx] then
				local pPrePeachNpc = KNpc.GetById(tbNpcInfo[nTreeIdx].nNpcId or 0);
				if pPrePeachNpc then
					pPrePeachNpc.Delete();
				end
			end

			local pNpc = KNpc.Add(nNpcTemplateId, 1, 0, nMapId, unpack(tbPeach.FAIRYLAND_TREE_POS[nTreeIdx]));
			tbNpcInfo[nTreeIdx] = {
				nNpcTemplateId = nNpcTemplateId;
				nNpcId = pNpc.nId;
			};
		end

		nTreeIdx = nTreeIdx + 1;
		nBringupCount = nBringupCount - tbPeach.WATER_STATE_MATRUE_COUNT;
	end
end

function tbPeach:OnFairylandDestroy(nMapId)
	self.tbFairylandMapInfo[nMapId] = nil;
end

function tbPeach:OnEnterFairyland(pPlayer, nMapId)
	self.tbFairylandMapInfo[nMapId].tbPlayers[pPlayer.dwID] = true;
	self.tbFairylandMapInfo[nMapId].nPlayerCount = Lib:CountTB(self.tbFairylandMapInfo[nMapId].tbPlayers);

	local nFairyId = self:GetFairyIdByMap(nMapId);
	local tbPeachData = self:GetPeachData(nFairyId);
	pPlayer.CallClientScript("House.tbPeach.OnSyncPeachData", tbPeachData);

	local tbMyPeachData = self:GetPeachData(pPlayer.dwID) or {};
	pPlayer.CallClientScript("House.tbPeach.OnSyncMyPeachData", tbMyPeachData.nFairyId, tbMyPeachData.nAwardIdx);

	if tbPeachData.nWaterDay ~= Lib:GetLocalDay() then
		self:UpdateFairylandPeachState(nMapId);
	end

	local tbFairylandData = self:GetFairylandDataByOwerId(nFairyId);
	pPlayer.CallClientScript("House.tbPeach.OnSyncFairylandEffect", tbFairylandData.nEffectIdx or 0);

	local nCurTeamId = tbFairylandData.nTeamId or -1;
	if pPlayer.dwTeamID ~= 0 and pPlayer.dwTeamID ~= nCurTeamId then
		TeamMgr:QuiteTeam(pPlayer.dwTeamID, pPlayer.dwID);
	end

	local tbTeamData = TeamMgr:GetTeamById(nCurTeamId);
	if not tbTeamData then
		TeamMgr:Create(pPlayer.dwID, pPlayer.dwID, true);
		tbFairylandData.nTeamId = pPlayer.dwTeamID;
	else
		tbTeamData:AddMember(pPlayer.dwID, true);
	end
end

function tbPeach:UpdateFairylandEffect(nMapId, bCreateMap)
	local nFairyId = self:GetFairyIdByMap(nMapId);
	local tbFairylandData = self:GetFairylandDataByOwerId(nFairyId);

	local nPreEffectIdx = tbFairylandData.nEffectIdx or 0;
	local tbOwerIds = tbPeach:GetFairylandOwerIds(nFairyId);
	for _, nPlayerId in ipairs(tbOwerIds) do
		local tbPeachData = self:GetPeachData(nPlayerId);
		if tbPeachData.nAwardIdx and tbPeachData.nAwardIdx > nPreEffectIdx then
			tbFairylandData.nEffectIdx = tbPeachData.nAwardIdx;
		end
	end

	if nPreEffectIdx ~= tbFairylandData.nEffectIdx and not bCreateMap then
		KPlayer.MapBoardcastScript(nMapId, "House.tbPeach.OnSyncFairylandEffect", tbFairylandData.nEffectIdx);
	end
end

function tbPeach:OnLeaveFairyland(pPlayer, nMapId)
	self.tbFairylandMapInfo[nMapId].tbPlayers[pPlayer.dwID] = nil;
	self.tbFairylandMapInfo[nMapId].nPlayerCount = Lib:CountTB(self.tbFairylandMapInfo[nMapId].tbPlayers);

	TeamMgr:QuiteTeam(pPlayer.dwTeamID, pPlayer.dwID);
end

function tbPeach:OnLoginFairyland(pPlayer, nMapId)
	self:OnEnterFairyland(pPlayer, nMapId);
end

function tbPeach:InviteFriend(pPlayer, nFriendId)
	local nMapId = tbPeach:GetFairylandMapId(pPlayer.dwID);
	if nMapId and self:GetFairylandPlayerCount(nMapId) >= tbPeach.FAIRYLAND_MAX_ENTER_PLAYER then
		return false, "Nhân số đã đạt hạn mức cao nhất không thể mời";
	end

	local pFriend = KPlayer.GetPlayerObjById(nFriendId);
	if not pFriend then
		return false, "Hảo hữu hạ tuyến";
	end

	local tbPeachData = self:GetPeachData(pPlayer.dwID);
	if not tbPeachData.nFairyId then
		return false, "Ngài huyễn cảnh không tồn tại";
	end

	local tbMsgData = {
		nFairyId = pPlayer.dwID;
		szName = pPlayer.szName;
		szType = "Fairyland";
		nTimeOut = GetTime() + tbPeach.FAIRYLAND_INVITE_TIMEOUT;
	};
	pFriend.CallClientScript("Ui:SynNotifyMsg", tbMsgData);
	return true;
end


-------------------------------------------------------------

local tbClientReq = {
	Water                 = true;
	Fertilizer            = true;
	GoFairyland           = true;
	BringUpFairylandPeach = true;
	TakeTreeAward         = true;
	InviteFriend          = true;
	InvitedIntoFairyland  = true;
};

function tbPeach:ClientReq(szType, ...)
	if not tbClientReq[szType] then
		return;
	end

	local bRet, szMsg = self[szType](self, me, ...);
	if not bRet and szMsg then
		me.CenterMsg(szMsg);
	end
end