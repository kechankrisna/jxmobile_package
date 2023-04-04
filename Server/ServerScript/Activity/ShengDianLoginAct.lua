local tbAct = Activity:GetClass("ShengDianLoginAct")
tbAct.tbTrigger  =
{
    Init  = {},
    Start = {},
    End   = {},
}
tbAct.TIME = 4*3600
tbAct.tbAttach = {
    [7] = {{"Item", 1927, 100}},
    [6] = {{"Item", 224, 1}},
    [5] = {{"Item", 2569, 1}},
    [4] = {{"Coin", 3000}},
    [3] = {{"Contrib", 3000}},
    [2] = {{"Item", 1930, 2}},
    [1] = {{"Coin", 5000}},
}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Start" then
        local _, nEndTime = self:GetOpenTimeInfo()
        self:RegisterDataInPlayer(nEndTime)
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnLogin")
    end
end

function tbAct:OnLogin(pPlayer)
    local nDay = Lib:GetLocalDay(GetTime() - self.TIME)
    local tbData = self:GetDataFromPlayer(pPlayer.dwID) or {}
    if not tbData[nDay] then
        tbData[nDay] = true
        self:SaveDataToPlayer(pPlayer, tbData)
        self:SendEmail(pPlayer.dwID)
    end
end

function tbAct:SendEmail(nId)
    local _, nEndTime = self:GetOpenTimeInfo()
    local nLastDay = Lib:GetLocalDay(nEndTime - self.TIME) - Lib:GetLocalDay(GetTime() - self.TIME) + 1
    local tbAward = self.tbAttach[nLastDay]
    if not tbAward then
        return
    end
    local szTxt = [[Cách 【 Giang hồ thịnh điển · Duyên tụ giang hồ 】 Buổi trình diễn thời trang long trọng khai mạc còn có [FFFE0D]%s[-] Trời!\n Giang hồ thịnh điển đếm ngược hiện đã mở ra, đếm ngược trong lúc đó bên trong chư vị thiếu hiệp có thể thông qua thư tín nhận lấy mỗi ngày đếm ngược đăng nhập ban thưởng.\n Thịnh điển buổi trình diễn thời trang đem với [FFFE0D]2017.10.29 Nhật 18:30-20:30[-] Tiến hành trực tiếp, quá trình bên trong sẽ có càng nhiều kinh hỉ đại lễ xin đợi chư vị thiếu hiệp, kính thỉnh chú ý!]]
    szTxt = string.format(szTxt, nLastDay)
    Mail:SendSystemMail({
        To = nId,
        Title = "Giang hồ thịnh điển đếm ngược",
        Text = szTxt,
        tbAttach = tbAward,
    })
end