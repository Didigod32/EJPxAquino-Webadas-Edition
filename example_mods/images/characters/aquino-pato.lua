function onCreate()
	setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'aquino-pato-dead')
end

function onGameOverStart()
	setProperty('camFollow.x', getProperty('boyfriend.x') - 460)
end