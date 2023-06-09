local tbTimeCase = Item:GetClass("TimeCase");

function tbTimeCase:LoadSetting()
	self.tbAllCaseInfo = {};

	local tbFileData = Lib:LoadTabFile("Setting/Item/Other/TimeCase.tab", {TemplateId = 1, ServerOpenDay = 1});
	for _, tbInfo in pairs(tbFileData) do
		self.tbAllCaseInfo[tbInfo.TemplateId] = tbInfo;
	end	
end

tbTimeCase:LoadSetting();

function tbTimeCase:OnUse(pItem)
	local nRet, szMsg = self:CheckUsable(pItem);
	if nRet ~= 1 then
		me.CenterMsg(szMsg);
		return 0;
	end	
	
	local nReturn = Item:GetClass("RandomItem"):OnUse(pItem);
	if nReturn ~= 1 then
		return 0;
	end

	return 1;
end


function tbTimeCase:CheckUsable(pItem)
	local tbItemInfo = self.tbAllCaseInfo[pItem.dwTemplateId];
	if not tbItemInfo then
		Log("[tbTimeCase] OnUse ERR ?? tbKey is nil !!", me.szName, me.dwID, pItem.szName, pItem.dwTemplateId);
		return 0, "Hệ thống kiểm tra thấy đạo cụ bất thường, không thể dùng!";
	end

	local nServerOpenDay = Lib:GetServerOpenDay();
	if tbItemInfo.ServerOpenDay > nServerOpenDay then
		return 0, "Chưa đến thời gian mở";
	end	

	return 1;
end