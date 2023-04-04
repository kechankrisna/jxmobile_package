if not MODULE_GAMESERVER then
    Activity.YinXingJiQingAct = Activity.YinXingJiQingAct or {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("YinXingJiQingAct") or Activity.YinXingJiQingAct
--YXJQ:银杏寄情
--QS:情书
tbAct.QS_CONTENT_MAX_LEN = 12  --情书内容字数
tbAct.MAX_MODIFY         = 2   --每封情书修改次数
tbAct.LIKE_COUNT_PER     = 1   --每封情书点赞次数
tbAct.DAY_LIKE_COUNT_PER = 3   --每天给某个玩家总共点赞次数
tbAct.DAY_LIKE_COUNT     = 10 --每天点赞次数
tbAct.MODITY_COST        = 200 --修改情书花费的元宝
tbAct.PLAYER_LEVEL       = 20  --玩家等級
tbAct.IMITYLEVEL         = 15 --点赞亲密度等级

tbAct.MAINUI_QS_COUNT    = 12  --主UI情书数量
tbAct.QS_COUNT           = 3   --情书数量

function tbAct:CheckData(tbData)
	if tbData.nDataDay and tbData.nDataDay >= Lib:GetLocalDay() then
		return
	end
	tbData.nDataDay   = Lib:GetLocalDay()
	tbData.nLikeCount = 0
	tbData.tbLikeList = {}
	for i = 1, self.QS_COUNT do
		if tbData.tbQS and tbData.tbQS[i] then
			tbData.tbQS[i].nModifyTimes = 0
		end
	end
end

function tbAct:CheckCommit(tbData, tbQS, nPlayer, nKinId)
	if MODULE_GAMESERVER then
		if GetTime() > self.nOperationEndTime then
			return false, "Hoạt động đã kết thúc"
		end
	end
	if tbQS.nIdx <= 0 or tbQS.nIdx > self.QS_COUNT then
		return false, "Mỗi người chỉ được gửi 3 bức thư!"
	end
	if tbData.tbQS and tbData.tbQS[tbQS.nIdx] then
		return false, "Không thể gửi trùng!"
	end
	local nProfessionPlayer = tbQS.nProfessionPlayer
	if not nProfessionPlayer then
		return false, "Hãy chọn người nhận thư!"
	end
	if nProfessionPlayer == nPlayer then
		return false, "Không thể gửi cho bản thân!"
	end
	for i = 1, self.QS_COUNT do
		if tbData.tbQS and tbData.tbQS[i] and tbData.tbQS[i].nPlayer == nProfessionPlayer then
			return false, "Không thể gửi cho cùng một người chơi"
		end
	end
	if MODULE_GAMESERVER then
		local tbRoleStayInfo = KPlayer.GetRoleStayInfo(nProfessionPlayer)
		if not tbRoleStayInfo then
			return false, "Người chơi không tồn tại"
		end
		if not FriendShip:IsFriend(nPlayer, nProfessionPlayer) and
			(nKinId == 0 or tbRoleStayInfo.dwKinId ~= nKinId) then
			return false, "Người chơi này không thân"
		end
	end
	for i = 1, self.QS_COUNT do
		if Lib:IsEmptyStr(tbQS.tbContent[i]) then
			return false, "Thư chưa sửa xong"
		end
		if ReplaceLimitWords(tbQS.tbContent[i]) then
			return false, "Nội dung thư có chứa ký tự không hợp lệ"
		end
		local nContentLen = Lib:Utf8Len(tbQS.tbContent[i])
		if nContentLen > self.QS_CONTENT_MAX_LEN then
			return false, "Nội dung thư mỗi hàng tối đa 24 ký tự"
		end
	end
	return true
end

function tbAct:CheckModify(tbData, tbQS)
	if MODULE_GAMESERVER then
		if GetTime() > self.nOperationEndTime then
			return false, "Hoạt động đã kết thúc"
		end
	end
	tbData.tbQS  = tbData.tbQS or {}
	if not tbData.tbQS[tbQS.nIdx] then
		return false, "Chưa viết thư"
	end
	self:CheckData(tbData)
	if tbData.tbQS[tbQS.nIdx].nModifyTimes and tbData.tbQS[tbQS.nIdx].nModifyTimes >= self.MAX_MODIFY then
		return false, "Mỗi thư mỗi ngày chỉ được sửa 2 lần"
	end
	local bHaveChange = false
	for i = 1, self.QS_COUNT do
		if Lib:IsEmptyStr(tbQS.tbContent[i]) then
			return false, "Thư chưa sửa xong"
		end
		if ReplaceLimitWords(tbQS.tbContent[i]) then
			return false, "Nội dung thư có chứa ký tự không hợp lệ"
		end
		local nContentLen = Lib:Utf8Len(tbQS.tbContent[i])
		if nContentLen > self.QS_CONTENT_MAX_LEN then
			return false, "Nội dung thư mỗi hàng tối đa 24 ký tự"
		end
		bHaveChange = bHaveChange or tbData.tbQS[tbQS.nIdx].tbContent[i] ~= tbQS.tbContent[i]
	end
	if not bHaveChange then
		return false, "Thư chưa sửa lần nào"
	end
	return true
end

function tbAct:CheckLike(tbData, nLikePlayer, nBelonger, nIdx)
	if MODULE_GAMESERVER then
		if GetTime() > self.nOperationEndTime then
			return false, "Hoạt động đã kết thúc"
		end
	end
	if nLikePlayer == nBelonger then
		return false, "Không thể thích bản thân"
	end
	if not nBelonger or nIdx <= 0 or nIdx > self.QS_COUNT then
		return false, "Số liệu bất thường, hãy thử lại"
	end
	local nImityLevel = FriendShip:GetFriendImityLevel(nLikePlayer, nBelonger) or 0
	if nImityLevel < self.IMITYLEVEL then
		return false, string.format("Chỉ được thích hảo hữu có thân mật Lv%d trở lên", self.IMITYLEVEL)
	end

	self:CheckData(tbData)
	tbData.nLikeCount = tbData.nLikeCount or 0
	if tbData.nLikeCount >= self.DAY_LIKE_COUNT then
		return false, "Mỗi người mỗi ngày chỉ được thích người khác [FFFE0D]10 lần[-]"
	end
	tbData.tbLikeList = tbData.tbLikeList or {}
	tbData.tbLikeList[nBelonger] = tbData.tbLikeList[nBelonger] or {nCount = 0, tbIdxCount = {}}
	if tbData.tbLikeList[nBelonger].nCount >= self.DAY_LIKE_COUNT_PER then
		return false, "Mỗi ngày chỉ được thích cùng 1 người chơi [FFFE0D]3 lần[-]"
	end
	tbData.tbLikeList[nBelonger].tbIdxCount[nIdx] = tbData.tbLikeList[nBelonger].tbIdxCount[nIdx] or 0
	if tbData.tbLikeList[nBelonger].tbIdxCount[nIdx] >= self.LIKE_COUNT_PER then
		return false, "Mỗi ngày chỉ được thích cùng 1 thư [FFFE0D]1 lần[-]"
	end
	return true
end

if MODULE_GAMESERVER then return end

function tbAct:OnSyncMyData(tbData)
	self.tbMyData       = tbData or {}
	self.tbPlayerQS     = {}
	self.tbFriendQSList = {}
	self.nRequestTime   = 0
end

tbAct.tbPlayerQS = tbAct.tbPlayerQS or {}
tbAct.tbReadCd = tbAct.tbReadCd or {}
function tbAct:OnReadRsp(nPlayer, tbData, nIdx)
	if not tbData then
		me.CenterMsg("Không tìm thấy thư của người chơi này")
		return
	end
	if not self.tbPlayerQS[nPlayer] then
		self.tbPlayerQS[nPlayer] = tbData
	else
		self.tbPlayerQS[nPlayer].szName = tbData.szName
		self.tbPlayerQS[nPlayer].tbQS = self.tbPlayerQS[nPlayer].tbQS or {}
		for i = 1, self.QS_COUNT do
			self.tbPlayerQS[nPlayer].tbQS[i] = tbData.tbQS[i] or self.tbPlayerQS[nPlayer].tbQS[i]
		end
	end
	Ui:OpenWindow("YXJQ_PlayerQS", nPlayer, nIdx)
end

function tbAct:OpenQS(nPlayer, nIdx)
	if nPlayer == me.dwID then
		Ui:OpenWindow("YXJQ_PlayerQS", nPlayer, nIdx)
		return
	end

	local tbVersion = nil
	if self.tbPlayerQS[nPlayer] then
		self.tbReadCd[nPlayer] = self.tbReadCd[nPlayer] or 0
		if GetTime() - self.tbReadCd[nPlayer] < 5 then
			Ui:OpenWindow("YXJQ_PlayerQS", nPlayer, nIdx)
			return
		end
		self.tbReadCd[nPlayer] = GetTime()
		tbVersion  = {}
		local tbQS = (self.tbPlayerQS[nPlayer] or {}).tbQS or {}
		for i = 1, self.QS_COUNT do
			tbVersion[i] = tbQS[i] and tbQS[i].nVersion or nil
		end
	end
	RemoteServer.YinXingJiQingClientCall("Read", nPlayer, tbVersion, nIdx or 1)
end

function tbAct:GetPlayerData(nPlayer)
	if nPlayer == me.dwID then
		self.tbMyData = self.tbMyData or {}
		self.tbMyData.tbQS = self.tbMyData.tbQS or {}
		return self.tbMyData
	else
		return self.tbPlayerQS[nPlayer]
	end
end

function tbAct:GetFriendQSList()
	self.tbFriendQSList = self.tbFriendQSList or {}
	local nCD = #self.tbFriendQSList < self.MAINUI_QS_COUNT and 60*3 or 60*60*2
	if not self.nRequestTime or (GetTime() - self.nRequestTime) >= nCD then
		self.nRequestTime = GetTime()
		RemoteServer.YinXingJiQingClientCall("ReqQSList")
	end
	return self.tbFriendQSList
end

function tbAct:Commit(tbQSData, bConfirm)
	local tbData      = self:GetPlayerData(me.dwID)
	local bExist      = tbData.tbQS[tbQSData.nIdx]
	local szCheckFunc = bExist and "CheckModify" or "CheckCommit"
	local szType      = bExist and "Modify" or "Commit"
	local bRet, szMsg = self[szCheckFunc](self, tbData, tbQSData, me.dwID, me.dwKinId)
	if not bRet then
		me.CenterMsg(szMsg)
		return
	end
	if not bConfirm then
		local szMsg = szType == "Commit" and
			string.format("Mỗi thư gửi lần đầu sẽ miễn phí, sửa và gửi ở các lần sau sẽ tốn %d Nguyên Bảo, đồng ý gửi?", self.MODITY_COST)
			or string.format("Sửa và gửi cần tốn [FFFE0D]%d Nguyên Bảo[-], đồng ý gửi? Đóng giao diện Thư có thể hủy sửa", self.MODITY_COST)
		me.MsgBox(szMsg,
			{{"Xác nhận", Activity.YinXingJiQingAct.Commit, Activity.YinXingJiQingAct, tbQSData, true}, {"Hủy"}})
		return
	end
	if szType == "Modify" and me.GetMoney("Gold") < self.MODITY_COST then
		me.CenterMsg("Nguyên Bảo không đủ! Hãy nạp thẻ trước")
		Ui:OpenWindow("CommonShop", "Recharge", "Recharge")
		return
	end
	RemoteServer.YinXingJiQingClientCall(szType, tbQSData)
end

function tbAct:OnCommitCallBack(nIdx, tbQS)
	local tbData = self:GetPlayerData(me.dwID)
	local szMsg  = tbData.tbQS[nIdx] and "Sửa thành công" or "Đã nộp"
	tbData.tbQS[nIdx] = tbQS
	UiNotify.OnNotify(UiNotify.emNOTIFY_SYNC_YXJQ_DATA)
	me.CenterMsg(szMsg)
end

function tbAct:Like(nPlayerId, nQSIdx)
	local tbData = self:GetPlayerData(me.dwID)
	local bRet, szMsg = self:CheckLike(tbData, me.dwID, nPlayerId, nQSIdx)
	if not bRet then
		me.CenterMsg(szMsg)
		return
	end
	RemoteServer.YinXingJiQingClientCall("Like", nPlayerId, nQSIdx)
end

function tbAct:OnLikeCallBack(nBelonger, nIdx)
	local tbData = self:GetPlayerData(me.dwID)
	tbData.nLikeCount = (tbData.nLikeCount or 0) + 1
	tbData.tbLikeList = tbData.tbLikeList or {}
	tbData.tbLikeList[nBelonger] = tbData.tbLikeList[nBelonger] or {nCount = 0, tbIdxCount = {}}
	tbData.tbLikeList[nBelonger].nCount = tbData.tbLikeList[nBelonger].nCount + 1
	tbData.tbLikeList[nBelonger].tbIdxCount[nIdx] = (tbData.tbLikeList[nBelonger].tbIdxCount[nIdx] or 0) + 1

	local tbBelong = self:GetPlayerData(nBelonger)
	if tbBelong and tbBelong.tbQS and tbBelong.tbQS[nIdx] then
		tbBelong.tbQS[nIdx].nLikeCount = (tbBelong.tbQS[nIdx].nLikeCount or 0) + 1
	end
	UiNotify.OnNotify(UiNotify.emNOTIFY_SYNC_YXJQ_DATA)
	me.CenterMsg("Thích thành công")
end

function tbAct:OnBeLikeCallBack(nIdx, nLikeCount)
	if not self.tbMyData or not self.tbMyData.tbQS or not self.tbMyData.tbQS[nIdx] then
		return
	end
	self.tbMyData.tbQS[nIdx].nLikeCount = nLikeCount
end

function tbAct:OnSyncQSList(tbQSList)
	self.tbFriendQSList = tbQSList or {}
	UiNotify.OnNotify(UiNotify.emNOTIFY_SYNC_YXJQ_DATA, 1)
end