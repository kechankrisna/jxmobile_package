local tbNpc = Npc:GetClass("GoodVoiceStatue")
local tbAct = MODULE_GAMESERVER and Activity:GetClass("GoodVoice") or Activity.GoodVoice


function tbNpc:OnDialog()
	if not him.tbWinnerInfo or not him.tbStatueInfo then
		return
	end

	local OptList = {
		{Text = "Thông tin", Callback = self.OpenPlayerUrl, Param = {self, him.nId}},
		{Text = "Để sau"},
	};

	local szDefaultText = self:GetDefaultTxt(him)

	if self:CheckStatueOwner(me, him) then
		table.insert(OptList, 1, {Text = "Thay đổi hình tượng", Callback = self.UpdateStatue, Param = {self, him.nId}})
	end

	local tbDialogInfo = {Text = szDefaultText, OptList = OptList};
	Dialog:Show(tbDialogInfo, me, him);
end

function tbNpc:GetDefaultTxt(pNpc)
	local tbDefaultTxt = 
		{
			[tbAct.WINNER_TYPE.FINAL_1] = "[FF69B4]「Giọng Ca Số 1 Võ Lâm」[-] %s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.FINAL_2] = "[FF69B4]「Đệ Nhị Hảo Thanh Võ Lâm」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.FINAL_3] = "[FF69B4]「Đệ Tam Hảo Thanh Võ Lâm」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_1] = "[FF69B4]「Đệ Nhất Hảo Thanh Vòng Chung Kết」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_1_1] = "[FF69B4]「Hoa Đông Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_2_1] = "[FF69B4]「Hoa Nam Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_3_1] = "[FF69B4]「Hoa Trung Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_4_1] = "[FF69B4]「Hoa Bắc Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_5_1] = "[FF69B4]「Tây Bắc Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_6_1] = "[FF69B4]「Tây Nam Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_7_1] = "[FF69B4]「Đông Bắc Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_AREA_8_1] = "[FF69B4]「Hương Cảng Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_1_1] = "[FF69B4]「Thiên Vương Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_2_1] = "[FF69B4]「Nga Mi Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_3_1] = "[FF69B4]「Đào Hoa Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_4_1] = "[FF69B4]「Tiêu Dao Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_5_1] = "[FF69B4]「Võ Đang Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_6_1] = "[FF69B4]「Thiên Nhẫn Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_7_1] = "[FF69B4]「Thiếu Lâm Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_8_1] = "[FF69B4]「Thúy Yên Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_9_1] = "[FF69B4]「Đường Môn Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_10_1] = "[FF69B4]「Côn Lôn Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_11_1] = "[FF69B4]「Cái Bang Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_12_1] = "[FF69B4]「Ngũ Độc Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_13_1] = "[FF69B4]「Tàng Kiếm Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_14_1] = "[FF69B4]「Trường Ca Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_15_1] = "[FF69B4]「Thiên Sơn Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.SEMI_FINAL_FACTION_16_1] = "[FF69B4]「Bá Đao Cường Thanh」[-]%s\nĐến từ: [FFFE0D]%s[-]";
			[tbAct.WINNER_TYPE.LOCAL_1] = "[FF69B4]「Giọng Ca Số 1 Server」[-] %s";
		}
	local szDefaultText = tbDefaultTxt[pNpc.tbWinnerInfo.nWinnerType] or "[FF69B4]「Giọng Ca Số 1」[-]%s"
	return string.format(szDefaultText, pNpc.tbWinnerInfo.szPlayerName, pNpc.tbWinnerInfo.szServerName )
end

-- 是否是跨多服务器的雕像类型（就是别的服务器也有立雕像，本服好声音只有本服才有雕像）
function tbNpc:IsCrossType(nWinnerType)
	if nWinnerType ~= tbAct.WINNER_TYPE.LOCAL_1 then
		return true
	end
	return false
end

function tbNpc:CheckStatueOwner(pPlayer, pNpc)
	if not pPlayer or not pNpc then
		return false
	end

	if not pNpc.tbWinnerInfo or not pNpc.tbStatueInfo then
		return false
	end

	if self:IsCrossType(pNpc.tbWinnerInfo.nWinnerType) and
	 pPlayer.dwID == pNpc.tbWinnerInfo.nPlayerId and
	 math.floor(pNpc.tbWinnerInfo.nServerId/10000) == math.floor(GetServerIdentity()/10000)  then

	 	return true
	 -- 本服雕像只判断玩家id
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
	me.CallClientScript("Ui.HyperTextHandle:Handle", string.format(tbAct:GetPlayerPage(pNpc.tbWinnerInfo.nPlayerId, pNpc.tbWinnerInfo.szAccount)));
end

function tbNpc:UpdateStatue(nNpcId)
	local pNpc = KNpc.GetById(nNpcId)
	if not pNpc or not pNpc.tbWinnerInfo or not pNpc.tbStatueInfo then
		return
	end

	if not self:CheckStatueOwner(me, pNpc) then
		return
	end

	tbAct:UpdateStatueInfo(me, pNpc.tbWinnerInfo.nWinnerType, pNpc.tbWinnerInfo.nRank)
end
