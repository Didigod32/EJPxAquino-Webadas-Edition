local floatSpeed = 1.3
local floatAmount = 12

-- POSICIONES BASE
local dadBaseY = 0
local bfBaseY = 0
local gfBaseY = 0

local plat1BaseY = 0
local plat2BaseY = 0
local plat3BaseY = 0

function onCreatePost()

    dadBaseY = getProperty('dad.y')
    bfBaseY = getProperty('boyfriend.y')
    gfBaseY = getProperty('gf.y')

makeAnimatedLuaSprite('c3jocup1', 'c3jocup/c3jo_cuphead_plataforma', 1000, 620) 
setScrollFactor('c3jocup1', 1, 1) scaleObject('c3jocup1', 1.2, 1.2) 
addAnimationByPrefix('c3jocup1', 'idle', 'c3jo cuphead plataforma', 24, true)

 makeAnimatedLuaSprite('c3jocup2', 'c3jocup/c3jo_cuphead_plataforma', 1500, 750) 
 setScrollFactor('c3jocup2', 1, 1) scaleObject('c3jocup2', 1.2, 1.2) 
 addAnimationByPrefix('c3jocup2', 'idle', 'c3jo cuphead plataforma', 24, true) 

 makeAnimatedLuaSprite('c3jocup3', 'c3jocup/c3jo_cuphead_plataforma', 450, 750) 
 setScrollFactor('c3jocup3', 1, 1) scaleObject('c3jocup3', 1.2, 1.2) 
 addAnimationByPrefix('c3jocup3', 'idle', 'c3jo cuphead plataforma', 24, true)
 
    addLuaSprite('c3jocup1', false)
    addLuaSprite('c3jocup2', false)
    addLuaSprite('c3jocup3', false)

    plat1BaseY = getProperty('c3jocup1.y')
    plat2BaseY = getProperty('c3jocup2.y')
    plat3BaseY = getProperty('c3jocup3.y')

end

function onUpdate(elapsed)

    local songTime = getSongPosition() / 500

    ------------------------------------------------
    -- WAVE DE CADA PAREJA
    ------------------------------------------------

    local dadWave =
        math.sin(songTime * floatSpeed + 1)

    local bfWave =
        math.sin((songTime * floatSpeed) + 1)

    local gfWave =
        math.sin((songTime * floatSpeed) + 1)


    setProperty(
        'dad.y',
        dadBaseY + (dadWave * floatAmount - 10)
    )

    setProperty(
        'c3jocup1.y',
        plat1BaseY + (dadWave * floatAmount - 10)
    )


    setProperty(
        'boyfriend.y',
        bfBaseY + (bfWave * floatAmount)
    )

    setProperty(
        'c3jocup2.y',
        plat2BaseY + (bfWave * floatAmount)
    )



    setProperty(
        'gf.y',
        gfBaseY + (gfWave * (floatAmount - 3))
    )

    setProperty(
        'c3jocup3.y',
        plat3BaseY + (gfWave * (floatAmount - 3))
    )

end