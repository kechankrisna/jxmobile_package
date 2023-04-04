
local tbAct = Activity:GetClass("DomainBattleAct");

tbAct.tbTimerTrigger = 
{ 
	[1] = {szType = "Day", Time = "4:02" , Trigger = "SendNews"},					--第一次攻城战是4：02
}
tbAct.tbTrigger = { 
	Init 	= { }, 
	Start 	= { {"StartTimerTrigger", 1}, }, 
	End 	= { }, 
	SendNews= { };
}


function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Start" then
		self:SendNews();
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
	NewInformation:AddInfomation("DomainBattleAct", nEndTime, {[[
[FFFE0D]Công thành chiến cuồng hoan hoạt động [-]

    Các vị đại hiệp, tuần này sắp mở ra công thành chiến cuồng hoan hoạt động, tham dự công thành chiến tướng thu hoạch được càng nhiều ban thưởng, mời nô nức tấp nập tham gia.
[FFFE0D] Thời gian hoạt động: 7 Nguyệt 12 Nhật ——7 Nguyệt 16 Nhật [-]
[FFFE0D] Hoạt động một: [-] Bang phái khí giới công thành đánh gãy
    Tại hoạt động trong lúc đó, chiến tranh phường bán ra khí giới công thành giá cả đem biến thành [FFFE0D] Giảm còn 80% [-].
[FFFE0D] Hoạt động hai: [-] Người ban thưởng gia tăng
    Tại hoạt động trong lúc đó, tham gia công thành chiến sau, người thu hoạch được ban thưởng [FFFE0D] Gia tăng 50%[-], sẽ thu hoạch được càng nhiều công thành bảo rương.
	]]} )	

end
