local tbItem = Item:GetClass("WaiYiTryToken")

function tbItem:OnUse(it)
    if GetTimeFrameState(WaiYiTry.Def.szMaxTimeframe) == 1 then
        local szMsg = "Cấp máy chủ của đại hiệp cao hơn cấp trải nghiệm, có thể đến [FFFE0D]Cửa Hàng Ngân Sức[-] mua ngoại trang tuyệt đẹp"
        me.CenterMsg(szMsg)
        me.Msg(szMsg)
		return 1
    end
	me.CallClientScript("Ui:OpenWindow", "WaiYiTryPanel")
	return 0
end
