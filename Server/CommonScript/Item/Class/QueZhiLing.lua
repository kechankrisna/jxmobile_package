local tbItem = Item:GetClass("QueZhiLing")

function tbItem:OnUse(it)
	local _, tbRunning = Activity:GetActivityData()
	if not tbRunning.QueQiaoXiangHuiAct then
		me.CenterMsg("Không trong bản đồ hoạt động")
		return
	end

	local tbAct = tbRunning.QueQiaoXiangHuiAct.tbInst
	tbAct:OnClientReq(me, "Put")
end

function tbItem:GetUseSetting(nTemplateId, nItemId)
	return {szFirstName = "Đặt", fnFirst = "UseItem"}
end