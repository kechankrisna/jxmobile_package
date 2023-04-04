local tbAct = Activity:GetClass("LaoDongJie")
tbAct.tbTimerTrigger = {
}
tbAct.tbTrigger = { 
    Init = {},
    Start = {},
    End = {},
}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
    elseif szTrigger == "Start" then
    elseif szTrigger == "End" then
    end
    Log("LaoDongJie OnTrigger:", szTrigger)
end

function tbAct:GetUiData()
    if not self.tbUiData then
        local tbData = {}
        tbData.nShowLevel = 20
        tbData.szTitle = "Lao động vinh quang nhất"
        tbData.nBottomAnchor = 0

        local nStartTime, nEndTime = self:GetOpenTimeInfo()
        local tbTime1 = os.date("*t", nStartTime)
        local tbTime2 = os.date("*t", nEndTime)
        tbData.szContent = string.format([[Thời gian hoạt động: [c8ff00]%s Năm %s Nguyệt %s Nhật %d Điểm -%s Năm %s Nguyệt %s Nhật %s Điểm [-]
Ngày Quốc Tế Lao Động tới!
]], tbTime1.year, tbTime1.month, tbTime1.day, tbTime1.hour, tbTime2.year, tbTime2.month, tbTime2.day, tbTime2.hour)
        tbData.tbSubInfo = {}
        table.insert(tbData.tbSubInfo, {szType = "Item2", szInfo = [[Hoạt động một     Huy hiệu tranh đoạt chiến:
Hoạt động trong lúc đó đại hiệp sinh động độ đạt tới [FFFE0D]60[-], [FFFE0D]80[-], [FFFE0D]100[-], mở ra đối ứng [FFFE0D] Sinh động bảo rương [-], sẽ thu hoạch được [11adf6][url=openwnd: Lao động huy hiệu, ItemTips, "Item", nil, 7699][-], đại hiệp có thể coi đây là thẻ đánh bạc tham gia huy hiệu tranh đoạt chiến!
Huy hiệu tranh đoạt chiến lúc đối chiến ở giữa vì [FFFE0D]19:00-19:30[-], các đại hiệp nhớ kỹ tại trong lúc này tiến về bang phái quyền sở hữu thông qua bổn trang mặt tham dự hoạt động, thắng được người khác huy hiệu!
Cuối cùng hoạt động kết thúc lúc lại dựa theo các đại hiệp huy hiệu số lượng xếp hạng cấp cho ban thưởng, mau tới tranh đoạt [FFFE0D] Chiến sĩ thi đua [-] Xưng hào đi! Kết toán lúc đầy [FFFE0D]10[-] Cái huy hiệu đều sẽ có ban thưởng a!
[FFFE0D] Chú [-]: Hoạt động trong lúc đó bang phái bài thi tạm thời hủy bỏ
]], szBtnText = "Mở ra tham dự giới mặt", szBtnTrap = "[url=openwnd:Mở ra tham dự giới mặt, MedalFightWaitPanel]"})
        table.insert(tbData.tbSubInfo, {szType = "Item2", szInfo = [[Hoạt động hai     Lao động vinh quang nhất:
Hoạt động trong lúc đó Nguyên bảo bảo dưỡng sẽ thu hoạch được cao hơn ban thưởng!
]], szBtnText = "Mở ra hiệp trợ giới mặt", szBtnTrap = "[url=openwnd:Mở ra hiệp trợ giới mặt, PlantHelpCurePanel]"})

        self.tbUiData = tbData
    end
    return self.tbUiData
end