
local tbAct = Activity:GetClass("AllPeopleWelfare");

tbAct.tbTimerTrigger = 
{
};

tbAct.tbTrigger = 
{
    Init = {},
    Start = {},
    End = {},
};

tbAct.tbNewInfo_Old = 
{
    szTitle = "Phúc Lợi Toàn Dân";
    szContent =
[[
      Võ lâm minh chủ đặc lệnh, hiệp sĩ tiến vào chiếm giữ 4 Nguyệt 12 Nhật 0 Điểm đến 5 Nguyệt 1 Nhật 0 Điểm ở giữa mở ra server, có thể đạt được nhàn nhã nhã cư phim tư liệu độc hưởng tăng thêm phúc lợi. Trợ lực chúng hiệp sĩ sớm ngày độc bộ võ lâm!( Tăng thêm phúc lợi đem tiếp tục đến mở ra 59 Cấp đẳng cấp hạn mức cao nhất )
      Phúc lợi một: [ffcc00] Chung chiến [-]. Dã ngoại tu luyện đánh quái thu hoạch được kinh nghiệm gia tăng 10%.
      Phúc lợi hai: [ffcc00] Tài vận [-]. Thông qua cây rụng tiền, mỗi ngày mục tiêu, ngẫu nhiên địa cung, dã ngoại tu luyện, thương hội nhiệm vụ thu hoạch được ngân lượng gia tăng 10%.
      Phúc lợi ba: [ffcc00] Thiên Công [-]. Thông qua bang phái hiến cho, Võ Thần điện, trừng phạt ác nhiệm vụ, bang phái sưởi ấm bài thi, võ lâm minh chủ thu hoạch được cống hiến gia tăng 10%.
]]
}

tbAct.tbNewInfo = 
{
    szTitle = "Phúc Lợi Toàn Dân";
    szContent =
[[
      Võ lâm minh chủ đặc lệnh, hiệp sĩ tiến vào chiếm giữ 5 Nguyệt 1 Nhật 4 Điểm đến 5 Nguyệt 16 Nhật 0 Điểm ở giữa mở ra server, có thể đạt được 5 Nguyệt ngày Quốc Tế Lao Động độc hưởng tăng thêm phúc lợi. Trợ lực chúng hiệp sĩ sớm ngày độc bộ võ lâm!( Tăng thêm phúc lợi đem tiếp tục đến mở ra 59 Cấp đẳng cấp hạn mức cao nhất )
      Phúc lợi một: [ffcc00] Xưng hào [-]. Tân tiến người chơi có thể đạt được tân phục chuyên môn hạn định xưng hào.
      Phúc lợi hai: [ffcc00] Chung chiến [-]. Dã ngoại tu luyện đánh quái thu hoạch được kinh nghiệm gia tăng 10%.
      Phúc lợi ba: [ffcc00] Tài vận [-]. Thông qua cây rụng tiền, mỗi ngày mục tiêu, ngẫu nhiên địa cung, dã ngoại tu luyện, thương hội nhiệm vụ thu hoạch được ngân lượng gia tăng 10%.
      Phúc lợi bốn: [ffcc00] Thiên Công [-]. Thông qua bang phái hiến cho, Võ Thần điện, trừng phạt ác nhiệm vụ, bang phái sưởi ấm bài thi, võ lâm minh chủ thu hoạch được cống hiến gia tăng 10%.
]]
}

tbAct.tbAddBuff = 
{
    {nBuffID = 2301, nLevel = 1 },
    {nBuffID = 2302, nLevel = 1 },
    {nBuffID = 2303, nLevel = 1 },
};

function tbAct:OnTrigger(szTrigger)
    if szTrigger == "Init" then
        self:SendNew();
    elseif szTrigger == "Start" then
        Activity:RegisterPlayerEvent(self, "Act_OnPlayerLogin", "OnPlayerLogin");
    end

    Log("AllPeopleWelfare OnTrigger:", szTrigger)
end

function tbAct:OnPlayerLogin()
    local pPlayerNpc = me.GetNpc();
    if not pPlayerNpc then
        return;
    end

    local _, nEndTime = self:GetOpenTimeInfo();
    local nCurTime = GetTime();
    if nCurTime >= (nEndTime - 10) then
        return;
    end

    for _, tbBuffInfo in pairs(self.tbAddBuff) do
        local tbState  = pPlayerNpc.GetSkillState(tbBuffInfo.nBuffID);
        if not tbState then
            pPlayerNpc.AddSkillState(tbBuffInfo.nBuffID, tbBuffInfo.nLevel, FightSkill.STATE_TIME_TYPE.state_time_truetime, nEndTime, 1, 1);
        end    
    end   
end

function tbAct:SendNew()
    local tbNewInfo = self.tbNewInfo;
    if not tbNewInfo then
        return;
    end
    
    if tonumber(os.date("%Y%m%d", GetTime())) < 20170501 then	-- 这个时间之前用老的最新消息
    	tbNewInfo = self.tbNewInfo_Old or tbNewInfo;
    end

    local _, nEndTime = self:GetOpenTimeInfo();
    NewInformation:AddInfomation("AllPeopleWelfare_NewInfo", nEndTime, {tbNewInfo.szContent}, {szTitle = tbNewInfo.szTitle, nReqLevel = 1})
end