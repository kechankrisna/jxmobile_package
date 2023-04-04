local tbNpc = Npc:GetClass("KinManager");


function tbNpc:OnDialog()
	local tbDlg = {};

	if Task.KinTask:CheckOpen() then
		table.insert(tbDlg, { Text = "Nhiệm vụ Bang Hội", Callback = Task.KinTask.TryAcceptTask, Param = {Task.KinTask, me.dwID} });
	end	

	if KinDinnerParty:CanAcceptTask(me) then
		table.insert(tbDlg, { Text = "Nhiệm Vụ Tiệc", Callback = self.AcceptTaskDlg, Param = {self}})
	end

	if KinDinnerParty:IsDoingTask(me) and KinDinnerParty:IsFinishedTask(me) then
		table.insert(tbDlg, { Text = "Hoàn thành Nhiệm Vụ Tiệc", Callback = KinDinnerParty.FinishTask, Param = {KinDinnerParty, me.dwID}})
	end

	local nKinNestState = Kin.KinNest:GetKinNestState(me.dwKinId);
	if nKinNestState == 1 then
		table.insert(tbDlg, { Text = "Mở Hầm Gian Thương ", Callback = self.DoKinNest, Param = {self} });
	elseif nKinNestState == 2 then
		table.insert(tbDlg, { Text = "Đến Hầm Gian Thương", Callback = self.DoKinNest, Param = {self} });
	end
	local fnSelfChuanGong = function(dwID,dwKinId)
		local tbKinData = Kin:GetKinById(dwKinId) 
	    if not tbKinData then
	        return
	    end
		Dialog:Show(
		{
		    Text    = string.format("Có thể tốn [FFFE0D]1 lần[-] nhận truyền công để ngồi thiền, tu luyện xong nhận được EXP. [FF6464FF]Chú ý: EXP ngồi thiền sẽ ít hơn EXP truyền công[-]"),
		    OptList = {
		   		[1] = { Text = "Ngồi thiền tu luyện", Callback = ChuangGong.SelfChuanGong, Param = {ChuangGong, dwID} },
		   		[2] = {Text = "Hiểu rồi"}
		    },
		}, me, him);
	end
	table.insert(tbDlg, { Text = "Ngồi thiền", Callback = fnSelfChuanGong, Param = {me.dwID,me.dwKinId} });

	table.insert(tbDlg, {Text = "Hiểu rồi"});

	Dialog:Show(
	{
	    Text    = "Sự phồn vinh của bang hội cần dựa vào nỗ lực của từng thành viên!",
	    OptList = tbDlg,
	}, me, him);
end

function tbNpc:AcceptTaskDlg()
	Dialog:Show({
        Text = "Nhận Nhiệm Vụ Tiệc?",
        OptList = {
            { Text = "Chấp nhận", Callback = KinDinnerParty.AcceptTask, Param = {KinDinnerParty, me.dwID}},
            {Text = "Để sau"},
        },
    }, me, him)
end

function tbNpc:Donation()
	me.CallClientScript("Ui:OpenWindow", "KinVaultPanel");
end

function tbNpc:DoKinNest()
	local nKinNestState = Kin.KinNest:GetKinNestState(me.dwKinId);
	local OnOk = function ()
	     Kin.KinNest:ApplyOpenKinNest(me);
	end

	if nKinNestState == 1 then
		me.MsgBox(string.format("Hầm Gian Thương nguy hiểm, sau khi mở sẽ gửi thông báo đến tất cả thành viên, đồng ý mở?"), { {"Đồng ý", OnOk}, {"Hủy"}});
	elseif nKinNestState == 2 then
		Kin.KinNest:EnterKinNest(me.dwID);
	end
end