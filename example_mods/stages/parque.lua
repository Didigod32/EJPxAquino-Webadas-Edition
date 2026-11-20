function onCreate()
    makeLuaSprite('1', 'main_weeks/parque/1', -900, -900)
    scaleObject('1', 1.2, 1.2)
    addLuaSprite('1')

    makeLuaSprite('2', 'main_weeks/parque/2', -900, -880)
    scaleObject('2', 1.2, 1.2)
    setScrollFactor('2', 1.05, 1)
    addLuaSprite('2')

    makeLuaSprite('3', 'main_weeks/parque/3', -900, -300)
    scaleObject('3', 1.2, 1.2)
    setScrollFactor('3', 1.08, 1)
    addLuaSprite('3')

    makeLuaSprite('4', 'main_weeks/parque/4', -800, -710)
    scaleObject('4', 1.2, 1.2)
    setScrollFactor('3', 1.1, 1)
    addLuaSprite('4')

    makeLuaSprite('5', 'main_weeks/parque/5', -900, -600)
    scaleObject('5', 1.2, 1.2)
    addLuaSprite('5')

    makeLuaSprite('6', 'main_weeks/parque/6', -110, 300)
    scaleObject('6', 1.2, 1.2)
    addLuaSprite('6')

    makeLuaSprite('bot', 'bot', 150, 20)
    scaleObject('bot', 0.7, 0.7)
    addLuaSprite('bot', false)

end