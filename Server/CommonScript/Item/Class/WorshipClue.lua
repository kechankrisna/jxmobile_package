local tbItem = Item:GetClass("WorshipClue");

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local fnComposeWorshipMap = function ()
		if not Activity:__IsActInProcessByType("QingMingAct") then
			me.CenterMsg("Hoạt động đã kết thúc", true)
			return 
		end

		RemoteServer.TryComposeWorshipMap()
	end
	return {szFirstName = "Ghép", fnFirst = fnComposeWorshipMap};
end
