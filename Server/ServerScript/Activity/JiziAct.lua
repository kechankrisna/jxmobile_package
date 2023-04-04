local tbAct     = Activity:GetClass("JiziAct")
tbAct.tbTrigger = {Init = {}, Start = {}, End = {}}
tbAct.tbNpcBubbleTalk = {
    --{nMapId, nNpcTemplateId, szContent}
    {10, 620, "Ta họ Đường, Đường Môn Đường. Chúng ta sẽ tại giang hồ thịnh điển gặp lại......"},
    {10, 621, "Gần đây vô sự, ta dự định đi giang hồ thịnh điển giải sầu một chút, ngươi đi không?"},
    {10, 630, "Giang hồ thịnh điển thịnh huống chưa bao giờ có! Hẳn là ngư long hỗn tạp...... Muốn bảo đảm vạn vô nhất thất mới được!"},
    {10, 90, "Giang hồ thịnh điển nhất định chơi rất vui đi? Tốt lo lắng cha không cho phép ta đi......"},
    {10, 622, "Giang hồ thịnh điển sắp tổ chức, các vị hào hiệp muốn tích cực tham dự a!"},
    {10, 629, "Giang hồ thịnh điển, mỗi năm một lần võ lâm thịnh sự! Thế nào có thể thiếu đi lão phu?"},
    {10, 623, "Có người hay không mang ta đi giang hồ thịnh điển nhìn xem náo nhiệt nha? Nhất định có không ít bảo bối tốt!"},
    {10, 100, "Giang hồ thịnh điển các ngươi những này có triển vọng hậu bối tới kiến thức hạ liền tốt, lão phu liền không đi tham gia náo nhiệt."},
    {10, 97, "Vạn chúng chú mục giang hồ thịnh điển, kia...... Kia dương ảnh phong cũng sẽ đi thôi?"},
    {10, 99, "Vãng lai thương khách đều đàm luận cái này giang hồ thịnh điển, chắc là phi thường náo nhiệt!"},
    {10, 626, "Các ngươi hậu bối đều chú mục nơi này giang hồ thịnh điển, mà lão phu ý không ở chỗ này......"},
    {10, 627, "Cùng bang phái thành viên gặp nhau giang hồ thịnh điển, nâng cốc ngôn hoan, cũng không nên quên lão phu a!"},
    {10, 624, "Cái này võ lâm thịnh sự tại hạ có thể nào vắng mặt? Chúng ta giang hồ thịnh điển gặp!"},
    {10, 88, "Giang hồ thịnh điển sắp với [FFFE0D]2017.10.29[-] Tổ chức, nhìn trong chốn võ lâm các vị hào hiệp, đồng đều có thể trình diện cộng đồng ăn mừng!"},
    {10, 631, "Bồi tiếp Phi Vân cùng nhau đi giang hồ thịnh điển cũng chưa hẳn không thể, nhưng là......"},
    {10, 632, "Ta muốn đi giang hồ thịnh điển tìm ảnh Phong ca ca!"},
    {10, 625, "Giang hồ thịnh điển sắp tổ chức, còn xin các vị hào hiệp tiếp tục chú ý!"},
    {10, 694, "Giang hồ thịnh điển sắp tổ chức, các vị hào hiệp muốn tích cực tham dự a!"},
    {10, 91, "Mỗi năm một lần giang hồ thịnh điển, nếu có nhàn rỗi, lão phu cũng muốn đi thấy rầm rộ......"},
    {10, 633, "Cái gì? Giang hồ thịnh điển nơi nào có không đi đạo lý?"},
    {10, 1350, "Không biết cái này giang hồ thịnh điển bên trong có hay không có thể tự xét lại tăng tiến chỗ, ta mau mau đến xem......"},
    {10, 89, "Cái này giang hồ thịnh điển nhất định là cao thủ tụ tập a, muốn đi thấy chút việc đời, giao mấy người bằng hữu ha ha ha!"},
    {10, 92, "Giang hồ thịnh điển loại này toàn bộ võ lâm đại sự, cũng khó nói...... Không được, ta nhất định phải đi một chuyến!"},
    {10, 1529, "Đi giang hồ thịnh điển tiêu khiển giải sầu có thể, nhưng vi sư phân phó nhưng tuyệt đối không thể quên."},
    {10, 1528, "Thú vị thú vị, cái này giang hồ thịnh điển bản công tử cũng phải đi nhìn xem!"},
    {10, 1530, "Không muốn chỉ muốn giang hồ thịnh điển! Hừ! Phải nhớ được đến Đào Hoa đảo tìm ta chơi a!"},
    {10, 190, "Giang hồ thịnh điển? Hắc hắc hắc, lại là phát tài cơ hội tốt......"},
    {10, 1666, "Phụ trương phụ trương, giang hồ thịnh điển sắp tổ chức!"},
    {10, 1667, "Rất ca cả ngày nhớ giang hồ thịnh điển, cũng không biết tới tìm ta, ai......"},
    {10, 1829, "A Di Đà Phật, thịnh điển chi náo nhiệt vui mừng thật không phải bần tăng chỗ vui, vẫn là tĩnh tâm trông coi thôi......"},
    {10, 2279, "Ta sẽ tại [FFFE0D]2017.10.29[-] Có mặt giang hồ thịnh điển, các vị thiếu hiệp nhất định phải tới cổ động a!"},
    {10, 2326, "Ta sẽ tại [FFFE0D]2017.10.29[-] Có mặt giang hồ thịnh điển, các vị thiếu hiệp nhất định phải tới cổ động a!"},
    {10, 2371, "Giang hồ đường quanh co, trân quý đoạn này duyên......"},
    {10, 2372, "Còn không định đi giang hồ thịnh điển? Ngươi tâm tâm niệm niệm một nửa khác có thể ngay tại loại kia lấy ngươi!"},
    {10, 2373, "Ngươi thật muốn tự mình một người lẻ loi trơ trọi đi giang hồ thịnh điển sao?"},
}
tbAct.tbAward = {
    [1] =
    {
        tbFixedItem  = {{"Item", 6775, 1}},
        tbRandomItem = {{6686, 12500},{6687, 12500},{6688, 12500},{6689, 12500},{6691, 12500},{6690, 12500},{6692, 12500},{6693, 12500},}
    },
    [2] =
    {
        tbFixedItem  = {{"Item", 6776, 1}},
        tbRandomItem = {{6686, 37500},{6687, 37500},{6688, 37500},{6689, 37500},{6691, 37500},{6690, 37500},{6692, 37500},{6693, 37500},}
    },
    [3] =
    {
        tbFixedItem  = {{"Item", 6777, 1}},
        tbRandomItem = {{6686, 50000},{6687, 50000},{6688, 50000},{6689, 50000},{6691, 50000},{6690, 50000},{6692, 50000},{6693, 50000},}
    },
    [4] =
    {
        tbFixedItem  = {{"Item", 6778, 1}},
        tbRandomItem = {{6686, 87500},{6687, 87500},{6688, 87500},{6689, 87500},{6691, 87500},{6690, 87500},{6692, 87500},{6693, 87500},}
    },
    [5] =
    {
        tbFixedItem  = {{"Item", 6779, 1}},
        tbRandomItem = {{6686, 125000},{6687, 125000},{6688, 125000},{6689, 125000},{6691, 125000},{6690, 125000},{6692, 125000},{6693, 125000},}
    },
}
tbAct.MAX_RANDOM = 1000000
function tbAct:OnTrigger(szEvent)
    if szEvent == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_EverydayTargetGainAward", "OnEverydayAward")
        Timer:Register(Env.GAME_FPS, self.AddNpcBubbleTalk, self)
    end
end

function tbAct:AddNpcBubbleTalk()
    if not self.tbParam[2] then
        return
    end
    local tbBubbleTime = Lib:SplitStr(self.tbParam[2], "-")
    if GetTime() >= Lib:ParseDateTime(tbBubbleTime[2]) then
        return
    end

    for _, tbInfo in ipairs(self.tbNpcBubbleTalk) do
        tbInfo[4] = tbBubbleTime[1]
        tbInfo[5] = tbBubbleTime[2]
        NpcBubbleTalk:Add(unpack(tbInfo))
    end
end

function tbAct:OnEverydayAward(pPlayer, nAwardIdx)
    if self.tbParam[1] and GetTime() > Lib:ParseDateTime(self.tbParam[1]) then
        return
    end

    local tbAwardInfo = self.tbAward[nAwardIdx]
    if not tbAwardInfo then
        return
    end

    local tbAward = Lib:CopyTB(tbAwardInfo.tbFixedItem)
    local nRate = MathRandom(self.MAX_RANDOM)
    local nRateSum = 0
    for i, tbItem in ipairs(tbAwardInfo.tbRandomItem) do
        nRateSum = nRateSum + tbItem[2]
        if nRate <= nRateSum then
            local nEndTime = Lib:ParseDateTime(self.tbParam[1])
            table.insert(tbAward, {"Item", tbItem[1], 1, nEndTime})
            break
        end
    end
    pPlayer.SendAward(tbAward, true, false, Env.LogWay_JiziAct)
    Log("JiziAct OnEverydayAward:", pPlayer.dwID, nAwardIdx, nRate)
end