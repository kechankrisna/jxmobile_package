Require("CommonScript/Item/Class/Equip.lua")

local tbHorse = Item:GetClass("horse");
local tbEquip = Item:GetClass("equip");

local tbExtip = 
{
	[2400] = {"OpenLevel69", "(Mở giới hạn Lv79 có thể tiến cấp đến Thú Cưỡi Lv70)"},
	[3012] = {"OpenLevel89", "(Mở giới hạn Lv99 có thể tiến cấp đến Thú Cưỡi Lv90)"},
}

    
function tbHorse:FormatTips(nTemplateId, pEquip)
	local tbNormal = {};
	local tbRider = {};

	local tbAttrib = KItem.GetEquipBaseProp(nTemplateId).tbBaseAttrib;
	local tbBaseProp = KItem.GetItemBaseProp(nTemplateId)

	if not tbAttrib then
		return szTips;
	end
	
	table.insert(tbNormal, {"", 1});	

	for i, tbMA in ipairs(tbAttrib) do
		local szDesc = tbEquip:GetMagicAttribDesc(tbMA.szName, tbMA.tbValue, 0);
		if (szDesc and szDesc ~= "") then
			if tbMA.nActiveReq == Item.emEquipActiveReq_Ride then
				table.insert(tbRider, {szDesc, 1})
				
			else
				table.insert(tbNormal, {szDesc, 1})
			end
		end
	end
	
	if #tbRider > 0 then
		table.insert(tbNormal, {"Kích hoạt sau khi cưỡi"})
		Lib:MergeTable(tbNormal, tbRider)
	end
	
	local szTips = self:GetHorseEnhanceTips(nTemplateId);
	if szTips then
		table.insert(tbNormal, {"", 1});	
		table.insert(tbNormal, {szTips, 2});
	end


	if pEquip and pEquip.GetIntValue(-9996) > 0 then
		table.insert(tbNormal, {"Có hiệu lực"})
		table.insert(tbNormal, {os.date("%Y-%m-%d %H:%M:%S", pEquip.GetIntValue(-9996)), 1})
	end

	return tbNormal, tbBaseProp.nQuality;
end

function tbHorse:GetHorseEnhanceTips(nTemplateId)
	if tbExtip[nTemplateId] then
		local szTimeFrame, szDesc = unpack(tbExtip[nTemplateId])
		if GetTimeFrameState(szTimeFrame) == 1 then
			return szDesc;
		end
	end
end

function tbHorse:GetTip(pEquip, pPlayer, bIsCompare)            -- 获取普通道具Tip
    local tbBaseAttrib, nQuality = self:FormatTips(pEquip.dwTemplateId, pEquip) 
    return tbBaseAttrib, nQuality;
end

function tbHorse:GetTipByTemplate(nTemplateId, tbSaveRandomAttrib)
    local tbBaseAttrib, nQuality = self:FormatTips(nTemplateId) 
    return tbBaseAttrib, nQuality;
end

function tbHorse:IsUsableItem(pPlayer, dwTemplateId)
	 --目前只是心魔用
	local tbItems = pPlayer.FindItemInPlayer("horse")
	if #tbItems > 0 then
		return false
	end

	return true
end