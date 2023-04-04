local tbNpc = Npc:GetClass("PrisonHelper");

function tbNpc:OnDialog()
	local szText = "Chỉ cần cho ta tiền, ta sẽ giúp ngươi thoát khỏi nơi này!";
	local tbOptList = {};

	table.insert(tbOptList, { Text = "Nộp nợ", Callback = function () self:OpenRechargeWindow(); end});
	table.insert(tbOptList, { Text = "Thoát Địa Lao Tối", Callback = function () self:Leave(); end});

	Dialog:Show(
	{
		Text	= szText,
		OptList = tbOptList,
	}, me, him);
end

function tbNpc:OpenRechargeWindow()
	if me.GetMoneyDebt("Gold") <= 0 then
		me.MsgBox("Đã nộp đủ nợ, đến Kỳ Trân Các?", {{"Tiếp tục", function ()
			me.CallClientScript("Ui:OpenWindow", "CommonShop", "Recharge", "Recharge");
		end}, {"Hủy"}});
		return;
	end

	me.CallClientScript("Ui:OpenWindow", "CommonShop", "Recharge", "Recharge");
end

function tbNpc:Leave()
	if me.CanPushPrison() then
		me.CenterMsg("Còn nợ chưa nộp, hãy nộp đủ");
	else
		Log("Leave Prison", me.dwID, me.szName);
		me.PushToPrison(0);
		Map:SwitchMapDirectly(Map.MAIN_CITY_XIANYAN_TEAMPLATE_ID, Map.MAIN_CITY_XIANYAN_TEAMPLATE_ID);
	end
end