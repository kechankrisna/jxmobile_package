if not MODULE_GAMESERVER then
	Activity.WorldCupAct = Activity.WorldCupAct or {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("WorldCupAct") or Activity.WorldCupAct


tbAct.szMainKey = "WorldCupAct"

tbAct.nJoinLevel = 20

tbAct.nBookId = 8216	--收集册id
tbAct.nMedalItemId = 8217	--未鉴定徽章道具id
tbAct.szIdentyCostType = "Contrib"   --鉴定消耗货币类型，不能为元宝
tbAct.nIdentyMedalCost = 60	--鉴定徽章消耗
tbAct.tbActiveAward = { -- 活跃奖励个数
	[1] = 0,
	[2] = 0,
	[3] = 1,
	[4] = 1,
	[5] = 1,
}
tbAct.tbDailyGiftAward = {	--购买每日礼包奖励个数
	[1] = 1,	--1元
	[2] = 1,	--3元
	[3] = 1,	--6元
}

tbAct.tbScoreCfg = {
	[8218] = 1,    --俄罗斯国家队徽章
	[8219] = 1,    --沙特阿拉伯国家队徽章
	[8220] = 1,    --埃及国家队徽章
	[8221] = 1,    --乌拉圭国家队徽章
	[8222] = 1,    --葡萄牙国家队徽章
	[8223] = 1,    --西班牙国家队徽章
	[8224] = 1,    --摩洛哥国家队徽章
	[8225] = 1,    --伊朗国家队徽章
	[8226] = 1,    --法国国家队徽章
	[8227] = 1,    --澳大利亚国家队徽章
	[8228] = 1,    --秘鲁国家队徽章
	[8229] = 1,    --丹麦国家队徽章
	[8230] = 1,    --阿根廷国家队徽章
	[8231] = 1,    --冰岛国家队徽章
	[8232] = 1,    --克罗地亚国家队徽章
	[8233] = 1,    --尼日利亚国家队徽章
	[8234] = 1,    --巴西国家队徽章
	[8235] = 1,    --瑞士国家队徽章
	[8236] = 1,    --哥斯达黎加国家队徽章
	[8237] = 1,    --塞尔维亚国家队徽章
	[8238] = 1,    --德国国家队徽章
	[8239] = 1,    --墨西哥国家队徽章
	[8240] = 1,    --瑞典国家队徽章
	[8241] = 1,    --韩国国家队徽章
	[8242] = 1,    --比利时国家队徽章
	[8243] = 1,    --巴拿马国家队徽章
	[8244] = 1,    --突尼斯国家队徽章
	[8245] = 1,    --英格兰国家队徽章
	[8246] = 1,    --波兰国家队徽章
	[8247] = 1,    --塞内加尔国家队徽章
	[8248] = 1,    --哥伦比亚国家队徽章
	[8249] = 1,    --日本国家队徽章
}

tbAct.nTransferItemNormal = 8392	--转换道具（普通）
tbAct.nTransferItemAdvance = 8393 --转换道具（高级）
tbAct.nTransferExpire = Lib:ParseDateTime("2018-07-17 0:0:0")
tbAct.nTransferTokenExpire = Lib:ParseDateTime("2018-07-11 1:59:59")

tbAct.szMailText = "Trong [FFFE0D]hoạt động Thu Thập Huy Chương Cup Thế Giới 2018[-] đạt hạng [FFFE0D]%d[-], đính kèm là phần thưởng, xin hãy nhận!"
tbAct.tbRankAward = {
	{1, {"Item", 2804, 100}, {"Item", 8254, 1}, {"Item", 8274, 1}},
	{5, {"Item", 2804, 60}, {"Item", 8255, 1}, {"Item", 8275, 1}},
	{10, {"Item", 2804, 40}},
	{20, {"Item", 2804, 30}},
	{50, {"Item", 2804, 20}},
	{200, {"Item", 2804, 10}},
	{500, {"Item", 2804, 5}},
}
tbAct.nBaseRewardScoreMin = 999999	--满x价值量获得基础奖励
tbAct.tbBaseReward = {"Item", 7704, 1} --基础奖励

tbAct.tbCollect32Rewards = {	--收集满32支球队的徽章获得的奖励
	{"item", 224, 6},
}

tbAct.tbShowItems = {	--收集册中显示的徽章物品id
	8218, 8219, 8220, 8221, 
	8222, 8223, 8224, 8225, 
	8226, 8227, 8228, 8229, 
	8230, 8231, 8232, 8233, 
	8234, 8235, 8236, 8237, 
	8238, 8239, 8240, 8241, 
	8242, 8243, 8244, 8245, 
	8246, 8247, 8248, 8249
}

tbAct.tbShowItems4 = { --上届4强名单
	8238, 8230, 8234
}
tbAct.tbShowItems8 = {  --上届8强名单
	8238, 8230, 8234, 8226, 8242, 8248, 8236
}

function tbAct:CheckPlayer(pPlayer)
	if pPlayer.nLevel < self.nJoinLevel then
		return false, string.format("Hãy tăng đến Lv%d", self.nJoinLevel)
	end
	return true
end

if MODULE_GAMECLIENT then
	function tbAct:GainReward()
		RemoteServer.WorldCupReq("GainReward")
	end

	function tbAct:UpdateData()
		RemoteServer.WorldCupReq("UpdateData")
	end

	function tbAct:OnUpdateData(tbData)
		self.tbData = tbData
		local szUiName = "WorldCupPanel"
		if Ui:WindowVisible(szUiName) ~= 1 then
			return
		end
		Ui(szUiName):Refresh()
	end

	function tbAct:Transfer(bNormal)
		bNormal = not not bNormal

		if not self.nTransFromItemId or self.nTransFromItemId <= 0 then
			return false, "Chưa chọn huy chương cần chuyển đổi!"
		end

		if self.nTransFromItemId == self.nTransToItemId then
	        return false, "Huy chương đợi chuyển đổi không được giống với huy chương mục tiêu!"
	    end

		if not self.tbData then
			self:UpdateData()
			return false
		end
		local nCount = self.tbData.tbItems[self.nTransFromItemId] or 0
		if nCount <= 0 then
			return false, "Chưa nhận huy chương đã chọn"
		end

		if not bNormal then
			if not self.nTransToItemId or self.nTransToItemId <= 0 then
				return false, "Chưa chọn huy chương mục tiêu chuyển đổi!"
			end
			local nCount = self.tbData.tbItems[self.nTransToItemId] or 0
			if nCount <= 0 then
				return false, "Chưa nhận huy chương mục tiêu đã chọn"
			end		
		end
		
		local szFromName = KItem.GetItemShowInfo(self.nTransFromItemId, me.nFaction, me.nSex);
		local szToName = KItem.GetItemShowInfo(self.nTransToItemId, me.nFaction, me.nSex);
		if (me.nFaction >= 18) then
			szFromName = Item:GetNewItemShowInfo(self.nTransFromItemId, me.nFaction, me.nSex);
			szToName = Item:GetNewItemShowInfo(self.nTransToItemId, me.nFaction, me.nSex);
		end
		
		
		local szMsg = bNormal and string.format("Đồng ý chuyển [FFFE0D]%s[-] thành huy chương một quốc gia ngẫu nhiên ngoài huy chương này? Chuyển đổi thành công sẽ tốn [FFFE0D]Bùa Chuyển Đổi Huy Chương-Thường[-]!", szFromName) or 
					string.format("Đồng ý chuyển [FFFE0D]%s[-] thành [FFFE0D]%s[-]? Chuyển đổi thành công sẽ tốn [FFFE0D]Bùa Chuyển Đổi Huy Chương-Cao[-]!", szFromName, szToName);
		me.MsgBox(szMsg, {{"Đồng ý", function ()
			local szUiName = "WorldCupTransferPanel"
			if Ui:WindowVisible(szUiName) == 1 then
				Ui(szUiName).pPanel:SetActive("texiao", true)
				Ui(szUiName).pPanel:SetActive("BtnTransformation", false)
			end
			Timer:Register(Env.GAME_FPS * 1, function()
				RemoteServer.WorldCupReq("Transfer", bNormal, self.nTransFromItemId, self.nTransToItemId)
				self.nTransFromItemId = nil
				self.nTransToItemId = nil
			end)
		end}, {"Hủy"}})
		return true
	end

	function tbAct:OnUpdateTransferData()
		local szUiName = "WorldCupTransferPanel"
		if Ui:WindowVisible(szUiName) ~= 1 then
			return
		end
		Ui(szUiName):Refresh()
	end
end