function onCreate()
	makeLuaSprite('panza de burro', 'perupe/cielo', -1200, -1000);
	setLuaSpriteScrollFactor('panza de burro', 0.9, 0.9);
	scaleObject('panza de burro', 1.6, 1.6);
	
	makeLuaSprite('mi cerru pe', 'perupe/wea', -850, -1000);
	setLuaSpriteScrollFactor('chosa', 0.9, 0.9);
	scaleObject('mi cerru pe', 1.6, 1.6);

	makeLuaSprite('chosa', 'perupe/piso', -1200, -1200);
	setLuaSpriteScrollFactor('chosa', 0.9, 0.9);
	scaleObject('chosa', 1.6, 1.6);

	addLuaSprite('panza de burro', false);
	addLuaSprite('mi cerru pe', false);
	addLuaSprite('chosa', false);
	
	close(true);
end