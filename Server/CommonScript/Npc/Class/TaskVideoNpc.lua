local tbNpc = Npc:GetClass("TaskVideoNpc");
function tbNpc:OnDialog()
	local szText = "Thanh y bạch sam kiếm hiệp khách, bách lý tần xuyên vạn lý hào";
	local tbOptList = {}
	local tbVideoType = Task:GetBackPlayVideoType(me)
	for _, nVideoType in ipairs(tbVideoType) do
		local tbVideoInfo = Task.tbAllVideoTask[nVideoType]
		if tbVideoInfo then
			table.insert(tbOptList, { Text = tbVideoInfo.szVideoTitle, Callback = self.ChooseVideo, Param = {self, me.dwID, nVideoType}});
		end
	end
	local bAllFinish = Task:AllFlowTaskFinish(me)
	if bAllFinish then
		table.insert(tbOptList, { Text = "Vong Ưu Tửu Quán 3", Callback = function () me.CallClientScript("Sdk:OpenUrl", "https://jxqy.qq.com/act/a20180831bigmovie/index.shtml") end});
	end
	Dialog:Show(
	{
		Text	= szText,
		OptList = tbOptList,
	}, me, him);
end

function tbNpc:ChooseVideo(dwID, nVideoType)
	local pPlayer = KPlayer.GetPlayerObjById(dwID)
	if not pPlayer then
       return
	end
	pPlayer.CallClientScript("Task:OnOpenTaskVideo", nVideoType)
end