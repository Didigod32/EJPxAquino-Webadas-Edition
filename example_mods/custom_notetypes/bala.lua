function onCreate()
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'bala' then
            setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
        end
    end
end

function goodNoteHit(index, noteData, noteType, isSustainNote)
    if noteType == 'bala' then
		playAnim('boyfriend', 'shoot', true)
		setProperty('boyfriend.specialAnim', true)
    end
end

function opponentNoteHit(index, noteData, noteType, isSustainNote)
    if noteType == 'bala' then
        playAnim('dad', 'shoot', true)
        setProperty('dad.specialAnim', true)
    end
end