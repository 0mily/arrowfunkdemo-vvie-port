af = {}

local lang = ''
local assets = {} 
local sure = false
local buceta = false

function onCreate()
    stopSound('')
    playSound('friendJoinConfig', 1)

    lang = getPropertyFromClass('backend.ClientPrefs', 'data.language')
    af.configurarIdiomas()
    
    af.shitPooPooBiduzin()
end

function af.configurarIdiomas()
    if lang == 'pt-BR' then
        assets.warning = 'flashing/warn-pt'
    else
        assets.warning = 'flashing/warn-en'
    end
end

function onCreatePost()
    af.confgKKKK()
    
    local lado = 10
    local targetX = 1280 - getProperty('bidu.width') - lado - 6
    local posY = 720 - getProperty('bidu.height') - lado + 3
    
    setProperty('bidu.x', 1300)
    setProperty('bidu.y', posY)
    setProperty('warning.y', 320)
    setProperty('warnshit.y', 413)
    setProperty('enter.y', 533)

    doTweenX('biduVino', 'bidu', targetX, 0.8, 'expoOut')
    doTweenY('warninVino', 'warning', 210, 0.8, 'expoOut')
    doTweenY('warninVinotext', 'warnshit', 303, 0.8, 'expoOut')
    doTweenY('entertext', 'enter', 423, 0.8, 'expoOut')
end

function af.confgKKKK()
    playAnim('bidu', 'normal', true)
end

function af.shitPooPooBiduzin()
    makeAnimatedLuaSprite('bidu', 'flashing/biduflash', 0, 0)
    addAnim('bidu', 'normal', 'bidu IDLE0', 24, true)
    addAnim('bidu', 'flashbang', 'bidu ACCEPT0', 24, false)
    addLuaSprite('bidu', true)
    scaleObject('bidu', 0.8, 0.8, true)

    makeLuaSprite('warning', assets.warning, 0, 0)
    screenCenter('warning', 'x');
    updateHitbox('warning')
    addLuaSprite('warning')

    makeLuaText('warnshit', 'This mod may\ncontain Flashing Lights,\nColorful Colors and stuff like that', 1280, 0, 0)
    setTextAlignment('warnshit', 'center')
    setTextSize('warnshit', 32)
    screenCenter('warnshit', 'x')
    setProperty('warnshit.antialiasing', true)
    setTextFont('warnshit', 'hey.ttf')
    setTextBorder('warnshit', 1, 'FF0000', 'none')
    addLuaText('warnshit')

    makeLuaText('enter', 'Press ENTER to continue', 1280, 0, 0)
    setTextSize('enter', 36)
    screenCenter('enter', 'x')
    setProperty('enter.antialiasing', true)
    setTextFont('enter', 'hey.ttf')
    setTextBorder('enter', 1, 'FF0000', 'none')
    addLuaText('enter')

end

function ficaBrancoPorra()
    debugPrint('cabaço');
    makeLuaSprite('bg_color', '', 0, 0)
    makeGraphic('bg_color', screenWidth, screenHeight, 'FFFFFF')
    addLuaSprite('bg_color', false)
    setTextColor('warnshit', '000000')
    setProperty('warning.color', '000000')
    removeLuaText('enter', true)
    playAnim('bidu', 'flashbang')

    cameraFlash('game', 'FFFFFF', 0.5)
    setProperty('camGame.zoom', 1.1)
    doTweenZoom('legal', 'game', 1, 1.3, 'expoOut')
    playSound('confirmMenu', 1)
    runTimer('indoali', 0.7)
    runTimer('aaa', 0.46)
    runTimer('ibora', 3.5)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'indoali' then
        cameraFade('game', 'FFFFFF',1.7, true)
    elseif tag == 'aaa' then
        playSound('AAAAAAAAAAAA', 1, 'aaa')
    elseif tag == 'ibora' then
        loadState('AF_TitleState')
    end
end

-- anothers five hundreds

function onUpdate()
    if keyJustPressed('back') then
        switchState('MainMenuState')
    end

    if keyJustPressed('accept') and buceta == false then
        if sure == false then
            setTextString('enter', 'Are you sure?');
            setTextColor('enter', 'FF0000')
            playSound('pause', 1)
            sure = true
        elseif sure == true then
            buceta = true
            ficaBrancoPorra()
        end
        
    end
end