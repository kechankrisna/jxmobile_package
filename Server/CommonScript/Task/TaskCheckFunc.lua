
-----------------  check task require ----------------
function Task:CheckRequireMinLevel(pPlayer, value)
	return pPlayer.nLevel >= value, "Cấp chưa đạt" .. value;
end

function Task:CheckRequireMaxLevel(pPlayer, value)
	if value == 0 then
		-- value 为零表示无上限
		return true;
	end

	local szFailMsg = string.format("Cấp quá %s", value);
	return pPlayer.nLevel <= value, szFailMsg;
end

function Task:CheckRequireFinishTask(pPlayer, value)
	local nFlag = self:GetTaskFlag(pPlayer, tonumber(value) or 9999999);
	return nFlag == 1, "Nhiệm vụ phía trước chưa hoàn thành";
end


-----------------  check task target ----------------
function Task:CheckTargetExtInfo(pPlayer, nTaskId, szTarget, tbCurInfo)
	if tbCurInfo and tbCurInfo[szTarget] then
		return true;
	end

	return false;
end

function Task:CheckTargetOnTrap(pPlayer, nTaskId, tbTargetInfo, tbCurInfo)
	if tbCurInfo and tbCurInfo[tbTargetInfo.nMapTemplateId] and tbCurInfo[tbTargetInfo.nMapTemplateId][tbTargetInfo.szTrap] then
		return true;
	end

	return false;
end

function Task:CheckTargetEnterMap(pPlayer, nTaskId, nTargetMapId, tbCurInfo)
	tbCurInfo = tbCurInfo or {};
	return tbCurInfo[nTargetMapId] and true or false;
end

function Task:CheckTargetKillNpc(pPlayer, nTaskId, tbTargetInfo, tbCurInfo)
	for nNpcTemplateId, nCount in pairs(tbTargetInfo) do
		if not tbCurInfo or not tbCurInfo[nNpcTemplateId] or tbCurInfo[nNpcTemplateId] < nCount then
			return false;
		end
	end
	return true;
end

function Task:CheckTargetPersonalFuben(pPlayer, nTaskId, tbTargetInfo)
	local szSectionName = PersonalFuben:GetSectionName(tbTargetInfo.nSectionIdx, tbTargetInfo.nSubSectionIdx, tbTargetInfo.nFubenLevel);
	if not szSectionName then
		return false;
	end

	local nStarLevel = PersonalFuben:GetFubenStarLevel(pPlayer, tbTargetInfo.nSectionIdx, tbTargetInfo.nSubSectionIdx, tbTargetInfo.nFubenLevel);
	return nStarLevel > 0, "Chưa hoàn thành" .. szSectionName;
end

function Task:CheckTargetCollectItem(pPlayer, nTaskId, tbTargetInfo)
	for nItemId, nCount in pairs(tbTargetInfo) do
		if pPlayer.GetItemCountInAllPos(nItemId) < nCount then
			return false, "Chưa đạt mục tiêu nhiệm vụ!";
		end
	end

	return true;
end

function Task:CheckTargetMinLevel(pPlayer, nTaskId, nTargetMinLevel)
	if nTargetMinLevel < 0 then
		return false, "Cốt truyện mới sắp ra mắt, hãy đợi";
	end

	if pPlayer.nLevel < nTargetMinLevel then
		return false, string.format("Đại hiệp chưa đạt Lv%s, hãy rèn luyện thêm!", nTargetMinLevel);
	end

	return true
end

function Task:CheckTargetExtPoint(pPlayer, nTaskId, nTargetValue, tbCurInfo)
	if not tbCurInfo or not tbCurInfo.nValue or tbCurInfo.nValue < nTargetValue then
		return false, "Chưa đạt mục tiêu nhiệm vụ!";
	end

	return true;
end

function Task:CheckTargetAchievement(pPlayer, nTaskId, tbTargetAchievement)
	if not Achievement:CheckCompleteLevel(pPlayer, unpack(tbTargetAchievement)) then
		return false, "Chưa đạt mục tiêu nhiệm vụ!";
	end

	return true;
end