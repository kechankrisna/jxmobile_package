local tbNpc = Npc:GetClass("CommerceTask")

function tbNpc:OnDialog()
	if me.nLevel < CommerceTask.START_LEVEL then
		local szDefaultText = string.format("Đại hiệp cần rèn luyện thêm, đạt Lv%d hãy quay lại.", CommerceTask.START_LEVEL);
		Dialog:Show({Text = szDefaultText, OptList = {}}, me, him);
		return;
	end

	if not CommerceTask:IsTimeFrameOpen() then
		Dialog:Show({Text = "Hoạt động chưa mở", OptList = {}}, me, him);
		return;
	end

	if CommerceTask:CanAcceptTask(me) then
		local OptList = {
			{Text = "Chấp nhận", Callback = self.Accept, Param = {self}},
			{Text = "Để sau"},
		};
		local szDefaultText = "Thương Hội gần đây thiếu chút vật phẩm, đại hiệp có thể giúp đỡ không?";
		local tbDialogInfo = {Text = szDefaultText, OptList = OptList};
		Dialog:Show(tbDialogInfo, me, him);
	elseif CommerceTask:IsDoingTask(me) then
		CommerceTask:SyncCommerceData(me);
		local tbCommerceTask = CommerceTask:GetTaskInfo(me)
		local nFinishCount = 0
		for i = 1, 10 do
			local tbTask = tbCommerceTask.tbTask[i]
			if tbTask.bFinish then
				nFinishCount = nFinishCount + 1
			end
		end

		if nFinishCount < CommerceTask.COMPLETE_COUNT then
			me.CallClientScript("Ui:OpenWindow", "CommerceTaskPanel")
		else
			local szDefaultText = "Chuyện lão phu nhờ thế nào rồi?"
			local OptList = {
				{Text = "Nộp hàng hóa", Callback = CommerceTask.FinishTask, Param = {CommerceTask, me.dwID}}
			}
			local tbDialogInfo = {Text = szDefaultText, OptList = OptList};
			Dialog:Show(tbDialogInfo, me, him);
		end
	else
		local szDefaultText = "Hôm nay không thể nhận tiếp nhiệm vụ Thương Hội";
		local tbDialogInfo = {Text = szDefaultText, OptList = {}};
		Dialog:Show(tbDialogInfo, me, him);
	end
end

function tbNpc:Accept()
	CommerceTask:AcceptTask(me);
	
	CommerceTask:SyncCommerceData(me);
	me.CallClientScript("Ui:OpenWindow", "CommerceTaskPanel")
end