local tbNpc = Npc:GetClass("CollectAndRobClueDialog")

function tbNpc:OnDialog()
	local nAcceptRoleId = him.nAcceptRoleId
	if not nAcceptRoleId then
		return
	end
	if me.dwID ~= nAcceptRoleId then
		local tbDialogInfo = {Text = "Hình như ta không quen biết ngươi.", OptList = {}};
		Dialog:Show(tbDialogInfo, me, him);	
		return
	end

	local OptList = {
		{Text = "Chấp nhận", Callback = self.Accept, Param = {self}},
		{Text = "Để sau"},
	};
	local tbDialogInfo = {Text = him.szDialogMsg, OptList = OptList};
	Dialog:Show(tbDialogInfo, me, him);

end

function tbNpc:Accept()
	if me.GetMoney("Gold") < him.nSellPrice then
		me.CenterMsg("Nguyên Bảo không đủ")
		return
	end

	local nNpcId = him.nId;
	me.CostGold(him.nSellPrice, Env.LogWay_CollectAndRobClue, him.nTemplateId, function (nPlayerId, bSucceed)
		if not bSucceed then
			return false
		end
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if not pPlayer then
			return false
		end
		local pNpc = KNpc.GetById(nNpcId)
		if not pNpc then
			pPlayer.CenterMsg("Thương nhân đã biến mất")
			return false
		end

		Activity:OnPlayerEvent(pPlayer, "Act_OnBuyFromNpc", pNpc)
	end)
end