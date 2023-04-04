
local ITEM_CLASS = "FurnitureItem";
local tbItem = Item:GetClass(ITEM_CLASS);

function tbItem:OnUse(it)
	local tbFurniture = House:GetFurnitureInfo(it.dwTemplateId);
	if not tbFurniture then
		me.CenterMsg("Đạo cụ bất thường");
		return;
	end
	if me.nHouseState ~= 1 then
		me.MsgBox("Không có gia viên, hãy đến chỗ [FFFE0D]Triệu Ân Đồng[-] để hỏi thông tin liên quan.",
		{
			{"Đi ngay", function () me.CallClientScript("Ui.HyperTextHandle:Handle", "[url=npc:testtt,2279,10]", 0, 0); end},
			{"Xin đợi"}
		});
		me.CallClientScript("Ui:CloseWindow", "QuickUseItem");
		return;
	end

	me.CenterMsg("Đặt thành công vào Kho Gia Cụ", true);
	Furniture:Add(me, it.dwTemplateId);
	return 1;
end

function tbItem:GetTip(it)
	local tbFurniture = House:GetFurnitureInfo(it.dwTemplateId);
	if not tbFurniture then
		return "";
	end

	local szPutType = "Trong phòng, Đình Viện";
	if tbFurniture.nIsHouse == 1 then
		szPutType = "Trong phòng";
	elseif tbFurniture.nIsHouse == 0 then
		szPutType = "Đình Viện";
	end

	return string.format([[Cấp: %s
Độ thoải mái: %s
Loại gia cụ: %s
Vị trí đặt: %s]], tbFurniture.nLevel, tbFurniture.nComfortValue, Furniture:GetTypeName(tbFurniture.nType), szPutType);
end

function tbItem:GetUseSetting(nItemTemplateId, nItemId)
	if not House.bHasHouse then
		return {
					szFirstName = "Bỏ vào Kho Gia Cụ",
					fnFirst = function ()
								Ui:CloseWindow("ItemTips");
								Ui:CloseWindow("ItemBox");

								me.MsgBox("Không có gia viên, hãy đến chỗ [FFFE0D]Triệu Ân Đồng[-] để hỏi thông tin liên quan.",
									{
										{"Đi ngay", function () Ui.HyperTextHandle:Handle("[url=npc:testtt,2279,10]", 0, 0); end},
										{"Xin đợi"}
									});
								end
				};
	end
	if not nItemId or nItemId <= 0 then
		if Ui:WindowVisible("HouseDecorationPanel") and not Ui:WindowVisible("HouseComfortableDetailsPanle") then
			local tbOpt = {};
			if Furniture:CanSell(nItemTemplateId) then
				table.insert(tbOpt, { szName = "Bán", fnClick = function ()
					Shop:SellFakeItem("Furniture", nItemTemplateId, House.tbFurniture[nItemTemplateId]);
				end });
			end

			local _, x, y = me.GetWorldPos();
			local bCanPut = House:CheckCanPutFurnitureCommon(me.nMapTemplateId, x, y, 0, nItemTemplateId);
			if bCanPut then
				table.insert(tbOpt, { szName = "Đặt", fnClick = function ( ... )
					UiNotify.OnNotify(UiNotify.emNOTIFY_PUT_DECORATION, nItemTemplateId);
					Ui:CloseWindow("ItemTips");
				end});
			end

			if #tbOpt == 0 then
				return {};
			end

			local tbParam = { bForceShow = true};
			if tbOpt[1] then
				tbParam.szFirstName = tbOpt[1].szName;
				tbParam.fnFirst = tbOpt[1].fnClick;
			end

			if tbOpt[2] then
				tbParam.szSecondName = tbOpt[2].szName;
				tbParam.fnSecond = tbOpt[2].fnClick;
			end

			return tbParam;
		end
		return {};
	end

	local pItem = me.GetItemInBag(nItemId);
	if not pItem then
		return {};
	end

	return {szFirstName = "Bỏ vào Kho Gia Cụ", fnFirst = "UseItem"};
end
