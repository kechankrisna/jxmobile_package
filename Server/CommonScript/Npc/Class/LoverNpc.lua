
local tbNpc = Npc:GetClass("LoverNpc");

function tbNpc:OnDialog()
	local szText = "Hỏi thế gian tình là gì, mà khiến người ta sinh tử có nhau!";
	local tbOptList = {
		{ Text = "Tình Duyên hôm nay", Callback = self.TodayLove, Param = {self, me.dwID} };
	};
	local szTaskStep = LoverTask:GetTaskStepDes(me)
	if szTaskStep then
		table.insert(tbOptList, { Text = szTaskStep, Callback = self.DoLoverTask, Param = {self, me.dwID} })
	else
		table.insert(tbOptList, { Text = "[Duyên] Nhiệm Vụ Tình Duyên", Callback = self.TaskLove, Param = {self, me.dwID} })
	end

	if BiWuZhaoQin:GetLover(me.dwID) and not self.bBiWuZhaoQinOpen then
		table.insert(tbOptList, { Text = "Hủy quan hệ tình duyên", Callback = function () self:RemoveLover(); end});
	end

	Dialog:Show(
	{
		Text	= szText,
		OptList = tbOptList,
	}, me, him);
end

function tbNpc:OnBiWuZhaoQinStateChange(bOpen)
	self.bBiWuZhaoQinOpen = bOpen;
end

function tbNpc:RemoveLover(bConfirm)
	if not bConfirm then
		local nLover = BiWuZhaoQin:GetLover(me.dwID);
		if not nLover then
			me.CenterMsg("Không có quan hệ tình duyên!");
			return;
		end

		local tbRoleInfo = KPlayer.GetRoleStayInfo(nLover or 0) or {szName = "Vô Danh"};
		me.MsgBox(string.format("Hủy quan hệ tình duyên với [FFFE0D]%s[-]? Thao tác sẽ [FFFE0D]có hiệu lực ngay[-]!", tbRoleInfo.szName), {{"Đồng ý", function ()
			self:RemoveLover(true);
		end}, {"Hủy"}})

		return;
	end

	local nOtherId = BiWuZhaoQin:RemoveLover(me);
	if not nOtherId then
		me.CenterMsg("Không có quan hệ tình duyên!");
		return;
	end

	local tbRoleInfo = KPlayer.GetRoleStayInfo(nOtherId or 0) or {szName = "Vô Danh"};

	me.DeleteTitle(BiWuZhaoQin.nTitleId);
	Mail:SendSystemMail({
		To = nOtherId,
		Title = "Hủy tình duyên",
		Text = string.format("[FFFE0D]%s[-] vào lúc %s đã hủy quan hệ tình duyên với đại hiệp!", me.szName, os.date("%Y-%m-%d", GetTime())),
		From = "Yên Nhược Tuyết",
	});

	local pOther = KPlayer.GetPlayerObjById(nOtherId);
	if pOther then
		BiWuZhaoQin:RemoveLover(pOther);
		pOther.DeleteTitle(BiWuZhaoQin.nTitleId);
	end
	me.CenterMsg(string.format("Đại hiệp đã hủy quan hệ tình duyên với [FFFE0D]%s[-]!", tbRoleInfo.szName));
end

function tbNpc:TaskLove(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
       return 
	end
	LoverTask:AcceptTask(pPlayer)
end

function tbNpc:TodayLove(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
       return 
	end
	pPlayer.CallClientScript("Ui:OpenWindow", "LoverRecommondPanel")
end

function tbNpc:DoLoverTask(dwID)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
       return 
	end
	LoverTask:DoTask(pPlayer)
end