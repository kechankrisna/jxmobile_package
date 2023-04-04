local tbItem = Item:GetClass("LoverRecallClue");

function tbItem:GetUseSetting(nTemplateId, nItemId)
	
	local fnComposeLoverRecallMap = function ()
		if not Activity:__IsActInProcessByType("LoverRecallAct") then
			me.CenterMsg("Hoạt động đã kết thúc", true)
			return 
		end

		RemoteServer.TryComposeLoverRecallMap()
	end

	return {szFirstName = "Ghép", fnFirst = fnComposeLoverRecallMap};
end
