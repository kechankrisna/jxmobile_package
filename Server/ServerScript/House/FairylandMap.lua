local tbPeach = House.tbPeach;
local tbMap = Map:GetClass(tbPeach.FAIRYLAND_MAP_TEMPLATE_ID);

function tbMap:OnCreate(nMapId)
	tbPeach:OnFairylandCreate(nMapId);
end

function tbMap:OnDestroy(nMapId)
	tbPeach:OnFairylandDestroy(nMapId);
end

function tbMap:OnEnter(nMapId)
	tbPeach:OnEnterFairyland(me, nMapId);
end

function tbMap:OnLeave(nMapId)
	tbPeach:OnLeaveFairyland(me, nMapId);
end

function tbMap:OnPlayerTrap(nMapId, szTrapName)
end

function tbMap:OnLogin(nMapId)
	tbPeach:OnLoginFairyland(me, nMapId);
end