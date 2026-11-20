function onCreatePost()
    makeLuaSprite('sky', 'freeplay_weeks/lima/limasky', -300, -220)
    setScrollFactor('sky', 0.6, 0.6)
    scaleObject('sky', 1.4, 1.4)

    makeLuaSprite('cruces', 'freeplay_weeks/lima/limacruces', -50, 0)
    setScrollFactor('cruces', 0.7, 0.7)
    scaleObject('cruces', 1.2, 1.2)

    makeLuaSprite('city', 'freeplay_weeks/lima/limacity', 0, -20)
    setScrollFactor('city', 0.8, 0.8)
    scaleObject('city', 1.25, 1.25)

    makeLuaSprite('edificio', 'freeplay_weeks/lima/limaedificio', -50, -20)
    setScrollFactor('edificio', 0.9, 0.9)
    scaleObject('edificio', 1.3, 1.3)

    makeLuaSprite('torre', 'freeplay_weeks/lima/limatorre', 0, 0)
    setScrollFactor('torre', 1, 1)
    scaleObject('torre', 1.4, 1.4)

    addLuaSprite('sky', false)
    addLuaSprite('cruces', false)
    addLuaSprite('city', false)
    addLuaSprite('edificio', false)
    addLuaSprite('torre', false)
end