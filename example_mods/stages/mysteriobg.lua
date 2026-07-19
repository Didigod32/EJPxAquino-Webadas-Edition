BGS = {'Fondo', 'Rocas_de_fondo', 'Neblina_2', 'Mi_tio_terio', 'Central', 'Cielomysterio', 'De_fondo', 'Cercano', 'Las_vias', 'Neblina', 'misterio'}

function onCreatePost()
	for i = 1, #BGS do
        precacheImage('mysteriobg/'..BGS[i])     
    end

	makeLuaSprite('misterio', 'mysteriobg/misterio', -550, 150);
	setScrollFactor('misterio', 0.9, 0.9)
	setProperty('misterio.antialiasing', false)
	scaleObject('misterio', 1.5, 1.5)
	addLuaSprite('misterio', false)

	makeLuaSprite('Cielomysterio', 'mysteriobg/Cielomysterio', -800, -400)
	setScrollFactor('Cielomysterio', 0.9, 0.9)
    scaleObject('Cielomysterio', 1.1, 1.1)
	addLuaSprite('Cielomysterio', false)
	
	makeLuaSprite('De_fondo', 'mysteriobg/De_fondo', -800, -400)
	setScrollFactor('De_fondo', 0.9, 0.9)
	scaleObject('De_fondo', 1.1, 1.1)
	addLuaSprite('De_fondo', false)

	makeLuaSprite('Cercano', 'mysteriobg/Cercano', -800, -400)
	setScrollFactor('Cercano', 0.9, 0.9)
	scaleObject('Cercano', 1.1, 1.1)
	addLuaSprite('Cercano', false)

	makeLuaSprite('Las_vias', 'mysteriobg/Las_vias', -800, -400)
	setScrollFactor('Las_vias', 0.9, 0.9)
	scaleObject('Las_vias', 1.1, 1.1)
	addLuaSprite('Las_vias', false)

	makeLuaSprite('Neblina', 'mysteriobg/Neblina', -800, -400)
	setScrollFactor('Neblina', 0.9, 0.9)
	scaleObject('Neblina', 1.1, 1.1)
	addLuaSprite('Neblina', false)

	makeLuaSprite('Fondo', 'mysteriobg/Fondo', -600, -400)
	setScrollFactor('Fondo', 0.9, 0.9)
    scaleObject('Fondo', 1.5, 1.5)
	addLuaSprite('Fondo', false)
	
	makeLuaSprite('Rocas_de_fondo', 'mysteriobg/Rocas_de_fondo', -600, 0)
	setScrollFactor('Rocas_de_fondo', 0.9, 0.9)
	scaleObject('Rocas_de_fondo', 1.5, 1.5)
	addLuaSprite('Rocas_de_fondo', false)
	
    makeLuaSprite('Neblina_2', 'mysteriobg/Neblina_2', -600, 200)
	setScrollFactor('Neblina_2', 0.9, 0.9)
	scaleObject('Neblina_2', 1.5, 1.5)
	addLuaSprite('Neblina_2', false)

    makeLuaSprite('Mi_tio_terio', 'mysteriobg/Mi_tio_terio', -500, -100)
	setScrollFactor('Mi_tio_terio', 0.9, 0.9)
	scaleObject('Mi_tio_terio', 1.5, 1.5)
	addLuaSprite('Mi_tio_terio', false)

    makeLuaSprite('Central', 'mysteriobg/Central', -550, 150);
	setScrollFactor('Central', 0.9, 0.9)
	setObjectOrder('Central', getObjectOrder('dadGroup') + 1)
	scaleObject('Central', 1.5, 1.5)
	addLuaSprite('Central', false)

    makeLuaSprite('filtro', 'mysteriobg/filtro', 0, 0)
	screenCenter('filtro')
	setGraphicSize('filtro', getProperty('filtro.width') / getProperty('defaultCamZoom'))
	setObjectCamera('filtro', 'other')
    addLuaSprite('filtro', true)

	makeLuaSprite('misterio', 'mysteriobg/misterio', -1200, -1000)
	setProperty('misterio.antialiasing', false)
	scaleObject('misterio', 3, 3)
	addLuaSprite('misterio')

	for i = 1, #BGS do
		setProperty(BGS[i]..'.alpha', 0.001)
	end

	stageChange(1)
end

function stageChange(c)
	if c == 0 then -- Stage del tren
		for i = 6, 9 do
			setProperty(BGS[i]..'.alpha', 1)
		end
		for i = 1, 5 do
			setProperty(BGS[i]..'.alpha', 0.001)
		end
		setProperty('misterio.alpha', 0.001)
		setProperty('filtro.alpha', 0.001)

        setProperty('dad.x', -230)
        setProperty('dad.y', 40)

        setProperty('boyfriend.x', 500)
        setProperty('boyfriend.y', 80)
		setProperty('defaultCamZoom', 0.7)
		cameraSetTarget(mustHitSection and 'dad' or 'boyfriend')
    end

    if c == 1 then -- Stage de las rocas
		for i = 1, 5 do
			setProperty(BGS[i]..'.alpha', 1)
		end

		for i = 6, 11 do
			setProperty(BGS[i]..'.alpha', 0.001)
		end
		setProperty('filtro.alpha', 1)

        setProperty('dad.x', 100)
        setProperty('dad.y', -150)
        setProperty('boyfriend.x', 260)
        setProperty('boyfriend.y', 480)
		cameraSetTarget(mustHitSection and 'boyfriend' or 'dad')
    end

	if c == 2 then -- Stage de Minecraft
		for i = 1, 10 do
			setProperty(BGS[i]..'.alpha', 0)
		end

		setProperty('misterio.alpha', 1)
		setProperty('filtro.alpha', 0.001)
		setProperty('defaultCamZoom', 0.5)

		setProperty('dad.x', 100)
        setProperty('dad.y', -100)
        setProperty('boyfriend.x', 260)
        setProperty('boyfriend.y', 300)
		cameraSetTarget(mustHitSection and 'dad' or 'boyfriend')
	end
end

function onEvent(n, v1, v2)
	if n == 'Misterio Events' then
		if v1 == 'stg' then
			if v2 == '0' then
				stageChange(0)
			end
			if v2 == '1' then
				stageChange(1)
			end
			if v2 == '2' then
				stageChange(2)
			end
		end
	end
end