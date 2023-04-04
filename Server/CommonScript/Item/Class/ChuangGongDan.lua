local tbItem = Item:GetClass("ChuangGongDan");

local nChuangGongDanUseResetTime = 4 * 60 * 60    -- 传功丹每天使用次数的重置时间点

local nAddChuangGongTimes = 1 					 -- 使用之后增加的被传次数
local nAddChuangGongSendTimes = 1 				 -- 使用之后增加的传功次数

tbItem.nItemId = 2759

---------------上面策划配

function tbItem:OnUse(it)
	if not it.dwTemplateId then
		return 
	end

	local bRet, szMsg = self:CheckUse(me)
	if not bRet then
		me.CenterMsg(szMsg)
		return
	end

	local nAddChuangGong = 0
	local nAddChuangGongSend = 0

	local _, _, nChuangGongDan = ChuangGong:GetDegree(me, "ChuangGong")
	local _, _, nChuangGongSendDan = ChuangGong:GetDegree(me, "ChuangGongSend")

	nAddChuangGong = nAddChuangGongTimes - nChuangGongDan
	nAddChuangGongSend = nAddChuangGongSendTimes - nChuangGongSendDan

	me.SetUserValue(ChuangGong.SAVE_GROUP, ChuangGong.KEY_USE_CHUANGGONGDAN_TIME, GetTime());
	
	szMsg = ""
	if nAddChuangGongSend > 0 then
		me.SetUserValue(ChuangGong.SAVE_GROUP, ChuangGong.KEY_EXTRA_CHUANGGONGSEND, nAddChuangGongSend + nChuangGongSendDan);
		szMsg = szMsg ..XT(string.format("Tăng [FFFE0D]%d lần[-] truyền công", nAddChuangGongSend))
	end
	if nAddChuangGong > 0 then
		me.SetUserValue(ChuangGong.SAVE_GROUP, ChuangGong.KEY_EXTRA_CHUANGGONG, nAddChuangGong + nChuangGongDan);
		if nAddChuangGongSend > 0 then
			szMsg = szMsg ..","
		end
		szMsg = szMsg ..XT(string.format("Tăng [FFFE0D]%d lần[-] nhận truyền công", nAddChuangGong))
	end

	me.CenterMsg(szMsg)
	Log("[ChuangGongDan] Use ", me.szName, me.dwID, nAddChuangGong, nAddChuangGongSend, nChuangGongDan, nChuangGongSendDan)
	return 1
end

function tbItem:GetUseSetting(nTemplateId, nItemId)
	return {szFirstName = "Dùng", fnFirst = "UseChuangGongDan"};
end

function tbItem:UseChuangGongDan(nItemId)
	local _, _, nChuangGongDan = ChuangGong:GetDegree(me, "ChuangGong")
	local _, _, nChuangGongSendDan = ChuangGong:GetDegree(me, "ChuangGongSend")

	local nAddChuangGong = nAddChuangGongTimes - nChuangGongDan
	local nAddChuangGongSend = nAddChuangGongSendTimes - nChuangGongSendDan

	local bTip = false
	local szMsgTip = ""

	if nChuangGongSendDan > 0 and nChuangGongDan <= 0 then
		bTip = true
		szMsgTip = string.format("[FFFE0D]Số lần tăng truyền công của Truyền Công Đơn đã đạt giới hạn[-]\nSử dụng tăng [FFFE0D]%d lần[-] nhận truyền công", nAddChuangGong)
	elseif nChuangGongDan > 0 and nChuangGongSendDan <= 0 then
		bTip = true
		szMsgTip = string.format("[FFFE0D]Số lần nhận truyền công của Truyền Công Đơn đã đạt giới hạn[-]\nSử dụng tăng [FFFE0D]%d lần[-] truyền công", nAddChuangGongSend)
	end

	local fnUse = function (nItemId)
		RemoteServer.UseItem(nItemId);
	end

	if bTip then
		me.MsgBox(szMsgTip,
		{
			{"Dùng", fnUse, nItemId},
			{"Tạm không dùng"},
		})
	else
		RemoteServer.UseItem(nItemId);
	end
end

function tbItem:CheckUse(pPlayer)
	local nUseTime = ChuangGong:ChuangGongDanUseTime(pPlayer)
	local bIsCross = Lib:IsDiffDay(nChuangGongDanUseResetTime, nUseTime)
	if not bIsCross then
		return false, XT("Hôm nay đã dùng Truyền Công Đơn (4:00 hôm sau được dùng tiếp) ")
	end

	local _, _, nChuangGongDan = ChuangGong:GetDegree(pPlayer, "ChuangGong")
	local _, _, nChuangGongSendDan = ChuangGong:GetDegree(pPlayer, "ChuangGongSend")
	if nChuangGongDan >= nAddChuangGongTimes and nChuangGongSendDan >= nAddChuangGongSendTimes then
		return false, XT("Số lần truyền công và nhận truyền công của Truyền Công Đơn đã đạt giới hạn, hãy tiêu hao rồi sử dụng tiếp")
	end

	return true
end

function tbItem:GetChuangGongDanUseResetTime()
	return nChuangGongDanUseResetTime
end

