function onCreate()
   makeLuaSprite('Roof', 'furcon/Roof', -1610, -1830);
   scaleObject('Roof', 1.05, 1.05);
   setScrollFactor('Roof', 0.68, 0.68) 
   addLuaSprite('Roof', false);

   makeLuaSprite('Floor', 'furcon/Floor', -1810, -60);
   setScrollFactor('Floor', 0.68, 0.68) 
   addLuaSprite('Floor', false);

   makeLuaSprite('walls', 'furcon/walls', -1830, -1208);
   scaleObject('walls', 1.0, 1.0);
   setScrollFactor('walls', 0.68, 0.68) 
   addLuaSprite('walls', false);

   makeLuaSprite('banner', 'furcon/banner', -450, -490);
   scaleObject('banner', 0.75, 0.75);
   setScrollFactor('banner', 0.73, 0.73) 
   addLuaSprite('banner', false);

   makeAnimatedLuaSprite('personajes_locochones_1','furcon/personajes_locochones_1', 570, -1020)
   setScrollFactor('personajes_locochones_1', 0.73, 0.73) 
   scaleObject('personajes_locochones_1', 1.2, 1.2);
   addAnimationByPrefix('personajes_locochones_1', 'idle', 'personajes loco arriba', 24, false)
   addLuaSprite('personajes_locochones_1')

   makeAnimatedLuaSprite('personajes_locochones_2','furcon/personajes_locochones_2', -1350, -1020)
   setScrollFactor('personajes_locochones_2', 0.73, 0.73) 
   scaleObject('personajes_locochones_2', 1.2, 1.2);
   addAnimationByPrefix('personajes_locochones_2', 'idle', 'Personajes loco arriba 2', 24, false)
   addLuaSprite('personajes_locochones_2')

   makeAnimatedLuaSprite('personajes_locochones_3','furcon/personajes_locochones_3', -280, -850)
   setScrollFactor('personajes_locochones_3', 0.73, 0.73) 
   scaleObject('personajes_locochones_3', 1.2, 1.2);
   addAnimationByPrefix('personajes_locochones_3', 'idle', 'Personas locochonas Bv', 24, false)
   addLuaSprite('personajes_locochones_3')

   makeAnimatedLuaSprite('las_pibas_y_el_papu','furcon/las_pibas_y_el_papu', -650, -420)
   setScrollFactor('las_pibas_y_el_papu', 0.73, 0.73) 
   scaleObject('las_pibas_y_el_papu', 1.2, 1.2);
   addAnimationByPrefix('las_pibas_y_el_papu', 'idle', 'las pibas y el papu', 24, false)
   addLuaSprite('las_pibas_y_el_papu')

   makeLuaSprite('second_floor', 'furcon/second_floor', -2050, -950);
   scaleObject('second_floor', 1.1, 1.1);
   setScrollFactor('second_floor', 0.73, 0.73) 
   addLuaSprite('second_floor', false);

   makeAnimatedLuaSprite('Un_lobo_solitario_auuuu','furcon/Un_lobo_solitario_auuuu', -1200, -250)
   setScrollFactor('Un_lobo_solitario_auuuu', 0.68, 0.68) 
   scaleObject('Un_lobo_solitario_auuuu', 1.8, 1.8);
   addAnimationByPrefix('Un_lobo_solitario_auuuu', 'idle', 'Jerpez 0', 24, false)
   addLuaSprite('Un_lobo_solitario_auuuu')
end

function onCreatePost()
    setScrollFactor('dadGroup',  0.72, 0.72)
    setScrollFactor('gfGroup',  0.72, 0.72)
    setProperty('cameraSpeed', 0.7)   
    setScrollFactor('boyfriendGroup',  0.72, 0.72)
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('personajes_locochones_1', 'idle')
        playAnim('personajes_locochones_2', 'idle')
        playAnim('personajes_locochones_3', 'idle')
        playAnim('Un_lobo_solitario_auuuu', 'idle')
        playAnim('las_pibas_y_el_papu', 'idle')
    end
end