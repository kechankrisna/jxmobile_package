LoverTask.SAVE_GROUP = 176
LoverTask.nFinishCountIdx = 1 					-- 完成次数
LoverTask.nTaskTypeIdx = 2 						-- 任务类型
LoverTask.nTaskStateIdx = 3 					-- 任务状态
LoverTask.nTaskStepIdx = 4 						-- 任务进度
LoverTask.nTaskTeammateIdx = 5 					-- 一起进行任务的队友id
LoverTask.nUpdateTimeIdx = 6 					-- 次数更新时间

LoverTask.TASK_TYPE_IDIOMS = 1 					-- 有缘一线牵
LoverTask.TASK_TYPE_DEFEND = 2 					-- 缘定长相守
LoverTask.TASK_TYPE_DREAM = 3 					-- 梦境


LoverTask.TASK_STATE_ACCEPT = 1 				-- 任务状态-接取
LoverTask.TASK_STATE_CANCEL = 2 				-- 任务状态-取消
LoverTask.TASK_STATE_CAN_FINISH = 3 			-- 任务状态-可完成

LoverTask.MAX_FINISH_COUNT = 2 					-- 每周最多可完成次数

LoverTask.PROCESS_SHOW_TASK_PANEL = 1 			-- 展示交任务界面
LoverTask.PROCESS_FINISH_TASK = 2 				-- 接任务

LoverTask.nTaskIdiomsFubenMapTId = 8013
LoverTask.nTaskDefendFubenMapTId = 8014
LoverTask.nTaskDreamFubenMapTId = 8015

LoverTask.nLoveTaskFakeId = -1
-- 时间轴概率
LoverTask.tbTimeFrameRate = LoverTask.tbTimeFrameRate or {}

LoverTask.nMinJoinLevel = 35 				-- 参与最小等级
LoverTask.nMaxJoinLevel = 79 				-- 参与最大等级
LoverTask.nAddImitity = 200 					-- 组队完成任务增加的亲密度
LoverTask.nAddTitleId = 6808
LoverTask.nTitleTime = 7 * 24 * 60 * 60 		-- 称号有效期
LoverTask.szTitleFrame = "OpenLevel59" 			-- 该时间轴开放之后就不给称号
LoverTask.tbSetting = 
{
	[LoverTask.TASK_TYPE_IDIOMS] = 
	{
		szFubenClass = "IdiomsFubenBaseTask";
		nFubenMapTemplateId = LoverTask.nTaskIdiomsFubenMapTId;
		nDelayKickOut = 120;
		JOIN_MEMBER_COUNT = 2;
		NameCol = 10;
		NameRow = 10;
		tbNpcNameSet = {} ;						-- 决定每条龙有几个tbTaskIdiomsFuben.tbNpcPos = {};
		tbNpcPos = {};
		tbNpcIdSet = {2051} ;					-- 所有的npcid
		REVIVE_TIME = 3;
		tbReward = {}; 							-- 副本奖励，配置表（任务完成发）
		tbFinishAward = 
		{
			["OpenLevel39"] = {
				tbTaskAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}; 		-- 任务完成奖励
			};
			["OpenLevel59"] = {
				tbTaskAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}; 		-- 任务完成奖励
				tbExtAward = { {{"item", 9509, 1}}}; 				-- 从里面随机一份
			};			
		};
		nWinCount = 10; 							-- 接上几句成语任务才完成
		nPreFinishDialogId = 91002; 			-- 完成任务之前的对话
		tbStep = 
		{
			{
				szDes = "[Duyên] Thí Luyện Ăn Ý", 
				szFinishDes = "[Duyên] Thí Luyện Ăn Ý", 
				szType = "Dialog", 
				tbParam = {91000}, 
				tbTaskInfo = {
					-- szTitle 任务标题 szDetail 任务目标 szDesc任务描述 tbAward 任务展示奖励
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Thí Luyện Ăn Ý[-]", szDetail = "Trò chuyện với [FFFE0D]Yên Nhược Tuyết[-]", szDesc = "Yên Nhược Tuyết muốn giúp mọi người bồi dưỡng độ ăn ý, nghe nói ở Cửu Châu Văn Mạch Nguyên, vào tu luyện có thể tăng độ ăn ý.", tbShowAward = {}};
				};
			};
			{
				szDes = "[Duyên] Vong Tuyết Địa", 
				szFinishDes = "[Duyên] Vong Tuyết Địa", 
				szType = "Dialog", 
				tbParam = {91001}, 
				tbTaskInfo = {
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Vong Tuyết Địa[-]", szDetail = "Gặp [FFFE0D]Yên Nhược Tuyết[-] tìm hiểu về Vong Tuyết Cốc", szDesc = "Thì ra Văn Mạch Nguyên ở Thiên Sơn Phúc Địa, có tên là Vong Tuyết Cốc, linh vật bên trong đều đặt tên bằng các câu thành ngữ, Yên Nhược Tuyết yêu cầu mọi người diệt quái theo tên nối tiếp nhau, đạt 10 điểm sẽ hoàn thành thí luyện lần này.", tbShowAward = {}};
				};
			};
			{
				szDes = "[Duyên] Đến Vong Tuyết Cốc", 
				szFinishDes = "【Đã xong】[Duyên] Thí Luyện Vong Tuyết[-]", 
				szType = "Fuben", 
				tbParam = {LoverTask.nTaskIdiomsFubenMapTId}, 
				tbTaskInfo = {
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Thí Luyện Vong Tuyết[-]", szDetail = "Theo [FFFE0D]Yên Nhược Tuyết[-] vào phó bản", szDesc = "Chuẩn bị xong rồi hãy tìm Yên Nhược Tuyết, cô ấy sẽ đưa mọi người đến Vong Tuyết Cốc", tbShowAward = {}};
					[LoverTask.TASK_STATE_CAN_FINISH] = {szTitle = "[11adf6][Duyên] Thí Luyện Vong Tuyết[-]", szDetail = "Tìm [FFFE0D]Yên Nhược Tuyết[-] nhận thưởng", szDesc = "Hai vị dễ dàng vượt qua thí luyện, độ ăn ý đầy, Nhược Tuyết tặng các vật sau, mong người hữu tình trong thiên hạ sẽ được thành đôi!", tbShowAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}};
				};
			};
		};
	};
	[LoverTask.TASK_TYPE_DEFEND] = {
		szFubenClass = "DefendFubenBaseTask";
		nFubenMapTemplateId = LoverTask.nTaskDefendFubenMapTId;
		nPreFinishDialogId = 91005; 													-- 完成任务之前的对话
		KICK_TIME = 5;
		REVIVE_TIME = 5;
		nMingXiaHitMsgInteval = 10;
		tbFinishAward = 
		{
			["OpenLevel39"] = {
				tbTaskAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}; 		-- 任务完成奖励
			};
			["OpenLevel59"] = {
				tbTaskAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}; 		-- 任务完成奖励
				tbExtAward = { {{"item", 9509, 1}}}; 				-- 从里面随机一份
			};		
		};
		tbReward = { 																	-- 副本奖励（任务完成发）
			[0] = {{"Item", 4523, 1}},
			[1] = {{"Item", 4524, 1}}, 		
			[2] = {{"Item", 4525, 1}},
			[3] = {{"Item", 4526, 1}},
			[4] = {{"Item", 4527, 1}},
			[5] = {{"Item", 4528, 1}}, 		
			[6] = {{"Item", 4529, 1}, {"AddTimeTitle", 5033, 10*24*60*60}},
		};
		nWinCount = 4; 							-- 守几波任务才完成
		tbSeriesSetting = {
			["Dialog"] = {
				[1] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement1", Index = "Series_Jin1",  Text = "Thiên Vương"},
				[2] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement2", Index = "Series_Mu1",   Text = "Tiêu Dao"},
				[3] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement3", Index = "Series_Shui1", Text = "Nga Mi"},
				[4] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement4", Index = "Series_Huo1",  Text = "Đào Hoa"},
				[5] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement5", Index = "Series_Tu1",   Text = "Võ Đang"},
			},
			["Monster"] = {
				[1] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement1", Index = "Series_Jin2",  Text = "Kim"},
				[2] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement2", Index = "Series_Mu2",   Text = "Mộc"},
				[3] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement3", Index = "Series_Shui2", Text = "Thủy"},
				[4] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement4", Index = "Series_Huo2",  Text = "Hỏa"},
				[5] = {FontSize = 18, NotShow = 0, XPos = 0, YPos = 0, Color = "FiveElement5", Index = "Series_Tu2",   Text = "Thổ"},
			}, 
			
		};
		tbStep = 
		{
			{
				szDes = "[Duyên] Sinh Tử Tương Thủ", 
				szFinishDes = "[Duyên] Sinh Tử Tương Thủ", 
				szType = "Dialog", 
				tbParam = {91003}, 
				tbTaskInfo = {
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Sinh Tử Tương Thủ[-]", szDetail = "Trò chuyện với [FFFE0D]Yên Nhược Tuyết[-]", szDesc = "Yên Nhược Tuyết biết Trương Như Mộng và người yêu Nam Cung Thái Hồng gặp nạn, mong mọi người có thể giúp đỡ họ.", tbShowAward = {}};
				};
			};
			{
				szDes = "[Duyên] Tái Ngoại Đại Mạc", 
				szFinishDes = "[Duyên] Tái Ngoại Đại Mạc", 
				szType = "Dialog", 
				tbParam = {91004}, 
				tbTaskInfo = {
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Tái Ngoại Đại Mạc[-]", szDetail = "Nghe [FFFE0D]Yên Nhược Tuyết[-] giảng giải chiến thuật", szDesc = "Yên Nhược Tuyết đã nói xong cách giải cứu, mọi người cần phòng thủ 4 lần tấn công, việc còn Yên Nhược Tuyết sẽ giải quyết.", tbShowAward = {}};
				};
			};
			{
				szDes = "[Duyên] Đến Tái Ngoại", 
				szFinishDes = "[Đã xong] [Duyên] Giải Vây Biên Ải[-]", 
				szType = "Fuben", 
				tbParam = {LoverTask.nTaskDefendFubenMapTId};
				tbTaskInfo = {
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Tái Ngoại Giải Vây[-]", szDetail = "Theo [FFFE0D]Yên Nhược Tuyết[-] đến Tái Ngoại", szDesc = "Chuẩn bị xong rồi hãy tìm Yên Nhược Tuyết, cô ấy sẽ đưa mọi người đến Vong Tuyết Cốc", tbShowAward = {}};
					[LoverTask.TASK_STATE_CAN_FINISH] = {szTitle = "[11adf6][Duyên] Tái Ngoại Giải Vây[-]",  szDetail = "Tìm [FFFE0D]Yên Nhược Tuyết[-] nhận thưởng", szDesc = "Hai vị đại hiệp đã không ngại nguy hiểm, Yên Nhược Tuyết rất khâm phục, hai người trai tài gái sắc thật xứng đôi, nay ta tặng hai người một số vật tình duyên.",tbShowAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}};
				};
			};
		};
	};
	[LoverTask.TASK_TYPE_DREAM] = 
	{
		szFubenClass = "DreamFubenBaseTask";
		nPreFinishDialogId = 91008; 	
		nFubenMapTemplateId = LoverTask.nTaskDreamFubenMapTId;
		KICK_TIME = 120;
		REVIVE_TIME = 5;
		tbFinishAward = 
		{
			["OpenLevel39"] = {
				tbTaskAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}; 		-- 任务完成奖励
			};
			["OpenLevel59"] = {
				tbTaskAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}; 		-- 任务完成奖励
				tbExtAward = { {{"item", 9509, 1}}}; 				-- 从里面随机一份
			};			
		};
		tbStep = 
		{
			{
				szDes = "[Duyên] Tâm Kết Thành Mộng", 
				szFinishDes = "[Duyên] Tâm Kết Thành Mộng", 
				szType = "Dialog", 
				tbParam = {91006}, 
				tbTaskInfo = {
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Tâm Kết Thành Mộng[-]", szDetail = "Trò chuyện với [FFFE0D]Yên Nhược Tuyết[-]", szDesc = "Yên Nhược Tuyết có vẻ như đang có tâm sự, đến hỏi xem sao.", tbShowAward = {}};
				};
			};
			{
				szDes = "[Duyên] Nhược Tuyết Mộng Cảnh", 
				szFinishDes = "[Duyên] Nhược Tuyết Mộng Cảnh", 
				szType = "Dialog", 
				tbParam = {91007}, 
				tbTaskInfo = {
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Nhược Tuyết Mộng Cảnh[-]", szDetail = "Tìm hiểu mộng cảnh của [FFFE0D]Nhược Tuyết[-]", szDesc = "Yên Nhược Tuyết nói về những việc cần lưu ý của mộng cảnh, hai vị phải học cách nắm tay mới có thể thông qua mộng cảnh", tbShowAward = {}};
				};
			};
			{
				szDes = "[Duyên] Tiền Vãng Mộng Cảnh", 
				szFinishDes = "[Đã xong] [Duyên] Nhược Tuyết Mộng Cảnh[-]", 
				szType = "Fuben", 
				tbParam = {LoverTask.nTaskDreamFubenMapTId};
				tbTaskInfo = {
					[LoverTask.TASK_STATE_ACCEPT] = {szTitle = "[11adf6][Duyên] Tiền Vãng Mộng Cảnh[-]", szDetail = "Vào Mộng Cảnh [FFFE0D]Yên Nhược Tuyết[-]", szDesc = "Chuẩn bị xong thì đi tìm Yên Nhược Tuyết, cô ấy sẽ đưa các ngươi vào mộng cảnh", tbShowAward = {}};
					[LoverTask.TASK_STATE_CAN_FINISH] = {szTitle = "[11adf6][Duyên] Mộng Cảnh Trở Về[-]",  szDetail = "Tìm [FFFE0D]Yên Nhược Tuyết[-] nhận thưởng", szDesc = "Hai vị đã giúp Yên Nhược Tuyết giải được nút thắt trong lòng, Yên Nhược Tuyết quyết định nói rõ chân tướng, đối mặt với số mệnh, đây là vật tình duyên cho hai vị.",tbShowAward = {{"item", 1234, 20},{"item", 1235, 20},{"item", 1969, 5,0,true},{"BasicExp", 90}}};
				};
			};
		};
    };
}
LoverTask.nRecommondLoverCount = 3 						-- 推荐人数
local tbTaskIdiomsFuben = LoverTask.tbSetting[LoverTask.TASK_TYPE_IDIOMS]
local tbTaskDefendFuben = LoverTask.tbSetting[LoverTask.TASK_TYPE_DEFEND]

function LoverTask:LoadSetting()
	if MODULE_GAMESERVER then
		local szTabPath,szParamType,tbParams
		if not next(tbTaskIdiomsFuben.tbNpcNameSet) then
			szTabPath = "Setting/LoverTask/IdiomsTask/npc_name.tab";
			szParamType = "";
			tbParams = {};
			for i = 1, tbTaskIdiomsFuben.NameCol do
				szParamType = szParamType .. "s";
				table.insert(tbParams, "name" .. i);
			end
			tbTaskIdiomsFuben.tbNpcNameSet = LoadTabFile(szTabPath, szParamType, nil, tbParams);
			assert(#tbTaskIdiomsFuben.tbNpcNameSet == tbTaskIdiomsFuben.NameCol,string.format("[tbTaskIdiomsFuben] LoadSetting no match NameCol %d/%d",#tbTaskIdiomsFuben.tbNpcNameSet,tbTaskIdiomsFuben.NameCol))
			local nRow = 0
			for _,v in ipairs(tbTaskIdiomsFuben.tbNpcNameSet) do
				assert(Lib:CountTB(v) == tbTaskIdiomsFuben.NameCol,"[tbTaskIdiomsFuben] LoadSetting valid NameCol")
				nRow = nRow + 1
			end
			assert(nRow == tbTaskIdiomsFuben.NameRow,"[tbTaskIdiomsFuben] LoadSetting valid NameRow")
		end
		if not next(tbTaskIdiomsFuben.tbNpcPos) then
			szTabPath = "Setting/LoverTask/IdiomsTask/npc_pos.tab";
			szParamType = "dd";
			tbParams = {"PosX", "PosY"};
			local tbFile = LoadTabFile(szTabPath, szParamType, nil, tbParams);
			for _, tbInfo in ipairs(tbFile) do
				table.insert(tbTaskIdiomsFuben.tbNpcPos, {nPosX = tbInfo.PosX, nPosY = tbInfo.PosY});
			end
		end
		if not next(tbTaskIdiomsFuben.tbReward) then
			szTabPath = "Setting/LoverTask/IdiomsTask/Award.tab";
			szParamType = "ds"
			tbParams = {"nRank","szAward"}
			local tbFile = LoadTabFile(szTabPath, szParamType, nil, tbParams);
			for _, tbInfo in ipairs(tbFile) do
				local tbRow = {}
				tbRow[1] = tbInfo.nRank
				tbRow[2] = Lib:GetAwardFromString(tbInfo.szAward)
				table.insert(tbTaskIdiomsFuben.tbReward,tbRow)
			end
		end
	end

end
LoverTask:LoadSetting()

function LoverTask:OnServerStart()
	if version_tx or version_hk then
		self.tbTimeFrameRate =  					-- 时间轴概率
			{
				["OpenLevel39"] = {
					tbRate = {
						[LoverTask.TASK_TYPE_IDIOMS] = 1000;
						[LoverTask.TASK_TYPE_DEFEND] = 1000;
						[LoverTask.TASK_TYPE_DREAM] = 1000;
					};
				};
			}
	else
		self.tbTimeFrameRate =  					-- 时间轴概率
			{
				["OpenLevel39"] = {
					tbRate = {
						[LoverTask.TASK_TYPE_IDIOMS] = 0;
						[LoverTask.TASK_TYPE_DEFEND] = 1000;
						[LoverTask.TASK_TYPE_DREAM] = 1000;
					};
				};
			}
	end
	assert(next(self.tbTimeFrameRate), "[Error] LoverTask Wrong Rate...")
	for _, v in pairs(self.tbTimeFrameRate) do
		local nTotalRate = 0
		for _, nRate in pairs(v.tbRate) do
			nTotalRate = nTotalRate + nRate
		end
		v.nTotalRate = nTotalRate
	end
end

function LoverTask:GetTaskIdiomsFubenReward(nRank)
	local tbAllReward = {}

	for _,tbInfo in ipairs(tbTaskIdiomsFuben.tbReward) do
		tbAllReward = Lib:CopyTB(tbInfo[2])
		if nRank <= tbInfo[1] then
			break
		end
	end

	return self:FormaReward(tbAllReward)
end

function LoverTask:FormaReward(tbAllReward)
	tbAllReward = Lib:CopyTB(tbAllReward) or {}

	local tbFormatReward = {}
	for _,tbReward in ipairs(tbAllReward) do
		if tbReward[1] == "AddTimeTitle" then
			tbReward[3] = tbReward[3] + GetTime()
		end
		table.insert(tbFormatReward,tbReward)
	end

	return tbFormatReward
end

function LoverTask:GetTaskDefendFubenReward(nRound)
	return tbTaskDefendFuben.tbReward[nRound] and  self:FormaReward(tbTaskDefendFuben.tbReward[nRound]) 
end

function LoverTask:GetSeriesSetting(szKey, nSeries)
	local tbSetting = tbTaskDefendFuben.tbSeriesSetting[szKey] and tbTaskDefendFuben.tbSeriesSetting[szKey][nSeries]
	return tbSetting and Lib:CopyTB(tbSetting)
end

function LoverTask:GetActiveTaskType(pPlayer)
	local nTaskType = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx);
	local nTaskState = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
	if nTaskType > 0 and (nTaskState == LoverTask.TASK_STATE_ACCEPT or nTaskState == LoverTask.TASK_STATE_CAN_FINISH) then
		return nTaskType
	end
end

function LoverTask:GetCancelTaskType(pPlayer)
	local nTaskType = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx);
	local nTaskState = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
	if nTaskType > 0 and nTaskState == LoverTask.TASK_STATE_CANCEL then
		return nTaskType
	end 
end

function LoverTask:CheckTeammate(pPlayer, szTipTitle)
	local tbTeam = TeamMgr:GetTeamById(pPlayer.dwTeamID)
	if not tbTeam then
		return false, string.format("Cần nam nữ 2 người tổ đội mới có thể %s!", szTipTitle or "Nhận nhiệm vụ")
	end
	local tbMember = TeamMgr:GetMembers(pPlayer.dwTeamID)
    if #tbMember ~= 2 then
        return false, string.format("Cần nam nữ 2 người tổ đội mới có thể %s!", szTipTitle or "Nhận nhiệm vụ")
    end
    local nMemberId = tbMember[1] == pPlayer.dwID and tbMember[2] or tbMember[1]
    local pMember = KPlayer.GetPlayerObjById(nMemberId)
    if not pMember then
        return false, "Không tìm được đồng đội"
    end
     local nMapId1 = pPlayer.GetWorldPos()
    local nMapId2 = pMember.GetWorldPos()
    if nMapId1 ~= nMapId2 or pPlayer.GetNpc().GetDistance(pMember.GetNpc().nId) > Npc.DIALOG_DISTANCE * 3 then
        return false, "Đồng đội không ở gần!"
    end
    return true, "", pMember, tbTeam
end

function LoverTask:CheckLevel(pPlayer)
	if pPlayer.nLevel < LoverTask.nMinJoinLevel or pPlayer.nLevel > LoverTask.nMaxJoinLevel then
		return false
	end
	return true
end

function LoverTask:CheckAcceptTask(pPlayer)
	local bRet, szMsg, pMember, tbTeam = self:CheckTeammate(pPlayer)
	if not bRet then
		return false, szMsg
	end
    if tbTeam:GetCaptainId() ~= pPlayer.dwID then
        return false, "Đại hiệp không phải đội trưởng không thể thao tác!"
    end
    if pPlayer.nSex == pMember.nSex then
        return false, "Cần nam nữ 2 người tổ đội mới có thể nhận nhiệm vụ!"
    end
    local nLoverId = Wedding:GetLover(pPlayer.dwID)
    if nLoverId and nLoverId ~= pMember.dwID then
    	return false, "Chỉ có thể cùng hoàn thành với đối tượng kết hôn"
    end
    local nEngaged = Wedding:GetEngaged(pPlayer.dwID)
    if nEngaged and nEngaged ~= pMember.dwID then
    	return false, "Chỉ có thể cùng hoàn thành với đối tượng đính hôn"
    end

    local nMemberLoverId = Wedding:GetLover(pMember.dwID)
    if nMemberLoverId and nMemberLoverId ~= pPlayer.dwID then
    	return false, string.format("%s đã kết hôn, chỉ có thể cùng hoàn thành với đối tượng kết hôn", pMember.szName)
    end
    local nMemberEngaged = Wedding:GetEngaged(pMember.dwID)
    if nMemberEngaged and nMemberEngaged ~= pPlayer.dwID then
    	return false, string.format("%s đã đính hôn, chỉ có thể cùng hoàn thành với đối tượng đính hôn", pMember.szName)
    end
    if not LoverTask:CheckLevel(pPlayer) then
    	return false, string.format("%s không trong phạm vi cấp tham gia", pPlayer.szName)
    end
     if not LoverTask:CheckLevel(pMember) then
    	return false, string.format("%s không trong phạm vi cấp tham gia", pMember.szName)
    end
    return true, "", pMember
end

function LoverTask:CheckDoTask(pPlayer)
	local bRet, szMsg, pMember, tbTeam = self:CheckTeammate(pPlayer, "Làm nhiệm vụ")
	if not bRet then
		return false, szMsg
	end
	if tbTeam:GetCaptainId() ~= pPlayer.dwID then
        return false, "Đại hiệp không phải đội trưởng không thể thao tác!"
    end
    local nTeammateId = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTeammateIdx)
    local nMemberTeammateId = pMember.GetUserValue(self.SAVE_GROUP, self.nTaskTeammateIdx)
    if nTeammateId ~= pMember.dwID or pPlayer.dwID ~= nMemberTeammateId then
    	return false, "Nhiệm vụ phải tiến hành cùng đồng đội"
    end
    local nTaskType = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx);
    local nMemberTaskType = pMember.GetUserValue(self.SAVE_GROUP, self.nTaskTypeIdx);
    
    if nTaskType == 0 or not nMemberTaskType == 0 then
    	return false, "Hiện không có nhiệm vụ"
    end
    if nTaskType ~= nMemberTaskType then
    	return false, "Nhiệm vụ không giống nhau"
    end
    local nTaskStep = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStepIdx);
    local nMemberTaskStep = pMember.GetUserValue(self.SAVE_GROUP, self.nTaskStepIdx);
    if nTaskStep == 0 or nTaskStep ~= nMemberTaskStep then
    	return false, "Tiến độ nhiệm vụ không giống nhau"
    end
    local nTaskState = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
    local nMemberTaskState = pMember.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
    if nTaskState == 0 then 
    	return false, string.format("「%s」không trong trạng thái nhiệm vụ", pPlayer.szName)
    end
    if nMemberTaskState == 0 then 
    	return false, string.format("「%s」không trong trạng thái nhiệm vụ", pMember.szName)
    end
    if nTaskState == LoverTask.TASK_STATE_CANCEL then
    	return false, string.format("「%s」đã hủy nhiệm vụ", pPlayer.szName)
    end
    if nMemberTaskState == LoverTask.TASK_STATE_CANCEL then
    	return false, string.format("「%s」đã hủy nhiệm vụ", pMember.szName)
    end
    if nTaskState ~= nMemberTaskState then
    	return false, "Trạng thái nhiệm vụ không giống nhau"
    end
    return true, "", pMember, nTaskState
end

-- 返回任务步骤描述
function LoverTask:GetTaskStepDes(pPlayer)
	local nTaskType = self:GetActiveTaskType(pPlayer)
	if not nTaskType then
		return
	end
	local nTaskState = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
	local nTaskStep = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStepIdx);
	local tbStep = LoverTask:GetTaskStep(pPlayer) or {}
	local tbStepInfo = tbStep[nTaskStep] or {}
	local szDes = tbStepInfo.szDes
	if nTaskState == self.TASK_STATE_CAN_FINISH and tbStepInfo.szFinishDes then
		szDes = tbStepInfo.szFinishDes
	end
	return szDes or ""
end

function LoverTask:GetTaskPreFinishDialog(nTaskType)
	local tbTaskSetting = self.tbSetting[nTaskType]
	return tbTaskSetting and tbTaskSetting.nPreFinishDialogId
end

function LoverTask:GetTaskStep(pPlayer)
	local nTaskType = self:GetActiveTaskType(pPlayer)
	if not nTaskType then
		return
	end
	return self.tbSetting[nTaskType] and self.tbSetting[nTaskType].tbStep
end

function LoverTask:GetTaskAward(pPlayer)
	local nTaskType = self:GetActiveTaskType(pPlayer)
	if not nTaskType then
		return
	end
	local tbInfo = self.tbSetting[nTaskType] or {}
	local szMaxTimeFrame = Lib:GetMaxTimeFrame(tbInfo.tbFinishAward)
	local tbAward = tbInfo.tbFinishAward[szMaxTimeFrame]
	return tbAward.tbTaskAward, tbAward.tbExtAward
end

function LoverTask:GetTaskInfo(pPlayer)
	local tbStep = LoverTask:GetTaskStep(pPlayer)
	if not tbStep then
		return
	end
	local nTaskStep = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStepIdx);
	local tbTaskInfo = tbStep[nTaskStep] and tbStep[nTaskStep].tbTaskInfo
	local nTaskState = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
	return tbTaskInfo and tbTaskInfo[nTaskState]
end

function LoverTask:GetLoverTask(pPlayer)
	local tbTask = LoverTask:GetTaskInfo(pPlayer)
	if not tbTask then
		return
	end
	return {LoverTask.nLoveTaskFakeId, tbTask.szTitle, tbTask.szDetail, tbTask.szDesc, tbTask.tbShowAward}
end

function LoverTask:IsLoverTask(nTaskId)
	return nTaskId == LoverTask.nLoveTaskFakeId
end

function LoverTask:CheckGiveUpTask(pPlayer)
	local nTaskType = self:GetActiveTaskType(pPlayer)
	if not nTaskType then
		return false, "Không có nhiệm vụ để hủy"
	end
	local nTaskState = pPlayer.GetUserValue(self.SAVE_GROUP, self.nTaskStateIdx);
	if nTaskState == self.TASK_STATE_CAN_FINISH then
		return false, "Không thể hủy nhiệm vụ đã xong"
	end
	return true
end

function LoverTask:IsDreamTaskMap(pPlayer)
	if pPlayer.nMapTemplateId == self.nTaskDreamFubenMapTId then
		return true
	end
end