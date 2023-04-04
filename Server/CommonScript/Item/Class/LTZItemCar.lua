local tbItem = Item:GetClass("LTZItemCar");

function tbItem:GetUseSetting(nItemTemplateId, nItemId)
	LingTuZhan:GetSynKinBattleFightData()
	local tbShowInfo = { 
		bForceShow = true;
		szFirstName = "Xây";
		fnFirst = function (  )
			LingTuZhan:BuildSupplyItem( nItemTemplateId )
		end;
		szSecondName = "Dùng";
		fnSecond = function ( ... )
			LingTuZhan:UseSupplyItem( nItemTemplateId )
		end;
	 }
	 return tbShowInfo
end