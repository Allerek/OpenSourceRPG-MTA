SQL = exports.rpg_db
RPu = exports.rpg_utilities
spawns= {
	{"1716","-1902","13"},
	{"822","-1345","13"}
}
--Sekwencja logowania
addEvent("login",true)
addEventHandler("login",getRootElement(),function(plr,login,pass)
    if not plr or not login or not pass then return end
    local ip = getPlayerIP(source)
    local serial = getPlayerSerial(plr)

    local q = SQL:query("select * from ips_core_members where name=?", login)
	passwordVerify(pass, q[1].members_pass_hash, function(verified)
	if verified then
        for i,v in pairs(getElementsByType("Player")) do
			local info = getElementData(v,"p:info")
			if info then
				if q[1].member_id == info.gid then
					outputDebugString("TU BĘDZIE NOTI-KTOŚ JEST NA KONCIE")
					return
				end
			end
		end
		local q2 = SQL:query("select * from rpg_accounts where gid=?",q[1].member_id)
		if #q2 <= 0 then
			SQL:query("INSERT INTO rpg_accounts (name,health) VALUES(?,100)",q[1].name)
			kickPlayer(plr,"Stworzono konto!")
		end
		setPlayerName(plr,q[1].name)
		setElementData(plr,"p:logged",true)
		setElementData(plr,"p:info",{
			["gid"] = q[1].member_id,
			["dpoints"] = q[1].pp_reputation_points,
			["groupid"] = q[1].member_group_id,
			["name"] = q2[1].name,
			["money"] = q2[1].money,
			["bankmoney"] = q2[1].bank,
			["skin"] = q2[1].skin,
		},true)
		RPu:doCheckID(plr)
		math.randomseed( os.time() )
		local number = math.random(1,#spawns)
		spawnPlayer(plr,spawns[number][1],spawns[number][2],spawns[number][3],0,q2[1].skin,0,0)
		setElementHealth(plr,q2[1].health)
		triggerClientEvent(plr,"loginC",plr)
		setCameraTarget(plr)
		else
			print("Nie ma takiej kombinacji")
		end
	end)
end)

--Sprawdzanie bana na wejściu
addEventHandler('onPlayerConnect', root, function(playerNick, playerIP, playerUsername, playerSerial)
	local result=SQL:query('SELECT * FROM rpg_bans WHERE serial=? AND time>NOW() LIMIT 1;', playerSerial)
	if #result > 0 then
		cancelEvent(true,"Zostałeś/aś zbanowany/a na tym serwerze!\nPowód zbanowania:" .. result[1].reason.."\nCzas bana:"..result[1].time.."l")
	else
		SQL:query("DELETE FROM rpg_bans WHERE serial=?",playerSerial)
	end
end)

--Takie tam do konsoli i wysył danych do panelu po lewej stronie
addEventHandler("onResourceStart",resourceRoot,function()
	print("=")
	print("==")
	print("===")
	print("====")
	print("=====")
	print("======")
	print("=======")
	print("========")
	print("=========")
	print("==========")
	print("===========")
	print("============")
	print("=============")
	print("==============")
	print("===============")
	print("=================")
	local time = getRealTime()
	local month = time.month
	local day = time.monthday
	local year = 1900+time.year
	local hour = time.hour
	local minute = time.minute
	if (hour < 10) then
		hour = "0"..hour
	end
	if (minute < 10) then
		minute = "0"..minute
	end
	if (day < 10) then
		day = "0"..day
	end
	if (month < 10) then
		month = "0"..month+1
	end
	print("Rozruch:"..day.."|"..month.."|"..year.." "..hour..":"..minute)
	local q = SQL:query("SELECT * FROM rpg_settings WHERE name=?","devMode")
	local q2 = SQL:query("SELECT * FROM rpg_settings WHERE name=?","devPass")
	if q[1].value == "true" then
		setServerPassword(q2[1].value)
	else
		setServerPassword(nil)
	end
	local q3 = SQL:query("SELECT * FROM rpg_settings WHERE name=?","name")
	print("Serwer: "..q3[1].value)
	setGameType(q3[1].value)
	q = SQL:query('SELECT * FROM rpg_settings WHERE name=?',"forumLink")
	flink = q[1].value
	q = SQL:query('SELECT * FROM rpg_settings WHERE name=?',"discordLink")
	dlink = q[1].value
	for i,v in pairs(getElementsByType("player")) do 
		if not getElementData(v,"p:info") then
			setTimer(function()
				triggerClientEvent(v,"onLoginShowC",v,flink,dlink)
			end,100,1)
		end
	end
end)

--Ustawianie danych w tabeli po lewej.
addEvent("onLoginShowS",true)
addEventHandler("onLoginShowS",getRootElement(),function()
	q = SQL:query('SELECT * FROM rpg_settings WHERE name=?',"forumLink")
	flink = q[1].value
	q = SQL:query('SELECT * FROM rpg_settings WHERE name=?',"discordLink")
	dlink = q[1].value
	local plr = source
	triggerClientEvent(plr,"onLoginShowC",plr,flink,dlink)
end)

--Zapis na wyjściu
addEventHandler("onPlayerQuit",getRootElement(),function()
    local info = getElementData(source,"p:info")
    if not info then return end
	local hp = getElementHealth(source)
	local skin = info.skin or 0
	local money = info.money
	local id = info.gid
	SQL:query("UPDATE rpg_accounts SET health=?,skin=?,money=? WHERE gid=?",hp,skin,money,id)
end)

--Po śmierci 2 sekundy i respawn
addEventHandler ( "onPlayerWasted", getRootElement(),function()
	math.randomseed( os.time() )
	local number = math.random(1,#spawns)
	setTimer(spawnPlayer(source,spawns[number][1],spawns[number][2],spawns[number][3],0,getElementData(source,"p:info").skin,0,0),2000,1)
end)

