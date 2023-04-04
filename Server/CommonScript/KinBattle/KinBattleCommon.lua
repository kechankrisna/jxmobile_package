
KinBattle.STATE_NONE = 0;
KinBattle.STATE_PRE = 1;
KinBattle.STATE_FIGHT = 2;

KinBattle.PRE_MAP_ID = 1021;
KinBattle.tbPreMapBeginPos = {5609, 8595};

KinBattle.MAX_PLAYER_COUNT = 20;

KinBattle.FIGHT_MAP_ID = 1023;
KinBattle.tbFightMapBeginPoint = {
	{4150,  6788};
	{14244, 6788};
};

KinBattle.nPreTime = 5 * 60;

KinBattle.nNpcRefreshTime = 60;

KinBattle.fileCommNpc = "Setting/Battle/KinBattle/CommNpcSetting.tab";
-- KinBattle.fileDotaNpc = "Setting/Battle/KinBattle/DotaNpcSetting.tab";
KinBattle.fileWildNpc = "Setting/Battle/KinBattle/WildNpcSetting.tab";
KinBattle.fileMovePath= "Setting/Battle/KinBattle/MovePath.tab";

KinBattle.tbKinRankSetting = {6, 11, 21, 31};

KinBattle.nKinBattleTypeCount = 2;

KinBattle.tbStateTrans = KinBattle.STATE_TRANS;

KinBattle.tbResultKinMsg =
{
	[-1] = "Bang hội đã hòa đối thủ";			--平局
	[0] = "Rất tiếc, bang hội đã chiến bại";				--失败
	[1] = "Chúc mừng bang hội chiến thắng!";			--胜利
}
KinBattle.tbFightByeMsg = "Không có đối thủ, thắng lượt này!";  --轮空

KinBattle.szStartWorldMsg = "Bang Hội Chiến mở vòng báo danh mới, chọn tham gia tại Lịch hoạt động";

KinBattle.szWinText = "Thắng Bang Hội Chiến, mỗi thành viên nhận 1200 điểm cống hiến";
KinBattle.nWinPrestige = 400;
KinBattle.tbWinAward = {
	{"Contrib", 1200};
};

KinBattle.szFailText = "Bang Hội Chiến thất bại, mỗi thành viên nhận 600 điểm cống hiến";
KinBattle.nFailPrestige = 200;
KinBattle.tbFailAward = {
	{"Contrib", 600};
};

KinBattle.szDrawText = "Bang Hội Chiến hòa, mỗi thành viên nhận 900 điểm cống hiến";
KinBattle.nDrawPrestige = 300;
KinBattle.tbDrawAward = {
	{"Contrib", 900};
};



KinBattle.tbTimeTips = {
[[Báo danh   20:50
Khai chiến   21:00]],
[[Báo danh   21:15
Khai chiến   21:20]]
};
KinBattle.szTips = [[· Bang Hội Chiến gồm 2 vòng, mỗi vòng đấu với một bang hội ngẫu nhiên.
· Mỗi vòng thi đấu cùng lúc mở 2 trận, mỗi trận mỗi bang hội tối đa vào 20 người.
· 2 trận đấu khai chiến cùng lúc, nếu bang hội thắng ở cả 2 trận tức bang hội thắng vòng này. Nếu bang hội chỉ thắng 1 trận xem như bang hội hòa vòng này.

· Mỗi trận sẽ giới hạn số người, Bang Chủ tự thiết lập yêu cầu cấp tham gia thi đấu của thành viên bang hội.

]]

