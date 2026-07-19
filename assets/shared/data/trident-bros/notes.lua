function onCreate()
    setProperty('skipCountdown', true)
    setPropertyFromClass('states.PlayState', 'isPixelStage', true)
    setProperty('stageUI', 'pixel')
end

function onCreatePost()
    for i = 0, 3 do
        setPropertyFromGroup('playerStrums', i, 'texture', 'noteSkins/NOTE_assetssmb')
        setPropertyFromGroup('opponentStrums', i, 'texture', 'noteSkins/NOTE_assetssmb')
    end
end

function onUpdate()
    if curStep < 1200 then
        for i = 0, getProperty('notes.length')-1 do
            if not getPropertyFromGroup('notes', i, 'mustPress') or getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'texture', 'noteSkins/NOTE_assetssmb')
            end 
        end
    elseif curStep >= 1200 and curStep <= 2288 then
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'texture', 'noteSkins/NOTE_assetssmb3')
            setPropertyFromGroup('opponentStrums', i, 'texture', 'noteSkins/NOTE_assetssmb3')
        end

        for i = 0, getProperty('notes.length')-1 do
            if not getPropertyFromGroup('notes', i, 'mustPress') or getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'texture', 'noteSkins/NOTE_assetssmb3')
            end
        end
    elseif curStep > 2288 then
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'texture', 'noteSkins/NOTE_assets')
            setPropertyFromGroup('opponentStrums', i, 'texture', 'noteSkins/NOTE_assets')
        end

        for i = 0, getProperty('notes.length')-1 do
            if not getPropertyFromGroup('notes', i, 'mustPress') or getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'texture', 'noteSkins/NOTE_assets')
            end
        end
    end
end