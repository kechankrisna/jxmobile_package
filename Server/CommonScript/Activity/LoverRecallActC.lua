if not MODULE_GAMESERVER then
    Activity.LoverRecallAct = Activity.LoverRecallAct or {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("LoverRecallAct") or Activity.LoverRecallAct

tbAct.szFubenClass = "LoverRecallFubenBase"

tbAct.tbActiveAward = {[1] = {{"item", 4606, 1}}, [2] = {{"item", 4606, 1}}, [3] = {{"item", 4606, 1}}, [4] = {{"item", 4606, 1}}, [5] = {{"item", 4606, 1}}};

-- 合成地图需要几个线索
tbAct.nClueCompose = 5
-- 线索道具模板ID
tbAct.nClueItemTID = 4606
-- 地图道具模板ID
tbAct.nMapItemTID = 4617
-- 参与等级
tbAct.nJoinLevel = 20
-- 使用地图道具需达到的亲密度
tbAct.nUseMapImityLevel = 5
-- 双方距离
tbAct.MIN_DISTANCE = 1000
-- 每天最多可协助次数
tbAct.nMaxAssistCount = 1
-- 协助次数刷新时间点
tbAct.nAssistRefreshTime = 4 * 60 * 60

tbAct.tbMapInfo = {
	{nMapTID = 1611, szText = "Nguyệt Ảnh Truyền Thuyết-Vong Ưu Thiếu Nữ",   },   --杨影枫&纳兰真
	{nMapTID = 1612, szText = "Nguyệt Ảnh Truyền Thuyết-Phi Long Nữ Hiệp",   },   --杨影枫&月眉儿
	{nMapTID = 1613, szText = "Nguyệt Ảnh Truyền Thuyết-Đa Tình Hồng Nhan",   },   --杨影枫&紫轩
	{nMapTID = 1614, szText = "Nguyệt Ảnh Truyền Thuyết-Lạc Diệp Thiên Kim",   },   --杨影枫&蔷薇
	{nMapTID = 1615, szText = "Võ Lâm Truyền Kỳ-Danh Môn Khuê Tú",   },   --独孤剑&张琳心
	{nMapTID = 1616, szText = "Võ Lâm Truyền Kỳ-Thiên Vương Cân Quốc",   },   --独孤剑&杨瑛
	{nMapTID = 1617, szText = "Võ Lâm Truyền Kỳ 2-Kim Quốc Công Chúa", },   --南宫飞云&燕若雪
}

-- 协助奖励
tbAct.tbAssistAward = {{"Contrib", 200}}

-- 使用奖励
tbAct.tbUseMapAward = {{"Item", 4683, 1}}

function tbAct:CheckLevel(pPlayer)
	return pPlayer.nLevel >= self.nJoinLevel
end

if not MODULE_GAMESERVER then

	function tbAct:OnLeaveLoverRecallMap()
		Ui:CloseWindow("HomeScreenFuben")
	end

end