function onCreate()
	makeLuaSprite('Salon', 'patos/Salon', -330, -150);
	scaleObject('Salon', 5.7, 5.7);
	setProperty('Salon.antialiasing',false)
	addLuaSprite('Salon', false);

	setProperty('cameraSpeed', 99)
end

function onSongStart()
	setProperty('cameraSpeed', 1)
end