function onCreate()

   makeLuaSprite('walls', 'main_weeks/furcon/walls', -1400, -800);
   scaleObject('walls', 0.90, 0.90);
   setScrollFactor('walls', 0.68, 0.68) 
   addLuaSprite('walls', false);

    makeLuaSprite('filtro', 'main_weeks/furcon/Luz_BgLOCOCHON', -1395, -790);
   scaleObject('filtro', 1.2, 1.15);
   setScrollFactor('filtro', 0.68, 0.68) 
   addLuaSprite('filtro', true);


   makeAnimatedLuaSprite('personajes_locochones_1','main_weeks/furcon/personajes_locochones_1', 440, -615)
   setScrollFactor('personajes_locochones_1', 0.73, 0.73) 
   scaleObject('personajes_locochones_1', 1, 1);
   addAnimationByPrefix('personajes_locochones_1', 'idle', 'personajes loco arriba', 24, false)
   addLuaSprite('personajes_locochones_1')

   makeAnimatedLuaSprite('personajes_locochones_2','main_weeks/furcon/personajes_locochones_2', -1300, -615)
   setScrollFactor('personajes_locochones_2', 0.73, 0.73) 
   scaleObject('personajes_locochones_2', 1, 1);
   addAnimationByPrefix('personajes_locochones_2', 'idle', 'Personajes loco arriba 2', 24, false)
   addLuaSprite('personajes_locochones_2')

   makeAnimatedLuaSprite('personajes_locochones_3','main_weeks/furcon/personajes_locochones_3', -305, -445)
   setScrollFactor('personajes_locochones_3', 0.73, 0.73) 
   scaleObject('personajes_locochones_3', 1, 1);
   addAnimationByPrefix('personajes_locochones_3', 'idle', 'Personas locochonas Bv', 24, false)
   addLuaSprite('personajes_locochones_3')

   makeAnimatedLuaSprite('las_pibas_y_el_papu','main_weeks/furcon/las_pibas_y_el_papu', -150, -10)
   setScrollFactor('las_pibas_y_el_papu', 0.68, 0.68) 
   scaleObject('las_pibas_y_el_papu', 0.6, 0.6);
   addAnimationByPrefix('las_pibas_y_el_papu', 'idle', 'las pibas y el papu', 24, false)
   addLuaSprite('las_pibas_y_el_papu')

   makeLuaSprite('second_floor', 'main_weeks/furcon/second_floor', -1395, -805);
   scaleObject('second_floor', 0.91, 0.91);
   setScrollFactor('second_floor', 0.68, 0.68) 
   addLuaSprite('second_floor', false);

   makeAnimatedLuaSprite('Un_lobo_solitario_auuuu','main_weeks/furcon/Un_lobo_solitario_auuuu', -936, 40)
   setScrollFactor('Un_lobo_solitario_auuuu', 0.68, 0.68) 
   scaleObject('Un_lobo_solitario_auuuu', 0.85, 0.85);
   addAnimationByPrefix('Un_lobo_solitario_auuuu', 'idle', 'Jerpez 0', 24, false)
   addLuaSprite('Un_lobo_solitario_auuuu')

 
end

function onCreatePost()
    setScrollFactor('dadGroup',  0.68, 0.68)
    setScrollFactor('gfGroup',  0.68, 0.68)
    setProperty('cameraSpeed', 0.7)   
    setScrollFactor('boyfriendGroup',  0.68, 0.68)

     
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