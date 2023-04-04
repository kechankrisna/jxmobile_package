local tbItem = Item:GetClass("ItemDev");
Require("CommonScript/ChangeFaction/ChangeFactionDef.lua");
function tbItem:OnUse(it)
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Hỗ Trợ Tân Thủ", Callback = self.FnSupport, Param = {self} },
					{ Text ="Nhận Tiền Tệ", Callback = self.FnGold, Param = {self} },
					{ Text ="Nhận Trang Bị", Callback = self.FnEquip, Param = {self} },
					{ Text ="Nhận Thời Trang (New)", Callback = self.FnFactionNew, Param = {self} },
					{ Text ="Nhận Thời Trang", Callback = self.FnFaction, Param = {self} },
					{ Text ="Nhận Thú Cưỡi", Callback = self.FnHorse, Param = {self} },
					{ Text ="Nhận Chân Nguyên", Callback = self.FnZhenYuan, Param = {self} },
					{ Text ="Nhận Kinh Mạch", Callback = self.NhanKinhMach, Param = {self} },
					{ Text ="Chuyển Phái", Callback = self.ChuyenPhai, Param = {self} },
					{ Text ="Nhận Đồng Hành", Callback = self.FnPartner, Param = {self} },
					{ Text ="Nhận Gia Viên", Callback = self.FnHouse, Param = {self} },
					{ Text ="Nhận Quân Hàm", Callback = self.FnHonor, Param = {self} },
					{ Text ="Nhận Danh Hiệu", Callback = self.FnTitle, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnSupport()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Max Level", Callback = self.FnSupportLevel, Param = {self} },
                    { Text ="Xóa hành trang", Callback = self.DelHanhTrang, Param = {self} },
					{ Text ="Nhận Full Skill", Callback = self.NhanFullSkill, Param = {self} },
					{ Text ="Max Cường hóa", Callback = self.MaxCuongHoa, Param = {self} },
					{ Text ="Nhận hỗ trợ thử nghiệm", Callback = self.FnSupportNew, Param = {self} },
					{ Text ="Nhận Đạo cụ", Callback = self.FnDaoCu, Param = {self} },
					{ Text ="Vật Phẩm Hỗ Trợ Thêm", Callback = self.FnItemFull, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);  
end

function tbItem:ChuyenPhai()
   	local tbAllFaction = {};
    	for nFaction, tbInfo in pairs(Faction.tbFactionInfo) do
        tbAllFaction[nFaction] = 1;
   	end
    me.CallClientScript("Ui:OpenWindow", "ChangeFactionPanel", tbAllFaction)
end

function tbItem:NhanKinhMach()
	Task:SetTaskFlag(me, 3206);
	me.CallClientScript("Task:OnFinishTask", 3206);
end

function tbItem:DelHanhTrang()
	  Dialog:Show(
	  {
		Text  ="Sau khi chọn, toàn bộ hành trang sẽ bị tiêu hủy vĩnh viễn!",
		OptList = {
					{ Text ="Xóa toàn bộ", Callback = self.DelHanhTrangAll, Param = {self} },
					{ Text ="Xóa từng món", Callback = self.DelHanhTrangOne, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:DelHanhTrangOne()
	local tbOptList = {}
	local items = me.GetItemListInBag();
	for nIdx, pItem in ipairs(items) do
		local szName = pItem.szName;
		local nCount = pItem.nCount;
		local nItemDwId = pItem.dwId;
		local nRandomByLevelKindId = pItem.nRandomByLevelKindId;
		local ndwTemplateId = pItem.dwTemplateId;
		local nParamId = nRandomByLevelKindId or KItem.GetItemExtParam(ndwTemplateId, 1);
		local nItemType =  KItem.GetItemExtParam(ndwTemplateId, 2);
		table.insert(tbOptList, 1, { Text = szName, Callback = self.XoaID, Param = {self, pItem,szName} })
	end
	Dialog:Show(
        	{
            	Text = "Xin mời lựa chọn!",
            	OptList = tbOptList,
        	}, me, him)
end

function tbItem:XoaID(pItem,szName)
	pItem.Delete(1)
	me.CenterMsg(string.format("Xóa thành công (%s)",szName));
end

function tbItem:MaxCuongHoa()
	  GM:EnhanceEquip(500);
end

function tbItem:NhanFullSkill()
	  GM:SkillUpFull();
end

function tbItem:DelHanhTrangAll()
	  GM:CleanBag();		
end

function tbItem:FnHorse()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận thú cưỡi", Callback = self.FnHorseAdd, Param = {self} },									
					{ Text ="Nhận Trang Bị Thú Cưỡi", Callback = self.FnHorseItem, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnPartner()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Đồng Hành SSS", Callback = self.FnPartnerSSS, Param = {self} },
					{ Text ="Thăng Cấp Đồng Hành", Callback = self.FnPartnerLevel, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnHouse()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Được Gia Viên", Callback = self.FnHouse1, Param = {self} },
					{ Text ="Tăng Cấp Gia Viên", Callback = self.FnHouse2, Param = {self} },					
					{ Text ="Nhận Nguyên Liệu Gia Cụ", Callback = self.FnHouse3, Param = {self} },
					{ Text ="Nhận Gia Cụ", Callback = self.FnHouse4, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnFaction()
	me.AddItem(9569, 1);
	me.AddItem(9700, 1);
	me.AddItem(4865, 1);
	me.AddItem(4866, 1);
	me.AddItem(4868, 1);
	me.AddItem(7280, 1);
	me.AddItem(7296, 1);
	me.AddItem(7712, 1);
	me.AddItem(7713, 1);
	me.AddItem(8282, 1);
	me.AddItem(8252, 1);
	me.AddItem(8253, 1);
	me.AddItem(8273, 1);
	me.AddItem(10152, 1);
	me.AddItem(10956, 1); ---Băng Hồn Tuyết Phách
	me.AddItem(10954, 1); ---Lôi Đình Bào Hao
	me.AddItem(10198, 1); --Hán Nguyệt Toái Ngân
	me.AddItem(10610, 1); --Lẫm Đông Bào Hao
	me.AddItem(10531, 1); --Thích Kim Mao Tê
	me.AddItem(10647, 1); --U Viêm-Li Mị Hỏa Hồ
	me.AddItem(10502, 1); --Áo Phiên Yến Lưu Vân
	me.AddItem(10509, 1); --Đầu Sức Phiên Yến Lưu Vân
	me.AddItem(10521, 1); --Đầu Sức Hoa Tình
	me.AddItem(10455, 1); --Diều Giấy Xích Lân
	me.AddItem(9491, 1);
	me.AddItem(9718, 1);
	me.AddItem(6709, 1);
	me.AddItem(9728, 1);
	me.AddItem(9699, 1);
end
function tbItem:FnFactionNew()
	me.AddItem(11247, 1); --Oanh Minh Chi Đầu
	me.AddItem(11241, 1); --Đầu Sức Khổng Tước Linh
	me.AddItem(11178, 1); --Phong Hoa Tuyệt Đại
	me.AddItem(11184, 1); --Đầu Sức Phong Hoa Tuyệt Đại
	me.AddItem(10521, 1); --Đầu Sức Hoa Tươi
	me.AddItem(11051, 1); --Ngoại Trang Vũ Khí
end

function tbItem:FnSupportLevel()
	me.AddLevel(200);
end

function tbItem:FnDaoCu()
    me.AddItem(2396, 100); --Sách Tu Vi-Cao
	me.AddItem(7158, 100); --Bí Quyển Kỹ Năng cũ
	me.AddItem(7973, 10); --【Hoàng Kim】Bí Quyển Tuyệt Học
	me.AddItem(7978, 10); --【Trác Việt】Mảnh Tuyệt Học
	me.AddItem(10938, 10); --【Kế Thừa】Tuyệt Học Đoạn Thiên
	me.AddItem(11273, 20); -- Bí Kíp Sơ Vạn Hoa
	me.AddItem(11274, 20);
	me.AddItem(11275, 20);
	me.AddItem(11276, 20);
end

function tbItem:FnZhenYuan()
    me.AddItem(7092, 1);
	me.AddItem(7093, 1);
	me.AddItem(7094, 1);
	me.AddItem(7091, 1);
	me.AddItem(4264, 1);
	me.AddItem(4265, 1);
end

function tbItem:FnItemFull()
	me.AddItem(4818, 1);
	me.AddItem(4820, 1);
	me.AddItem(4821, 1);
	me.AddItem(4822, 1);
	me.AddItem(4823, 1);
	me.AddItem(4824, 1);
	me.AddItem(6803, 1);
	me.AddItem(7735, 1);
	me.AddItem(7485, 1);
	me.AddItem(7499, 1);
	me.AddItem(3692, 1);
	me.AddItem(4477, 1);
	me.AddItem(3577, 1);
	me.AddItem(3578, 1);
	me.AddItem(3579, 1);
	me.AddItem(1391, 1);
	me.AddItem(1392, 1);
	me.AddItem(1526, 1);
	me.AddItem(3313, 1);
	me.AddItem(3314, 1);
	me.AddItem(1454, 1);
	me.AddItem(1430, 5);
	me.AddItem(1431, 5);
	me.AddItem(1432, 5);
	me.AddItem(2591, 1);
	me.AddItem(2876, 1);
	me.AddItem(3238, 1);
	me.AddItem(3714, 5);
	me.AddItem(3715, 5);
	me.AddItem(3716, 5);
	me.AddItem(7912, 5);
	me.AddItem(2877, 5);
	me.AddItem(6444, 5);
	me.AddItem(4579, 5);
	me.AddItem(4580, 5);
	me.AddItem(4581, 5);
	me.AddItem(4582, 5);
	me.AddItem(7153, 5);
	me.AddItem(7154, 5);
	me.AddItem(7155, 5);
	me.AddItem(7156, 5);
	me.AddItem(7157, 5);
	me.AddItem(7158, 5);	
	me.AddItem(3585, 1);
	me.AddItem(4828, 1);
	me.AddItem(4829, 1);
	me.AddItem(4830, 1);
	me.AddItem(5252, 1);
	me.AddItem(6008, 1);
	me.AddItem(3357, 1);
	me.AddItem(3358, 1);
	me.AddItem(3360, 1);
	me.AddItem(3586, 1);
	me.AddItem(4831, 1);
	me.AddItem(4832, 1);
	me.AddItem(6005, 1);
	me.AddItem(6010, 1);
	me.AddItem(6011, 1);
	me.AddItem(6445, 1);
	me.AddItem(7054, 1);
	me.AddItem(7320, 1);
	me.AddItem(7965, 1);
	me.AddItem(3699, 1);
	me.AddItem(7727, 1);
	me.AddItem(7728, 1);
	me.AddItem(7729, 1);
	me.AddItem(6230, 1);
	me.AddItem(6804, 1);
	me.AddItem(7343, 1);
	me.AddItem(7383, 1);
	me.AddItem(7876, 1);
	me.AddItem(7877, 1);
	me.AddItem(7878, 1);	
	me.AddItem(6149, 200);
	me.AddItem(6150, 200);
	me.AddItem(6276, 200);
end

function tbItem:FnSupportNew()
	GM:AddPlayerLevel(90);
	GM:SkillUpFull();
	GM:AddEquips(80, 3);
	GM:EnhanceEquip(50);
	GM:InsetEquip(80, 3);
	PersonalFuben:UnlockFuben();
	GM:AddOnePartner(78);
	GM:AddOnePartner(49);
end

function tbItem:FnHorseAdd()
	me.AddItem(9824, 1);
	me.AddItem(9823, 1);
	me.AddItem(9598, 1);
	me.AddItem(7535, 1);	
	me.AddItem(7152, 1);
	me.AddItem(5359, 1);
	me.AddItem(4859, 1);
	me.AddItem(8369, 1);	
	me.AddItem(4051, 1);
	me.AddItem(4050, 1);
	me.AddItem(4583, 1);	
	me.AddItem(4046, 1);
	me.AddItem(4045, 1);
	me.AddItem(3639, 1);	
end

function tbItem:FnHorseItem()
	me.AddItem(3447, 1); -- Bậc 5
	me.AddItem(3452, 1);
	me.AddItem(3457, 1);
	me.AddItem(3448, 1); -- Bậc 6
	me.AddItem(3453, 1);
	me.AddItem(3458, 1);
	me.AddItem(3449, 1); -- Bậc 7
	me.AddItem(3454, 1);
	me.AddItem(3459, 1);
	me.AddItem(11068, 1); -- Bậc 8
	me.AddItem(11071, 1);
	me.AddItem(11074, 1);
end

function tbItem:FnPartnerSSS()
	--me.AddPartner(3);
	me.AddPartner(4);
	me.AddPartner(5);
	me.AddPartner(6);
	me.AddPartner(7);
	me.AddPartner(9);
	--me.AddPartner(10);
	me.AddPartner(144);
end

function tbItem:FnPartnerLevel()
	local tbPos = me.GetPartnerPosInfo();
	for _, v in pairs(tbPos) do
		me.AddPartnerExp(v, 2000000000);
	end
end

function tbItem:FnGold()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Bạc", Callback = self.FnGold1, Param = {self} },
					{ Text ="Nhận Nguyên Bảo", Callback = self.FnGold2, Param = {self} },
					{ Text ="Nhận Kiếm Hiệp", Callback = self.FnGoldKH, Param = {self} },
					{ Text ="Nhận Ngân Sức", Callback = self.FnGold3, Param = {self} },
					{ Text ="Nhận Điểm Cống Hiến Bang Hội", Callback = self.FnGold4, Param = {self} },
					{ Text ="Nhận Điểm Kiến Thiết Bang Hội", Callback = self.FnGold5, Param = {self} },
					{ Text ="Nhận Điểm Danh Vọng", Callback = self.FnGold6, Param = {self} },
					{ Text ="Nhận Điểm Nguyên Khí", Callback = self.FnGold7, Param = {self} },
					{ Text ="Nhận Điểm Chân Khí", Callback = self.FnGold8, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnGoldKH()
	me.SendAward({{"VipExp", 100000000} }, nil, nil, Env.LogWay_IdIpAddVipExp);
end

function tbItem:FnGold1()
	me.AddMoney("Coin", 100000000, Env.LogWay_Offline);
end

function tbItem:FnGold2()
	me.AddMoney("Gold", 100000000, Env.LogWay_Offline);
end

function tbItem:FnGold3()
	me.AddMoney("SilverBoard", 100000000, Env.LogWay_Offline);
end

function tbItem:FnGold4()
	me.AddMoney("Contrib", 100000000, Env.LogWay_Offline);
end

function tbItem:FnGold5()
	local kinData = Kin:GetKinById(me.dwKinId)
	if kinData then
		local nAddFound = kinData:AddFound(me.dwID, 9999999);
	end
end
	
function tbItem:FnGold6()
	me.AddMoney("Renown", 100000000, Env.LogWay_Offline);
end

function tbItem:FnGold7()
	me.AddMoney("Energy", 100000000, Env.LogWay_Offline);
end

function tbItem:FnGold8()
	me.AddMoney("ZhenQi", 100000000, Env.LogWay_Offline);
end

function tbItem:FnEquip()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Trang Bị Thường", Callback = self.FnEquipThuong, Param = {self} },
					{ Text ="Nhận Trang Bị Hiếm", Callback = self.FnEquipHiem, Param = {self} },
					{ Text ="Nhận Trang Bị Kế Thừa", Callback = self.FnEquipKeThua, Param = {self} },
					{ Text ="Nhận Trang Bị Hoàng Kim", Callback = self.FnEquipHoangKim, Param = {self} },
					{ Text ="Nhận Trang Bị Bạch Kim", Callback = self.FnEquipBachKim, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnEquipThuong()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Trang Bị Thường Cấp 100", Callback = self.FnEquipThuong100, Param = {self} },
					{ Text ="Nhận Trang Bị Thường Cấp 110", Callback = self.FnEquipThuong110, Param = {self} },
					{ Text ="Nhận Trang Bị Thường Cấp 120", Callback = self.FnEquipThuong120, Param = {self} },
					{ Text ="Nhận Trang Bị Thường Cấp 130", Callback = self.FnEquipThuong130, Param = {self} },
					{ Text ="Nhận Trang Bị Thường Cấp 140", Callback = self.FnEquipThuong140, Param = {self} },
					{ Text ="Nhận Trang Bị Thường Cấp 150", Callback = self.FnEquipThuong150, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnEquipKeThua()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Trang Bị Kế Thừa Cấp 100", Callback = self.FnEquipKeThua100, Param = {self} },
					{ Text ="Nhận Trang Bị Kế Thừa Cấp 110", Callback = self.FnEquipKeThua110, Param = {self} },
					{ Text ="Nhận Trang Bị Kế Thừa Cấp 120", Callback = self.FnEquipKeThua120, Param = {self} },
					{ Text ="Nhận Trang Bị Kế Thừa Cấp 130", Callback = self.FnEquipKeThua130, Param = {self} },
					{ Text ="Nhận Trang Bị Kế Thừa Cấp 140", Callback = self.FnEquipKeThua140, Param = {self} },
					{ Text ="Nhận Trang Bị Kế Thừa Cấp 150", Callback = self.FnEquipKeThua150, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnEquipHiem()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Trang Bị Hiếm Cấp 100", Callback = self.FnEquipHiem100, Param = {self} },
					{ Text ="Nhận Trang Bị Hiếm Cấp 110", Callback = self.FnEquipHiem110, Param = {self} },
					{ Text ="Nhận Trang Bị Hiếm Cấp 120", Callback = self.FnEquipHiem120, Param = {self} },
					{ Text ="Nhận Trang Bị Hiếm Cấp 130", Callback = self.FnEquipHiem130, Param = {self} },
					{ Text ="Nhận Trang Bị Hiếm Cấp 140", Callback = self.FnEquipHiem140, Param = {self} },
					{ Text ="Nhận Trang Bị Hiếm Cấp 150", Callback = self.FnEquipHiem150, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnEquipHoangKim()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Trang Bị Hoàng Kim Bậc 9", Callback = self.FnEquipHoangKim100, Param = {self} },
					{ Text ="Nhận Trang Bị Hoàng Kim Bậc 10", Callback = self.FnEquipHoangKim110, Param = {self} },
					{ Text ="Nhận Trang Bị Hoàng Kim Bậc 11", Callback = self.FnEquipHoangKim120, Param = {self} },
					{ Text ="Nhận Trang Bị Hoàng Kim Bậc 12", Callback = self.FnEquipHoangKim130, Param = {self} },
					{ Text ="Nhận Trang Bị Hoàng Kim Bậc 13", Callback = self.FnEquipHoangKim140, Param = {self} },
					{ Text ="Nhận Trang Bị Hoàng Kim Bậc 14", Callback = self.FnEquipHoangKim150, Param = {self} },
					{ Text ="Nhận Trang Bị Hoàng Kim Bậc 15", Callback = self.FnEquipHoangKim160, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnEquipBachKim()
	  Dialog:Show(
	  {
		Text  ="Ta có rất Nhiều hỗ trợ cứ tha hồ mà nhận!",
		OptList = {
					{ Text ="Nhận Trang Bị Bạch Kim Bậc 10", Callback = self.FnEquipBachKim100, Param = {self} },
					{ Text ="Nhận Trang Bị Bạch Kim Bậc 11", Callback = self.FnEquipBachKim110, Param = {self} },
					{ Text ="Nhận Trang Bị Bạch Kim Bậc 12", Callback = self.FnEquipBachKim120, Param = {self} },
					{ Text ="Nhận Trang Bị Bạch Kim Bậc 13", Callback = self.FnEquipBachKim130, Param = {self} },
					{ Text ="Nhận Trang Bị Bạch Kim Bậc 14", Callback = self.FnEquipBachKim140, Param = {self} },
					{ Text ="Nhận Trang Bị Bạch Kim Bậc 15", Callback = self.FnEquipBachKim150, Param = {self} },
					{ Text ="Nhận Trang Bị Bạch Kim Bậc 16", Callback = self.FnEquipBachKim160, Param = {self} },
					{ Text ="Kết thúc đối thoại!", Callback = function () end},
		},
	  }, me, him);
end

function tbItem:FnEquipBachKim100()
	me.AddItem(10016, 1);
	me.AddItem(10060, 1);
	me.AddItem(10049, 1);
	me.AddItem(10071, 1);
	me.AddItem(10027, 1);
	me.AddItem(10104, 1);
	me.AddItem(10038, 1);
	me.AddItem(10093, 1);
	me.AddItem(10115, 1);
	me.AddItem(10082, 1);				
end

function tbItem:FnEquipBachKim110()
	me.AddItem(10017, 1);
	me.AddItem(10061, 1);
	me.AddItem(10050, 1);
	me.AddItem(10072, 1);
	me.AddItem(10028, 1);
	me.AddItem(10105, 1);
	me.AddItem(10039, 1);
	me.AddItem(10094, 1);
	me.AddItem(10116, 1);
	me.AddItem(10083, 1);							
end

function tbItem:FnEquipBachKim120()
	me.AddItem(10018, 1);
	me.AddItem(10062, 1);
	me.AddItem(10051, 1);
	me.AddItem(10073, 1);
	me.AddItem(10029, 1);
	me.AddItem(10106, 1);
	me.AddItem(10040, 1);
	me.AddItem(10095, 1);
	me.AddItem(10117, 1);
	me.AddItem(10084, 1);							
end

function tbItem:FnEquipBachKim130()
	me.AddItem(10019, 1);
	me.AddItem(10063, 1);
	me.AddItem(10052, 1);
	me.AddItem(10074, 1);
	me.AddItem(10030, 1);
	me.AddItem(10107, 1);
	me.AddItem(10041, 1);
	me.AddItem(10096, 1);
	me.AddItem(10118, 1);
	me.AddItem(10085, 1);							
end

function tbItem:FnEquipBachKim140()
	me.AddItem(10020, 1);
	me.AddItem(10064, 1);
	me.AddItem(10053, 1);
	me.AddItem(10075, 1);
	me.AddItem(10031, 1);
	me.AddItem(10108, 1);
	me.AddItem(10040, 1);
	me.AddItem(10097, 1);
	me.AddItem(10119, 1);
	me.AddItem(10086, 1);							
end

function tbItem:FnEquipBachKim150()
	me.AddItem(10021, 1);
	me.AddItem(10065, 1);
	me.AddItem(10054, 1);
	me.AddItem(10076, 1);
	me.AddItem(10032, 1);
	me.AddItem(10109, 1);
	me.AddItem(10041, 1);
	me.AddItem(10098, 1);
	me.AddItem(10120, 1);
	me.AddItem(10087, 1);							
end
function tbItem:FnEquipBachKim160()
	me.AddItem(10022, 1);
	me.AddItem(10066, 1);
	me.AddItem(10055, 1);
	me.AddItem(10077, 1);
	me.AddItem(10033, 1);
	me.AddItem(10110, 1);
	me.AddItem(10042, 1);
	me.AddItem(10099, 1);
	me.AddItem(10121, 1);
	me.AddItem(10088, 1);							
end

function tbItem:FnEquipThuong100()
	GM:AddEquips(110, 1);					
end

function tbItem:FnEquipThuong110()
	GM:AddEquips(120, 1);				
end

function tbItem:FnEquipThuong120()
	me.AddItem(5441, 1);
	me.AddItem(5471, 1);
	me.AddItem(5481, 1);
	me.AddItem(5491, 1);	
	me.AddItem(5501, 1);
	me.AddItem(5511, 1);				
	me.AddItem(5521, 1);
	me.AddItem(5531, 1);	
	me.AddItem(5541, 1);
	me.AddItem(5551, 1);							
end

function tbItem:FnEquipThuong130()
	me.AddItem(5442, 1);
	me.AddItem(5472, 1);
	me.AddItem(5482, 1);
	me.AddItem(5492, 1);	
	me.AddItem(5502, 1);
	me.AddItem(5512, 1);				
	me.AddItem(5522, 1);
	me.AddItem(5532, 1);	
	me.AddItem(5542, 1);
	me.AddItem(5552, 1);							
end

function tbItem:FnEquipThuong140()
	me.AddItem(5443, 1);
	me.AddItem(5473, 1);
	me.AddItem(5483, 1);
	me.AddItem(5493, 1);	
	me.AddItem(5503, 1);
	me.AddItem(5513, 1);				
	me.AddItem(5523, 1);
	me.AddItem(5533, 1);	
	me.AddItem(5543, 1);
	me.AddItem(5553, 1);							
end

function tbItem:FnEquipThuong150()
	me.AddItem(5444, 1);
	me.AddItem(5474, 1);
	me.AddItem(5484, 1);
	me.AddItem(5494, 1);	
	me.AddItem(5504, 1);
	me.AddItem(5514, 1);				
	me.AddItem(5524, 1);
	me.AddItem(5534, 1);	
	me.AddItem(5544, 1);
	me.AddItem(5554, 1);							
end

function tbItem:FnEquipKeThua100()
	GM:AddEquips(110, 2);					
end

function tbItem:FnEquipKeThua110()
	GM:AddEquips(120, 2);				
end

function tbItem:FnEquipKeThua120()
	me.AddItem(5661, 1);
	me.AddItem(5671, 1);
	me.AddItem(5681, 1);
	me.AddItem(5691, 1);	
	me.AddItem(5701, 1);
	me.AddItem(5711, 1);				
	me.AddItem(5721, 1);
	me.AddItem(5731, 1);	
	me.AddItem(5741, 1);
	me.AddItem(5751, 1);							
end

function tbItem:FnEquipKeThua130()
	me.AddItem(5662, 1);
	me.AddItem(5672, 1);
	me.AddItem(5682, 1);
	me.AddItem(5692, 1);	
	me.AddItem(5702, 1);
	me.AddItem(5712, 1);				
	me.AddItem(5722, 1);
	me.AddItem(5732, 1);	
	me.AddItem(5742, 1);
	me.AddItem(5752, 1);							
end

function tbItem:FnEquipKeThua140()
	me.AddItem(5663, 1);
	me.AddItem(5673, 1);
	me.AddItem(5683, 1);
	me.AddItem(5693, 1);	
	me.AddItem(5703, 1);
	me.AddItem(5713, 1);				
	me.AddItem(5723, 1);
	me.AddItem(5733, 1);	
	me.AddItem(5743, 1);
	me.AddItem(5753, 1);							
end

function tbItem:FnEquipKeThua150()
	me.AddItem(5664, 1);
	me.AddItem(5674, 1);
	me.AddItem(5684, 1);
	me.AddItem(5694, 1);	
	me.AddItem(5704, 1);
	me.AddItem(5714, 1);				
	me.AddItem(5724, 1);
	me.AddItem(5734, 1);	
	me.AddItem(5744, 1);
	me.AddItem(5754, 1);							
end

function tbItem:FnEquipHiem100()
	GM:AddEquips(110, 3);					
end

function tbItem:FnEquipHiem110()
	GM:AddEquips(120, 3);				
end

function tbItem:FnEquipHiem120()
	me.AddItem(5561, 50);
	me.AddItem(5571, 50);
	me.AddItem(5581, 50);
	me.AddItem(5591, 50);	
	me.AddItem(5601, 50);
	me.AddItem(5611, 50);			
	me.AddItem(5621, 50);
	me.AddItem(5631, 50);	
	me.AddItem(5641, 50);
	me.AddItem(5651, 50);					
end

function tbItem:FnEquipHiem130()
	me.AddItem(5562, 50);
	me.AddItem(5572, 50);
	me.AddItem(5582, 50);
	me.AddItem(5592, 50);
	me.AddItem(5602, 50);
	me.AddItem(5612, 50);			
	me.AddItem(5622, 50);
	me.AddItem(5632, 50);	
	me.AddItem(5642, 50);
	me.AddItem(5652, 50);						
end

function tbItem:FnEquipHiem140()
	me.AddItem(5563, 50);
	me.AddItem(5573, 50);
	me.AddItem(5583, 50);
	me.AddItem(5593, 50);	
	me.AddItem(5603, 50);
	me.AddItem(5613, 50);				
	me.AddItem(5623, 50);
	me.AddItem(5633, 50);	
	me.AddItem(5643, 50);
	me.AddItem(5653, 50);							
end

function tbItem:FnEquipHiem150()
	me.AddItem(5564, 50);
	me.AddItem(5574, 50);
	me.AddItem(5584, 50);
	me.AddItem(5594, 50);	
	me.AddItem(5604, 50);
	me.AddItem(5614, 50);				
	me.AddItem(5624, 50);
	me.AddItem(5634, 50);	
	me.AddItem(5644, 50);
	me.AddItem(5654, 50);							
end

function tbItem:FnEquipHoangKim100()
	me.AddItem(3619, 1);
	me.AddItem(3629, 1);
	me.AddItem(3621, 1);
	me.AddItem(3633, 1);	
	me.AddItem(3623, 1);
	me.AddItem(3631, 1);				
	me.AddItem(3625, 1);
	me.AddItem(3635, 1);	
	me.AddItem(3627, 1);
	me.AddItem(3637, 1);							
end

function tbItem:FnEquipHoangKim110()
	me.AddItem(3620, 1);
	me.AddItem(3630, 1);
	me.AddItem(3622, 1);
	me.AddItem(3634, 1);	
	me.AddItem(3624, 1);
	me.AddItem(3632, 1);				
	me.AddItem(3626, 1);
	me.AddItem(3636, 1);	
	me.AddItem(3628, 1);
	me.AddItem(3638, 1);							
end

function tbItem:FnEquipHoangKim120()
	me.AddItem(5360, 1);
	me.AddItem(5385, 1);
	me.AddItem(5365, 1);
	me.AddItem(5395, 1);	
	me.AddItem(5370, 1);
	me.AddItem(5390, 1);				
	me.AddItem(5375, 1);
	me.AddItem(5400, 1);	
	me.AddItem(5380, 1);
	me.AddItem(5405, 1);							
end

function tbItem:FnEquipHoangKim130()
	me.AddItem(5361, 1);
	me.AddItem(5386, 1);
	me.AddItem(5366, 1);
	me.AddItem(5396, 1);	
	me.AddItem(5371, 1);
	me.AddItem(5391, 1);				
	me.AddItem(5376, 1);
	me.AddItem(5401, 1);	
	me.AddItem(5381, 1);
	me.AddItem(5406, 1);							
end

function tbItem:FnEquipHoangKim140()
	me.AddItem(5362, 1);
	me.AddItem(5387, 1);
	me.AddItem(5367, 1);
	me.AddItem(5397, 1);	
	me.AddItem(5372, 1);
	me.AddItem(5392, 1);				
	me.AddItem(5377, 1);
	me.AddItem(5402, 1);	
	me.AddItem(5382, 1);
	me.AddItem(5407, 1);							
end

function tbItem:FnEquipHoangKim150()
	me.AddItem(5363, 1);
	me.AddItem(5388, 1);
	me.AddItem(5368, 1);
	me.AddItem(5398, 1);	
	me.AddItem(5373, 1);
	me.AddItem(5393, 1);				
	me.AddItem(5378, 1);
	me.AddItem(5403, 1);	
	me.AddItem(5383, 1);
	me.AddItem(5408, 1);							
end
function tbItem:FnEquipHoangKim160()
	me.AddItem(5364, 1);
	me.AddItem(5389, 1);
	me.AddItem(5369, 1);
	me.AddItem(5399, 1);	
	me.AddItem(5374, 1);
	me.AddItem(5394, 1);				
	me.AddItem(5379, 1);
	me.AddItem(5404, 1);	
	me.AddItem(5384, 1);
	me.AddItem(5409, 1);							
end


function tbItem:FnHonor()
	me.SetHonorLevel(13);
end

function tbItem:FnTitle()
	me.AddTitle(7104, 31536000, false, true); -- Võ Lâm Chí Tôn
	me.AddTitle(7200, 31536000, false, true); -- Đệ Nhất Mỹ Nữ
	me.AddTitle(8105, 31536000, false, true); -- Khởi Vũ Thanh Ảnh
	me.AddTitle(6001, 31536000, false, true); -- Lâm An Thành Chủ
end

function tbItem:FnHouse1()
	GM:GetHouse();
end

function tbItem:FnHouse2()
	GM:LevelupHouse();
end

function tbItem:FnHouse3()
	GM:GetAllHouseMaterial();
end

function tbItem:FnHouse4()
	for i = 4058, 4251 do
		local tbBaseInfo = KItem.GetItemBaseProp(i);
		if tbBaseInfo and tbBaseInfo.szClass =="FurnitureItem"then
			Furniture:Add(me, i);
		end
	end
	for i = 5225, 5246 do
		local tbBaseInfo = KItem.GetItemBaseProp(i);
		if tbBaseInfo and tbBaseInfo.szClass =="FurnitureItem"then
			Furniture:Add(me, i);
		end
	end
	Furniture:Add(me, 4837);
	Furniture:Add(me, 4838);
	Furniture:Add(me, 5256);
	Furniture:Add(me, 6006);
end
