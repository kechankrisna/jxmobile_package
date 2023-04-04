local tbNpc = Npc:GetClass("PartnerCardHouseNpc");

function tbNpc:OnGeneralDialog()
	local szType = him.szType
	local nNowTime = GetTime()
	local nMyId = me.dwID
	local nCardId = him.nCardId or 0
	local tbOptList = {}
	if szType == PartnerCard.NPC_TYPE_VISIT then
		if not him.nResult and nMyId == him.nQuesionPlayerId and (him.nVisitTime and nNowTime - him.nVisitTime < PartnerCard.CARD_ACT_ACTIVE_TIME) and him.nVisitPlayerId then
			table.insert(tbOptList, { Text = "Trả lời vấn đề", Callback = self.VisitQuestion, Param = {self, me.dwID, nCardId, him.nQuestionId, him.nVisitPlayerId, him.tbAnswer} })
		end
	elseif szType == PartnerCard.NPC_TYPE_LIVE then
		local nOwnPlayerId = him.nOwnPlayerId or 0
		if nOwnPlayerId == me.dwID then
			local bRet, szMsg = PartnerCard:CheckAcceptTask(me, nCardId)
			if bRet then
				table.insert(tbOptList, { Text = "Nhận nhiệm vụ", Callback = self.AcceptTask, Param = {self, me.dwID, nCardId} })
			end
		end
		if PartnerCard:IsActing(nOwnPlayerId, nCardId, PartnerCard.CARD_ACT_STATE_MUSE) then
			local bRet = PartnerCard:CheckIsDevil(nOwnPlayerId, nCardId)
			if bRet then
				table.insert(tbOptList, { Text = "Chế Phục Tâm Ma", Callback = self.CureDevil, Param = {self, me.dwID, nOwnPlayerId,nCardId} })
			end
		end
	elseif szType == PartnerCard.NPC_TYPE_TRIP_MAP then
		local nOwnPlayerId = him.nOwnPlayerId or 0
		self:TryTalkTripMapNpc(me, him, nOwnPlayerId, nCardId)
		return
	elseif szType == PartnerCard.NPC_TYPE_TRIP_FUBEN then
		return
	end
	 Dialog:Show(
    {
        Text    = "Nơi đây chim hót hoa nở, sáng sủa sạch sẽ, thật khiến cho người ta lưu luyến quên về. Ngài tìm ta có chuyện gì không?",
        OptList = tbOptList,
    }, me, him);
end 

function tbNpc:TryTalkTripMapNpc(pPlayer, pNpc, nOwnPlayerId, nCardId)
	if pPlayer.dwID ~= nOwnPlayerId then
		Dialog:Show(
	    {
	        Text    = "Nơi đây hung hiểm vạn phần, các ngươi muốn lượng sức mà đi, nếu có ứng phó không được tình huống, kịp thời trở về.",
	        OptList = {};
	    }, pPlayer, pNpc);
		return
	end
	local tbCardInfo = PartnerCard:GetCardInfo(nCardId)
	if not tbCardInfo then
		pPlayer.CenterMsg("Môn khách không biết", true)
		return
	end
	if him.bGetAward or not tbCardInfo.nDialogId then
		Dialog:Show(
	    {
	        Text    = "Ta ở phương này một lúc, chủ nhân không cần quản ta, đợi về đến nhà, chúng ta lại cầm đuốc soi dạ đàm, chủ nhân hết thảy cẩn thận",
	        OptList = {};
	    }, pPlayer, pNpc);
	    return
	end

	pPlayer.CallClientScript("PartnerCard:PlayTripMapNpcDialog", tbCardInfo.nDialogId, nCardId, pNpc.nId);
end

function tbNpc:AcceptTask(nPlayerId, nCardId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
       return 
	end
	local bRet, szMsg = PartnerCard:CheckAcceptTask(pPlayer, nCardId)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return 
	end
	local fnAgree = function (nPlayerId, nCardId)
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
		if not pPlayer then
           return
		end
		PartnerCard:AcceptTask(pPlayer, nCardId)
	end
	 pPlayer.MsgBox(string.format("Hoàn thành môn khách nhiệm vụ sẽ tăng môn khách [FFFE0D]độ thân thiện[-], [FFFE0D]mỗi ngày chỉ có thể nhận 1 nhiệm vụ môn khách[-], xác nhận?\n(Nhiệm vụ chung [FFFE0D]5[-] vòng)"), {{"Đồng ý", fnAgree, nPlayerId, nCardId}, {"Hủy bỏ"}}, nil, nil, fnClose)
	
end

function tbNpc:VisitQuestion(nPlayerId, nCardId, nQuestionId, nVisitPlayerId, tbAnswer)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
		return 	         
	end
	pPlayer.CallClientScript("Ui:OpenWindow", "PartnerCardQuestionPanel", PartnerCard.TYPE_ANSWER, nCardId, nQuestionId, nVisitPlayerId, tbAnswer)
end

function tbNpc:CureDevil(nPlayerId, nOwnPlayerId, nCardId)
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId)
	if not pPlayer then
       return 
	end
	local tbDevilInfo = PartnerCard:GetDevilCardInfo(nOwnPlayerId, nCardId)
	local nOwnKinId = tbDevilInfo.nKinId or 0
	if nOwnKinId == me.dwKinId and nOwnKinId ~= 0 then
		pPlayer.CallClientScript("Ui:OpenWindow", "PartnerCardDevilPanel", nOwnPlayerId, nCardId)
	else
		if pPlayer.dwID == nOwnPlayerId then
			pPlayer.CenterMsg("Ngươi rời khỏi bang trước kia, không thể hiệp trợ", true)
		else
			pPlayer.CenterMsg("Ngươi và môn khách chủ nhân không phải cùng một bang, không thể hiệp trợ", true)
		end
		
	end
end