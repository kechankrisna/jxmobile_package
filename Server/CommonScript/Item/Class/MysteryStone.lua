
local tbItem = Item:GetClass("MysteryStone");

function tbItem:GetIntroBottom(nTemplateId)
	local _, szMoneyEmotion = Shop:GetMoneyName("Coin")
	local nCost = StoneMgr:GetCombineCost(nTemplateId)
	if nCost and nCost > 0 then
		return string.format("Ghép tiêu hao %s %d", szMoneyEmotion, nCost)
	end
	
end

function tbItem:GetUseSetting(nTemplateId)
	local tbBtnFuncs = {};
	if StoneMgr:GetNextLevelStone(nTemplateId) ~= 0 then
		table.insert(tbBtnFuncs,{"Ghép", "UseCombine" })
	end
	table.insert(tbBtnFuncs,{"Cường hóa", "UseInset" })
	local tbUseSetting = {};
	local tbFuncName = {
		{"szFirstName", "fnFirst"};
		{"szSecondName", "fnSecond"};
		{"szThirdName", "fnThird"};
	}
	for i,v in ipairs(tbBtnFuncs) do
		local szKey1,szKey2 = unpack(tbFuncName[i])
		tbUseSetting[szKey1] = v[1]
		tbUseSetting[szKey2] = v[2]
	end

	return tbUseSetting;		
end


