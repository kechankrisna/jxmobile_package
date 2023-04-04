local tbItem = Item:GetClass("ImperialTombTicket");

function tbItem:GetUseSetting()
	return {};
end

function tbItem:GetIntrol()
	Log(GetTimeFrameState(ImperialTomb.FEMALE_EMPEROR_TIME_FRAME))
	if GetTimeFrameState(ImperialTomb.FEMALE_EMPEROR_TIME_FRAME) ~= 1 then
		return "Viên ngọc long lanh không chỉ phát sáng trong bóng tối, còn có công dụng giải độc.\n\nDùng tham gia Thủy Hoàng Giáng Thế lúc [FFFE0D]21:55-22:30 thứ năm, chủ nhật[-]"
	else
		return "Viên ngọc long lanh không chỉ phát sáng trong bóng tối, còn có công dụng giải độc.\n\nDùng tham gia Thủy Hoàng Giáng Thế lúc [FFFE0D]21:55-22:30 thứ năm[-], Nữ Đế Hồi Sinh lúc [FFFE0D]21:55-22:30 chủ nhật[-]"
	end
end