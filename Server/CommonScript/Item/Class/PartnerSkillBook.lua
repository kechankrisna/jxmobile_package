
local tbPartnerSkillBook = Item:GetClass("PartnerSkillBook");

function tbPartnerSkillBook:GetTip(it)
	local nSkillBookId =  KItem.GetItemExtParam(it.dwTemplateId, 1);
	local tbInfo = Partner:GetSkillInfo(nSkillBookId);
	if not tbInfo then
		return "Giang hồ bao la rộng lớn";
	end

	local _, szSkillName = FightSkill:GetSkillShowInfo(tbInfo.nSkillId);
	return string.format("Kỹ năng Đồng Hành: %s\nNgũ Hành: %s", szSkillName, Npc.Series[tbInfo.nSeries] or "Không");
end

function tbPartnerSkillBook:ClientUseItem(nPartnerId, nItemId)
	Ui:CloseWindow("ItemTips");
	if not nPartnerId then
		me.CenterMsg("Đồng Hành ra trận không thể học Sách Kỹ Năng này");
		return;
	end

	Ui:OpenWindow("Partner", "PartnerMainPanel", string.format("PId=%s;EP=LearnSkill;EPP=%s;", nPartnerId, nItemId));
end

function tbPartnerSkillBook:GetUseSetting(nTemplateId, nItemId)
	if Ui:WindowVisible("Partner") then
		return {};
	end

	local pItem = KItem.GetItemObj(nItemId or 0);
	if not pItem then
		return;
	end

	local tbPosInfo = me.GetPartnerPosInfo();
	local nPartnerId;
	for i = 1, Partner.MAX_PARTNER_POS_COUNT do
		local nTId = tbPosInfo[i];
		if nTId and nTId > 0 then
			local bRet = Partner:CheckCanUseSkillBook(me, nTId, nItemId);
			if bRet then
				nPartnerId = nTId;
				break;
			end
		end
	end

	local function fnFirst()
		self:ClientUseItem(nPartnerId, nItemId);
	end

	if Shop:CanSellWare(me, nItemId or 0, 1) then
		return {szFirstName = "Bán", fnFirst = "SellItem", szSecondName = "Dùng", fnSecond = fnFirst};
	end

	return { szFirstName = "Dùng", fnFirst = fnFirst};
end
