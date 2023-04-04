local tbNpc = Npc:GetClass("CardPickHelper");

function tbNpc:OnDialog()
	local szText = "Hoa đào, may mắn luôn ở bên cạnh";
	local tbOptList = {};

	if version_tx then
		table.insert(tbOptList, { Text = "Thông báo tỉ lệ ngẫu nhiên", Callback = function () self:OpenCardPickProbInfo(); end});
		table.insert(tbOptList, { Text = "Xem nhật ký chiêu mộ", Callback = function () self:ShowCardPickHistory(); end});
	end

	Dialog:Show(
	{
		Text	= szText,
		OptList = tbOptList,
	}, me, him);
end

function tbNpc:OpenCardPickProbInfo()
	me.CallClientScript("Ui:OpenWindow", "CardPickRecordPanel", "Prob");
end

function tbNpc:ShowCardPickHistory()
	me.CallClientScript("Ui:OpenWindow", "CardPickRecordPanel", "History");
end