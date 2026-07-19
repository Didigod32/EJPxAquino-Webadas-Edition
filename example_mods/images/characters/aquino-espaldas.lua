function onCreatePost()
    if boyfriendName == 'aquino-espaldas' then
        setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'aquino-espaldas')
		setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-micless-Aquino')
    end
end

function onEvent(n,v1,v2)
	if n == 'Change Character' then
		if v1 == 'bf' then
			if v2 == 'aquino-espaldas' then
				setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'aquino-espaldas')
			else
				setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'aquino-espaldas')
			end
		end
	end
end