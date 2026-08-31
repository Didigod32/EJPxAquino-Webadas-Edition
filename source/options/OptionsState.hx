package options;

import states.MainMenuState;
import states.PlayState;
import states.LoadingState;
import backend.StageData;
import backend.ClientPrefs;
import backend.Language;
import backend.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

#if (target.threaded)
import sys.thread.Mutex;
import sys.thread.Thread;
#end

class OptionsState extends MusicBeatState
{
    var options:Array<String> = [
        'Graphics',
        'Visuals',
        'Gameplay',
        'Controls',
        'Note Colors',
        'Adjust Delay and Combo',
        'V-Slice Options',
        #if TRANSLATIONS_ALLOWED 'Language', #end
        #if (TOUCH_CONTROLS_ALLOWED || mobile) 'Mobile Options' #end
    ];

    private static var curSelected:Int = 0;
    public static var onPlayState:Bool = false;
    #if (target.threaded) var mutex:Mutex = new Mutex(); #end

    // Estructura Windows 10
    var bg:FlxSprite;
    var topBarBg:FlxSprite;
    var topTitle:FlxText;
    var backBtn:FlxText;
    var closeBtnBg:FlxSprite;
    var closeBtnTxt:FlxText;

    // Encabezado
    var headerTitle:FlxText;
    var searchBarFake:FlxSprite;
    var searchTxtFake:FlxText;

    // Mosaicos (Tiles)
    var tilesGroup:FlxTypedGroup<FlxSprite>;
    var textsGroup:FlxTypedGroup<FlxText>;
    var tileCards:Array<FlxSprite> = [];

    final COLS:Int = 3;
    final TILE_WIDTH:Int = 250;
    final TILE_HEIGHT:Int = 95;
    final SPACING_X:Float = 24;
    final SPACING_Y:Float = 20;

    override function create()
    {
        #if DISCORD_ALLOWED
        DiscordClient.changePresence("Options Menu", null);
        #end

        FlxG.mouse.visible = true;

        // 1. Fondo Moderno Gris Oscuro / Neutro
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(32, 32, 32));
        add(bg);

        // 2. Barra Superior Plana
        topBarBg = new FlxSprite(0, 0).makeGraphic(FlxG.width, 36, FlxColor.fromRGB(24, 24, 24));
        add(topBarBg);

        backBtn = new FlxText(15, 8, 0, "❮", 16);
        backBtn.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE);
        add(backBtn);

        topTitle = new FlxText(45, 10, 0, "Configuración", 13);
        topTitle.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(200, 200, 200), LEFT);
        add(topTitle);

        closeBtnBg = new FlxSprite(FlxG.width - 45, 0).makeGraphic(45, 36, FlxColor.fromRGB(190, 40, 40));
        add(closeBtnBg);

        closeBtnTxt = new FlxText(FlxG.width - 45, 8, 45, "✕", 14);
        closeBtnTxt.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.WHITE, CENTER);
        add(closeBtnTxt);

        // 3. Encabezado Central
        headerTitle = new FlxText(0, 60, FlxG.width, "Configuración de Windows", 26);
        headerTitle.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, CENTER);
        add(headerTitle);

        // Buscador simulado clásico de Win10
        searchBarFake = new FlxSprite(FlxG.width / 2 - 180, 105).makeGraphic(360, 32, FlxColor.fromRGB(45, 45, 48));
        add(searchBarFake);

        searchTxtFake = new FlxText(FlxG.width / 2 - 170, 112, 340, "🔍 Buscar una opción de configuración", 12);
        searchTxtFake.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(150, 150, 150), LEFT);
        add(searchTxtFake);

        // 4. Cuadrícula de Tarjetas
        tilesGroup = new FlxTypedGroup<FlxSprite>();
        textsGroup = new FlxTypedGroup<FlxText>();
        add(tilesGroup);
        add(textsGroup);

        buildTilesGrid();

        changeSelection(0, false);
        ClientPrefs.saveSettings();

        #if (target.threaded)
        Thread.create(() -> {
            mutex.acquire();
            for (music in VisualsSettingsSubState.pauseMusics) {
                if (music.toLowerCase() != "none")
                    Paths.music(Paths.formatToSongPath(music));
            }
            mutex.release();
        });
        #end

        super.create();
    }

    function buildTilesGrid():Void
    {
        tileCards = [];
        tilesGroup.clear();
        textsGroup.clear();

        var totalGridWidth:Float = (COLS * TILE_WIDTH) + ((COLS - 1) * SPACING_X);
        var startX:Float = (FlxG.width - totalGridWidth) / 2;
        var startY:Float = 170;

        for (i in 0...options.length)
        {
            var col:Int = i % COLS;
            var row:Int = Std.int(i / COLS);

            var posX:Float = startX + (col * (TILE_WIDTH + SPACING_X));
            var posY:Float = startY + (row * (TILE_HEIGHT + SPACING_Y));

            // Tarjeta Base
            var card:FlxSprite = new FlxSprite(posX, posY).makeGraphic(TILE_WIDTH, TILE_HEIGHT, FlxColor.fromRGB(45, 45, 48));
            card.ID = i;
            tilesGroup.add(card);
            tileCards.push(card);

            // Datos de la Opción
            var optName:String = options[i];
            var iconStr:String = getIconForOption(optName);
            var descStr:String = getDescForOption(optName);
            var titleStr:String = Language.getPhrase('options_$optName', optName);

            // Icono
            var iconTxt:FlxText = new FlxText(posX + 15, posY + 15, 40, iconStr, 24);
            iconTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.fromRGB(0, 120, 215), CENTER);
            textsGroup.add(iconTxt);

            // Título
            var optTitleTxt:FlxText = new FlxText(posX + 60, posY + 16, TILE_WIDTH - 70, titleStr, 13);
            optTitleTxt.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.WHITE, LEFT);
            textsGroup.add(optTitleTxt);

            // Subtítulo
            var optDescTxt:FlxText = new FlxText(posX + 60, posY + 38, TILE_WIDTH - 70, descStr, 10);
            optDescTxt.setFormat(Paths.font("vcr.ttf"), 10, FlxColor.fromRGB(160, 160, 160), LEFT);
            textsGroup.add(optDescTxt);
        }
    }

    override function closeSubState()
    {
        super.closeSubState();
        ClientPrefs.saveSettings();
        #if DISCORD_ALLOWED
        DiscordClient.changePresence("Options Menu", null);
        #end
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        // Controles de Teclado
        if (controls.UI_LEFT_P) changeSelection(-1);
        if (controls.UI_RIGHT_P) changeSelection(1);
        if (controls.UI_UP_P) changeSelection(-COLS);
        if (controls.UI_DOWN_P) changeSelection(COLS);

        if (controls.ACCEPT)
            openSelectedSubstate(options[curSelected]);

        if (controls.BACK || FlxG.keys.justPressed.ESCAPE)
            exitOptionsMenu();

        // Controles de Ratón
        if (FlxG.mouse.justPressed)
        {
            if (FlxG.mouse.overlaps(closeBtnBg) || FlxG.mouse.overlaps(closeBtnTxt) || FlxG.mouse.overlaps(backBtn))
            {
                exitOptionsMenu();
                return;
            }

            for (i in 0...tileCards.length)
            {
                var card = tileCards[i];
                if (FlxG.mouse.overlaps(card))
                {
                    curSelected = i;
                    openSelectedSubstate(options[curSelected]);
                    return;
                }
            }
        }

        if (FlxG.mouse.justMoved)
        {
            for (i in 0...tileCards.length)
            {
                var card = tileCards[i];
                if (FlxG.mouse.overlaps(card) && curSelected != i)
                {
                    curSelected = i;
                    changeSelection(0);
                    break;
                }
            }
        }
    }

    function changeSelection(change:Int = 0, playSound:Bool = true)
    {
        if (playSound) FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);

        for (i in 0...tileCards.length)
        {
            var card = tileCards[i];
            if (i == curSelected)
            {
                // Borde/Fondo azul característico de Windows 10
                card.color = FlxColor.fromRGB(55, 65, 80);
            }
            else
            {
                card.color = FlxColor.fromRGB(45, 45, 48);
            }
        }
    }

    function getIconForOption(label:String):String
    {
        return switch (label)
        {
            case 'Graphics': "🖥";
            case 'Visuals': "✨";
            case 'Gameplay': "🎮";
            case 'Controls': "⌨";
            case 'Note Colors': "🎨";
            case 'Adjust Delay and Combo': "⏱";
            case 'V-Slice Options': "📦";
            case 'Language': "🌐";
            default: "⚙";
        };
    }

    function getDescForOption(label:String):String
    {
        return switch (label)
        {
            case 'Graphics': "Resolución, FPS y suavizado.";
            case 'Visuals': "Luces parpadeantes e interfaz.";
            case 'Gameplay': "Downscroll, Ghost Tapping.";
            case 'Controls': "Atajos y teclas de juego.";
            case 'Note Colors': "Personalizar tonos de notas.";
            case 'Adjust Delay and Combo': "Latencia de audio y HUD.";
            case 'V-Slice Options': "Compatibilidad del motor.";
            case 'Language': "Idioma de menús y textos.";
            default: "Configuraciones del sistema.";
        };
    }

    function openSelectedSubstate(label:String)
    {
        switch (label)
        {
            case 'Note Colors':
                openSubState(new options.NotesColorSubState());
            case 'Controls':
                if (controls.mobileC)
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                else
                    openSubState(new options.ControlsSubState());
            case 'Graphics':
                openSubState(new options.GraphicsSettingsSubState());
            case 'Visuals':
                openSubState(new options.VisualsSettingsSubState());
            case 'Gameplay':
                openSubState(new options.GameplaySettingsSubState());
            case 'Adjust Delay and Combo':
                MusicBeatState.switchState(new options.NoteOffsetState());
            case 'V-Slice Options':
                openSubState(new BaseGameSubState());
            #if (TOUCH_CONTROLS_ALLOWED || mobile)
            case 'Mobile Options':
                openSubState(new mobile.options.MobileOptionsSubState());
            #end
            case 'Language':
                openSubState(new options.LanguageSubState());
        }
    }

    function exitOptionsMenu():Void
    {
        FlxG.sound.play(Paths.sound('cancelMenu'));
        if (onPlayState)
        {
            StageData.loadDirectory(PlayState.SONG);
            LoadingState.loadAndSwitchState(new PlayState());
            FlxG.sound.music.volume = 0;
        }
        else
        {
            MusicBeatState.switchState(new MainMenuState());
        }
    }

    override function destroy()
    {
        ClientPrefs.loadPrefs();
        super.destroy();
    }
	//piero lacra basura asquerosa horrorosa pepepe
}