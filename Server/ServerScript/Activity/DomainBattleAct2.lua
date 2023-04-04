
local tbAct = Activity:GetClass("DomainBattleAct2");

tbAct.tbTimerTrigger = 
{ 
	[1] = {szType = "Day", Time = "19:10" , Trigger = "AddAcution"},				
	[2] = {szType = "Day", Time = "4:02" , Trigger = "SendNews"},					--第一次攻城战是4：02
}
tbAct.tbTrigger = { 
	Init 	= { }, 
	Start 	= { {"StartTimerTrigger", 1}, {"StartTimerTrigger", 2},}, 
	End 	= { }, 
	AddAcution = {};
	SendNews = {};
}


function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Start" then
		self:SendNews();
	elseif szTrigger == "AddAcution" then

		self:AddAcution()
	elseif szTrigger == "SendNews" then
		self:SendNews();
	end
end

function tbAct:SendNews()
	local nVersion = DomainBattle:GetBattleVersion()
	if not nVersion or nVersion == 0 then
		return
	end
	local _, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("DomainBattleAct2", nEndTime, {[[
\t\t[FFFE0D]Công thành chiến cuồng hoan hoạt động hai [-]
\t\t\t[FFFE0D] Thời gian hoạt động: 7 Nguyệt 17 Nhật ——7 Nguyệt 23 Nhật [-]
\t\t\t Các vị hiệp sĩ, hoạt động trong lúc đó, Tây Vực hành thương bắt đầu xuất hiện tại các lớn lãnh địa buôn bán các loại trân quý vật phẩm.
\t\t\t Mỗi ngày [FFFE0D]19: 10[-], bang phái phòng đấu giá sẽ xuất hiện [FFFE0D] Lãnh địa hành thương [-] Đấu giá, tham gia [FFFE0D] Lần trước công thành chiến [-] Bang phái thành viên có thể thu hoạch được đấu giá chia hoa hồng.
]]} )
end

function tbAct:AddAcution()
	DomainBattle:AddOnwenrAcutionAward()
end
