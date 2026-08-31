package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.keyboard.FlxKey;
import openfl.display.BitmapData;
import openfl.display.Shape;

import backend.Song;
import backend.WeekData;
import backend.ClientPrefs;
import backend.Highscore;
import states.PlayState;
import states.MainMenuState;

typedef TabItem = {
    var id:Int;
    var title:String;
    var bg:FlxSprite;
    var txt:FlxText;
    var closeBtn:FlxSprite;
    var closeTxt:FlxText;
    var isOpen:Bool;
    var width:Int;
}

class StoryMenuState extends MusicBeatState
{
    public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

    var inSearchHub:Bool = true;

    // Datos de los Canales
    var channelsData:Array<Dynamic> = [
        {
            id: "aquisi",
            name: "AQUISI ✔",
            handle: "@AQUISI_ • 1.85 M de suscriptores",
            desc: "En este canal se subirá todo tipo de contenido que salga de los directos de Kick de AQUINO, ya sean gameplays, reacciones, ...",
            avatar: "storymenu/aqlogo",
            banner: "storymenu/aqbanner"
        },
        {
            id: "diegoverso",
            name: "DIEGOVERSO ✔",
            handle: "@DIEGOVERSO_ • 950 K suscriptores",
            desc: "Contenido variado del Diegoverso, universos alternos, lore y directos especiales.",
            avatar: "storymenu/diegologo",
            banner: "storymenu/diegobanner"
        },
        {
            id: "extras",
            name: "AQUINO EXTRAS ✔",
            handle: "@AQUINO_EXTRAS • 500 K suscriptores",
            desc: "Semanas adicionales, colaboraciones especiales y minijuegos fuera del canon principal.",
            avatar: "storymenu/extraslogo",
            banner: "storymenu/extrasbanner"
        }
    ];

    var curChannelSelected:Int = 0;

    // Listas de semanas por canal
    var aquinoWeeks:Array<Dynamic> = [];
    var diegoversoWeeks:Array<Dynamic> = [];
    var extraWeeks:Array<Dynamic> = [];
    var currentWeeksData:Array<Dynamic> = [];

    var curWeek:Int = 0;   
    var isClosingTab:Bool = false;

    // Fondo Degradado
    var gradientBG:FlxSprite;
    var bgTimer:Float = 0;
    var colorShiftTimer:Float = 0;

    // Cámaras
    var menuCamera:FlxCamera;
    var uiCamera:FlxCamera;

    var targetScrollY:Float = 0;

    // --- SISTEMA DE PESTAÑAS Y NAVEGADOR ---
    var browserBarGroup:FlxTypedGroup<FlxSprite>;
    var browserTextGroup:FlxTypedGroup<FlxText>;
    var tabsList:Array<TabItem> = [];
    var activeTabIdx:Int = 0; // 0 = Buscador, 1 = AQUISI, 2 = DIEGOVERSO, 3 = EXTRAS
    var windowCloseBtn:FlxSprite;
    var winCloseTxt:FlxText;
    var urlText:FlxText;

    // --- BÚSQUEDA INTERACTIVA ---
    var isWritingSearch:Bool = false;
    var searchQuery:String = "aquino";
    var searchInputTxt:FlxText;
    var searchBarBg:FlxSprite;

    // --- ELEMENTOS VISTA 1: BUSCADOR HUB ---
    var hubGroup:FlxTypedGroup<FlxSprite>;
    var hubTextGroup:FlxTypedGroup<FlxText>;
    var hubHitboxes:Array<FlxSprite> = [];
    var channelCardsGroup:FlxTypedGroup<FlxSprite>;
    var channelCardsTextGroup:FlxTypedGroup<FlxText>;
    var filteredChannels:Array<Dynamic> = [];

    // --- ELEMENTOS VISTA 2: CANAL ---
    var headerBg:FlxSprite;
    var bannerSpr:FlxSprite;
    var avatarSpr:FlxSprite;
    var channelNameTxt:FlxText;
    var channelSubscribersTxt:FlxText;
    var channelDescTxt:FlxText;

    var cardSprites:Array<FlxSprite> = [];
    var cardHitboxes:Array<FlxSprite> = [];
    var spinnerSprites:Array<FlxSprite> = [];
    var cardGroup:FlxTypedGroup<FlxSprite>;
    var cardTextGroup:FlxTypedGroup<FlxText>;

    final COLS:Int = 3;
    final CARD_WIDTH:Int = 365;
    final CARD_HEIGHT:Int = 200;
    final SPACING_X:Float = 25;
    final SPACING_Y:Float = 65;

    public function new(param:Dynamic = null) {
        super();
    }

    override public function create()
    {
        // 1. CARGA DE SEMANAS Y Detección por Nombre
        backend.WeekData.reloadWeekFiles(true);
        aquinoWeeks = [];
        diegoversoWeeks = [];
        extraWeeks = [];

        var aqPattern:EReg = ~/^week\d+$/i;
        var dvPattern:EReg = ~/^dvweek\d+$/i;
        var exPattern:EReg = ~/^exweek\d+$/i;

        if (backend.WeekData.weeksList != null)
        {
            for (weekName in backend.WeekData.weeksList)
            {
                var weekFile:backend.WeekData = backend.WeekData.weeksLoaded.get(weekName);
                if (weekFile != null)
                {
                    var songList:Array<String> = [];
                    for (song in weekFile.songs) songList.push(song[0]);

                    var weekDataObj = {
                        title: (weekFile.storyName != null && weekFile.storyName.length > 0) ? weekFile.storyName : weekFile.weekName,
                        songs: songList,
                        fileName: weekName
                    };

                    if (aqPattern.match(weekName)) {
                        aquinoWeeks.push(weekDataObj);
                    } else if (dvPattern.match(weekName)) {
                        diegoversoWeeks.push(weekDataObj);
                    } else if (exPattern.match(weekName)) {
                        extraWeeks.push(weekDataObj);
                    }
                }
            }
        }

        // Fallbacks independientes si aún no existen archivos JSON creados
        if (aquinoWeeks.length == 0)
        {
            aquinoWeeks = [{
                title: "Week 1: Dibujanding",
                songs: ["tutorial", "boopeebo", "fresh"],
                fileName: "week1"
            }];
        }
        if (diegoversoWeeks.length == 0)
        {
            diegoversoWeeks = [{
                title: "DV Week 1: Próximamente",
                songs: ["tutorial"],
                fileName: "dvweek1"
            }];
        }
        if (extraWeeks.length == 0)
        {
            extraWeeks = [{
                title: "EX Week 1: Extras",
                songs: ["tutorial"],
                fileName: "exweek1"
            }];
        }

        super.create();

        FlxG.mouse.visible = true;

        // Cámaras
        menuCamera = new FlxCamera();
        uiCamera = new FlxCamera();
        uiCamera.bgColor.alpha = 0;

        FlxG.cameras.reset(menuCamera);
        FlxG.cameras.add(uiCamera, false);

        // Fondo Degradado
        gradientBG = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height + 350, [
            FlxColor.fromRGB(15, 15, 20),
            FlxColor.fromRGB(0, 120, 180),
            FlxColor.fromRGB(0, 60, 120),
            FlxColor.fromRGB(10, 20, 40)
        ]);
        gradientBG.scrollFactor.set(0, 0);
        gradientBG.cameras = [menuCamera];
        add(gradientBG);

        // Inicializar Capas
        createPersistentBrowserHeader();
        createSearchHubUI();
        createChannelViewUI();

        // Estado Inicial
        showSearchHub(true);
    }

    // --- BARRA DE PESTAÑAS Y NAVEGADOR ---
    function createPersistentBrowserHeader()
    {
        browserBarGroup = new FlxTypedGroup<FlxSprite>();
        browserTextGroup = new FlxTypedGroup<FlxText>();

        browserBarGroup.cameras = [uiCamera];
        browserTextGroup.cameras = [uiCamera];

        var topBarBg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 65, FlxColor.fromRGB(24, 24, 28));
        browserBarGroup.add(topBarBg);

        var tabTitles:Array<String> = ["🔍 Búsqueda", "▶ AQUISI", "▶ DIEGOVERSO", "▶ EXTRAS"];
        var tabWidths:Array<Int> = [115, 120, 135, 120];

        tabsList = [];

        for (i in 0...tabTitles.length)
        {
            var w:Int = tabWidths[i];
            var bg:FlxSprite = new FlxSprite(0, 8).makeGraphic(w, 26, FlxColor.fromRGB(28, 28, 34));
            browserBarGroup.add(bg);

            var txt:FlxText = new FlxText(0, 12, w - 20, tabTitles[i], 11);
            txt.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.GRAY);
            browserTextGroup.add(txt);

            var closeBtn:FlxSprite = new FlxSprite(0, 12).makeGraphic(14, 14, FlxColor.TRANSPARENT);
            browserBarGroup.add(closeBtn);

            var closeTxt:FlxText = new FlxText(0, 12, 14, "x", 11);
            closeTxt.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.fromRGB(150, 150, 150), CENTER);
            browserTextGroup.add(closeTxt);

            tabsList.push({
                id: i,
                title: tabTitles[i],
                bg: bg,
                txt: txt,
                closeBtn: closeBtn,
                closeTxt: closeTxt,
                isOpen: true,
                width: w
            });
        }

        repositionTabs();

        // Botón cerrar navegador completo
        windowCloseBtn = new FlxSprite(FlxG.width - 48, 9).makeGraphic(32, 32, FlxColor.fromRGB(180, 40, 40));
        browserBarGroup.add(windowCloseBtn);

        winCloseTxt = new FlxText(FlxG.width - 48, 13, 32, "X", 20);
        winCloseTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        browserTextGroup.add(winCloseTxt);

        // Barra URL
        var urlBarBg:FlxSprite = new FlxSprite(10, 36).makeGraphic(FlxG.width - 20, 24, FlxColor.fromRGB(16, 16, 20));
        browserBarGroup.add(urlBarBg);

        urlText = new FlxText(20, 40, FlxG.width - 40, "🔒  https://youtube.com/results?search_query=aquino", 12);
        urlText.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(180, 180, 200));
        browserTextGroup.add(urlText);

        add(browserBarGroup);
        add(browserTextGroup);
    }

    function repositionTabs()
    {
        var startX:Float = 10;
        for (tab in tabsList)
        {
            if (tab.isOpen)
            {
                tab.bg.x = startX;
                tab.bg.visible = true;

                tab.txt.x = startX + 6;
                tab.txt.visible = true;

                tab.closeBtn.x = startX + tab.width - 16;
                tab.closeBtn.visible = true;

                tab.closeTxt.x = tab.closeBtn.x;
                tab.closeTxt.visible = true;

                startX += tab.width + 6;
            }
            else
            {
                tab.bg.visible = false;
                tab.txt.visible = false;
                tab.closeBtn.visible = false;
                tab.closeTxt.visible = false;
            }
        }
    }

    function updateTabVisuals(selectedIdx:Int)
    {
        activeTabIdx = selectedIdx;
        for (tab in tabsList)
        {
            if (tab.isOpen)
            {
                if (tab.id == selectedIdx)
                {
                    tab.bg.makeGraphic(tab.width, 26, FlxColor.fromRGB(42, 42, 50));
                    tab.txt.color = FlxColor.WHITE;
                    tab.closeTxt.color = FlxColor.WHITE;
                }
                else
                {
                    tab.bg.makeGraphic(tab.width, 26, FlxColor.fromRGB(28, 28, 34));
                    tab.txt.color = FlxColor.GRAY;
                    tab.closeTxt.color = FlxColor.fromRGB(140, 140, 140);
                }
            }
        }
    }

    function closeTab(tabIdx:Int)
    {
        if (tabIdx < 0 || tabIdx >= tabsList.length) return;

        tabsList[tabIdx].isOpen = false;
        FlxG.sound.play(Paths.sound('cancelMenu'));

        var openCount:Int = 0;
        var firstOpenIdx:Int = -1;

        for (i in 0...tabsList.length)
        {
            if (tabsList[i].isOpen)
            {
                openCount++;
                if (firstOpenIdx == -1) firstOpenIdx = i;
            }
        }

        if (openCount == 0)
        {
            closeTabAndExit();
            return;
        }

        repositionTabs();

        if (activeTabIdx == tabIdx)
        {
            if (firstOpenIdx == 0)
                showSearchHub(true);
            else if (firstOpenIdx > 0)
                openChannel(firstOpenIdx - 1);
        }
    }

    // --- HUB DE BÚSQUEDA YOUTUBE ---
    function createSearchHubUI()
    {
        hubGroup = new FlxTypedGroup<FlxSprite>();
        hubTextGroup = new FlxTypedGroup<FlxText>();
        channelCardsGroup = new FlxTypedGroup<FlxSprite>();
        channelCardsTextGroup = new FlxTypedGroup<FlxText>();

        hubGroup.cameras = [uiCamera];
        hubTextGroup.cameras = [uiCamera];
        channelCardsGroup.cameras = [uiCamera];
        channelCardsTextGroup.cameras = [uiCamera];

        // Barra Búsqueda Interna
        var topBarBg:FlxSprite = new FlxSprite(0, 65).makeGraphic(FlxG.width, 50, FlxColor.fromRGB(15, 15, 15));
        hubGroup.add(topBarBg);

        searchBarBg = new FlxSprite((FlxG.width / 2) - 250, 72).makeGraphic(500, 34, FlxColor.fromRGB(28, 28, 28));
        hubGroup.add(searchBarBg);

        searchInputTxt = new FlxText(searchBarBg.x + 15, 80, 420, searchQuery, 15);
        searchInputTxt.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE);
        hubTextGroup.add(searchInputTxt);

        var searchBtn:FlxSprite = new FlxSprite(searchBarBg.x + searchBarBg.width - 50, 72).makeGraphic(50, 34, FlxColor.fromRGB(38, 38, 38));
        hubGroup.add(searchBtn);

        // Lupa VECTORIAL
        var searchIconSpr:FlxSprite = new FlxSprite(searchBtn.x + 13, searchBtn.y + 5);
        searchIconSpr.loadGraphic(createSearchIconBitmap());
        hubGroup.add(searchIconSpr);

        // Filtros (Con "Canales" seleccionado)
        var chipsBarBg:FlxSprite = new FlxSprite(0, 115).makeGraphic(FlxG.width, 40, FlxColor.fromRGB(15, 15, 15));
        hubGroup.add(chipsBarBg);

        var filterNames:Array<String> = ["Canales", "Semanas", "Subidos recientemente", "En vivo"];
        var chipX:Float = 20;

        for (i in 0...filterNames.length)
        {
            var isSelected:Bool = (i == 0);
            var chipWidth:Int = Std.int(filterNames[i].length * 10 + 24);
            var chipBg:FlxSprite = new FlxSprite(chipX, 121).makeGraphic(chipWidth, 26, isSelected ? FlxColor.WHITE : FlxColor.fromRGB(38, 38, 38));
            hubGroup.add(chipBg);

            var chipTxt:FlxText = new FlxText(chipX, 126, chipWidth, filterNames[i], 11);
            chipTxt.setFormat(Paths.font("vcr.ttf"), 11, isSelected ? FlxColor.BLACK : FlxColor.WHITE, CENTER);
            hubTextGroup.add(chipTxt);

            chipX += chipWidth + 12;
        }

        add(hubGroup);
        add(hubTextGroup);
        add(channelCardsGroup);
        add(channelCardsTextGroup);

        filterAndRenderChannels();
    }

    function filterAndRenderChannels()
    {
        channelCardsGroup.clear();
        channelCardsTextGroup.clear();
        hubHitboxes = [];

        var cleanQuery:String = StringTools.trim(searchQuery.toLowerCase());
        filteredChannels = [];

        for (c in channelsData)
        {
            var cName:String = c.name.toLowerCase();
            var cId:String = c.id.toLowerCase();

            if (cleanQuery == "" || cleanQuery == "aquino" || cleanQuery == "canal" || cleanQuery == "canales")
            {
                filteredChannels.push(c);
            }
            else if (cName.indexOf(cleanQuery) != -1 || cId.indexOf(cleanQuery) != -1)
            {
                filteredChannels.push(c);
            }
        }

        var startY:Float = 175;

        for (i in 0...filteredChannels.length)
        {
            var channel = filteredChannels[i];
            var posY:Float = startY + (i * 150);

            var channelCardBg:FlxSprite = new FlxSprite(35, posY).makeGraphic(FlxG.width - 70, 135, FlxColor.fromRGB(18, 18, 22));
            channelCardBg.alpha = 0.95;
            channelCardsGroup.add(channelCardBg);

            var avatar:FlxSprite = new FlxSprite(55, posY + 17);
            var avatarPath:String = channel.avatar;
            if (!Paths.fileExists('images/' + avatarPath + '.png', IMAGE)) avatarPath = 'storymenu/aqlogo';

            if (Paths.fileExists('images/' + avatarPath + '.png', IMAGE))
                avatar.loadGraphic(Paths.image(avatarPath));
            else
                avatar.makeGraphic(100, 100, FlxColor.fromRGB(60, 60, 70));

            avatar.setGraphicSize(100, 100);
            avatar.updateHitbox();
            avatar.antialiasing = ClientPrefs.data.antialiasing;
            channelCardsGroup.add(avatar);

            var nameTxt:FlxText = new FlxText(175, posY + 16, 500, channel.name, 20);
            nameTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            channelCardsTextGroup.add(nameTxt);

            var handleTxt:FlxText = new FlxText(175, posY + 44, 500, channel.handle, 13);
            handleTxt.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(170, 170, 170));
            channelCardsTextGroup.add(handleTxt);

            var descTxt:FlxText = new FlxText(175, posY + 66, FlxG.width - 400, channel.desc, 12);
            descTxt.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(150, 150, 150));
            channelCardsTextGroup.add(descTxt);

            var subBtn:FlxSprite = new FlxSprite(FlxG.width - 185, posY + 38).makeGraphic(130, 36, FlxColor.WHITE);
            channelCardsGroup.add(subBtn);

            var subTxt:FlxText = new FlxText(subBtn.x, subBtn.y + 10, subBtn.width, "Suscribirse", 13);
            subTxt.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.BLACK, CENTER);
            channelCardsTextGroup.add(subTxt);

            var boxHit:FlxSprite = new FlxSprite(35, posY).makeGraphic(FlxG.width - 70, 135, FlxColor.TRANSPARENT);
            boxHit.ID = i;
            channelCardsGroup.add(boxHit);
            hubHitboxes.push(boxHit);
        }

        if (curChannelSelected >= filteredChannels.length) curChannelSelected = 0;
    }

    // --- VISTA CANAL ---
    function createChannelViewUI()
    {
        headerBg = new FlxSprite(25, 75).makeGraphic(FlxG.width - 50, 230, FlxColor.fromRGB(18, 18, 22));
        headerBg.alpha = 0.95;
        headerBg.cameras = [menuCamera];

        bannerSpr = new FlxSprite(35, 85);
        bannerSpr.cameras = [menuCamera];

        avatarSpr = new FlxSprite(45, 210);
        avatarSpr.cameras = [menuCamera];

        channelNameTxt = new FlxText(130, 212, 0, "", 22);
        channelNameTxt.setFormat(Paths.font("vcr.ttf"), 22, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        channelNameTxt.cameras = [menuCamera];

        channelSubscribersTxt = new FlxText(130, 240, 0, "", 12);
        channelSubscribersTxt.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.GRAY);
        channelSubscribersTxt.cameras = [menuCamera];

        channelDescTxt = new FlxText(130, 258, FlxG.width - 180, "", 12);
        channelDescTxt.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(180, 180, 180));
        channelDescTxt.cameras = [menuCamera];

        cardGroup = new FlxTypedGroup<FlxSprite>();
        cardTextGroup = new FlxTypedGroup<FlxText>();
        cardGroup.cameras = [menuCamera];
        cardTextGroup.cameras = [menuCamera];

        add(headerBg);
        add(bannerSpr);
        add(avatarSpr);
        add(channelNameTxt);
        add(channelSubscribersTxt);
        add(channelDescTxt);
        add(cardGroup);
        add(cardTextGroup);
    }

    function showSearchHub(show:Bool)
    {
        inSearchHub = show;

        hubGroup.visible = show;
        hubTextGroup.visible = show;
        channelCardsGroup.visible = show;
        channelCardsTextGroup.visible = show;

        headerBg.visible = !show;
        bannerSpr.visible = !show;
        avatarSpr.visible = !show;
        channelNameTxt.visible = !show;
        channelSubscribersTxt.visible = !show;
        channelDescTxt.visible = !show;
        cardGroup.visible = !show;
        cardTextGroup.visible = !show;

        if (show)
        {
            tabsList[0].isOpen = true;
            repositionTabs();
            updateTabVisuals(0);
            urlText.text = '🔒  https://youtube.com/results?search_query=$searchQuery';
            menuCamera.scroll.y = 0;
        }
    }

    function openChannel(channelIndex:Int)
    {
        var channel = channelsData[channelIndex];
        curChannelSelected = channelIndex;

        var targetTabIdx:Int = channelIndex + 1;
        tabsList[targetTabIdx].isOpen = true;
        repositionTabs();

        showSearchHub(false);
        updateTabVisuals(targetTabIdx);

        var bannerPath:String = channel.banner;
        if (!Paths.fileExists('images/' + bannerPath + '.png', IMAGE)) bannerPath = 'storymenu/aqbanner';
        bannerSpr.loadGraphic(Paths.image(bannerPath));
        bannerSpr.setGraphicSize(FlxG.width - 70, 115);
        bannerSpr.updateHitbox();

        var avatarPath:String = channel.avatar;
        if (!Paths.fileExists('images/' + avatarPath + '.png', IMAGE)) avatarPath = 'storymenu/aqlogo';
        avatarSpr.loadGraphic(Paths.image(avatarPath));
        avatarSpr.setGraphicSize(70, 70);
        avatarSpr.updateHitbox();

        channelNameTxt.text = channel.name;
        channelSubscribersTxt.text = channel.handle;
        channelDescTxt.text = channel.desc;

        urlText.text = '🔒  https://youtube.com/c/${channel.id}_official/playlists';

        switch (channel.id)
        {
            case "aquisi": currentWeeksData = aquinoWeeks;
            case "diegoverso": currentWeeksData = diegoversoWeeks;
            default: currentWeeksData = extraWeeks;
        }

        curWeek = 0;
        targetScrollY = 0;
        menuCamera.scroll.y = 0;

        buildGrid();
    }

    function buildGrid()
    {
        cardGroup.clear();
        cardTextGroup.clear();
        cardSprites = [];
        cardHitboxes = [];
        spinnerSprites = [];

        var gridStartY:Float = 315;
        var startX:Float = 45;
        var extractNum:EReg = ~/\d+/;

        for (w in 0...currentWeeksData.length)
        {
            var weekInfo = currentWeeksData[w];
            var isLocked:Bool = checkWeekLocked(weekInfo.fileName);

            var col:Int = w % COLS;
            var row:Int = Std.int(w / COLS);

            var posX:Float = startX + (col * (CARD_WIDTH + SPACING_X));
            var posY:Float = gridStartY + (row * (CARD_HEIGHT + SPACING_Y));

            var stackEffect:FlxSprite = new FlxSprite(posX + 10, posY - 6).makeGraphic(CARD_WIDTH - 20, 8, FlxColor.fromRGB(60, 65, 75));
            stackEffect.alpha = 0.7;
            stackEffect.cameras = [menuCamera];
            cardGroup.add(stackEffect);

            var cardThumb:FlxSprite = new FlxSprite(posX, posY);
            var weekNumStr:String = "";
            if (extractNum.match(weekInfo.fileName)) {
                weekNumStr = extractNum.matched(0);
            }

            var fileNameLower:String = weekInfo.fileName.toLowerCase();
            var prefix:String = "playlist_";

            if (fileNameLower.indexOf("dvweek") != -1)
                prefix = "dminiatura";
            else if (fileNameLower.indexOf("exweek") != -1)
                prefix = "exminiatura";

            var playlistImagePath:String = 'storymenu/playlist/' + prefix + weekNumStr;
            var altImagePath:String = 'storymenu/playlist/' + prefix + '_' + weekNumStr;
            var hasLoadedImage:Bool = false;

            if (!isLocked)
            {
                if (weekNumStr != "" && Paths.fileExists('images/' + playlistImagePath + '.png', IMAGE))
                {
                    cardThumb.loadGraphic(Paths.image(playlistImagePath));
                    hasLoadedImage = true;
                }
                else if (weekNumStr != "" && Paths.fileExists('images/' + altImagePath + '.png', IMAGE))
                {
                    cardThumb.loadGraphic(Paths.image(altImagePath));
                    hasLoadedImage = true;
                }
                else if (Paths.fileExists('images/storymenu/' + weekInfo.fileName + '.png', IMAGE))
                {
                    cardThumb.loadGraphic(Paths.image('storymenu/' + weekInfo.fileName));
                    hasLoadedImage = true;
                }
            }

            if (!hasLoadedImage)
            {
                cardThumb.makeGraphic(CARD_WIDTH, CARD_HEIGHT, FlxColor.fromRGB(30, 35, 45));
            }

            cardThumb.setGraphicSize(CARD_WIDTH, CARD_HEIGHT);
            cardThumb.updateHitbox();
            cardThumb.antialiasing = ClientPrefs.data.antialiasing;
            cardThumb.cameras = [menuCamera];

            if (isLocked) cardThumb.color = FlxColor.fromRGB(70, 70, 75);

            cardGroup.add(cardThumb);
            cardSprites.push(cardThumb);

            if (isLocked)
            {
                var spinner:FlxSprite = new FlxSprite();
                var spinnerPath:String = 'storymenu/yt_spinner';

                if (!Paths.fileExists('images/' + spinnerPath + '.png', IMAGE))
                    spinnerPath = 'flappywebones/yt_spinner';

                if (Paths.fileExists('images/' + spinnerPath + '.png', IMAGE))
                {
                    spinner.loadGraphic(Paths.image(spinnerPath));
                }
                else
                {
                    spinner.loadGraphic(createCircularSpinnerBitmap());
                }

                spinner.setGraphicSize(42, 42);
                spinner.updateHitbox();
                spinner.antialiasing = ClientPrefs.data.antialiasing;
                spinner.x = posX + (CARD_WIDTH / 2) - (spinner.width / 2);
                spinner.y = posY + (CARD_HEIGHT / 2) - (spinner.height / 2);
                spinner.cameras = [menuCamera];
                cardGroup.add(spinner);
                spinnerSprites.push(spinner);
            }
            else
            {
                spinnerSprites.push(null);
            }

            var songCount:Int = weekInfo.songs.length;
            var badgeTextStr:String = '≡ $songCount ${songCount == 1 ? "video" : "videos"}';

            var badgeTxt:FlxText = new FlxText(0, 0, 0, badgeTextStr, 11);
            badgeTxt.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.WHITE);
            badgeTxt.cameras = [menuCamera];

            var badgeW:Int = Std.int(badgeTxt.width + 12);
            var badgeH:Int = 22;
            var badgeX:Float = posX + CARD_WIDTH - badgeW - 8;
            var badgeY:Float = posY + CARD_HEIGHT - badgeH - 8;

            var badgeBg:FlxSprite = new FlxSprite(badgeX, badgeY).makeGraphic(badgeW, badgeH, FlxColor.fromRGB(0, 0, 0));
            badgeBg.alpha = 0.82;
            badgeBg.cameras = [menuCamera];
            cardGroup.add(badgeBg);

            badgeTxt.x = badgeX + 6;
            badgeTxt.y = badgeY + 4;
            cardTextGroup.add(badgeTxt);

            var playlistTitle:FlxText = new FlxText(posX, posY + CARD_HEIGHT + 8, CARD_WIDTH, weekInfo.title, 15);
            playlistTitle.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            playlistTitle.cameras = [menuCamera];
            cardTextGroup.add(playlistTitle);

            var subTextStr:String = isLocked ? "🔒 Completa la semana anterior" : "Ver semana completa";
            var playlistSub:FlxText = new FlxText(posX, posY + CARD_HEIGHT + 28, CARD_WIDTH, subTextStr, 12);
            playlistSub.setFormat(Paths.font("vcr.ttf"), 12, isLocked ? FlxColor.fromRGB(220, 80, 80) : FlxColor.fromRGB(160, 160, 160));
            playlistSub.cameras = [menuCamera];
            cardTextGroup.add(playlistSub);

            var clickHitbox:FlxSprite = new FlxSprite(posX, posY).makeGraphic(CARD_WIDTH, CARD_HEIGHT + 45, FlxColor.TRANSPARENT);
            clickHitbox.ID = w;
            clickHitbox.cameras = [menuCamera];
            cardGroup.add(clickHitbox);
            cardHitboxes.push(clickHitbox);
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        bgTimer += elapsed * 3.8;
        if (gradientBG != null) gradientBG.y = (Math.sin(bgTimer) * 85) - 85;

        colorShiftTimer += elapsed * 1.5;
        var crimsonFactor:Float = (Math.sin(colorShiftTimer) * 0.5) + 0.5;
        var crimsonTint:FlxColor = FlxColor.fromRGB(220, 20, 60);
        gradientBG.color = FlxColor.interpolate(FlxColor.WHITE, crimsonTint, crimsonFactor * 0.75);

        // INTERACCIÓN CON RATÓN EN PESTAÑAS Y CERRAR
        if (FlxG.mouse.justPressed)
        {
            if (FlxG.mouse.overlaps(windowCloseBtn, uiCamera) || FlxG.mouse.overlaps(winCloseTxt, uiCamera))
            {
                closeTabAndExit();
                return;
            }

            for (tab in tabsList)
            {
                if (tab.isOpen)
                {
                    if (FlxG.mouse.overlaps(tab.closeBtn, uiCamera) || FlxG.mouse.overlaps(tab.closeTxt, uiCamera))
                    {
                        closeTab(tab.id);
                        return;
                    }

                    if (FlxG.mouse.overlaps(tab.bg, uiCamera))
                    {
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        if (tab.id == 0)
                            showSearchHub(true);
                        else
                            openChannel(tab.id - 1);
                        return;
                    }
                }
            }
        }

        // --- MODO 1: BUSCADOR HUB (MOUSE-ONLY) ---
        if (inSearchHub)
        {
            if (FlxG.mouse.justPressed)
            {
                if (FlxG.mouse.overlaps(searchBarBg, uiCamera))
                {
                    isWritingSearch = true;
                    searchInputTxt.text = searchQuery + "|";
                }
                else
                {
                    isWritingSearch = false;
                    searchInputTxt.text = searchQuery;
                }
            }

            if (isWritingSearch)
            {
                handleSearchTyping();
            }
            else
            {
                if (FlxG.mouse.justPressed)
                {
                    for (i in 0...hubHitboxes.length)
                    {
                        if (FlxG.mouse.overlaps(hubHitboxes[i], uiCamera))
                        {
                            var targetChan = filteredChannels[i];
                            for (cIdx in 0...channelsData.length)
                            {
                                if (channelsData[cIdx].id == targetChan.id)
                                {
                                    openChannel(cIdx);
                                    return;
                                }
                            }
                        }
                    }
                }
            }

            if (FlxG.keys.justPressed.ESCAPE)
            {
                closeTabAndExit();
                return;
            }

            return;
        }

        // --- MODO 2: CANAL (MOUSE-ONLY) ---
        for (spinner in spinnerSprites)
        {
            if (spinner != null) spinner.angle += 360 * elapsed;
        }

        if (isClosingTab) return;

        if (FlxG.mouse.wheel != 0)
        {
            targetScrollY -= FlxG.mouse.wheel * 130;
            var totalRows:Int = Math.ceil(currentWeeksData.length / COLS);
            var maxScrollY:Float = Math.max(0, (totalRows * (CARD_HEIGHT + SPACING_Y)) - FlxG.height + 360);
            targetScrollY = FlxMath.bound(targetScrollY, 0, maxScrollY);
        }

        menuCamera.scroll.y = FlxMath.lerp(menuCamera.scroll.y, targetScrollY, elapsed * 10);

        for (i in 0...cardHitboxes.length)
        {
            var box = cardHitboxes[i];
            if (FlxG.mouse.overlaps(box, menuCamera))
            {
                if (curWeek != i)
                {
                    curWeek = i;
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                }

                if (FlxG.mouse.justPressed)
                {
                    startWeek();
                }
            }
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            showSearchHub(true);
        }
    }

    function handleSearchTyping()
    {
        if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE)
        {
            isWritingSearch = false;
            searchInputTxt.text = searchQuery;
            filterAndRenderChannels();
            urlText.text = '🔒  https://youtube.com/results?search_query=$searchQuery';
            return;
        }

        if (FlxG.keys.justPressed.BACKSPACE)
        {
            if (searchQuery.length > 0)
                searchQuery = searchQuery.substr(0, searchQuery.length - 1);

            searchInputTxt.text = searchQuery + "|";
            filterAndRenderChannels();
            urlText.text = '🔒  https://youtube.com/results?search_query=$searchQuery';
            return;
        }

        var keysToCheck:Array<FlxKey> = [
            A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z,
            SPACE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, ZERO
        ];

        for (k in keysToCheck)
        {
            if (FlxG.keys.anyJustPressed([k]))
            {
                var charStr:String = (k == SPACE) ? " " : k.toString().toLowerCase();
                if (searchQuery.length < 24)
                {
                    searchQuery += charStr;
                    searchInputTxt.text = searchQuery + "|";
                    filterAndRenderChannels();
                    urlText.text = '🔒  https://youtube.com/results?search_query=$searchQuery';
                }
                break;
            }
        }
    }

    function closeTabAndExit()
    {
        if (isClosingTab) return;
        isClosingTab = true;

        FlxG.sound.play(Paths.sound('cancelMenu'));

        FlxTween.tween(menuCamera, {alpha: 0}, 0.3, {
            onComplete: function(twn:FlxTween) {
                MusicBeatState.switchState(new MainMenuState());
            }
        });
    }

    function startWeek()
    {
        var weekInfo = currentWeeksData[curWeek];
        if (weekInfo == null || checkWeekLocked(weekInfo.fileName))
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            return;
        }

        FlxG.sound.play(Paths.sound('confirmMenu'));

        PlayState.storyPlaylist = weekInfo.songs;
        PlayState.isStoryMode = true;

        var selectedSongName:String = PlayState.storyPlaylist[0];
        var diffSuffix:String = "-hard";

        PlayState.SONG = Song.loadFromJson(selectedSongName.toLowerCase() + diffSuffix, selectedSongName.toLowerCase());
        PlayState.storyWeek = curWeek;
        PlayState.campaignScore = 0;

        LoadingState.loadAndSwitchState(new PlayState());
    }

    function checkWeekLocked(weekName:String):Bool
    {
        var weekFile:backend.WeekData = backend.WeekData.weeksLoaded.get(weekName);
        if (weekFile == null) return false;

        if (weekFile.startUnlocked) return false;

        if (weekFile.weekBefore != null && weekFile.weekBefore.length > 0)
        {
            var reqWeek:String = weekFile.weekBefore.toLowerCase();

            var isCompleted:Bool = StoryMenuState.weekCompleted.exists(reqWeek) && StoryMenuState.weekCompleted.get(reqWeek);

            if (!isCompleted)
            {
                isCompleted = (backend.Highscore.getWeekScore(reqWeek, 0) > 0 || 
                               backend.Highscore.getWeekScore(reqWeek, 1) > 0 || 
                               backend.Highscore.getWeekScore(reqWeek, 2) > 0);
            }

            return !isCompleted;
        }

        return false;
    }

    function createCircularSpinnerBitmap():BitmapData
    {
        var size:Int = 44;
        var shape:Shape = new Shape();
        shape.graphics.lineStyle(4, 0xFFFFFFFF);
        
        var cx:Float = size / 2;
        var cy:Float = size / 2;
        var radius:Float = 16;
        var startAngle:Float = 0;
        var endAngle:Float = (Math.PI * 2) * 0.75;

        shape.graphics.moveTo(cx + radius * Math.cos(startAngle), cy + radius * Math.sin(startAngle));
        for (i in 1...31)
        {
            var angle:Float = startAngle + (endAngle - startAngle) * (i / 30);
            shape.graphics.lineTo(cx + radius * Math.cos(angle), cy + radius * Math.sin(angle));
        }

        var bmp:BitmapData = new BitmapData(size, size, true, 0x00000000);
        bmp.draw(shape);
        return bmp;
    }

    function createSearchIconBitmap():BitmapData
    {
        var size:Int = 24;
        var shape:Shape = new Shape();
        shape.graphics.lineStyle(2.5, 0xFFFFFFFF);

        shape.graphics.drawCircle(9, 9, 6);

        shape.graphics.moveTo(13.5, 13.5);
        shape.graphics.lineTo(20, 20);

        var bmp:BitmapData = new BitmapData(size, size, true, 0x00000000);
        bmp.draw(shape);
        return bmp;
    }
}