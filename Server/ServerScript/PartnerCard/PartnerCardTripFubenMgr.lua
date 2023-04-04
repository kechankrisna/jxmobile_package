-- 游历副本
PartnerCard.tbTripFuben = PartnerCard.tbTripFuben or {}
local tbTripFuben = PartnerCard.tbTripFuben
tbTripFuben.nMapTemplateId = 8008
tbTripFuben.szFubenBase = "PartnerCardTripFuben"
tbTripFuben.nMaxPlayerNum = 4; --最大四人队
--击杀小怪获得的奖励银两范围
tbTripFuben.tbNpcKillAward = {
	50, 100
}
tbTripFuben.tbGateAward = {{"Coin", 50000},{"BasicExp", 40}}; --开门奖励
tbTripFuben.nReviveTime = 10 ; --10s倒计时复活

function tbTripFuben:CreateFuben(pPlayer, nCardId)
	local nPlayerId = pPlayer.dwID
	local fnSucess = function (nMapId)
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if not pPlayer then
			return
		end
		if pPlayer.dwTeamID ~= 0 then
			TeamMgr:QuiteTeam(pPlayer.dwTeamID, pPlayer.dwID);
		end
		pPlayer.SwitchMap(nMapId, 0, 0);
	end
	local fnFail = function ()
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if not pPlayer then
			return
		end
		pPlayer.CenterMsg("Tạo phó bản thất bại, xin thử lại!")
	end
	Fuben:ApplyFuben(pPlayer.dwID, self.nMapTemplateId, fnSucess, fnFail, pPlayer.dwID, nCardId);
end

function tbTripFuben:InvitePlayer(pPlayer, dwRoleId)
	
	local pPlayer2 = KPlayer.GetPlayerObjById(dwRoleId)
	if not pPlayer2 then
		pPlayer.CenterMsg("Đối phương chưa online", true)
		return
	end
	--邀请者需要在副本的准备阶段
	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst or not tbInst.bCanInvite then
		pPlayer.CenterMsg("Chỉ có tại chuẩn bị giai đoạn mới có thể mời", true)
		return
	end
	if tbInst.dwOwnerId ~= pPlayer.dwID then
		pPlayer.CenterMsg("Chỉ có môn khách chủ nhân mới có thể mời", true)
		return
	end
	if tbInst.nPlayerCount >= self.nMaxPlayerNum then
		pPlayer.CenterMsg("Hiện tại phó bản số người đã đủ", true)
		pPlayer.CallClientScript("Ui:CloseWindow", "DungeonInviteList")
		return
	end
	local tbData = {
		szType = "InviteTripFuben",
		nTimeOut = tbInst.nReadyEndTime, --消息超时时间
		szInviteName = pPlayer.szName,
		dwInviteRoleId = pPlayer.dwID,
	}
	pPlayer2.CallClientScript("Ui:SynNotifyMsg", tbData)
	return true, "Thành công gửi đi mời"
end

function tbTripFuben:InviteApply(pPlayer, dwOwnerId)
	local pOwner = KPlayer.GetPlayerObjById(dwOwnerId)
	if not pOwner then
		pPlayer.CenterMsg("Người mời hiện không online")
		return
	end
	local tbInst = Fuben.tbFubenInstance[pOwner.nMapId]
	if not tbInst or not tbInst.bCanInvite then
		pPlayer.CenterMsg("Mời đã hết hạn, hiệp trợ phó bản đã kết thúc")
		return
	end
	if tbInst.dwOwnerId ~= dwOwnerId then
		pPlayer.CenterMsg("Vô hiệu mời")
	end
	if tbInst.nPlayerCount >= self.nMaxPlayerNum then
		pPlayer.CenterMsg("Hiệp trợ phó bản số người đã đủ")
		return
	end
	local bRet, szMsg = TeamMgr:DirectAddMember(dwOwnerId, pPlayer)
	if not bRet then
		pPlayer.CenterMsg(szMsg)
		return
	end
	tbInst.nPlayerCount = tbInst.nPlayerCount + 1; --如放在进入副本的话会延迟一帧
	pPlayer.SetEntryPoint();
	pPlayer.SwitchMap(pOwner.nMapId, 0, 0);
end

function tbTripFuben:RandomInvite(pPlayer)
	--邀请者需要在副本的准备阶段
	local tbInst = Fuben.tbFubenInstance[pPlayer.nMapId]
	if not tbInst or not tbInst.bCanInvite then
		pPlayer.CenterMsg("Chỉ có tại hiệp trợ phó bản chuẩn bị giai đoạn mới có thể mời")
		return 
	end

	if tbInst.dwOwnerId ~= pPlayer.dwID then
		pPlayer.CenterMsg("Chỉ có hiệp trợ phó bản người thành lập mới có thể mời")
		return 
	end

	if tbInst.nPlayerCount >= self.nMaxPlayerNum then
		pPlayer.CallClientScript("Ui:CloseWindow", "DungeonInviteList")
		pPlayer.CenterMsg("Hiện tại hiệp trợ phó bản số người đã đủ")
		return
	end

	local tbData = {
		szType = "InviteTripFuben",
		nTimeOut = tbInst.nReadyEndTime, --消息超时时间
		szInviteName = pPlayer.szName,
		dwInviteRoleId = pPlayer.dwID,
	}

	local tbStranger = KPlayer.GetStranger(pPlayer.dwID, 20, 1);
	for i, v in ipairs(tbStranger) do
		local pTar = v.pPlayer
		if pTar then
			pTar.CallClientScript("Ui:SynNotifyMsg", tbData)
		end
	end

	pPlayer.CenterMsg("Đã hướng trong chốn võ lâm hiệp sĩ tuyên bố chiêu mộ văn kiện, mời chậm đợi hồi âm")
end