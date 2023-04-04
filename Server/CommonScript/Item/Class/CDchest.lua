
local tbChest = Item:GetClass("CDChest");
local tbRandomItem = Item:GetClass("RandomItem");

tbChest.MAX_AWARD_COUNT = 20

function tbChest:LoadSetting()
	local tbTitle = {"Kind", "CDTime"};
	local szType = "dd"
	for i = 1, self.MAX_AWARD_COUNT do
		table.insert(tbTitle, "Award"..i)
		szType = szType.."d"
	end
	local tbFile = LoadTabFile("Setting/Item/CDChest.tab", szType, "Kind", tbTitle);
	if not tbFile then
		Log("[ERROR]Load File Failed! Setting/Item/CDChest.tab");
		return;
	end
	self.tbSetting = {}
	for nKinId, tbInfo in pairs(tbFile) do
		self.tbSetting[nKinId] = {nCDTime = tbInfo.CDTime, tbAward = {}}
		for i = 1, self.MAX_AWARD_COUNT do
			self.tbSetting[nKinId].tbAward[i] = tbInfo["Award"..i]
			if not self.tbSetting[nKinId].tbAward[i] or self.tbSetting[nKinId].tbAward[i] == 0 then
				self.tbSetting[nKinId].tbAward[i] = nil
				break;
			end
		end
	end
end

tbChest:LoadSetting();

function tbChest:GetSetting(nKindId)
	return self.tbSetting[nKindId]
end

function tbChest:OnUse(it)
	local nStep = it.GetIntValue(1);
	local nLastUseTime = it.GetIntValue(2);
	local nCurTime = GetTime();
	local nChestType = KItem.GetItemExtParam(it.dwTemplateId, 1)
	local tbChestAward = self:GetSetting(nChestType);
	if not tbChestAward then
		me.CenterMsg("Đạo cụ bị lỗi, không thể dùng");
		return;
	end
	if nLastUseTime + tbChestAward.nCDTime > nCurTime then
		me.CenterMsg("Đạo cụ  hiện không thể dùng");
		return;
	end
	nStep = nStep + 1
	local nKind = tbChestAward.tbAward[nStep];
	if nKind then
		local nRet, szMsg, tbAllAward = tbRandomItem:GetRandItemAward(me, nKind,  it.szName, true, it.dwTemplateId)
		if szMsg then
			me.Msg(szMsg)
		end
		if (not nRet) or (nRet == 0) then
			return
		end
		Log("[Item] CDChest OnUse", it.dwTemplateId, it.szName, me.szName, me.szAccount, me.dwID, nStep);
	end
	
	if tbChestAward.tbAward[nStep + 1] and tbChestAward.tbAward[nStep + 1] > 0 then
		it.SetIntValue(1, nStep);
		it.SetIntValue(2, nCurTime);
		return
	end
	return 1;
end

function tbChest:GetTip(pItem)
    local nStep = pItem.GetIntValue(1);
	local nLastUseTime = pItem.GetIntValue(2);
	local nCurTime = GetTime();
	local nChestType = KItem.GetItemExtParam(pItem.dwTemplateId, 1)
	local tbChestAward = self:GetSetting(nChestType);
	if not tbChestAward then
		return "Đạo cụ bị lỗi, không thể dùng";
	end
	local szMsg = string.format("Số lần dùng đạo cụ: %d/%d\n", nStep, #tbChestAward.tbAward)
	if nLastUseTime + tbChestAward.nCDTime > nCurTime then
		return szMsg..string.format("Đạo cụ hiện không thể dùng, cần chờ %s", Lib:TimeDesc2(nLastUseTime + tbChestAward.nCDTime - nCurTime));
	end
    return szMsg.."Đạo cụ được dùng";
end
