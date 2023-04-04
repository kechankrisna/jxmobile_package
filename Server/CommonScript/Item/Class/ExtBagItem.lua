
local tbExtBagItem = Item:GetClass("ExtBagItem");

function tbExtBagItem:OnUse(pItem)
	local nExtParam1 = KItem.GetItemExtParam(pItem.dwTemplateId, 1)
    local nExtParam2 = KItem.GetItemExtParam(pItem.dwTemplateId, 2)
    if nExtParam2 == 0 then
    	nExtParam2 = 127
    end
	if nExtParam1 <= 0 or nExtParam2 > 127 then
		return 0;
	end
	local nUseCount = Item:GetExtBagValue(me, nExtParam1)
	if nUseCount >= nExtParam2 then
		me.CenterMsg(string.format("Đạo cụ được dùng tối đa %s.", nExtParam2))
		return 0;
	end
	
	Item:SetExtBagValue(me, nExtParam1, nUseCount + 1)
	me.CenterMsg(string.format("Dùng %s thành công", pItem.szName))
	return 1;
end

function tbExtBagItem:GetIntrol(dwTemplateId)
    local nExtParam1 = KItem.GetItemExtParam(dwTemplateId, 1)
    local nExtParam2 = KItem.GetItemExtParam(dwTemplateId, 2)
    if nExtParam2 == 0 then
    	return "";
    end
    local tbInfo = KItem.GetItemBaseProp(dwTemplateId)
    if not tbInfo then
        return ""
    end
    
	if nExtParam1 <= 0 then
		return "";
	end

    local nUseCount = Item:GetExtBagValue(me, nExtParam1)
    return string.format("%s\nSố lượng dùng: %d/%d", tbInfo.szIntro, nUseCount, nExtParam2)
end
