
function ScheduleTask:OnExecute(szFunc, szTimeFrame, szCloseTimeFrame, Param1, Param2, Param3, Param4, Param5)
	if szTimeFrame and szTimeFrame ~= "" then
		if TimeFrame:GetTimeFrameState(szTimeFrame) ~= 1 then
			return false;
		end
	end

	if szCloseTimeFrame and szCloseTimeFrame ~= "" then
		if TimeFrame:GetTimeFrameState(szCloseTimeFrame) == 1 then
			return false;
		end
	end

	local fnFunc = self[szFunc];
	if (not fnFunc) then
		Log(string.format("[SCHEDUALTASK]Callback Func Missing: %s", szFunc));
		return true;
	end

	local tbParams = {Param1, Param2, Param3, Param4, Param5}
	for i, v in ipairs(tbParams) do
		if Lib:IsEmptyStr(v) then
			tbParams[i] = nil;
		elseif tonumber(v) then
			tbParams[i] = tonumber(v);
		end
	end
	Log(string.format("[SCHEDUALTASK]Execute: %s()", szFunc), tbParams[1], tbParams[2],tbParams[3],tbParams[4],tbParams[5]);
	local fnExc = function ()
		fnFunc(self, tbParams[1],tbParams[2],tbParams[3],tbParams[4],tbParams[5])
	end
	xpcall(fnExc, Lib.ShowStack);
	return true;
end

function ScheduleTask:DoNothing()
end

function ScheduleTask:KinRunPerDay()
	Kin:RunPerDay();

	if version_vn then
		local nServerId = GetServerIdentity()
		TLog("ServerCreateTime", nServerId, ScriptData:GetValue("dwServerCreateTime"))
	end
end

function ScheduleTask:KinRobber(nRound)
	if not Kin.bRobberOpened then
		return
	end
	Kin:OpenKinRobber(tonumber(nRound));
end

function ScheduleTask:KinRobberStop()
	-- 活动显示用...故加的空的..
end

function ScheduleTask:BossFight(nRound)
	Boss:StartBossFight(nRound);
end

function ScheduleTask:StopBossFight()
	Boss:NotifyFinishBoss();
end

function ScheduleTask:SendCrossBossKinMail()
	Boss:ZCSendKinNotifyMail();
end

function ScheduleTask:StartZoneBossMaster()
	Boss:ZSPreStart();
end

function ScheduleTask:EndZoneBossMaster()
	Boss:ZSPreFinish();
end

function ScheduleTask:AuctionRunPerday()
	--Kin:AuctionRunPerday();
end

function ScheduleTask:CheckMaxLevel()
	local nMaxLevel = TimeFrame:GetMaxLevel();
	if nMaxLevel then
		SetMaxLevel(nMaxLevel)
	end
end

function ScheduleTask:UpdateLevelAddExpP()
    Lib:CallBack({Npc.UpdateLevelAddExpP, Npc})
end

function ScheduleTask:KinGatherPrepare()
	Kin:PrepareKinGatherActivity();
end

function ScheduleTask:KinGatherStart()
	Kin:StartKinGatherActivity();
end

function ScheduleTask:KinGatherStop()
	Kin:StopKinGatherActivity()
end

function ScheduleTask:RankBattleAward()
	RankBattle:Award()
end

function ScheduleTask:HeroChallengeUpdate()
    HeroChallenge:UpdatePlayerRankData();
end

function ScheduleTask:PreStartBoss()
	BossLeader:PreStartActivity("Boss");
	Log("ChangeMapPKMode PreStartBoss");
end

function ScheduleTask:EndEnterBossFuben()
	BossLeader:EndActivityEnter("Boss");
	Log("ChangeMapPKMode EndEnterBoss");
end

function ScheduleTask:StartBoss(nJiFen)
	if not nJiFen then
		nJiFen = 0;
	end
	nJiFen = tonumber(nJiFen);
	local bJiFen = false;
	if nJiFen == 1 then
		bJiFen = true;
	end
	BossLeader:StartActivity("Boss", 0, bJiFen);
end

function ScheduleTask:EndBoss()
	BossLeader:CloseActivity("Boss");
end

function ScheduleTask:CrossBossMail(nWorld)
	if not nWorld then
		nWorld = 0;
	end
	nWorld = tonumber(nWorld);
	local bWorld = false;
	if nWorld == 1 then
		bWorld = true;
	end
    BossLeader:SendCrossKinMail(bWorld);
end

function ScheduleTask:StartLeader(nExtCount)
	if not nExtCount then
		nExtCount = 0;
	end

	nExtCount = tonumber(nExtCount);
	BossLeader:StartActivity("Leader", nExtCount);
end

function ScheduleTask:EndLeader()
	BossLeader:CloseActivity("Leader");
end

function ScheduleTask:HSLJOpenHSLJMail()
   HuaShanLunJian:OpenHSLJMail()
end

function ScheduleTask:HSLJChampionGuessing()
   HuaShanLunJian:PreEndChampionGuessing();
end

function ScheduleTask:HSLJPreStartPreGame()
   HuaShanLunJian:PreStartPrepareGame()
end

function ScheduleTask:HSLJStartPreGame()
   HuaShanLunJian:StartPrepareGame();
end

function ScheduleTask:HSLJClosePreGame()
   HuaShanLunJian:CloseEnterPreGame();
end

function ScheduleTask:HSLJPreStartFinalsGame()
	HuaShanLunJian:PreStartFinalsPlayGame();
end

function ScheduleTask:HSLJStartFinalsGame()
   HuaShanLunJian:StartFinalsPlayGame();
end

function ScheduleTask:HSLJCloseFinalsGame()
   HuaShanLunJian:CloseFinalsPlayGame();
end

function ScheduleTask:HSLJFinalsList()
    HuaShanLunJian:InformFinalsFightTeamList();
end

function ScheduleTask:StartUpdatePunishTask()
	PunishTask:StartCreateMapNpc()
	Log("ScheduleTask StartUpdatePunishTask");
end

function ScheduleTask:QYHFirstStartGame()
    QunYingHui:FirstStartGame();
end

function ScheduleTask:QYHStartGame()
    QunYingHui:StartGame();
end

function ScheduleTask:QYHEndGame()
    --QunYingHui:EndGame();
end

function ScheduleTask:QYHSeasonEndGame()
	QunYingHui:SeasonEndGame();
end

function ScheduleTask:StartBattle(nType)
	Battle:OpenBattleSignUp(nType)
	Log("StartBattle sign up", nType)
end

function ScheduleTask:StopBattle()
	Battle:StopBattleSignUp()
end

function ScheduleTask:UpdateStrangerMap()
	KPlayer.UpdateStrangerMap();
end

--新的一天开始了
function ScheduleTask:OnNewDayBegin()
	SupplementAward:OnPerDayUpdate()
	ActivityQuestion:OnNewDayBegin()
	LoginAwards:OnNewDayBegin()
	SignInAwards:OnNewDayBegin()
	MoneyTree:OnNewDayBegin()
	SummerGift:OnPerDayUpdate()
	Lib:CallBack({WuLinDaShi.OnNewDayBegin, WuLinDaShi})
	Furniture.MagicBowl:UpdateOnlinePlayersBuff()
end

function ScheduleTask:CheckRankBoard()
	RankBoard:UpdateAllRank()
end

function ScheduleTask:LogDailyKinData()
	-- 日期，家族ID，家族中文名，家族等级，威望值，家族排名，族长角色ID
	local pRank = KRank.GetRankBoard("kin")
	if not pRank then
		return
	end

	for i = 1, 500 do
		local tbInfo = pRank.GetRankInfoByPos(i - 1);
		if not tbInfo then
			break;
		end
		local tbKin = Kin:GetKinById(tbInfo.dwUnitID)
		if tbKin then
			LogD(Env.LOGD_DailyKin, nil, nil, tbInfo.dwUnitID, tbKin.szName, tbKin:GetLevel(), tbKin.nPrestige, i, tbKin.nMasterId)
		end
	end
end

function ScheduleTask:LogDailyRole()
	LogRoleLogined(os.date("%Y-%m-%d %H:%M:%S", (GetTime() - 3600 * 26)))
end

function ScheduleTask:PreStartKinBattle(nWaiteTime)
	KinBattle:PreStartKinBattle(nWaiteTime * 60);
end

function ScheduleTask:EndKinBattle()
	KinBattle:EndKinBattle();
end

function ScheduleTask:StartWhiteTiger()
	Fuben.WhiteTigerFuben:Start()
end

function ScheduleTask:CheckCrossBossTimeFrame()
    if not MODULE_ZONESERVER then
		return
	end

	BossLeader:CheckServerCrossBossInfoZ();
end

function ScheduleTask:PreStartCrossBoss()
    if not MODULE_ZONESERVER then
		return
	end

	BossLeader:PreStartCrossBossZ();
end

function ScheduleTask:StartCrossBoss()
    if not MODULE_ZONESERVER then
		return
	end

	BossLeader:StartCrossBossZ()
end

function ScheduleTask:EndCrossBoss()
    if not MODULE_ZONESERVER then
		return
	end

	BossLeader:EndCrossBossZ();
end

function ScheduleTask:StartCrossWhiteTiger()
	if not MODULE_ZONESERVER then
		return
	end

	Fuben.WhiteTigerFuben:BeginCrossFight()
end

function ScheduleTask:CloseWhiteTiger()
    if MODULE_ZONESERVER then
        Fuben.WhiteTigerFuben:StopCrossFight()
        return
    end
	Fuben.WhiteTigerFuben:CloseFuben()
end

function ScheduleTask:CheckStartTeamBattle()
	TeamBattle:CheckStart();
end

function ScheduleTask:CheckStartLeagueTeamBattle()
	TeamBattle:CheckStartLeague();
end

function ScheduleTask:SendLeagueTeamBattleTip()
	local bNeedCheck = TeamBattle:CheckTips();
	if not bNeedCheck then
		return;
	end

	local tbAllPlayer = KPlayer.GetAllPlayer();
	for _, pPlayer in pairs(tbAllPlayer) do
		TeamBattle:SendLeagueTip(pPlayer);
	end
end

function ScheduleTask:StartFactionBattle()
	FactionBattle:Start()
end

function ScheduleTask:CloseFactionBattle()
	FactionBattle:Close()
end

--开启家族运镖活动
function ScheduleTask:StartKinEscort()
	KinEscort:Open()
end

--关闭家族运镖活动
function ScheduleTask:CloseKinEscort()
	KinEscort:Close()
end

function ScheduleTask:StartKinTrain()
	Fuben.KinTrainMgr:Start()
end

function ScheduleTask:StopKinTrain()
	Fuben.KinTrainMgr:Stop()
end

function ScheduleTask:StartKinSecretFuben()
	Fuben.KinSecretMgr:Start()
end

function ScheduleTask:StopKinSecretFuben()
	Fuben.KinSecretMgr:Stop()
end

function ScheduleTask:UpdateKinLeader()
	Kin:CheckLeaderOn()
	Kin:CheckLeaderOff()
end

function ScheduleTask:StartFactionMonkey()
	FactionBattle.FactionMonkey:StartFactionMonkey()
end

function ScheduleTask:EndFactionMonkey()
	FactionBattle.FactionMonkey:EndFactionMonkey()
end

function ScheduleTask:KinActivityDaily()
	Kin:DoActivityDaily()
	Kin:RedBagGlobalRemoveExpire()
end

function ScheduleTask:KinTransferCareerNew()
	Kin:TransferCareerNew()
end

function ScheduleTask:NewDayBegin_Zero()
	Spokesman:OnNewDayBegin()
end

function ScheduleTask:NotifyDomainBattle()
	DomainBattle:NotifyEndDomainWar()
end

function ScheduleTask:NotifyKinDomainBattle()
	DomainBattle:NotifyKinDomainWar()
end

function ScheduleTask:StartDomainBattle()
	DomainBattle:StartActivity()
end

function ScheduleTask:DeclareWarDomainBattle()
	DomainBattle:StartDeclareWar();
end

function ScheduleTask:CloseDomainBattle()

end

function ScheduleTask:ActivityDynamicCallback(szParam)
	Activity:ScheduleCallBack(szParam);
end

function ScheduleTask:CheckAndStartActivity()
	Activity:CheckActivityStartToday();
end

function ScheduleTask:CheckNewMonth()
	CollectionSystem:CheckNewMonth()
end

function ScheduleTask:CheckFirstCollection()
	CollectionSystem:CheckBeginFirstActivity()
end

function ScheduleTask:UpdateCollectionRankBoard()
	CollectionSystem:UpdateRank()
end

function ScheduleTask:MarketStallCheckAllLimit()
	MarketStall:CheckAllLimit();
end

function ScheduleTask:MarketStallOutputLimitData()
	MarketStall:OutputLimitDataInfo();
end

function ScheduleTask:MarketStallCheckWarningMail()
	MarketStall:DoCheckSendWarningMail()
end

function ScheduleTask:TeacherStudentDaily()
	TeacherStudent:DoDaily()
end

function ScheduleTask:AcutionAwardDomainBattle()
	DomainBattle:AddOnwenrAcutionAward()
end

function ScheduleTask:StartImperialTomb()
	ImperialTomb:Open()
end

function ScheduleTask:CloseImperialTomb()
	ImperialTomb:Close()
end

function ScheduleTask:StartEmperor()
	ImperialTomb:OpenEmperor()
end

function ScheduleTask:StartFemaleEmperor()
	ImperialTomb:OpenEmperor(true)
end

function ScheduleTask:CallBoss()
	ImperialTomb:CallBoss()
end

function ScheduleTask:CallEmperor()
	ImperialTomb:CallEmperor()
end

function ScheduleTask:ClearEmperorData()
	ImperialTomb:ClearEmperorData()
	ImperialTomb:ClearBossData()
end

function ScheduleTask:CloseEmperor()
	ImperialTomb:CloseEmperor()
end

function ScheduleTask:SaveAllPlayerQueryData()
	if not version_vn then
		return
	end
	Log("ScheduleTask:SaveAllPlayerQueryData Begin")
	KPlayer.SaveAllPlayerQueryData()
	Log("ScheduleTask:SaveAllPlayerQueryData End")
end

function ScheduleTask:StopBattleCalender()
	Battle:StopBattleCalender()
end

function ScheduleTask:ChanageZone(szType, szActName, szCloseActName, szGroup)
	Server:ChangeZoneGroup(szType, szActName, szCloseActName, szGroup)
end

--和跨服城战有冲突需要特殊处理
function ScheduleTask:ChanageTeamBattleZone(szType, szActName, szCloseActName, szGroup)
	--如果跨服攻城战开启(每月最后一周周日)则关闭通天塔
	if DomainBattle.tbCross:CheckCrossDay() then
		return
	end
	if KinEncounter:IsRunning() then
		return
	end
	Server:ChangeZoneGroup(szType, szActName, szCloseActName, szGroup)
end

function ScheduleTask:ChangeKinEncounterZone(szType, szActName, szCloseActName, szGroup)
	if not KinEncounter:IsOpenToday() then
		return
	end
	Server:ChangeZoneGroup(szType, szActName, szCloseActName, szGroup)
end

function ScheduleTask:OpenIndiffer(szType)
	if MODULE_ZONESERVER then
		InDifferBattle:OpenSignUp(szType);
	end
end

function ScheduleTask:CloseInfiffer()
	--只是一次匹配不走这里
end

function ScheduleTask:OpenIndifferNotify(nMinute)
	KPlayer.SendWorldNotify(InDifferBattle.tbDefine.nMinLevel, 999, string.format("Tâm ma ảo cảnh sẽ mở sau %d phút sau bắt đầu báo danh, thời gian báo danh là  %d phút, mời các đại hiệp hãy mau chóng chuẩn bị!", nMinute, math.floor(InDifferBattle.tbDefine.MATCH_SIGNUP_TIME / 60)), 1, 1)
end

function ScheduleTask:OpenKeyQuestFuben(  )
	if MODULE_ZONESERVER then
		Fuben.KeyQuestFuben:StartSignUp()
	end
end

function ScheduleTask:CloseKeyQuestFuben( )
	-- body
end

function ScheduleTask:CheckCardPickCutAct()
	CardPicker:CheckPickCutAct();
end

function ScheduleTask:UpdateCardPickSchedule()
	CardPicker:UpdateSpecialCardSchedule();
end

function ScheduleTask:CheckCalendarHonor()
	Calendar:CheckMonth()
end

function ScheduleTask:CheckTaskValidTime()
	local tbPlayer = KPlayer.GetAllPlayer()
	for _, pPlayer in ipairs(tbPlayer) do
	    Task:CheckTaskValidTime(pPlayer)
	end
end

function ScheduleTask:StartAuctionDealer()
	Kin:StartAuctionDealer();
end

function ScheduleTask:ShowAuctionDealerItems()
	local bForShow = true;
	Kin:StartAuctionDealer(bForShow);
end

function ScheduleTask:WeddingDaily()
	Wedding:DoDaily()
end

function ScheduleTask:LotteryDraw()
	if version_tx then
		return;
	end

	Lottery:Draw();
end

function ScheduleTask:LotteryNotify()
	if version_tx then
		return;
	end

	Lottery:Notify();
end

function ScheduleTask:LotteryWorldMsg(nMinute)
	if version_tx then
		return;
	end

	Lottery:SendWorldMsg(nMinute);
end

function ScheduleTask:WuLinDaShiDayClose()
	WuLinDaShi:PutUpTheShutters()
end

function ScheduleTask:QYHCrossPreStart()
	QunYingHuiCross.tbQunYingHuiZ:PreStart()
end

function ScheduleTask:QYHCrossStart()
	QunYingHuiCross.tbQunYingHuiZ:Start()
end

function ScheduleTask:QYHCrossEnd()
	-- 不做处理
end

function ScheduleTask:AnalyzeStrongerRecommendData()
	Player.Stronger:AnalyzeRecommendData()
end

function ScheduleTask:CheckFirstAnalyzeStronger()
	Player.Stronger:CheckFirstAnalyze()
end

--local server
function ScheduleTask:OnCrossDomainStartAidSignUp()
	DomainBattle.tbCross:CheckAidSignUp()
end

--local server
function ScheduleTask:OnCrossDomainAidSignUpNotice()
	DomainBattle.tbCross:OnAidSignUpMsg()
end

--local server
function ScheduleTask:OnCrossDomainPrepareNotice()
	DomainBattle.tbCross:OnPrepareNotice()
end

--local server
function ScheduleTask:OnCrossDomainLocalStart()
	DomainBattle.tbCross:OnLocalStart()
end

--local server
function ScheduleTask:OnCrossDomainLocalAttendMail()
	DomainBattle.tbCross:SendAttendKinMail()
end

--local server
function ScheduleTask:OnCrossDomainChangeZone(szType, szActName, szCloseActName, szGroup)
	if not DomainBattle.tbCross:CheckCrossDay() then
		return
	end
	Server:ChangeZoneGroup(szType, szActName, szCloseActName, szGroup)
end

--zone server
function ScheduleTask:OnCrossDomainCreateMap()
	DomainBattle.tbCross:CreateBattleMap()
end

--zone server
function ScheduleTask:OnCrossDomainStart()
	DomainBattle.tbCross:Start()
end


--by初心
function ScheduleTask:StartNewBoss()
local szMsg = "Cao thủ thần bí hiện thân giang hồ, các vị hiệp khách nhanh chóng tiêu diệt, nhận thưởng phong phú!";--公告内容
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);
local randomNum1 = MathRandom(1, 2);
local randomNum2 = MathRandom(3, 5);

local npcId1 = 19010+randomNum1;
local npcId2 = 19010+randomNum2;
local mapName ={"Kiến Tính Phong","Kiếm Môn Quan","Điểm Thương Sơn","Phục Ngưu Sơn","Miêu Lĩnh"};
local randomMapIndex1 = MathRandom(1, 2);
local randomMapIndex2 = MathRandom(3, 5);

local mapId1;
local mapX1;
local mapY1;
if randomMapIndex1 == 1 then
	local randomXY = MathRandom(1, 2);
	if randomXY == 1 then
		mapId1 = 407;
		mapX1 = 11946;
		mapY1 = 3914;
	else
		mapId1 = 407;
		mapX1 = 14095;
		mapY1 = 4738;	
	end
else

	local randomXY = MathRandom(1, 2);
	if randomXY == 1 then
		mapId1 = 408;
		mapX1 = 4457;
		mapY1 = 13050;
	else
		mapId1 = 408;
		mapX1 = 2263;
		mapY1 = 11084;	
	end

end


local mapId2;
local mapX2;
local mapY2;
if randomMapIndex2 == 3 then

	local randomXY = MathRandom(1, 2);
	if randomXY == 1 then
		mapId2 = 405;
		mapX2 = 13393;
		mapY2 = 4202;
	else
		mapId2 = 405;
		mapX2 = 12320;
		mapY2 = 4269;	
	end
end

if randomMapIndex2 == 4 then

	local randomXY = MathRandom(1, 2);
	if randomXY == 1 then
		mapId2 = 411;
		mapX2 = 13833;
		mapY2 = 3216;
	else
		mapId2 = 411;
		mapX2 = 11634;
		mapY2 = 3089;	
	end
end

if randomMapIndex2 == 5 then
	local randomXY = MathRandom(1, 2);
	if randomXY == 1 then
		mapId2 = 404;
		mapX2 = 14050;
		mapY2 = 4167;
	else
		mapId2 = 404;
		mapX2 = 13126;
		mapY2 = 3970;	
	end
end


local mapId3;
local mapX3;
local mapY3;

if 6 then
	local randomXY = MathRandom(1, 2);
	if randomXY == 1 then
		mapId3 = 404;
		mapX3 = 14050;
		mapY3 = 4167;
	else
		mapId3 = 404;
		mapX3 = 13126;
		mapY3 = 3970;	
	end
end



KNpc.Add(npcId1, 80, 0, mapId1, mapX1, mapY1, 0);	
KNpc.Add(npcId2, 80, 0, mapId2, mapX2, mapY2, 0);	
KNpc.Add(19016, 80, 0, mapId3, mapX3, mapY3, 0);	

KPlayer.SendWorldNotify(1, 999, "Nghe nói có người phát hiện cao thủ thần bí xuất hiện tại ["..mapName[randomMapIndex1].."]", 1, 1);
KPlayer.SendWorldNotify(1, 999, "Nghe nói có người phát hiện cao thủ thần bí xuất hiện tại ["..mapName[randomMapIndex2].."]一", 1, 1);
KPlayer.SendWorldNotify(1, 999, "Nghe nói có người phát hiện cao thủ thần bí xuất hiện tại [Miêu Lĩnh]", 1, 1);

end



function ScheduleTask:StartHomeBB01()
local szMsg = "Phù Đồ Tháp BOSS hiện thân, các vị đại hiệp nhanh chân đoạt bảo!";--公告内容
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);

local f1 = {
[1]={6759,3419},
[2]={1330,12403},
[3]={7612,14030},
[4]={13040,7881},
[5]={2263,1590},
}

local f2 = {
[1]={2070,9835},
[2]={5148,9869},
[3]={7483,9458},
[4]={9813,6884},
[5]={4151,7818},
}

local f3 = {
[1]={3591,1817},
[2]={8088,3707},
[3]={5147,8281},
[4]={1440,6107},
[5]={3531,3581},
}

local f4 = {
[1]={3591,1817},
[2]={8088,3707},
[3]={5147,8281},
[4]={1440,6107},
[5]={3531,3581},
}
local randomIndex = MathRandom(1, 5);

local f1X = f1[randomIndex][1];
local f1Y = f1[randomIndex][2];

local f2X = f2[randomIndex][1];
local f2Y = f2[randomIndex][2];

local f3X = f3[randomIndex][1];
local f3Y = f3[randomIndex][2];

local f4X = f4[randomIndex][1];
local f4Y = f4[randomIndex][2];


KNpc.Add(19017, 80, 0, 11100, f1X, f1Y, 0);
KNpc.Add(19018, 80, 0, 11101, f2X, f2Y, 0);
KNpc.Add(19019, 80, 0, 11102, f3X, f3Y, 0);
KNpc.Add(19020, 80, 0, 11103, f4X, f4Y, 0);
end


function ScheduleTask:StartHomeBB02()
local szMsg = "Phù Đồ Tháp BOSS hiện thân, các vị đại hiệp nhanh chân đoạt bảo!";--公告内容
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);
KPlayer.SendWorldNotify(1, 999, szMsg, 1, 1);

local f1 = {
[1]={6759,3419},
[2]={1330,12403},
[3]={7612,14030},
[4]={13040,7881},
[5]={2263,1590},
}

local f2 = {
[1]={2070,9835},
[2]={5148,9869},
[3]={7483,9458},
[4]={9813,6884},
[5]={4151,7818},
}

local f3 = {
[1]={3591,1817},
[2]={8088,3707},
[3]={5147,8281},
[4]={1440,6107},
[5]={3531,3581},
}

local f4 = {
[1]={3591,1817},
[2]={8088,3707},
[3]={5147,8281},
[4]={1440,6107},
[5]={3531,3581},
}
local randomIndex = MathRandom(1, 5);

local f1X = f1[randomIndex][1];
local f1Y = f1[randomIndex][2];

local f2X = f2[randomIndex][1];
local f2Y = f2[randomIndex][2];

local f3X = f3[randomIndex][1];
local f3Y = f3[randomIndex][2];

local f4X = f4[randomIndex][1];
local f4Y = f4[randomIndex][2];


KNpc.Add(19017, 80, 0, 11100, f1X, f1Y, 0);
KNpc.Add(19018, 80, 0, 11101, f2X, f2Y, 0);
KNpc.Add(19019, 80, 0, 11102, f3X, f3Y, 0);
KNpc.Add(19020, 80, 0, 11103, f3X, f3Y, 0);

end



function ScheduleTask:KickoutPlayerBbHome()
    local tbPlayer = KPlayer.GetMapPlayer(11100)
    for _, pPlayer in ipairs(tbPlayer) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer2 = KPlayer.GetMapPlayer(11101)
    for _, pPlayer in ipairs(tbPlayer2) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer3 = KPlayer.GetMapPlayer(11102)
    for _, pPlayer in ipairs(tbPlayer3) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer4 = KPlayer.GetMapPlayer(11103)
    for _, pPlayer in ipairs(tbPlayer4) do
        pPlayer.GotoEntryPoint()
    end
end


function ScheduleTask:KickoutPlayerBbHome1()
    local tbPlayer = KPlayer.GetMapPlayer(11100)
    for _, pPlayer in ipairs(tbPlayer) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer2 = KPlayer.GetMapPlayer(11101)
    for _, pPlayer in ipairs(tbPlayer2) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer3 = KPlayer.GetMapPlayer(11102)
    for _, pPlayer in ipairs(tbPlayer3) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer4 = KPlayer.GetMapPlayer(11103)
    for _, pPlayer in ipairs(tbPlayer4) do
        pPlayer.GotoEntryPoint()
    end
end


function ScheduleTask:KickoutPlayerBbHome2()
    local tbPlayer = KPlayer.GetMapPlayer(11100)
    for _, pPlayer in ipairs(tbPlayer) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer2 = KPlayer.GetMapPlayer(11101)
    for _, pPlayer in ipairs(tbPlayer2) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer3 = KPlayer.GetMapPlayer(11102)
    for _, pPlayer in ipairs(tbPlayer3) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer4 = KPlayer.GetMapPlayer(11103)
    for _, pPlayer in ipairs(tbPlayer4) do
        pPlayer.GotoEntryPoint()
    end
end

function ScheduleTask:KickoutPlayerBbHome3()
    local tbPlayer = KPlayer.GetMapPlayer(11100)
    for _, pPlayer in ipairs(tbPlayer) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer2 = KPlayer.GetMapPlayer(11101)
    for _, pPlayer in ipairs(tbPlayer2) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer3 = KPlayer.GetMapPlayer(11102)
    for _, pPlayer in ipairs(tbPlayer3) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer4 = KPlayer.GetMapPlayer(11103)
    for _, pPlayer in ipairs(tbPlayer4) do
        pPlayer.GotoEntryPoint()
    end
end

function ScheduleTask:KickoutPlayerBbHome4()
    local tbPlayer = KPlayer.GetMapPlayer(11100)
    for _, pPlayer in ipairs(tbPlayer) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer2 = KPlayer.GetMapPlayer(11101)
    for _, pPlayer in ipairs(tbPlayer2) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer3 = KPlayer.GetMapPlayer(11102)
    for _, pPlayer in ipairs(tbPlayer3) do
        pPlayer.GotoEntryPoint()
    end
	
	local tbPlayer4 = KPlayer.GetMapPlayer(11103)
    for _, pPlayer in ipairs(tbPlayer4) do
        pPlayer.GotoEntryPoint()
    end
end

