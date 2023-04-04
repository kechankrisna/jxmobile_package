local tbItem = Item:GetClass("WeddingPromiseItem")
tbItem.nItemTId = 9429
function tbItem:OnUse(it)
	local bRet, szMsg = self:CheckAlter(me)
	if not bRet then
		me.CenterMsg(szMsg, true)
		return
	end
	me.CallClientScript("Item:GetClass('WeddingPromiseItem'):OnUsePromiseItem")
end

function tbItem:OnUsePromiseItem()
	Ui:OpenWindow("WeddingSendPromisePanel", nil, true)
	Ui:CloseWindow("ItemBox")
end

function tbItem:GetWeddingPaperItem(pPlayer)
	local nCount, tbDanItem = pPlayer.GetItemCountInBags(Wedding.nMarriagePaperId);
	return tbDanItem and tbDanItem[1]
end

function tbItem:CheckAlter(pPlayer, bNotCheckArea)
	if not bNotCheckArea then
		if not Fuben.tbSafeMap[pPlayer.nMapTemplateId] and Map:GetClassDesc(pPlayer.nMapTemplateId) ~= "fight"  then
			return false, "Không thể dùng ở bản đồ hiện tại, hãy về Thành Chính rồi dùng!"
		end

		if Map:GetClassDesc(pPlayer.nMapTemplateId) == "fight" and pPlayer.nFightMode ~= 0 then
			return false, "Hãy về khu an toàn rồi dùng!"
		end
	end
	local nLoverId = Wedding:GetLover(pPlayer.dwID);
	if not nLoverId then
		return false, "Không trong trạng thái kết hôn!"
	end
	local pItem = self:GetWeddingPaperItem(pPlayer)
	if not pItem then
		return false, "Trong hành trang không có Giấy Kết Hôn!"
	end
	return true, "", pItem, nLoverId
end

function tbItem:AlterWeddingPromise(pPlayer, szPromise)
	local bRet, szMsg, pItem, nLoverId = self:CheckAlter(pPlayer) 
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return
	end
	local bRet, szMsg = Wedding:CheckPromiseValid(szPromise)
	if not bRet then
		pPlayer.CenterMsg(szMsg, true)
		return
	end
	local nHaveNum = pPlayer.GetItemCountInAllPos(self.nItemTId)
	if nHaveNum < 1 then
		pPlayer.CenterMsg("Không có「Bút Nguyệt Lão」, không thể sửa lời hứa", true)
		return 
	end
	local nConsume = pPlayer.ConsumeItemInAllPos(self.nItemTId, 1, Env.LogWay_AlterWeddingPromise);
	if nConsume < 1 then
		pPlayer.CenterMsg("Trừ đạo cụ thất bại", true)
		return 
	end
	local nSex = pPlayer.GetUserValue(Wedding.nSaveGrp, Wedding.nSaveKeyGender)
	if nSex == Player.SEX_MALE then
		pItem.SetStrValue(Wedding.nMPHusbandPledgeIdx, szPromise)
	else
		pItem.SetStrValue(Wedding.nMPWifePledgeIdx, szPromise)
	end
	local pLover = KPlayer.GetPlayerObjById(nLoverId)
	if pLover then
		self:AlterLoverWeddingPromise(pLover, szPromise, pPlayer.dwID, nSex)
	else
		local szLog = string.format("%s|%s|%s|%s", "AlterWeddingPromise", szPromise, pPlayer.dwID, nSex or -1)
		local szCmd = string.format("Item:GetClass('WeddingPromiseItem'):AlterLoverWeddingPromise(me, '%s', %d, %d)", szPromise, pPlayer.dwID, nSex)
		KPlayer.AddDelayCmd(nLoverId, szCmd, szLog);
	end
	pPlayer.CenterMsg("Lời hứa đã được sửa", true)
	pPlayer.CallClientScript("Item:GetClass('WeddingPromiseItem'):OnAlterPromise")

	local tbMail = {Title = "Thông báo sửa lời hứa kết hôn", From = "Nguyệt Lão", nLogReazon = Env.LogWay_AlterWeddingPromise, Text = string.format("  Bạn đời của bạn đã sửa lời hứa kết hôn thành「%s」.", szPromise), To = nLoverId}
	Mail:SendSystemMail(tbMail)
	Log("[WeddingPromiseItem] fnAlterWeddingPromise ok", pPlayer.dwID, pPlayer.szName, nLoverId, nSex, szPromise, pLover and "OnLine" or "Delay")
end

function tbItem:AlterLoverWeddingPromise(pPlayer, szPromise, nAlterPlayerId, nAlterPlayerSex)
	local bRet, szMsg, pItem, nLoverId = self:CheckAlter(pPlayer, true) 
	if not bRet then
		Log("[WeddingPromiseItem] fnAlterLoverWeddingPromise Check Valid", pPlayer.dwID, pPlayer.szName, nLoverId or -1, szMsg, szPromise, nAlterPlayerId, nAlterPlayerSex, pItem and 1 or 0)
		return
	end
	if not nLoverId or nLoverId ~= nAlterPlayerId then
		Log("[WeddingPromiseItem] fnAlterLoverWeddingPromise Error Param", nLoverId or -1, pPlayer.dwID, pPlayer.szName, szMsg, nAlterPlayerId, nAlterPlayerSex)
		return
	end
	if nAlterPlayerSex == Player.SEX_MALE then
		pItem.SetStrValue(Wedding.nMPHusbandPledgeIdx, szPromise)
	else
		pItem.SetStrValue(Wedding.nMPWifePledgeIdx, szPromise)
	end
	Log("[WeddingPromiseItem] fnAlterLoverWeddingPromise ok", pPlayer.dwID, pPlayer.szName, nLoverId, nAlterPlayerId, nAlterPlayerSex, szPromise)
end

function tbItem:OnAlterPromise()
	Wedding:TryDestroyUi("WeddingSendPromisePanel")
end
