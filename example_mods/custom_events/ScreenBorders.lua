function onCreatePost()

	makeLuaSprite('bar1', nil, 0, -100);
	makeGraphic('bar1', 2000, 100, '000000');
	setScrollFactor('bar1', 0, 0);
	setObjectCamera('bar1', 'hud');
	addLuaSprite('bar1', true);
	screenCenter('bar1', 'x');

	makeLuaSprite('bar2', nil, 0, 720);
	makeGraphic('bar2', 2000, 100, '000000');
	setScrollFactor('bar2', 0, 0);
	setObjectCamera('bar2', 'hud');
	addLuaSprite('bar2', true);
	screenCenter('bar2', 'x');

	setObjectOrder('bar1', getObjectOrder('timeBar')-1);
	setObjectOrder('bar2', getObjectOrder('timeBar')-1);
end
function onEvent(name, value1, value2)
	if name == 'ScreenBorders' then
		switch = tonumber(value1)
		duration = tonumber(value2)
		if switch == 1 then
			doTweenY('tween1', 'bar1', 0, duration, 'cubeOut');
			doTweenY('tween2', 'bar2', 620, duration, 'cubeOut');
			if duration == 0 then
				setProperty('bar1.y', 0)
				setProperty('bar2.y', 620)
			elseif duration == null then
				doTweenY('tween1', 'bar1', 0, 1, 'cubeOut');
				doTweenY('tween2', 'bar2', 620, 1, 'cubeOut');
			end
		elseif switch == 0 then
			doTweenY('tween1', 'bar1', -100, duration, 'cubeIn');
			doTweenY('tween2', 'bar2', 720, duration, 'cubeIn');
			if duration == 0 then
				setProperty('bar1.y', -100)
				setProperty('bar2.y', 720)
			elseif duration == null then
				doTweenY('tween1', 'bar1', -100, 1, 'cubeIn');
				doTweenY('tween2', 'bar2', 720, 1, 'cubeIn')
			end
		elseif switch == null then
			doTweenY('tween1', 'bar1', -100, duration, 'cubeIn');
			doTweenY('tween2', 'bar2', 720, duration, 'cubeIn');
			if duration == 0 then
				setProperty('bar1.y', -100)
				setProperty('bar2.y', 720)
			elseif duration == null then
				doTweenY('tween1', 'bar1', -100, 1, 'cubeIn');
				doTweenY('tween2', 'bar2', 720, 1, 'cubeIn')
			end
		end
	end
end