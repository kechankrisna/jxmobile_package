
local tbOrgQuizs = {
	[1] ="Ai là Bang Chủ?",
	[2] ="Ai là Bang Phó?",
	[3] ="Ai là Trưởng Lão?",
	[4] ="Cấp ai cao nhất?",
	[5] ="Trong Bang Hội, lực chiến ai cao nhất?",
	[6] ="Trong Bang Hội, ai tích lũy cống hiến cao nhất?",
	[7] ="Thành viên nào dưới đây có quân hàm là: ",
	[8] ="Bang Hội hiện có bao nhiêu thành viên Chính Thức?",
	[9] ="Bang Hội hiện có bao nhiêu thành viên Kiến Tập?",
	[10] ="Cấp Bang Hội hiện tại?",
	[11] ="Môn phái nào nhiều nhất trong Bang Hội?",

	[12] ="Trong Hoạt Động Lửa Trại Bang Hội hôm qua ai là người trúng thưởng?", -- khả năng vô hiệu 
	[13] ="ngày hôm qua chạng vạng tối minh chủ võ lâm hoạt động bản bang phái bài danh nhiều ít ？", -- khả năng vô hiệu 
	[14] ="Trong hoạt động Minh Chủ Võ Lâm buổi trưa, Bang Hội xếp hạng mấy?", -- khả năng vô hiệu 
	[15] ="%s của Bang Hội hiện đạt cấp mấy?",
	[16] ="Ai vào Bang Hội gần đây nhất?",

	[17] ="bang phái lý ai đích võ thần điện bài danh tối cao ？", -- vị tố 
	[18] ="Thành viên nào trong Bang Hội gần đây nhất dành Tân Nhân Vương trong Thi Đấu Môn Phái?", -- vị tố 
	[19] ="Trong Bang Hội ai sẽ giành dành hạng 1 Chiến Trường Tống Kim hôm nay?", -- khả năng vô hiệu 
	[20] ="Trong Bang Hội ai sẽ giành chiến thắng Khiêu Chiến Anh hùng vòng 10 hôm nay?", -- khả năng vô hiệu 

	[21] ="Trong Hoạt Động Vận Tiêu Bang Hội hôm qua Tiêu Xa màu gì?", -- khả năng vô hiệu 
	[22] ="Trong Bang Hội ai leo lên tầng 7 Thông Thiên Tháp gần đây nhất?", -- khả năng vô hiệu 
};

local tbRandomName = {
	"HoàiAn","DiệpAnh",
	"BảoAnh","ThùyChi",
	"BạchTuyết","BíchQuân",
	"NgọcOanh","ThuầnHậu",
	"TuyếtXuân","UyênThơ",
	"ThảoChi","QuỳnhDiệp",
	"GiaNhi","HoàngOanh",
	"BìnhMinh","ChấnHùng",
	"ĐăngĐạt","DuyThành",
	"SongHà","AnhTuấn",
	"BảoHoàng","BìnhDương",
	"CôngTráng","ÐắcThái",
	"ÐìnhNam","ÐứcThành",
	"HoàiTrung","HùngCường",
	"KhởiPhong","KimVượng",
	"MinhDanh","NguyênKhôi",

	"QuangKhải","TháiHòa",
	"ThànhDoanh","TrọngNhân",
	"TườngNguyên","ViệtLong",
	"XuânTường","NguyễnKim",
	"HoàngGia","DuyKhải",
	"ThànhLong","HoàngMinh",
	"HàNguyên","KhởiPhong",
	"AnhThái","KhắcTrung",
	"QuốcViệt","VươngQuố",
	"HoàngNgọc","QuangLâm",
	"HoàngKhánh","HồngHải",
	"TùngDương","CaoCường",
	"XuânBách","TrungDũng",
}

assert(#tbRandomName > 5);

tbRandomName = Lib:RandomArray(tbRandomName);

local function ValueInTable(value, tb)
	for _,v in pairs(tb) do
		if value == v then
			return true;
		end
	end
	return false;
end


local nNameIndex = 0;
local function GetRandomName(tbNames)
	local szName = "";
	repeat
		if nNameIndex >= #tbRandomName then
			nNameIndex = 0;
		end

		nNameIndex = nNameIndex + 1;
		szName = tbRandomName[nNameIndex];
	until not ValueInTable(szName, tbNames)

	return szName;
end

local function RandAnswer(tbOption, nAnswerIndex)
	assert(nAnswerIndex <= #tbOption);
	local answer = tbOption[nAnswerIndex];
	local nCount = #tbOption
	local temp = nil;
	for i = 1, nCount do
		local n = MathRandom(nCount);
		temp = tbOption[i];
		tbOption[i] = tbOption[n];
		tbOption[n] = temp;
	end

	for nIdx, option in ipairs(tbOption) do
		if option == answer then
			nAnswerIndex = nIdx;
			break;
		end
	end

	return tbOption, nAnswerIndex;
end

local function PackgeQuizData(szQuiz, tbOptions, nAnswerIndex)
	if not next(tbOptions) then
		return;
	end

	local tbQuiz = {};
	tbQuiz.szQuiz = szQuiz;
	tbQuiz.tbOption, tbQuiz.nAnswer = RandAnswer(tbOptions, nAnswerIndex);
	return tbQuiz;
end

local function FillUpKinRandomName(kinData, tbOptions, fnCheck)
	local tbMembers = {};
	kinData:TraverseMembers(function (memberData)
		table.insert(tbMembers, memberData);
		return true;
	end);

	tbMembers = Lib:RandomArray(tbMembers);
	for _, memberData in ipairs(tbMembers) do
		if #tbOptions >= 4 then
			break;
		end

		local szName = memberData:GetName();
		if not ValueInTable(szName, tbOptions) then
			if not fnCheck or fnCheck(memberData) then
				table.insert(tbOptions, szName);
			end
		end
	end

	return tbOptions;
end

--[[
tbQuiz = {
	szQuiz = "以下谁是家族的族长？";
	nAnswer = 1;
	tbOption = {
		[1] = "aaa";
		[2] = "bbb";
		[3] = "cc";
		[4] = "d";
	}
}

]]

local tbKinQuizCreator = {
	[1] = function (kinData) --以下谁是家族的族长？
		local nQuizIdx = 1;
		local nRightAnswer = 1;
		local master = KPlayer.GetRoleStayInfo(kinData.nMasterId);
		local tbNames = {master.szName};
		tbNames = FillUpKinRandomName(kinData, tbNames);

		while #tbNames < 4 do
			table.insert(tbNames, GetRandomName(tbNames));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbNames, nRightAnswer);
	end;

	[2] = function (kinData)-- 以下谁是家族的副族长？
		local nQuizIdx = 2;
		local tbNames = {"Không"};
		local nRightAnswer = 1;

		kinData:TraverseMembers(function (memberData)
			if memberData.nCareer == Kin.Def.Career_ViceMaster then
				table.insert(tbNames, memberData:GetName());
				nRightAnswer = 2;
				return false;
			end
			return true;
		end);

		tbNames = FillUpKinRandomName(kinData, tbNames, function (memberData)
			return memberData.nCareer ~= Kin.Def.Career_ViceMaster;
		end);

		while #tbNames < 4 do
			table.insert(tbNames, GetRandomName(tbNames));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbNames, nRightAnswer);
	end;

	[3] = function (kinData)-- 以下谁是家族的长老？
		local nQuizIdx = 3;
		local tbNames = {"Không"};
		local nRightAnswer = 1;

		kinData:TraverseMembers(function (memberData)
			if memberData.nCareer == Kin.Def.Career_Elder then
				table.insert(tbNames, memberData:GetName());
				nRightAnswer = 2;
				return false;
			end
			return true;
		end);

		tbNames = FillUpKinRandomName(kinData, tbNames, function (memberData)
			return memberData.nCareer ~= Kin.Def.Career_Elder;
		end);

		while #tbNames < 4 do
			table.insert(tbNames, GetRandomName(tbNames));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbNames, nRightAnswer);
	end;

	[4] = function (kinData)-- 家族里谁的等级最高？
		local nQuizIdx = 4;
		local tbNames = {};
		local nRightAnswer = 1;

		local nMaxLevel = 0;
		local szMaxLevelName = "";
		kinData:TraverseMembers(function (memberData)
			local tbRoleStayInfo = KPlayer.GetRoleStayInfo(memberData.nMemberId);
			if tbRoleStayInfo.nLevel > nMaxLevel then
				szMaxLevelName = memberData:GetName();
				nMaxLevel = tbRoleStayInfo.nLevel;
			end
			return true;
		end);

		table.insert(tbNames, szMaxLevelName);

		tbNames = FillUpKinRandomName(kinData, tbNames, function (memberData)
			local tbRoleStayInfo = KPlayer.GetRoleStayInfo(memberData.nMemberId);
			return tbRoleStayInfo.nLevel < nMaxLevel;
		end);

		while #tbNames < 4 do
			table.insert(tbNames, GetRandomName(tbNames));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbNames, nRightAnswer);
	end;

	[5] = function (kinData)-- 家族里谁的战力最高？
		local nQuizIdx = 5;
		local tbNames = {};
		local nRightAnswer = 1;

		local nMaxPower = -1;
		local szMaxPowerName = "";
		kinData:TraverseMembers(function (memberData)
			local nPower = FightPower:GetFightPower(memberData.nMemberId);
			if nPower > nMaxPower then
				nMaxPower = nPower;
				szMaxPowerName = memberData:GetName();
			end
			return true;
		end);

		table.insert(tbNames, szMaxPowerName);

		tbNames = FillUpKinRandomName(kinData, tbNames, function (memberData)
			local nPower = FightPower:GetFightPower(memberData.nMemberId);
			return nPower < nMaxPower;
		end);

		while #tbNames < 4 do
			table.insert(tbNames, GetRandomName(tbNames));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbNames, nRightAnswer);
	end;

	[6] = function (kinData) -- 家族里谁的个人贡献最高？
		local nQuizIdx = 6;
		local tbNames = {};
		local nRightAnswer = 1;

		local nMaxContribution = -1;
		local szMaxConName = "";
		kinData:TraverseMembers(function (memberData)
			local nContrib = memberData:GetContribution();
			if nContrib > nMaxContribution then
				nMaxContribution = nContrib;
				szMaxConName = memberData:GetName();
			end
			return true;
		end);

		table.insert(tbNames, szMaxConName);

		tbNames = FillUpKinRandomName(kinData, tbNames, function (memberData)
			local nContrib = memberData:GetContribution();
			return nContrib < nMaxContribution;
		end);

		while #tbNames < 4 do
			table.insert(tbNames, GetRandomName(tbNames));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbNames, nRightAnswer);
	end;

	[7] = function (kinData) -- "以下成员谁的头衔是:",
		local nQuizIdx = 7;
		local nRightAnswer = 1;
		local tbTitle = {};
		local tbMapFlag = {};
		kinData:TraverseMembers(function (memberData)
			local tbRoleStayInfo = KPlayer.GetRoleStayInfo(memberData.nMemberId);
			if not tbMapFlag[tbRoleStayInfo.nHonorLevel] then
				table.insert(tbTitle, tbRoleStayInfo.nHonorLevel);
				tbMapFlag[tbRoleStayInfo.nHonorLevel] = true;
			end
			return true;
		end);

		table.sort(tbTitle, function (a, b)
			return a > b;
		end);

		local nSelectHonor = tbTitle[1];
		if #tbTitle > 1 and MathRandom(2) == 2 then
			nSelectHonor = tbTitle[2];
		end

		local tbOptions = {};
		kinData:TraverseMembers(function (memberData)
			local tbRoleStayInfo = KPlayer.GetRoleStayInfo(memberData.nMemberId);
			if tbRoleStayInfo.nHonorLevel == nSelectHonor then
				table.insert(tbOptions, tbRoleStayInfo.szName);
				return false;
			end
			return true;
		end);

		tbOptions = FillUpKinRandomName(kinData, tbOptions, function (memberData)
			local tbRoleStayInfo = KPlayer.GetRoleStayInfo(memberData.nMemberId);
			return tbRoleStayInfo.nHonorLevel ~= nSelectHonor;
		end);

		while #tbOptions < 4 do
			table.insert(tbOptions, GetRandomName(tbOptions));
		end

		local tbHonorInfo = Player.tbHonorLevelSetting[nSelectHonor] or {Name = "Không Quân Hàm"};
		return PackgeQuizData(tbOrgQuizs[nQuizIdx] .. tbHonorInfo.Name, tbOptions, nRightAnswer);
	end;

	[8] = function (kinData) -- 家族目前有多少正式成员？
		local nQuizIdx = 8;
		local nRightAnswer = 1;
		local tbOptions = {};
		local nNormalMemberCount = kinData:GetMemberCount();
		table.insert(tbOptions, nNormalMemberCount);

		local tbArray = {}
		for i = nNormalMemberCount - 5, nNormalMemberCount + 5 do
			if i ~= nNormalMemberCount and i > 1 then
				table.insert(tbArray, i);
			end
		end

		assert(#tbArray >= 3, "Quy Tắc có vấn đề");
		local nOptionCount = 1;
		while nOptionCount < 4 do
			local nSelect = MathRandom(#tbArray);
			table.insert(tbOptions, tbArray[nSelect]);
			table.remove(tbArray, nSelect);
			nOptionCount = nOptionCount + 1;
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[9] = function (kinData) -- 家族目前有多少见习成员？
		local nQuizIdx = 9;
		local nRightAnswer = 1;
		local tbOptions = {};
		local nNormalMemberCount = kinData:GetNewerCount();
		table.insert(tbOptions, nNormalMemberCount);

		local tbArray = {}
		for i = nNormalMemberCount - 3, nNormalMemberCount + 3 do
			if i ~= nNormalMemberCount and i <= 40 and i >= 0 then
				table.insert(tbArray, i);
			end
		end

		assert(#tbArray >= 3, "Quy Tắc có vấn đề");
		local nOptionCount = 1;
		while nOptionCount < 4 do
			local nSelect = MathRandom(#tbArray);
			table.insert(tbOptions, tbArray[nSelect]);
			table.remove(tbArray, nSelect);
			nOptionCount = nOptionCount + 1;
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[10] = function (kinData) -- 家族目前多少级？
		local nQuizIdx = 10;
		local nRightAnswer = 1;
		local tbOptions = {};
		local nLevel = kinData:GetLevel();
		table.insert(tbOptions, nLevel);

		local tbArray = {}
		for i = nLevel - 10, nLevel + 10 do
			if i ~= nLevel and i > 0 then
				table.insert(tbArray, i);
			end
		end

		local nOptionCount = 1;
		while nOptionCount < 4 do
			local nSelect = MathRandom(#tbArray);
			table.insert(tbOptions, tbArray[nSelect]);
			table.remove(tbArray, nSelect);
			nOptionCount = nOptionCount + 1;
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[11] = function (kinData) -- 家族目前什么门派人最多？
		local nQuizIdx = 11;
		local nRightAnswer = 1;
		local tbFactions = {};
		for i = 1, Faction.MAX_FACTION_COUNT do
			tbFactions[i] = 0;
		end

		kinData:TraverseMembers(function (memberData)
			local tbRoleStayInfo = KPlayer.GetRoleStayInfo(memberData.nMemberId);
			tbFactions[tbRoleStayInfo.nFaction] = tbFactions[tbRoleStayInfo.nFaction] + 1;
			return true;
		end);

		local nMaxFaction = 1;
		local nMaxCount = 0;
		for nFaction, nCount in pairs(tbFactions) do
			if nCount > nMaxCount then
				nMaxFaction = nFaction;
				nMaxCount = nCount;
			end
		end

		local tbOptions = {};
		table.insert(tbOptions, Faction:GetName(nMaxFaction));

		for nFaction = 1, Faction.MAX_FACTION_COUNT do
			if #tbOptions >= 4 then
				break;
			end

			if nFaction ~= nMaxFaction then
				table.insert(tbOptions, Faction:GetName(nFaction));
			end
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[12] = function (kinData) -- "昨天家族烤火活动谁中奖了？",
		local gatherWinNames = kinData:GetGatherWinNames() or {};
		if not next(gatherWinNames) then
			return;
		end

		local nQuizIdx = 12;
		local nRightAnswer = 1;
		local tbOptions = {};

		table.insert(tbOptions, gatherWinNames[MathRandom(#gatherWinNames)]);

		tbOptions = FillUpKinRandomName(kinData, tbOptions, function (memberData)
			local szName = memberData:GetName();
			return not ValueInTable(szName, gatherWinNames);
		end);

		while #tbOptions < 4 do
			table.insert(tbOptions, GetRandomName(tbOptions));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[13] = function (kinData) -- "昨天傍晚的武林盟主活动本家族排名多少？",
		local nQuizIdx = 13;
		local nRightAnswer = 1;
		local tbOptions = {};

		local nRank = kinData:GetCacheFlag("BossRank2");
		if not nRank then
			return;
		end

		local fnSelect = Lib:GetRandomSelect(12);
		table.insert(tbOptions, nRank);

		while #tbOptions < 4 do
			local nRandRank = fnSelect() - 6 + nRank;
			if nRandRank ~= nRank and nRandRank > 0 then
				table.insert(tbOptions, nRandRank);
			end
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[14] = function (kinData) -- "中午的武林盟主活动家族排名多少？",
		local nQuizIdx = 14;
		local nRightAnswer = 1;
		local tbOptions = {};

		local nRank = kinData:GetCacheFlag("BossRank1");
		if not nRank then
			return;
		end

		local fnSelect = Lib:GetRandomSelect(12);
		table.insert(tbOptions, nRank);

		while #tbOptions < 4 do
			local nRandRank = fnSelect() - 6 + nRank;
			if nRandRank ~= nRank and nRandRank > 0 then
				table.insert(tbOptions, nRandRank);
			end
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[15] = function (kinData) -- "家族的%s现在多少级？",
		local nQuizIdx = 15;
		local nRightAnswer = 1;
		local tbOptions = {};

		local tbKinBuildings = {
			Kin.Def.Building_Main,
			Kin.Def.Building_War,
			Kin.Def.Building_DrugStore,
			Kin.Def.Building_WeaponStore,
			Kin.Def.Building_Treasure,
			Kin.Def.Building_FangJuHouse,
			Kin.Def.Building_ShouShiHouse,
		};

		local nBuildingId = tbKinBuildings[MathRandom(#tbKinBuildings)];
		local szQuiz = string.format(tbOrgQuizs[nQuizIdx], Kin.Def.BuildingName[nBuildingId]);
		local nBuildingLevel = kinData:GetBuildingLevel(nBuildingId);
		local fnSelect = Lib:GetRandomSelect(Kin.Def.nMaxBuildingLevel);

		table.insert(tbOptions, nBuildingLevel);
		while #tbOptions < 4 do
			local nLevel = fnSelect();
			if nLevel ~= nBuildingLevel then
				table.insert(tbOptions, nLevel);
			end
		end

		return PackgeQuizData(szQuiz, tbOptions, nRightAnswer);
	end;

	[16] = function (kinData) -- "最晚加入家族的是谁？",
		local nQuizIdx = 16;
		local nRightAnswer = 1;
		local tbOptions = {};

		local nMaxJoinTime = 0;
		local szLatestMemberName = "";
		kinData:TraverseMembers(function (memberData)
			local nJoinTime = memberData:GetJoinTime();
			if nJoinTime > nMaxJoinTime then
				nMaxJoinTime = nJoinTime;
				szLatestMemberName = memberData:GetName();
			end
			return true;
		end);

		table.insert(tbOptions, szLatestMemberName);
		tbOptions = FillUpKinRandomName(kinData, tbOptions);

		while #tbOptions < 4 do
			table.insert(tbOptions, GetRandomName(tbOptions));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[17] = function (kinData) -- "家族里谁的武神殿排名最高？",
		local nQuizIdx = 17;
		local nRightAnswer = 1;
		local tbOptions = {};

		-- todo

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[18] = function (kinData) -- "最近的一次门派竞技家族里谁的排名最高?",
		local nQuizIdx = 18;
		local nRightAnswer = 1;
		local tbOptions = {};
		-- todo
		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[19] = function (kinData) -- "家族里谁今天获得了战场第1名?",
		local nQuizIdx = 19;
		local nRightAnswer = 1;
		local tbOptions = {};

		local tbWinBattleNames = kinData:GetBattleKingNames() or {};
		if not next(tbWinBattleNames) then
			return;
		end

		table.insert(tbOptions, tbWinBattleNames[MathRandom(#tbWinBattleNames)]);

		tbOptions = FillUpKinRandomName(kinData, tbOptions, function (memberData)
			local szName = memberData:GetName();
			return not ValueInTable(szName, tbWinBattleNames);
		end);

		while #tbOptions < 4 do
			table.insert(tbOptions, GetRandomName(tbOptions));
		end

		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[20] = function (kinData) -- "家族里谁今天在英雄挑战第10轮获胜?",
		local nQuizIdx = 20;
		local nRightAnswer = 1;
		local tbOptions = {};

		local tbWin10Names = kinData:GetHeroChallengeWin10Names();
		if not next(tbWin10Names) then
			return;
		end

		table.insert(tbOptions, tbWin10Names[MathRandom(#tbWin10Names)]);

		tbOptions = FillUpKinRandomName(kinData, tbOptions, function (memberData)
			local szName = memberData:GetName();
			return not ValueInTable(szName, tbWin10Names);
		end);

		while #tbOptions < 4 do
			table.insert(tbOptions, GetRandomName(tbOptions));
		end
		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;


	[21] = function (kinData) --"昨天家族运镖的镖车是什么颜色?",
		local nQuizIdx = 21;
		local nRightAnswer = 1;
		local tbOptions = {};
		local szEscortColor = kinData:GetYesterdayKinEscortColor();
		if not szEscortColor then
			return;
		end
		table.insert(tbOptions, szEscortColor);
		for _, szColor in pairs(KinEscort.tbNpcColor) do
			if #tbOptions >= 4 then
				break;
			end

			if szColor ~= szEscortColor then
				table.insert(tbOptions, szColor);
			end
		end
		assert(#tbOptions == 4);
		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;

	[22] = function (kinData) --"家族里谁最近登上了通天塔7层?",
		local nQuizIdx = 22;
		local nRightAnswer = 1;
		local tbOptions = {};
		local szLatestName = kinData:GetLatestTower7PlayerName();
		if not szLatestName then
			return;
		end

		table.insert(tbOptions, szLatestName);
		tbOptions = FillUpKinRandomName(kinData, tbOptions);

		while #tbOptions < 4 do
			table.insert(tbOptions, GetRandomName(tbOptions));
		end
		return PackgeQuizData(tbOrgQuizs[nQuizIdx], tbOptions, nRightAnswer);
	end;
}

function Kin:GetGatherQuizByIndex(tbIndexes, nIndex, kinData)
	local tbQuiz = tbKinQuizCreator[tbIndexes[nIndex]](kinData);

	-- 若选取的题目不可用, 则从未选的题中再选题, 直到题目可用为止
	local fnSelect = not tbQuiz and Lib:GetRandomSelect(#tbKinQuizCreator);
	local nMaxTryTime = #tbKinQuizCreator;
	while not tbQuiz do
		local nQuizIdx = fnSelect();
		nMaxTryTime = nMaxTryTime - 1;
		if nMaxTryTime < 0 then
			Log(debug.traceback())
			return;
		end

		while ValueInTable(nQuizIdx, tbIndexes) do
			nQuizIdx = fnSelect();
			nMaxTryTime = nMaxTryTime - 1;
			if nMaxTryTime < 0 then
				Log(debug.traceback())
				return;
			end
		end
		tbIndexes[nIndex] = nQuizIdx;

		tbQuiz = tbKinQuizCreator[nQuizIdx](kinData);
	end
	return tbQuiz;
end

function Kin:GetGatherQuizIndex()
	local fnSelect = Lib:GetRandomSelect(#tbKinQuizCreator);
	local tbIndexes = {};
	for i = 1, Kin.GatherDef.QuizCount do
		table.insert(tbIndexes, fnSelect());
	end
	return tbIndexes;
end
