function onCreate()
    makeLuaSprite('0', 'hollow/0', -540, -820)
    addLuaSprite('0')

    makeLuaSprite('1', 'hollow/1', 520, -550)
    setScrollFactor('1', 1.1, 0.9)
    addLuaSprite('1')

    makeLuaSprite('2', 'hollow/2', -170, -450)
    setScrollFactor('1', 0.9, 0.9)
    addLuaSprite('2')

    makeLuaSprite('3', 'hollow/3', -520, 0)
    setScrollFactor('3', 1.05, 1.05)
    addLuaSprite('3')

    makeLuaSprite('4', 'hollow/4', -480, 100)
    setScrollFactor('4', 1.02, 1.02)
    addLuaSprite('4')

    makeLuaSprite('5', 'hollow/5', 120, -340)
    setScrollFactor('5', 1.02, 1.02)
    addLuaSprite('5')

    makeLuaSprite('6', 'hollow/6', -540, 350)
    setScrollFactor('6', 1.04, 1.04)
    addLuaSprite('6')

    makeLuaSprite('7', 'hollow/7', -520, 50)
    addLuaSprite('7')

    makeLuaSprite('8', 'hollow/8', -540, 650)
    setScrollFactor('8', 1.1, 0.9)
    addLuaSprite('8', true)

    makeLuaSprite('11', 'hollow/11', -540, 650)
    setScrollFactor('11', 1.1, 0.9)
    addLuaSprite('11', true)
    setProperty('11.visible', false)

    makeLuaSprite('9', 'hollow/9', -540, 720)
    setScrollFactor('9', 1.1, 0.9)
    addLuaSprite('9', true)

    makeLuaSprite('10', 'hollow/10', -540, -820)
    setBlendMode('10', 'add')
    setScrollFactor('10', 1.1, 1.1)
    addLuaSprite('10', true)
end