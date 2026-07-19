function onCreatePost()
	if boyfriendName == 'aquino-mc' then
        setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'aquino-mc-dead')
        setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', nil)
    end
end

function onEvent(n,v1,v2)
	if n == 'Change Character' then
		if v1 == 'bf' then
			if v2 == 'aquino-mc' then
                setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'aquino-mc-dead')
                setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', nil)
			end
		end
	end
end

function onGameOverStart()
    playSound('mc/hit'..getRandomInt(1, 3), 1)
    playSound('mc/sweep'..getRandomInt(1, 7), 1)
end