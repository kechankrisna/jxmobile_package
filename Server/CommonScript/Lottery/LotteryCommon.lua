
Lottery.szOpenTimeFrame = "OpenLevel69";
Lottery.USER_GROUP = 143;
Lottery.USER_KEY_WEEK = 1;
Lottery.USER_KEY_TICKET = 2;
Lottery.NOTIFY_TIME = 19 * 3600 + 1800;
Lottery.DRAW_GAP = 7 * 24 * 3600;
Lottery.DRAW_TIME = 6 * 24 * 3600 + 19 * 3600 + 1800;
Lottery.NEWINFO_TIME_RESULT = 24 * 3600;
Lottery.NEWINFO_KEY_RESULT = "LotteryResult";
Lottery.NEWINFO_KEY_NOTIFY = "LotteryNotify";
Lottery.VIP_MIN = 6;
Lottery.VIP_MAX = 12;
Lottery.tbTicketItem = 
{
	OpenLevel69 = 6144,
};

Lottery.tbGiftTicketCount =
{
	Daily1 = 1,		-- 1元礼包 
	Daily2 = 1,		-- 3元礼包 
	Daily3 = 2,		-- 6元礼包
	Weekly = 1,		-- 周卡
	Monthly = 1,	-- 月卡
};

Lottery.tbAwardSetting = 
{
	OpenLevel69 = 
	{
		[1] = { {"item",1397, 3},{"item", 3450, 1}, },
		[2] = { {"item",1397, 1},{"item", 3455, 1}, },
		[3] = { {"item", 2170, 3}, },
		[4] = { {"item", 2169, 2}, },

		-- 幸运奖
		[-1] = { {"item",2804, 10},{"item", 1968, 5000}, },
	},

	OpenLevel79 = 
	{
		[1] = { {"item",1397, 3},{"item", 3450, 1}, },
		[2] = { {"item",1397, 1},{"item", 3455, 1}, },
		[3] = { {"item", 2170, 3}, },
		[4] = { {"item", 2169, 2}, },
		[-1] = { {"item",2804, 10},{"item", 1968, 5000}, },
	},

	OpenLevel89 = 
	{
		[1] = { {"item",1397, 3},{"item", 3450, 1}, },
		[2] = { {"item",1397, 1},{"item", 3455, 1}, },
		[3] = { {"item", 2170, 3}, },
		[4] = { {"item", 2169, 2}, },
		[-1] = { {"item",2804, 10},{"item", 1968, 5000}, },
	},

	OpenLevel99 = 
	{
		[1] = { {"item",1397, 3},{"item", 3450, 1}, },
		[2] = { {"item",1397, 1},{"item", 3455, 1}, },
		[3] = { {"item", 2170, 3}, },
		[4] = { {"item", 2169, 2}, },
		[-1] = { {"item",2804, 10},{"item", 1968, 5000}, },
	},

	OpenLevel109 = 
	{
		[1] = { {"item",1397, 3},{"item", 3450, 1}, },
		[2] = { {"item",1397, 1},{"item", 3455, 1}, },
		[3] = { {"item", 2170, 3}, },
		[4] = { {"item", 2169, 2}, },
		[-1] = { {"item",2804, 10},{"item", 1968, 5000}, },
	},

	OpenLevel119 = 
	{
		[1] = { {"item",1397, 3},{"item", 3450, 1}, },
		[2] = { {"item",1397, 1},{"item", 3455, 1}, },
		[3] = { {"item", 2170, 3}, },
		[4] = { {"item", 2169, 2}, },
		[-1] = { {"item",2804, 10},{"item", 1968, 5000}, },
	},

	OpenLevel129 = 
	{
		[1] = { {"item",1397, 3},{"item", 3450, 1}, },
		[2] = { {"item",1397, 1},{"item", 3455, 1}, },
		[3] = { {"item", 2170, 3}, },
		[4] = { {"item", 2169, 2}, },
		[-1] = { {"item",2804, 10},{"item", 1968, 5000}, },
	},
};
-- 幸运奖玩家不在此配置内
Lottery.tbRankSetting =
{
	[1] = { nNum = 1, szWorldNotify = "「%s」trong hoạt động Quà Tặng Minh Chủ được Minh Chủ tặng [FFFE0D]Quà Đặc Biệt[-]!", 	szKinNotify = "「%s」trong hoạt động Quà Tặng Minh Chủ được Minh Chủ tặng [FFFE0D]Quà Đặc Biệt[-]!" },
	[2] = { nNum = 3, szWorldNotify = "「%s」trong hoạt động Quà Tặng Minh Chủ được Minh Chủ tặng [FFFE0D]Quà Bậc 1[-]!", 		szKinNotify = "「%s」trong hoạt động Quà Tặng Minh Chủ được Minh Chủ tặng [FFFE0D]Quà Bậc 1[-]!" },
	[3] = { nNum = 10, szWorldNotify = "「%s」trong hoạt động Quà Tặng Minh Chủ được Minh Chủ tặng [FFFE0D]Quà Bậc 2[-]!", 		szKinNotify ="「%s」trong hoạt động Quà Tặng Minh Chủ được Minh Chủ tặng [FFFE0D]Quà Bậc 2[-]!" },
	[4] = { nNum = 50, szWorldNotify = nil, 		szKinNotify = "「%s」trong hoạt động Quà Tặng Minh Chủ được Minh Chủ tặng [FFFE0D]Quà Bậc 3[-]!"  },
};

-- 幸运奖个数3000个
Lottery.MAX_JOIN_AWARD_COUNT = 3000;

function Lottery:GetAwardSetting(nRank)
	local tbSetting = Lottery.tbAwardSetting;
	local szTimeFrame = Lib:GetMaxTimeFrame(tbSetting);
	local tbAward = tbSetting[szTimeFrame];
	if not tbAward then
		return;
	end
	return tbAward[nRank];
end

function Lottery:GetTicketItem()
	local tbSetting = Lottery.tbTicketItem;
	local szTimeFrame = Lib:GetMaxTimeFrame(tbSetting);
	return tbSetting[szTimeFrame];
end

function Lottery:GetAwardTicketCount(szType)
	return self.tbGiftTicketCount[szType];
end

function Lottery:GetDrawTime(nTime)
	nTime = nTime or GetTime();
	local nPassTime = Lib:GetLocalWeekTime(nTime);
	local nLeftTime = self.DRAW_TIME - nPassTime;
	if nLeftTime < 0 then
		nLeftTime = nLeftTime + self.DRAW_GAP;
	end
	return nTime + nLeftTime;
end

function Lottery:GetDrawWeek()
	if MODULE_GAMESERVER then
		local nTime = self:GetDrawTime();
		return Lib:GetLocalWeek(nTime);
	else
		return self.nDrawWeek or 0;
	end
end