function onCreate()
	makeLuaSprite('fondo_nobbly', 'backgrounds/callejon/fondo_nobbly', -1150, -350);
	setLuaSpriteScrollFactor('fondo_nobbly', 1, 1);
	scaleObject('fondo_nobbly', 1.6, 1.5);

	makeLuaSprite('hombrecito', 'backgrounds/callejon/hombrecito', -1150,-350);
	setLuaSpriteScrollFactor('hombrecito', 1, 1);
	scaleObject('hombrecito', 1.5, 1.5);

	makeLuaSprite('farol', 'backgrounds/callejon/farol', -700, -350);
	setLuaSpriteScrollFactor('farol', 0.9, 0.9);
	scaleObject('farol', 1.5, 1.5);

	makeLuaSprite('luz_farol', 'backgrounds/callejon/luz_farol', -700, -350);
	setLuaSpriteScrollFactor('luz_farol', 0.9, 0.9);
	setBlendMode('luz_farol', 'add')
	scaleObject('luz_farol', 1.5, 1.5);

	makeLuaSprite('carro', 'backgrounds/callejon/carro', -900,-350);
	setLuaSpriteScrollFactor('carro', 0.9, 0.9);
	scaleObject('carro', 1.5, 1.5);

	addLuaSprite('fondo_nobbly', false);
	addLuaSprite('hombrecito', false);
	addLuaSprite('farol', false);
	addLuaSprite('luz_farol', true);
	addLuaSprite('carro', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end