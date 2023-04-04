-- 许愿符
local tbItem = Item:GetClass("WishItem")

function tbItem:OnUse(it)
	me.CallClientScript("Ui:CloseWindow", "ItemTips")
	me.CallClientScript("Ui:CloseWindow", "ItemBox")
	local tbAct = Activity:GetClass("NewYearChris")
    me.CallClientScript("AutoPath:AutoPathToNpc", tbAct.nWishNpcTempId, tbAct.nWishNpcMapId, tbAct.tbWishNpcPos[1], tbAct.tbWishNpcPos[2])
end

-- 未鉴定的许愿符
local tbItem = Item:GetClass("UnidentWishItem")

function tbItem:OnUse(it)
end

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local fnIdentify = function ()
		if not Activity:__IsActInProcessByType("NewYearChris") then
			me.CenterMsg("Hoạt động đã kết thúc", true)
			return 
		end
		RemoteServer.NewYearChrisReq("IdentifyWishItem", nItemId)
	end

	local fnLock = function()
		if not Activity:__IsActInProcessByType("NewYearChris") then
			me.CenterMsg("Hoạt động đã kết thúc", true)
			return
		end
		RemoteServer.NewYearChrisReq("LockWishItem", nItemId)
	end

	return {
		szFirstName = "Giám định",
		fnFirst = function ()
			fnIdentify()
			Ui:CloseWindow("ItemTips")
		end,

		szSecondName = "Phong Ấn",
		fnSecond = function ()
			fnLock()
			Ui:CloseWindow("ItemTips")
		end,
	}
end


-- 封印的许愿符
local tbItem = Item:GetClass("LockedWishItem")

function tbItem:GetUseSetting(nTemplateId, nItemId)
	if Activity:__IsActInProcessByType("NewYearChris") then
		return {}
	end
	return {szFirstName = "Bán", fnFirst = "SellItem"}
end

function tbItem:CheckCanSell(pItem)
	return Activity:__IsActInProcessByType("NewYearChris")
end