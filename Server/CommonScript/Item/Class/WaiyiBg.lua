local tbItem = Item:GetClass("WaiyiBg");

tbItem.nAddTime = 8 * 60 * 60;						-- 增加挂机时间
tbItem.nPrice = 48;									-- 价格

function tbItem:OnUse(it)
	local nBgId = KItem.GetItemExtParam(it.dwTemplateId, 1)
	if Item.tbChangeColor:IsUnlockedBg(me, nBgId) then
		me.CenterMsg("Đã kích hoạt phong cách nền ngoại trang này")
		return 0;
	end
	Item.tbChangeColor:UnlockBg(me, nBgId)
	me.CenterMsg("Đã kích hoạt phong cách nền ngoại trang mới")
	return 1
end
