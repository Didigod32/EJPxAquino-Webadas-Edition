function onCreate()
    makeLuaSprite('bg', 'majotoriBG/majoBG', -100, -280)
    scaleObject('bg', 0.85, 0.85)
    addLuaSprite('bg')

    -- Camera pos reasons
    function onCreatePost()
        setProperty('gf.visible', false)
    end
end