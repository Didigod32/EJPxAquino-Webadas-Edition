function onCreate()
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

	setProperty('Fondo.visible', false)
	setProperty('Rocas_de_fondo.visible', false)
	setProperty('Neblina_2.visible', false)
	setProperty('Mi_tio_terio.visible', false)
	setProperty('Central.visible', false)
	setProperty('filtro.visible', false)
end