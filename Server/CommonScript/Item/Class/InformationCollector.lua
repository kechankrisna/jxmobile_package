local tbItem = Item:GetClass("InformationCollector");

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local tbUserSet = {};
	local fnOpenWeb = function ()
		local szUrl = "https://jxqy.qq.com/ingame/act/a20181108infov/index_g.html";
		Sdk:OpenUrl(szUrl);
	end

	tbUserSet.szFirstName = "Dùng"
	tbUserSet.fnFirst = fnOpenWeb;
	return tbUserSet;
end