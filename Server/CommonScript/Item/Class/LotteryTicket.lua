local tbItem = Item:GetClass("LotteryTicket");

function tbItem:OnUse(it)
	local bSuccess = Lottery:ExchangeTicket(me);
	if not bSuccess then
		return;
	end
	return 1;
end

function tbItem:GetTip(it)
	return string.format("Tần này đã dùng: %d tấm", Lottery:GetTicketCount());
end