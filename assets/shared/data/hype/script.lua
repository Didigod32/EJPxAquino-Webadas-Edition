function onCreatePost()
	makeLuaSprite('blackbg', '', screenWidth * -0.5, screenHeight * -0.5)
	makeGraphic('blackbg', screenWidth * 2, screenHeight * 2, '000000')
	setScrollFactor('blackbg', 0)
    setProperty('blackbg.alpha', 0.8)
	addLuaSprite('blackbg', true)
	
    makeLuaSprite('light1', 'spotlight', 400, -100)
    setProperty('light1.alpha', 0)
    setBlendMode('light1', 'add')
    addLuaSprite('light1', true)

    makeLuaSprite('light2', 'spotlight', 400, -100)
    setProperty('light2.alpha', 0)
    setBlendMode('light2', 'add')
    addLuaSprite('light2', true)

    setProperty('light1.x', getMidpointX('dadGroup') - getProperty('light1.width') / 2.4)
    setProperty('light2.x', getMidpointX('boyfriendGroup') - getProperty('light2.width') / 2)
end

function onStepHit()
    if curStep == 96 then
        setProperty('light1.alpha', 0.375)
        setProperty('light2.alpha', 0.375)
    elseif curStep == 128 then
        removeLuaSprite('blackbg', true)
        removeLuaSprite('light1', true)
        removeLuaSprite('light2', true)
    end
end