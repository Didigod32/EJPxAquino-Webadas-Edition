function onCreatePost()
    makeLuaSprite('black', 'black', 0, 0)
    makeGraphic('black', 2000, 1000, '000000')
    setScrollFactor('black', 0, 0)
    setObjectCamera('black', 'other')
end
function onEvent(name, value1, value2)
    if name == 'Black' then
        lmao = tonumber(value1)
        if lmao == 1 then
            addLuaSprite('black', true)
        end
        if lmao == 0 then
            removeLuaSprite('black', false)
        end
        if lmao == null then
            removeLuaSprite('black', false)
        end
    end
end