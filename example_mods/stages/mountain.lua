function onCreatePost()
    makeLuaSprite('bg', 'hypothermia/bg', 0, 0)
    setScrollFactor('bg', 1, 1)
    scaleObject('bg', 1, 1)
    addLuaSprite('bg', false)

    makeLuaSprite('nimu', 'hypothermia/nimu', 0, 200)
    setScrollFactor('nimu', 1, 1)
    scaleObject('nimu', 1, 1)
    addLuaSprite('nimu', false)

    makeLuaSprite('kendo', 'hypothermia/kendo', 200, 300)
    setScrollFactor('kendo', 1, 1)
    scaleObject('kendo', 1, 1)
    addLuaSprite('kendo', false)

    makeLuaSprite('loco', 'hypothermia/loco', 200, 100)
    setScrollFactor('loco', 1, 1)
    scaleObject('loco', 1, 1)
    addLuaSprite('loco', false)

    makeAnimatedLuaSprite('aquino_ha_muerto', 'aquino_ha_muerto', 300, 310)
    addAnimationByPrefix('aquino_ha_muerto', 'idle', 'letsgo', 24, false)
    scaleObject('aquino_ha_muerto', 2, 2)
    setProperty('aquino_ha_muerto.visible', false)
    addLuaSprite('aquino_ha_muerto', true)
end

function onBeatHit()
    if curBeat % 2 == 0 then
		playAnim('myCustomSprite', 'anim')
	end

    if curBeat == 197 then 
        setProperty('aquino_ha_muerto.visible', true)
        playAnim('aquino_ha_muerto', 'idle', true)
    end    
    if curBeat == 203 then 
        cameraFlash('game', 'FFFFFF', 1, false)
    end    
    if curBeat == 203 then 
        setProperty('aquino_ha_muerto.visible', false)
    end    
end