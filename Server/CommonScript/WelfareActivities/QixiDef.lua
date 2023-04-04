if not MODULE_GAMESERVER then
    Activity.Qixi = {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("Qixi") or Activity.Qixi

tbAct.Def = {
    BAIXING_AWARDS_ID = 2701, --拜星奖励
    BAIXING_EXT_AWARDS = {{"BasicExp", 2}}, --每次拜星读条奖励
    BAIXING_HELP_AWARDS = {{"Contrib", 200}},
    BAIXING_EXT_TIMES = 15, --总共读条次数
    BAIXING_EXT_INTERVAL = 6, --每次读条时间

    IMITITY_BAIXING = 500,
    IMITITY_SENDGIFT = 200,

    --SEND_GIFT_AWARD = {{"Coin", 100}}, --赠送奖励
    --GAIN_GIFT_AWARD = {{"Coin", 100}}, --被赠奖励

    EVERY_AWARD = { {"Item", 2684, 1}, {"Item", 2685, 1}, {"Item", 2686, 1}, {"Item", 2687, 1} }, --每日目标奖励
    SEND_ITEM = { {[2688] = 2689}, {[2690] = 2691} }, --道具赠送对应关系

    IMITYLEVEL = 2,  --亲密度
    OPEN_LEVEL = 20, --开启等级

    CHANGE_ITEM_TIMES    = 1, --每天交换七色玄香次数
    HELP_AWARD_TIMES     = 2, --协助烧香有奖励次数

    ACTIVITY_TIME_BEGIN = Lib:ParseDateTime("2016/8/9"), --开始时间
    ACTIVITY_TIME_END   = Lib:ParseDateTime("2016/8/15 23:59:59"), --结束时间

    CHAT_GIFT = {
        [2688] = "Cành hoa tặng người, nâng chén vui cười!",
        [2689] = "Cảm ơn quà [%s] tặng, ta rất thích!",
        [2690] = "Gươm báu tặng người, ngao du đất trời!",
        [2691] = "Cảm ơn quà [%s] tặng, ta rất thích!",
    },

    ITEM_TIP = {
        [2689] = "[FFFE0D][%s][-] tặng quà cho ta, nhắn rằng: [FFFE0D]Cành hoa tặng người, nâng chén vui cười[-]",
        [2691] = "[FFFE0D][%s][-] tặng quà cho ta, nhắn rằng: [FFFE0D]Gươm báu tặng người, ngao du đất trời[-]",
    },

    WORLD_NOTIFY = "Sự Kiện tháng 11 đã bắt đầu, [FFFE0D]hoàn thành Mục Tiêu Ngày[-] và [FFFE0D]Cống Hiến Bang Hội[-], nhận đạo cụ hoạt động. Theo dõi thông tin để biết thêm chi tiết.",

-----------------------------------以上为策划配置项-----------------------------------

    SAVE_GROUP            = 59,
    DATA_LOCALDAY_KEY     = 1,
    CHANGE_ITEM_TIMES_KEY = 2,
    HELP_AWARD_TIMES_KEY  = 3,
}

function tbAct:IsInActivityTime()
    return GetTime() >= self.Def.ACTIVITY_TIME_BEGIN and GetTime() < self.Def.ACTIVITY_TIME_END
end

function tbAct:CommonCheck(tbMyInfo, tbHelperInfo)
   if tbMyInfo[1] == tbHelperInfo[1] or not FriendShip:IsFriend(tbMyInfo[2], tbHelperInfo[2]) then
        return nil, "Hảo hữu khác giới"
    end

    local nImityLevel = FriendShip:GetFriendImityLevel(tbMyInfo[2], tbHelperInfo[2]) or 0
    if nImityLevel < self.Def.IMITYLEVEL then
        return nil, string.format("Thân mật Lv%d", self.Def.IMITYLEVEL)
    end

    local nLevel = self.Def.OPEN_LEVEL
    if tbMyInfo[3] < nLevel or tbHelperInfo[3] < nLevel then
        return nil, "Cấp chưa đạt"
    end

    return true
end