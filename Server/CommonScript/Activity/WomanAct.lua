if not MODULE_GAMESERVER then
    Activity.WomanAct = Activity.WomanAct or {}
    Activity.WomanAct.tbLabelInfo = Activity.WomanAct.tbLabelInfo or {}
    Activity.WomanAct.tbPlayerRequestCD = {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("WomanAct") or Activity.WomanAct
tbAct.bTSMode = false 		-- 是否是师徒关系模式（否则是女神模式）
tbAct.szActDes = tbAct.bTSMode and "Chúc Phúc" or "Ấn tượng"
-- 赠送需达到的亲密度等级
tbAct.nImityLevel = 5
-- 付费标签价格
tbAct.nPayLabelCost = 199
-- 保存多少个付费的赠送来源
tbAct.nSavePayCount = 5
-- 参与等级
tbAct.nLevelLimit = 20

tbAct.FreeLabel = 1
tbAct.PayLabel = 2

-- 标签长度配置
tbAct.nLabelMin = 1;		-- 最小标签长度
tbAct.nLabelMax = 7;		-- 最大标签长度
tbAct.nVNLabelMin = 4;		-- 越南版最小标签长度
tbAct.nVNLabelMax = 14;		-- 越南版最大标签长度

if tbAct.bTSMode then
	tbAct.tbFree = {"Phong Thái Danh Sư", "Sư Phụ Tuấn Tú", "Sư Phụ Nghiêm Khắc", "Sư Phụ Lợi Hại", "Đại Đại Hài Hước", "Khiêm Tốn Học Hỏi", "Ơn Nghĩa Một Đời", "Người Thầy Hiếm Có", "Sư phụ, mình đi đâu thế!", "Vũ khí hiếm của sư phụ"}
else
	tbAct.tbFree = {"Dễ thương", "Hiền lành", "Thướt tha", "Nho nhã", "Thẳng thắn", "Hoạt bát", "Quyến rũ", "Xinh đẹp", "Tươi tắn", "Dịu dàng"}
end


-- 赠送之后可获得的礼盒个数
tbAct.nBoxLimit = 5
-- 礼盒刷新点
tbAct.nBoxRefreshTime = 4 * 60 * 60
-- 可用标签位置
tbAct.nMaxLabel = 15
-- 增加亲密度
tbAct.nAddImitity = 100

-- 赠送印象册邮件内容
tbAct.szMailTitle =  "Hãy ghi lại ấn tượng";
tbAct.szMailText =  "    8/3 sắp đến, đại hiệp hành tẩu giang hồ đến nay chắc cũng đã quen không ít bạn hữu, không biết trong số đó có nữ hiệp nào đã để lại ấn tượng sâu sắc không, nếu có hãy mở Sách Ấn Tượng, ghi lại ấn tượng của họ đối với đại hiệp!";
tbAct.szMailFrom =  "";

-- 赠送印象标签之后发给对方的邮件内容%s （1：赠送方 2：标签）
tbAct.szAcceptMailTitle = "Ấn tượng mới";
tbAct.szAcceptMailFrom = "Hệ Thống";
tbAct.szAcceptMailText = "    [FFFE0D]%s[-] ghi lại ấn tượng mới--[FFFE0D]%s[-] đối với đại hiệp, mau [64db00] [url=openwnd:Xem-ấn-tượng, FriendImpressionPanel] [-]!"


-- 赠送之后自身获得的奖励
tbAct.tbSendAward = 
{
	[tbAct.FreeLabel] = {{"item", 3932, 1}};
	[tbAct.PayLabel] = {{"item", 3932, 1}};
}

-- 赠送之后对方获得的奖励
tbAct.tbAcceptAward = 
{
	[tbAct.FreeLabel] = {{"item", 3932, 1}};
	[tbAct.PayLabel] = {{"item", 3932, 1}};
}

-- 女生标签到达几个可以获得奖励
tbAct.nGirlAwardLabelCount = 15
tbAct.nGirlAward = {{"item", 3931, 1}}

-- 领取哪个活跃度可获得奖励
tbAct.tbActiveIndex = 
{
	[Gift.Sex.Boy] = {[1] = {{"item", 3910, 1}},[2] = {{"item", 3910, 1}},[3] = {{"item", 3910, 1}},[4] = {{"item", 3910, 1}},[5] = {{"item", 3910, 1}}};
	[Gift.Sex.Girl] = {[1] = {{"item", 3909, 1}},[2] = {{"item", 3909, 1}},[3] = {{"item", 3909, 1}},[4] = {{"item", 3909, 1}},[5] = {{"item", 3909, 1}}};
}

tbAct.tbFree2Label = tbAct.tbFree2Label or {}
if not next(tbAct.tbFree2Label) then
	for k,v in pairs(tbAct.tbFree) do
		tbAct.tbFree2Label[v] = k
	end
end

-- 印象签
tbAct.nImpressionLabelItemID = 3910
-- 免费标签需要消耗的道具数量
tbAct.nNeedConsumeImpressionLabel = 1
-- 可赠送的截止时间
tbAct.szSendLabelEndTime = "2019-3-11-3-59-59"
--[[
师徒关系模式:
	去掉旧活动领取活跃度奖励时给的奖励
	去掉升到一定等级邮件发送印象签的设定
	去掉最新消息

	印象签/印象册通过师徒种树活动获得
]]

function tbAct:InitData()
	local tbEndDateTime = Lib:SplitStr(self.szSendLabelEndTime, "-")
	local year, month, day, hour, minute, second = unpack(tbEndDateTime)
	local nEndTime = os.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(minute), sec = tonumber(second)})
	self.nSendLabelEndTime = nEndTime
end

tbAct:InitData()

function tbAct:IsEndSendLabel()
	if GetTime() >= self.nSendLabelEndTime then
		return true, string.format("Hoạt động đã kết thúc, không thể thêm %s", self.szActDes)
	end
	return false
end

-- bNotCheckGold 扣完元宝回调中不再检查元宝
function tbAct:CheckCommon(pPlayer, nAcceptId, nType, szLabel, bNotCheckGold)
	local bRet, szMsg = self:IsEndSendLabel()
	if bRet then
		return false, szMsg
	end

	if nType ~= self.FreeLabel and nType ~= self.PayLabel then
		return false, "Loại chưa biết"
	end

	if szLabel == "" then
		return false, "Ký hiệu chưa biết"
	end

	if pPlayer.nLevel < self.nLevelLimit then
		return false, string.format("Cấp tham gia chưa đạt Lv%s", self.nLevelLimit)
	end

	if MODULE_GAMESERVER then
		if self.bTSMode and not TeacherStudent:IsMyTeacher(pPlayer, nAcceptId) then
			return false, string.format("Chỉ có thể giúp sư phụ tăng %s", self.szActDes)
		end
	end
	
	if not self.bTSMode and not FriendShip:IsFriend(pPlayer.dwID, nAcceptId) then
		return false, "Đối phương không là hảo hữu của đại hiệp";
	end

	local nImityLevel = FriendShip:GetFriendImityLevel(pPlayer.dwID, nAcceptId) or 0
	if nImityLevel < self.nImityLevel then
		return false, string.format("Thân mật 2 bên chưa đạt Lv%s", self.nImityLevel)
	end

	if nType == self.FreeLabel then
		if pPlayer.GetItemCountInAllPos(self.nImpressionLabelItemID) < self.nNeedConsumeImpressionLabel then
			local szItemName = KItem.GetItemShowInfo(self.nImpressionLabelItemID, pPlayer.nFaction, pPlayer.nSex) or "Thẻ Ấn Tượng";
			if (pPlayer.nFaction >= 18) then
				szItemName = Item:GetNewItemShowInfo(self.nImpressionLabelItemID, pPlayer.nFaction, pPlayer.nSex);
			end
			return false, string.format("%s không đủ ",szItemName );
		end
		if not self.tbFree2Label[szLabel] then
			return false, "Miêu tả ký hiệu chưa biết"
		end
	elseif nType == self.PayLabel then
		if not bNotCheckGold and pPlayer.GetMoney("Gold") < self.nPayLabelCost then
			return false, "Nguyên Bảo không đủ"
		end
		if version_vn then
			local nVNLen = string.len(szLabel);
			if nVNLen > self.nVNLabelMax or nVNLen < self.nVNLabelMin then
				return false, string.format("Miêu tả ký hiệu cần từ %d-%d ký tự", self.nVNLabelMin, self.nVNLabelMax);
			end
		else
			local nNameLen = Lib:Utf8Len(szLabel);
			if nNameLen > self.nLabelMax or nNameLen < self.nLabelMin then
				return false, string.format("Miêu tả ký hiệu cần từ %d-%d ký tự", self.nLabelMin, self.nLabelMax);
			end
		end
		if not CheckNameAvailable(szLabel) then
			return false, "Có từ không hợp lệ, sửa rồi thử lại"
		end
	end

	return true
end

--------------------------- Client ------------------------------

function tbAct:OnSendLabelSuccess()
	UiNotify.OnNotify(UiNotify.emNOTIFY_WOMAN_SYNDATA)
end

function tbAct:OnAcceptLabelSuccess()
end

function tbAct:OnSynData(tbData, nStartTime, nEndTime)
	self.nStartTime = nStartTime
	self.nEndTime = nEndTime
	self:FormatData(tbData)
	UiNotify.OnNotify(UiNotify.emNOTIFY_WOMAN_SYNDATA)
end

function tbAct:FormatData(tbData)
	for dwID, tbInfo in pairs(tbData or {}) do
		self.tbLabelInfo[dwID] = self.tbLabelInfo[dwID] or {}
		self.tbLabelInfo[dwID].nPlayerId = dwID
		self.tbLabelInfo[dwID].tbFreeLabel = tbInfo.tbFreeLabel or self.tbLabelInfo[dwID].tbFreeLabel or {}
		self.tbLabelInfo[dwID].tbPayLabel = tbInfo.tbPayLabel or self.tbLabelInfo[dwID].tbPayLabel or {}
		self.tbLabelInfo[dwID].tbLabelTime = tbInfo.tbLabelTime or self.tbLabelInfo[dwID].tbLabelTime or {}
		self.tbLabelInfo[dwID].tbPayLabelPlayer = tbInfo.tbPayLabelPlayer or self.tbLabelInfo[dwID].tbPayLabelPlayer or {}
		self.tbLabelInfo[dwID].nHadLabelCount = tbInfo.nHadLabelCount or self.tbLabelInfo[dwID].nHadLabelCount or 0
	end
end

function tbAct:OnSynLabelPlayer(tbData)
	self.tbPriorData = tbData
	Ui:OpenWindow("FriendImpressionPanel")
end

function tbAct:GetLabelInfo()
	return self.tbLabelInfo
end

function tbAct:GetPriorData()
	return self.tbPriorData
end

function tbAct:ClearPriorData()
	self.tbPriorData = nil
end

function tbAct:OpenLabelWindow(nTargetId)
	if FriendShip:IsFriend(me.dwID, nTargetId) then
		Ui:OpenWindow("FriendImpressionPanel", nTargetId)
	else
		RemoteServer.TrySynLabelPlayer(nTargetId)
	end
end

function tbAct:GetTimeInfo()
	return self.nStartTime, self.nEndTime
end