
TeamFuben.MIN_PLAYER_COUNT = 2;
TeamFuben.MAX_PLAYER_COUNT = 4;

TeamFuben.REVIVE_TIME = 10;				-- 玩家死亡后等待多久自动复活
TeamFuben.MAX_AWARD_TIMES = 2;			--每天最大奖励次数

-- 没有奖励次数时，固定奖励
TeamFuben.tbCommonAward = {
	{"item", 1, 1},
}

TeamFuben.tbTeamLeaderExtAward = {
	[1] = 100;
	[2] = 80;
	[3] = 60;
	[4] = 40;
	[5] = 40;
	[6] = 40;
}

-- 按照亲密度等级不同进行加分
TeamFuben.tbFriendLevelScroe =
{
-- 亲密度等级		增加积分
	{9, 			3},
	{99, 			6},
};
TeamFuben.SAME_KIN_SCROE = 3;		-- 同家族加分
TeamFuben.KIN_NEWER_SCROE = 8;		-- 队友有同家族见习成员加分

-- 副本耗时加分
TeamFuben.FubenTimeScroe =
{
--	耗时		加分
	{300, 		20},
	{330, 		19},
	{360, 		18},
	{390, 		17},
	{420, 		16},
	{450, 		15},
	{480, 		14},
	{510, 		13},
	{540, 		12},
	{570, 		11},
	{600, 		10},
	{660, 		9},
	{720, 		8},
	{780, 		7},
	{840, 		6},
	{900, 		5},
};

TeamFuben.tbExtMissAward =
{
	[1] = {
		{"BasicExp", 120},
	},
	[2] = {
		{"BasicExp", 100},
	},
	[3] = {
		{"BasicExp", 90},
	},
	[4] = {
		{"BasicExp", 80},
	},
	[5] = {
		{"BasicExp", 70},
	},
	[6] = {
		{"BasicExp", 60},
	},
}

function TeamFuben:GetFriendLevelScroe(nImityLevel)
	nImityLevel = nImityLevel or 0;
	if nImityLevel <= 0 then
		return 0;
	end

	local nScore = 0;
	for _, tbInfo in ipairs(self.tbFriendLevelScroe or {}) do
		nScore = tbInfo[2] or 0;
		if nImityLevel <= tbInfo[1] then
			break;
		end
	end

	return nScore;
end

TeamFuben.TEAM_FUBEN_SETTING_PATH = "Setting/Fuben/TeamFuben/TeamFubenSetting.tab";
function TeamFuben:Init()
	local tbFile = LoadTabFile(self.TEAM_FUBEN_SETTING_PATH, "ddddssssssss", nil, {"nSectionIdx", "nSubSectionIdx", "nMapTemplateId", "nMinLevel", "szOpenTimeFrame", "szName", "szSprite", "szAtlas", "szFubenDesc", "szAward", "szShowItem", "szMissionSumup"});
	assert(tbFile, "Tải file thiết lập phó bản tổ đội thất bại!!!" .. self.TEAM_FUBEN_SETTING_PATH);

	self.tbAllFuben = {};
	for _, tbRow in pairs(tbFile) do
		tbRow.tbShowItem = Lib:GetAwardFromString(tbRow.szShowItem);
		tbRow.szShowItem = nil;

		tbRow.tbAward = Lib:GetAwardFromString(tbRow.szAward, "|");
		tbRow.szAward = nil;

		self.tbAllFuben[tbRow.nSectionIdx] = self.tbAllFuben[tbRow.nSectionIdx] or {};
		self.tbAllFuben[tbRow.nSectionIdx][tbRow.nSubSectionIdx] = tbRow;
	end

	self.tbAllFubenByIndex = {};
	for nSectionIdx = 1, 100 do
		local tbSectionInfo = self.tbAllFuben[nSectionIdx];
		if tbSectionInfo then
			for nSubSectionIdx = 1, 100 do
				if tbSectionInfo[nSubSectionIdx] then
					table.insert(self.tbAllFubenByIndex, {nSectionIdx, nSubSectionIdx});
				end
			end
		end
	end
end
TeamFuben:Init();

function TeamFuben:GetFubenSetting(nSectionIdx, nSubSectionIdx)
	if not self.tbAllFuben[nSectionIdx] then
		return;
	end

 	if not nSubSectionIdx then
 		return self.tbAllFuben[nSectionIdx];
 	end

	return self.tbAllFuben[nSectionIdx][nSubSectionIdx];
end

function TeamFuben:CanEnterFubenCommon(pPlayer, nSectionIdx, nSubSectionIdx)
	local tbSetting = self:GetFubenSetting(nSectionIdx, nSubSectionIdx);
	if not tbSetting then
		return false, "Chưa tìm được phó bản!";
	end

	if GetTimeFrameState(tbSetting.szOpenTimeFrame) ~= 1 then
		return false, "Phó bản hiện tại chưa mở";
	end

	if pPlayer.nLevel < tbSetting.nMinLevel then
		return false, string.format("Cấp chưa đạt %d, không thể tham gia phó bản tổ đội", tbSetting.nMinLevel);
	end

	if not Env:CheckSystemSwitch(pPlayer, Env.SW_TeamFuben) then
		return false, "Hiện không thể tham gia";
	end

	return true, "";
end

function TeamFuben:CheckPlayerCanEnterFuben(pPlayer, nSectionIdx, nSubSectionIdx, bHelp)
	local bRet, szMsg = self:CanEnterFubenCommon(pPlayer, nSectionIdx, nSubSectionIdx);
	if not bRet then
		return false, szMsg;
	end

	if not bHelp and DegreeCtrl:GetDegree(pPlayer, "TeamFuben") <= 0 then
		return false, "Số lần phó bản tổ đội không đủ";
	end

	local bRet, szMsg = pPlayer.CheckNeedArrangeBag();
	if bRet then
		return false, szMsg
	end

	if not Fuben.tbSafeMap[pPlayer.nMapTemplateId] and Map:GetClassDesc(pPlayer.nMapTemplateId) ~= "fight" then
		return false, "Khu vực hiện tại không được vào phó bản";
	end

	if Map:GetClassDesc(pPlayer.nMapTemplateId) == "fight" and pPlayer.nFightMode ~= 0 then
		return false, "Không phải khu an toàn, không thể vào phó bản";
	end

	return true, szMsg;
end

function TeamFuben:CheckCanCreateFuben(pPlayer, nSectionIdx, nSubSectionIdx)
	local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID);
	if not tbMember or #tbMember <= 0 then
		tbMember = { pPlayer.dwID };
	end

	local teamData = TeamMgr:GetTeamById(pPlayer.dwTeamID);
	if teamData and teamData.nCaptainID ~= pPlayer.dwID then
		return false, "Đội trưởng mới được mở phó bản!";
	end

	if #tbMember < self.MIN_PLAYER_COUNT then
		return false, string.format("Số người chưa đủ %d, không thể mở phó bản!", self.MIN_PLAYER_COUNT), tbMember;
	end

	if #tbMember > self.MAX_PLAYER_COUNT then
		return false, string.format("Số người vượt quá %d, không thể mở phó bản!", self.MAX_PLAYER_COUNT), tbMember;
	end

	for _, nPlayerId in pairs(tbMember) do
		local pPlayer = KPlayer.GetPlayerObjById(nPlayerId);
		if not pPlayer then
			return false, "Thành viên đội chưa biết, không thể mở phó bản!", tbMember;
		end

		local bHelp = TeamMgr:CanQuickTeamHelp(pPlayer);
		local bRet, szMsg = self:CheckPlayerCanEnterFuben(pPlayer, nSectionIdx, nSubSectionIdx, bHelp);
		if not bRet then
			return false, "「" .. pPlayer.szName .. "」" .. szMsg, tbMember;
		end
	end

	local tbSetting = self:GetFubenSetting(nSectionIdx, nSubSectionIdx);


	return true, "", tbMember, tbSetting.nMapTemplateId;
end

