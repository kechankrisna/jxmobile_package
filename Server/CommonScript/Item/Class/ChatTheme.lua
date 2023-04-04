local tbItem = Item:GetClass("ChatTheme");

function tbItem:OnUse(it)

	local ChatDecorate = ChatMgr.ChatDecorate
	local tbValueDecorate = ValueItem.ValueDecorate;

	local nThemeID =  KItem.GetItemExtParam(it.dwTemplateId, 1);
	local nTime =  KItem.GetItemExtParam(it.dwTemplateId, 2);
	
	local tbThemeInfo = ChatDecorate:GetThemeInfo(nThemeID)
	if not tbThemeInfo then
		Log("[ChatTheme] no theme info",nThemeID,nTime,me.dwID,me.szName)
		return
	end

	if tbThemeInfo.nDefault == 1 then
		Log("[ChatTheme] use default theme? ",nThemeID,nTime,me.dwID,me.szName)
		return
	end

	local nCurTime =  tbValueDecorate:GetValue(me,nThemeID)

	if nCurTime == ChatDecorate.Valid_Type.FOREVER then
		me.CenterMsg("Đã có khung đại diện vĩnh viễn này")
		Log("[ChatTheme] cover forever",nThemeID,nTime,me.dwID,me.szName)
		return
	end

	local nNowTime = GetTime()
	if nNowTime < nCurTime then
		me.CenterMsg("Đã có khung đại diện này, hãy dùng tiếp sau khi hết hạn")
		return
	end

	local nNewTime = nTime == 0 and ChatDecorate.Valid_Type.FOREVER or nNowTime + nTime

	tbValueDecorate:SetValue(me,nThemeID,nNewTime)

	me.CenterMsg(string.format("Nhận được khung đại diện「%s」",ChatDecorate:GetTitleByThemeId(nThemeID, me.nSex) or ""),true)

	Log("[ChatTheme] OnUse ok",nNewTime,nCurTime,nThemeID,nTime,me.dwID,me.szName)

	return 1
end