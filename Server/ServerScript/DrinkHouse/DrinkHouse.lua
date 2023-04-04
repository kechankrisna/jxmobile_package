-- DrinkHouse.tbCurMapIds = {};
local tbDef = DrinkHouse.tbDef
local tbRentDef = DrinkHouse.tbRentDef
DrinkHouse.tbMapInst = DrinkHouse.tbMapInst or {};
DrinkHouse.tbRentKinToMapId = DrinkHouse.tbRentKinToMapId or {};
DrinkHouse.tbRenMapIdEnterdRole = DrinkHouse.tbRenMapIdEnterdRole or {};

function DrinkHouse:OnStartUp()
	self.fnRandomSelectNormalPos = Lib:GetRandomSelect(#tbDef.NORMAL_RAND_POS)
end

local tbInferFace = {
    DiceShake = 1;
    InviteDrink = 1;
}

function DrinkHouse:PlayerRequest(pPlayer, szFunc, ...)
    if not tbInferFace[szFunc] then
        return
    end
    self[szFunc](self, pPlayer, ...)
end

function DrinkHouse:DiceShake( pPlayer )
	local nMapId = pPlayer.nMapId
	local dwKinId = pPlayer.dwKinId
	if nMapId ~= self.tbRentKinToMapId[dwKinId] then
		Log(debug.traceback())
		return
	end
	local tbInst = Fuben.tbFubenInstance[nMapId]
	if not tbInst then
		return
	end
	tbInst:DiceShake(pPlayer)
end

function DrinkHouse:InviteDrink( pPlayer, dwRoleId )
	local pTarPlayer = KPlayer.GetPlayerObjById(dwRoleId)
	if not pTarPlayer then
		return
	end
	local tbInst = self.tbMapInst[pPlayer.nMapId]
	if not tbInst then
		return
	end
	if pTarPlayer.nMapId ~= pPlayer.nMapId then
		return
	end
	tbInst:InviteDrink(pPlayer, pTarPlayer)
end

function DrinkHouse:RequestEnterMap( pPlayer )
	if not Env:CheckSystemSwitch(pPlayer, Env.SW_House) then
		pPlayer.CenterMsg("Hiện tại không thể vào gia viên, xin đợi thử lại");
		return;
	end
	if not Fuben.tbSafeMap[pPlayer.nMapTemplateId] then
		pPlayer.CenterMsg("Bản đồ hiện tại không cho phép vào");
		return 
	end
	if pPlayer.nLevel < tbDef.MIN_PLAYER_LEVEL then
		pPlayer.CenterMsg(string.format("Cấp %d có thể vào", tbDef.MIN_PLAYER_LEVEL))
		return
	end

	local nMapId = self.tbRentKinToMapId[pPlayer.dwKinId]
	if nMapId then
		self:RequestEnterRentMap(pPlayer, nMapId)
		return
	end

	local nIndex = self.fnRandomSelectNormalPos()
	local x, y = unpack(tbDef.NORMAL_RAND_POS[nIndex])
	pPlayer.SetEntryPoint()
	pPlayer.SwitchMap(tbDef.NORMAL_MAP, x, y)
end

function DrinkHouse:RequestEnterRentMap( pPlayer , nMapId)
	local tbRenMapIdEnterdRole = DrinkHouse.tbRenMapIdEnterdRole[nMapId]
	if not tbRenMapIdEnterdRole then
		return
	end
	if not tbRenMapIdEnterdRole[pPlayer.dwID] then
		if not DegreeCtrl:ReduceDegree(pPlayer, "DrinkHouseRent", 1) then
			pPlayer.CenterMsg(string.format("Tuần này bạn đã tham gia %d lần Tửu Quán Yến Hội, không thể tham gia thêm", DegreeCtrl:GetMaxDegree("DrinkHouseRent", pPlayer)))
			return 
		end	
		tbRenMapIdEnterdRole[pPlayer.dwID] = 1;
	end
	
	pPlayer.SetEntryPoint()
	pPlayer.SwitchMap(nMapId, 0, 0)	
end

function DrinkHouse:CanRentDrinkHouse( pPlayer )
	local dwKinId = pPlayer.dwKinId
	if dwKinId == 0 then
		return false, "Hãy vào bang"
	end
	local tbKinData = Kin:GetKinById(dwKinId)
	if not tbKinData then
		return false, "Hãy vào bang"
	end
	--家族正在承包酒楼
	if self.tbRentKinToMapId[dwKinId] then
		return false, "Hiện tại đang có người trong bang tổ chức yến hội"
	end

	if pPlayer.GetItemCountInBags(tbRentDef.CONTRACT_ITEM) <= 0 then
		return false, "Bạn không có Tửu Quán Chi Yêu, không thể mở yến hội"
	end
	local nRentDrinHosueTimes = tbKinData:GetRentDrinkHouseTimes()
	if nRentDrinHosueTimes >= tbRentDef.MAX_RENT_TIMES then
		return false, string.format("Bang tuần này đã tổ chức %d lần bang yến hội, không thể mở", tbRentDef.MAX_RENT_TIMES)
	end
	if DegreeCtrl:GetDegree(pPlayer, "DrinkHouseRent") <= 0 then
		return false, string.format("Bạn tuần này đã tham gia %d lần bang yến hội, không thể mở", DegreeCtrl:GetMaxDegree("DrinkHouseRent", pPlayer)) 
	end
	local nToDaySec = Lib:GetTodaySec()
	local nFrom, nTo = unpack(tbRentDef.RENT_TIME_FROM_TO) 
	if nToDaySec < nFrom or nToDaySec > nTo then
		local nFromH, nFromM = math.floor(nFrom / 3600), math.floor( (nFrom % 3600) / 60)
		local nToH, nToM = math.floor(nTo / 3600), math.floor( (nTo % 3600) / 60)
		return false, string.format("Hiện tại không thể mở, %d:%.2d-%d:%.2d đến mở", nFromH, nFromM, nToH, nToM) 
	end
	
	return true
end

function DrinkHouse:RentDrinkHouse( pPlayer )
	local bRet, szMsg = self:CanRentDrinkHouse(pPlayer)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return 
	end
	local fnYes = function ()
		self:ConfirmRentDrinkHouse()
	end
	pPlayer.MsgBox("Xác nhận mở yến hội ngay tại đây?", { { "Xác nhận", fnYes },{ "Hủy" } })
end

function DrinkHouse:ConfirmRentDrinkHouse(  )
	local bRet, szMsg = self:CanRentDrinkHouse(me)
	if not bRet then
		me.CenterMsg(szMsg, true)
		return 
	end
	if me.ConsumeItemInBag(tbRentDef.CONTRACT_ITEM, 1, Env.LogWay_RentDrinkHouse) ~= 1 then
		return
	end
	local tbKinData = Kin:GetKinById(me.dwKinId)
	tbKinData:AddRentDrinkHouseTimes()

	local function fnFailedCallback()
        Log(debug.traceback())
    end
    local dwMasterRoleId = me.dwID
    local dwKinId = me.dwKinId
    local function fnSucess(nMapId)
    	DrinkHouse.tbRentKinToMapId[dwKinId] = nMapId
    	DrinkHouse.tbRenMapIdEnterdRole[nMapId] = { [dwMasterRoleId] = 1}
    	local pPlayer = KPlayer.GetPlayerObjById(dwMasterRoleId)
    	if pPlayer then
    		DegreeCtrl:ReduceDegree(pPlayer, "DrinkHouseRent", 1)
    		pPlayer.SetEntryPoint()
    		pPlayer.SwitchMap(nMapId, 0, 0 )
    		local tbMapNpcInfo = Map:GetMapNpcInfoByNpcTemplate(tbRentDef.RENT_NPC_IN_MAP, tbRentDef.RENT_NPC_ID);
    		if tbMapNpcInfo then
    			local tbNpcInfo = tbMapNpcInfo[1];
    			if tbNpcInfo then
	    			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format(tbRentDef.CREATE_NOTIFY, pPlayer.szName), pPlayer.dwKinId, 
	 	               	{nLinkType = ChatMgr.LinkType.Position, nMapId = tbRentDef.RENT_NPC_IN_MAP, nX = tbNpcInfo.XPos, nY = tbNpcInfo.YPos})
	    		end
    		end
    	end
    	
    end
	Fuben:ApplyFubenUseLevel(0, tbRentDef.RENT_MAP, 1, fnSucess, fnFailedCallback, dwKinId,dwMasterRoleId)

end


function DrinkHouse:OnNormalMapCreate(nMapId)
	local tbInst = Lib:NewClass(DrinkHouse.tbNormalMapLogic)
	tbInst:Init(nMapId)
	self.tbMapInst[nMapId] = tbInst
end

function DrinkHouse:OnNormalMapDestory(nMapId)
	local tbInst = self.tbMapInst[nMapId]
	if tbInst then
		tbInst:OnDestroy()
	end
	 self.tbMapInst[nMapId] = nil;
end

function DrinkHouse:OnCloseFuben( dwKinId, nMapId )
	self.tbRentKinToMapId[dwKinId] = nil
	self.tbRenMapIdEnterdRole[nMapId] = nil;
end


DrinkHouse.tbRandomNames = {};
function DrinkHouse:GetRandomNames(nSex)
	local tbNames = self.tbRandomNames[nSex]
	if not tbNames then
		local tbFile = LoadTabFile(tbDef.NameSetting[nSex], "sd", nil, {"Name", "Pool"});
		tbNames = {};
		for i,v in ipairs(tbFile) do
			tbNames[v.Pool] = tbNames[v.Pool] or {};
			table.insert(tbNames[v.Pool], v.Name)
		end

		self.tbRandomNames[nSex] = tbNames
	end
	return tbNames
end

function DrinkHouse:OnPlayerHonorLevelUp( pPlayer, nNewHonorLevel )
	local tbDrinRentHonorInfo = tbRentDef.tbGetItemSetting[nNewHonorLevel]
	if not tbDrinRentHonorInfo then
		return
	end
	if tbDrinRentHonorInfo.szCloseTimeFrame and GetTimeFrameState(tbDrinRentHonorInfo.szCloseTimeFrame) == 1 then
		return
	end
	local dwKinId = pPlayer.dwKinId
	if dwKinId == 0 then
		return
	end
	local tbScripData = ScriptData:GetValue("DrinkHouseRent")
	local nOldGetNum = tbScripData[nNewHonorLevel] or 0;
	if nOldGetNum >= tbDrinRentHonorInfo.nTotalInServer then
		return
	end
	local tbKinData = Kin:GetKinById(dwKinId)
	if not tbKinData then
		return
	end
	local nGetItemInKin = tbKinData:GetRentDrinHosueGetItemCount(nNewHonorLevel)
	if nGetItemInKin >= tbDrinRentHonorInfo.nTopInKinNum then
		return
	end
	local tbHonorSetting = Player.tbHonorLevelSetting[nNewHonorLevel]

	local tbMail = Lib:CopyTB(tbRentDef.SendRentItemMail)
	tbMail.To = pPlayer.dwID
	tbMail.Text = string.format(tbMail.Text, nGetItemInKin + 1, tbHonorSetting.Name)
	tbMail.nLogReazon = Env.LogWay_RentDrinkHouse
	Mail:SendSystemMail(tbMail)

	tbKinData:AddRentDrinHosueGetItemCount(nNewHonorLevel)
	tbScripData[nNewHonorLevel] = nOldGetNum + 1;
	ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin, string.format(tbRentDef.szGetRentItemKinMsg, pPlayer.szName, nGetItemInKin + 1, tbHonorSetting.Name), dwKinId)
end

function DrinkHouse:SetupMapCallback(  )
	local fnOnCreate = function (tbMap, nMapId)
		self:OnNormalMapCreate(nMapId)
	end

	local fnOnDestory = function (tbMap, nMapId)
		self:OnNormalMapDestory(nMapId)
	end

	local fnOnEnter = function (tbMap, nMapId)
		local tbInst = self.tbMapInst[nMapId]
		if tbInst then
			tbInst:OnEnter()
		end
	end

	local fnOnLeave = function (tbMap, nMapId)
		local tbInst = self.tbMapInst[nMapId]
		if tbInst then
			tbInst:OnLeave()
		end
	end

	local fnOnMapLogin = function (tbMap, nMapId)
		local tbInst = self.tbMapInst[nMapId]
		if tbInst then
			tbInst:OnLogin()
		end
	end

	local tbMapClass = Map:GetClass(tbDef.NORMAL_MAP)
	tbMapClass.OnCreate = fnOnCreate;
	tbMapClass.OnDestroy = fnOnDestory;
	tbMapClass.OnEnter = fnOnEnter;
	tbMapClass.OnLeave = fnOnLeave;
	tbMapClass.OnLogin = fnOnMapLogin;
end

DrinkHouse:SetupMapCallback()