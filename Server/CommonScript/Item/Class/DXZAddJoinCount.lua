
Require("CommonScript/Activity/DaXueZhangDef.lua");

local tbDaXueZhang = Activity.tbDaXueZhang;
local tbDef = tbDaXueZhang.tbDef;

local tbItem = Item:GetClass("DXZAddJoinCount")
tbItem.nAddCount = 1;

function tbItem:CheckDXZJoinCount(pPlayer, nAdd)
    local nDegreeAdd = DegreeCtrl:GetDegree(pPlayer, "DaXueZhangAdd");  
    if nDegreeAdd <= 0 then
        return false, "Số lần mỗi ngày tăng không đủ";
    end

    return true, "";
end

function tbItem:OnUse(it)
    local bRet, szMsg = self:CheckDXZJoinCount(me, tbItem.nAddCount);
    if not bRet then
        me.CenterMsg(szMsg, true);
        return;
    end

    DegreeCtrl:ReduceDegree(me, "DaXueZhangAdd", 1);
    tbDaXueZhang:AddPlayerJoinCount(me, tbItem.nAddCount);
    me.CenterMsg("Nhận 1 lần tam gia", true);
    return 1
end