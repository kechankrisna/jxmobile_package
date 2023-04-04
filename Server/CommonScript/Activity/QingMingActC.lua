if not MODULE_GAMESERVER then
    Activity.QingMingAct = Activity.QingMingAct or {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("QingMingAct") or Activity.QingMingAct

tbAct.szFubenClass = "QingMingFubenBase"
tbAct.nSitSkill  = 1083 					-- 打坐动作
tbAct.nEffectId = 1086 						-- 修炼身上的特效

tbAct.nWorshipTimes = 10 					-- 祭拜一共加5次经验
tbAct.nWorshipDelayTime = 6 				-- 6秒加一次经验
tbAct.nWorshipAddExpRate = 3			-- 经验倍率

-- 领活跃奖励
tbAct.tbActiveAward = {[1] = {{"item", 4426, 1}}, [2] = {{"item", 4426, 1}}, [3] = {{"item", 4426, 1}}, [4] = {{"item", 4426, 1}}, [5] = {{"item", 4426, 1}}};
-- 合成地图需要几个线索
tbAct.nClueCompose = 5
-- 线索道具模板ID
tbAct.nClueItemTID = 4426
-- 地图道具模板ID
tbAct.nMapItemTID = 4425
-- 活动中所有用到的地图信息
tbAct.tbMapInfo = {
	{nMapTID = 1602, szName = "Tâm Ma Ảo Cảnh-Vong Ưu Đảo",   --[[szTip = "",]] szIntrol = "Giáo chủ Vô Ưu Giáo, cha của Nạp Lan Chân và Nguyệt My Nhi, là một người có dã tâm, vì mục đích của mình mà bất chấp cả tình thân, sát hại sư phụ huynh đệ, cuối cùng độc bá Vô Ưu Giáo, võ công siêu phàm, luôn dòm ngó Võ Đạo Đức Kinh. Sau quyết đấu cùng Dương Ảnh Phong, thất bại thảm hại.\n"},
	{nMapTID = 1603, szName = "Tâm Ma Ảo Cảnh-Phượng Hoàng Sơn",   --[[szTip = "",]] szIntrol = "Người yêu của Độc Cô Kiếm, con gái của Phi Kiếm Khách Trương Phong. Cô ấy chưa từng nghĩ rằng người mình yêu ngay từ cái nhìn đầu tiên, lại có mối thâm thù với bản thân như thế, nên vô cùng đau lòng. Khi hiểu lầm được gỡ bỏ thì một lòng đi theo Độc Cô Kiếm, cứu vớt bá tánh, báo thù cho cha.\n"},
	{nMapTID = 1604, szName = "Tâm Ma Ảo Cảnh-Lăng Tuyệt Phong",   --[[szTip = "",]] szIntrol = "Cha của Nguyệt My Nhi, tiền bảo chủ Phi Long Bảo, một trong hai cao thủ võ lâm「Bắc Thượng Quan, Nam Hi Liệt」. Một người chính trực, không thích đấu đá, kiếm pháp cao siêu. Từng giao đấu một trận khốc liệt với Dương Hi Liệt ở Lăng Tuyệt Phong, cuối cùng cả hai đều mất mạng.\n"},
	{nMapTID = 1605, szName = "Tâm Ma Ảo Cảnh-Kiếm Khí Phong",   --[[szTip = "",]] szIntrol = "Tàng Kiếm Trang Chủ, thiếu niên anh tuấn, văn võ song toàn. Nhưng lòng dạ khó đoán, để có được Võ Đạo Đức Kinh đã phái tì thiếp Tử Hiên dụ dỗ Dương Ảnh Phong, sau khi âm mưu bại lộ đã đẩy Dương Ảnh Phong xuống Kiếm Khí Phong. Nhưng Dương Ảnh Phong không những không mất mạng mà võ công còn tiến bộ. Về sau đã tử trận khi tỉ võ với Dương Ảnh Phong.\n"},
	{nMapTID = 1606, szName = "Tâm Ma Ảo Cảnh-Lăng Tuyệt Phong",   --[[szTip = "",]] szIntrol = "Cha của Dương Ảnh Phong, một trong hai cao thủ võ lâm「Bắc Thượng Quan, Nam Hi Liệt」, là người hào sảng, trọng tình nghĩa, chiêu thức đấu kiếm gấp rút nhanh nhẹn. Khi tỉ võ cùng Thượng Quan Phi Long ở Lăng Tuyệt Phong, thắng thua khó phân, kiệt sức mà bỏ mạng.\n"},
	{nMapTID = 1607, szName = "Tâm Ma Ảo Cảnh-Lạc Diệp Cốc",   --[[szTip = "",]] szIntrol = "Lạc Diệp cốc chủ, cũng là minh chủ võ lâm, cha của Tường Vi. Võ công cực cao, ít người có thể so bì. Sau này khi Nạp Lan Tiềm Lẫm huyết tẩy võ lâm, Mạnh Tri Thu không thể địch nổi, hi sinh khi tuổi còn trẻ.\n"},
	{nMapTID = 1608, szName = "Tâm Ma Ảo Cảnh-Ngoài Lâm An", --[[szTip = "",]] szIntrol = "「Phi Kiếm Khách」là một trong tứ đại kiếm khách「Thiên Tâm Phi Tiên」, cha của Trương Như Mộng và Trương Lâm Tâm, chỉ huy sứ Nam Tống Lâm An Đô. Cùng「Tiên Kiếm Khách」Độc Cô Vân đến nước Kim để cứu Huy Khâm nhị đế, sau bại lộ, để bảo vệ「Bản Đồ Sơn Hà Xã Tắc」giả vờ bị「Thiên Kiếm Khách」Nam Cung Diệt mua chuộc, đích thân xuống tay với Độc Cô Vân đang bị giày vò. Nhẫn nhục sống nhiều năm, sau bỏ mạng dưới tay Nam Cung Diệt.\n"},
	{nMapTID = 1609, szName = "Tâm Ma Ảo Cảnh-Võ Đang Sơn",   --[[szTip = "",]] szIntrol = "Chưởng Môn Nhân tiền nhiệm của Võ Đang, là tri giao của Minh Chủ Võ Lâm Mạnh Tri Thu. Tương truyền võ công được Huyền Thiên Đạo Nhân chỉ điểm, danh vọng trong võ lâm cực cao. Từng được chứng kiến Dương Ảnh Phong đại chiến Trác Phi Phàm. Sau này đã giúp Dương Ảnh Phong tiêu diệt Nạp Lan Tiềm Lẫm.\n"},
	{nMapTID = 1610, szName = "Tâm Ma Ảo Cảnh-Phong Ba Đình",   --[[szTip = "",]] szIntrol = "Danh tướng kháng Kim, là một nhà quân sự, chiến lược gia trứ danh, thống soái Nam Tống kiệt xuất nhất. Nhạc Phi trị quân thưởng phạt phân minh, đề cao kỷ luật, lại quan tâm đến thuộc hạ,「Nhạc Gia Quân」có câu「Thà đói không cướp, thà lạnh không đốt nhà」\n"},
}
-- 玩家自己可能使用地图道具的次数，会根据这个次数提前随好所有地图ID
tbAct.nMaxUseMap = 6
-- 使用地图道具需达到的亲密度
tbAct.nUseMapImityLevel = 5
-- 双方距离
tbAct.MIN_DISTANCE = 1000
-- 协助次数刷新时间点
tbAct.nAssistRefreshTime = 4 * 60 * 60
-- 每天最多可协助次数
tbAct.nMaxAssistCount = 1
-- 参与等级
tbAct.nJoinLevel = 20
-- 协助奖励
tbAct.tbAssistAward = {{"Contrib", 200}}
-- 每天捐献可获得的线索奖励,刷新时间点为协助次数刷新时间点
tbAct.nMaxClueDonatePerDay = 5
-- 每五次捐献的奖励
tbAct.tbDonateAward = {{"item", 4426, 1}}
-- 缅怀奖励
tbAct.tbWorshipAward = {{"item", 4428, 1}}
-- 每天可领取的最大缅怀奖励
tbAct.nMaxWorshipPerDay = 6

assert(#tbAct.tbMapInfo > 0 and tbAct.nMaxUseMap > 0, "[QingMingAct] assert setting fail " ..tbAct.nMaxUseMap .. #tbAct.tbMapInfo)

local nMaxBubbleCount = 10

function tbAct:InitSetting()
	self.tbMapSetting  = {}
	for _, tbInfo in ipairs(self.tbMapInfo) do
		self.tbMapSetting[tbInfo.nMapTID] = tbInfo
	end
end

tbAct:InitSetting()

function tbAct:GetMapSetting(nMapTID)
	return self.tbMapSetting[nMapTID]
end

function tbAct:CheckLevel(pPlayer)
	return pPlayer.nLevel >= self.nJoinLevel
end

function tbAct:OnLeaveWorshipMap()
	Ui:CloseWindow("HomeScreenFuben")
	Ui:CloseWindow("ChuangGongPanel")
end