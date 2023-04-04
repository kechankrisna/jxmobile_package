
local tbItem = Item:GetClass("DirectEnhance");

function tbItem:OnUse(it)
	local nExtLevel = KItem.GetItemExtParam(it.dwTemplateId, 1)
	local tbIdGrp = Kin.tbRedBagIdGrps[Kin.tbRedBagEvents.all_strength]
	if not tbIdGrp then
		return 0;
	end
	local tbAllEquips      = me.GetEquips();
	for i = Item.EQUIPPOS_HEAD, Item.EQUIPPOS_PENDANT do
		local nItemId = tbAllEquips[i]
		if not nItemId then
			me.CenterMsg("Có vật phẩm chưa trang bị, hãy trang bị trước")
			return 0;
		end
	end

	local nMoreCount = 0;
	local tbStrengthen 	= me.GetStrengthen();
	for nEquipPos, nEquipId in pairs(tbAllEquips) do
		local nStrenLevel 	= tbStrengthen[nEquipPos + 1]
		if nStrenLevel >= nExtLevel then
			nMoreCount = nMoreCount + 1;
		end
	end
	if nMoreCount == 10 then
		me.CenterMsg("Cường hóa trang bị đã đạt cấp này hoặc cao hơn, không cần dùng đạo cụ")
		return 0
	end

	for nEventId, v in pairs(tbIdGrp) do
		local tbSetting = Kin.tbRedBagSettings[nEventId]
		if nExtLevel >= tbSetting.nTarget then
			Kin:_SetRedBagSendTime(me, nEventId)		
		end
	end
	Log("DirectEnhance GM:EnhanceEquip", nExtLevel, me.dwID)
	
	
	for nEquipPos, nEquipId in pairs(tbAllEquips) do
		local nStrenLevel 	= tbStrengthen[nEquipPos + 1]
		Log(string.format("DirectEnhance  EquipId:%d  Level:%d", nEquipId, nExtLevel), nStrenLevel);
		if nExtLevel > nStrenLevel then
			Strengthen:DoStrengthen(me, nEquipId, nEquipPos, nExtLevel);
			--突破次数
			local nNeed 		= Strengthen:GetNeedBreakCount(nExtLevel);
			if nNeed then
				Strengthen:SetPlayerBreakCount(me, nEquipPos, nNeed)
			end
		end
	end

	me.CenterMsg(string.format("Tất cả trang bị đã cường hóa đến Lv%d", nExtLevel))
	me.CallClientScript("Ui:OpenWindow", "ItemBox")
	return 1;
end

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local nExtLevel = KItem.GetItemExtParam(nTemplateId, 1)
	local nMoreCount = 0;
	local tbAllEquips      = me.GetEquips();
	local tbStrengthen 	= me.GetStrengthen();
	for nEquipPos, nEquipId in pairs(tbAllEquips) do
		local nStrenLevel 	= tbStrengthen[nEquipPos + 1]
		if nStrenLevel >= nExtLevel then
			nMoreCount = nMoreCount + 1;
		end
	end

	local tbUseSetting = {szFirstName = "Dùng", fnFirst = "UseItem"};

	if nMoreCount == 10 and Shop:CanSellWare(me, nItemId, 1) then
		tbUseSetting.fnSecond = "SellItem";
		tbUseSetting.szSecondName = "Bán"
	end	

	return tbUseSetting;		
end
