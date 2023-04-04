
local tbAct = Activity:GetClass(WuLinDaHui.szActNameYuGao);
local tbDef = WuLinDaHui.tbDef;

tbAct.tbTimerTrigger =
{
}

tbAct.tbTrigger =
{
	Init 	= { }, 
	Start 	= { }, 
	End 	= { }, 
};


function tbAct:OnTrigger(szTrigger)
	if szTrigger == "Init" then	

		Mail:SendGlobalSystemMail({
			Title = "Võ lâm đại hội";
			Text = WuLinDaHui.tbDef.szMailTextYuGao;
			});

	elseif szTrigger == "Start" then	
		local _,nEndTime = self:GetOpenTimeInfo()
		NewInformation:AddInfomation(tbDef.szNewsKeyNotify, nEndTime, {}, {szTitle = "Võ lâm đại hội mở ra", nReqLevel = 1, szUiName = "Normal2"} )    

		Timer:Register(1, function ()
			KPlayer.BoardcastScript(1, "Player:ServerSyncData", "UpdateTopButton"); 
		end)
	elseif szTrigger == "End" then

	end
end

