package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class BootScreenState extends MusicBeatState
{
    var userAvatar:FlxSprite;
    var welcomeText:FlxText;
    var systemUser:String = "Usuario";

    override public function create()
    {
        super.create();

        // 1. Obtener el nombre real de usuario del sistema operativo
        #if sys
        var envUser:String = Sys.getEnv("USERNAME");
        if (envUser == null || envUser.length == 0)
            envUser = Sys.getEnv("USER"); // Para compatibilidad con Linux/Mac

        if (envUser != null && envUser.length > 0)
            systemUser = envUser;
        #end

        // 2. Fondo de la pantalla de inicio de sesión (oscuro o borroso)
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(15, 15, 20));
        add(bg);

        // 3. Avatar de usuario (Círculo o foto de perfil)
        userAvatar = new FlxSprite().loadGraphic(Paths.image('mainmenu/user_avatar'));
        userAvatar.setGraphicSize(150, 150);
        userAvatar.updateHitbox();
        userAvatar.screenCenter(X);
        userAvatar.y = (FlxG.height / 2) - 120;
        userAvatar.alpha = 0;
        add(userAvatar);

        // 4. Texto de Bienvenida
        welcomeText = new FlxText(0, userAvatar.y + 170, FlxG.width, "Bienvenido, " + systemUser, 28);
        welcomeText.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        welcomeText.alpha = 0;
        add(welcomeText);

        // --- ANIMACIÓN DE ENTRADA Y SALIDA ---
        
        // Sonido opcional de inicio de Windows / PC
        FlxG.sound.play(Paths.sound('scrollMenu')); 

        // Aparecer elementos suavemente (Fade In)
        FlxTween.tween(userAvatar, {alpha: 1, y: userAvatar.y + 10}, 0.8, {ease: FlxEase.cubeOut});
        FlxTween.tween(welcomeText, {alpha: 1, y: welcomeText.y + 10}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.2});

        // Esperar 2.2 segundos y hacer la transición al Menú Principal
        new FlxTimer().start(2.2, function(tmr:FlxTimer) {
            // Desvanecer elementos (Fade Out)
            FlxTween.tween(userAvatar, {alpha: 0}, 0.5);
            FlxTween.tween(welcomeText, {alpha: 0}, 0.5);
            FlxTween.tween(bg, {alpha: 0}, 0.5, {
                onComplete: function(twn:FlxTween) {
                    // Cambiar al MainMenuState
                    MusicBeatState.switchState(new MainMenuState());
                }
            });
        });
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // Permitir saltar la animación presionando ENTER o ESPACIO
        if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) {
            MusicBeatState.switchState(new MainMenuState());
        }
    }
}