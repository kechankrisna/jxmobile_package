--圣诞礼物
local tbAct = Activity:GetClass("ChristmasGift")

tbAct.MAX_RATE = 1000000
tbAct.tbMapInfo = {
    --[10 地图模板id] = {nRate --产生概率, {nPosX --坐标X, nPosY --坐标Y}}
    [300] = {nRate = 500000, nPosX = 3680, nPosY = 6592}, --藏剑山庄
    [301] = {nRate = 500000, nPosX = 2000, nPosY = 8484}, --武夷禁地
    [302] = {nRate = 500000, nPosX = 4460, nPosY = 7092}, --熔火霹雳
    [303] = {nRate = 500000, nPosX = 2332, nPosY = 3453}, --翠竹幽谷
    [304] = {nRate = 500000, nPosX = 3659, nPosY = 2458}, --呼啸栈道
    [305] = {nRate = 500000, nPosX = 1960, nPosY = 2637}, --雪峰硝烟

    [201] = {nRate = 1000000, nPosX = 3939, nPosY = 1639}, --a1
    [220] = {nRate = 1000000, nPosX = 4035, nPosY = 2690}, --b10
    [225] = {nRate = 1000000, nPosX = 1062, nPosY = 1375}, --c5
    [240] = {nRate = 1000000, nPosX = 4959, nPosY = 5237}, --d10
    [244] = {nRate = 1000000, nPosX = 3076, nPosY = 5722}, --e4
    [260] = {nRate = 1000000, nPosX = 4053, nPosY = 2001}, --f10
    [270] = {nRate = 1000000, nPosX = 1139, nPosY = 6564}, --g10

    [500] = {nRate = 500000, nPosX = 3276, nPosY = 3158}, --山贼秘窟

    [600] = {nRate = 500000, nPosX = 2059, nPosY = 4864}, --藏宝地宫
}
tbAct.nGiftNpcTID = 2123 -- 圣诞老人模板ID
tbAct.nGiftItemTID = 3527 -- 圣诞礼物道具模板ID
tbAct.nRequireLevel = 20
tbAct.MAX_AWARD_COUNT = 60 --活动期间最多只能拿到这么多的道具

tbAct.tbTimerTrigger = 
{
    [1] = {szType = "Day", Time = "10:00" , Trigger = "SendWorldNotify" },
    [2] = {szType = "Day", Time = "13:00" , Trigger = "SendWorldNotify" },
    [3] = {szType = "Day", Time = "19:00" , Trigger = "SendWorldNotify" },
}
tbAct.tbTrigger = { Init = { }, 
                    Start = { {"StartTimerTrigger", 1}, {"StartTimerTrigger", 2}, {"StartTimerTrigger", 3}, },
                    SendWorldNotify = { {"WorldMsg", "Các vị hiệp sĩ, [FFFE0D] Tết nguyên đán, Giáng Sinh [-] Song tiết cùng chúc mừng hoạt động bắt đầu, mọi người có thể thông qua thẩm tra「[FFFE0D] Tin tức mới nhất [-]」Hiểu rõ trong hoạt động cho!", 1} },
                    End = { }, }
function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
        self:SendNews()
    elseif szTrigger == "Start" then
        Activity:RegisterGlobalEvent(self, "Act_OnMapCreate", "OnMapCreate")
        Activity:RegisterNpcDialog(self, self.nGiftNpcTID,  {Text = "Nhận lấy quà giáng sinh", Callback = self.OnNpcDialog, Param = {self}})
        Activity:RegisterNpcDialog(self, self.nGiftNpcTID,  {Text = "Hiểu rõ tường tình", Callback = self.OpenClientUi, Param = {self}})
        local _, nEndTime = self:GetOpenTimeInfo()
        self:RegisterDataInPlayer(nEndTime)
    end
end

function tbAct:OnNpcDialog()
    if me.nLevel < self.nRequireLevel then
        me.CenterMsg(string.format("Mời trước đem đẳng cấp tăng lên tới %d Cấp!", self.nRequireLevel))
        return
    end
    him.tbGetList = him.tbGetList or {}
    if him.tbGetList[me.dwID] then
        me.CenterMsg("Ngươi đã nhận lấy qua ta cho lễ vật, không muốn lòng tham!")
        return
    end

    local tbData = self:GetDataFromPlayer(me.dwID) or {}
    tbData.nGetNum = tbData.nGetNum or 0
    if tbData.nGetNum >= self.MAX_AWARD_COUNT then
        me.CenterMsg("Ngươi đã lĩnh đủ nhiều! Còn lại ta còn muốn cho cái khác thiếu hiệp đâu!")
        return
    end
    tbData.nGetNum = tbData.nGetNum + 1
    self:SaveDataToPlayer(me, tbData)

    him.tbGetList[me.dwID] = true
    me.SendAward({{"Item", self.nGiftItemTID, 1}}, true, false, Env.LogWay_ChristmasGift)

    Activity:OnPlayerEvent(me, "Act_ChristmasGetGift", 1)
end

function tbAct:OpenClientUi()
    me.CallClientScript("Ui:OpenWindow", "NewInformationPanel", "ShuangJieTongQing")
end

function tbAct:OnMapCreate(nMapTID, nMapID)
    local tbInfo = self.tbMapInfo[nMapTID]
    if not tbInfo then
        return
    end

    local nRate = MathRandom(self.MAX_RATE)
    if nRate > tbInfo.nRate then
        return
    end

    local pNpc = KNpc.Add(self.nGiftNpcTID, 1, -1, nMapID, tbInfo.nPosX, tbInfo.nPosY)
    Log("ChristmasGift OnMapCreate And CreateNpc Success", nMapTID, nMapID, pNpc.nId)
end

function tbAct:SendNews()
    local szNewInfoMsg = [[
[FFFE0D]Tết nguyên đán, Giáng Sinh song tiết cùng chúc mừng hoạt động bắt đầu![-]
    [FFFE0D] Thời gian hoạt động [-]: 2017 Năm 12 Nguyệt 25 Nhật 4 Điểm ~~2018 Năm 1 Nguyệt 4 Nhật 24 Điểm
    [FFFE0D] Tham dự đẳng cấp [-]: 20 Cấp

    [FFFE0D]1, tết nguyên đán người tuyết [-]
    Hoạt động trong lúc đó, [FFFE0D] Bang phái quyền sở hữu [-] Sẽ xuất hiện một cái [FFFE0D] Người tuyết [-], [FFFE0D] Bang phái sưởi ấm [-] Lúc bắt đầu có thể tìm nhận lấy một cái [11adf6][url=openwnd: Người tuyết hộp quà, ItemTips, "Item", nil, 3533][-].
    Bang phái sưởi ấm [FFFE0D] Bài thi [-] Lúc, có thể có được [11adf6][url=openwnd: Bông tuyết, ItemTips, "Item", nil, 3532][-], có thể đi tìm người tuyết tiến hành「[FFFE0D] Đống tuyết người [-]」Thao tác, có thể thu được [FFFE0D] Kinh nghiệm [-] Ban thưởng.
    Người tuyết chồng chất nhất định số lần, có thể [FFFE0D] Thăng cấp biến lớn [-], đồng thời, đối [FFFE0D] Bên trên một đẳng cấp [-] Người tuyết tiến hành qua「[FFFE0D] Đống tuyết người [-]」Thao tác bang phái thành viên có thể thu được ngoài định mức「[FFFE0D] Người tuyết hộp quà [-]」.
    
    [FFFE0D]2, quà giáng sinh [-]
    Hoạt động trong lúc đó, tại [FFFE0D] Tổ đội bí cảnh [-], [FFFE0D] Lăng tuyệt phong [-], [FFFE0D] Sơn tặc bí quật [-] Cùng [FFFE0D] Đào bảo [-] Xuất hiện địa cung bên trong, khả năng gặp được [FFFE0D] Ông già Noel [-], cùng nó đối thoại có thể thu hoạch được quà giáng sinh [11adf6][url=openwnd: Giáng Sinh bít tất, ItemTips, "Item", nil, 3527][-], mở ra có thể thu được phong phú ban thưởng, có lẽ có cơ hội thu hoạch được [11adf6][url=openwnd: Giáng Sinh bánh kẹo, ItemTips, "Item", nil, 3535][-].
    [FFFE0D] Chú [-]: Đại hiệp tại hoạt động trong lúc đó chỉ có thể lấy thu hoạch được 60 Phần ông già Noel lễ vật a!

    [FFFE0D]3, tâm tưởng sự thành [-]
    Hoạt động trong lúc đó, tại mở ra [FFFE0D] Sinh động bảo rương [-], hoàn thành [FFFE0D] Gia viên hiệp trợ [-], đánh giết [FFFE0D] Dã ngoại tinh anh [-], công kích [FFFE0D] Dã ngoại thủ lĩnh [-] Lúc đại hiệp có cơ hội thu hoạch được [11adf6][url=openwnd: Chưa giám định cầu nguyện phù, ItemTips, "Item", nil, 7346][-], giám định sau nhưng ngẫu nhiên thu hoạch được [11adf6][url=openwnd: Hi hữu cầu nguyện phù, ItemTips, "Item", nil, 7349][-] Hoặc là [11adf6][url=openwnd: Phổ thông cầu nguyện phù, ItemTips, "Item", nil, 7348][-], cầu nguyện phù có thể cầm tới [FFFE0D] Lâm An [-] [FFFE0D] Giáng Sinh thiếu nữ [-] Chỗ cầu nguyện thu hoạch được điểm tích lũy, mỗi tiêu hao một trương [11adf6][url=openwnd: Hi hữu cầu nguyện phù, ItemTips, "Item", nil, 7349][-] Có thể thu hoạch được một lần lưu lại chúc phúc cơ hội! Hoạt động kết thúc lúc đem dựa theo điểm tích lũy xếp hạng cấp cho quà tặng.
    Chú ý [11adf6][url=openwnd: Chưa giám định cầu nguyện phù, ItemTips, "Item", nil, 7346][-] Là có thời gian hạn định a! Nếu như đại hiệp [FFFE0D] Chưa giám định cầu nguyện phù [-] Dùng không hết, có thể lựa chọn phong ấn nó biến thành [11adf6][url=openwnd: Phong ấn cầu nguyện phù, ItemTips, "Item", nil, 7347][-] Bày quầy bán hàng bán, kiếm lấy một phần thu nhập thêm đâu!
    [FFFE0D] Chú [-]: Đại hiệp mỗi ngày chỉ có thể lấy giám định 15 Trương [FFFE0D] Cầu nguyện phù [-].

    [FFFE0D]4, tay lưu dư hương [-]
    Hoạt động trong lúc đó, đang tiến hành trước ba cái hoạt động thường có cơ hội thu hoạch được [11adf6][url=openwnd: Tặng phẩm · Ngày hội hộp quà, ItemTips, "Item", nil, 7350][-], có thể đem nó lấy ra tặng cho ngươi hảo hữu, hảo hữu của ngươi sẽ thu được một phần tinh mỹ [11adf6][url=openwnd: Ngày hội hộp quà, ItemTips, "Item", nil, 7351][-], mở ra có thể thu hoạch được tinh mỹ quà tặng! Mong ước tình nghĩa của các ngươi lâu dài!
    ]]

    local nEndTime = Activity:GetActEndTime(self.szKeyName)
    NewInformation:AddInfomation("ShuangJieTongQing", nEndTime, {szNewInfoMsg}, { szTitle = "Song tiết cùng chúc mừng"})
end

--礼盒传情
local tbLHAct = Activity:GetClass("LiHeChuanQing")
tbLHAct.tbJoinActInfo = {
    Rank = 10000,
}
tbLHAct.nBoxTID = 10
tbLHAct.MAX_RATE = 1000000

tbLHAct.tbTrigger = { Init = { }, Start = { }, End = { }, }
function tbLHAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_OnJoinAct", "OnJoinAct")
    end
end

function tbLHAct:OnJoinAct(pPlayer, szAct)
    if not self.tbJoinActInfo[szAct] then
        return
    end

    local nRate = MathRandom(self.MAX_RATE)
    if nRate > self.tbJoinActInfo[szAct] then
        return
    end

    pPlayer.SendAward({{"Item", self.nBoxTID, 1}}, true, false, Env.LogWay_LiHeChuanQing)
    Log("ChristmasGift OnJoinAct And SendAward", pPlayer.dwID, szAct)
end