local tbNpc   = Npc:GetClass("DrinkHouseNpc")

function tbNpc:OnDialog()
    local szDefaultText = Lib:IsEmptyStr(him.szDefaultDialogInfo) and "Bạn đang tìm gì vậy?？" or him.szDefaultDialogInfo
    local OptList = {
        { Text = "Ta muốn đi vào vong ưu tửu quán", Callback = self.EnterFuben, Param = {self} };
    };
    if not DrinkHouse.tbRentKinToMapId[me.dwKinId] then
        table.insert(OptList, { Text = "Ta muốn mở ra Tiệc bang hội", Callback = self.RentDrinkHouse, Param = {self} })
    end
    Dialog:Show(
    {
        Text = szDefaultText,
        OptList = OptList,
    }, me, him)
end

function tbNpc:EnterFuben()
    DrinkHouse:RequestEnterMap(me)
end

function tbNpc:RentDrinkHouse( )
	DrinkHouse:RentDrinkHouse(me)
end