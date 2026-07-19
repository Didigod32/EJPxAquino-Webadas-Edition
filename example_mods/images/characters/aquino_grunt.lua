function onCreatePost()
	if boyfriendName == 'aquino_grunt' then
        setPropertyFromClass('GameOverSubstate', 'characterName', 'aquino_grunt-dead')
        setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'grunt dead')
    end
end

function onEvent(n,v1,v2)
	if n == 'Change Character' then
		if v1 == 'bf' then
			if v2 == 'aquino_grunt' then
				setPropertyFromClass('GameOverSubstate', 'characterName', 'aquino_grunt-dead')
				setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'grunt dead')
			end
		end
	end
end

function onGameOverStart()
	setProperty('camFollow.x', getProperty('boyfriend.x') + 700)
	setProperty('camFollow.y', getProperty('boyfriend.y') + 480)
end