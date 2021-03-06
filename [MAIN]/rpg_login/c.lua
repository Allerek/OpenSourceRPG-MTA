loadstring(exports.dgs:dgsImportFunction())()
RPu = exports.rpg_utilities

--Tworzymy tablice do których wrzucimy elementy
elements = {}
elements["login"] = {}
elements["main"] = {}

--Trochę zmiennych, plr z przyzwyczajenia do s-side i dla przejrzystości kodu, czcionki poza tablicą bo są tylko dwie.
local zoom = RPu:getZoom()
local plr = getLocalPlayer()
local screenW, screenH = guiGetScreenSize()
local font = dxCreateFont(":rpg_login/files/font.ttf",12)
local font2 = dxCreateFont(":rpg_login/files/font.ttf",20)

--Wielkości editboxów, dla wygody w zmiennej.
local a,b = 384,54

--Skalujemy elementy
sizelogined = RPu:scaleScreen(0,60,a,b,"center","center")
sizepassed = RPu:scaleScreen(0,-10,a,b,"center","center")
sizeloginbtn = RPu:scaleScreen(0,-100,a,b,"center","center")
sizeinfo = RPu:scaleScreen(600,0,616,260,"center","center")
sizelogo = RPu:scaleScreen(0,200,225,162,"center","center")

--Tworzymy elementy
--Main
elements["main"]["background"] = dgsCreateImage(screenW*0,screenH*0,screenW*1,screenH*1,":rpg_login/files/tlo.png",false)
elements["main"]["logo"] = dgsCreateImage(unpack(sizelogo,1),unpack(sizelogo,2),unpack(sizelogo,3),unpack(sizelogo,4),":rpg_login/files/logo.png",false,false)
elements["main"]["info"] = dgsCreateImage(unpack(sizeinfo,1),unpack(sizeinfo,2),unpack(sizeinfo,3),unpack(sizeinfo,4),":rpg_login/files/info.png",false,false)

--Login
elements["login"]["logined"] = dgsCreateEdit(unpack(sizelogined,1),unpack(sizelogined,2),unpack(sizelogined,3),unpack(sizelogined,4),"LOGIN",false,false,tocolor(255,255,255),1,1,":rpg_login/files/edit.png",tocolor(255,255,255))
elements["login"]["passed"] = dgsCreateEdit(unpack(sizepassed,1),unpack(sizepassed,2),unpack(sizepassed,3),unpack(sizepassed,4),"HASLO",false,false,tocolor(255,255,255,255),1,1,":rpg_login/files/edit.png",tocolor(255,255,255))
elements["login"]["loginbtn"] = dgsCreateButton(unpack(sizeloginbtn,1),unpack(sizeloginbtn,2),unpack(sizeloginbtn,3),unpack(sizeloginbtn,4),"ZALOGUJ",false,false,tocolor(255,255,255),1,1,":rpg_login/files/button.png",":rpg_login/files/button.png",":rpg_login/files/button.png",tocolor(255,255,255),tocolor(155,155,155),tocolor(255,255,255))
elements["login"]["label"] = dgsCreateLabel(screenW*0.02,screenH*0.015,screenW*1,screenH*1,"Jeśli widzisz ten napis\nto znaczy że skrypt nie zdążył się załadować.\nPołącz się ponownie\nlub zaloguj tutaj!",false,elements["main"]["info"],false,1/zoom,1/zoom)

--Z defaultu chowamy elementy by przy restarcie się nie pokazywały
for i,v in pairs(elements["login"]) do
    dgsSetLayer(v,"top")
    dgsSetVisible(v,false)
end

    --Ustawiamy widoczność i warstwy dla DGS
    dgsSetVisible(elements["main"]["logo"],false)
    dgsSetVisible(elements["main"]["background"],false)
    dgsSetLayer(elements["main"]["logo"],"top")
    dgsSetLayer(elements["main"]["info"],"top")
    dgsSetLayer(elements["login"]["label"],"top")

    --Różnorakie właściwości elementów.
    dgsSetProperty(elements["login"]["logined"],"caretColor",tocolor(255,255,255,0))
    dgsSetProperty(elements["login"]["logined"],"textColor",tocolor(104,109,115,255))
    dgsSetProperty(elements["login"]["logined"],"alignment",{"center","center"})
    dgsEditSetMaxLength(elements["login"]["logined"],20)

    dgsSetProperty(elements["login"]["passed"],"caretColor",tocolor(255,255,255,255))
    dgsSetProperty(elements["login"]["passed"],"textColor",tocolor(104,109,115,255))
    dgsSetProperty(elements["login"]["passed"],"masked",true)
    dgsSetProperty(elements["login"]["passed"],"alignment",{"center","center"})
    dgsEditSetMaxLength(elements["login"]["passed"],15)

    dgsSetFont(elements["login"]["logined"],font)
    dgsSetFont(elements["login"]["passed"],font)
    dgsSetFont(elements["login"]["loginbtn"],font)
    dgsSetFont(elements["login"]["label"],font2)

    --Alpha elementów, wymagane do dgsAlphaTo
    dgsSetAlpha(elements["main"]["logo"],0.1)
    dgsSetAlpha(elements["main"]["info"],0.1)
    dgsSetAlpha(elements["login"]["logined"],0.1)
    dgsSetAlpha(elements["login"]["passed"],0.1)
    dgsSetAlpha(elements["login"]["loginbtn"],0.1)
    
    --Dźwięk pisania w editbox.
    dgsEditSetTypingSound(elements["login"]["logined"],":rpg_login/files/tock.mp3")
    dgsEditSetTypingSound(elements["login"]["passed"],":rpg_login/files/tock.mp3")

--Funkcja do niszczenia elementów np. po zalogowaniu lub restarcie skryptu(dla gracza zalogowanego)
function destroyElements()
    for i,v in pairs(elements["login"]) do
        destroyElement(v)
    end
    for i,v in pairs(elements["main"]) do
        destroyElement(v)
    end
end

--Animacje panelu przy uruchomieniu skryptu, pokazanie panelu
function showLogin()
    dgsSetVisible(elements["login"]["logined"],true)
    dgsSetVisible(elements["login"]["passed"],true)
    dgsSetVisible(elements["login"]["loginbtn"],true)
    dgsSetVisible(elements["login"]["label"],true)
    dgsSetVisible(elements["main"]["logo"],true)

    dgsAlphaTo(elements["main"]["logo"],1,false,"OutQuad",2000)
    dgsAlphaTo(elements["login"]["logined"],1,false,"OutQuad",2000)
    dgsAlphaTo(elements["login"]["passed"],1,false,"OutQuad",2000)
    dgsAlphaTo(elements["login"]["loginbtn"],1,false,"OutQuad",2000)
    dgsAlphaTo(elements["main"]["info"],1,false,"OutQuad",2000)
end

--Wykrywanie klikniecia
function btnClick( button, state )
    if button == "left" and state == "down" then
        if source == elements["login"]["loginbtn"] then
            local login = dgsGetText(elements["login"]["logined"])
            local pass = dgsGetText(elements["login"]["passed"])
            if login == "" or pass == "" then return end
            triggerServerEvent("login",plr,plr,login,pass)
            playSound("files/click.mp3",false,true)
        end
    end
end
addEventHandler ( "onDgsMouseClick", getRootElement(),btnClick)

--Wykrywanie zmiany focusu na element
function dgsFocus()
    local edlog = elements["login"]["logined"]
    local edpass = elements["login"]["passed"]
    if source == edlog then
        if dgsGetText(edlog) == "LOGIN" then
            dgsSetProperty(edlog,"text","")
        end
        if dgsGetText(edpass) == "" then
            dgsSetProperty(edpass,"text","HASLO")
        end
        playSound("files/click.mp3",false,true)
    elseif source == edpass then
        if dgsGetText(edpass) == "HASLO" then
            dgsSetProperty(edpass,"text","")
        end
        if dgsGetText(edlog) == "" then
            dgsSetProperty(edlog,"text","LOGIN")
        end
        playSound("files/click.mp3",false,true)
    end
end
addEventHandler("onDgsFocus", getRootElement(), dgsFocus, true)

--Chowanie elementów(niszczenie ich) po zalogowaniu
addEvent("loginC",true)
addEventHandler("loginC",getRootElement(),function()
    destroyElements()
    showCursor(false)
    showChat(true)
end)

--Ustawianie danych w tabeli po lewej.
addEvent("onLoginShowC",true)
addEventHandler("onLoginShowC",getRootElement(),function(flink,dlink)
    dgsSetProperty(elements["login"]["label"],"text","Nie masz konta? Stwórz je na forum!\nLogowanie do naszego serwera odbywa się\nza pomocą danych do konta na forum.\n\n Forum: "..flink.."\nDiscord: "..dlink.."")
end)

--Jeśli gracz nie jest zalogowany to pokazujemy mu panel logowania, jeśli jest zalogowany to niszczymy elementy, wyłączamy dźwięki wystrzałów
--Wyłączamy też ograniczniki prędkości na moście SF czy głównej drodze LV
addEventHandler("onClientResourceStart",resourceRoot,function()
    if not getElementData(plr,"p:info") then
        fadeCamera(true,0)
        setPlayerHudComponentVisible("all",false)
        showCursor(true)
        showChat(false)
        dgsSetVisible(elements["main"]["background"],true)
        dgsSetVisible(elements["main"]["logo"],true)
        showLogin()
        triggerServerEvent("onLoginShowS",plr)
    else
        destroyElements()
    end
    setAmbientSoundEnabled( "gunfire", false )
    setWorldSpecialPropertyEnabled("extraairresistance",false)
end,false,"low-1")

   



