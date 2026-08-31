package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import backend.ClientPrefs;

import states.StoryMenuState;
import states.PlayState;
import states.FlappySelectState;
import options.OptionsState;
import pslice.vslice.freeplay.FreeplayState;

// IMPORTS DE EDITORES Y MODS
import states.editors.MasterEditorMenu;
import states.ModsMenuState;

class MainMenuState extends MusicBeatState
{
    public static var psychEngineVersion:String = '1.0.0';
    public static var pSliceVersion:String = '1.4.1';

    var busy:Bool = false;

    var desktopWallpaper:FlxSprite;

    var taskbarContainer:FlxTypedGroup<FlxSprite>;
    var taskbarTextGroup:FlxTypedGroup<FlxText>;
    var taskbarBg:FlxSprite;
    var targetTaskbarY:Float = 0;
    var currentTaskbarY:Float = 0;

    var startWinBtn:FlxSprite;
    var clockText:FlxText;

    var searchBarBg:FlxSprite;
    var searchTxt:FlxText;
    var isSearching:Bool = false;
    var searchQuery:String = "";

    var desktopIconsGroup:FlxTypedGroup<FlxSprite>;
    var desktopTextsGroup:FlxTypedGroup<FlxText>;
    var taskbarIconsGroup:FlxTypedGroup<FlxSprite>;

    // LISTA DE APLICACIONES EN ESCRITORIO
    var appsData:Array<Dynamic> = [
        {id: "story", title: "Story Mode", icon: "Opera_GX", action: "story"},
        {id: "freeplay", title: "Spotify", icon: "spotify", action: "freeplay"},
        {id: "flappy", title: "Flappy webones", icon: "flappy", action: "flappy"},
        {id: "options", title: "Ajustes", icon: "ajustes", action: "options"},
        {id: "credits", title: "Créditos", icon: "powerpoint", action: "credits"},
        {id: "gallery", title: "Galería", icon: "fotos", action: "gallery"}
    ];

    var desktopIconSprites:Array<FlxSprite> = [];
    var taskbarIconSprites:Array<FlxSprite> = [];

    final DESKTOP_ICON_SIZE:Int = 52;
    final TASKBAR_ICON_SIZE:Int = 28;

    public function new(?playRankAnim:Bool = false)
    {
        super();
    }

    override function create()
    {
        super.create();

        FlxG.mouse.visible = true;

        desktopWallpaper = new FlxSprite(0, 0);
        if (Paths.fileExists('images/menuBG.png', IMAGE))
            desktopWallpaper.loadGraphic(Paths.image('menuBG'));
        else
            desktopWallpaper.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(25, 35, 45));
        desktopWallpaper.setGraphicSize(FlxG.width, FlxG.height);
        desktopWallpaper.updateHitbox();
        add(desktopWallpaper);

        desktopIconsGroup = new FlxTypedGroup<FlxSprite>();
        desktopTextsGroup = new FlxTypedGroup<FlxText>();
        add(desktopIconsGroup);
        add(desktopTextsGroup);

        buildDesktopShortcuts();
        createWindowsTaskbar();

        busy = false;
    }

    function getValidIconPath(rawName:String):String
    {
        var candidates:Array<String> = [
            'mainmenu/' + rawName,
            'mainmenu/' + rawName.toLowerCase(),
            'mainmenu/Opera_GX',
            'mainmenu/opera_gx'
        ];

        for (path in candidates)
        {
            if (Paths.fileExists('images/' + path + '.png', IMAGE))
                return path;
        }

        return 'mainmenu/' + rawName;
    }

    function buildDesktopShortcuts()
    {
        desktopIconsGroup.clear();
        desktopTextsGroup.clear();
        desktopIconSprites = [];

        var startX:Float = 40;
        var startY:Float = 40;
        var spacingY:Float = 90;

        for (i in 0...appsData.length)
        {
            var app = appsData[i];
            var posY:Float = startY + (i * spacingY);

            var iconSpr:FlxSprite = new FlxSprite(startX, posY);
            var iconPath:String = getValidIconPath(app.icon);
            
            if (Paths.fileExists('images/' + iconPath + '.png', IMAGE))
            {
                iconSpr.loadGraphic(Paths.image(iconPath));
            }
            else
            {
                iconSpr.makeGraphic(DESKTOP_ICON_SIZE, DESKTOP_ICON_SIZE, FlxColor.fromRGB(200, 160, 40));
            }

            iconSpr.setGraphicSize(DESKTOP_ICON_SIZE, DESKTOP_ICON_SIZE);
            iconSpr.updateHitbox();
            iconSpr.antialiasing = ClientPrefs.data.antialiasing;
            iconSpr.ID = i;
            desktopIconsGroup.add(iconSpr);
            desktopIconSprites.push(iconSpr);

            var labelTxt:FlxText = new FlxText(startX - 20, posY + DESKTOP_ICON_SIZE + 4, DESKTOP_ICON_SIZE + 40, app.title, 11);
            labelTxt.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            desktopTextsGroup.add(labelTxt);
        }
    }

    function createWindowsTaskbar()
    {
        taskbarContainer = new FlxTypedGroup<FlxSprite>();
        taskbarTextGroup = new FlxTypedGroup<FlxText>();
        taskbarIconsGroup = new FlxTypedGroup<FlxSprite>();

        currentTaskbarY = FlxG.height - 2;
        targetTaskbarY = FlxG.height - 2;

        taskbarBg = new FlxSprite(0, FlxG.height - 2).makeGraphic(FlxG.width, 48, FlxColor.fromRGB(24, 28, 34));
        taskbarBg.alpha = 0.94;
        taskbarContainer.add(taskbarBg);

        startWinBtn = new FlxSprite(12, FlxG.height + 8);
        if (Paths.fileExists('images/mainmenu/winlogo.png', IMAGE))
        {
            startWinBtn.loadGraphic(Paths.image('mainmenu/winlogo'));
        }
        else
        {
            startWinBtn.makeGraphic(28, 28, FlxColor.fromRGB(0, 162, 232));
        }
        startWinBtn.setGraphicSize(28, 28);
        startWinBtn.updateHitbox();
        startWinBtn.antialiasing = ClientPrefs.data.antialiasing;
        taskbarContainer.add(startWinBtn);

        searchBarBg = new FlxSprite(50, FlxG.height + 8).makeGraphic(210, 28, FlxColor.fromRGB(38, 44, 54));
        taskbarContainer.add(searchBarBg);

        searchTxt = new FlxText(58, FlxG.height + 14, 200, "🔍 Buscar programa...", 11);
        searchTxt.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.GRAY);
        taskbarTextGroup.add(searchTxt);

        var centerStartX:Float = (FlxG.width / 2) - ((appsData.length * 40) / 2);
        taskbarIconSprites = [];

        for (i in 0...appsData.length)
        {
            var app = appsData[i];
            var iconSpr:FlxSprite = new FlxSprite(centerStartX + (i * 40), FlxG.height + 9);
            var iconPath:String = getValidIconPath(app.icon);

            if (Paths.fileExists('images/' + iconPath + '.png', IMAGE))
                iconSpr.loadGraphic(Paths.image(iconPath));
            else
                iconSpr.makeGraphic(TASKBAR_ICON_SIZE, TASKBAR_ICON_SIZE, FlxColor.fromRGB(200, 160, 40));

            iconSpr.setGraphicSize(TASKBAR_ICON_SIZE, TASKBAR_ICON_SIZE);
            iconSpr.updateHitbox();
            iconSpr.antialiasing = ClientPrefs.data.antialiasing;
            iconSpr.ID = i;
            taskbarIconsGroup.add(iconSpr);
            taskbarIconSprites.push(iconSpr);
        }

        clockText = new FlxText(FlxG.width - 95, FlxG.height + 10, 80, "00:00\n0/0/0000", 10);
        clockText.setFormat("_sans", 10, FlxColor.WHITE, RIGHT);
        clockText.textField.defaultTextFormat.leading = 4;      
        clockText.antialiasing = ClientPrefs.data.antialiasing;
        taskbarTextGroup.add(clockText);

        add(taskbarContainer);
        add(taskbarIconsGroup);
        add(taskbarTextGroup);

        updateTaskbarPosition();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var isMouseNearBottom:Bool = (FlxG.mouse.y >= FlxG.height - 65);
        targetTaskbarY = isMouseNearBottom ? (FlxG.height - 48) : (FlxG.height - 2);

        currentTaskbarY = FlxMath.lerp(currentTaskbarY, targetTaskbarY, elapsed * 12);
        updateTaskbarPosition();

        var date = Date.now();
        var hours = StringTools.lpad(Std.string(date.getHours()), "0", 2);
        var mins = StringTools.lpad(Std.string(date.getMinutes()), "0", 2);
        var day = Std.string(date.getDate());
        var month = Std.string(date.getMonth() + 1);
        var year = date.getFullYear();

        clockText.text = '$hours:$mins\n$day/$month/$year';

        if (busy) return;

        if (isSearching)
        {
            handleSearchInput();
            return;
        }

        // --- TECLAS RÁPIDAS PARA EDITORES Y MODS ---
        if (FlxG.keys.justPressed.SEVEN)
        {
            launchApp("editors");
            return;
        }
        else if (FlxG.keys.justPressed.EIGHT)
        {
            launchApp("mods");
            return;
        }

        if (isMouseNearBottom && FlxG.mouse.overlaps(searchBarBg))
        {
            if (FlxG.mouse.justPressed)
            {
                isSearching = true;
                searchQuery = "";
                searchTxt.text = "🔍 |";
                searchTxt.color = FlxColor.WHITE;
                return;
            }
        }

        for (i in 0...desktopIconSprites.length)
        {
            var icon = desktopIconSprites[i];
            if (FlxG.mouse.overlaps(icon))
            {
                icon.setGraphicSize(Std.int(DESKTOP_ICON_SIZE * 1.15), Std.int(DESKTOP_ICON_SIZE * 1.15));
                icon.updateHitbox();

                if (FlxG.mouse.justPressed)
                {
                    launchApp(appsData[i].action);
                    return;
                }
            }
            else
            {
                icon.setGraphicSize(DESKTOP_ICON_SIZE, DESKTOP_ICON_SIZE);
                icon.updateHitbox();
            }
        }

        if (isMouseNearBottom)
        {
            for (i in 0...taskbarIconSprites.length)
            {
                var icon = taskbarIconSprites[i];
                if (FlxG.mouse.overlaps(icon))
                {
                    icon.setGraphicSize(Std.int(TASKBAR_ICON_SIZE * 1.25), Std.int(TASKBAR_ICON_SIZE * 1.25));
                    icon.updateHitbox();

                    if (FlxG.mouse.justPressed)
                    {
                        launchApp(appsData[i].action);
                        return;
                    }
                }
                else
                {
                    icon.setGraphicSize(TASKBAR_ICON_SIZE, TASKBAR_ICON_SIZE);
                    icon.updateHitbox();
                }
            }
        }
    }

    function handleSearchInput():Void
    {
        if (FlxG.keys.justPressed.ESCAPE)
        {
            cancelSearch();
            return;
        }

        if (FlxG.keys.justPressed.ENTER)
        {
            executeSearch(searchQuery);
            return;
        }

        if (FlxG.keys.justPressed.BACKSPACE)
        {
            if (searchQuery.length > 0)
                searchQuery = searchQuery.substr(0, searchQuery.length - 1);
            
            searchTxt.text = searchQuery.length == 0 ? "🔍 |" : '🔍 $searchQuery|';
            return;
        }

        var keysToCheck:Array<FlxKey> = [
            A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z,
            SPACE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, ZERO
        ];

        for (key in keysToCheck)
        {
            if (FlxG.keys.anyJustPressed([key]))
            {
                var char:String = (key == SPACE) ? " " : key.toString().toLowerCase();
                if (searchQuery.length < 20)
                {
                    searchQuery += char;
                    searchTxt.text = '🔍 $searchQuery|';
                }
                break;
            }
        }

        if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(searchBarBg))
        {
            cancelSearch();
        }
    }

    function cancelSearch():Void
    {
        isSearching = false;
        searchQuery = "";
        searchTxt.text = "🔍 Buscar programa...";
        searchTxt.color = FlxColor.GRAY;
    }

    function executeSearch(query:String):Void
    {
        var cleanQuery:String = StringTools.trim(query.toLowerCase());

        switch (cleanQuery)
        {
            case "story", "storymode", "story mode", "youtube", "opera", "opera gx", "operagx", "browser", "historia":
                cancelSearch();
                launchApp("story");

            case "freeplay", "spotify", "musica", "música", "canciones":
                cancelSearch();
                launchApp("freeplay");

            case "flappy", "flappy webones", "flappybird", "juego", "pajarito":
                cancelSearch();
                launchApp("flappy");

            case "options", "ajustes", "opciones", "configuracion", "configuración":
                cancelSearch();
                launchApp("options");

            case "credits", "creditos", "créditos":
                cancelSearch();
                launchApp("credits");

            case "gallery", "galeria", "galería", "fotos":
                cancelSearch();
                launchApp("gallery");

            case "editors", "editor", "master", "chart", "character", "stage":
                cancelSearch();
                launchApp("editors");

            case "mods", "mod", "modmenu":
                cancelSearch();
                launchApp("mods");

            default:
                searchTxt.text = "❌ No encontrado";
                searchTxt.color = FlxColor.RED;
                new flixel.util.FlxTimer().start(1.2, function(_) {
                    cancelSearch();
                });
        }
    }

    function updateTaskbarPosition():Void
    {
        taskbarBg.y = currentTaskbarY;
        startWinBtn.y = currentTaskbarY + 10;
        searchBarBg.y = currentTaskbarY + 10;

        for (spr in taskbarIconsGroup.members)
        {
            spr.y = currentTaskbarY + 10;
        }

        for (txt in taskbarTextGroup.members)
        {
            if (txt == clockText)
                txt.y = currentTaskbarY + 10;
            else
                txt.y = currentTaskbarY + 15;
        }
    }

    override function closeSubState()
    {
        busy = false;
        super.closeSubState();
    }

    function launchApp(action:String):Void
    {
        if (busy) return;

        try {
            var snd = Paths.sound('confirmMenu');
            if (snd != null) FlxG.sound.play(snd);
        } catch (e:Dynamic) {}

        switch (action)
        {
            case "story":
                busy = true;
                MusicBeatState.switchState(new StoryMenuState());

            case "freeplay":
                busy = true;
                openSubState(new FreeplayState());

            case "flappy":
                busy = true;
                MusicBeatState.switchState(new FlappySelectState());

            case "options":
                busy = true;
                MusicBeatState.switchState(new options.OptionsState());

            case "credits":
                trace("Abriendo créditos...");

            case "gallery":
                busy = true;
                MusicBeatState.switchState(new GalleryState());

            case "editors":
                busy = true;
                FlxTransitionableState.skipNextTransIn = false;
                FlxTransitionableState.skipNextTransOut = false;
                MusicBeatState.switchState(new MasterEditorMenu());

            case "mods":
                busy = true;
                MusicBeatState.switchState(new ModsMenuState());
        }
    }
}