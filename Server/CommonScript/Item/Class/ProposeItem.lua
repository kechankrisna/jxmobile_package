local tbItem = Item:GetClass("ProposeItem");

function tbItem:OnUse(it)	
end

function tbItem:OnClientUse(it)
    if not Wedding:CheckOpenProposeTime() then
        me.CenterMsg("Chưa mở", true)
        return 1
    end
    local tbTeam = TeamMgr:GetTeamMember()
    if #tbTeam ~= 1 then
        me.CenterMsg("Cùng [FFFE0D]nhân vật khác giới tính[-] tổ đội [FFFE0D]2 người[-]")
        return 1
    end
    local nMySex = me.nSex;
    local nTeammateSex = Player:Faction2Sex((tbTeam[1] or {}).nFaction, (tbTeam[1] or {}).nSex);
    if not nMySex or not nTeammateSex or nMySex == nTeammateSex then
         me.CenterMsg("Cùng [FFFE0D]nhân vật khác giới tính[-] tổ đội [FFFE0D]2 người[-]")
        return 1
    end
    local bRet, szMsg = Wedding:CheckProposeC(me, tbTeam[1].nPlayerID)
    if not bRet then
        me.CenterMsg(szMsg, true)
        return 
    end

    local fnSure = function (nPlayerID)
        local bRet, szMsg = Wedding:CheckProposeC(me, nPlayerID)
        if not bRet then
            me.CenterMsg(szMsg, true)
            return 
        end
       RemoteServer.OnWeddingRequest("TryChoosePropose");
    end
    me.MsgBox(string.format("Chuẩn bị sẵn sàng cầu hôn [FFFE0D]%s [-]chưa?", tbTeam[1].szName or ""), {{"Cầu hôn", fnSure, tbTeam[1].nPlayerID}, {"Hủy"}})
    return 1
end

