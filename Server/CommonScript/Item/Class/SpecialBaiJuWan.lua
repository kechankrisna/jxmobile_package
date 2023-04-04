local tbItem = Item:GetClass("SpecialBaiJuWan");

tbItem.nAddTime = 8 * 60 * 60;						-- 增加特效白驹丸时间
tbItem.nPrice = 240;								-- 价格

function tbItem:OnUse(it)
	if not it.dwTemplateId then
		return 
	end

	if not OnHook:IsOpen(me) then
		me.CenterMsg("Ủy thác rời mạng chưa mở");
		return
	end
	local nBaiJuWanTime = OnHook:SpecialBaiJuWanTime(me)
	if nBaiJuWanTime >= OnHook.nSpecialBaiJuWanLimitTime then
		me.CenterMsg("Thời gian tích lũy Đại Bạch Câu Hoàn đã đạt giới hạn, tạm không thể dùng");
		return
	end
	local bRet = OnHook:OnUseBaiJuWan(me,self.nAddTime,OnHook.OnHookType.SpecialPay)

	if not bRet then
		return 0
	end

	return 1
end
