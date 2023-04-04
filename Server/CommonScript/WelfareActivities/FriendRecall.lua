--常驻活动不挂在Activity下了

FriendRecall.Def = {
	MAIN_ICON_SHOW_TIME = {Lib:ParseDateTime("2017-03-01 00:00:00"), Lib:ParseDateTime("2017-03-28 23:59:59")},
	BEGIN_DATE = 1, --(暂时没用)每月回归开始日期，这个时间段内符合离线标准的玩家回归了才有效
	END_DATE = 31, --每月回归结束日期
	LAST_ONLINE_TIME_LIMIT = 15 * 24 * 60 * 60, --离线多久算老玩家
	AWARD_TIME = 30 * 24 * 60 * 60,		 --福利持续多久
	MAX_RENOWN_WEEKLY = 10000, 	--每周获取名望上限
	MAX_RENOWN_COUNT_WEEKLY = 3,	--每个活动每周最多可以获得几次回归玩家的额外名望奖励
	RENOWN_FRESH_TIME = 4 * 3600; 	--4点刷新累计上限
	MAX_AWARD_PLAYER_COUNT = 100, 	--老玩家召回福利列表上限
	MAX_SHOW_CAN_RECALL_COUNT = 10, --最多显示多少名可召回玩家(按亲密度排序)
	IMITY_LEVEL_LIMIT = 10, 			--好友亲密度等级限制
	RESH_LIST_INTERVAL = 10, 		--列表刷新请求间隔
	IMITY_BONUS = 2,				--亲密度加成100%
	MAX_RECALLED_COUNT  = 5,		--召回次数
	TEAM_BUFF_TIME = 3*24*3600,		--组队buff时间
	TEAM_BUFF_ID = 2317,			--组队buff ID
	RENOWN_VALUE = 				--名望奖励
	{
		["TeamFuben"] = 100,	--组队秘境
		["RandomFuben"] = 100,	--凌绝峰
		["AdventureFuben"] = 100,	--山贼秘窟
		["PunishTask"] = 40,		--惩恶
		["TeamBattle"] = 500,		--通天塔
		["InDifferBattle"] = 500,	--心魔幻境
	},
--------------------------以上为策划配置项--------------------------
	SAVE_GROUP = 61,
	ACTIVITY_VERSION = 101, --版本信息
	RECALL = 102, --是否是召回的老玩家
	AWARD_END_TIME = 103, --福利结束时间
	GET_RENOWN = 104, --累计获取的名望
	RESET_RENOWN_WEEK = 105,--重置名望累计周
	HAVE_RECALL_PLAYER = 106,--有过可召回玩家标记
	TEAM_BATTLE_RENOWN = 107,--每周获取通天塔名望奖励次数
	PUNISH_TASK_RENOWN = 108,--每周获取惩恶名望奖励次数
	TEAM_FUBEN_RENOWN = 109,--每周获取组队秘境名望奖励次数
	RANDOM_FUBEN_RENOWN = 110,--每周获取凌绝峰名望奖励次数
	ADVENTURE_FUBEN_RENOWN = 111,--每周获取山贼秘窟名望奖励次数
	INDIFFER_BATTLE_RENOWN = 112,--每周获取心魔幻境名望奖励次数
}

FriendRecall.Def.RENOWN_SAVE_MAP = 
{
	["TeamFuben"] = FriendRecall.Def.TEAM_FUBEN_RENOWN,
	["RandomFuben"] = FriendRecall.Def.RANDOM_FUBEN_RENOWN,
	["AdventureFuben"] = FriendRecall.Def.ADVENTURE_FUBEN_RENOWN,
	["PunishTask"] = FriendRecall.Def.PUNISH_TASK_RENOWN,
	["TeamBattle"] = FriendRecall.Def.TEAM_BATTLE_RENOWN,
	["InDifferBattle"] = FriendRecall.Def.INDIFFER_BATTLE_RENOWN,
}

FriendRecall.RecallType = 
{
	TEACHER = 1,
	STUDENT = 2,
	FIREND = 3,
	KIN = 4,	
}

FriendRecall.AwardInfo = 
{
	szTitle = [[Đã lâu không gặp, bây giờ thế nào rồi?
   Các bằng hữu đã từng kề vai chinh chiến giang hồ, nay công thành danh toại, có muốn cùng họ chia sẻ niềm vui? Hãy dùng Zalo và VLTKm tìm họ và cùng tái chiến giang hồ!]],

   	szDesc = [[
Quy tắc và phần thưởng
  
  1. Hoàn thành [FFFE0D]Bí Cảnh Tổ Đội, Lăng Tuyệt Phong, Sơn Tặc Mật Quật, Nhiệm Vụ Trừng Ác, Tâm Ma Ảo Cảnh, Thông Thiên Tháp[-] với đại hiệp được triệu hồi sẽ nhận Danh Vọng, mỗi hoạt động mỗi tuần tối đa 3 lần
  2. Tổ đội với người chơi được triệu hồi sẽ nhận trạng thái tăng lợi ích tăng thuộc tính (Liên SV vô hiệu)
  3. Tăng độ thân mật với người được triệu hồi sẽ tăng 100%]],

     	tbAward = {{3640, 1}, {3641, 1}, {3642, 1}},
}

FriendRecall.RecalledAwardInfo = 
{
	szTitle = [[Giang hồ phong vân biến động, phúc lợi võ lâm không ít, đại hiệp vẫn phải cố gắng tăng cấp, sớm ngày tái xuất giang hồ.]],

   	szDesc = [[
Quy tắc và phần thưởng
     1. Chỉ cần tìm người phù hợp điều kiện trong danh sách hảo hữu cùng tổ đội sẽ có thể nhận trạng thái「Tái Xuất Giang Hồ」
     2. Đại hiệp Lv55 trở lên có thể nhấp vào nút phúc lợi trong giao diện chính để nhận thưởng Tái Xuất Giang Hồ
     3. Tổ đội với người chơi triệu hồi sẽ nhận trạng thái tăng lợi ích tăng thuộc tính (Liên SV vô hiệu)
     4. Tăng độ thân mật với người triệu hồi sẽ tăng 100%]],

     	tbAward = {{3640, 1}, {3641, 1}, {3643, 1}},
}

FriendRecall.RecallDesc = 
{
	[FriendRecall.RecallType.TEACHER] = 
	{
		szTitle = "Sư đồ hội ngộ",
		szDesc = "Đồ nhi, đã lâu không gặp, có muốn cùng tái xuất giang hồ không?",
	},
	[FriendRecall.RecallType.STUDENT] = 
	{
		szTitle = "Một ngày làm thầy, cả đời cũng là thầy",
		szDesc = "Sư phụ, thập đại môn phái có biến, khi nào người dẫn đồ nhi bôn ba giang hồ?",
	},
	[FriendRecall.RecallType.FIREND] = 
	{
		szTitle = "Rượu còn ấm, người chưa đi xa đâu",
		szDesc = "Hảo huynh đệ! Trở về chúng ta lại cùng uống rượu cho sảng khoái nhé!",
	},
	[FriendRecall.RecallType.KIN] = 
	{
		szTitle = "Phải như vậy mới là giang hồ",
		szDesc = "Nay phong vân biến đổi, quần hùng tranh bá, chính là lúc ngươi bộc lộ tài năng!",
	},
}

--主界面是否显示图标入口
function FriendRecall:IsInShowMainIcon()
	local nNow = GetTime()
	local nBegin = self.Def.MAIN_ICON_SHOW_TIME[1];
	local nEnd = self.Def.MAIN_ICON_SHOW_TIME[2];

	if not nBegin or not nEnd then
		return false
	end

	return nBegin <= nNow and nNow <= nEnd;
end

function FriendRecall:IsInProcess()
	local nDate = Lib:GetMonthDay()
	return self.Def.BEGIN_DATE <= nDate and nDate <= self.Def.END_DATE;
end

function FriendRecall:IsRecallPlayer(pPlayer)
	return pPlayer.GetUserValue(self.Def.SAVE_GROUP, self.Def.RECALL) == 1;
end

function FriendRecall:IsHaveRecallAward(pPlayer)
	local nEndTime = pPlayer.GetUserValue(self.Def.SAVE_GROUP, self.Def.AWARD_END_TIME);
	return nEndTime > 0 and nEndTime > GetTime();
end
