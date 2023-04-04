local tbNpc = Npc:GetClass("BeautyPageantStatue")
local tbAct = MODULE_GAMESERVER and Activity:GetClass("BeautyPageant") or Activity.BeautyPageant

function tbNpc:OnDialog()
	if not him.tbWinnerInfo or not him.tbStatueInfo then
		return
	end

	local OptList = {
		{Text = "Thông tin", Callback = self.OpenPlayerUrl, Param = {self, him.nId}},
		{Text = "Để sau"},
	};

	local bOwner = false

	local szDefaultText = ""
	if him.tbWinnerInfo.nWinnerType == tbAct.WINNER_TYPE.FINAL_1 then
		szDefaultText = string.format("[FF69B4]「Võ Lâm Đệ Nhất Mỹ Nhân」[-]%s\nĐến từ: [FFFE0D]%s[-]", him.tbWinnerInfo.szPlayerName, him.tbWinnerInfo.szServerName);
		if me.dwID == him.tbWinnerInfo.nPlayerId and math.floor(him.tbWinnerInfo.nServerId/10000) == math.floor(GetServerIdentity()/10000) then
			--考虑到合服，这里需要判断是同一个大区就行
			bOwner = true;
		end 
	else
		szDefaultText = string.format("[FF69B4]「Đệ Nhất Mỹ Nhân Server」[-]%s", him.tbWinnerInfo.szPlayerName);
		if me.dwID == him.tbWinnerInfo.nPlayerId then
			bOwner = true;
		end
	end

	if self:CheckStatueOwner(me, him) then
		table.insert(OptList, 1, {Text = "Thay đổi hình tượng", Callback = self.UpdateStatue, Param = {self, him.nId}})
	end

	local tbDialogInfo = {Text = szDefaultText, OptList = OptList};
	Dialog:Show(tbDialogInfo, me, him);
end

function tbNpc:CheckStatueOwner(pPlayer, pNpc)
	if not pPlayer or not pNpc then
		return false
	end

	if not pNpc.tbWinnerInfo or not pNpc.tbStatueInfo then
		return false
	end

	if pNpc.tbWinnerInfo.nWinnerType == tbAct.WINNER_TYPE.FINAL_1 and
	 pPlayer.dwID == pNpc.tbWinnerInfo.nPlayerId and
	 math.floor(pNpc.tbWinnerInfo.nServerId/10000) == math.floor(GetServerIdentity()/10000)  then

	 	return true
	 elseif pPlayer.dwID == him.tbWinnerInfo.nPlayerId then
	 	return true
	end

	return false
end

function tbNpc:OpenPlayerUrl(nNpcId)
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc or not pNpc.tbWinnerInfo or not pNpc.tbStatueInfo then
		return
	end
	me.CallClientScript("Ui.HyperTextHandle:Handle", string.format("[url=openBeautyUrl:PlayerPage, %s][-]", string.format(tbAct:GetPlayerUrl(), pNpc.tbWinnerInfo.nPlayerId, pNpc.tbWinnerInfo.nServerId)));
end

function tbNpc:UpdateStatue(nNpcId)
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc or not pNpc.tbWinnerInfo or not pNpc.tbStatueInfo then
		return
	end

	if not self:CheckStatueOwner(me, pNpc) then
		return
	end

	tbAct:UpdateStatueInfo(me, pNpc.tbWinnerInfo.nWinnerType)
end
