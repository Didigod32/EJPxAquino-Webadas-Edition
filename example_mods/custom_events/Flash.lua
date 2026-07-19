function onEvent(name, value1, value2)
	color = tonumber(value1)
	tween = tonumber(value2)
	if name == "Flash" then
		if color == 0 then
			cameraFlash('hud', 'FFFFFF', tween, false)
		end
		if color == null then
			cameraFlash('hud', 'FFFFFF', tween, false)
		end
		if color == 1 then
			cameraFlash('hud', 'FF0000', tween, false)
		end
		if color == 2 then
			cameraFlash('hud', '00FF00', tween, false)
		end
		if color == 3 then
			cameraFlash('hud', '0000FF', tween, false)
		end
		if color == 4 then
			cameraFlash('hud', 'FFFF00', tween, false)
		end
		if color == 5 then
			cameraFlash('hud', 'FF00FF', tween, false)
		end
		if color == 6 then
			cameraFlash('hud', '00FFFF', tween, false)
		end	
		if color == 7 then
			cameraFlash('hud', '000000 ', tween, false)
		end
	end
end