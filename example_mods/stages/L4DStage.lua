function onCreate()
    posX = -200
    posY = -400

    makeLuaSprite('bg', 'freeplay_weeks/l4dStage/Fondo', posX, posY)
    scaleObject('bg', 1, 0.8)
    addLuaSprite('bg')

    makeLuaSprite('tunel1', 'freeplay_weeks/l4dStage/Tunel1', posX, posY)
    scaleObject('tunel1', 1, 0.8)
    addLuaSprite('tunel1')

    makeLuaSprite('tunel2', 'freeplay_weeks/l4dStage/Tunel2', posX, posY)
    scaleObject('tunel2', 1, 0.8)
    addLuaSprite('tunel2',true)

    makeLuaSprite('luz', 'freeplay_weeks/l4dStage/Luz100', posX, posY)
    scaleObject('luz', 1, 0.8)
    setBlendMode('luz', 'add')
    setProperty('luz.alpha', 0.2)
    addLuaSprite('luz', true)

    function onCreatePost()
        setProperty('gf.alpha', 0.001)
    end
end