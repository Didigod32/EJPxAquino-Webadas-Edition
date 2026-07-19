local smb1Stuff = {'SMB1Piso', 'SMB1enemigos'}
local smbwStuff = {'SMBWBG', 'SMBWPiso', 'SMWTuneles', 'SMWbloques', 'SMWGoomba', 'SMWKoopa'}

function onCreate()	
	makeLuaSprite('SMB1Piso', 'mario-maker/smb1/suelosmb', -330, -150)
	scaleObject('SMB1Piso', 5.7, 5.7)
	setProperty('SMB1Piso.antialiasing', false)
	addLuaSprite('SMB1Piso', true)

	makeAnimatedLuaSprite('SMB1enemigos', 'mario-maker/smb1/enemigosmb', -330, -150)
	scaleObject('SMB1enemigos', 5.7, 5.7)
	addAnimationByPrefix('SMB1enemigos','idle','enemigos', 20, true)
	setProperty('SMB1enemigos.antialiasing', false)
	addLuaSprite('SMB1enemigos', true)
	
	makeLuaSprite('SMBWBG', 'mario-maker/smw/bg', -330, -500)
	scaleObject('SMBWBG', 5.7, 5.7)
	setProperty('SMBWBG.antialiasing', false)
	setProperty('SMBWBG.alpha', 0)
	addLuaSprite('SMBWBG')

	makeLuaSprite('SMBWPiso', 'mario-maker/smw/piso', -330, -500)
	scaleObject('SMBWPiso', 5.7, 5.7)
	setProperty('SMBWPiso.antialiasing', false)
	addLuaSprite('SMBWPiso')

	makeAnimatedLuaSprite('SMWTuneles', 'mario-maker/smw/Tuneles', -330, -500)
	addAnimationByPrefix('SMWTuneles', 'idle', 'Tuneles', 12)
	scaleObject('SMWTuneles', 5.7, 5.7)
	setProperty('SMWTuneles.antialiasing', false)
	addLuaSprite('SMWTuneles')

	makeAnimatedLuaSprite('SMWbloques', 'mario-maker/smw/bloques', -330, -500)
	addAnimationByPrefix('SMWbloques', 'idle', 'bloques', 12)
	scaleObject('SMWbloques', 5.7, 5.7)
	setProperty('SMWbloques.antialiasing', false)
	addLuaSprite('SMWbloques')

	makeAnimatedLuaSprite('SMWGoomba', 'mario-maker/smw/Goomba', -380, 412)
	addAnimationByPrefix('SMWGoomba', 'idle', 'Goomba', 12)
	scaleObject('SMWGoomba', 5.7, 5.7)
	setProperty('SMWGoomba.velocity.x', 60)
	setProperty('SMWGoomba.antialiasing', false)
	addLuaSprite('SMWGoomba')

	makeAnimatedLuaSprite('SMWKoopa', 'mario-maker/smw/Koopa', 1800, 322)
	addAnimationByPrefix('SMWKoopa', 'idle', 'Koopa', 12)
	scaleObject('SMWKoopa', 5.7, 5.7)
	setProperty('SMWKoopa.velocity.x', -60)
	setProperty('SMWKoopa.antialiasing', false)
	addLuaSprite('SMWKoopa')

	for i = 1, #smbwStuff do 
		setProperty(smbwStuff[i]..'.alpha', 0)
	end
end

function onUpdate()
	if getProperty('SMWKoopa.x') <= 1404.18 then
		setProperty('SMWKoopa.flipX', true)
		setProperty('SMWKoopa.velocity.x', 60)
	end

	if getProperty('SMWKoopa.x') >= 1964.18 then
		setProperty('SMWKoopa.flipX', false)
		setProperty('SMWKoopa.velocity.x', -60)
	end

	if getProperty('SMWGoomba.x') >= -52.18 then
		setProperty('SMWGoomba.flipX', true)
		setProperty('SMWGoomba.velocity.x', -60)
	end

	if getProperty('SMWGoomba.x') <= -684.18 then
		setProperty('SMWGoomba.flipX', false)
		setProperty('SMWGoomba.velocity.x', 60)
	end
end

function onEvent(n, v1)
	if n == 'MM Change' then
		if v1 == 'smb3' then
			setCharacterX('dad', -50)
			setCharacterY('dad', -508)
			setCharacterX('boyfriend', 800)
			setCharacterY('boyfriend', getCharacterY('dad') - 20)

			for i = 1, #smb1Stuff do 
				setProperty(smb1Stuff[i]..'.alpha', 0)
				removeLuaSprite(smb1Stuff[i], true)
			end
			setProperty('defaultCamZoom', 0.7)
		end

		if v1 == 'smw' then
			setProperty('smb3BG.alpha', 0)
			setCharacterX('dad', 300)
			setCharacterY('dad', -443)
			setCharacterX('boyfriend', 850)
			setCharacterY('boyfriend', -443)
			setProperty('defaultCamZoom', 0.58)

			for i = 1, #smbwStuff do 
				setProperty(smbwStuff[i]..'.alpha', 1)
			end
		end
	end
end

function onCreatePost()
	setProperty('gf.visible', false)	
end