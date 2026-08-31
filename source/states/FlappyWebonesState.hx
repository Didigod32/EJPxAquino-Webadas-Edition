package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import backend.Paths;

class FlappyWebonesState extends MusicBeatState
{
    var webon:FlxSprite;
    var obstaculo:FlxTypedGroup<FlxSprite>;
    
    var score_actual:Int = 0;
    var text:FlxText;
    var fuerzaSalto:Float = -320;
    var juegoTerminado:Bool = false;
    
    // Escenarios
    var cielo:FlxBackdrop;
    var wea:FlxBackdrop;
    var piso:FlxBackdrop;

    // Tuberías
    var temporizador:Float = 0;
    var tiempoSpawn:Float = 2.0;
    var velocidadX:Float = -200;
    var tamanoHueco:Float = 160; 

    var gameSkins:Array<String> = ["webskin1", "webskin2", "webskin3", "webskin4", "webskin5"];
    var skinIndex:Int = 0;

    // Reducido a 0.08 para encajar sin rozar las tuberías
    final ESCALA_CABEZA:Float = 0.08;

    public function new(skinIndex:Int = 0)
    {
        super();
        this.skinIndex = skinIndex;
    }

    override public function create()
    {
        super.create();
        
        cielo = new FlxBackdrop(Paths.image("freeplay_weeks/perupe/cielo"), FlxAxes.X);
        cielo.velocity.x = -15; 
        add(cielo);

        wea = new FlxBackdrop(Paths.image("freeplay_weeks/perupe/wea"), FlxAxes.X);
        wea.velocity.x = -25;
        add(wea);
        
        piso = new FlxBackdrop(Paths.image("freeplay_weeks/perupe/piso"), FlxAxes.X);
        piso.y = FlxG.height - 100;
        piso.velocity.x = -40;
        add(piso);
        
        obstaculo = new FlxTypedGroup<FlxSprite>();
        add(obstaculo);

        // Cabeza del Jugador (Sprite único sin paloma atrás)
        webon = new FlxSprite(100, FlxG.height / 3);
        webon.loadGraphic(Paths.image("flappywebones/" + gameSkins[skinIndex]));
        webon.scale.set(ESCALA_CABEZA, ESCALA_CABEZA);
        webon.updateHitbox();
        webon.acceleration.y = 900;
        add(webon);

        text = new FlxText(0, 20, FlxG.width, "FLAPPY WEBONES", 24);
        text.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(text);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE || controls.BACK) 
        {
            MusicBeatState.switchState(new FlappySelectState());
            return;
        }

        if (juegoTerminado) 
        {
            if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) 
            {
                MusicBeatState.switchState(new FlappyWebonesState(skinIndex));
            }
            return;
        }

        // Salto
        if (FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed || controls.ACCEPT) 
        {
            webon.velocity.y = fuerzaSalto;
        }

        // Inclinación suave
        if (webon.velocity.y < 0)
        {
            webon.angle = -20;
        }
        else if (webon.velocity.y > 0)
        {
            webon.angle += 350 * elapsed;
            if (webon.angle > 90) webon.angle = 90;
        }

        // Spawneo de tuberías
        temporizador += elapsed;
        if (temporizador >= tiempoSpawn)
        {
            temporizador = 0;
            crearParObstaculos();
        }

        // Colisión exacta con el borde del piso o techo
        if ((webon.y + webon.height) >= piso.y || webon.y < 0) 
        {
            perderJuego();
        }

        FlxG.overlap(webon, obstaculo, function(webon:FlxSprite, tuberia:FlxSprite) {
            perderJuego();
        });
    }

    function crearParObstaculos()
    {
        var huecoY:Float = FlxG.random.float(150, FlxG.height - 200);

        var tuberiaArriba = new FlxSprite(FlxG.width, 0);
        tuberiaArriba.makeGraphic(50, Std.int(huecoY - (tamanoHueco / 2)), FlxColor.GREEN);
        tuberiaArriba.velocity.x = velocidadX;
        obstaculo.add(tuberiaArriba);

        var inicioAbajoY:Float = huecoY + (tamanoHueco / 2);
        var tuberiaAbajo = new FlxSprite(FlxG.width, inicioAbajoY);
        tuberiaAbajo.makeGraphic(50, Std.int(FlxG.height - inicioAbajoY), FlxColor.GREEN);
        tuberiaAbajo.velocity.x = velocidadX;
        obstaculo.add(tuberiaAbajo);
    }

    function perderJuego()
    {
        juegoTerminado = true;
        webon.velocity.y = 0;
        webon.acceleration.y = 0;

        obstaculo.forEachAlive(function(tuberia:FlxSprite) {
            tuberia.velocity.x = 0;
        });

        cielo.velocity.x = 0;
        wea.velocity.x = 0;
        piso.velocity.x = 0;

        text.text = "💥 ¡HAS PERDIDO!\nPresiona ESPACIO o ENTER para reiniciar";
    }
}