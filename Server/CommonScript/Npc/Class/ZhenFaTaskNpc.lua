
local tbNpc = Npc:GetClass("ZhenFaTaskNpc");

function tbNpc:OnDialog()
	if TimeFrame:GetTimeFrameState(ZhenFaTask.szOpenTimeFrame) ~= 1 then
		Dialog:Show({Text = "Sức một người chưa đủ! Nếu biết kết hợp sức mạnh xung quanh hợp thành liên minh, thì sẽ trường thịnh!", OptList = {}}, me, him);
		return;
	end

	local bRet, szMsg = ZhenFaTask:CheckCanAcceptTaskCommon(me);
	if not bRet then
		me.CenterMsg(szMsg);
		return;
	end

	local OptList = {
		{Text = "Chấp nhận", Callback = self.Accept, Param = {self}},
		{Text = "Thoát"},
	};
	local szDefaultText = "Đại hiệp đã sẵn sàng mở Trận Pháp Thí Luyện hôm nay?";
	local tbDialogInfo = {Text = szDefaultText, OptList = OptList};
	Dialog:Show(tbDialogInfo, me, him);
end

function tbNpc:Accept()
	local bRet, szMsg = ZhenFaTask:CheckCanAcceptTaskByNpc(me);
	if not bRet then
		me.CenterMsg(szMsg);
		return;
	end

	c2s:OnTeamRequest("AskTeammate2Follow");

	me.MsgBox("Thành viên không ở gần, không thể mở thí luyện, đã triệu hồi tất cả thành viên!", {{"Được", function ()
		ZhenFaTask:AcceptNewTask(me);
	end}});
end
