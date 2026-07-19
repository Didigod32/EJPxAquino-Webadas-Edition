function onCreatePost()
	if boyfriendName == 'tobey2002' then
		setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'tobey2002-dead')
		setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-micless-Aquino')
	end
end

function onEvent(n,v1,v2)
	if n == 'Change Character' then
		if v1 == 'bf' then
			if v2 == 'tobey2002' then
				setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'tobey2002-dead')
                setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-micless-Aquino')
			end
		end
	end
end

function onGameOverStart()
	if boyfriendName == 'tobey2002' then
		setProperty('camFollow.x', getProperty('boyfriend.x') + 500)
		setProperty('camFollow.y', getProperty('boyfriend.y') + 350)
	end
end