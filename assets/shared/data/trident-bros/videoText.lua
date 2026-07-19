local skipKey = 'Y'
local timerFadeIn = 0.5
local timerFadeOut = 2

-- This is only for the text, I was too lazy to do it on hscript

function onCreate()
    if lowQuality then
        close(true)
    end
end

function onEvent(n)
    if n == 'Video' then
        createTip('Puedes saltar la cinemática presionando '..skipKey, 'KurriIslandCaps.ttf')
    end
end

function createTip(text, font)
    if font ~= '' or font ~= nil then font = 'vcr.ttf' end

    makeLuaText('texthelp', tostring(text), screenWidth, 0, screenHeight * 0.92)
    setTextBorder('texthelp', 1.25, '000000')
    setTextColor('texthelp', 'FFFFFF')
    setTextSize('texthelp', 32)
    setTextFont('texthelp', font)
    screenCenter('texthelp', 'x')
    setObjectCamera('texthelp','other')
    setTextAlignment('texthelp', 'center')
    setProperty('texthelp.alpha', 0)
    addLuaText('texthelp')
    setProperty('texthelp.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))

    makeLuaText('textShadow', text, screenWidth, 0, screenHeight * 0.92)
    setTextColor('textShadow', '000000')
    setTextSize('textShadow', 32)
    setTextFont('textShadow', font)
    setObjectCamera('textShadow','other')
    setProperty('textShadow.x', getProperty('texthelp.x') + 3)
    setProperty('textShadow.y', getProperty('texthelp.y') + 2)
    setTextAlignment('textShadow', 'center')
    setProperty('textShadow.alpha', 0)
    addLuaText('textShadow')
    setProperty('textShadow.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))

    runTimer('texty', timerFadeIn)
    setObjectOrder('textShadow', getObjectOrder('texthelp') - 1)
end

function onTimerCompleted(t)
    if t == 'texty' then
        if luaTextExists('texthelp') then
            doTweenAlpha('text', 'texthelp', 1, 1, 'expoin')
            runTimer('fady', timerFadeOut)
        end
    end

    if t == 'fady' then
        if luaTextExists('texthelp') then
            doTweenAlpha('text1', 'texthelp', 0, 0.5, 'expoout')
        end
    end
end