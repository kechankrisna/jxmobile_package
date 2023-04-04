Require("CommonScript/Item/Class/RandomItem.lua");
local tbRandomItem = Item:NewClass("RandomItemWaiYiBox", "RandomItem");	-- 派生，一定要放在最后
function tbRandomItem:OnClientUse(pItem)
	if not pItem then
		return 1
	end
	local nItemId = pItem.dwId
	local nTemplateId = pItem.dwTemplateId
	
	local fnYes = function ( )
		RemoteServer.UseItem(nItemId);
	end	

	local tbTargetWaiyis, tbPackItems = Shop:CanPreViewTargetWaiyiListFromItemPack(nTemplateId, me.nFaction)
	if not next(tbTargetWaiyis) then
		return		
	end
	local tbFindItemList = {};
	for i,v in ipairs(tbTargetWaiyis) do
		local tbRets = me.FindItemInPlayer(v) 
		if #tbRets > 0 then
			table.insert(tbFindItemList, tbRets[1])
		else
			local nFromItemId = tbPackItems[i]
			local tbRets = me.FindItemInPlayer(nFromItemId) 
			if #tbRets > 0 then
				table.insert(tbFindItemList, tbRets[1])
			end
		end
	end
	if #tbFindItemList == 0 then
		fnYes()
	else
		if #tbFindItemList < #tbTargetWaiyis then
			local tbItemNames = {};
			for i, v in ipairs(tbFindItemList) do
				local szName = v.GetItemShowInfo()
				table.insert(tbItemNames, string.format("[FFFE0D][url=openwnd:%s, ItemTips, 'Item', nil, %d][-]", szName, v.dwTemplateId))
			end
			local szItemName = table.concat(tbItemNames, ",")
			me.MsgBox( string.format("Đã có %s, tiếp tục dùng?", szItemName) , { {"Xác nhận", fnYes },{"Hủy"}  })	
		else
			me.CenterMsg("Đã có tất cả ngoại trang trong rương, có thể tặng rương cho hảo hữu!")
		end
	end
	return 1;
end

function tbRandomItem:GetUseSetting(nTemplateId, nItemId)
    local tbRet = {
        szFirstName = "Dùng",
        fnFirst = "UseItem",
    }
    local tbInfo = Gift:GetMailGiftItemInfo(nTemplateId)
    if not tbInfo then
        return tbRet
    end

    if me.GetVipLevel() < tbInfo.tbData.nVip then
        return tbRet
    end

    tbRet = {
        szFirstName = "Tặng",
        fnFirst = function()
            Ui:OpenWindow("GiftSystem")
            Ui:CloseWindow("ItemTips")
        end,
        szSecondName = "Dùng",
        fnSecond = "UseItem",
    }
    return tbRet
end
