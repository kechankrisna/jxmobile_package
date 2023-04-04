-- DrinkHouse.tbCurMapIds = {};
local tbDef = DrinkHouse.tbDef
DrinkHouse.tbNormalMapLogic = DrinkHouse.tbNormalMapLogic or {};
local tbNormalMapLogic = DrinkHouse.tbNormalMapLogic

function tbNormalMapLogic:Init( nMapId )
	self.nMapId = nMapId
	self.nChannelId = KChat.CreateDynamicChannel(tbDef.CHANNEL_NAME,tbDef.CHANNEL_ICON, "CheckDrinkHouseChannelMsg")
	local tbName1 =  DrinkHouse:GetRandomNames(Player.SEX_MALE)
	local tbName2 =  DrinkHouse:GetRandomNames(Player.SEX_FEMALE)
	self.tbRandomName = {
		[Player.SEX_MALE] = Lib:CopyTB(tbName1); 
		[Player.SEX_FEMALE] = Lib:CopyTB(tbName2);
	}

	self.tbPlayerInfos = {};
	
	Timer:Register(1, self.TimerInit, self)
end

function tbNormalMapLogic:TimerInit(  )
	if not self.nMapId then
		return
	end
	for i,tbFurnitureInfo in ipairs(tbDef.AddFurnitureSetting) do
		Decoration:NewDecoration(self.nMapId, tbFurnitureInfo.nPosX, tbFurnitureInfo.nPosY, tbFurnitureInfo.nRotation, tbFurnitureInfo.nTemplate)
	end
	for i,tbNpcInfo in ipairs(tbDef.AddNpcSetting) do
		 KNpc.Add(tbNpcInfo.nTemplate, tbNpcInfo.nLevel, -1, self.nMapId, tbNpcInfo.nPosX, tbNpcInfo.nPosY, 0, tbNpcInfo.nDir);
	end
end

function tbNormalMapLogic:GetRandomName( nSex )
	local tbAllRandomName = self.tbRandomName[nSex]
	local nPool, tbPoolNames = next(tbAllRandomName);
	if not tbPoolNames then
		return "Thiếu Hiệp"
	end
	local nRandIndex = MathRandom(1, #tbPoolNames)
	local szRandomName =  table.remove(tbPoolNames, nRandIndex)
	if #tbPoolNames == 0 then
		tbAllRandomName[nPool] = nil;
	end
	return szRandomName, nPool
end

function tbNormalMapLogic:OnEnter(  )
	local szRandomName, nPoolIndex = self:GetRandomName(me.nSex)
	local pPlayerNpc = me.GetNpc()
	pPlayerNpc.SetName(szRandomName)

	Kin:SyncTitle(me.dwID, "");
	local tbInfo = {}
	self.tbPlayerInfos[me.dwID] = tbInfo;
	tbInfo.nOrgTitleId = me.LockTitle(true); --现在进场是先
	tbInfo.nPoolIndex = nPoolIndex
	tbInfo.szRandomName = szRandomName

	me.ActiveTitle(0)

	local nNpcResID, tbCurFeature = pPlayerNpc.GetFeature()
	local nResId = Item.tbChangeColor:GetWaiZhuanRes(tbDef.WAIYI_BODY, me.nFaction, me.nSex)
    if nResId ~= 0 then
        pPlayerNpc.ChangeFeature(nNpcResID,Npc.NpcResPartsDef.npc_part_body, nResId) -- 换门派装
    end
	local nResId = Item.tbChangeColor:GetWaiZhuanRes(tbDef.WAIYI_HEAD, me.nFaction, me.nSex)
    if nResId ~= 0 then
        pPlayerNpc.ChangeFeature(nNpcResID,Npc.NpcResPartsDef.npc_part_head, nResId) -- 换门派装
    end
    pPlayerNpc.ChangeFeature(nNpcResID,Npc.NpcResPartsDef.npc_part_weapon, tbCurFeature[Npc.NpcResPartsDef.npc_part_weapon]) -- 换门派装

	KChat.AddPlayerToDynamicChannel(self.nChannelId, me.dwID);
	KChat.SetChannelNickName(me.dwID, self.nChannelId, szRandomName)
	-- KChat.SetChannelNickName(me.dwID, ChatMgr.ChannelType.Nearby, szRandomName)

	OnHook:TryStartOnLineOnHookForce(me)
	me.CallClientScript("DrinkHouse:OnEnterMap", self.nChannelId ,szRandomName, me.szName)
end

function tbNormalMapLogic:OnLeave()
	KChat.SetChannelNickName(me.dwID, self.nChannelId, "")
	-- KChat.SetChannelNickName(me.dwID, ChatMgr.ChannelType.Nearby, "")
	KChat.DelPlayerFromDynamicChannel(self.nChannelId, me.dwID);
	local pPlayerNpc = me.GetNpc()
	pPlayerNpc.SetName(me.szName)
	pPlayerNpc.RestoreFeature()

	me.LockTitle(nil);
	local tbInfo = self.tbPlayerInfos[me.dwID]
	if tbInfo.nOrgTitleId ~= 0 then
		me.ActiveTitle(tbInfo.nOrgTitleId, false);
	end
	if tbInfo.nPoolIndex then
		self.tbRandomName[me.nSex][tbInfo.nPoolIndex] = self.tbRandomName[me.nSex][tbInfo.nPoolIndex] or {};
		table.insert(self.tbRandomName[me.nSex][tbInfo.nPoolIndex], tbInfo.szRandomName)
	end

	local kinMemberData = Kin:GetMemberData(me.dwID);
	if kinMemberData and kinMemberData.nKinId and kinMemberData.nKinId ~= 0 then
		local szTitle = kinMemberData:GetFullTitle();
		Kin:SyncTitle(me.dwID, szTitle);	
	end
	me.bDrinkInviteFollow = nil;
	self.tbPlayerInfos[me.dwID] = nil;
end

function tbNormalMapLogic:OnLogin()
	Kin:SyncTitle(me.dwID, "");	
	me.CallClientScript("DrinkHouse:OnEnterMap", self.nChannelId, me.GetNpc().szName, me.szName)
end

function tbNormalMapLogic:OnDestroy()
	KChat.DelDynamicChannel(self.nChannelId);
	self.nChannelId = nil;
end

function tbNormalMapLogic:InviteDrink(pPlayer, pTarPlayer)
	if not DrinkHouse:InviteDrinkPopAvaliable(pPlayer) then
		return
	end
	local tbInfoMe = self.tbPlayerInfos[pPlayer.dwID]	
	local tbInfoHim = self.tbPlayerInfos[pTarPlayer.dwID]	
	local nNow = GetTime() 
	if tbInfoMe.nInviteDrinkTimeOut and tbInfoMe.nInviteDrinkTimeOut - nNow > 0 then
		pPlayer.CenterMsg(string.format("Mời %d giây sau thử lại", tbInfoMe.nInviteDrinkTimeOut - nNow))
		return
	end
	if ActionInteract:IsInteract(pPlayer) then
		pPlayer.CenterMsg("Động tác lẫn nhau hạ không thể sử dụng")
		return 
	end
	local pPlayerNpc = pPlayer.GetNpc();
    local nResult = pPlayerNpc.CanChangeDoing(Npc.Doing.skill);
    if nResult == 0 then
    	pPlayer.CenterMsg("Ngay tại sử dụng kỹ năng không thể sử dụng")
    	return 
    end
    if pPlayerNpc.GetRefFlag(1) > 0 then
    	pPlayer.CenterMsg("Đối phương trạng thái hiện tại không thể sử dụng")
    	return 
    end
    local pPlayerNpcTar = pTarPlayer.GetNpc();
    local nResult = pPlayerNpcTar.CanChangeDoing(Npc.Doing.skill);
    if nResult == 0 then
    	pPlayer.CenterMsg("Đối phương ngay tại sử dụng kỹ năng không thể sử dụng")
    	return 
    end
    if tbInfoHim.nDrinkWineEndTime and tbInfoHim.nDrinkWineEndTime - nNow > 0 then
    	pPlayer.CenterMsg(string.format("Mời %d giây sau thử lại", tbInfoHim.nDrinkWineEndTime - nNow))
    	return
    end
    tbInfoMe.nInviteDrinkTimeOut = nNow + tbDef.nDrinkInviteInterval

    pPlayer.CallClientScript("DrinkHouse:SynDrinkInviteTimeOut", tbInfoMe.nInviteDrinkTimeOut)

    local tbDrinkWineRandAction = tbDef.tbDrinkWineRandAction
    local nRand = MathRandom(1, #tbDrinkWineRandAction)
    local tbSel = tbDrinkWineRandAction[nRand]
    tbInfoHim.nDrinkWineEndTime = nNow + tbSel.nDuraTime
    pPlayerNpcTar.AddRefFlag(1, 1)
    local dwFollowPlayerId;
    if tbSel.bFollow then
    	pTarPlayer.CallClientScript("AutoFight:StartFollowNpc", pPlayer.GetNpc().nId, tbSel.nFollowDistance)
    	pTarPlayer.CallClientScript("Operation:DisableWalking")
    	dwFollowPlayerId = pPlayer.dwID
    	pPlayer.bDrinkInviteFollow = true
    	local szSendMsg = string.format(tbSel.szNotifyMsg, pPlayerNpcTar.szName, pPlayer.GetNpc().szName, pPlayer.GetNpc().szName)
    	local tbRandSay = tbSel.tbRandSay
    	local szRandSay = tbRandSay[MathRandom(1, #tbRandSay)] 
    	ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, pTarPlayer.dwID, pPlayerNpcTar.szName, pTarPlayer.nFaction, pTarPlayer.nPortrait, pTarPlayer.nSex, pTarPlayer.nLevel, szSendMsg);
    	ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, pTarPlayer.dwID, pPlayerNpcTar.szName, pTarPlayer.nFaction, pTarPlayer.nPortrait, pTarPlayer.nSex, pTarPlayer.nLevel, szRandSay);
    elseif tbSel.nActionID then
    	pPlayerNpcTar.DoCommonAct(tbSel.nActionID, tbSel.nActionEventID, 0, 0, 1);
    	local szSendMsg = string.format(tbSel.szNotifyMsg, pPlayerNpcTar.szName)
    	ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, pTarPlayer.dwID, pPlayerNpcTar.szName, pTarPlayer.nFaction, pTarPlayer.nPortrait, pTarPlayer.nSex, pTarPlayer.nLevel, szSendMsg);
    	pTarPlayer.CallClientScript("Operation:DisableWalking")
    end

	Timer:Register(Env.GAME_FPS * tbSel.nDuraTime, function (dwTarRoleId)
    		local pTarPlayer = KPlayer.GetPlayerObjById(dwTarRoleId)
    		if pTarPlayer then
    			if dwFollowPlayerId then
    				local pPlayerFollow = KPlayer.GetPlayerObjById(dwFollowPlayerId)
    				if pPlayerFollow and pPlayerFollow.bDrinkInviteFollow then
    					pPlayerFollow.bDrinkInviteFollow = nil;
    					ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, pTarPlayer.dwID, pTarPlayer.GetNpc().szName, pTarPlayer.nFaction, pTarPlayer.nPortrait, pTarPlayer.nSex, pTarPlayer.nLevel, tbSel.szEndSayMsg);	
    				end
    			else
    				ChatMgr:SendPlayerMsg(ChatMgr.ChannelType.Nearby, pTarPlayer.dwID, pTarPlayer.GetNpc().szName, pTarPlayer.nFaction, pTarPlayer.nPortrait, pTarPlayer.nSex, pTarPlayer.nLevel, tbSel.szEndSayMsg);
    			end
    			pTarPlayer.GetNpc().AddRefFlag(1, -1)
    			pTarPlayer.GetNpc().RestoreAction()
    			if pTarPlayer.nMapId == self.nMapId then
    				pTarPlayer.CallClientScript("DrinkHouse:RestoreDinkAction")
    			end
    		end
    	end, pTarPlayer.dwID)
end

