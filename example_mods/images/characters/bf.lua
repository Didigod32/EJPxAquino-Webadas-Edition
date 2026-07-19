function onCreatePost()
	if boyfriendName == 'bf' then
		setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'bf-dead')
		setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx')
		setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOver-base')
		setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEnd-base')
	end
end

function onEvent(n,v1,v2)
	if n == 'Change Character' then
		if v1 == 'bf' then
			if v2 == 'bf' then
				setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'bf-dead')
                setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx')
                setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOver-base')
                setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEnd-base')
			end
		end
	end
end