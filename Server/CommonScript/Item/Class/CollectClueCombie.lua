local tbItem = Item:GetClass("CollectClueCombie");
function tbItem:GetUseSetting(nTemplateId, nItemId)
	local tbUserSet = {};
	local tbAct = Activity.CollectAndRobClue
	local _, tbMyItemList = tbAct:GetMyItemListData();
	local tbClueItem = Item:GetClass("CollectAndRobClue");
	local bRet = tbClueItem:CanCombieDebris(tbMyItemList)
	if bRet then
		tbUserSet.szFirstName = "Ghép"
		tbUserSet.fnFirst = function ()
			RemoteServer.DoRequesActCollectAndRobClue("CombieClueItem")
		end	
	else
		tbUserSet.szFirstName = "Xem trước"
		tbUserSet.fnFirst = function ()
			Item:ShowItemDetail({nTemplate = tbClueItem.nLastCombineItemId});
		end	
	end
	return tbUserSet
end