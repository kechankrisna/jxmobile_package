local tbItem = Item:GetClass("BaiXiaoShengTuJianItem");

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local tbUserSet = {};
	local fnOpenWeb = function ()
		local szUrl = "https://jxqy.qq.com/cp/a20190222jhz/index_g.html?sRoleId=%s&sPlatId=%s&sOpenId=%s&sArea=%s&sPartition=%s&sNickName=%s";
		local tbMyInfo = FriendShip:GetMyPlatInfo();
		local szFinalUrl = string.format(szUrl,tostring(me.dwID),tostring(Sdk:GetLoginPlatId()),tostring(Sdk:GetUid()),tostring(Sdk:GetAreaId()),tostring(Sdk:GetServerId()),Lib:UrlEncode(tbMyInfo.szNickName or me.szName));
		Sdk:OpenUrl(szFinalUrl);
	end

	tbUserSet.szFirstName = "Dùng"
	tbUserSet.fnFirst = fnOpenWeb;
	return tbUserSet;
end

