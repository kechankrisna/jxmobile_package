if not MODULE_GAMESERVER then
    Activity.MaterialCollectAct = Activity.MaterialCollectAct or {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("MaterialCollectAct") or Activity.MaterialCollectAct

tbAct.nJoinLevel = 20
-- 酿酒材料
tbAct.tbMaterial = 
{
	{nItemId = 9836; nScore = 2};
	{nItemId = 9837; nScore = 3};
	{nItemId = 9838; nScore = 5};
}
tbAct.nEnterNpcTId = 3287
tbAct.nEnterNpcMapTID = 8011
tbAct.nEnterNpcPosX = 4412
tbAct.nEnterNpcPosY = 17661
-- 阶段奖励
tbAct.tbProcessAward = 
{
	{nScore = 10000; nAwardCount = 5; tbAward = {{"item", 9856, 1}}, nNpcTID = 3288, nShowItemId = 9856};
	{nScore = 18000; nAwardCount = 5; tbAward = {{"item", 7670, 1}}, nNpcTID = 3289, nShowItemId = 7670};
}
tbAct.nChangeScore = 5 					-- 自动兑换道具积分
tbAct.nChangeItemId = 9839 				-- 自动兑换的道具ID
-- 活跃奖励
tbAct.tbActiveIndex = 
{
	[3] = {{"item", 9836, 1}},
	[4] = {{"item", 9837, 1}},
	[5] = {{"item", 9838, 1}};
}
-- 购买礼包奖励
tbAct.tbDailyGiftVote = 
{
	[Recharge.DAILY_GIFT_TYPE.YUAN_1] = {{"item", 9836, 1}},
	[Recharge.DAILY_GIFT_TYPE.YUAN_3] = {{"item", 9837, 1}},
	[Recharge.DAILY_GIFT_TYPE.YUAN_6] = {{"item", 9838, 1}},
}
 
tbAct.nCollectBoxItemId = 9840 				-- 酒箱id

-- 酒
tbAct.tbCollect = 
{
	{nId = 1, szName = "Đạp Ca Hành", nRandom = 1, nLevel = 3, nScore = 6, nIconId = 9841, nShowItemId = 9841, szKinMsg = "[FFFE0D]%s[-]Mở nắp đậy và phát hiện vò rượu kia chính là [FFFE0D]%s[-]!"};
	{nId = 2, szName = "Nhất Tâm Nhân", nRandom = 1, nLevel = 3, nScore = 6, nIconId = 9842, nShowItemId = 9842, szKinMsg = "[FFFE0D]%s[-]Mở nắp đậy và phát hiện vò rượu kia chính là [FFFE0D]%s[-]!"};
	{nId = 3, szName = "Tương Tư Môn", nRandom = 1, nLevel = 3, nScore = 6, nIconId = 9843, nShowItemId = 9843, szKinMsg = "[FFFE0D]%s[-]Mở nắp đậy và phát hiện vò rượu kia chính là [FFFE0D]%s[-]!"};
	{nId = 4, szName = "Mộng Ngôn Hoan", nRandom = 3, nLevel = 2, nScore = 3, nIconId = 9844, nShowItemId = 9844 };
	{nId = 5, szName = "Thương Tâm Lệ", nRandom = 3, nLevel = 2, nScore = 3, nIconId = 9845, nShowItemId = 9845 };
	{nId = 6, szName = "Đồng Tâm Ẩm", nRandom = 3, nLevel = 2, nScore = 3, nIconId = 9846, nShowItemId = 9846 };
	{nId = 7, szName = "Sơ Kiến Thanh", nRandom = 6, nLevel = 1, nScore = 1, nIconId = 9847, nShowItemId = 9847 };
	{nId = 8, szName = "Túy Xuân Phong", nRandom = 6, nLevel = 1, nScore = 1, nIconId = 9848, nShowItemId = 9848 };
	{nId = 9, szName = "Mạch Thượng Hoa", nRandom = 6, nLevel = 1, nScore = 1, nIconId = 9849, nShowItemId = 9849 };
}

tbAct.tbCollectFullAward = {{"item", 9857, 1}} 			-- 集满奖励
tbAct.nCollectFullShowItem = 9857 						-- 未集满状态点击展示用的id

-- 排名奖励
tbAct.tbRankInfo = 
{
	{1, {{"Item", 9858, 1}}},
	{5, {{"Item", 9859, 1}}},
	{10, {{"Item", 9860, 1}}},
	{20, {{"Item", 9861, 1}}},
	{50, {{"Item", 9862, 1}}},
	{200, {{"Item", 9863, 1}}},
	{500, {{"Item", 9864, 1}}},
}
-- 展示排名
tbAct.nShowRank = 10
tbAct.nServerMaxScore = 20000
tbAct.tbRankAward = {}

tbAct.szMsgTitle = "Thu thập Rượu Ngon"

tbAct.szIntroMsg = [[
[FFFE0D]Hoạt động Thu Thập Rượu Ngon đã bắt đầu![-]
[FFFE0D]Thời gian hoạt động[-]: Từ [c8ff00]4 giờ 10/06/2019 - 4 giờ 10/07/2019[-]
[FFFE0D]Cấp cần: [-]Lv20
Giang hồ sắp chuyển biến, các đại hiệp võ lâm đang chuẩn bị rượu ngon để mừng lễ!
[FFFE0D]Năng động ngày nhận nguyên liệu[-]
Trong thời gian hoạt động, đại hiệp đạt [FFFE0D]60[-], [FFFE0D]80[-], [FFFE0D]100[-] năng động khi mở [FFFE0D]Rương Năng Động[-] tương ứng hoặc nhận [FFFE0D]Quà Mỗi Ngày[-] đều nhận được [11adf6][url=openwnd:Nước Suối, ItemTips, "Item", nil, 9836][-], [11adf6][url=openwnd:Ngũ Cốc, ItemTips, "Item", nil, 9837][-] chỉ định hoặc [11adf6][url=openwnd:Men Rượu, ItemTips, "Item", nil, 9838][-]. 
[FFFE0D]Góp nguyên liệu, toàn máy chủ cùng hợp sức[-]
Trong thời gian hoạt động, Đình Viện Vong Ưu Tửu Quán sẽ đặt [FFFE0D][url=pos:Tửu Đàn, 8011, 4412, 17661][-], người chơi có thể góp [11adf6][url=openwnd:Nước Suối, ItemTips, "Item", nil, 9836][-], [11adf6][url=openwnd:Ngũ Cốc, ItemTips, "Item", nil, 9837][-] và [11adf6][url=openwnd:Men rượu, ItemTips, "Item", nil, 9838][-] trong Hành Trang của mình vào Tửu Đàn, giúp điểm toàn máy chủ tăng đến [FFFE0D]2, 3, 5[-] điểm. Khi điểm máy chủ đạt [FFFE0D]10000[-], trong số người chơi trước đây từng góp nguyên liệu sẽ ngẫu nhiên rút ra [FFFE0D]5[-] người chơi, mỗi người phát 1 [ff8f06][url=openwnd:Rương Chọn Hoàng Kim Đồ Phổ-Phòng Cụ, ItemTips, "Item", nil, 9856][-]. Khi điểm máy chủ đạt [FFFE0D]18000[-], trong số người chơi trước đây từng góp nguyên liệu sẽ ngẫu nhiên rút thêm [FFFE0D]5[-] người chơi, mỗi người phát 1 [ff578c][url=openwnd:Rương Chọn Đá Hồn-Sơ Lv5, ItemTips, "Item", nil, 7670][-]!
[FFFE0D]Thu thập đủ nhận nhiều thưởng[-]
Đại hiệp góp nguyên liệu [FFFE0D]5 điểm[-] cũng sẽ nhận được [FFFE0D]5 điểm[-] cá nhân. Mỗi [FFFE0D]5 điểm[-] sẽ tự động giúp đại hiệp đổi 1 [aa62fc][url=openwnd:Rượu Chưa Mở, ItemTips, "Item", nil, 9839][-]. Sau khi mở sẽ nhận ngẫu nhiên 1 trong [FFFE0D]9 loại rượu[-] gồm [FFFE0D]Đạp Ca Hành, Nhất Tâm Nhân, Tương Tư Môn, Mộng Ngôn Hoan, Thương Tâm Lệ, Đồng Tâm Ẩm, Sơ Kiến Thanh, Túy Xuân Phong, Mạch Thượng Hoa[-], và tự động đặt vào [ff8f06][url=openwnd:Rương Rượu Mừng Lễ, ItemTips, "Item", nil, 9840][-], khi đại hiệp thu thập đủ tất cả [FFFE0D]9 loại rượu[-], có thể mở phần thưởng giấu trong Rương Rượu, nhận 6 [aa62fc][url=openwnd:Thủy Tinh Tím, ItemTips, "Item", nil, 224][-]!
[FFFE0D]Giá trị cao, nhận thưởng hạng[-]
Mỗi loại rượu thu thập được đều có [FFFE0D]giá trị[-] tương ứng, khi hoạt động kết thúc ([ff578c]4:00 ngày 13/07/2019[-]) sẽ phát thưởng căn cứ vào tổng giá trị của rượu thu thập được. Thưởng như sau: 
Hạng 1----------------200 [ff8f06][url=openwnd:Hòa Thị Bích, ItemTips, "Item", nil, 2804][-], 5 [FFFE0D][url=openwnd:Rương Chọn Đá Hồn Lv5, ItemTips, "Item", nil, 7670][-], 50 [FFFE0D][url=openwnd:Tùy Hầu Châu, ItemTips, "Item", nil, 10014][-]
Hạng 2-5--------------158 [ff8f06][url=openwnd:Hòa Thị Bích, ItemTips, "Item", nil, 2804][-], 4 [FFFE0D][url=openwnd:Rương Chọn Đá Hồn Lv5, ItemTips, "Item", nil, 7670][-], 40 [FFFE0D][url=openwnd:Tùy Hầu Châu, ItemTips, "Item", nil, 10014][-]
Hạng 6-10-------------138 [ff8f06][url=openwnd:Hòa Thị Bích, ItemTips, "Item", nil, 2804][-], 3 [FFFE0D][url=openwnd:Rương Chọn Đá Hồn Lv5, ItemTips, "Item", nil, 7670][-], 30 [FFFE0D][url=openwnd:Tùy Hầu Châu, ItemTips, "Item", nil, 10014][-]
Hạng 11-20------------128 [ff8f06][url=openwnd:Hòa Thị Bích, ItemTips, "Item", nil, 2804][-], 2 [FFFE0D][url=openwnd:Rương Chọn Đá Hồn Lv5, ItemTips, "Item", nil, 7670][-], 20 [FFFE0D][url=openwnd:Tùy Hầu Châu, ItemTips, "Item", nil, 10014][-]
Hạng 21-50------------118 [ff8f06][url=openwnd:Hòa Thị Bích, ItemTips, "Item", nil, 2804][-], 1 [FFFE0D][url=openwnd:Rương Chọn Đá Hồn Lv5, ItemTips, "Item", nil, 7670][-], 10 [FFFE0D][url=openwnd:Tùy Hầu Châu, ItemTips, "Item", nil, 10014][-]
Hạng 51-200-----------80 [ff8f06][url=openwnd:Hòa Thị Bích, ItemTips, "Item", nil, 2804][-], 1 [FFFE0D][url=openwnd:Rương Chọn Đá Hồn Lv5, ItemTips, "Item", nil, 7670][-]
Hạng 201-500----------30 [ff8f06][url=openwnd:Hòa Thị Bích, ItemTips, "Item", nil, 2804][-]
Hạng 1 nhận thêm  [ff8f06][url=openwnd:Danh hiệu-Tửu Kiếm Tiên, ItemTips, "Item", nil, 9865][-]
Hạng 2-5 sẽ nhận [ff578c][url=openwnd:Danh Hiệu-Tửu Trung Quân Tử, ItemTips, "Item", nil, 9866][-]
]]
tbAct.szIntroNewMsgKey = "MaterialCollectIntro"
tbAct.szRankAwardNewMsgKey = "MaterialCollectRankAward"
tbAct.szRankAwardMsgTitle = "Hạng thu thập rượu ngon"
tbAct.szRankAwardMsgTime = 60 * 60 * 24 			-- 过期时间

tbAct.nMaterialCollextItemId = 9839 				-- 未启封道具id

for _, v in ipairs(tbAct.tbRankInfo) do
	for nRank = v[1], #tbAct.tbRankAward + 1, -1 do
		tbAct.tbRankAward[nRank] = v[2]
	end
end

for _, v in ipairs(tbAct.tbCollect) do
	tbAct.nCollectRandom = (tbAct.nCollectRandom or 0) + v.nRandom
end

tbAct.tbLeaveMapCloseUi = {"MaterialBoxPanel", "MaterialCollectPanel"}

function tbAct:CheckJoin(pPlayer)
	if pPlayer.nLevel < self.nJoinLevel then
       return false, "Chưa đủ cấp tham gia"
	end
	return true
end

function tbAct:GetMaterialData(pPlayer)
	local tbPlayerData = self.tbMaterialData
	if MODULE_GAMESERVER then
		tbPlayerData = self:GetDataFromPlayer(pPlayer.dwID)
	end
	return tbPlayerData or {}
end

function tbAct:GetMaterialCollect(pPlayer)
	local tbPlayerData = self:GetMaterialData(pPlayer)
	return tbPlayerData.tbCollect or {}
end

function tbAct:GetMaterialCount(pPlayer)
	local nCount = 0
	local tbCollect = self:GetMaterialCollect(pPlayer)
	for _, nC in pairs(tbCollect) do
		nCount = nCount + nC
	end
	return nCount
end

function tbAct:GetMaterialValueKind(pPlayer)
	local tbCollect = self:GetMaterialCollect(pPlayer)
	return Lib:CountTB(tbCollect)
end

function tbAct:GetMaterialValue(pPlayer)
	local tbCollect = self:GetMaterialCollect(pPlayer)
	local nValue = 0
	for _, v in ipairs(self.tbCollect) do
		nValue = nValue + (tbCollect[v.nId] or 0) * v.nScore
	end
	return nValue
end

function tbAct:CheckCanDonate(pPlayer)
	local bRet, szMsg = self:CheckJoin(pPlayer)
	if not bRet then
		return false, szMsg
	end
	for _, v in ipairs(self.tbMaterial) do
		local nHave = pPlayer.GetItemCountInAllPos(v.nItemId);
		if nHave > 0 then
			return true
		end
	end
	return false, "Hiện không có nguyên liệu ủ rượu!"
end

function tbAct:CheckCollectAward(pPlayer)
	local bRet, szMsg = self:CheckJoin(pPlayer)
	if not bRet then
		return false, szMsg
	end
	local tbCollect = self:GetMaterialCollect(pPlayer)
	for _, v in ipairs(self.tbCollect) do
		if not tbCollect[v.nId] or tbCollect[v.nId] < 1 then
			return false, "Chưa thu thập đủ"
		end
	end
	local tbPlayerData = self:GetMaterialData(pPlayer)
	if tbPlayerData.bCollectAward then
		return false, "Phần thưởng đã nhận!"
	end
	return true
end

function tbAct:FormatAward(tbAward, nEndTime)
	local tbFormatAward = Lib:CopyTB(tbAward)
	for _, v in ipairs(tbFormatAward) do
		if v[1] and (v[1] == "item" or v[1] == "Item") then
			 v[4] = nEndTime
		end
	end
	return tbFormatAward
end

function tbAct:GetRankAward(nRank)
	return self.tbRankAward[nRank]
end