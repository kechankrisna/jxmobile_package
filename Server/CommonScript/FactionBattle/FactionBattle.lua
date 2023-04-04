FactionBattle.FactionMonkey = FactionBattle.FactionMonkey or {}

-- 大师兄相关

FactionBattle.MONKEY_VOTE_TIME = 24 		   			-- 活动开启后允许投票的小时
FactionBattle.MONKEY_SESSION_LIMIT_COUNT = 3 	   		-- 举行超过几届门派竞技开始
FactionBattle.MONKEY_START_DAY = 1 						-- 活动每月几号开启
FactionBattle.MONKEY_END_DAY = 2 						-- 活动每月几号结束

FactionBattle.tbHonorVoteScore = 						-- 每票 头衔得分
{
	[0] = 1,
	[1] = 1,
	[2] = 2,
	[3] = 4,
	[4] = 8,
	[5] = 16,
	[6] = 32,
	[7] = 64,
	[8] = 128,
	[9] = 256,
	[10] = 256,
	[11] = 256,	
	[12] = 512,
	[13] = 512,
	[14] = 512,
	[15] = 1024,
	[16] = 1024,
	[17] = 1024,
	[18] = 1024,
	[19] = 1024,
	[20] = 2048,
	[21] = 4096,
}

FactionBattle.tbFactionMonkeyReward = {{"Item", 3358, 1}}

FactionBattle.MAX_VOTE 	 = 1 							-- 最大投票次数

FactionBattle.MONKEY_TITLE_ID = 						-- 大师兄称号ID
{
	[1] = {311, 380},
	[2] = {314, 314},
	[3] = {313, 313},
	[4] = {312, 386},
	[5] = {315, 367},
	[6] = {316, 316},
	[7] = {317, 317},
	[8] = {318, 318},
	[9] = {319, 319},
	[10] = {373, 320},
	[11] = {322, 322},
	[12] = {324, 324},
	[13] = {326, 326},
	[14] = {328, 328},
	[15] = {330, 331},
	[16] = {365, 366},
	[17] = {371, 372},
	[18] = {378, 379},
	[19] = {384, 385},
}

FactionBattle.MONKEY_TITLE_TIMEOUT = 30 * 24 * 60 * 60 	-- 称号过期时间

FactionBattle.nNewInfomationValidTime = 7 * 24 * 60 * 60 	-- 最新消息过期时间（距离推送时间）

FactionBattle.tbMailSetting =
{
	[1] = {szTitle = "Thư Chúc Mừng",szText = "    Làm tốt lắm, từ nay về sau hãy cố gắng hơn nữa để có thể trở thành hào kiệt. Nên nhớ, hãy hòa đồng với các đồng môn của mình."},
	[2] = {szTitle = "Thư Chúc Mừng",szText = "    Nga Mi xưa nay coi việc giúp người làm tôn chỉ, nay ngươi trở thành đại sư tỷ của Nga Mi, cũng nên lấy đại cục làm trọng."},
	[3] = {szTitle = "Thư Chúc Mừng",szText = "    Đào Hoa ta có được nhân tài ưu tú như ngươi thật đáng vui mừng, nay ngươi trở thành đại sư tỷ của Đào Hoa, võ nghệ hơn hẳn các đồng môn, nhưng không nên vì vậy mà tự kiêu, phải giao lưu với các tỷ muội, sự phát triển của Đào Hoa đều nhờ vào nỗ lực của các ngươi."},
	[4] = {szTitle = "Thư Chúc Mừng",szText = "    Thân là đại sư huynh, làm gì cũng phải giỏi hơn các đồng môn, việc này tuy khó, nhưng môn đệ của ta đều phải vậy!"},
	[5] = {szTitle = "Thư Chúc Mừng",szText = "    Nay chiến hỏa lan tràn, thiên hạ đại loạn, có được đệ tử kiệt xuất như ngươi thật khiến lão đạo vui mừng, chức chưởng môn sau này sẽ chọn trong số những người trẻ tuổi các ngươi, mong ngươi chăm tập võ công, tu tâm dưỡng tánh, không được quá tự phụ. "},
	[6] = {szTitle = "Thư Chúc Mừng",szText = "    Ngươi đã nắm bắt được tinh túy của Thiên Nhẫn ta, sau này khi đã thành thục, ngươi sẽ là chủ lực của Thiên Nhẫn."},
	[7] = {szTitle = "Thư Chúc Mừng",szText = "    A Di Đà Phật. Nay ngươi tu tập đã thành, nhưng phải tu tâm dưỡng tính, đề phòng Tâm Ma, thường xuyên hướng dẫn đồng môn, không ngừng rèn luyện."},
	[8] = {szTitle = "Thư Chúc Mừng",szText = "    Tài nghệ ngươi ngày càng thuần thục, vượt trội so với đồng môn. Hành tẩu giang hồ phải cẩn thận, hãy chăm sóc đồng hành thật tốt."},
	[9] = {szTitle = "Thư Chúc Mừng",szText = "   Là đệ tử của Đường Môn, góp công sức vì danh tiếng của Đường Môn trong võ lâm là chuyện cần làm. Nên nhớ là nếu ngươi trở thành Danh Hiệp thì Đường Môn ta xem như đã tiến một bước vào võ lâm."},
	[10] = {szTitle = "Thư Chúc Mừng",szText = "   Khá lắm, Côn Lôn ta xem như đã có được một nhân tài. Ngươi tu luyện đã lâu, có được thành tích như ngày hôm nay là chuyện đương nhiên, hãy tiếp tục hành tẩu giang hồ, sau này nhất định sẽ là một nhân tài xuất chúng."},
	[11] = {szTitle = "Thư Chúc Mừng",szText = "   Cái Bang từ khi thành lập đã luôn là thiên hạ đệ nhất, với số lượng thành viên đông đảo và võ công xuất chúng, nếu ngươi có thể gia nhập thì sẽ giúp ích rất nhiều."},
	[12] = {szTitle = "Thư Chúc Mừng",szText = "   Hừ, võ lâm trung nguyên luôn xem thường Ngũ Độc Giáo ta, giờ đây võ nghệ của ngươi đã luyện thành, hãy cho đám trung nguyên ấy nếm mùi lợi hại! Mọi chuyện đều phải cẩn thận đấy!"},
	[13] = {szTitle = "Thư Chúc Mừng",szText = "   Tàng Kiếm Sơn Trang nổi danh võ lâm, võ học cao thâm, nay đại hiệp gánh trọng trách của Tàng Kiếm, mong đại hiệp có thể hành hiệp trượng nghĩa, không phụ bốn chữ Tàng Kiếm Sơn Trang."},
	[14] = {szTitle = "Thư Chúc Mừng",szText = "   Trường Ca vốn do văn nhân sáng lập, võ công độc đáo, nay tuy đại hiệp đã đứng đầu môn phái nhưng vẫn mong đại có thể chăm chỉ luyện tập võ nghệ, làm rạng danh môn phái."},
	[15] = {szTitle = "Thư Chúc Mừng",szText = "  Võ công bổn phái hội tụ điểm mạnh các phái, nhưng vì nằm ở nơi xa, ít người biết đến. Nay ngươi là người có võ công cao nhất trong phái, nhớ cố gắng tu luyện, giúp bổn phái vang danh."},
	[16] = {szTitle = "Thư Chúc Mừng",szText = "   Ha ha, Bá Đao Sơn Trang ta có được đệ tử xuất sắc như ngươi quả là phước phần của sơn trang ta."},
	[17] = {szTitle = "Thư Chúc Mừng",szText = "   Nay chiến hỏa lan tràn, thiên hạ đại loạn, có được đệ tử kiệt xuất như ngươi thật khiến lão đạo vui mừng, chức chưởng môn sau này sẽ chọn trong số những người trẻ tuổi các ngươi, mong ngươi chăm tập võ công, tu tâm dưỡng tánh, không được quá tự phụ. "},
	[18] = {szTitle = "Thư Chúc Mừng",szText = "   Thời thế loạn lạc, phái ta có được đệ tử tài giỏi như ngươi quả thật đáng mừng. Mong rằng sau này ngươi hãy cố gắng luyện tập võ công, tu tâm dưỡng tính để không phụ lòng ta."},
	[19] = {szTitle = "Thư Chúc Mừng",szText = "   Thời thế loạn lạc, phái ta có được đệ tử tài giỏi như ngươi quả thật đáng mừng. Mong rằng sau này ngươi hãy cố gắng luyện tập võ công, tu tâm dưỡng tính để không phụ lòng ta."},
}

--门派大师兄聊天前缀
FactionBattle.MonkeyNamePrefix =
{
	[1] = {"#964","#857"},
	[2] = {"#963","#963"},
	[3] = {"#961","#961"},
	[4] = {"#962","#854"},
	[5] = {"#960","#929"},
	[6] = {"#959","#959"},
	[7] = {"#957","#957"},
	[8] = {"#958","#958"},
	[9] = {"#950","#950"},
	[10]= {"#860","#951"},
	[11]= {"#946","#946"}, 
	[12]= {"#947","#947"}, 
	[13]= {"#938","#938"}, 
	[14]= {"#939","#939"}, 
	[15]= {"#934","#933"}, 
	[16]= {"#930","#931"}, 
	[17]= {"#862","#861"}, 
	[18]= {"#855","#856"}, 
	[19]= {"#852","#853"}, 
}

FactionBattle.SAVE_GROUP_MONKEY  = 96
FactionBattle.KEY_VOTE			 = 1
FactionBattle.KEY_STARTTIME		 = 2

function FactionBattle:CheckCommondVote(pPlayer)
	-- 检查投票次数
	if self:RemainVote(pPlayer) <= 0 then
		return false,"Đã hết số lần bỏ phiếu"
	end

	return true
end

function FactionBattle:RemainVote(pPlayer)
	return pPlayer.GetUserValue(FactionBattle.SAVE_GROUP_MONKEY, FactionBattle.KEY_VOTE);
end

function FactionBattle:GetMonkeyNamePrefix(nFaction, nSex)
	local szPrefix = FactionBattle.MonkeyNamePrefix[nFaction] and FactionBattle.MonkeyNamePrefix[nFaction][nSex]
	return szPrefix or ""
end

--活动时间不能跨天
function FactionBattle:IsMonthBattleOpen()
	if not MODULE_ZONESERVER then
		if GetTimeFrameState(self.CROSS_MONTHLY_FRAME) ~= 1 then
			return false
		end
	end
	if Activity:__IsActInProcessByType(WuLinDaHui.szActNameMain) then
		return false
	end
	--每月第一周的周一
	return Lib:IsMonthlyFirstWeekday(1)
end

--活动时间不能跨天
function FactionBattle:IsSeasonBattleOpen()
	if not MODULE_ZONESERVER then
		if GetTimeFrameState(self.CROSS_MONTHLY_FRAME) ~= 1 then
			return false
		end
	end
	if Activity:__IsActInProcessByType(WuLinDaHui.szActNameMain) then
		return false
	end

	local tbTime = Lib:LocalDate("*t", GetTime());

	--每季度的最后一个月
	if tbTime.month ~= 3 and tbTime.month ~= 6 and tbTime.month ~= 9 and tbTime.month ~= 12 then
		return false
	end

	--每月最后一周的周一
	return Lib:IsMonthlyLastWeekday(1)
end

function FactionBattle:GetNameFromCrossType(nCrossType)
	local tbNames = {
		[self.CROSS_TYPE.MONTH] = "Đấu Tháng",
		[self.CROSS_TYPE.SEASON] = "Đấu Quý"
	}
	return tbNames[nCrossType] or "-"
end

function FactionBattle:GetCrossTypeName()
	if self:IsMonthBattleOpen() then
		return "Đấu Tháng", self.CROSS_TYPE.MONTH
	end

	if self:IsSeasonBattleOpen() then
		return "Đấu Quý", self.CROSS_TYPE.SEASON
	end

	return ""
end

function FactionBattle:GetNextMonthlyBattleTime()
	local bTimeFrameOpen = (GetTimeFrameState(self.CROSS_MONTHLY_FRAME) == 1)
	local nTime = (bTimeFrameOpen and GetTime()) or CalcTimeFrameOpenTime(self.CROSS_MONTHLY_FRAME)
	local tbTime = Lib:LocalDate("*t", nTime);

	if not Lib:IsMonthlyFirstWeekday(1, nTime) or Lib:GetLocalDayTime() > Lib:ParseTodayTime("21:00") then

		nTime = os.time(tbTime);
		local nTmpTime = Lib:GetTimeByWeekInMonth(nTime, 1, 1, 21, 0, 0);

		if nTime > nTmpTime then
			tbTime.month = tbTime.month + 1;
			if tbTime.month > 12 then
				tbTime.month = 1;
				tbTime.year = tbTime.year + 1;
			end
			nTime = os.time(tbTime);
		else
			return nTmpTime;
		end
	else
		nTime = os.time({year = tbTime.year, month = tbTime.month, day = tbTime.day, hour = 21, min = 0, sec = 0})
	end
	return Lib:GetTimeByWeekInMonth(nTime, 1, 1, 21, 0, 0);
end

function FactionBattle:GetNextSeasonBattleTime()
	local bTimeFrameOpen = (GetTimeFrameState(self.CROSS_MONTHLY_FRAME) == 1)
	local nTime = (bTimeFrameOpen and GetTime()) or CalcTimeFrameOpenTime(self.CROSS_MONTHLY_FRAME)
	local tbTime = Lib:LocalDate("*t", nTime);
	local nOpenMonth = math.ceil(tbTime.month / 3) * 3;

	if nOpenMonth ~= tbTime.month then
		tbTime.month = nOpenMonth;
		tbTime.day = 1;
		tbTime.hour = 0;
		tbTime.min = 0;
	end

	local nNextTime = os.time(tbTime);
	local nOpenTime = Lib:GetTimeByWeekInMonth(nNextTime, -1, 1, 21, 0, 0);
	if nOpenTime < nTime then
		tbTime.month = nOpenMonth + 3;
		if tbTime.month > 12 then
			tbTime.year = tbTime.year + 1;
			tbTime.month = 3;
		end
	end

	nNextTime = os.time(tbTime);
	return Lib:GetTimeByWeekInMonth(nNextTime, -1, 1, 21, 0, 0);
end
