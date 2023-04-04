
local tbItem = Item:GetClass("RechargeSumOpenBox");
tbItem.ITEM_KEY_CURLEVEL = 1;

function tbItem:GetAct(  )
	local tbAct = MODULE_GAMESERVER and Activity:GetClass("RechargeSumOpenBox") or Activity.RechargeSumOpenBox
	return tbAct
end

function tbItem:OnUse(it)
	local tbAct = self:GetAct()
	local tbAwardSet = tbAct.tbRechargeItemBoxAwardSetting[it.dwTemplateId]
	if not tbAwardSet then
		me.CenterMsg("ERROR1")
		return
	end
	local nCurlevel = it.GetIntValue(self.ITEM_KEY_CURLEVEL)
	local nOpenLevel = nCurlevel + 1;
	local tbProdInfo = Recharge.tbSettingGroup.BuyGold[nOpenLevel]
	if not tbProdInfo then
		me.CenterMsg("ERROR2")
		return
	end
	local tbGetAward = tbAwardSet[nOpenLevel]
	if not tbGetAward then
		me.CenterMsg("ERROR3")
		return
	end
	
	local nNeedKeyItemId = tbAct.tbRechargeGetKeyItem[tbProdInfo.nGroupIndex]
	if not nNeedKeyItemId then
		me.CenterMsg("ERROR4")
		return
	end
	if me.ConsumeItemInBag(nNeedKeyItemId ,1, Env.LogWay_RechargeSumOpenBox)  ~= 1 then
		local tbItembase = KItem.GetItemBaseProp(nNeedKeyItemId)
		me.CenterMsg(string.format("%s không đủ ", tbItembase.szName))
		return
	end
	if nOpenLevel == #tbAwardSet then
		it.Delete(Env.LogWay_RechargeSumOpenBox)
		if tbAct.nOpenAllBoxRedBagKey then
			Kin:RedBagOnEvent(me, tbAct.nOpenAllBoxRedBagKey, 1)	
		end
	else
		it.SetIntValue(self.ITEM_KEY_CURLEVEL, nOpenLevel)
	end
	me.SendAward(tbGetAward, nil,nil, Env.LogWay_RechargeSumOpenBox)
end


function tbItem:GetCurOpenLevel( it )
	local nCurlevel = it.GetIntValue(self.ITEM_KEY_CURLEVEL)
	return nCurlevel + 1;
end

function tbItem:GetIntrol( dwTemplateId, nItemID )
	if not nItemID then
		return
	end
	local pItem = KItem.GetItemObj(nItemID)
	if not pItem then
		return
	end
	local nCurlevel = pItem.GetIntValue(self.ITEM_KEY_CURLEVEL)
	local tbAct = self:GetAct()
	local tbSeting = tbAct.tbRechargeItemBoxTipSetting[dwTemplateId]
	local tbDescs = {}
	for i,v in ipairs(tbSeting) do
		local bActive = nCurlevel >= i;
		table.insert(tbDescs, string.format("[%s]%s (%s)[-]", bActive and "ffff00" or "ffffff",  v,  bActive and "Đã mở" or "Chưa mở"))
	end
	return "Nạp thẻ với mức nạp tương ứng với số tầng được nhận chìa khóa bảo rương, mở [FFFE0D]hoàn toàn 6 tầng sẽ nhận được danh hiệu[-], thưởng như sau:\n" .. table.concat( tbDescs, "\n")
end