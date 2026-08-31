package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import backend.Paths;
import states.MainMenuState;
import states.FlappyWebonesState;

class FlappySelectState extends MusicBeatState
{
    var menuSkins:Array<String> = ["webon1", "webon2", "webon3", "webon4", "webon5"];
    var personajeSeleccionado:Int = 0;
    
    var palomaFondo:FlxSprite;
    var previewWebon:FlxSprite;
    var textoSeleccion:FlxText;

    // Escalas de renderizado
    final ESCALA_PALOMA:Float = 0.18;
    final ESCALA_CABEZA:Float = 0.26;

    override public function create()
    {
        super.create();

        var cielo = new FlxBackdrop(Paths.image("freeplay_weeks/perupe/cielo"), FlxAxes.X);
        cielo.velocity.x = -15;
        add(cielo);

        var wea = new FlxBackdrop(Paths.image("freeplay_weeks/perupe/wea"), FlxAxes.X);
        wea.velocity.x = -25;
        add(wea);

        var piso = new FlxBackdrop(Paths.image("freeplay_weeks/perupe/piso"), FlxAxes.X);
        piso.y = FlxG.height - 100;
        piso.velocity.x = -40;
        add(piso);

        // 1. Cuerpo de Paloma
        palomaFondo = new FlxSprite().loadGraphic(Paths.image("flappywebones/palomafondo"));
        palomaFondo.scale.set(ESCALA_PALOMA, ESCALA_PALOMA);
        palomaFondo.updateHitbox();
        palomaFondo.screenCenter(X);
        palomaFondo.y = FlxG.height * 0.40;
        add(palomaFondo);

        // 2. Cabeza del Personaje
        previewWebon = new FlxSprite();
        previewWebon.loadGraphic(Paths.image("flappywebones/" + menuSkins[personajeSeleccionado]));
        previewWebon.scale.set(ESCALA_CABEZA, ESCALA_CABEZA);
        previewWebon.updateHitbox();
        
        posicionarPersonaje();
        add(previewWebon);

        var titulo = new FlxText(0, 30, FlxG.width, "SELECCIONA TU WEBON", 28);
        titulo.setFormat(null, 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(titulo);

        textoSeleccion = new FlxText(0, FlxG.height - 80, FlxG.width, "← / → Cambiar personaje\n[ENTER / ESPACIO] Jugar", 20);
        textoSeleccion.setFormat(null, 20, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(textoSeleccion);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE || controls.BACK)
        {
            MusicBeatState.switchState(new MainMenuState());
            return;
        }

        if (FlxG.keys.justPressed.LEFT || controls.UI_LEFT_P || FlxG.keys.justPressed.A)
        {
            personajeSeleccionado--;
            if (personajeSeleccionado < 0) personajeSeleccionado = menuSkins.length - 1;
            actualizarPreview();
        }

        if (FlxG.keys.justPressed.RIGHT || controls.UI_RIGHT_P || FlxG.keys.justPressed.D)
        {
            personajeSeleccionado++;
            if (personajeSeleccionado >= menuSkins.length) personajeSeleccionado = 0;
            actualizarPreview();
        }

        if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || controls.ACCEPT)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            MusicBeatState.switchState(new FlappyWebonesState(personajeSeleccionado));
        }
    }

    function posicionarPersonaje()
    {
        previewWebon.x = palomaFondo.x + (palomaFondo.width / 2) - (previewWebon.width / 2);
        // Bajamos la cabeza multiplicando por 0.10 en lugar de 0.42 para meterla directo sobre el cuello
        previewWebon.y = palomaFondo.y - (previewWebon.height * 0.10);
    }

    function actualizarPreview()
    {
        previewWebon.loadGraphic(Paths.image("flappywebones/" + menuSkins[personajeSeleccionado]));
        previewWebon.scale.set(ESCALA_CABEZA, ESCALA_CABEZA);
        previewWebon.updateHitbox();
        
        posicionarPersonaje();
        FlxG.sound.play(Paths.sound('scrollMenu'));
    }
}