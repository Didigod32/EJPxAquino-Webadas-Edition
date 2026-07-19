function onCreatePost()
    makeLuaSprite('grunt2', 'gruntbg/grunt2', -420, -210)
    setScrollFactor('grunt2', 1, 1)
    scaleObject('grunt2', 1.7, 1.7)
    addLuaSprite('grunt2', false)
    
    makeLuaSprite('grunt4', 'gruntbg/grunt4', 0, 100)
    setScrollFactor('grunt4', 1, 1)
    scaleObject('grunt4', 1.3, 1.3)
    addLuaSprite('grunt4', false)
    
    makeLuaSprite('grunt3', 'gruntbg/grunt3', 475, -210)
    setScrollFactor('grunt3', 0.75, 0.75)
    scaleObject('grunt3', 1.25, 1.25)
    addLuaSprite('grunt3', true)

    makeLuaSprite('grunt1', 'gruntbg/grunt1', -600, -210)
    setScrollFactor('grunt1', 0.75, 0.75)
    scaleObject('grunt1', 1.3, 1.3)
    addLuaSprite('grunt1', true)
end