local tbNpc = Npc:GetClass("FactionAwardBox")

function tbNpc:OnCreate(szParam)
	Timer:Register(Env.GAME_FPS * FactionBattle.BOX_EXSIT_TIME, self.TimeUp, self, him.nId);
end

function tbNpc:OnDialog()
	if FactionBattle:GetBoxAwardCount(me.dwID) >= FactionBattle.BOX_MAX_GET  then
		Dialog:SendBlackBoardMsg(me, string.format(XT("Thi Đấu Môn Phái lần này mỗi người chỉ mở được %s rương"), FactionBattle.BOX_MAX_GET));
		return;
	end
	GeneralProcess:StartProcess(me, FactionBattle.PICK_BOX_TIME * Env.GAME_FPS, "Đang mở...", self.EndProcess, self, me.dwID, him.nId);
end

function tbNpc:EndProcess(nPlayerId, nNpcId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if not pPlayer then
		return;
	end

	local pNpc = KNpc.GetById(nNpcId);

	if not pNpc then
		return;
	end

	if FactionBattle:GetBoxAwardCount(pPlayer.dwID) >= FactionBattle.BOX_MAX_GET  then
		return;
	end

	if not MODULE_ZONESERVER then
		local nAwardId = FactionBattle:GetBoxAwardId()
		if nAwardId then
			local nRet, szMsg, tbAward = Item:GetClass("RandomItem"):RandomItemAward(pPlayer, nAwardId, "FactionBattleBox");
			if nRet == 1 then
				FactionBattle:AddBoxAwardRecord(pPlayer.dwID);
				pPlayer.SendAward(tbAward, true, false, Env.LogWay_FactionBattleBox);
				pNpc.Delete();
			end
		end

	else
		pPlayer.CenterMsg("Mở thành công phần thưởng sẽ gửi vào thư khi kết thúc!")
		FactionBattle:AddBoxAwardRecord(pPlayer.dwID, pPlayer.nZoneServerId, pPlayer.dwOrgPlayerId);
		pNpc.Delete();
	end
end

function tbNpc:TimeUp(nNpcId)
	local pNpc = KNpc.GetById(nNpcId);

	if not pNpc then
		return;
	end

	pNpc.Delete();
end