--Script by NeoMetalSonic
--pls dknt steal :(

local stepCount = 30
local am = 0
local isMini = false

local sx, sy, tx, ty
local wSX, hSX, wTX, hTX
local baseW, baseH

local screenW = getPropertyFromClass('openfl.system.Capabilities','screenResolutionX')
local screenH = getPropertyFromClass('openfl.system.Capabilities','screenResolutionY')

function getBoundW()
    local v = getPropertyFromClass('openfl.Lib','application.window.display.bounds.width')
    return (v ~= nil and v > 0) and v or screenW
end

function getBoundH()
    local v = getPropertyFromClass('openfl.Lib','application.window.display.bounds.height')
    return (v ~= nil and v > 0) and v or screenH
end

function onCreate()
    addHaxeLibrary('Lib','openfl')
end

function onEvent(name, value1, value2)
    if name ~= 'WindowMove' then return end
    am = tonumber(value1) or 0

    if value2 == 'Mini' then
        if isMini then return end
        isMini = true
        setFullscreen(false)
        setBorderless(true)
        forceMini(0.25)
        runTimer('miniDone', 0.26)
        runTimer('startShake', 0.3)
        return
    end

    if value2 == 'Windowed' then
        setFullscreen(false)
        setBorderless(false)
        if isMini then
            restoreWindow(0.25)
            isMini = false
        end
        windowedTween(0.35)
        runTimer('startShake', 0.3)
        return
    end

    startShake()
end

function onTimerCompleted(tag)
    if tag == 'startShake' then
        startShake()
        return
    end

    local i = tonumber(tag:match('%d+'))
    if not i then return end
    local e = expoOut(i / stepCount)

    if tag:sub(1,9) == 'sizeTween' then
        setPropertyFromClass('openfl.Lib','application.window.width',  lerp(wSX, wTX, e))
        setPropertyFromClass('openfl.Lib','application.window.height', lerp(hSX, hTX, e))
        return
    end

    if tag:sub(1,10) == 'moveWindow' then
        local bw, bh = getBoundW(), getBoundH()
        local ww = getPropertyFromClass('openfl.Lib','application.window.width')
        local hh = getPropertyFromClass('openfl.Lib','application.window.height')

        setPropertyFromClass('openfl.Lib','application.window.x',
            clamp(lerp(sx, tx, e), 0, bw - ww))
        setPropertyFromClass('openfl.Lib','application.window.y',
            clamp(lerp(sy, ty, e), 0, bh - hh))
        return
    end

    if tag:sub(1,8) == 'winTween' then
        local bw, bh = getBoundW(), getBoundH()
        local cw = lerp(wSX, wTX, e)
        local ch = lerp(hSX, hTX, e)

        setPropertyFromClass('openfl.Lib','application.window.width', cw)
        setPropertyFromClass('openfl.Lib','application.window.height', ch)
        setPropertyFromClass('openfl.Lib','application.window.x',
            clamp(lerp(sx, tx, e), 0, bw - cw))
        setPropertyFromClass('openfl.Lib','application.window.y',
            clamp(lerp(sy, ty, e), 0, bh - ch))
        return
    end
end

function startShake()
    local bw, bh = getBoundW(), getBoundH()

    sx = getPropertyFromClass('openfl.Lib','application.window.x')
    sy = getPropertyFromClass('openfl.Lib','application.window.y')

    local ww = getPropertyFromClass('openfl.Lib','application.window.width')
    local hh = getPropertyFromClass('openfl.Lib','application.window.height')

    tx = clamp(sx + getRandomInt(-am*2, am*2), 0, bw - ww)
    ty = clamp(sy + getRandomInt(-am, am), 0, bh - hh)

    local t = 0.2 / stepCount
    for i = 1, stepCount do
        runTimer('moveWindow'..i, t*i)
    end
end

function windowedTween(time)
    local bw, bh = getBoundW(), getBoundH()

    wSX = getPropertyFromClass('openfl.Lib','application.window.width')
    hSX = getPropertyFromClass('openfl.Lib','application.window.height')
    sx = getPropertyFromClass('openfl.Lib','application.window.x')
    sy = getPropertyFromClass('openfl.Lib','application.window.y')

    wTX = baseW or wSX
    hTX = baseH or hSX

    tx = (bw - wTX) * 0.5
    ty = (bh - hTX) * 0.5

    local t = time / stepCount
    for i = 1, stepCount do
        runTimer('winTween'..i, t*i)
    end
end

function forceMini(time)
    baseW = getPropertyFromClass('openfl.Lib','application.window.width')
    baseH = getPropertyFromClass('openfl.Lib','application.window.height')

    wSX, hSX = baseW, baseH
    wTX, hTX = baseW * 0.65, baseH * 0.65

    sizeTween(time)
end

function restoreWindow(time)
    wSX = getPropertyFromClass('openfl.Lib','application.window.width')
    hSX = getPropertyFromClass('openfl.Lib','application.window.height')

    wTX, hTX = baseW, baseH
    sizeTween(time)
end

function sizeTween(time)
    local t = time / stepCount
    for i = 1, stepCount do
        runTimer('sizeTween'..i, t*i)
    end
end

function setFullscreen(v)
    setPropertyFromClass('openfl.Lib','application.window.fullscreen', v)
end

function setBorderless(v)
    setPropertyFromClass('openfl.Lib','application.window.borderless', v)
end

function expoOut(t)
    if t >= 1 then return 1 end
    return 1 - math.pow(2, -10 * t)
end

function lerp(a,b,t)
    return a + (b - a) * t
end

function clamp(v,min,max)
    return math.max(min, math.min(max, v))
end
