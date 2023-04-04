local tbItem = Item:GetClass("WeddingWelcome");
function tbItem:OnUse(it)
	if Wedding:IsPlayerMarring(me.dwID) then
		me.CenterMsg("Đang cử hành hôn lễ, không thể đến đó", true)
		return 
	end
	if Wedding:IsPlayerTouring(me.dwID) then
		me.CenterMsg("Đang diễu hành, không thể đến đó", true)
		return 
	end
	if not Env:CheckSystemSwitch(me, Env.SW_ChuangGong) then
		me.CenterMsg("Trạng thái hiện tại không thể đến đó", true)
		return 
	end
	if not Env:CheckSystemSwitch(me, Env.SW_Muse) then
		me.CenterMsg("Trạng thái hiện tại không thể đến đó", true)
		return 
	end
	local nMapId = it.GetIntValue(1)
	if not nMapId then
		return
	end
	local tbInst = Fuben.tbFubenInstance[nMapId]
	if not tbInst then
		me.CenterMsg("Hôn lễ này đã kết thúc", true)
		return
	end
	tbInst:SynWelcomeInfo(me)
end

function tbItem:GetTip(it)
	if type(it) ~= "userdata" then
		return ""
	end
	local szNameStr = it.GetStrValue(1) or ""
	local szManName, szFemanName = unpack(Lib:SplitStr(szNameStr, ";"))
	return string.format("Tân Lang: %s\nTân Nương: %s", szManName or "", szFemanName or "")
end