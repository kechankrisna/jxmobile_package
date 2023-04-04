local tbNpc   = Npc:GetClass("HuaTongNpc")
function tbNpc:OnDialog()
    local nOpenDay, nOpenTime = Wedding:CheckTimeFrame()
    if nOpenDay then
         Dialog:Show(
        {
            Text = string.format("Hi hi, ngươi có phải đã thích ai đó không? Nói ra không chừng Nguyệt gia sẽ giúp được ngươi.\n[FFFE0D]Hệ thống kết hôn sẽ mở sau %d ngày![-]", nOpenDay),
            OptList = {},
        }, me, him)
        return 
    end
	 Dialog:Show(
        {
            Text = "Hi hi, ngươi có phải đã thích ai đó không? Nói ra không chừng Nguyệt gia sẽ giúp được ngươi.",
            OptList = {
                { Text = "Cửa Hàng Hôn Lễ", Callback = self.Shop, Param = {self, me.dwID} };
            },
        }, me, him)
end

function tbNpc:Shop(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
       return
	end
	pPlayer.CallClientScript("Ui:OpenWindow", "KinStore", "WeddingShop")
end