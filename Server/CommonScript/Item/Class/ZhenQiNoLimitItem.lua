
local tbItem = Item:GetClass("ZhenQiNoLimitItem");
tbItem.SET_ZHENQI_VALUE = 20000 				-- 设置值
tbItem.USE_TIME_FRAME = "OpenLevel79" 			-- 使用时间轴
function tbItem:OnUse(it)
	if self.USE_TIME_FRAME and GetTimeFrameState(self.USE_TIME_FRAME) ~= 1 then
		me.CenterMsg("Tạm không thể dùng", true)
		return
	end
	local nDegree = DegreeCtrl:GetDegree(me, "ZhenQiLimitCount")
	if nDegree < 1 then
		me.CenterMsg("Hôm nay đã không thể dùng", true)
		return 
	end
	local nHave = me.GetMoney("ZhenQi")
	if nHave >= self.SET_ZHENQI_VALUE then
		me.CenterMsg(string.format("Điểm Chân Khí đã vượt quá %s", self.SET_ZHENQI_VALUE), true)
		return 
	end
	if not DegreeCtrl:ReduceDegree(me, "ZhenQiLimitCount", 1) then
		me.CenterMsg("Trừ số lần thất bại", true)
		return
	end	
	local nAdd = self.SET_ZHENQI_VALUE - nHave
	me.SendAward({{"ZhenQi", nAdd}}, true, true, Env.LogWay_ZhenQiNoLimitItem);
end

