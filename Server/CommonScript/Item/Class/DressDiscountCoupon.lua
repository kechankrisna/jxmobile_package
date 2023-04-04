local tbItem = Item:GetClass("DressDiscountCoupon");

function tbItem:GetUseSetting(nTemplateId, nItemId)
	local tbUserSet = {};
	local fnGotoShop = function ()
		local szFirstPage = "Dress";
		if not Shop.tbDiscountConfigure or 
	        not Shop.tbDiscountConfigure[nTemplateId] then return end;
	    local nDiscount = Shop.tbDiscountConfigure[nTemplateId][1];
	    local tbTargetDress = Shop.tbDiscountConfigure[nTemplateId][2];
	    local tbShopWares = Shop:GetShopWares(szFirstPage,nil,true);
	    if not tbShopWares or not tbTargetDress or nDiscount == nil then return end;
	    
	    local szPage = nil;
	    local nTargetId = nil;
	    for _, nDressId in ipairs(tbTargetDress) do
	    	for _,tbItems in ipairs(tbShopWares) do
	    		if tbItems.nTemplateId == nDressId then 
	    			szPage = tbItems.SubType;
	                nTargetId = tbItems.nTemplateId;
	    			break;
	    		end
	    	end
	    	if szPage ~= nil then break end;
	    end
	    if szPage == nil or nTargetId == nil then
	    	me.CenterMsg("Thương phẩm tương ứng với Phiếu Giảm Giá đã không còn bán.");
	    else
	        Ui:OpenWindow("CommonShop", szFirstPage , szPage);
	        Ui:CloseWindow("ItemTips");
	    end
	end
	tbUserSet.szFirstName = "Bán"
	tbUserSet.fnFirst = "SellItem"		

	tbUserSet.szSecondName = "Dùng"
	tbUserSet.fnSecond = fnGotoShop;
	return tbUserSet;
end
