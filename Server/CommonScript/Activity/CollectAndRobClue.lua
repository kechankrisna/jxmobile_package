if not MODULE_GAMESERVER then
    Activity.CollectAndRobClue = Activity.CollectAndRobClue or {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("CollectAndRobClue") or Activity.CollectAndRobClue

tbAct.szActStartMailTitle = "Ngày Lễ-Thần Châu Đại Địa";
tbAct.szActStartMailText = [[         Hoạt động thu thập tầm bảo Thần Châu đã mở, thời gian hoạt động là [FFFE0D]01/06/2019-01/07/2019[-]. 
                Kho báu Thần Châu sắp xuất hiện, hãy mau tham gia tầm bảo! Đây là [ff8f06] [url=openwnd:Hộp Thu Thập Thần Châu Bảo Quyển, ItemTips, "Item", nil, 6468] [-], hãy nhận!
                Chi tiết hãy nhấp và xem tại trang [FFFE0D][url=openwnd:Tin mới, NewInformationPanel, 'CollectAndRobClue'][-]. 

]];

tbAct.nMinLevel = 30; --活动参与最小等级
tbAct.szNewsText = [[
    Hoạt động Thần Châu Đại Địa đã bắt đầu!
      Thời gian hoạt động: [FFFE0D]01/06/2019-01/07/2019[-]
      Cấp tham gia: [FFFE0D]Lv30[-]
      Trong thời gian hoạt động, thu thập đủ 25 Mảnh Bản Đồ thông qua tầm bảo để ghép thành [ff8f06] [url=openwnd:Thần Châu Bảo Quyển, ItemTips, "Item", nil, 6386] [-], dùng có cơ hội nhận [aa62fc] [url=openwnd:Dịch Cốt Kinh, ItemTips, "Item", nil, 7912] [-], [aa62fc] [url=openwnd:Tẩy Tủy Kinh-Hạ, ItemTips, "Item", nil, 3716] [-], [ff578c] [url=openwnd:Phụ Ma Thạch-Tấn Công Lv3, ItemTips, "Item", nil, 1526] [-], [ff8f06] [url=openwnd:Phụ Ma Thạch-Tấn Công Lv4, ItemTips, "Item", nil, 3313] [-], [FFFE0D] [url=openwnd:Phụ Ma Thạch-Tấn Công Lv5, ItemTips, "Item", nil, 3314] [-], [FFFE0D] [url=openwnd:Bạch Kim Đồ Phổ (Nón) , ItemTips, "Item", nil, 10006] [-], [FFFE0D] [url=openwnd:Bạch Kim Đồ Phổ (Đai) , ItemTips, "Item", nil, 10007] [-], [FFFE0D] [url=openwnd:Bạch Kim Đồ Phổ (Hộ Uyển) , ItemTips, "Item", nil, 10008] [-], [FFFE0D] [url=openwnd:Bạch Kim Đồ Phổ (Giày) , ItemTips, "Item", nil, 10009] [-], [ff8f06] [url=openwnd:Thủy Tinh Cam, ItemTips, "Item", nil, 225] [-], [ff8f06] [url=openwnd:Thẻ Môn Khách S, ItemTips, "Item", nil, 8525] [-], [ff8f06] [url=openwnd:Thẻ Môn Khách SS, ItemTips, "Item", nil, 8526] [-], [ff8f06] [url=openwnd:Hộp Chọn Vũ Khí Bổn Mạng Cấp SS, ItemTips, "Item", nil, 3693] [-], [aa62fc] [url=openwnd:Đá Hồn Lv4 Ngẫu Nhiên, ItemTips, "Item", nil, 2169] [-], [ff578c] [url=openwnd:Hộp Chọn Bí Quyển Thông Huyệt, ItemTips, "Item", nil, 6537] [-]!
      Manh Mối Bảo Quyển có thể nhận từ [FFFE0D]Rương Năng Động Ngày[-] (Mỗi mốc rương năng động có 3 Manh Mối Bảo Quyển), cũng có thể mua từ [FFFE0D]Kỳ Trân Các[-]. Dựa vào manh mối có thể tìm được mảnh phân quyển, ghép 10 mảnh thành phân quyển tương ứng. Trong quá trình tìm kiếm, có cơ hội gặp Hành Thương Giang Hồ và Giang Nam Phú Giả, có thể mua [11adf6] [url=openwnd:Mảnh Càn Khôn Phân Quyển, ItemTips, "Item", nil, 6414] [-] từ họ!
      Đặt tất cả phân quyển và mảnh vào [ff8f06] [url=openwnd:Hộp Thu Thập Thần Châu Bảo Quyển, ItemTips, "Item", nil, 6468] [-], có thể mở hộp tặng mảnh đã chọn cho hảo hữu/thành viên bang, cũng có thể đoạt mảnh ngẫu nhiên từ kẻ thù/người lạ. Khi rời mạng vẫn có thể bị đoạt mất các mảnh này. (Khi hoạt động kết thúc, có thể bán các đạo cụ liên quan, các phân quyển và mảnh đặt trong Hộp Thu Thập cũng được tính gộp chung khi bán hộp)

]]; 

--不同活跃时获取的奖励
tbAct.nEverydayTargetAward = 6387
tbAct.tbEverydayTargetAwardCount = {
	[1] = 3;
	[2] = 3;
	[3] = 3;
	[4] = 3;
	[5] = 3;
};

tbAct.szNewsTitle = "Ngày Lễ-Thần Châu Đại Địa" --

tbAct.RefreshTime = 3600 * 4; --刷新时间

tbAct.MAX_CLUE_MSG_COUNT = 50; --收纳盒最多记录的消息条目数
tbAct.RequestRobListInterval = 600; --请求强求列表cd 不能太短
tbAct.MAX_ROBED_COUNT = 10; --最多被抢夺次数
tbAct.MAX_ROB_COUNT = 10; --最多抢夺次数
tbAct.ROB_CD = 3600; --抢夺cd

tbAct.MAX_GETSEND_COUNT = 20; --每日被赠送上限次数
tbAct.MAX_SEND_COUNT = 20; --每日赠送上限次数
tbAct.SEND_CD = 1800; --赠送cd

tbAct.nRobAddHate = 10000; --抢碎片增加的仇恨值


tbAct.tbCombieDebrisAward = { {"item", 6532, 1} }; --碎片合成残卷时的奖励



tbAct.LogWayType_Rob = 1; -- 被抢夺
tbAct.LogWayType_OpenBox = 2; -- 挖宝打开宝箱
tbAct.LogWayType_OpenPosin = 3; -- 挖宝打开毒箱子
tbAct.LogWayType_AttackNpc = 4; -- 挖宝打开夺宝贼
tbAct.LogWayType_DialogNpc = 5; -- 对话npc购买
tbAct.LogWayType_RobOther  = 6; -- 抢夺他人获得
tbAct.LogWayType_Combine  = 7; -- 合成碎片
tbAct.LogWayType_GetSend  = 8; -- 被人赠与获得
tbAct.LogWayType_Send  = 9; -- 送给他人扣除


tbAct.tbLogWayDesc = {
	[tbAct.LogWayType_Rob] = "[ffff00]%s [-] đã đoạt mất [11adf6]%s[-] từ Hộp Thu Thập của đại hiệp!";
	[tbAct.LogWayType_OpenBox] = "[c8ff00]Mở rương %s [-]\nnhận được %s"; --多个奖励
	[tbAct.LogWayType_OpenPosin] = "Bị khí độc làm choáng %s, [11adf6]%s[-] không cánh mà bay!";
	[tbAct.LogWayType_AttackNpc] = "[c8ff00]Đã diệt %s[-]\nnhận được %s"; --多个奖励
	[tbAct.LogWayType_DialogNpc] = "May mắn gặp được %s, mua được [11adf6]%s[-]";
	[tbAct.LogWayType_RobOther] = "Tấn công [ffff00]%s[-], đoạt được [11adf6]%s[-]!";
	[tbAct.LogWayType_Combine] = "Ghép được %s [11adf6]%s[-]";
	[tbAct.LogWayType_GetSend] = "Được [ffff00]%s[-] tặng [11adf6]%s[-]";
	[tbAct.LogWayType_Send] = "Tặng cho [ffff00]%s[-] [11adf6]%s[-]";
	[Env.LogWay_ChooseItem] = "Tham gia [11adf6]%s[-] nhận được [11adf6]%s[-]";
}




