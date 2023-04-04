local tbItem = Item:GetClass("BaiJuWan");

tbItem.nAddTime = 8 * 60 * 60;						-- 增加挂机时间
tbItem.nPrice = 48;									-- 价格

function tbItem:OnUse(it)
	if not it.dwTemplateId then
		return 
	end

	if not OnHook:IsOpen(me) then
		me.CenterMsg("Ủy thác rời mạng chưa mở");
		return
	end
	local nBaiJuWanTime = OnHook:BaiJuWanTime(me)
	if nBaiJuWanTime >= OnHook.nBaiJuWanLimitTime then
		me.CenterMsg("Thời gian tích lũy Bạch Câu Hoàn đã đạt giới hạn, tạm không thể dùng");
		return
	end
	local nRet = OnHook:OnUseBaiJuWan(me,self.nAddTime,OnHook.OnHookType.Pay);
	
	if not nRet then
		return 0
	end

	return 1
end
