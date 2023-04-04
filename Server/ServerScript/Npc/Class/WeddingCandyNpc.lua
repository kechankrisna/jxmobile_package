local tbNpc = Npc:GetClass("WeddingCandyNpc");
function tbNpc:OnDialog()
	local tbInst = Fuben.tbFubenInstance[me.nMapId];
	if tbInst then
		tbInst.tbCandyAwardTimes[me.dwID] = tbInst.tbCandyAwardTimes[me.dwID] or 0
		if tbInst.tbCandyAwardTimes[me.dwID] >= tbInst.nMaxCandyAwardTimes then
			me.CenterMsg("Bánh kẹo cưới đang chia sẻ, ngày hôm nay ngươi đã nhặt đủ rồi")
			return 
		end
	end
	GeneralProcess:StartProcessExt(me, Wedding.nCandyWaitTime * Env.GAME_FPS, true, 0, 0, "Đang nhặt", {self.OnEndProgress, self, me.dwID, him.nId}, {self.OnBreakProgress, self, me.dwID, him.nId});
end

function tbNpc:OnEndProgress(dwID, nNpcId)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
		return
	end
	local pNpc = KNpc.GetById(nNpcId);
	if not pNpc then
		pPlayer.CenterMsg("Đã bị người khác nhặt", true)
		return;
	end
	local tbTmp = pNpc.tbTmp or {}
	local tbPlayer = tbTmp.tbRole
	local szType = tbTmp.szType
	if not tbPlayer then
		pPlayer.CenterMsg("Ai ném bánh kẹo cưới?", true)
		return
	end
	local tbAward
	local nAwrdTimes 
	if szType == Wedding.szFubenCandy then
		local tbInst = Fuben.tbFubenInstance[pNpc.nMapId];
		tbAward = tbInst and tbInst.tbCandySetting.tbAward
		if tbAward then
			tbInst.tbCandyAwardTimes[dwID] = tbInst.tbCandyAwardTimes[dwID] or 0
			if tbInst.tbCandyAwardTimes[dwID] >= tbInst.nMaxCandyAwardTimes then
				pPlayer.CenterMsg("Bánh kẹo cưới đang chia sẻ, ngày hôm nay ngươi đã nhặt đủ rồi")
				return 
			end
			tbInst.tbCandyAwardTimes[dwID] = tbInst.tbCandyAwardTimes[dwID] + 1
			nAwrdTimes = tbInst.tbCandyAwardTimes[dwID]
			pPlayer.SendAward(tbAward, true, true, Env.LogWay_Wedding)
		end
	-- 游城喜糖不限次数
	elseif szType == Wedding.szTourCandy then
		tbAward = Wedding.tbCandyTourAward
		pPlayer.SendAward(tbAward, true, true, Env.LogWay_Wedding)
	end
	if tbAward then
		pNpc.Delete()
		Log("WeddingCandyNpc Award ok ", pPlayer.dwID, pPlayer.szName, szType, nAwrdTimes or -1)
	else
		Log("WeddingCandyNpc Award no ", pPlayer.dwID, pPlayer.szName, szType, nAwrdTimes or -1)
	end
end

function tbNpc:OnBreakProgress(nPlayerId, nNpcId)

end