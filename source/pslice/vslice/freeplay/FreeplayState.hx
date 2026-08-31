package pslice.vslice.freeplay;

import pslice.compatibility.FunkinControls;
import pslice.compatibility.ModsHelper;
import pslice.compatibility.VsliceOptions;
import pslice.compatibility.FunkinCamera;
import pslice.compatibility.FreeplaySongData;
import pslice.compatibility.FreeplayHelpers;
import pslice.funkin.custom.VsliceSubState as MusicBeatSubstate;
import substates.StickerSubState;
import pslice.funkin.Scoring.ScoringRank;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.keyboard.FlxKey;
import shaders.AngleMask;
import states.PlayState;
import states.MainMenuState;
import backend.WeekData;
import backend.Song;
import backend.Paths;

typedef FreeplayStateParams =
{
    ?fromCharSelect:Bool,
    ?fromResults:FromResultsParams,
};

typedef FromResultsParams =
{
    var ?oldRank:ScoringRank;
    var playRankAnim:Bool;
    var newRank:ScoringRank;
    var songId:String;
    var difficultyId:String;
};

typedef SpotifyPlaylist =
{
    var id:String;
    var title:String;
    var description:String;
    var color:FlxColor;
    var isDJ:Bool;
    var songs:Array<FreeplaySongData>;
}

class FreeplayState extends MusicBeatSubstate
{
    final currentCharacterId:String;

    public var bgDad:FlxSprite;
    public var angleMaskShader:AngleMask = new AngleMask();
    public var busy:Bool = false;
    public static var missingTextBG:FlxSprite;
    public static var missingText:FlxText;
    public var grpCapsules:FlxTypedGroup<SongMenuItem>;
    public var letterSort:LetterSort;
    public var curSelected:Int = 0;

    var allMasterSongs:Array<FreeplaySongData> = [];
    var playlists:Array<SpotifyPlaylist> = [];
    var extraReleasesSongs:Array<FreeplaySongData> = [];
    var activeCarouselSongs:Array<FreeplaySongData> = []; 
    var curPlaylistIdx:Int = 0;

    // Control de Vistas
    var inPlaylistView:Bool = false;
    var selectedPlaylist:SpotifyPlaylist;

    public var funnyCam:FunkinCamera;

    // Fondo Base
    var spotifyBg:FlxSprite;
    var topGlow:FlxSprite;
    var glowTimer:Float = 0;

    // Barra Lateral & Superior
    var sidebarBg:FlxSprite;
    var sidebarThumbsGroup:FlxTypedGroup<FlxSprite>;
    var topBarBg:FlxSprite;
    var navBackBtn:FlxText;
    var navHomeBtn:FlxText;
    var searchBarBg:FlxSprite;
    var searchTxt:FlxText;
    var closeBtnBg:FlxSprite;
    var closeBtn:FlxText;

    // Búsqueda
    var isWritingSearch:Bool = false;
    var searchQuery:String = "";

    // VISTA 1: HOME & RELEASES
    var homeGroup:FlxTypedGroup<FlxBasic>;
    var playlistCards:Array<FlxSprite> = [];
    var playlistSelector:FlxSprite;

    var releasesGroup:FlxTypedGroup<FlxBasic>;
    var releaseCards:Array<FlxSprite> = [];
    var releaseCoverThumbs:Array<FlxSprite> = [];
    var releaseTitleTexts:Array<FlxText> = [];
    var releaseArtistTexts:Array<FlxText> = [];
    var releaseArrowLeft:FlxSprite;
    var releaseArrowRight:FlxSprite;

    var targetReleaseScrollX:Float = 0;
    var currentReleaseScrollX:Float = 0;

    // VISTA 2: DETALLE DE PLAYLIST
    var playlistViewGroup:FlxTypedGroup<FlxBasic>;
    var playlistHeaderBg:FlxSprite;
    var playlistBigThumb:FlxSprite;
    var playlistTitleText:FlxText;
    var playlistDescText:FlxText;
    var playBigBtn:FlxSprite;
    var playBigIcon:FlxSprite;
    var songRowsGroup:FlxTypedGroup<FlxSprite>;
    var songTextsGroup:FlxTypedGroup<FlxText>;
    var songRowSprites:Array<FlxSprite> = [];
    var songRowNums:Array<FlxText> = [];
    var curSongIdx:Int = 0;
    var targetPlaylistScrollY:Float = 0;

    final CARD_WIDTH:Int = 380;
    final CARD_HEIGHT:Int = 70;
    final RELEASE_CARD_SIZE:Int = 135;
    final RELEASE_SPACING:Float = 20;

    public function new(?params:FreeplayStateParams, ?stickers:StickerSubState)
    {
        controls.isInSubstate = true;
        super();
        var saveBox = VsliceOptions.LAST_MOD;
        currentCharacterId = saveBox.char_name;
        if (ModsHelper.isModDirEnabled(saveBox.mod_dir))
            ModsHelper.loadModDir(saveBox.mod_dir);

        super();
    }

    override function create():Void
    {
        funnyCam = new FunkinCamera('freeplayFunny', 0, 0, FlxG.width, FlxG.height);
        funnyCam.alpha = 0;
        FlxG.cameras.add(funnyCam, false);

        bgDad = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.TRANSPARENT);
        bgDad.visible = false;
        add(bgDad);

        grpCapsules = new FlxTypedGroup<SongMenuItem>();
        letterSort = new LetterSort(400, 75);
        letterSort.visible = false;
        add(letterSort);

        super.create();
        FlxG.state.persistentUpdate = false;
        FlxTransitionableState.skipNextTransIn = true;
        FlxG.mouse.visible = true;

        // 1. CARGA DE CANCIONES
        allMasterSongs = FreeplayHelpers.loadSongs();

        var storySongs:Array<FreeplaySongData> = [];
        var diegoSongs:Array<FreeplaySongData> = [];
        var oldSongs:Array<FreeplaySongData> = [];
        var djSongs:Array<FreeplaySongData> = [];
        extraReleasesSongs = [];

        var aqPattern:EReg = ~/^week\d*$/i;
        var dvPattern:EReg = ~/^dvweek\d*$/i;
        var oldPattern:EReg = ~/^oldweek\d*$/i;
        var newPattern:EReg = ~/^newweek\d*$/i;
        var exPattern:EReg = ~/^exweek\d*$/i;

        for (song in allMasterSongs)
        {
            var weekNameStr:String = "";
            try {
                if (WeekData.weeksList != null && song.levelId >= 0 && song.levelId < WeekData.weeksList.length)
                    weekNameStr = WeekData.weeksList[song.levelId];
            } catch(e:Dynamic) {}

            var fileNameLower = weekNameStr.toLowerCase();

            if (aqPattern.match(fileNameLower)) storySongs.push(song);
            else if (dvPattern.match(fileNameLower)) diegoSongs.push(song);
            else if (oldPattern.match(fileNameLower)) oldSongs.push(song);
            else if (newPattern.match(fileNameLower)) extraReleasesSongs.push(song);
            else djSongs.push(song);
        }

        if (storySongs.length == 0) storySongs = allMasterSongs;
        if (diegoSongs.length == 0) diegoSongs = allMasterSongs;
        if (oldSongs.length == 0) oldSongs = allMasterSongs;
        if (djSongs.length == 0) djSongs = allMasterSongs;

        playlists = [
            {
                id: "pl_dj",
                title: "DJ",
                description: "Reproduce una canción aleatoria de los extras.",
                color: FlxColor.fromRGB(30, 180, 90),
                isDJ: true,
                songs: djSongs
            },
            {
                id: "pl_story",
                title: "Storymode",
                description: "Todas las semanas oficiales del modo historia.",
                color: FlxColor.fromRGB(20, 75, 160),
                isDJ: false,
                songs: storySongs
            },
            {
                id: "pl_diego",
                title: "DiegoVerso",
                description: "Directos, especiales y la saga del DiegoVerso.",
                color: FlxColor.fromRGB(130, 30, 110),
                isDJ: false,
                songs: diegoSongs
            },
            {
                id: "pl_old",
                title: "Versiones Anteriores",
                description: "Contenido clásico y versiones antiguas de los mods.",
                color: FlxColor.fromRGB(90, 80, 30),
                isDJ: false,
                songs: oldSongs
            }
        ];

        // 2. BASE VISUAL
        spotifyBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(18, 24, 18));
        spotifyBg.scrollFactor.set(0, 0);
        spotifyBg.cameras = [funnyCam];
        add(spotifyBg);

        var topColor1:FlxColor = FlxColor.fromRGB(28, 65, 38);
        var topColor2:FlxColor = FlxColor.fromRGB(22, 45, 28);
        var topColor3:FlxColor = FlxColor.fromRGB(18, 24, 18, 0);

        topGlow = FlxGradient.createGradientFlxSprite(FlxG.width - 70, 320, [topColor1, topColor2, topColor3]);
        topGlow.x = 70;
        topGlow.y = 0;
        topGlow.scrollFactor.set(0, 0);
        topGlow.cameras = [funnyCam];
        add(topGlow);

        // 3. CAPAS Y GRUPOS
        homeGroup = new FlxTypedGroup<FlxBasic>();
        releasesGroup = new FlxTypedGroup<FlxBasic>();
        playlistViewGroup = new FlxTypedGroup<FlxBasic>();
        songRowsGroup = new FlxTypedGroup<FlxSprite>();
        songTextsGroup = new FlxTypedGroup<FlxText>();

        add(homeGroup);
        add(releasesGroup);
        add(playlistViewGroup);
        add(songRowsGroup);
        add(songTextsGroup);

        playlistSelector = new FlxSprite().makeGraphic(CARD_WIDTH + 8, CARD_HEIGHT + 8, FlxColor.fromRGB(30, 215, 96));
        playlistSelector.alpha = 0.35;
        playlistSelector.cameras = [funnyCam];
        add(playlistSelector);

        // 4. ELEMENTOS PERMANENTES
        sidebarBg = new FlxSprite(0, 0).makeGraphic(70, FlxG.height, FlxColor.fromRGB(12, 12, 12));
        sidebarBg.scrollFactor.set(0, 0);
        sidebarBg.cameras = [funnyCam];
        add(sidebarBg);

        var sidebarIcon:FlxText = new FlxText(22, 15, 0, "≡║D", 16);
        sidebarIcon.setFormat("VCR OSD Mono", 16, FlxColor.GRAY);
        sidebarIcon.scrollFactor.set(0, 0);
        sidebarIcon.cameras = [funnyCam];
        add(sidebarIcon);

        var addBtn:FlxText = new FlxText(26, 45, 0, "+", 22);
        addBtn.setFormat("VCR OSD Mono", 22, FlxColor.GRAY);
        addBtn.scrollFactor.set(0, 0);
        addBtn.cameras = [funnyCam];
        add(addBtn);

        sidebarThumbsGroup = new FlxTypedGroup<FlxSprite>();
        add(sidebarThumbsGroup);

        for (i in 0...playlists.length)
        {
            var sideThumb:FlxSprite = new FlxSprite(13, 90 + (i * 54));
            sideThumb.loadGraphic(backend.Paths.image('lechad'));
            sideThumb.setGraphicSize(44, 44);
            sideThumb.updateHitbox();
            sideThumb.ID = i;
            sideThumb.scrollFactor.set(0, 0);
            sideThumb.cameras = [funnyCam];
            sidebarThumbsGroup.add(sideThumb);
        }

        topBarBg = new FlxSprite(70, 0).makeGraphic(FlxG.width - 70, 50, FlxColor.fromRGB(10, 10, 10));
        topBarBg.scrollFactor.set(0, 0);
        topBarBg.cameras = [funnyCam];
        add(topBarBg);

        navBackBtn = new FlxText(85, 12, 0, "❮", 18);
        navBackBtn.setFormat("VCR OSD Mono", 18, FlxColor.WHITE);
        navBackBtn.scrollFactor.set(0, 0);
        navBackBtn.cameras = [funnyCam];
        add(navBackBtn);

        navHomeBtn = new FlxText(118, 10, 0, "🏠", 18);
        navHomeBtn.setFormat("VCR OSD Mono", 18, FlxColor.WHITE);
        navHomeBtn.scrollFactor.set(0, 0);
        navHomeBtn.cameras = [funnyCam];
        add(navHomeBtn);

        searchBarBg = new FlxSprite(160, 9).makeGraphic(420, 32, FlxColor.fromRGB(32, 32, 32));
        searchBarBg.scrollFactor.set(0, 0);
        searchBarBg.cameras = [funnyCam];
        add(searchBarBg);

        searchTxt = new FlxText(175, 16, 400, "🔍 ¿Qué quieres reproducir?", 13);
        searchTxt.setFormat("VCR OSD Mono", 13, FlxColor.GRAY);
        searchTxt.scrollFactor.set(0, 0);
        searchTxt.cameras = [funnyCam];
        add(searchTxt);

        closeBtnBg = new FlxSprite(FlxG.width - 48, 9).makeGraphic(32, 32, FlxColor.fromRGB(180, 40, 40));
        closeBtnBg.scrollFactor.set(0, 0);
        closeBtnBg.cameras = [funnyCam];
        add(closeBtnBg);

        closeBtn = new FlxText(FlxG.width - 48, 13, 32, "X", 20);
        closeBtn.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        closeBtn.scrollFactor.set(0, 0);
        closeBtn.cameras = [funnyCam];
        add(closeBtn);

        buildHomeView();
        renderBottomCarousel(extraReleasesSongs, "Nuevos lanzamientos para ti", "Música nueva de tus artistas favoritos.");
        showHomeView(true);

        busy = false;
        updateHomeSelection();

        FlxTween.tween(funnyCam, {alpha: 1}, 0.3, {ease: FlxEase.quadOut});
    }

    function buildHomeView():Void
    {
        homeGroup.clear();
        playlistCards = [];

        var cols:Int = 2;
        var spacingX:Float = 25;
        var spacingY:Float = 15;
        var startX:Float = 95;
        var startY:Float = 65;

        for (i in 0...playlists.length)
        {
            var pl = playlists[i];
            var col:Int = i % cols;
            var row:Int = Std.int(i / cols);

            var posX:Float = startX + (col * (CARD_WIDTH + spacingX));
            var posY:Float = startY + (row * (CARD_HEIGHT + spacingY));

            var card:FlxSprite = new FlxSprite(posX, posY).makeGraphic(CARD_WIDTH, CARD_HEIGHT, FlxColor.fromRGB(42, 48, 42));
            card.ID = i;
            card.cameras = [funnyCam];
            homeGroup.add(card);
            playlistCards.push(card);

            var thumb:FlxSprite = new FlxSprite(posX, posY);
            thumb.loadGraphic(backend.Paths.image('lechad'));
            thumb.setGraphicSize(CARD_HEIGHT, CARD_HEIGHT);
            thumb.updateHitbox();
            thumb.cameras = [funnyCam];
            homeGroup.add(thumb);

            var txt:FlxText = new FlxText(posX + CARD_HEIGHT + 15, posY + 24, CARD_WIDTH - CARD_HEIGHT - 20, pl.title, 16);
            txt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            txt.cameras = [funnyCam];
            homeGroup.add(txt);
        }
    }

    function renderBottomCarousel(songList:Array<FreeplaySongData>, titleStr:String, subTitleStr:String):Void
    {
        activeCarouselSongs = songList;
        targetReleaseScrollX = 0;
        currentReleaseScrollX = 0;

        for (member in releasesGroup.members)
        {
            if (member != null) member.destroy();
        }
        releasesGroup.clear();
        releaseCards = [];
        releaseCoverThumbs = [];
        releaseTitleTexts = [];
        releaseArtistTexts = [];

        var sectionY:Float = 245;

        var subHeaderTxt:FlxText = new FlxText(95, sectionY, 0, subTitleStr, 12);
        subHeaderTxt.setFormat("VCR OSD Mono", 12, FlxColor.fromRGB(180, 180, 180));
        subHeaderTxt.cameras = [funnyCam];
        releasesGroup.add(subHeaderTxt);

        var headerTxt:FlxText = new FlxText(95, sectionY + 18, 0, titleStr, 22);
        headerTxt.setFormat("VCR OSD Mono", 22, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        headerTxt.cameras = [funnyCam];
        releasesGroup.add(headerTxt);

        var uiAssets = backend.Paths.getSparrowAtlas('campaign_menu_UI_assets');

        releaseArrowLeft = new FlxSprite(FlxG.width - 90, sectionY + 14);
        releaseArrowLeft.frames = uiAssets;
        releaseArrowLeft.animation.addByPrefix('idle', 'arrow left0000', 24, false);
        releaseArrowLeft.animation.addByPrefix('press', 'arrow push left0000', 24, false);
        releaseArrowLeft.animation.play('idle');
        releaseArrowLeft.setGraphicSize(30, 30);
        releaseArrowLeft.updateHitbox();
        releaseArrowLeft.cameras = [funnyCam];

        releaseArrowRight = new FlxSprite(FlxG.width - 48, sectionY + 14);
        releaseArrowRight.frames = uiAssets;
        releaseArrowRight.animation.addByPrefix('idle', 'arrow right0000', 24, false);
        releaseArrowRight.animation.addByPrefix('press', 'arrow push right0000', 24, false);
        releaseArrowRight.animation.play('idle');
        releaseArrowRight.setGraphicSize(30, 30);
        releaseArrowRight.updateHitbox();
        releaseArrowRight.cameras = [funnyCam];

        releasesGroup.add(releaseArrowLeft);
        releasesGroup.add(releaseArrowRight);

        var startX:Float = 95;
        var cardsY:Float = sectionY + 55;

        for (i in 0...activeCarouselSongs.length)
        {
            var songData = activeCarouselSongs[i];
            var posX:Float = startX + (i * (RELEASE_CARD_SIZE + RELEASE_SPACING));

            var card:FlxSprite = new FlxSprite(posX, cardsY).makeGraphic(RELEASE_CARD_SIZE, RELEASE_CARD_SIZE + 55, FlxColor.fromRGB(24, 28, 24));
            card.ID = i;
            card.cameras = [funnyCam];
            releasesGroup.add(card);
            releaseCards.push(card);

            var thumb:FlxSprite = new FlxSprite(posX, cardsY);
            thumb.loadGraphic(backend.Paths.image('lechad'));
            thumb.setGraphicSize(RELEASE_CARD_SIZE, RELEASE_CARD_SIZE);
            thumb.updateHitbox();
            thumb.cameras = [funnyCam];
            releasesGroup.add(thumb);
            releaseCoverThumbs.push(thumb);

            var songTitleTxt:FlxText = new FlxText(posX, cardsY + RELEASE_CARD_SIZE + 6, RELEASE_CARD_SIZE, songData.songName, 12);
            songTitleTxt.setFormat("VCR OSD Mono", 12, FlxColor.WHITE, LEFT);
            songTitleTxt.cameras = [funnyCam];
            releasesGroup.add(songTitleTxt);
            releaseTitleTexts.push(songTitleTxt);

            var artistTxt:FlxText = new FlxText(posX, cardsY + RELEASE_CARD_SIZE + 24, RELEASE_CARD_SIZE, songData.folder, 11);
            artistTxt.setFormat("VCR OSD Mono", 11, FlxColor.GRAY, LEFT);
            artistTxt.cameras = [funnyCam];
            releasesGroup.add(artistTxt);
            releaseArtistTexts.push(artistTxt);
        }
    }

    function showHomeView(show:Bool):Void
    {
        inPlaylistView = !show;
        homeGroup.visible = show;
        releasesGroup.visible = show;
        playlistSelector.visible = show;
        topGlow.visible = show;

        playlistViewGroup.visible = !show;
        songRowsGroup.visible = !show;
        songTextsGroup.visible = !show;

        if (show)
        {
            funnyCam.scroll.y = 0;
            updateHomeSelection();
        }
    }

    function openPlaylistView(pl:SpotifyPlaylist):Void
    {
        selectedPlaylist = pl;
        curSongIdx = 0;
        targetPlaylistScrollY = 0;
        funnyCam.scroll.y = 0;

        for (member in playlistViewGroup.members)
        {
            if (member != null) member.destroy();
        }
        playlistViewGroup.clear();
        songRowsGroup.clear();
        songTextsGroup.clear();
        songRowSprites = [];
        songRowNums = [];

        var baseCol:FlxColor = pl.color;
        var targetBgCol:FlxColor = FlxColor.fromRGB(18, 18, 18);

        var gradientColors:Array<FlxColor> = [
            baseCol,
            FlxColor.interpolate(baseCol, targetBgCol, 0.2),
            FlxColor.interpolate(baseCol, targetBgCol, 0.45),
            FlxColor.interpolate(baseCol, targetBgCol, 0.7),
            FlxColor.interpolate(baseCol, targetBgCol, 0.9),
            targetBgCol
        ];

        playlistHeaderBg = FlxGradient.createGradientFlxSprite(FlxG.width - 70, 520, gradientColors);
        playlistHeaderBg.x = 70;
        playlistHeaderBg.y = 0;
        playlistHeaderBg.cameras = [funnyCam];
        playlistViewGroup.add(playlistHeaderBg);

        playlistBigThumb = new FlxSprite(95, 65).loadGraphic(backend.Paths.image('lechad'));
        playlistBigThumb.setGraphicSize(130, 130);
        playlistBigThumb.updateHitbox();
        playlistBigThumb.cameras = [funnyCam];
        playlistViewGroup.add(playlistBigThumb);

        var tagTxt:FlxText = new FlxText(240, 70, 0, "PLAYLIST PÚBLICA", 11);
        tagTxt.setFormat("VCR OSD Mono", 11, FlxColor.WHITE);
        tagTxt.cameras = [funnyCam];
        playlistViewGroup.add(tagTxt);

        playlistTitleText = new FlxText(240, 88, FlxG.width - 520, pl.title, 32);
        playlistTitleText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        playlistTitleText.cameras = [funnyCam];
        playlistViewGroup.add(playlistTitleText);

        playlistDescText = new FlxText(240, 135, FlxG.width - 520, pl.description, 12);
        playlistDescText.setFormat("VCR OSD Mono", 12, FlxColor.fromRGB(200, 200, 200));
        playlistDescText.cameras = [funnyCam];
        playlistViewGroup.add(playlistDescText);

        // BOTÓN PLAY CIRCULAR
        playBigBtn = new FlxSprite(95, 225);
        playBigBtn.makeGraphic(52, 52, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawCircle(playBigBtn, 26, 26, 26, FlxColor.fromRGB(30, 215, 96));
        playBigBtn.cameras = [funnyCam];
        playlistViewGroup.add(playBigBtn);

        // ÍCONO PLAY NEGRO DENTRO DEL CÍRCULO
        playBigIcon = new FlxSprite(108, 237);
        playBigIcon.frames = backend.Paths.getSparrowAtlas('campaign_menu_UI_assets');
        playBigIcon.animation.addByPrefix('idle', 'arrow right0000', 24, false);
        playBigIcon.animation.play('idle');
        playBigIcon.setGraphicSize(26, 26);
        playBigIcon.updateHitbox();
        playBigIcon.color = FlxColor.BLACK;
        playBigIcon.cameras = [funnyCam];
        playlistViewGroup.add(playBigIcon);

        var tableHeader:FlxText = new FlxText(95, 295, FlxG.width - 140, "#    TÍTULO                                           MÚSICO                                       🕒", 12);
        tableHeader.setFormat("VCR OSD Mono", 12, FlxColor.GRAY);
        tableHeader.cameras = [funnyCam];
        playlistViewGroup.add(tableHeader);

        var divider:FlxSprite = new FlxSprite(95, 315).makeGraphic(FlxG.width - 120, 1, FlxColor.fromRGB(50, 50, 60));
        divider.cameras = [funnyCam];
        playlistViewGroup.add(divider);

        var startY:Float = 325;
        var rowHeight:Float = 45;

        for (i in 0...pl.songs.length)
        {
            var songData = pl.songs[i];
            var posY:Float = startY + (i * rowHeight);

            var rowBg:FlxSprite = new FlxSprite(95, posY).makeGraphic(FlxG.width - 120, 40, FlxColor.fromRGB(24, 24, 28));
            rowBg.alpha = 0.5;
            rowBg.ID = i;
            rowBg.cameras = [funnyCam];
            songRowsGroup.add(rowBg);
            songRowSprites.push(rowBg);

            var numTxt:FlxText = new FlxText(108, posY + 12, 20, '${i + 1}', 13);
            numTxt.setFormat("VCR OSD Mono", 13, FlxColor.GRAY, CENTER);
            numTxt.cameras = [funnyCam];
            songTextsGroup.add(numTxt);
            songRowNums.push(numTxt);

            var miniThumb:FlxSprite = new FlxSprite(135, posY + 4).loadGraphic(backend.Paths.image('lechad'));
            miniThumb.setGraphicSize(32, 32);
            miniThumb.updateHitbox();
            miniThumb.cameras = [funnyCam];
            songRowsGroup.add(miniThumb);

            var songTitleTxt:FlxText = new FlxText(175, posY + 12, 300, songData.songName, 13);
            songTitleTxt.setFormat("VCR OSD Mono", 13, FlxColor.WHITE);
            songTitleTxt.cameras = [funnyCam];
            songTextsGroup.add(songTitleTxt);

            var musicianTxt:FlxText = new FlxText(550, posY + 12, 200, songData.folder, 12);
            musicianTxt.setFormat("VCR OSD Mono", 12, FlxColor.GRAY);
            musicianTxt.cameras = [funnyCam];
            songTextsGroup.add(musicianTxt);

            var fakeSecs:Int = (i * 17 + 15) % 45 + 10;
            var durationStr:String = '2:${fakeSecs < 10 ? "0" + fakeSecs : "" + fakeSecs}';
            var durationTxt:FlxText = new FlxText(FlxG.width - 140, posY + 12, 0, durationStr, 12);
            durationTxt.setFormat("VCR OSD Mono", 12, FlxColor.GRAY, RIGHT);
            durationTxt.cameras = [funnyCam];
            songTextsGroup.add(durationTxt);
        }

        showHomeView(false);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        glowTimer += elapsed * 1.5;
        if (topGlow != null && topGlow.visible)
        {
            topGlow.scale.y = 1.0 + (Math.sin(glowTimer) * 0.3);
            topGlow.updateHitbox();
            topGlow.y = 0;
        }

        if (FlxG.mouse.justPressed && !isWritingSearch)
        {
            if (FlxG.mouse.overlaps(closeBtn, funnyCam) || FlxG.mouse.overlaps(closeBtnBg, funnyCam))
            {
                exitMenu();
                return;
            }

            if (FlxG.mouse.overlaps(navHomeBtn, funnyCam) || FlxG.mouse.overlaps(navBackBtn, funnyCam))
            {
                if (inPlaylistView) showHomeView(true);
                else exitMenu();
                return;
            }

            for (thumb in sidebarThumbsGroup.members)
            {
                if (FlxG.mouse.overlaps(thumb, funnyCam))
                {
                    curPlaylistIdx = thumb.ID;
                    openSelectedPlaylist();
                    return;
                }
            }
        }

        // --- MODO 1: HOME ---
        if (!inPlaylistView)
        {
            funnyCam.scroll.y = 0;
            currentReleaseScrollX = FlxMath.lerp(currentReleaseScrollX, targetReleaseScrollX, elapsed * 12);
            updateReleasesPositions();

            if (busy) return;

            if (FlxG.mouse.justPressed)
            {
                if (FlxG.mouse.overlaps(searchBarBg, funnyCam) || FlxG.mouse.overlaps(searchTxt, funnyCam))
                    isWritingSearch = true;
                else
                    isWritingSearch = false;
                updateSearchText();
            }

            if (isWritingSearch)
            {
                handleSearchTyping();
                return;
            }

            var totalReleasesWidth:Float = activeCarouselSongs.length * (RELEASE_CARD_SIZE + RELEASE_SPACING);
            var maxReleaseScroll:Float = Math.max(0, totalReleasesWidth - (FlxG.width - 120));

            releaseArrowLeft.visible = (currentReleaseScrollX < -10);
            releaseArrowRight.visible = (totalReleasesWidth > (FlxG.width - 120) && currentReleaseScrollX > -maxReleaseScroll + 10);

            if (FlxG.mouse.justPressed)
            {
                if (releaseArrowLeft.visible && FlxG.mouse.overlaps(releaseArrowLeft, funnyCam))
                {
                    scrollReleases(1);
                    return;
                }
                if (releaseArrowRight.visible && FlxG.mouse.overlaps(releaseArrowRight, funnyCam))
                {
                    scrollReleases(-1);
                    return;
                }
            }

            var cardsY:Float = 300;
            if (FlxG.mouse.y >= cardsY && FlxG.mouse.y <= cardsY + RELEASE_CARD_SIZE + 55)
            {
                for (i in 0...releaseCards.length)
                {
                    var card = releaseCards[i];
                    if (FlxG.mouse.x >= card.x && FlxG.mouse.x <= card.x + card.width && FlxG.mouse.justPressed)
                    {
                        launchReleaseSong(activeCarouselSongs[i]);
                        return;
                    }
                }
            }

            if (controls.UI_LEFT_P) changeHomeSelection(-1);
            if (controls.UI_RIGHT_P) changeHomeSelection(1);
            if (controls.UI_UP_P) changeHomeSelection(-2);
            if (controls.UI_DOWN_P) changeHomeSelection(2);

            if (FlxG.mouse.justMoved || FlxG.mouse.justPressed)
            {
                for (i in 0...playlistCards.length)
                {
                    var card = playlistCards[i];
                    if (FlxG.mouse.overlaps(card, funnyCam))
                    {
                        if (curPlaylistIdx != i)
                        {
                            curPlaylistIdx = i;
                            updateHomeSelection();
                        }
                        if (FlxG.mouse.justPressed) openSelectedPlaylist();
                    }
                }
            }

            if (controls.ACCEPT) openSelectedPlaylist();
            if (controls.BACK || FlxG.keys.justPressed.ESCAPE) exitMenu();
        }
        // --- MODO 2: DETALLE DE PLAYLIST ---
        else
        {
            if (!busy && FlxG.mouse.wheel != 0)
            {
                var totalContentHeight:Float = 325 + (selectedPlaylist.songs.length * 45) + 30;
                var maxScrollY:Float = Math.max(0, totalContentHeight - FlxG.height);
                targetPlaylistScrollY -= FlxG.mouse.wheel * 90;
                targetPlaylistScrollY = FlxMath.bound(targetPlaylistScrollY, 0, maxScrollY);
            }

            if (!busy)
            {
                funnyCam.scroll.y = FlxMath.lerp(funnyCam.scroll.y, targetPlaylistScrollY, elapsed * 10);
            }

            if (busy) return;

            var mouseWorldY:Float = FlxG.mouse.y + funnyCam.scroll.y;

            // Click en el botón play verde superior
            if (FlxG.mouse.justPressed && selectedPlaylist != null && selectedPlaylist.songs.length > 0)
            {
                if (FlxG.mouse.overlaps(playBigBtn, funnyCam) || FlxG.mouse.overlaps(playBigIcon, funnyCam))
                {
                    launchReleaseSong(selectedPlaylist.songs[0]);
                    return;
                }
            }

            for (i in 0...songRowSprites.length)
            {
                var row = songRowSprites[i];
                var numTxt = songRowNums[i];

                if (FlxG.mouse.x >= row.x && FlxG.mouse.x <= row.x + row.width &&
                    mouseWorldY >= row.y && mouseWorldY <= row.y + row.height)
                {
                    numTxt.text = "▶";
                    numTxt.color = FlxColor.fromRGB(30, 215, 96);
                    row.alpha = 0.95;

                    if (curSongIdx != i) curSongIdx = i;
                    if (FlxG.mouse.justPressed) launchReleaseSong(selectedPlaylist.songs[curSongIdx]);
                }
                else
                {
                    numTxt.text = '${i + 1}';
                    numTxt.color = FlxColor.GRAY;
                    row.alpha = 0.4;
                }
            }

            if (controls.BACK || FlxG.keys.justPressed.ESCAPE)
            {
                showHomeView(true);
            }
        }
    }

    function updateSearchText():Void
    {
        if (searchQuery == "" && !isWritingSearch)
        {
            searchTxt.text = "🔍 ¿Qué quieres reproducir?";
            searchTxt.color = FlxColor.GRAY;
        }
        else
        {
            searchTxt.text = "🔍 " + searchQuery + (isWritingSearch ? "|" : "");
            searchTxt.color = FlxColor.WHITE;
        }
    }

    function handleSearchTyping():Void
    {
        if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE)
        {
            isWritingSearch = false;
            updateSearchText();
            return;
        }

        if (FlxG.keys.justPressed.BACKSPACE)
        {
            if (searchQuery.length > 0)
            {
                searchQuery = searchQuery.substr(0, searchQuery.length - 1);
                updateSearchText();
                onSearchQueryChanged();
            }
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
                if (searchQuery.length < 30)
                {
                    searchQuery += charStr;
                    updateSearchText();
                    onSearchQueryChanged();
                }
                break;
            }
        }
    }

    function onSearchQueryChanged():Void
    {
        if (searchQuery.length == 0)
        {
            renderBottomCarousel(extraReleasesSongs, "Nuevos lanzamientos para ti", "Música nueva de tus artistas favoritos.");
        }
        else
        {
            var cleanQuery = StringTools.trim(searchQuery.toLowerCase());
            var results:Array<FreeplaySongData> = [];

            for (song in allMasterSongs)
            {
                if (song.songName.toLowerCase().indexOf(cleanQuery) != -1 || song.folder.toLowerCase().indexOf(cleanQuery) != -1)
                {
                    results.push(song);
                }
            }

            if (results.length > 0)
                renderBottomCarousel(results, 'Resultados para "$searchQuery"', "Canciones encontradas en tus listas.");
            else
                renderBottomCarousel([], 'Resultados para "$searchQuery"', "No se encontró ninguna coincidencia.");
        }
    }

    function scrollReleases(dir:Int):Void
    {
        var totalReleasesWidth:Float = activeCarouselSongs.length * (RELEASE_CARD_SIZE + RELEASE_SPACING);
        var maxReleaseScroll:Float = Math.max(0, totalReleasesWidth - (FlxG.width - 120));

        targetReleaseScrollX += dir * (RELEASE_CARD_SIZE + RELEASE_SPACING) * 2;
        targetReleaseScrollX = FlxMath.bound(targetReleaseScrollX, -maxReleaseScroll, 0);

        if (dir > 0 && releaseArrowLeft != null)
        {
            releaseArrowLeft.animation.play('press');
            new flixel.util.FlxTimer().start(0.15, function(_) {
                if (releaseArrowLeft != null) releaseArrowLeft.animation.play('idle');
            });
        }
        else if (dir < 0 && releaseArrowRight != null)
        {
            releaseArrowRight.animation.play('press');
            new flixel.util.FlxTimer().start(0.15, function(_) {
                if (releaseArrowRight != null) releaseArrowRight.animation.play('idle');
            });
        }

        try {
            var snd = backend.Paths.sound('scrollMenu');
            if (snd != null) FlxG.sound.play(snd);
        } catch (e:Dynamic) {}
    }

    function updateReleasesPositions():Void
    {
        var startX:Float = 95;

        for (i in 0...releaseCards.length)
        {
            var posX:Float = startX + (i * (RELEASE_CARD_SIZE + RELEASE_SPACING)) + currentReleaseScrollX;

            releaseCards[i].x = posX;
            releaseCoverThumbs[i].x = posX;
            releaseTitleTexts[i].x = posX;
            releaseArtistTexts[i].x = posX;
        }
    }

    function openSelectedPlaylist():Void
    {
        var pl = playlists[curPlaylistIdx];

        if (pl.isDJ)
        {
            if (pl.songs.length > 0 && !busy)
            {
                var randomSong:FreeplaySongData = pl.songs[FlxG.random.int(0, pl.songs.length - 1)];
                launchReleaseSong(randomSong);
            }
            return;
        }

        openPlaylistView(pl);
    }

    public function launchReleaseSong(songData:FreeplaySongData):Void
    {
        if (songData == null || busy) return;
        busy = true;

        try {
            var snd = backend.Paths.sound('confirmMenu');
            if (snd != null) FlxG.sound.play(snd);
        } catch (e:Dynamic) {}

        PlayState.isStoryMode = false;
        PlayState.storyWeek = songData.levelId;
        PlayState.storyDifficulty = 2;

        var cleanSongName:String = backend.Paths.formatToSongPath(songData.songName);

        try {
            PlayState.SONG = backend.Song.loadFromJson(cleanSongName + '-hard', cleanSongName);
        } catch (e:Dynamic) {
            try {
                PlayState.SONG = backend.Song.loadFromJson(cleanSongName, cleanSongName);
            } catch (e2:Dynamic) {
                PlayState.SONG = backend.Song.loadFromJson(songData.songName.toLowerCase() + '-hard', songData.songName.toLowerCase());
            }
        }

        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();

        // En lugar de switchState directo, invocamos la pantalla de carga visual:
        states.LoadingState.loadAndSwitchState(new states.PlayState(), true, true);
    }

    function exitMenu():Void
    {
        if (busy) return;
        busy = true;

        try {
            var snd = backend.Paths.sound('cancelMenu');
            if (snd != null) FlxG.sound.play(snd);
        } catch (e:Dynamic) {}

        FlxTween.tween(funnyCam, {alpha: 0}, 0.3, {
            ease: FlxEase.cubeIn,
            onComplete: function(_) {
                close();
            }
        });
    }

    function changeHomeSelection(change:Int):Void
    {
        curPlaylistIdx = FlxMath.wrap(curPlaylistIdx + change, 0, playlists.length - 1);

        try {
            var snd = backend.Paths.sound('scrollMenu');
            if (snd != null) FlxG.sound.play(snd);
        } catch (e:Dynamic) {}

        updateHomeSelection();
    }

    function updateHomeSelection():Void
    {
        var card = playlistCards[curPlaylistIdx];
        if (card != null)
        {
            playlistSelector.x = card.x - 4;
            playlistSelector.y = card.y - 4;
        }
    }

    public static function build(?params:FreeplayStateParams, ?stickers:StickerSubState):MusicBeatState
    {
        var result:MainMenuState;
        if (params?.fromResults?.playRankAnim == true)
            result = new MainMenuState(true);
        else
            result = new MainMenuState(false);
        result.openSubState(new FreeplayState(params, stickers));
        result.persistentUpdate = false;
        result.persistentDraw = true;
        return result;
    }

    override public function destroy():Void
    {
        controls.isInSubstate = false;
        super.destroy();
        FlxG.cameras.remove(funnyCam);
    }
}

typedef ExitMoverData = Map<Array<FlxSprite>, MoveData>;

typedef MoveData =
{
    var ?x:Float;
    var ?y:Float;
    var ?speed:Float;
    var ?wait:Float;
}