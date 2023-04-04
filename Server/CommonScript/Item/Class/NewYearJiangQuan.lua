local tbItem = Item:GetClass("NewYearJiangQuan");
tbItem.szNewYearOverdue = "2019-2-10-22-00-00"               -- 新年奖券过期时间
tbItem.nNewYearJianQuanItemId = 3689
tbItem.nUseLevel = 1
function tbItem:OnUse(it)
	if not ChouJiang.bOpen then
		me.CenterMsg("Hiện chưa mở rút thưởng", true)
		return
	end
	if not it.dwTemplateId then
		return 
	end
	
	if self:CheckOverdue() then
		me.CenterMsg("Đạo cụ đã quá hạn", true)
		return 1
	end

	if me.nLevel < self.nUseLevel then
		me.CenterMsg(string.format("Lv%d mới được dùng", self.nUseLevel), true)
		return
	end	

	local bInProcess = Activity:__IsActInProcessByType("ChouJiang")
	if not bInProcess then
		me.CenterMsg("Hoạt động đã kết thúc", true)
		return
	end

	Activity:OnPlayerEvent(me, "Act_OnUseNewYearJiangQuan")
end

function tbItem:GetOverdueTime()
	local tbTime = Lib:SplitStr(self.szNewYearOverdue, "-")
	local year, month, day, hour, minute, second = unpack(tbTime)
	return os.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(minute), sec = tonumber(second)})
end

function tbItem:CheckOverdue()
	local nNowTime = GetTime()
	local nOverdueTime = self:GetOverdueTime()
	return nNowTime >= nOverdueTime
end

function tbItem:GetTip()
	local szTips = ""
	local tbTime = Lib:SplitStr(self.szNewYearOverdue, "-")
	local year, month, day, hour = unpack(tbTime)
	local szOverdue = self:CheckOverdue() and "(Đã quá hạn)" or ""
	local nLastExeDay = ChouJiang:GetLastExeDay(ChouJiang.tbActInfo.nStartTime)
	local tbTime = Lib:SplitStr(ChouJiang.szDayTime, ":")
	local szExeDate = ChouJiang.tbDayLotteryDate[nLastExeDay] and string.format("Thời gian rút thưởng: %s %s giờ", ChouJiang.tbDayLotteryDate[nLastExeDay], tbTime[1] or "-") or ""
	szTips = szTips ..string.format("Hết hạn: %s/%s %s:%s\n%s", month, day, hour, szOverdue, szExeDate)
	return szTips
end

function tbItem:GetIntrol()
	local nLastExeDay = ChouJiang:GetLastExeDay(ChouJiang.tbActInfo.nStartTime)
	local szExeDate = ChouJiang.tbDayLotteryDate[nLastExeDay] and string.format("%s",ChouJiang.tbDayLotteryDate[nLastExeDay]) or ""
	return string.format("Sau khi dùng tham gia [FFFE0D]%s[-] rút thưởng, đồng thời nhận [FFFE0D]thưởng lớn Nguyên Tiêu 19/2[-], nhấp chọn [FFFE0D]Xem trước[-] để xem nội dung phần thưởng.", szExeDate)
end

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local fnPreview = function ()
		Ui:OpenWindow("NewInformationPanel", ChouJiang.szOpenNewInfomationKey)
		Ui:CloseWindow("ItemTips")
    end
	return {szFirstName = "Xem trước", fnFirst = fnPreview, szSecondName = "Dùng", fnSecond = "UseItem"};
end