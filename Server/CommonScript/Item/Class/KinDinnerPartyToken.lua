local tbItem = Item:GetClass("KinDinnerPartyToken")

function tbItem:OnUse(it)
	local bOk, szErr = KinDinnerParty:CanUsePartyToken(me)
	if not bOk then
		if szErr and szErr ~= "" then
			me.CenterMsg(szErr, true)
		end
		return 0
	end

	if not KinDinnerParty:IsPlayerJoinCountValid(me) then
		me.CenterMsg(string.format("Tuần này đã tham gia %d lần Tiệc Bang Hội, không thể dùng", KinDinnerParty.Def.nMaxPlayerJoinCount), true)
		return 0
	end

	if KinDinnerParty:IsRunning(me.dwID) then
		me.CenterMsg("Đã có tiệc đang tiến hành", true)
		return 0
	end

	me.CallClientScript("Ui:CloseWindow", "ItemBox")
	me.CallClientScript("Ui:CloseWindow", "ItemTips")

	if not House:IsInOwnHouse(me) or not House:IsIndoor(me) then
		House:GotoKinDinnerParty(me, me.dwID)
		return 0
	end

	local nMyId = me.dwID
	me.MsgBox("Đồng ý triệu hồi bàn ăn ở vị trí hiện tại?", {
        {"Đồng ý", function()
        	local pPlayer = KPlayer.GetPlayerObjById(nMyId)
        	if not pPlayer then
        		return
        	end
            pPlayer.CallClientScript("Ui:CloseWindow", "QuickUseItem")
            local bOk, szErr = KinDinnerParty:TryCallTable(pPlayer, it)
            if not bOk then
            	if szErr and szErr ~= "" then
            		pPlayer.CenterMsg(szErr, true)
            	end
            end
        end}, {"Hủy"}
    })

	return 0
end
