local tbItem = Item:GetClass("LabaZhou");
tbItem.nAssistId = 1
-- 266
function tbItem:GetUseSetting(nItemTemplateId, nItemId)
	local function fnGo()
		Ui.HyperTextHandle:Handle("[url=npc:Lưu Vân, 91, 15]", 0, 0)
		Ui:CloseWindow("ItemTips")
		Ui:CloseWindow("ItemBox")
	end
	return {szFirstName = "Dùng", fnFirst = fnGo};
end
function tbItem:GetTip(it)
	return "[FFFE0D]Bánh Chưng[-] nóng hổi, dâng lên Quốc Tổ Hùng Vương";
end

function tbItem:GetIntrol(nTemplateId, nItemId)
	 local it 
	 if nItemId then
	 	it = KItem.GetItemObj(nItemId)
	 end
	 local szTips  ="";

	if not it then
		szTips = "Nấu từ [FFFE0D]Gạo Nếp[-], [FFFE0D]Đậu Xanh[-], [FFFE0D]Lá Dong[-], [FFFE0D]Thịt Lợn[-], [FFFE0D]Muối[-], [FFFE0D]Dây Lạt[-], [FFFE0D]Hạt Tiêu[-], [FFFE0D]Củ Hành[-], mùi thơm phảng phất";
	else
		local szAssistPlayerName = it.GetStrValue(self.nAssistId);
		if not Lib:IsEmptyStr(szAssistPlayerName) then
			szTips = string.format("%s đã giúp đỡ nấu Bánh Chưng.\n", szAssistPlayerName)
		end
		szTips = szTips .. "Hộ tống đến tiền tuyến có thể nhận"
		
	end

	return szTips;
end