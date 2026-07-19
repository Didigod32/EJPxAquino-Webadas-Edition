function onCreatePost()
    makeLuaSprite('cielo', 'c3jocup/cielo', -500, -300);
	setLuaSpriteScrollFactor('cielo', 0.9, 0.9);
    scaleObject('cielo', 1.1, 1.1);

	makeLuaSprite('piso', 'c3jocup/piso', -600, 750);
	setLuaSpriteScrollFactor('piso', 0.9, 0.9);
	scaleObject('piso', 1.1, 1.1);

    if not lowQuality then
		makeLuaSprite('arbol 1', 'c3jocup/arbol_1',-245,-96);
		setLuaSpriteScrollFactor('arbol 1', 0.7, 0.7);
		scaleObject('arbol 1', 0.9, 0.9);
		
		makeLuaSprite('arbol 2', 'c3jocup/arbol_2', 1550, -130);
		setLuaSpriteScrollFactor('arbol 2', 0.9, 0.9);
		scaleObject('arbol 2', 0.8, 0.8);

		makeLuaSprite('flores', 'c3jocup/flores', -280, 680);
		setLuaSpriteScrollFactor('flores', 0.33, 0.33);
		scaleObject('flores', 1, 1);

        makeLuaSprite('planicie', 'c3jocup/planicie', -700,0);
        setLuaSpriteScrollFactor('planicie', 0.8, 0.8);
        scaleObject('planicie', 1.1, 1.1);

        makeLuaSprite('montaña 1', 'c3jocup/montana_1',750,-75);
        setLuaSpriteScrollFactor('montaña 1', 0.5, 0.5);
        scaleObject('montaña 1', 1.0, 1.0); 

        makeLuaSprite('montaña 2', 'c3jocup/montana_2',-400,-25);
        setLuaSpriteScrollFactor('montaña 2', 0.45, 0.45);
        scaleObject('montaña 1', 0.75, 0.75);

        makeLuaSprite('mar', 'c3jocup/mar',-840,400);
        setLuaSpriteScrollFactor('mar', 0.9, 0.9);
        scaleObject('mar', 1.1, 1.1);

        makeLuaSprite('nubes', 'c3jocup/nubes', -840, -300);
        setLuaSpriteScrollFactor('nubes', 0.9, 0.9);
        scaleObject('nubes', 1.1, 1.1);
	end

    makeAnimatedLuaSprite('c3jocup1', 'c3jocup/c3jo_cuphead_plataforma', 1000, 600)
    setScrollFactor('c3jocup1', 1, 1)
    scaleObject('c3jocup1', 1.2, 1.2)
    addAnimationByPrefix('c3jocup1', 'idle', 'c3jo cuphead plataforma', 24, true)

    makeAnimatedLuaSprite('c3jocup2', 'c3jocup/c3jo_cuphead_plataforma', 1500, 750)
    setScrollFactor('c3jocup2', 1, 1)
    scaleObject('c3jocup2', 1.2, 1.2)
    addAnimationByPrefix('c3jocup2', 'idle', 'c3jo cuphead plataforma', 24, true)

    makeAnimatedLuaSprite('c3jocup3', 'c3jocup/c3jo_cuphead_plataforma', 450, 750)
    setScrollFactor('c3jocup3', 1, 1)
    scaleObject('c3jocup3', 1.2, 1.2)
    addAnimationByPrefix('c3jocup3', 'idle', 'c3jo cuphead plataforma', 24, true)

    makeAnimatedLuaSprite('the_thing', 'c3jocup/the_thing', 0, 0)
    setGraphicSize('the_thing', getProperty('the_thing.width') / getProperty('defaultCamZoom'))
    screenCenter('the_thing')
    setObjectCamera('the_thing', 'other')
    addAnimationByPrefix('the_thing', 'start', 'BOO instance 1', 24, false)
    addAnimationByIndices('the_thing', 'end', 'BOO instance 1', '15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0', 24, false)

    makeAnimatedLuaSprite('Grainshit', 'c3jocup/Grainshit', 0, 0)
    setGraphicSize('Grainshit', getProperty('Grainshit.width') / getProperty('defaultCamZoom'))
    setObjectCamera('Grainshit', 'other')
    addAnimationByPrefix('Grainshit', 'idle', 'Geain instance 1', 24, true)

    makeAnimatedLuaSprite('CUpheqdshid', 'c3jocup/CUpheqdshid', 0, 0)
    setGraphicSize('CUpheqdshid', getProperty('CUpheqdshid.width') / getProperty('defaultCamZoom'))
    setObjectCamera('CUpheqdshid', 'other')
    addAnimationByPrefix('CUpheqdshid', 'idle', 'Cupheadshit_gif', 24, true)

    addLuaSprite('cielo', false);
    addLuaSprite('nubes', false);
    addLuaSprite('montaña 2', false);
    addLuaSprite('montaña 1', false);
    addLuaSprite('mar', false);
    addLuaSprite('planicie', false);
    addLuaSprite('arbol 1', false);
	addLuaSprite('piso', false);
	addLuaSprite('arbol 2', false);
	addLuaSprite('flores', true);
    addLuaSprite('c3jocup1', false)
    addLuaSprite('c3jocup2', false)
    addLuaSprite('c3jocup3', false)
    addLuaSprite('Grainshit')
    addLuaSprite('CUpheqdshid')
    addLuaSprite('the_thing')
end

function onSongStart()
    setProperty('the_thing.visible', false)
end

function onStepHit()
    if string.lower(songName) == 'smash' then
        if curStep == 1488 then
            setProperty('the_thing.visible', true)
            playAnim('the_thing', 'end')
        end
    end
end