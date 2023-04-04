local tbNpc = Npc:GetClass("KinEscortNpc");

function tbNpc:OnCreate(szParam)
end

function tbNpc:OnDialog(szParam)
	if me.dwKinId ==0 then
		Dialog:Show({Text = "Ngươi chưa vào Bang Hội, không thể tham gia Vận Tiêu", OptList = {}}, me, him);
		return;
	end

	if not KinEscort:IsOpen() then
		Dialog:Show({Text = "Hoạt động chưa mở", OptList = {}}, me, him);
		return;
	end

	local tbKin = Kin:GetKinById(me.dwKinId);
	local nMasterID = tbKin:GetMasterId();
 	local tbAssistantMasterIDs = tbKin:GetCareerMemberIds(Kin.Def.Career_ViceMaster);
 	local nAssistantMasterID = tbAssistantMasterIDs[1] or 0;
 	if me.dwID ~= nMasterID and me.dwID ~= nAssistantMasterID then
		Dialog:Show({Text = "Chỉ có Bang Chủ và Bang Phó mới có thể Nhận Tiêu", OptList = {}}, me, him);
 		return;
 	end

	local OptList = {};
 	local tbEscortData = KinEscort:GetKinEscortData(me.dwKinId);
	if tbKin:GetLastKinEscortDate()~=Lib:GetLocalDay() and tbEscortData.nState==KinEscort.States.beforeAfter then
		table.insert(OptList,{ Text = "Nhận Tiêu", Callback = KinEscort.OnAcceptEscortTask, Param = {KinEscort, me.dwID, tbKin, him}});
	end

	if tbKin:GetLastKinEscortDate()==Lib:GetLocalDay() and tbEscortData.nState==KinEscort.States.prepare then
		local pCarriageNpc = KNpc.GetById(tbEscortData.nCarriageNpcId);
		if pCarriageNpc and pCarriageNpc.nQuality < #KinEscort.tbNpcTemplate then 
			table.insert(OptList,{ Text = "Nâng cấp Tiêu Bang", Callback = KinEscort.OnUpgrade, Param = {KinEscort, me.dwID, me.dwKinId}});
		end

		table.insert(OptList,{ Text = "Bắt đầu Vận Tiêu", Callback = KinEscort.StartEscortAndStartAddExp, Param = {KinEscort, me.dwKinId}});
	end

	Dialog:Show({
	    Text    = KinEscort.szNpcTips,
	    OptList = OptList,
	}, me, him);
end
