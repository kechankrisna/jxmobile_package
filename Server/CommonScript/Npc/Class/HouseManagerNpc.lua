
local tbNpc = Npc:GetClass("HouseManagerNpc");

function tbNpc:OnDialog()
	local szText = Npc:GetRandomTalk(him.nTemplateId, me.nMapTemplateId);
	szText = szText or "Đại hiệp cần tạo phòng không?";
	
	if me.nHouseState ~= 1 and Task:GetTaskFlag(me, House.nFinishHouseTaskId) == 1 then
		Dialog:Show(
		{
			Text	= "Đại hiệp cần tạo phòng không?",
			OptList = {{ Text = "Nhận được Gia Viên", Callback = function ()
				House:Create(me, 1);
			end, Param = {}}},
		}, me, him);
		return;
	end

	for _, nTaskId in pairs(House.tbAllHouseTask) do
		if Task:GetPlayerTaskInfo(me, nTaskId) then
			szText = "Đại hiệp, không biết chuyện cần nhờ thế nào rồi?";
			break;
		end
	end

	local tbDlg = {};

	if House:CheckOpen(me) then
		if Task:GetPlayerTaskInfo(me, House.nSecondHouseTaskId) then
			table.insert(tbDlg, { Text = "Xây Gia Viên", Callback = function ()
				Task:DoAddExtPoint(me, House.nSecondHouseTaskId, 1);
			end, Param = {}});

			szText = "Đại hiệp cần tạo phòng không?";
		end

		local tbHouse = House:GetHouse(me.dwID);
		if tbHouse and tbHouse.nStartLeveupTime then
			local tbSetting = House.tbHouseSetting[tbHouse.nLevel];
			if tbHouse.nStartLeveupTime + tbSetting.nLevelupTime <= GetTime() then
				szText = "Đã hoàn thành tăng cấp Gia Viên!";
				table.insert(tbDlg, { Text = "Được, làm phiền cô nương. [FFFE0D](Hoàn thành tăng cấp Gia Viên) [-]", Callback = self.DoHouseLevelup, Param = {self} });
			end
		end

		if tbHouse then
			table.insert(tbDlg, { Text = "Ta muốn về nhà", Callback = self.GoHome, Param = {self} })
		end
	end

	if House:IsTimeFrameOpen() then
		for nMapTemplateId, _ in pairs(House.tbSampleHouseSetting) do
			table.insert(tbDlg, { Text = "Đến「Hoa Đồng Tiểu Trúc」", Callback = self.GotoSampleHouse, Param = { self, nMapTemplateId } });
		end
	end

	Dialog:Show(
	{
		Text	= szText,
		OptList = tbDlg,
	}, me, him);
end

function tbNpc:DoHouseLevelup()
	House:DoLevelUp(me);
end

function tbNpc:GoHome()
	House:GoMyHome(me);
end

function tbNpc:GotoSampleHouse(nMapTemplateId)
	SampleHouse:EnterSampleHouse(me, nMapTemplateId);
end
