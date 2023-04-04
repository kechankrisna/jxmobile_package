local tbNpc = Npc:GetClass("ActivityNpc");

function tbNpc:OnDialog()
    local   OptList = {
        { Text = "Dữ Tình Duyên Thư", Callback = self.PlaySound, Param = {self, 17} },
        { Text = "Kiếm Hiệp Tình", Callback = self.PlaySound, Param = {self, 10} },
        { Text = "Đại Anh Hùng", Callback = self.PlaySound, Param = {self, 21} },
        { Text = "Yêu Phế Tích", Callback = self.PlaySound, Param = {self, 10020} },
        { Text = "Họa Địa Vi Lao", Callback = self.PlaySound, Param = {self, 11} },
        { Text = "Tam Sinh Tam Thế", Callback = self.PlaySound, Param = {self, 12} },
        { Text = "Tạm ngưng phát", Callback = self.RestartPlayMapSound, Param = {self} },
        { Text = "Kết thúc đối thoại!", Callback = function () end},
    };
    if version_vn then
            OptList = {
                { Text = "Kiếm Hiệp Tình Duyên", Callback = self.PlaySound, Param = {self, 10} },
                { Text = "Đại Anh Hùng", Callback = self.PlaySound, Param = {self, 21} },
                { Text = "Kiếm Hiệp Tình", Callback = self.PlaySound, Param = {self, 16} },
                { Text = "Họa Địa Vi Lao", Callback = self.PlaySound, Param = {self, 11} },
                { Text = "Tam Sinh Duyên", Callback = self.PlaySound, Param = {self, 12} },
                { Text = "Ta Đi Tìm Em", Callback = self.PlaySound, Param = {self, 14} },
                { Text = "Tạm ngưng phát", Callback = self.RestartPlayMapSound, Param = {self} },
                { Text = "Kết thúc đối thoại!", Callback = function () end},
            };

    elseif version_kor then
        OptList =  {
                { Text = "Dữ Tình Duyên Thư", Callback = self.PlaySound, Param = {self, 17} },
                { Text = "Yêu Phế Tích", Callback = self.PlaySound, Param = {self, 10020} },
                { Text = "Đại Anh Hùng", Callback = self.PlaySound, Param = {self, 21} },
                { Text = "Tạm ngưng phát", Callback = self.RestartPlayMapSound, Param = {self} },
                { Text = "Kết thúc đối thoại!", Callback = function () end},
            };
    end
    Dialog:Show(
    {
        Text    = "Ngươi tìm ta có việc gì?",
        OptList = OptList,
    }, me, him);
end

function tbNpc:PlaySound(nSoundID)
    me.CallClientScript("Map:PlaySceneOneSound", nSoundID);
end

function tbNpc:RestartPlayMapSound()
    me.CallClientScript("Map:RestartPlayMapSound");
end