local tbItem = Item:GetClass("BeautyPageantPaper")
local tbAct = Activity.BeautyPageant

function tbItem:GetUseSetting(nTemplateId)
	if not tbAct:IsInProcess() or not tbAct:IsSignUp() then
		return {}
	end

	local tbUseSetting = 
	{
		["szFirstName"] = "Trang cá nhân",
		["fnFirst"] = function ()
			Ui.HyperTextHandle:Handle(string.format("[url=openBeautyUrl:PlayerPage, %s][-]", string.format(tbAct:GetPlayerUrl(), me.dwID, Sdk:GetServerId())));
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
	if dwTemplateId == tbAct.SIGNUP_ITEM_FINAL then
		tbTime = tbAct.STATE_TIME[tbAct.STATE_TYPE.FINAL]
		szMatch = "Chung kết"
	end
	if version_vn then
		if dwTemplateId == tbAct.SIGNUP_ITEM_SEMIFINAL then
			tbTime = tbAct.STATE_TIME[tbAct.STATE_TYPE.SEMIFINAL]
			szMatch = "Sơ Tuyển Liên SV"
		end
	end

	return string.format("[FFFE0D]%s: %s - %s[-]\n\nGiấy ghi thông tin các giai nhân dự giải. Dùng để gửi thông tin thi tuyển của mình lên kênh trò chuyện bất kỳ, hoặc để mở giao diện dự giải của bản thân", szMatch, Lib:TimeDesc10(tbTime[1]), Lib:TimeDesc10(tbTime[2]+1))
end
