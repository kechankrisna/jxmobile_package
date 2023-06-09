
local tbItem = Item:GetClass("DebrisAvod");

function tbItem:OnUse(it)
	for i,v in ipairs(Debris.tbBuyAvoidRobSet) do
		if it.dwTemplateId == v[3] and it.nCount >= v[4] then
			local bRet, szMsg = Debris:AvoidRob(me.dwID, v[2])
			if not bRet then
				me.CenterMsg(szMsg)
				return 
			end
			me.CenterMsg("Mua thời gian miễn chiến thành công")
			me.CallClientScript("Debris:RefreshMainPanel");
			return v[4]
		end
	end
end