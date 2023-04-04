
local tbAct = Activity:GetClass("RechargeResetDouNews");

tbAct.tbTimerTrigger = 
{ 
}
tbAct.tbTrigger = { 
	Init 	= { }, 
	Start 	= { }, 
	End 	= { }, 
}


function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Start" then
		self:SendNews()
	end
end

function tbAct:SendNews()
	local _, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("RechargeResetDou", nEndTime, {[[。
        [FFFE0D]Nghênh hoàn toàn mới phim tư liệu, toàn dân cuồng hoan phúc lợi [-]
            Chư vị hiệp sĩ, hoàn toàn mới phim tư liệu sắp đến, trở xuống là hoạt động báo trước ~

            Thời gian hoạt động: [FFFE0D]2016 Năm 9 Nguyệt 10 Nhật -2016 Năm 9 Nguyệt 20 Nhật [-]
            Nghênh hoàn toàn mới phim tư liệu, toàn dân cuồng hoan phúc lợi! Hoạt động trong lúc đó chỉ cần đăng nhập trò chơi hiệp sĩ, tất cả đã trữ giá trị ngăn [FFFE0D] Lần đầu trữ giá trị gấp đôi Nguyên bảo ban thưởng [-] Sẽ một lần nữa mở ra.
        ]]}, {szTitle = "Toàn dân cuồng hoan", nReqLevel = 1})
end

