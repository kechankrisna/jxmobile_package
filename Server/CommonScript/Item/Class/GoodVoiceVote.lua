local tbItem = Item:GetClass("GoodVoiceVote")
local tbAct = Activity.GoodVoice

function tbItem:GetUseSetting(nTemplateId)
	if not tbAct:IsInProcess() then
		return {}
	end

	local tbUseSetting = 
	{
		["szFirstName"] = "Tặng ca sĩ",
		["fnFirst"] = function ()
			Ui:OpenWindow("BeautyCompetitionPanel", Ui:GetClass("BeautyCompetitionPanel").TYPE_GOODVOICE_COMPETITION)
			Ui:CloseWindow("ItemTips")
		end,
	}

	return tbUseSetting;		
end