local tbItem = Item:GetClass("LTZItemCamp");

function tbItem:GetUseSetting(nItemTemplateId, nItemId)
	LingTuZhan:GetSynKinBattleFightData()
	local tbShowInfo = { 
		bForceShow = true;
		szFirstName = "Dùng";
		fnFirst = function (  )
			LingTuZhan:UseSupplyItem( nItemTemplateId )
		end;
		szSecondName = "Đến";
		fnSecond = function ( ... )
			LingTuZhan:QuckGotoCamp()
		end;
	 }
	 return tbShowInfo
end