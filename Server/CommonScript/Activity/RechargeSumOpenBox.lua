if MODULE_GAMECLIENT then
	Activity.RechargeSumOpenBox = Activity.RechargeSumOpenBox or {}
end
local tbAct = MODULE_GAMESERVER and Activity:GetClass("RechargeSumOpenBox") or Activity.RechargeSumOpenBox

tbAct.JOIN_LEVEL = 20

tbAct.MAIL_TITLE  = "Rương Phúc Lộc Lễ Hội"; --邮件标题
tbAct.MAIL_TEXT = [[
        Lễ hội đã đến, cùng nhau vui đón. Chào lễ hội tặng rương phúc lộc, gồm [FFFE0D]thưởng Nguyên Bảo giá trị ở 6 tầng[-]. Mở [FFFE0D] toàn bộ rương 6 tầng còn có thể nhận thưởng thêm danh hiệu[-]. Có thể [FFFE0D]nạp thẻ[-] nhận Chìa Khóa tương ứng, mở rương nhận thưởng tương ứng: 
        20,000 VND--Chìa Khóa Tầng 1
        50,000 VND--Chìa Khóa Tầng 2
       100,000 VND--Chìa Khóa Tầng 3
        500,000 VND--Chìa Khóa Tầng 4
       1,000,000 VND--Chìa Khóa Tầng 5
       1,500,000 VND--Chìa Khóa Tầng 6
        Chú ý, mỗi lần nạp thẻ chỉ được nhận [FFFE0D]1 chìa khóa[-] tương ứng để mở và nhận thưởng ở số tầng tương ứng. Thưởng không thể nhận trùng. Ngoài ra [FFFE0D]chưa nhận thưởng tầng 1 sẽ không thể nhận thưởng tầng 2[-].
        Chú ý: Do nạp thẻ bị chậm trễ, hãy đợi [FFFE0D]tài khoản nhận được[-] rồi tiếp tục nạp, để tránh vì sự chậm trễ mà không nhận được Chìa Khóa Rương.
		]];

tbAct.tbRechargeGetKeyItem = { --每档充值给的道具, 从小往大
	[1] 	= 9961; --6元对应key 道具id
	[2] 	= 9962;
	[3] 	= 9963;
	[4] 	= 9964;
	[5] 	= 9965;
	[6] 	= 9966;
}
tbAct.nOpenAllBoxRedBagKey = 145; --打开所有箱子对应的红包key
tbAct.szOpenAllNotifyMsg = "「%s」mở rương hoàn trả tất cả các tầng, nhận thêm [%s]<%s>[-]!";
tbAct.tbRechargeItemBoxAwardSetting = {
	[9958] = { --箱子的道具id
		{ {"Gold", 128 } }; --箱子第一层奖励
		{ {"Gold", 428 } };
		{ {"Gold", 1280 } };
		{ {"Gold", 2180 } };
		{ {"Gold", 3480 } };
		{ {"Gold", 6680 }, {"item", 10494, 1}};
	};
	[9959] = {
		{ {"Gold", 188 } }; --箱子第一层奖励
		{ {"Gold", 688 } };
		{ {"Gold", 1980 } };
		{ {"Gold", 2880 } };
		{ {"Gold", 4880 } };
		{ {"Gold", 6680 }, {"item", 10494, 1}};
	};
	[9960] = {
		{ {"Gold", 268 } }; --箱子第一层奖励
		{ {"Gold", 1280 } };
		{ {"Gold", 2980 } };
		{ {"Gold", 3980 } };
		{ {"Gold", 6580 } };
		{ {"Gold", 6680 }, {"item", 10494, 1}};
	};
	[10246] = {
		{ {"Gold", 298 } }; --箱子第一层奖励
		{ {"Gold", 1380 } };
		{ {"Gold", 3098 } };
		{ {"Gold", 4098 } };
		{ {"Gold", 6680 } };
		{ {"Gold", 6680 }, {"item", 10494, 1}};
	};
	[10247] = {
		{ {"Gold", 298 } }; --箱子第一层奖励
		{ {"Gold", 1380 } };
		{ {"Gold", 3298 } };
		{ {"Gold", 4598 } };
		{ {"Gold", 6880 } };
		{ {"Gold", 7280 }, {"item", 10494, 1}};
	};
	[10493] = {
		{ {"Gold", 298 } }; --箱子第一层奖励
		{ {"Gold", 1380 } };
		{ {"Gold", 3698 } };
		{ {"Gold", 4998 } };
		{ {"Gold", 7280 } };
		{ {"Gold", 8280 }, {"item", 10494, 1}};
	};
}

tbAct.tbRechargeItemBoxTipSetting = {
	[9958] = { --箱子的道具id
		"20,000 VND      128 Nguyên Bảo  ";
		"50,000 VND     428 Nguyên Bảo";
		"100,000 VND     1280 Nguyên Bảo";
		"500,000 VND   2180 Nguyên Bảo";
		"1,000,000 VND   3480 Nguyên Bảo";
		"1,500,000 VND   6680 Nguyên Bảo";
	};
	[9959] = {
		"20,000 VND       188 Nguyên Bảo  ";
		"50,000 VND     688 Nguyên Bảo";
		"100,000 VND     1980 Nguyên Bảo";
		"500,000 VND   2880 Nguyên Bảo";
		"1,000,000 VND   4880 Nguyên Bảo";
		"1,500,000 VND   6680 Nguyên Bảo";	
	};
	[9960] = {
		"20,000 VND       268 Nguyên Bảo  ";
		"50,000 VND     1280 Nguyên Bảo";
		"100,000 VND     2980 Nguyên Bảo";
		"500,000 VND   3980 Nguyên Bảo";
		"1,000,000 VND   6580 Nguyên Bảo";
		"1,500,000 VND   6680 Nguyên Bảo";		
	};
	[10246] = {
		"20,000 VNĐ       298 Nguyên Bảo  ";
		"50,000 VNĐ     1380 Nguyên Bảo";
		"100,000 VNĐ     3098 Nguyên Bảo";
		"500,000 VNĐ   4098 Nguyên Bảo";
		"1,000,000 VNĐ   6680 Nguyên Bảo";
		"1,500,000 VND   6680 Nguyên Bảo";		
	};
	[10247] = {
		"20,000 VNĐ       298 Nguyên Bảo  ";
		"50,000 VNĐ     1380 Nguyên Bảo";
		"100,000 VNĐ     3298 Nguyên Bảo";
		"500,000 VNĐ   4598 Nguyên Bảo";
		"1,000,000 VNĐ   6880 Nguyên Bảo";
		"1,500,000 VNĐ   7280 Nguyên Bảo";		
	};
	[10493] = {
		"20,000 VNĐ       298 Nguyên Bảo  ";
		"50,000 VNĐ     1380 Nguyên Bảo";
		"100,000 VND     3698 Nguyên Bảo";
		"500,000 VND   4998 Nguyên Bảo";
		"1,000,000 VND   7280 Nguyên Bảo";
		"1,500,000 VND   8280 Nguyên Bảo";		
	};
};


function tbAct:GetKeyOpenLevel( nItemKey )
	local nGroup ;
	for k,v in pairs(self.tbRechargeGetKeyItem) do
		if nItemKey == v then
			nGroup = k;
		end
	end
	return nGroup
end