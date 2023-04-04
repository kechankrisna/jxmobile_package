local tbItem = Item:GetClass("GoodVoicePaper")
local tbAct = Activity.GoodVoice

function tbItem:GetUseSetting(nTemplateId)
	if not tbAct:IsInProcess() or not tbAct:IsSignUp() then
		return {}
	end

	local tbUseSetting = 
	{
		["szFirstName"] = "Trang cá nhân",
		["fnFirst"] = function ()
			Ui.HyperTextHandle:Handle(string.format(tbAct:GetPlayerPage(me.dwID, Sdk:GetUid())));
			Ui:CloseWindow("ItemTips")
		end,

		["szSecondName"] = "Chia sẻ",
		["fnSecond"] = function ()
			local nChannel = ChatMgr.ChannelType.Public
			if Kin:HasKin() then
				nChannel = ChatMgr.ChannelType.Kin
			end
			Ui:OpenWindow("ChatLargePanel", nChannel, nil, "OpenEmotionLink")
			Ui:CloseWindow("ItemTips")
		end,
	}

	return tbUseSetting;		
end

function tbItem:GetIntrol(dwTemplateId)
	local tbTime = tbAct.STATE_TIME[tbAct.STATE_TYPE.LOCAL]
	local szMatch = "Sơ Loại (Bầu chọn tại máy chủ)"
	if dwTemplateId == tbAct.SIGNUP_ITEM_SEMI_FINAL then
		tbTime = tbAct.STATE_TIME[tbAct.STATE_TYPE.SEMI_FINAL]
		szMatch = "Bán kết"
	elseif dwTemplateId == tbAct.SIGNUP_ITEM_FINAL then
		tbTime = tbAct.STATE_TIME[tbAct.STATE_TYPE.FINAL]
		szMatch = "Chung kết"
	end
	return string.format("[FFFE0D]%s:%s - %s[-]\n\nSổ tay ghi chép thông tin của tuyển thủ tham gia The Voice, thông qua nó để quảng bá giọng hát của mình ở kênh trò chuyện bất kỳ hoặc mở trang tham gia thi đấu của bản thân.", szMatch, Lib:TimeDesc10(tbTime[1]), Lib:TimeDesc10(tbTime[2]+1))
end