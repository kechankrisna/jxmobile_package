Require("CommonScript/Activity/BeautyPageant.lua");

local tbAct = Activity:GetClass("BeautyPageant")

--本服冠军雕像有效期3个月
tbAct.nLocalStatueTimeOut = 3*30*24*60*60

tbAct.tbTimerTrigger = 
{
	--[1] = {szType = "Day", Time = "10:35" , Trigger = "OnWorldNotify" },  --因为发奖是在10点以后，取消该时间点的世界公告
	[1] = {szType = "Day", Time = "12:10" , Trigger = "OnWorldNotify" },
	[2] = {szType = "Day", Time = "16:10" , Trigger = "OnWorldNotify" },
	[3] = {szType = "Day", Time = "19:27" , Trigger = "OnWorldNotify" },
	[4] = {szType = "Day", Time = "22:42" , Trigger = "OnWorldNotify" },
	[5] = {szType = "Day", Time = "00:05", Trigger = "CheckLocalResultInfo"},-- 如果在间歇期中间时间还没公布结果的最新消息这里直接发
	[6] = {szType = "Day", Time = "00:05", Trigger = "CheckFinalResultInfo"},-- 如果在间歇期中间时间还没公布结果的最新消息这里直接发
}

tbAct.tbTrigger = { 
	Init = { }, 
	Start = { {"StartTimerTrigger", 1}, {"StartTimerTrigger", 2}, {"StartTimerTrigger", 3},
		 {"StartTimerTrigger", 4}, {"StartTimerTrigger", 5}, {"StartTimerTrigger", 6}, {"StartTimerTrigger", 7}},
	OnWorldNotify = {},
	End = { },
}

--每日礼包赠送投票道具数量
tbAct.DailyGiftVote = 
{
	[Recharge.DAILY_GIFT_TYPE.YUAN_1] = 1,
	[Recharge.DAILY_GIFT_TYPE.YUAN_3] = 2,
	[Recharge.DAILY_GIFT_TYPE.YUAN_6] = 3,
	[Recharge.DAILY_GIFT_TYPE.YUAN_10] = 6,
}

--周卡月卡赠送投票道具数量
tbAct.DaysCardVote = 
{
	[Recharge.DAYS_CARD_TYPE.DAYS_7] = 18,
	[Recharge.DAYS_CARD_TYPE.DAYS_30] = 30,
}

--充值元宝对应赠送投票道具比例
tbAct.nRechargeGoldVote = 300;

--充值获得黎饰对应赠送投票道具比例
--98元送1000黎饰
tbAct.nRechargeSilverBoardVote = 30;

--本服排行奖励
tbAct.tbLocalWinnerAward = 
{
	[1] =  --海选第一
	{
		{"AddTimeTitle", 7202, Lib:ParseDateTime("2018-06-23 12:00:00")},
		{"Item", 4835, 1},  --礼包
	},

	[2] =  --海选前十 
	{
		{"AddTimeTitle", 7203, Lib:ParseDateTime("2018-06-23 12:00:00")},
		{"Item", 4836, 1},  --礼包
	},
}

--全服排行奖励
tbAct.tbFinalWinnerAward = 
{
	[1] =  --决赛第一
	{
		{"AddTimeTitle", 7200, Lib:ParseDateTime("2018-07-03 00:00:00")},
		{"Item", 4833, 1},  --礼包
	},

	[2] =   --决赛前十
	{
		{"AddTimeTitle", 7201, Lib:ParseDateTime("2018-07-03 00:00:00")},
		{"Item", 4834, 1},  --礼包
	},
}

--海选赛投票参与奖励（199票）
tbAct.tbParticipateAward = 
{
	{"AddTimeTitle", 7204, Lib:ParseDateTime("2018-06-23 12:00:00")},
	{"Item", 4824, 1},  --头像
	{"Energy", 15000},
}

--决赛投票参与奖励（8000票）
tbAct.tbFinalParticipateAward = 
{
	{"AddTimeTitle", 7205, Lib:ParseDateTime("2018-07-03 00:00:00")},
	{"Item", 5252, 1},  --前缀
	{"Item", 4838, 1},  --地毯
	{"Item", 4820, 1},  --头像
	{"Energy", 30000},
}

tbAct.tbWorldNotify = 
{
	--报名阶段
	[tbAct.STATE_TYPE.SIGN_UP] = "「Võ lâm đệ nhất mỹ nữ bình chọn」Ngay tại lửa nóng tiếp nhận báo danh bên trong, chư vị nữ hiệp nhưng tiến về Tương Dương thành Tử Hiên chỗ báo danh",  
	--海选赛
	[tbAct.STATE_TYPE.LOCAL] = "「Võ lâm đệ nhất mỹ nữ bình chọn」Hải tuyển thi đấu ( Bản phục bình chọn ) Đang tiến hành bên trong, nhanh đi cho các ngươi trong suy nghĩ nữ thần ném bên trên một phiếu đi! Chưa báo danh nữ hiệp nhưng tiến về Tương Dương thành Tử Hiên chỗ báo danh.",  
	--海选赛展示
	[tbAct.STATE_TYPE.LOCAL_REST] = "「Võ lâm đệ nhất mỹ nữ bình chọn」Hải tuyển thi đấu ( Bản phục bình chọn ) Trước mười đã sinh ra, 「Bản phục đệ nhất mỹ nữ」Pho tượng đã ở Tử Hiên chỗ dựng nên, nhanh đi thấy phương dung đi!",
	--决赛
	[tbAct.STATE_TYPE.FINAL] = "「Võ lâm đệ nhất mỹ nữ bình chọn」Trận chung kết ( Vượt phục bình chọn ) Đang tiến hành bên trong, nhanh đi cho các ngươi trong suy nghĩ nữ thần ném bên trên một phiếu đi!",
	--决赛展示
	[tbAct.STATE_TYPE.FINAL_REST] = "「Võ lâm đệ nhất mỹ nữ bình chọn」Trận chung kết ( Vượt phục bình chọn ) Trước mười đã sinh ra, 「Võ lâm đệ nhất mỹ nữ」Pho tượng đã ở Tử Hiên chỗ dựng nên, nhanh đi thấy phương dung đi!",
}

tbAct.tbNpcBubble = 
{
	[tbAct.STATE_TYPE.SIGN_UP] = --报名阶段
	{
		--紫轩
		--[[{nNpcTemplate=622, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」火热接受报名中，报名阶段将于[FFFE0D]2017年6月21日[-]结束。"},

		--小紫烟
		{nNpcTemplate=95, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Tử Hiên tỷ tỷ nói tiểu nữ hài không thể tham gia「Võ lâm đệ nhất mỹ nữ bình chọn」, hừ hừ ~"},
		--张琳心
		{nNpcTemplate=621, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="听闻「Võ lâm đệ nhất mỹ nữ bình chọn」海选赛已经开始报名了，我也得启程前去参赛了。"},
		--唐影
		{nNpcTemplate=620, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」Tuyển thủ dự thi bên trong, kia Thúy Yên môn môn chủ ngược lại là có mấy phần tư sắc."},
		--小殷方
		{nNpcTemplate=623, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Oa! Tử Hiên tỷ tỷ nơi đó thật náo nhiệt a, đều là tiểu thư xinh đẹp tỷ, chắc là vì kia「Võ lâm đệ nhất mỹ nữ bình chọn」Mà đi a."},
		--杨瑛
		{nNpcTemplate=633, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nếu có cơ hội, ta cũng muốn tới kiến thức một chút Tương Dương thành lập tức thịnh sự「Võ lâm đệ nhất mỹ nữ bình chọn」."},
		--纳兰真
		{nNpcTemplate=90, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc ~ Ảnh Phong ca ca, ngươi sẽ ủng hộ ta đúng không? Hì hì......"},
		--月眉儿
		{nNpcTemplate=97, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Chân nhi muội muội,「Võ lâm đệ nhất mỹ nữ bình chọn」Ta cũng sẽ không để cho ngươi."},
		--杨影枫
		{nNpcTemplate=624, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Chân nhi cùng Mi nhi đều báo danh「Võ lâm đệ nhất mỹ nữ bình chọn」, ta nên ủng hộ ai đây? Thật đau đầu......"},
		--万金财
		{nNpcTemplate=190, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc hắc ~ Năm nay「Võ lâm đệ nhất mỹ nữ bình chọn」Từ ta Vạn mỗ người thương hội nhà tài trợ duy nhất, ban thưởng phong phú, cố ý nữ hiệp mau mau tiến đến báo danh đi."},
		--公孙惜花
		{nNpcTemplate=99, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Gần đây trong thành Tương Dương ngay tại tổ chức「Võ lâm đệ nhất mỹ nữ bình chọn」, ta cái này「Ẩn hương lâu」Nhưng góp nhặt không ít thi đấu sự tình báo nha ~"},
		--秋依水
		{nNpcTemplate=694, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Bằng vào ta Thúy Yên môn đệ tử tư sắc, 「Võ lâm đệ nhất mỹ nữ」Nhất định là môn hạ của ta đệ tử."},
		--武僧
		{nNpcTemplate=1829, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="A Di Đà Phật, mấy ngày nay sân đấu võ bên trong tốt là quạnh quẽ, chắc là bởi vì kia「Võ lâm đệ nhất mỹ nữ bình chọn」Đi......"},
		--祝子虚
		{nNpcTemplate=1528, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Kiếm hiệp nhiều giai nhân, đẹp người Nhan Như Ngọc. Cười một tiếng khuynh nhân thành, lại cười khuynh nhân quốc.——[FFFE0D]「Võ lâm đệ nhất mỹ nữ bình chọn」[-]"},
		--黄暮云
		{nNpcTemplate=1530, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Ta trong đảo đệ tử trời sinh manh manh đát, 「Võ lâm đệ nhất mỹ nữ」 Vinh dự dễ như trở bàn tay!"},]]
	},
	[tbAct.STATE_TYPE.LOCAL] = --海选赛
	{
		--紫轩
		{nNpcTemplate=622, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」Hải tuyển thi đấu đang tiến hành bên trong, đem với [FFFE0D]2017 Năm 6 Nguyệt 23 Nhật [-] Bình chọn ra [FFFE0D]「Bản phục đệ nhất mỹ nữ」[-], nhanh đi cho các ngươi trong suy nghĩ nữ thần ném bên trên một phiếu đi!"},

		--小紫烟
		{nNpcTemplate=95, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Tử Hiên tỷ tỷ nói tiểu nữ hài không thể tham gia「Võ lâm đệ nhất mỹ nữ bình chọn」, hừ hừ ~"},
		--张琳心
		{nNpcTemplate=621, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nghe nói「Võ lâm đệ nhất mỹ nữ bình chọn」Hải tuyển thi đấu đã bắt đầu báo danh, ta cũng phải lên đường tiến đến dự thi."},
		--唐影
		{nNpcTemplate=620, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」Tuyển thủ dự thi bên trong, kia Thúy Yên môn môn chủ ngược lại là có mấy phần tư sắc."},
		--小殷方
		{nNpcTemplate=623, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Oa! Tử Hiên tỷ tỷ nơi đó thật náo nhiệt a, đều là tiểu thư xinh đẹp tỷ, chắc là vì kia「Võ lâm đệ nhất mỹ nữ bình chọn」Mà đi a."},
		--杨瑛
		{nNpcTemplate=633, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nếu có cơ hội, ta cũng muốn tới kiến thức một chút Tương Dương thành lập tức thịnh sự「Võ lâm đệ nhất mỹ nữ bình chọn」."},
		--纳兰真
		{nNpcTemplate=90, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc ~ Ảnh Phong ca ca, ngươi sẽ ủng hộ ta đúng không? Hì hì......"},
		--月眉儿
		{nNpcTemplate=97, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Chân nhi muội muội,「Võ lâm đệ nhất mỹ nữ bình chọn」Ta cũng sẽ không để cho ngươi."},
		--杨影枫
		{nNpcTemplate=624, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Chân nhi cùng Mi nhi đều báo danh「Võ lâm đệ nhất mỹ nữ bình chọn」, ta nên ủng hộ ai đây? Thật đau đầu......"},
		--万金财
		{nNpcTemplate=190, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc hắc ~ Năm nay「Võ lâm đệ nhất mỹ nữ bình chọn」Từ ta Vạn mỗ người thương hội nhà tài trợ duy nhất, ban thưởng phong phú, cố ý nữ hiệp mau mau tiến đến báo danh đi."},
		--公孙惜花
		{nNpcTemplate=99, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Gần đây trong thành Tương Dương ngay tại tổ chức「Võ lâm đệ nhất mỹ nữ bình chọn」, ta cái này「Ẩn hương lâu」Nhưng góp nhặt không ít thi đấu sự tình báo nha ~"},
		--秋依水
		{nNpcTemplate=694, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Bằng vào ta Thúy Yên môn đệ tử tư sắc, 「Võ lâm đệ nhất mỹ nữ」Nhất định là môn hạ của ta đệ tử."},
		--武僧
		{nNpcTemplate=1829, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="A Di Đà Phật, mấy ngày nay sân đấu võ bên trong tốt là quạnh quẽ, chắc là bởi vì kia「Võ lâm đệ nhất mỹ nữ bình chọn」Đi......"},
		--祝子虚
		{nNpcTemplate=1528, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Kiếm hiệp nhiều giai nhân, đẹp người Nhan Như Ngọc. Cười một tiếng khuynh nhân thành, lại cười khuynh nhân quốc.——[FFFE0D]「Võ lâm đệ nhất mỹ nữ bình chọn」[-]"},
		--黄暮云
		{nNpcTemplate=1530, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Ta trong đảo đệ tử trời sinh manh manh đát,「Võ lâm đệ nhất mỹ nữ」Vinh dự dễ như trở bàn tay!"},
	},

	[tbAct.STATE_TYPE.LOCAL_REST] =  --海选赛休整
	{
		--紫轩
		{nNpcTemplate=622, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」Hải tuyển thi đấu ( Bản phục bình chọn ) Trước mười đã sinh ra, trận chung kết ( Vượt phục bình chọn ) Sẽ tại [FFFE0D]6 Nguyệt 26 Nhật [-] Bắt đầu."},

		--小紫烟
		{nNpcTemplate=95, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Tử Hiên tỷ tỷ nói tiểu nữ hài không thể tham gia「Võ lâm đệ nhất mỹ nữ bình chọn」, hừ hừ ~"},
		--张琳心
		{nNpcTemplate=621, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nghe nói「Bản phục đệ nhất mỹ nữ」 Pho tượng đã tại Tử Hiên tỷ tỷ cây kia lập......"},
		--唐影
		{nNpcTemplate=620, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」Tuyển thủ dự thi bên trong, kia Thúy Yên môn môn chủ ngược lại là có mấy phần tư sắc."},
		--小殷方
		{nNpcTemplate=623, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Oa! Tử Hiên tỷ tỷ nơi đó thật náo nhiệt a, đều là tiểu thư xinh đẹp tỷ, chắc là vì kia「Võ lâm đệ nhất mỹ nữ bình chọn」Mà đi a."},
		--杨瑛
		{nNpcTemplate=633, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nếu có cơ hội, ta cũng muốn tới kiến thức một chút Tương Dương thành lập tức thịnh sự「Võ lâm đệ nhất mỹ nữ bình chọn」."},
		--纳兰真
		{nNpcTemplate=90, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc ~ Ảnh Phong ca ca, ngươi sẽ ủng hộ ta đúng không? Hì hì......"},
		--月眉儿
		{nNpcTemplate=97, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Chân nhi muội muội,「Võ lâm đệ nhất mỹ nữ bình chọn」Ta cũng sẽ không để cho ngươi."},
		--杨影枫
		{nNpcTemplate=624, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Chân nhi cùng Mi nhi đều báo danh「Võ lâm đệ nhất mỹ nữ bình chọn」, ta nên ủng hộ ai đây? Thật đau đầu......"},
		--万金财
		{nNpcTemplate=190, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc hắc ~ Năm nay「Võ lâm đệ nhất mỹ nữ bình chọn」Từ ta Vạn mỗ người thương hội nhà tài trợ duy nhất, ban thưởng phong phú, cố ý nữ hiệp mau mau tiến đến báo danh đi."},
		--公孙惜花
		{nNpcTemplate=99, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Gần đây trong thành Tương Dương ngay tại tổ chức「Võ lâm đệ nhất mỹ nữ bình chọn」, ta cái này「Ẩn hương lâu」Nhưng góp nhặt không ít thi đấu sự tình báo nha ~"},
		--秋依水
		{nNpcTemplate=694, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Bằng vào ta Thúy Yên môn đệ tử tư sắc, 「Võ lâm đệ nhất mỹ nữ」Nhất định là môn hạ của ta đệ tử."},
		--武僧
		{nNpcTemplate=1829, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="A Di Đà Phật, mấy ngày nay sân đấu võ bên trong tốt là quạnh quẽ, chắc là bởi vì kia「Võ lâm đệ nhất mỹ nữ bình chọn」Đi......"},
		--祝子虚
		{nNpcTemplate=1528, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Kiếm hiệp nhiều giai nhân, đẹp người Nhan Như Ngọc. Cười một tiếng khuynh nhân thành, lại cười khuynh nhân quốc.——[FFFE0D]「Võ lâm đệ nhất mỹ nữ bình chọn」[-]"},
		--黄暮云
		{nNpcTemplate=1530, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Ta trong đảo đệ tử trời sinh manh manh đát, 「Võ lâm đệ nhất mỹ nữ」 Vinh dự dễ như trở bàn tay!"},
	},

	[tbAct.STATE_TYPE.FINAL] = --决赛
	{
		--紫轩
		{nNpcTemplate=622, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」Trận chung kết đang tiến hành bên trong, đem với [FFFE0D]2017 Năm 7 Nguyệt 3 Nhật [-] Bình chọn ra [FFFE0D]「Võ lâm đệ nhất mỹ nữ」[-], nhanh đi cho các ngươi trong suy nghĩ nữ thần ném bên trên một phiếu đi!"},

		--小紫烟
		{nNpcTemplate=95, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Tử Hiên tỷ tỷ nói tiểu nữ hài không thể tham gia「Võ lâm đệ nhất mỹ nữ bình chọn」, hừ hừ ~"},
		--张琳心
		{nNpcTemplate=621, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc hắc! Các vị đại hiệp, mau đưa trong tay các ngươi「Hồng phấn giai nhân」Hiến cho「Võ lâm đệ nhất mỹ nữ bình chọn」Dự thi giai nhân đi."},
		--唐影
		{nNpcTemplate=620, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」Tuyển thủ dự thi bên trong, kia Thúy Yên môn môn chủ ngược lại là có mấy phần tư sắc."},
		--小殷方
		{nNpcTemplate=623, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Oa! Tử Hiên tỷ tỷ nơi đó thật náo nhiệt a, đều là tiểu thư xinh đẹp tỷ, chắc là vì kia「Võ lâm đệ nhất mỹ nữ bình chọn」Mà đi a."},
		--杨瑛
		{nNpcTemplate=633, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Nếu có cơ hội, ta cũng muốn tới kiến thức một chút Tương Dương thành lập tức thịnh sự「Võ lâm đệ nhất mỹ nữ bình chọn」."},
		--纳兰真
		{nNpcTemplate=90, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc ~ Ảnh Phong ca ca, ngươi sẽ ủng hộ ta đúng không? Hì hì......"},
		--月眉儿
		{nNpcTemplate=97, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Chân nhi muội muội,「Võ lâm đệ nhất mỹ nữ bình chọn」Ta cũng sẽ không để cho ngươi."},
		--杨影枫
		{nNpcTemplate=624, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Chân nhi cùng Mi nhi đều báo danh「Võ lâm đệ nhất mỹ nữ bình chọn」, ta nên ủng hộ ai đây? Thật đau đầu......"},
		--万金财
		{nNpcTemplate=190, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Hắc hắc ~ Năm nay「Võ lâm đệ nhất mỹ nữ bình chọn」Từ ta Vạn mỗ người thương hội nhà tài trợ duy nhất, ban thưởng phong phú, cố ý nữ hiệp mau mau tiến đến báo danh đi."},
		--公孙惜花
		{nNpcTemplate=99, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Gần đây trong thành Tương Dương ngay tại tổ chức「Võ lâm đệ nhất mỹ nữ bình chọn」, ta cái này「Ẩn hương lâu」Nhưng góp nhặt không ít thi đấu sự tình báo nha ~"},
		--秋依水
		{nNpcTemplate=694, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Bằng vào ta Thúy Yên môn đệ tử tư sắc, 「Võ lâm đệ nhất mỹ nữ」Nhất định là môn hạ của ta đệ tử."},
		--武僧
		{nNpcTemplate=1829, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="A Di Đà Phật, mấy ngày nay sân đấu võ bên trong tốt là quạnh quẽ, chắc là bởi vì kia「Võ lâm đệ nhất mỹ nữ bình chọn」Đi......"},
		--祝子虚
		{nNpcTemplate=1528, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Kiếm hiệp nhiều giai nhân, đẹp người Nhan Như Ngọc. Cười một tiếng khuynh nhân thành, lại cười khuynh nhân quốc.——[FFFE0D]「Võ lâm đệ nhất mỹ nữ bình chọn」[-]"},
		--黄暮云
		{nNpcTemplate=1530, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="Ta trong đảo đệ tử trời sinh manh manh đát, 「Võ lâm đệ nhất mỹ nữ」 Vinh dự dễ như trở bàn tay!"},
	},

	[tbAct.STATE_TYPE.FINAL_REST] =  --决赛休整
	{
		--紫轩
		{nNpcTemplate=622, nMapId=10, szDateTime={"00:00:00", "23:59:59"}, szContent="「Võ lâm đệ nhất mỹ nữ bình chọn」Trận chung kết ( Vượt phục bình chọn ) Trước mười đã sinh ra, 「Võ lâm đệ nhất mỹ nữ」Pho tượng đã dựng nên, nhanh đi thấy phương dung đi!"},
	},
}

tbAct.tbSignUpMail = 
{
	[tbAct.STATE_TYPE.LOCAL] = 
	{
		Title = "Thành công báo danh tuyển mỹ hải tuyển thi đấu",
		Text = string.format("    Chúc mừng giai nhân! Ngươi thành công báo danh「Võ lâm đệ nhất mỹ nữ bình chọn」Hải tuyển thi đấu, phụ kiện vì ngươi dự thi tuyên truyền đơn.[FFFE0D] Có thể thông qua nó đang tùy ý nói chuyện phiếm kênh tuyên truyền người tuyển mỹ thông tin, hoặc mở ra mình dự thi giao diện.[-] Nhắc nhở: [FF6464FF] Đã thượng truyền dự thi tư liệu không thể sửa đổi, đề nghị hoạt động trong lúc đó không muốn sửa đổi nhân vật danh tự a![-]\n    [00FF00][url=openBeautyUrl:Xem xét hoạt động giao diện, %s]\n    [url=openBeautyUrl:Xem xét ta giao diện, %s][-]", tbAct.szMainEntryUrl, tbAct.szPlayerUrl),
		From = "「Tuyển mỹ đại hội người chủ trì」Tử Hiên",
		nLogReazon = Env.LogWay_BeautyPageant_SignUp,
		tbAttach = {{"item", tbAct.SIGNUP_ITEM, 1, tbAct.STATE_TIME[tbAct.STATE_TYPE.LOCAL][2]}},
	},
	[tbAct.STATE_TYPE.FINAL] = 
	{
		Title = "Tuyển mỹ nhập vây trận chung kết thông tri",
		Text = string.format("    Chúc mừng giai nhân! Ngươi thành công [FFFE0D] Nhập vây tuyển mỹ trận chung kết [-] Giai đoạn.\n    Trận chung kết ( Vượt phục bình chọn ) Đem với [FFFE0D]6 Nguyệt 24 Hào [-] Bắt đầu, đến lúc đó ngươi đem cùng đến từ cái khác server hải tuyển lúc trước ba tên người chơi cộng đồng tranh đấu [ff578c]「Võ lâm đệ nhất mỹ nữ」[-], phụ kiện vì ngươi trận chung kết tuyên truyền đơn.\n    [00FF00][url=openBeautyUrl:Xem xét bình chọn kết quả, %s]\n    [url=openBeautyUrl:Xem xét ta giao diện, %s][-]", tbAct.szMainEntryUrl, tbAct.szPlayerUrl),
		From = "「Tuyển mỹ đại hội người chủ trì」Tử Hiên",
		nLogReazon = Env.LogWay_BeautyPageant_SignUp,
		tbAttach = {{"item", tbAct.SIGNUP_ITEM_FINAL, 1, tbAct.STATE_TIME[tbAct.STATE_TYPE.FINAL][2]}},
	},
}

tbAct.tbWinnerMailInfo = 
{
	[1] = {szName="Quán quân", szTitle="Đệ nhất", szContent="    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D] Thứ %d Tên [-].\n    Chúc mừng giai nhân! Ngươi bị bình chọn vì [ff578c]「Võ lâm %s Mỹ nữ」[-]%s"},
	[2] = {szName="Thập cường", szTitle="Thập đại", szContent="    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D] Thứ %d Tên [-].\n    Chúc mừng giai nhân! Ngươi bị bình chọn vì [ff578c]「Võ lâm %s Mỹ nữ」[-]%s"},
}

tbAct.AVAILABLE_CHANNEL = 
{
	[ChatMgr.ChannelType.Public] = 1,
	[ChatMgr.ChannelType.Team] = 1,
	[ChatMgr.ChannelType.Kin] = 1,
	[ChatMgr.ChannelType.Nearby] = 1,
	[ChatMgr.ChannelType.Friend] = 1,
}

tbAct.WINNER_TYPE = 
{
	BEGINE = 0,

	FINAL_1 = 1,
	FINAL_2 = 2,
	FINAL_3 = 3,
	FINAL_4 = 4,
	FINAL_5 = 5,
	FINAL_6 = 6,
	FINAL_7 = 7,
	FINAL_8 = 8,
	FINAL_9 = 9,
	FINAL_10 = 10,

	LOCAL_1 = 11,
	LOCAL_2 = 12,
	LOCAL_3 = 13,
	LOCAL_4 = 14,
	LOCAL_5 = 15,
	LOCAL_6 = 16,
	LOCAL_7 = 17,
	LOCAL_8 = 18,
	LOCAL_9 = 19,
	LOCAL_10 = 20,

	PARTICIPATE = 21,
	FINAL_PARTICIPATE = 22,

	MAX = 23,
}

tbAct.tbStatueInfo =
{
	[tbAct.WINNER_TYPE.FINAL_1] =
	{
		--襄阳城雕像
		{
			nTemplateId = 2336,
			pos = {10, 13275,18637},
			nTitleId = 7200,
			nDir = 50,
		},
		--临安城雕像
		{
			nTemplateId = 2336,
			pos = {15, 11674,5010},
			nTitleId = 7200,
			nDir = 48,
		},
	},

	[tbAct.WINNER_TYPE.LOCAL_1] =
	{
		--襄阳城雕像
		{
			nTemplateId = 2306,
			pos = {10, 13284,18936},
			nTitleId = 7202,
			nDir = 50,
		},
		--临安城雕像
		{
			nTemplateId = 2306,
			pos = {15, 11676,4768},
			nTitleId = 7202,
			nDir = 48,
		},
	},
}

function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then
		ScriptData:SaveValue(self.szScriptDataKey, {})
		local tbData = self:GetActivityData();
		tbData.szFurnitureAwardFrame = Lib:GetMaxTimeFrame(self.tbFurnitureSelectAward)
		Log("[Info]", "BeautyPageant", "Init Set FurnitureAwardFrame", tbData.szFurnitureAwardFrame)

		local nStartTime, nEndTime = self:GetOpenTimeInfo()
		NewInformation:AddInfomation("BeautyReward", nEndTime,
						 {nStartTime, nEndTime},
						 {szTitle="Mỹ nữ bình chọn hộ hoa thưởng", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 1, szUiName = "BeautyReward", szCheckRpFunc="fnBeautyRewardCheckRp"})
	elseif szTrigger == "Start" then
		Timer:Register(Env.GAME_FPS, self.AddNpcBubbleTalk, self)
		Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin")
		Activity:RegisterPlayerEvent(self, "Act_SendChannelMsg", "SendChannelMsg")
		Activity:RegisterPlayerEvent(self, "Act_RequestSignUpFriend", "OnRequestSignUpFriend")
		Activity:RegisterPlayerEvent(self, "Act_DailyGift", "OnBuyDailyGift")
		Activity:RegisterPlayerEvent(self, "Act_BuyDaysCard", "OnBuyDaysCard")
		Activity:RegisterPlayerEvent(self, "Act_OnRechargeGold", "OnRechargeGold")
		Activity:RegisterPlayerEvent(self, "Act_OnAddOrgMoney", "OnAddOrgMoney")
		Activity:RegisterPlayerEvent(self, "Act_VotedAwardReq", "OnVotedAwardReq")
		Activity:RegisterPlayerEvent(self, "Act_EverydayTarget_Award", "OnAddEverydayAward")

		local nState = self:GetCurState()
		if nState == self.STATE_TYPE.SIGN_UP or nState == self.STATE_TYPE.LOCAL then
			Activity:RegisterNpcDialog(self, 622, {Text = "Ta muốn ghi danh", Callback = self.TrySignUp, Param = {self}})
		end

		if nState ~= self.STATE_TYPE.SIGN_UP then
			Activity:RegisterNpcDialog(self, 622, {Text = "Ta muốn bỏ phiếu", Callback = self.TryVote, Param = {self}})
		end

		local _, nEndTime = self:GetOpenTimeInfo()
		self:RegisterDataInPlayer(nEndTime)

		local tbPlayer = KPlayer.GetAllPlayer();
		for _, pPlayer in pairs(tbPlayer) do
			if pPlayer.nLevel >= self.LEVEL_LIMIT then
				self:OnLogin(pPlayer)
			end
		end
	elseif szTrigger == "OnWorldNotify" then
		self:OnWorldNotify()
	elseif szTrigger == "CheckLocalResultInfo" then
		local tbInfoData = NewInformation:GetInformation("BeautyPageantAct_LocalResult")
		if not tbInfoData and self:GetCurState() == self.STATE_TYPE.LOCAL_REST and self:GetStateLeftTime() <= 24*60*60 then
			-- 如果在间歇期中间时间还没公布结果的最新消息这里直接发
			self:AddLocalResultInfo();
		end
	elseif szTrigger == "CheckFinalResultInfo" then
		local tbInfoData = NewInformation:GetInformation("BeautyPageantAct_FinalResult")
		if not tbInfoData and self:GetCurState() == self.STATE_TYPE.FINAL_REST and self:GetStateLeftTime() <= 2*24*60*60 then
			-- 如果在间歇期中间时间还没公布结果的最新消息这里直接发
			self:AddFinalResultInfo();
		end
	elseif szTrigger  == "End" then
	end
end

function tbAct:GetActivityData()
	local tbData = ScriptData:GetValue(self.szScriptDataKey)
	tbData.tbSignList = tbData.tbSignList or {}
	tbData.tbFinalWinnerList = tbData.tbFinalWinnerList or {}
	tbData.tbLocalWinnerList = tbData.tbLocalWinnerList or {}
	tbData.tbParticipateWinnerList = tbData.tbParticipateWinnerList or {}
	tbData.tbFinalParticipateWinnerList = tbData.tbFinalParticipateWinnerList or {}
	return tbData
end

function tbAct:SaveActivityData()
	 ScriptData:AddModifyFlag(self.szScriptDataKey)
end

function tbAct:OnWorldNotify()
	local nState = self:GetCurState();
	local szNotify = self.tbWorldNotify[nState]
	if szNotify then
		KPlayer.SendWorldNotify(self.LEVEL_LIMIT, 1000,
					szNotify,
					ChatMgr.ChannelType.Public, 1);
	end
end

function tbAct:AddNpcBubbleTalk()
	for nState,tbNpcList in pairs(self.tbNpcBubble) do
		local tbTimeRange = tbAct.STATE_TIME[nState];
		for _,tbInfo in pairs(tbNpcList) do
			NpcBubbleTalk:Add(tbInfo.nMapId, tbInfo.nNpcTemplate,
						tbInfo.szContent,
						 Lib:GetTimeStr4(tbTimeRange[1]),
						 Lib:GetTimeStr4(tbTimeRange[2]),
						 tbInfo.szDateTime[1], tbInfo.szDateTime[2])
		end
	end
end

function tbAct:CheckPlayerData(pPlayer)
	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	if pPlayer.GetUserValue(self.SAVE_GROUP, self.VERSION) == nStartTime then
		return
	end
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VERSION, nStartTime)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_COUNT, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_1, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_2, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_3, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_4, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_5, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_6, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_7, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_8, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_9, 0)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_AWARD_10, 0)
end

function tbAct:OnLogin(pPlayer)
	self:CheckPlayerData(pPlayer);
	local bIsSignUp, nSignUpTimeOut = self:IsSignUp(pPlayer.dwID);
	if bIsSignUp then
		pPlayer.CallClientScript("Activity.BeautyPageant:SyncIsSignUp", nSignUpTimeOut);
	end
	pPlayer.CallClientScript("Activity.BeautyPageant:SyncFurnitureAwardFrame", self:GetFurnitureAwardFrame());
end

function tbAct:TrySignUp()
	if me.nLevel < self.LEVEL_LIMIT then
		me.CenterMsg(string.format("Cấp bậc chưa đủ %d", self.LEVEL_LIMIT))
		return
	end

	me.CallClientScript("Activity.BeautyPageant:OpenSignUpPage");
end

function tbAct:TryVote()
	me.CallClientScript("Activity.BeautyPageant:OpenMainPage");
end

function tbAct:GetFurnitureAwardFrame()
	local tbData = self:GetActivityData();
	
	return tbData.szFurnitureAwardFrame or "-1"
end

function tbAct:OnSignUp(nPlayerId)
	local tbData = self:GetActivityData();
	--有效时间到本服比赛结束时间
	tbData.tbSignList[nPlayerId] = self.STATE_TIME[self.STATE_TYPE.LOCAL][2]
	self:SaveActivityData();
	local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
	if pPlayer then
		pPlayer.CallClientScript("Activity.BeautyPageant:SyncIsSignUp", tbData.tbSignList[nPlayerId]);
		local dwKinId = pPlayer.dwKinId
		if dwKinId > 0 then
			local szName = pPlayer.szName
			local tbLinkData = {nLinkType = ChatMgr.LinkType.HyperText, linkParam={szHyperText = string.format("[url=openBeautyUrl:PlayerPage, %s][-]", string.format(self.szPlayerUrl, pPlayer.dwID, Sdk:GetServerId()))}}
			local nNow = GetTime()
			local tbTime = os.date("*t", nNow)
			ChatMgr:SendSystemMsg(ChatMgr.SystemMsgType.Kin,
				string.format(XT("Bang phái thành viên「%s」Đã báo danh Võ lâm đệ nhất mỹ nữ bình chọn Hoạt động < Giai nhân: %s>"),
					szName, szName),
					dwKinId, tbLinkData);
		end

	end

	self:SendSignUpItem(nPlayerId, self.STATE_TYPE.LOCAL)
end

function tbAct:IsSignUp(nPlayerId)
	local tbData = self:GetActivityData();
	local nSignUpTimeOut = tbData.tbSignList[nPlayerId];
	return nSignUpTimeOut ~= nil and GetTime() < nSignUpTimeOut, nSignUpTimeOut
end

function tbAct:SendChannelMsg(pPlayer, nType, nParam)
	if not self:IsSignUp(pPlayer.dwID) then
		return
	end

	if not nType then
		return
	end

	if nType ~= tbAct.MSG_CHANNEL_TYPE.NORMAL and 
		nType ~= tbAct.MSG_CHANNEL_TYPE.FACTION and
		nType ~= tbAct.MSG_CHANNEL_TYPE.PRIVATE then

		return
	end

	local szMsg, tbLinkData = self:GetSendMsg(pPlayer)

	if nType == tbAct.MSG_CHANNEL_TYPE.NORMAL then
		local nChannel = nParam or 0;
		if not tbAct.AVAILABLE_CHANNEL[nChannel] then
			return
		end

		if nChannel == ChatMgr.ChannelType.Public then
			if not ChatMgr:ReducePublicChatCount(pPlayer, 1) then
				return
			end
		end

		ChatMgr:SendPlayerMsg(nChannel, pPlayer.dwID, pPlayer.szName,
						 pPlayer.nFaction, pPlayer.nPortrait, pPlayer.nSex,
						 pPlayer.nLevel, szMsg, tbLinkData)

	elseif nType == tbAct.MSG_CHANNEL_TYPE.FACTION then
		local nChannel = Faction.tbChatChannel[pPlayer.nFaction]
		if not nChannel then
			return
		end

		ChatMgr:SendPlayerMsg(nChannel, pPlayer.dwID, pPlayer.szName,
						 pPlayer.nFaction, pPlayer.nPortrait, pPlayer.nSex,
						 pPlayer.nLevel, szMsg, tbLinkData)

	elseif nType == tbAct.MSG_CHANNEL_TYPE.PRIVATE then
		local nToRoleId = nParam or 0

		local pToStayInfo = KPlayer.GetRoleStayInfo(nToRoleId)
		if not pToStayInfo then
			return
		end

		SendPrivateMsg(pPlayer.dwID, nToRoleId, szMsg, tbLinkData)
	end
end

function tbAct:OnRequestSignUpFriend(pPlayer)
	local tbList = {}
	local tbAllFriends, _ = KFriendShip.GetFriendList(pPlayer.dwID);
	for nPlayerId, nImity in pairs(tbAllFriends) do
		if self:IsSignUp(nPlayerId) then
			table.insert(tbList, nPlayerId);
		end
	end
	if Lib:CountTB(tbList) > 0 then
		pPlayer.CallClientScript("Activity.BeautyPageant:SyncSignUpFriendList", tbList);
	end
end

function tbAct:OnVotedAwardReq(pPlayer, nIndex)
	local tbAward, nCanGet, nGotCount, bIsShow, tbAwardInfo = self:GetVotedAward(pPlayer, nIndex);
	if not tbAward or not nCanGet or nCanGet <= 0 or not bIsShow then
		return
	end
	
	pPlayer.SetUserValue(self.SAVE_GROUP, tbAwardInfo.nSaveKey, nGotCount + nCanGet);
	pPlayer.SendAward({tbAward}, true, true, Env.LogWay_BeautyPageant_Vote);

	pPlayer.CallClientScript("Activity.BeautyPageant:OnRefreshVotedAward");
end

function tbAct:OnAddEverydayAward(pPlayer, nAwardIdx)
	--活跃度100才给奖励
	if nAwardIdx ~= 5 then
		return
	end

	if pPlayer.nLevel < self.LEVEL_LIMIT then
		return
	end

	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end

	local tbFinalTime = self.STATE_TIME[self.STATE_TYPE.FINAL]

	pPlayer.SendAward({{"item", self.VOTE_ITEM, 1, tbFinalTime[2]}}, true, true, Env.LogWay_BeautyPageant_EverydayAward);
end

function tbAct:OnWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
	if self.WINNER_TYPE.FINAL_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.FINAL_10 then

		self:_OnFinalWinnerResult(nWinnerType, nServerId,
				 szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)

	elseif self.WINNER_TYPE.LOCAL_1 <= nWinnerType and nWinnerType <= self.WINNER_TYPE.LOCAL_10 then

		self:_OnLocalWinnerResult(nWinnerType, nServerId,
				 szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)

	elseif nWinnerType == self.WINNER_TYPE.PARTICIPATE then

		self:_OnParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName,
				 nFaction, nArmorResId, nWeaponResId)

	elseif nWinnerType == self.WINNER_TYPE.FINAL_PARTICIPATE then

		self:_OnFinalParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName,
				 nFaction, nArmorResId, nWeaponResId)

	end
end

function tbAct:_OnFinalWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
	local nRank = nWinnerType - self.WINNER_TYPE.FINAL_1 + 1;
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local bAwarded = false;
	local tbOldWinnerInfo = tbFinalWinnerList[nRank]
	if tbOldWinnerInfo then
		bAwarded = tbOldWinnerInfo.bAwarded
		Lib:LogTB(tbOldWinnerInfo);
		Log("[Warning]", "BeautyPageant", "_OnFinalWinnerResult", "Over Write Cur Data", nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded))
	end

	tbFinalWinnerList[nRank] = 
	{
		nWinnerType = nWinnerType,
		nRank = nRank,
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
		nTime = GetTime(),
	}

	local nThisServerId = GetServerIdentity()

	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	local nStatusTemplate
	if tbStatueInfoList then
		for _, tbStatueInfo in pairs( tbStatueInfoList ) do
			nStatusTemplate = tbStatueInfo.nTemplateId
			if tbOldWinnerInfo then
				self:RemoveStatue(tbOldWinnerInfo, tbStatueInfo)
			end
			self:AddStatue(tbFinalWinnerList[nRank], tbStatueInfo)
		end
	end

	if nThisServerId == nServerId and not bAwarded then
		if tbStatueInfoList then
			Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_final_1)
			Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_g_final_1)
		else
			Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_g_final_10)
			Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_final_10)
		end
		local tbAward = self.tbFinalWinnerAward[nRank] or self.tbFinalWinnerAward[2]
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[2]
		if tbAward then
			local tbMail = 
			{
				To = nPlayerId,
				Title = string.format("Tuyển mỹ trận chung kết %s", tbMailInfo.szName),
				Text = string.format("    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D] Thứ %s Tên [-]\n    Chúc mừng giai nhân! Ngươi khuynh quốc khuynh thành dung mạo cùng mị lực đạt được võ lâm tán thành, bị bình chọn vì [FF69B4]「Võ lâm %s Mỹ nữ」[-]%s\n    [FFFE0D] Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.[-]\n    [00FF00][url=openBeautyUrl:Xem xét bình chọn kết quả, %s]\n    [url=openBeautyUrl:Xem xét ta giao diện, %s][-]", "Trận chung kết ( Vượt phục bình chọn )", 
							Lib:Transfer4LenDigit2CnNum(nRank), tbMailInfo.szTitle,
							nStatusTemplate and string.format(", ngươi pho tượng đã ở [00ff00][url=npc:Tương Dương thành, %d, 10][-] Dựng nên, lấy cung cấp người khác thấy phương dung.", nStatusTemplate) or ".",
							self.szMainEntryUrl, string.format(self.szPlayerUrl, nPlayerId, nServerId)),
				From = "「Tuyển mỹ đại hội người chủ trì」Tử Hiên",
				nLogReazon = Env.LogWay_BeautyPageant_Winner,
				tbAttach = tbAward,
			}

			Mail:SendSystemMail(tbMail);
			tbFinalWinnerList[nRank].bAwarded = true;
		else
			Log("[Error]", "BeautyPageant", "_OnFinalWinnerResult", "Not Award", nRank, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
		end
	end
	
	self:SaveActivityData();

	--如果名单齐了发最新消息
	if Lib:CountTB(tbFinalWinnerList) >= 10 then
		self:AddFinalResultInfo()
	end
end

function tbAct:_OnLocalWinnerResult(nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "BeautyPageant", "_OnLocalWinnerResult", "Not This Server", nThisServerId, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
		return
	end

	local nRank = nWinnerType - self.WINNER_TYPE.LOCAL_1 + 1;
	local tbData = self:GetActivityData();
	local tbLocalWinnerList = tbData.tbLocalWinnerList
	local bAwarded = false;
	local tbOldWinnerInfo = tbLocalWinnerList[nRank]

	if tbOldWinnerInfo then
		bAwarded = tbOldWinnerInfo.bAwarded
		Lib:LogTB(tbOldWinnerInfo);
		Log("[Warning]", "BeautyPageant", "_OnLocalWinnerResult", "Over Write Cur Data", nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded))
	end

	tbLocalWinnerList[nRank] =
	{
		nWinnerType = nWinnerType,
		nRank = nRank,
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
		nTime = GetTime(),
	}

	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	local nStatusTemplate
	if tbStatueInfoList then
		for _, tbStatueInfo in pairs( tbStatueInfoList ) do
			nStatusTemplate = tbStatueInfo.nTemplateId
			if tbOldWinnerInfo then
				self:RemoveStatue(tbOldWinnerInfo, tbStatueInfo)
			end
			self:AddStatue(tbLocalWinnerList[nRank], tbStatueInfo)
		end
	end

	--前3名进入决赛
	if nRank <= 3 then
		local tbData = self:GetActivityData();
		--有效时间到决赛比赛结束时间
		tbData.tbSignList[nPlayerId] = self.STATE_TIME[self.STATE_TYPE.FINAL][2]
		self:SaveActivityData();
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
		if pPlayer then
			pPlayer.CallClientScript("Activity.BeautyPageant:SyncIsSignUp", tbData.tbSignList[nPlayerId]);
		end
		self:SendSignUpItem(nPlayerId, self.STATE_TYPE.FINAL)
	end

	if not bAwarded then
		if tbStatueInfoList then
			Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_hx_1)
			Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_g_hx_1)
		else
			Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_hx_10)
		end

		local tbAward = self.tbLocalWinnerAward[nRank] or self.tbLocalWinnerAward[2]
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[2]
		if tbAward then
			local tbMail = 
			{
				To = nPlayerId,
				Title = string.format("Tuyển mỹ hải tuyển thi đấu %s", tbMailInfo.szName),
				Text = string.format("    Ngươi tại %s Cuối cùng xếp hạng: [FFFE0D] Thứ %s Tên [-]\n    Chúc mừng giai nhân! Ngươi khuynh quốc khuynh thành dung mạo cùng mị lực đạt được võ lâm tán thành, bị bình chọn vì [FF69B4]「Bản phục %s Mỹ nữ」[-]%s\n    [FFFE0D] Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.[-]\n    [00FF00][url=openBeautyUrl:Xem xét bình chọn kết quả, %s]\n    [url=openBeautyUrl:Xem xét ta giao diện, %s][-]", "Hải tuyển thi đấu ( Bản phục bình chọn )", 
							Lib:Transfer4LenDigit2CnNum(nRank), tbMailInfo.szTitle,
							nStatusTemplate and string.format(", ngươi pho tượng đã ở [00ff00][url=npc:Tương Dương thành, %d, 10][-] Dựng nên, lấy cung cấp người khác thấy phương dung.", nStatusTemplate) or "。",
							self.szMainEntryUrl, string.format(self.szPlayerUrl, nPlayerId, nServerId)),
				From = "「Tuyển mỹ đại hội người chủ trì」Tử Hiên",
				nLogReazon = Env.LogWay_BeautyPageant_Winner,
				tbAttach = tbAward,
			}

			Mail:SendSystemMail(tbMail);

			tbLocalWinnerList[nRank].bAwarded = true;
		else
			Log("[Error]", "BeautyPageant", "_OnLocalWinnerResult", "Not Award", nRank, nWinnerType, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
		end
	end

	self:SaveActivityData();

	--如果名单齐了发最新消息
	if Lib:CountTB(tbLocalWinnerList) >= 10 then
		self:AddLocalResultInfo()
	end
end

function tbAct:_OnParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "BeautyPageant", "_OnParticipateWinnerResult", "Not This Server", nThisServerId, nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
		return
	end

	local tbData = self:GetActivityData();
	local tbParticipateWinnerList = tbData.tbParticipateWinnerList
	local bAwarded = false;

	if tbParticipateWinnerList[nPlayerId] then
		bAwarded = tbParticipateWinnerList[nPlayerId].bAwarded
		Lib:LogTB(tbParticipateWinnerList[nPlayerId]);
		Log("[Warning]", "BeautyPageant", "_OnParticipateWinnerResult", "Over Write Cur Data", nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded))
	end

	tbParticipateWinnerList[nPlayerId] = 
	{
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
	}

	if not bAwarded then
		local tbMail = 
		{
			To = nPlayerId,
			Title = "Tuyển mỹ lấy được ném 199 Phiếu ban thưởng",
			Text = string.format("    Ngươi tại hải tuyển thi đấu ( Bản phục bình chọn ) Đến số phiếu vượt qua [FFFE0D]199[-]\n    Chúc mừng giai nhân! Ngươi tại hải tuyển thi đấu bên trong nhận lấy đông đảo hiệp sĩ hâm mộ, [FF69B4]「Người gặp người thích, hoa gặp hoa nở」[-] Dùng với hình dung ngươi cũng không đủ, tuyển mỹ đại hội riêng ngươi chuẩn bị một chút ban thưởng, mời kiểm tra và nhận phụ kiện.\n    [FFFE0D] Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.[-]\n    [00FF00][url=openBeautyUrl:Xem xét bình chọn kết quả, %s]\n    [url=openBeautyUrl:Xem xét ta giao diện, %s][-]",
				self.szMainEntryUrl, string.format(self.szPlayerUrl, nPlayerId, nServerId)),
			From = "「Tuyển mỹ đại hội người chủ trì」Tử Hiên",
			nLogReazon = Env.LogWay_BeautyPageant_Winner,
			tbAttach = self.tbParticipateAward,
		}

		Mail:SendSystemMail(tbMail);

		tbParticipateWinnerList[nPlayerId].bAwarded = true;

		Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_hx_vote, 199)
	end

	self:SaveActivityData();
end

function tbAct:_OnFinalParticipateWinnerResult(nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
	local nThisServerId = GetServerIdentity()
	if nThisServerId ~= nServerId then
		Log("[Error]", "BeautyPageant", "_OnFinalParticipateWinnerResult", "Not This Server", nThisServerId, nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId)
		return
	end

	local tbData = self:GetActivityData();
	local tbFinalParticipateWinnerList = tbData.tbFinalParticipateWinnerList
	local bAwarded = false;

	if tbFinalParticipateWinnerList[nPlayerId] then
		bAwarded = tbFinalParticipateWinnerList[nPlayerId].bAwarded
		Lib:LogTB(tbFinalParticipateWinnerList[nPlayerId]);
		Log("[Warning]", "BeautyPageant", "_OnFinalParticipateWinnerResult", "Over Write Cur Data", nRank, nServerId, szServerName, nPlayerId, szPlayerName, nFaction, nArmorResId, nWeaponResId, tostring(bAwarded))
	end

	tbFinalParticipateWinnerList[nPlayerId] = 
	{
		nServerId = nServerId,
		szServerName = szServerName,
		nPlayerId = nPlayerId,
		szPlayerName = szPlayerName,
		nFaction =nFaction,
		nArmorResId = nArmorResId,
		nWeaponResId = nWeaponResId,
		bAwarded = bAwarded,
	}

	if not bAwarded then
		local tbMail = 
		{
			To = nPlayerId,
			Title = "Tuyển mỹ lấy được ném 8000 Phiếu ban thưởng",
			Text = string.format("    Ngươi tại trận chung kết ( Vượt phục bình chọn ) Đến số phiếu vượt qua [FFFE0D]8000[-]\n    Chúc mừng giai nhân! Ngươi tại trong trận chung kết nhận lấy đông đảo hiệp sĩ hâm mộ, [FF69B4]「Người gặp người thích, hoa gặp hoa nở」[-] Dùng với hình dung ngươi cũng không đủ, tuyển mỹ đại hội riêng ngươi chuẩn bị một chút ban thưởng, mời kiểm tra và nhận phụ kiện.\n    [FFFE0D] Hồng bao ban thưởng đã cấp cho, mời tiến về bang phái hồng bao giới mặt xem xét.[-]\n    [00FF00][url=openBeautyUrl: Xem xét bình chọn kết quả, %s]\n    [url=openBeautyUrl: Xem xét ta giao diện, %s][-]",
				self.szMainEntryUrl, string.format(self.szPlayerUrl, nPlayerId, nServerId)),
			From = "「Tuyển mỹ đại hội người chủ trì」Tử Hiên",
			nLogReazon = Env.LogWay_BeautyPageant_Winner,
			tbAttach = self.tbFinalParticipateAward,
		}

		Mail:SendSystemMail(tbMail);

		tbFinalParticipateWinnerList[nPlayerId].bAwarded = true;

		Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_final_vote, 8000)
		Kin:RedBagOnEvent(nPlayerId, Kin.tbRedBagEvents.beauty_g_final_vote, 8000)
	end

	self:SaveActivityData();
end

function tbAct:AddStatue(tbWinnerInfo, tbStatueInfo)
	local tbPos = tbStatueInfo.pos;

	local pNpc = KNpc.Add(tbStatueInfo.nTemplateId, 1, -1, tbPos[1], tbPos[2], tbPos[3], false, tbStatueInfo.nDir);
	if not pNpc then
		Lib:LogTB(tbWinnerInfo)
		Lib:LogTB(tbStatueInfo)
		Log("[Error]", "BeautyPageant", "AddStatue Failed");
		return
	end

	pNpc.tbWinnerInfo = tbWinnerInfo;
	pNpc.tbStatueInfo = tbStatueInfo;

	pNpc.SetName(tbWinnerInfo.szPlayerName);
	pNpc.SetTitleID(tbStatueInfo.nTitleId);

	--[[if not tbWinnerInfo.bNewRes then
		tbWinnerInfo.bNewRes = true
		local tbResReplace = LoadTabFile("Setting/Npc/Res/ReplacePartBody.tab", "ddd", "OldBodyResID", {"OldBodyResID", "NewBodyResID", "NewHeadResID"});
		if tbWinnerInfo.nArmorResId and tbWinnerInfo.nArmorResId > 0 then
			local OldBodyResID = tbWinnerInfo.nArmorResId;
			if tbResReplace[OldBodyResID] then
				tbWinnerInfo.nArmorResId = tbResReplace[OldBodyResID].NewBodyResID;
				tbWinnerInfo.nHeadResId = tbResReplace[OldBodyResID].NewHeadResID;
			else
				tbWinnerInfo.nArmorResId = nil
			end
		end
		self:SaveActivityData()
	end]]

	local nSex = Player:Faction2Sex(tbWinnerInfo.nFaction);
	local nResId , tbPartRes = KPlayer.GetNpcResId(tbWinnerInfo.nFaction, nSex);
	local nBodyResId = tbPartRes[Npc.NpcResPartsDef.npc_part_body] or 0;
	local nWeaponResId = tbPartRes[Npc.NpcResPartsDef.npc_part_weapon] or 0;
	local nHeadResId = tbPartRes[Npc.NpcResPartsDef.npc_part_head] or 0;
	if tbWinnerInfo.nArmorResId and tbWinnerInfo.nArmorResId > 0 then
		nBodyResId = tbWinnerInfo.nArmorResId;
	end

	if tbWinnerInfo.nWeaponResId and tbWinnerInfo.nWeaponResId > 0 then
		nWeaponResId = tbWinnerInfo.nWeaponResId;
	end

	if tbWinnerInfo.nHeadResId and tbWinnerInfo.nHeadResId > 0 then
		nHeadResId = tbWinnerInfo.nHeadResId;
	end

	pNpc.ChangeFeature(nResId, Npc.NpcResPartsDef.npc_part_body, nBodyResId);
	pNpc.ChangeFeature(nResId, Npc.NpcResPartsDef.npc_part_weapon, nWeaponResId);
	pNpc.ChangeFeature(nResId, Npc.NpcResPartsDef.npc_part_head, nHeadResId);
	if tbStatueInfo.nDir then
		pNpc.SetDir(tbStatueInfo.nDir);
	end
end

function tbAct:RemoveStatue(tbWinnerInfo, tbStatueInfo)
	local tbPosInfo = tbStatueInfo.pos;

	local tbNpcList,_ = KNpc.GetMapNpc(tbPosInfo[1])

	for _, pNpc in pairs(tbNpcList) do
		if pNpc.nTemplateId == tbStatueInfo.nTemplateId and 
			pNpc.tbWinnerInfo and pNpc.tbWinnerInfo.nServerId == tbWinnerInfo.nServerId and
			pNpc.tbWinnerInfo.nPlayerId == tbWinnerInfo.nPlayerId then

			pNpc.Delete();
		end
	end
end

function tbAct:OnBuyDailyGift(pPlayer, nGroupIndex, nBuyCount)
	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end

	local nCount = self.DailyGiftVote[nGroupIndex];
	if not nCount or nCount <= 0 then
		Log("[Error]", "BeautyPageant", "Wrong Daily Gift Vote Count", pPlayer.dwID, pPlayer.szName, nGroupIndex, nBuyCount);
		return
	end

	local tbFinalTime = self.STATE_TIME[self.STATE_TYPE.FINAL]

	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount * nBuyCount, tbFinalTime[2]}}, true, true, Env.LogWay_BeautyPageant_Recharge);
end

function tbAct:OnBuyDaysCard(pPlayer, nGroupIndex)
	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end

	local nCount = self.DaysCardVote[nGroupIndex];
	if not nCount or nCount <= 0 then
		Log("[Error]", "BeautyPageant", "Wrong Days Card Vote Count", pPlayer.dwID, pPlayer.szName, nGroupIndex);
		return
	end

	local tbFinalTime = self.STATE_TIME[self.STATE_TYPE.FINAL]

	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount, tbFinalTime[2]}}, true, true, Env.LogWay_BeautyPageant_Recharge);

end

function tbAct:OnRechargeGold(pPlayer, nRMB)
	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end

	local nCount = math.ceil(nRMB / self.nRechargeGoldVote);
	if not nCount or nCount <= 0 then
		Log("[Error]", "BeautyPageant", "Wrong Recharge Gold Vote Count", pPlayer.dwID, pPlayer.szName, nRMB);
		return
	end

	local tbFinalTime = self.STATE_TIME[self.STATE_TYPE.FINAL]

	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount, tbFinalTime[2]}}, true, true, Env.LogWay_BeautyPageant_Recharge);
end

function tbAct:OnAddOrgMoney(pPlayer, szType, nPoint, nLogReazon, nLogReazon2)
	if szType ~= "SilverBoard" then
		return
	end

	local nState = self:GetCurState()
	if nState < self.STATE_TYPE.SIGN_UP or nState > self.STATE_TYPE.FINAL then
		return
	end

	local nCount = math.ceil(nPoint / self.nRechargeSilverBoardVote);

	if not nCount or nCount <= 0 then
		Log("[Error]", "BeautyPageant", "Wrong Recharge SilverBoard Vote Count", pPlayer.dwID, pPlayer.szName, nPoint);
		return
	end

	local tbFinalTime = self.STATE_TIME[self.STATE_TYPE.FINAL]

	pPlayer.SendAward({{"item", self.VOTE_ITEM, nCount, tbFinalTime[2]}}, true, true, Env.LogWay_BeautyPageant_Recharge);
end

function tbAct:OnEnterMap(pPlayer, nMapTemplateId, nMapId)
	if nMapTemplateId ~= 10 and nMapTemplateId ~= 15 then
		return
	end

	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local tbLocalWinnerList = tbData.tbLocalWinnerList
	local bStatue = false
	for nRank,tbWinnerInfo in pairs(tbFinalWinnerList) do
		local tbStatueInfo = self.tbStatueInfo[tbWinnerInfo.nWinnerType]
		if tbStatueInfo then
			bStatue = true
			break;
		end
	end

	if not bStatue then
		for nRank,tbWinnerInfo in pairs(tbLocalWinnerList) do
			local tbStatueInfo = self.tbStatueInfo[tbWinnerInfo.nWinnerType]
			if tbStatueInfo then
				bStatue = true
				break;
			end
		end
	end

	if bStatue then
		pPlayer.CallClientScript("Activity.BeautyPageant:OnSynMiniMainMapInfo")
	end
end


function tbAct:SendSignUpItem(nPlayerId, nType)
	local tbMail = Lib:CopyTB(tbAct.tbSignUpMail[nType])
	if not tbMail then
		Log("[Error]", "BeautyPageant", "SendSignUpItem No Mail Template", nPlayerId, nType);
		return
	end

	tbMail.To = nPlayerId;
	tbMail.Text = string.format(tbMail.Text, nPlayerId, Sdk:GetServerId())

	Mail:SendSystemMail(tbMail);
end

function tbAct:AddVoteCount(pPlayer, nCount)
	self:CheckPlayerData(pPlayer);
	local nCurCount = pPlayer.GetUserValue(self.SAVE_GROUP, self.VOTE_COUNT)
	pPlayer.SetUserValue(self.SAVE_GROUP, self.VOTE_COUNT, nCurCount + nCount)
	pPlayer.CallClientScript("Activity.BeautyPageant:OnRefreshVotedAward");
end

function tbAct:IsLocalWinner(nPlayerId)
	local tbData = self:GetActivityData();
	local tbLocalWinnerList = tbData.tbLocalWinnerList;
	if not tbLocalWinnerList then
		return
	end

	for nRank,tbWinnerInfo in pairs(tbLocalWinnerList) do
		if tbWinnerInfo.nPlayerId == nPlayerId then
			return nRank
		end
	end
end

function tbAct:IsFinalWinner(nPlayerId)
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList;
	if not tbFinalWinnerList then
		return
	end

	local nThisServerId = GetServerIdentity()

	for nRank,tbWinnerInfo in pairs(tbFinalWinnerList) do
		if tbWinnerInfo.nServerId == nThisServerId and tbWinnerInfo.nPlayerId == nPlayerId then
			return nRank
		end
	end
end

function tbAct:IsParticipateWinner(nPlayerId)
	local tbData = self:GetActivityData();
	local tbParticipateWinnerList = tbData.tbParticipateWinnerList;
	if not tbParticipateWinnerList then
		return
	end

	return tbParticipateWinnerList[nPlayerId]
end

function tbAct:IsFinalParticipateWinner(nPlayerId)
	local tbData = self:GetActivityData();
	local tbFinalParticipateWinnerList = tbData.tbFinalParticipateWinnerList;
	if not tbFinalParticipateWinnerList then
		return
	end

	return tbFinalParticipateWinnerList[nPlayerId]
end

function tbAct:OnServerStart()
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local tbLocalWinnerList = tbData.tbLocalWinnerList
	local nNow = GetTime()
	--如果有冠军数据立雕像
	for _,tbWinnerInfo in pairs(tbFinalWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType]
		if tbStatueInfoList then
			for _, tbStatueInfo in pairs( tbStatueInfoList ) do
				self:AddStatue(tbWinnerInfo, tbStatueInfo)
			end
		end
	end
	for _,tbWinnerInfo in pairs(tbLocalWinnerList) do
		local tbStatueInfoList = self.tbStatueInfo[tbWinnerInfo.nWinnerType]
		if tbStatueInfoList and tbWinnerInfo.nTime + self.nLocalStatueTimeOut > nNow then
			for _, tbStatueInfo in pairs( tbStatueInfoList ) do
				self:AddStatue(tbWinnerInfo, tbStatueInfo)
			end
		end
	end
end

function tbAct:AddLocalResultInfo()
	local tbData = self:GetActivityData();
	local tbLocalWinnerList = tbData.tbLocalWinnerList
	local  szContent = [[
「Võ lâm đệ nhất mỹ nữ bình chọn」[FFFE0D] Hải tuyển thi đấu ( Bản phục bình chọn )[-] Đã kết thúc, chúc mừng trở xuống thập cường giai nhân!
]]

	for nRank,tbWinnerInfo in ipairs(tbLocalWinnerList) do
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[2]
		local pStayInfo = KPlayer.GetRoleStayInfo(tbWinnerInfo.nPlayerId)
		local pKinData = Kin:GetKinById((pStayInfo and pStayInfo.dwKinId) or 0);
		szContent = string.format("%s\n[FFFE0D]%s[-]Giai nhân: [C8FF00]%s[-]Bang phái: [C8FF00]%s[-][00FF00][url=openBeautyUrl:Xem xét tư liệu, %s][-]", szContent, Lib:StrFillL(string.format("Thứ %s Tên", Lib:TransferDigit2CnNum(nRank)), 18, " "), Lib:StrFillL(tbWinnerInfo.szPlayerName, 18, " "), Lib:StrFillL((pKinData and pKinData.szName) or "--", 18, " "), string.format(self.szPlayerUrl, tbWinnerInfo.nPlayerId, tbWinnerInfo.nServerId))
	end

	local tbStatueInfo = self.tbStatueInfo[self.WINNER_TYPE.LOCAL_1][1]
	szContent = string.format("%s\n\n[FFFE0D]「Bản phục đệ nhất mỹ nữ」[-]Pho tượng đã ở [00ff00][url=npc: Tương Dương thành, %d, 10][-] Dựng nên, các vị hiệp sĩ nhanh đi thấy phương dung đi!\n Chúc mừng [FFFE0D] Trước 3 Tên [-] Giai nhân nhập vây trận chung kết, trận chung kết đem với [FFFE0D]%s[-] Bắt đầu.", szContent, tbStatueInfo.nTemplateId, Lib:TimeDesc10(self.STATE_TIME[self.STATE_TYPE.FINAL][1]))

	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("BeautyPageantAct_LocalResult", nEndTime, {szContent},{szTitle="Bản phục thập đại mỹ nữ", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 3})	
end

function tbAct:AddFinalResultInfo()
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local  szContent = [[
「Võ lâm đệ nhất mỹ nữ bình chọn」[FFFE0D] Trận chung kết ( Vượt phục bình chọn ) Đã kết thúc [-], chúc mừng trở xuống thập cường giai nhân!
]]

	for nRank,tbWinnerInfo in ipairs(tbFinalWinnerList) do
		local tbMailInfo = self.tbWinnerMailInfo[nRank] or self.tbWinnerMailInfo[2]
		szContent = string.format("%s\n[FFFE0D]%s[-]Giai nhân: [C8FF00]%s[-]Đến từ: [C8FF00]%s[-][00FF00][url=openBeautyUrl:Xem xét tư liệu, %s][-]", szContent, Lib:StrFillL(string.format("Thứ %s Tên", Lib:TransferDigit2CnNum(nRank)), 18, " "), Lib:StrFillL(tbWinnerInfo.szPlayerName, 18, " "), Lib:StrFillL(tbWinnerInfo.szServerName, 24, " "), string.format(self.szPlayerUrl, tbWinnerInfo.nPlayerId, tbWinnerInfo.nServerId))
	end

	local tbStatueInfo = self.tbStatueInfo[self.WINNER_TYPE.FINAL_1][1]
	szContent = string.format("%s\n\n[FFFE0D]「Võ lâm đệ nhất mỹ nữ」[-]Pho tượng đã ở [00ff00][url=npc: Tương Dương thành, %d, 10][-] Dựng nên, các vị hiệp sĩ nhanh đi thấy phương dung đi!", szContent, tbStatueInfo.nTemplateId)

	local nStartTime, nEndTime = self:GetOpenTimeInfo()
	NewInformation:AddInfomation("BeautyPageantAct_FinalResult", nEndTime, {szContent},{szTitle="Võ lâm thập đại mỹ nữ", nReqLevel = self.LEVEL_LIMIT,
						 nShowPriority = 4})	
end

function tbAct:AwardFinalParticipateFromFile()

	Log("AwardFinalParticipateFromFile")

	local nThisServerId = GetServerIdentity()
	local tbList = LoadTabFile("FinalParticipate.tab", "dsnsddd", nil, {"ServerId", "ServerName", "PlayerId", "PlayerName", "Faction", "ArmorResId", "WeaponResId"}, 1, 1) or {};
	for _,tbInfo in pairs(tbList) do
		if nThisServerId == tbInfo.ServerId then

			self:_OnFinalParticipateWinnerResult(tbInfo.ServerId, tbInfo.ServerName, tbInfo.PlayerId, tbInfo.PlayerName,
					 tbInfo.Faction, tbInfo.ArmorResId, tbInfo.WeaponResId)

			Log("_OnFinalParticipateWinnerResult", tbInfo.ServerId, tbInfo.ServerName, tbInfo.PlayerId, tbInfo.PlayerName, tbInfo.Faction, tbInfo.ArmorResId, tbInfo.WeaponResId)
		end
	end
end

function tbAct:UpdateStatueInfo(pPlayer, nWinnerType)
	local tbStatueInfoList = self.tbStatueInfo[nWinnerType]
	if not tbStatueInfoList then
		return
	end
	local tbData = self:GetActivityData();
	local tbFinalWinnerList = tbData.tbFinalWinnerList
	local tbLocalWinnerList = tbData.tbLocalWinnerList

	local nRank = 1;
	local tbWinnerInfo = tbLocalWinnerList[nRank];
	if nWinnerType == self.WINNER_TYPE.FINAL_1 then
		tbWinnerInfo = tbFinalWinnerList[nRank];
	end

	if not tbWinnerInfo then
		return
	end

	tbWinnerInfo.szPlayerName = pPlayer.szName;
	tbWinnerInfo.nFaction = pPlayer.nFaction

	local tbEquipInfo = KPlayer.GetInfoFromAsyncData(pPlayer.dwID);

	if tbEquipInfo then
		local tbWeapon = tbEquipInfo[Item.EQUIPPOS_WEAPON]
		local tbArmor = tbEquipInfo[Item.EQUIPPOS_BODY]
		local tbHead = tbEquipInfo[Item.EQUIPPOS_HEAD]

		local tbWaiWeapon = tbEquipInfo[Item.EQUIPPOS_WAI_WEAPON]
		local tbWaiArmor = tbEquipInfo[Item.EQUIPPOS_WAIYI]
		local tbWaiHead = tbEquipInfo[Item.EQUIPPOS_WAI_HEAD]

		if tbWeapon then
			tbWinnerInfo.nWeaponResId = tbWeapon.nShowResId
		end

		if tbArmor then
			tbWinnerInfo.nArmorResId = tbArmor.nShowResId
		end

		if tbWaiWeapon then
			tbWinnerInfo.nWeaponResId = tbWaiWeapon.nShowResId
		end

		if tbWaiArmor then
			tbWinnerInfo.nArmorResId = tbWaiArmor.nShowResId
		end

		if tbWaiHead then
			tbWinnerInfo.nHeadResId = tbWaiHead.nShowResId
		elseif tbHead then
			tbWinnerInfo.nHeadResId = tbHead.nShowResId
		else
			local _ , tbPartRes = KPlayer.GetNpcResId(tbWinnerInfo.nFaction, pPlayer.nSex);
			tbWinnerInfo.nHeadResId = tbPartRes[Npc.NpcResPartsDef.npc_part_head] or 0;
		end
	end

	for _, tbStatueInfo in pairs( tbStatueInfoList ) do
		self:RemoveStatue(tbWinnerInfo, tbStatueInfo)
		self:AddStatue(tbWinnerInfo, tbStatueInfo)
	end
	pPlayer.SendBlackBoardMsg("Thành công đổi mới pho tượng hình tượng");
end
