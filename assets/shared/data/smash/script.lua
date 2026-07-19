function onCreatePost()
    makeAnimatedLuaSprite('ready_wallop', 'c3jocup/ready_wallop', 0, 0)
    setGraphicSize('ready_wallop', getProperty('ready_wallop.width') / getProperty('defaultCamZoom'))
    setObjectCamera('ready_wallop', 'other')
    scaleObject('ready_wallop', 0.9, 0.9)
    screenCenter('ready_wallop')
    addAnimationByIndices('ready_wallop', 'ready', 'Ready? WALLOP!',"0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40", 24, false); 
    addAnimationByIndices('ready_wallop', 'wallop', 'Ready? WALLOP!',"58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92", 24, false); 
    addLuaSprite('ready_wallop')
    setProperty('ready_wallop.visible', false)

    makeAnimatedLuaSprite('knock', 'c3jocup/knock', 0, 0)
    setGraphicSize('knock', getProperty('knock.width') / getProperty('defaultCamZoom'))
    setObjectCamera('knock', 'other')
    scaleObject('knock', 0.9, 0.9)
    screenCenter('knock')
    addAnimationByPrefix('knock', 'KnockOut!', 'A KNOCKOUT!', 24, false)
    addLuaSprite('knock')
    setProperty('knock.visible', false)
end

function onStepHit()
    if curStep == 9 then
        setProperty('ready_wallop.visible', true)
        playAnim('ready_wallop', 'ready')
    elseif curStep == 86 then
        playAnim('ready_wallop', 'wallop')
    elseif curStep == 90 then
        removeLuaSprite('ready_wallop', true)
    elseif curStep == 1454 then
        playAnim('knock', 'wallop')
        setProperty('knock.visible', true)
    elseif curStep == 1472 then
        doTweenAlpha('sis', 'knock', 0, 1, 'smoothStepOut')
    end
end