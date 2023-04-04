
local tbItem = Item:GetClass("CombineKey");

function tbItem:OnUse(it)
	local bRet, szMsg, nConsumeItemId, nDstItemId = self:DoCheck(me, it);
	if not bRet then
		me.CenterMsg(szMsg);
		return;
	end

	local nRet = me.ConsumeItemInBag(nConsumeItemId, 1, Env.LogWay_CombineKey);
	if not nRet or nRet < 1 then
		me.CenterMsg("Khấu trừ đạo cụ thất bại!");
		return;
	end

	me.SendAward({{"item", nDstItemId, 1}}, false, true, Env.LogWay_CombineKey);
	Log("[CombineKey] OnUse", me.dwID, me.szName, me.szAccount, it.dwTemplateId, nConsumeItemId, nDstItemId);
	return 1;
end

function tbItem:DoCheck(pPlayer, it)
	local nConsumeItemId = KItem.GetItemExtParam(it.dwTemplateId, 1);
	local szConsumeItemName = KItem.GetItemShowInfo(nConsumeItemId);

	local nDstItemId = KItem.GetItemExtParam(it.dwTemplateId, 2);
	local nCount = me.GetItemCountInBags(nConsumeItemId);
	if nCount <= 0 then
		return false, string.format("Chưa phát hiện %s, không thể ghép!", szConsumeItemName);
	end

	return true, "", nConsumeItemId, nDstItemId, nCount;
end

function tbItem:OnUseAll(it)
	local bRet, szMsg, nConsumeItemId, nDstItemId, nCount = self:DoCheck(me, it);
	if not bRet then
		me.CenterMsg(szMsg);
		return;
	end

	nCount = math.min(nCount, it.nCount);
	local nRet = me.ConsumeItemInBag(nConsumeItemId, nCount, Env.LogWay_CombineKey);
	if not nRet or nRet ~= nCount then
		me.CenterMsg("Khấu trừ đạo cụ thất bại!");
		Log("[CombineKey] OnUseAll ConsumeItemInBag Fail !!", me.dwID, me.szName, me.szAccount, it.dwTemplateId, nConsumeItemId, nCount, nRet);
		return;
	end

	me.SendAward({{"item", nDstItemId, nCount}}, false, true, Env.LogWay_CombineKey);
	Log("[CombineKey] OnUseAll", me.dwID, me.szName, me.szAccount, it.dwTemplateId, nConsumeItemId, nDstItemId, nCount);
	return nCount;
end

function tbItem:GetUseSetting(nItemTemplateId, nItemId)
	return {szFirstName = "Sửa", fnFirst = "UseItem", szSecondName = "Sửa hết", fnSecond = "UseAll"};
end
