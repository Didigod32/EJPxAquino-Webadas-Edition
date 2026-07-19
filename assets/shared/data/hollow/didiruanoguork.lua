things = {'scoreTxt', 'timeTxt', 'timeBar', 'timeBarBG', 'healthBar', 'healthBarBG', 'iconP1', 'iconP2',}

function onCreatePost()
	makeLuaSprite('b', nil, -100, -100)
	makeGraphic('b', 2000, 2000, '000000')
	addLuaSprite('b', true)
	setObjectCamera('b', 'other')
	doTweenAlpha('b', 'b', 0, 12, 'cubeInOut')

	for i = 1, #things do
		setProperty(tostring(things[i])..'.visible', false)
	end
end

function onUpdatePost()
	Particle()
end

function onStepHit()
	if curStep == 47 then   
		for i = 0, 7 do
			setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
		end

		for i = 1, #things do
			setProperty(tostring(things[i])..'.visible', false)
		end
	end 

	if curStep == 144 then   
		for i = 0, 7 do
			setPropertyFromGroup('strumLineNotes', i, 'alpha', 1)
		end

		for i = 1, #things do
			setProperty(tostring(things[i])..'.visible', true)
		end
	end

	if curStep == 1290 then
		setProperty('11.visible', true)
		setProperty('8.visible', false)
	end

	if curStep == 1312 then   
		cameraFlash('hud', '000000', 36)

		for i = 1, #things do
			setProperty(tostring(things[i])..'.visible', false)
		end
	end

	if curStep  == 1545 then   
		setProperty('boyfriend.alpha', 0.9);
		setProperty('dad.alpha', 0.9);
	  end
	  if curStep  == 1546 then   
		setProperty('boyfriend.alpha', 0.8);
		setProperty('dad.alpha', 0.8);
	 end
	  if curStep  == 1547 then   
	   setProperty('boyfriend.alpha', 0.7);
	   setProperty('dad.alpha', 0.7);
	 end
	 if curStep  == 1548 then   
	  setProperty('boyfriend.alpha', 0.6);
	  setProperty('dad.alpha', 0.6);
	end
	if curStep  == 1549 then   
	  setProperty('boyfriend.alpha', 0.5);
	  setProperty('dad.alpha', 0.5);
	end
	if curStep  == 1550 then   
	  setProperty('boyfriend.alpha', 0.4);
	  setProperty('dad.alpha', 0.4);
	end
	if curStep  == 1551 then   
	  setProperty('boyfriend.alpha', 0.2);
	  setProperty('dad.alpha', 0.2);
	end
	if curStep  == 1552 then   
	  setProperty('boyfriend.alpha', 0.1);
	  setProperty('dad.alpha', 0.1);
	end
	if curStep  == 1553 then   
	  setProperty('boyfriend.alpha', 0.1);
	  setProperty('dad.alpha', 0.1);
	end
	if curStep  == 1554 then   
	  setProperty('boyfriend.alpha', 0);
	  setProperty('dad.alpha', 0);
	end
end

function Particle()
	songPos = getSongPosition()
	currentBeat = (songPos/500)
	f = f + 1
	sus = math.random(2, 1500)
	sus2 = math.random(2, 1500)

	makeLuaSprite('escroto' .. f, 'backgrounds/hollow/particles', math.random(500, 2000), 1600)
	doTweenY(sus, 'escroto' .. f, -900*math.tan((currentBeat+1*0.1)*math.pi), 6)
	doTweenX(sus2, 'escroto' .. f, -900*math.sin((currentBeat+1*0.1)*math.pi), 6)
	scaleObject('escroto' .. f, 0.5, 0.5);
	addLuaSprite('escroto' .. f, true)

	if f >= 50 then
		f = 1
	end
end