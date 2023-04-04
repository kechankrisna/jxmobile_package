NewInformation.nOperationTypeQianngGou =1
NewInformation.nOperationTypeJingji    =2
NewInformation.nOperationTypeHuoDong   =3
NewInformation.nOperationTypeGongGao   =4

NewInformation.tbActivity = {
    FactionBattle = {
        szTitle    = "Thi Đấu Môn Phái",
        -- szUiName   = "Normal", -- 指定的UI组件，默认用Key作为组件名字
    },
    FactionBattleCross = {
        szTitle    = "Thi Đấu Môn Phái Liên SV",
        szUiName = "FactionBattle",
    },
    OpenSrvActivity = {
        szTitle    = "Bách Đại Bang Hội",
        nReqLevel = 11,
    },
    FactionMonkey = {
        szTitle    = "Tranh Cử Môn Phái",
    },

    DomainBattle = {
        szTitle    = "Kết Quả Công Thành Chiến",
        szUiName   = "TerritoryInfo",
    },

    LevelRankActivity = {
        szTitle    = "Hạng Cấp",
        szUiName   = "LevelRankActivity",
        nReqLevel = 10,
    },

     PowerRankActivity = {
        szTitle    = "Hạng Lực Chiến",
        szUiName   = "PowerRankActivity",
        nReqLevel = 10,
    },

	NormalActiveUi = {
		szTitle = "Hoạt động ",
		szUiName = "DragonBoatFestival",
		nReqLevel = 10,
	},

    HSLJEightRank = {
        szTitle = "Tứ Kết Hoa Sơn Luận Kiếm",
        szUiName = "HSLJEightRank",
        nReqLevel = 10,
    },

    HSLJChampionship = {
        szTitle = "Quán Quân Hoa Sơn Luận Kiếm",
        szUiName = "HSLJChampionship",
        nReqLevel = 10,
    },

    RandomFubenCollection = {
        szTitle    = "Thu Thập Lăng Tuyệt Phong",
        szUiName   = "CardCollectionInfo",
    },

    DomainBattleAct =
    {
        szTitle    = "Công Thành Chiến Sôi Động",
        szUiName   = "Normal",
    };

    DomainBattleAct2 =
    {
        szTitle    = "Công Thành Chiến Sôi Động 2",
        szUiName   = "Normal",
    };

    JXSH_Collection = {
        szTitle    = "Hạng Thu Thập Cẩm Tú Sơn Hà",
        szUiName   = "JXSH_RankInfo",
    },
    NYLottery = 
    {
        szTitle    = "Rút Thưởng Năm Mới",
        nReqLevel = 40,
    },
    NYLotteryResult = 
    {
        szTitle    = "Danh Sách Rút Thưởng May Mắn",
        nReqLevel = 40,
    },
    AnniversaryBag = 
    {
        szTitle    = "Quà Mừng Sinh Nhật",
    },
    WLDHChampionship = 
    {
      szTitle    = "Quán Quân Đại Hội Võ Lâm",  
    },
    HonorMonthRank = {
        szTitle = "Vinh Dự Võ Lâm Bạch Kim",
        szUiName = "HonorMonthRank",
    },

    LotteryResult =
    {
        szTitle = "Quà Tặng Minh Chủ",
        szUiName = "LotteryResult",
    },
    WebActivity = 
    {
        szTitle = "Phúc Tinh Cao Chiếu",
    },
}
---------------在此的配置适用于数据较大的功能，会单独存储ScriptData，数据小的情况下不许配置---------------

function NewInformation:RegisterButtonCallBack(szType, tbCallBack)
    self.tbButtonCallBack = self.tbButtonCallBack or {};
    self.tbButtonCallBack[szType] = tbCallBack;
end

function NewInformation:UnRegisterButtonCallBack(szType)
    self.tbButtonCallBack = self.tbButtonCallBack or {};
    self.tbButtonCallBack[szType] = nil;
end

function NewInformation:OnButtonEvent(szType)
    local tbCallBack = self.tbButtonCallBack[szType];
    if not tbCallBack or not tbCallBack[1] then
        return;
    end

    Lib:CallBack(tbCallBack);
end