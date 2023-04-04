--新年登录领奖
local tbAct = Activity:GetClass("NewServerFirstLoginAward")
tbAct.tbTimerTrigger = 
{    
}

tbAct.tbTrigger  =
{
    Init  = {},
    Start = {},
    End   = {},
}

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
    elseif szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerFirstLogin", "OnFirstLogin")
    end
end


function tbAct:OnFirstLogin(pPlayer)
    Mail:SendSystemMail({
        To = pPlayer.dwID;
        Title = "《Vong ưu trấn》Hỗ động gói quà";
        Text = "Thiếu hiệp, nhiều ngày không thấy nhưng từng mạnh khỏe? Ở đây cám ơn thiếu hiệp hôm đó vong ưu trong trấn tương trợ, vi biểu lòng biết ơn, hôm nay ta cùng lệ dĩnh vì hiệp sĩ đặc biệt chuẩn bị lễ mọn một phần, còn xin vui vẻ nhận.";
        tbAttach = { { "item", 2180, 1 }, {"item", 2181, 1} };
        From = "Dương đại hiệp";
        })
end

