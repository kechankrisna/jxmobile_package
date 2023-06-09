local tbCountAddProp = Item:GetClass("CountAddProp");

function tbCountAddProp:LoadSetting()
	local tbTitle = {
	"TemplateId",
	"AddDegree",
	"AddCount",
	"CostDegree",
	"NeedOpenAct", ---需要今天开对应的活动
	};
	
	self.tbAllPropInfo = LoadTabFile("Setting/Item/Other/CountAddProp.tab", "dsdsd", "TemplateId", tbTitle);
	assert(self.tbAllPropInfo)
end

tbCountAddProp:LoadSetting();
tbCountAddProp.MAX_ADD_COUNT = 999

function tbCountAddProp:OnUse(it)
	local tbKey = self.tbAllPropInfo[it.dwTemplateId];
	if not tbKey then
		Log("[CountAddProp] OnUse ERR ?? tbKey is nil !!", me.szName, me.dwID, it.szName, it.dwTemplateId);
		me.CenterMsg("Hệ thống kiểm tra thấy đạo cụ bất thường, không thể dùng!");
		return 0;
	end

	if tbKey.CostDegree ~= "" then
		if not DegreeCtrl:ReduceDegree(me, tbKey.CostDegree, 1) then
			me.CenterMsg(string.format("Đạo cụ giới hạn dùng mỗi ngày %s tăng %d lần", DegreeCtrl:GetDegreeDesc(tbKey.AddDegree), DegreeCtrl:GetMaxDegree(tbKey.CostDegree, me)) )
			return 0;
		end
	end

	local szDesc = DegreeCtrl:GetDegreeDesc(tbKey.AddDegree)
	DegreeCtrl:AddDegree(me, tbKey.AddDegree, tbKey.AddCount);		

	me.CallClientScript("me.BuyTimesSuccess", string.format("Tăng %s %d lần, mau tham gia hoạt động!", szDesc, tbKey.AddCount));
	return 1;
end

function tbCountAddProp:GetAddDegreeItemId(szDegree)
	for k,v in pairs(self.tbAllPropInfo) do
		if v.AddDegree == szDegree then
			return k;
		end
	end
end

function tbCountAddProp:GetMaxUseCount(it)
	local tbKey = self.tbAllPropInfo[it.dwTemplateId];
	if not tbKey then
		Log(debug.traceback(), it.dwTemplateId)
		return 
	end
	if tbKey.NeedOpenAct == 1 then
		--只有活动当天才能用
		local tbIds = Calendar:GetUseDegreeCalenderIds(tbKey.AddDegree)
		local bOpenToday = false
		for i, nId in ipairs(tbIds) do
			local tbTime = Calendar:GetTodayOpenTime(nId)
			if next(tbTime) then
				bOpenToday = true
				break;
			end
		end
		if not bOpenToday then
			return 0, string.format("Hôm nay không có hoạt động %s, không thể dùng",Calendar:GetActivityName(tbIds[1]) );
		end
	end
	if tbKey.CostDegree ~= "" then
		return DegreeCtrl:GetMaxDegree(tbKey.CostDegree, me)
	end
	return self.MAX_ADD_COUNT
end

function tbCountAddProp:OnClientUse(it)
	local nMaxCount, szMsg = self:GetMaxUseCount(it)
	if szMsg then
		me.CenterMsg(szMsg)
	end
	if not nMaxCount or nMaxCount == 0 then
		return 1;
	end
end

function tbCountAddProp:GetUseSetting(nItemTemplateId, nItemId)
	if nItemId and nItemId > 0 then
		return {szFirstName = "Dùng", fnFirst = "UseItem"};
	end

	local nPrice = MarketStall:GetPriceInfo("item", nItemTemplateId);
	if not nPrice then
		return {};
	end

	return {
				bForceShow = true,
				szFirstName = "Đến Bày Bán mua",
				fnFirst = function ()
					Ui:OpenWindow("MarketStallPanel", 1, nil, "item", nItemTemplateId);
					Ui:CloseWindow("ItemTips");
				end
			};
end


function tbCountAddProp:GetTip(it)
	local tbKey = self.tbAllPropInfo[it.dwTemplateId];
	if Lib:IsEmptyStr(tbKey.CostDegree) then
		return
	end
	local nMaxCount, szMsg = self:GetMaxUseCount(it)
	if nMaxCount == self.MAX_ADD_COUNT then
		return
	end
	nMaxCount = nMaxCount or 0
	local nCurCount = math.min(nMaxCount, DegreeCtrl:GetDegree(me, tbKey.CostDegree))
	return string.format("Có thể dùng: %s/%d", nCurCount, nMaxCount);
end