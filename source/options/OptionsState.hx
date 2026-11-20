package options;

import states.MainMenuState;
import states.PlayState;
import states.LoadingState;
import backend.StageData;
import backend.ClientPrefs;
import backend.Language;
import backend.Paths;
import objects.Alphabet;
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
    var headerTitle:Alphabet;
    var searchBarFake:FlxSprite;
    var searchTxtFake:FlxText;

    // Mosaicos (Tiles)
    var tilesGroup:FlxTypedGroup<FlxSprite>;
    var titlesGroup:FlxTypedGroup<FlxText>;
    var descriptionsGroup:FlxTypedGroup<FlxText>;
    var tileCards:Array<FlxSprite> = [];

    final COLS:Int = 3;
    final TILE_WIDTH:Int = 275;
    final TILE_HEIGHT:Int = 110;
    final SPACING_X:Float = 24;
    final SPACING_Y:Float = 20;

    override function create()
    {
        #if DISCORD_ALLOWED
        DiscordClient.changePresence("Options Menu", null);
        #end

        FlxG.mouse.visible = true;

        // 1. Fondo
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(28, 28, 30));
        add(bg);

        // 2. Barra Superior
        topBarBg = new FlxSprite(0, 0).makeGraphic(FlxG.width, 36, FlxColor.fromRGB(20, 20, 22));
        add(topBarBg);

        backBtn = new FlxText(15, 6, 0, "<", 18);
        backBtn.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.fromRGB(220, 220, 220));
        add(backBtn);

        topTitle = new FlxText(45, 9, 0, "Configuración", 14);
        topTitle.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.fromRGB(180, 180, 180), LEFT);
        add(topTitle);

        closeBtnBg = new FlxSprite(FlxG.width - 48, 0).makeGraphic(48, 36, FlxColor.fromRGB(196, 43, 28));
        add(closeBtnBg);

        closeBtnTxt = new FlxText(FlxG.width - 48, 6, 48, "X", 18);
        closeBtnTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(closeBtnTxt);

        // 3. Encabezado
        headerTitle = new Alphabet(0, 48, "Configuracion de Windows", true);
        headerTitle.setScale(0.48);
        headerTitle.screenCenter(X);
        add(headerTitle);

        searchBarFake = new FlxSprite(FlxG.width / 2 - 200, 100).makeGraphic(400, 32, FlxColor.fromRGB(40, 40, 44));
        add(searchBarFake);

        searchTxtFake = new FlxText(FlxG.width / 2 - 190, 107, 380, "Buscar una opción de configuración", 13);
        searchTxtFake.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(140, 140, 140), LEFT);
        add(searchTxtFake);

        // 4. Grupos de Contenido
        tilesGroup = new FlxTypedGroup<FlxSprite>();
        titlesGroup = new FlxTypedGroup<FlxText>();
        descriptionsGroup = new FlxTypedGroup<FlxText>();

        add(tilesGroup);
        add(titlesGroup);
        add(descriptionsGroup);

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
        titlesGroup.clear();
        descriptionsGroup.clear();

        var totalGridWidth:Float = (COLS * TILE_WIDTH) + ((COLS - 1) * SPACING_X);
        var startX:Float = (FlxG.width - totalGridWidth) / 2;
        var startY:Float = 155;

        for (i in 0...options.length)
        {
            var col:Int = i % COLS;
            var row:Int = Std.int(i / COLS);

            var posX:Float = startX + (col * (TILE_WIDTH + SPACING_X));
            var posY:Float = startY + (row * (TILE_HEIGHT + SPACING_Y));

            var card:FlxSprite = new FlxSprite(posX, posY).makeGraphic(TILE_WIDTH, TILE_HEIGHT, FlxColor.fromRGB(42, 42, 46));
            card.ID = i;
            tilesGroup.add(card);
            tileCards.push(card);

            var optName:String = options[i];
            var descStr:String = getDescForOption(optName);
            var titleStr:String = Language.getPhrase('options_$optName', optName);

            // Título de la tarjeta (más grande y nítido)
            var optTitleTxt:FlxText = new FlxText(posX + 18, posY + 16, TILE_WIDTH - 36, titleStr, 18);
            optTitleTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            titlesGroup.add(optTitleTxt);

            // Subtítulo descriptivo (más legible)
            var optDescTxt:FlxText = new FlxText(posX + 18, posY + 52, TILE_WIDTH - 36, descStr, 13);
            optDescTxt.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(175, 175, 180), LEFT);
            descriptionsGroup.add(optDescTxt);
        }
    }

    override function closeSubState()
    {
        super.closeSubState();
        FlxG.mouse.visible = true;
        ClientPrefs.saveSettings();
        #if DISCORD_ALLOWED
        DiscordClient.changePresence("Options Menu", null);
        #end
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        FlxG.mouse.visible = true;

        if (controls.UI_LEFT_P) changeSelection(-1);
        if (controls.UI_RIGHT_P) changeSelection(1);
        if (controls.UI_UP_P) changeSelection(-COLS);
        if (controls.UI_DOWN_P) changeSelection(COLS);

        if (controls.ACCEPT)
            openSelectedSubstate(options[curSelected]);

        if (controls.BACK || FlxG.keys.justPressed.ESCAPE)
            exitOptionsMenu();

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
                card.color = FlxColor.fromRGB(0, 120, 215); // Azul Windows 10
            else
                card.color = FlxColor.fromRGB(42, 42, 46);
        }
    }

    function getDescForOption(label:String):String
    {
        return switch (label)
        {
            case 'Graphics': "Resolución, FPS y antialiasing.";
            case 'Visuals': "Luces, HUD y efectos visuales.";
            case 'Gameplay': "Downscroll, Ghost Tapping y binds.";
            case 'Controls': "Configuración de teclas y mandos.";
            case 'Note Colors': "Personalizar tonos de cada nota.";
            case 'Adjust Delay and Combo': "Latencia de audio y offset.";
            case 'V-Slice Options': "Ajustes de motor V-Slice.";
            case 'Language': "Idioma de textos y menús.";
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
}