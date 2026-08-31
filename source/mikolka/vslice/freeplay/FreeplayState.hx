package pslice.vslice.freeplay;

import pslice.compatibility.FunkinControls;
import pslice.vslice.charSelect.CharSelectSubState;
import openfl.filters.ShaderFilter;
import pslice.funkin.freeplay.FreeplayStyleRegistry;
import pslice.funkin.freeplay.FreeplayStyle;
import pslice.compatibility.ModsHelper;
import pslice.compatibility.VsliceOptions;
import pslice.compatibility.FunkinCamera;
import pslice.vslice.freeplay.pslice.BPMCache;
import pslice.compatibility.FreeplaySongData;
import pslice.compatibility.FreeplayHelpers;
import pslice.compatibility.FunkinPath as Paths;
import pslice.funkin.custom.VsliceSubState as MusicBeatSubstate;
import substates.StickerSubState;
import pslice.funkin.Scoring.ScoringRank;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import states.PlayState;
import states.MainMenuState;

using pslice.funkin.custom.FunkinTools;
using pslice.funkin.utils.ArrayTools;

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

class FreeplayState extends MusicBeatSubstate
{
	final currentCharacterId:String;

	public static final FADE_IN_DURATION:Float = 1.5;
	public static final FADE_IN_START_VOLUME:Float = 0;
	public static final FADE_IN_END_VOLUME:Float = 0.8;

	var songs:Array<Null<FreeplaySongData>> = [];
	var diffIdsCurrent:Array<String> = [];
	var diffIdsTotal:Array<String> = ['easy', "normal", "hard"];

	var curSelected:Int = 0;
	var currentDifficulty:String = 'hard';

	public static var rememberedDifficulty:String = 'hard';
	public static var rememberedSongId:Null<String> = 'tutorial';

	var funnyCam:FunkinCamera;

	// --- ELEMENTOS SPOTIFY ---
	var spotifyBg:FlxSprite;
	var spotifyCardsGroup:FlxTypedGroup<FlxSprite>;
	var spotifyTextsGroup:FlxTypedGroup<FlxText>;
	var spotifySelector:FlxSprite;

	// Player Bar Inferior
	var bottomPlayerBg:FlxSprite;
	var spotifySongTitleText:FlxText;
	var spotifyArtistText:FlxText;
	var spotifyProgressBar:FlxSprite;

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
		FlxG.cameras.add(funnyCam, false);

		super.create();
		FlxG.state.persistentUpdate = false;
		FlxTransitionableState.skipNextTransIn = true;
		FlxG.mouse.visible = true;

		// Cargar lista de canciones de los mods/json
		songs.push(null); // Random
		PlayState.isStoryMode = false;

		for (sngCard in FreeplayHelpers.loadSongs())
		{
			songs.push(sngCard);
			for (difficulty in sngCard.songDifficulties)
			{
				diffIdsTotal.pushUnique(difficulty);
			}
		}

		// --- 1. FONDO DE SPOTIFY ---
		spotifyBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(18, 18, 18));
		add(spotifyBg);

		var topGreenGlow:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 220, FlxColor.fromRGB(22, 45, 28));
		topGreenGlow.alpha = 0.6;
		add(topGreenGlow);

		// Barra lateral izquierda
		var sidebarBg:FlxSprite = new FlxSprite(0, 0).makeGraphic(70, FlxG.height - 90, FlxColor.fromRGB(12, 12, 12));
		add(sidebarBg);

		var sidebarIcon:FlxText = new FlxText(22, 20, 0, "≡║D", 16);
		sidebarIcon.setFormat("VCR OSD Mono", 16, FlxColor.GRAY);
		add(sidebarIcon);

		// Barra de Búsqueda superior
		var searchBar:FlxSprite = new FlxSprite(360, 15).makeGraphic(360, 35, FlxColor.fromRGB(35, 35, 35));
		add(searchBar);

		var searchTxt:FlxText = new FlxText(380, 24, 0, "🔍 ¿Qué quieres reproducir?", 14);
		searchTxt.setFormat("VCR OSD Mono", 14, FlxColor.GRAY);
		add(searchTxt);

		var sectionTitle:FlxText = new FlxText(90, 65, 0, "Vuelve a tu música (Freeplay)", 24);
		sectionTitle.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		add(sectionTitle);

		// --- 2. GRUPO DE TARJETAS SPOTIFY ---
		spotifyCardsGroup = new FlxTypedGroup<FlxSprite>();
		spotifyTextsGroup = new FlxTypedGroup<FlxText>();
		add(spotifyCardsGroup);
		add(spotifyTextsGroup);

		// Selector verde de Spotify
		spotifySelector = new FlxSprite().makeGraphic(188, 188, FlxColor.fromRGB(30, 215, 96));
		spotifySelector.alpha = 0.4;
		add(spotifySelector);

		// --- 3. BARRA INFERIOR REPRODUCTOR ---
		createSpotifyPlayerBar();

		// Generar la parrilla gráfica de Spotify
		buildSpotifyGrid();

		// Asignar cámara unificada
		forEach(function(spr:FlxSprite) {
			spr.cameras = [funnyCam];
		});

		busy = false;
		changeSelection(0);
	}

	function createSpotifyPlayerBar():Void
	{
		bottomPlayerBg = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, FlxColor.fromRGB(10, 10, 10));
		add(bottomPlayerBg);

		var thumbBg:FlxSprite = new FlxSprite(15, FlxG.height - 75).makeGraphic(60, 60, FlxColor.fromRGB(40, 40, 50));
		add(thumbBg);

		spotifySongTitleText = new FlxText(90, FlxG.height - 68, 300, "Selecciona una canción", 15);
		spotifySongTitleText.setFormat("VCR OSD Mono", 15, FlxColor.WHITE, LEFT);
		add(spotifySongTitleText);

		spotifyArtistText = new FlxText(90, FlxG.height - 48, 300, "Friday Night Funkin'", 12);
		spotifyArtistText.setFormat("VCR OSD Mono", 12, FlxColor.GRAY, LEFT);
		add(spotifyArtistText);

		var playPauseBtn:FlxText = new FlxText(FlxG.width / 2 - 12, FlxG.height - 70, 0, "⏸", 22);
		playPauseBtn.setFormat("VCR OSD Mono", 22, FlxColor.WHITE);
		add(playPauseBtn);

		var progressBg:FlxSprite = new FlxSprite(FlxG.width / 2 - 200, FlxG.height - 25).makeGraphic(400, 4, FlxColor.fromRGB(50, 50, 50));
		add(progressBg);

		spotifyProgressBar = new FlxSprite(FlxG.width / 2 - 200, FlxG.height - 25).makeGraphic(1, 4, FlxColor.fromRGB(30, 215, 96));
		add(spotifyProgressBar);
	}

	function buildSpotifyGrid():Void
	{
		spotifyCardsGroup.clear();
		spotifyTextsGroup.clear();

		var startX:Float = 90;
		var startY:Float = 110;
		var cardSize:Int = 180;
		var spacingX:Float = 25;
		var spacingY:Float = 25;
		var cols:Int = 5;

		for (i in 0...songs.length)
		{
			var songData = songs[i];
			var col:Int = i % cols;
			var row:Int = Std.int(i / cols);

			var posX:Float = startX + (col * (cardSize + spacingX));
			var posY:Float = startY + (row * (cardSize + spacingY));

			// Cuadro del Álbum / Canción
			var card:FlxSprite = new FlxSprite(posX, posY).makeGraphic(cardSize, cardSize, FlxColor.fromRGB(28, 28, 32));
			card.ID = i;
			spotifyCardsGroup.add(card);

			// Imagen/Placeholder del centro de la tarjeta
			var innerArt:FlxSprite = new FlxSprite(posX + 12, posY + 12).makeGraphic(cardSize - 24, cardSize - 55, FlxColor.fromRGB(45, 45, 55));
			spotifyCardsGroup.add(innerArt);

			// Texto con el título
			var songName:String = (songData != null) ? songData.songName : "🎲 Random";
			var titleTxt:FlxText = new FlxText(posX + 10, posY + cardSize - 38, cardSize - 20, songName, 13);
			titleTxt.setFormat("VCR OSD Mono", 13, FlxColor.WHITE, LEFT);
			spotifyTextsGroup.add(titleTxt);

			// Texto con el artista/carpeta
			var folderName:String = (songData != null) ? songData.folder : "Mod";
			var artistTxt:FlxText = new FlxText(posX + 10, posY + cardSize - 20, cardSize - 20, folderName, 10);
			artistTxt.setFormat("VCR OSD Mono", 10, FlxColor.GRAY, LEFT);
			spotifyTextsGroup.add(artistTxt);
		}
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Barra de tiempo en vivo
		if (FlxG.sound.music != null && FlxG.sound.music.playing && FlxG.sound.music.length > 0)
		{
			var progress:Float = FlxG.sound.music.time / FlxG.sound.music.length;
			spotifyProgressBar.scale.x = FlxMath.lerp(spotifyProgressBar.scale.x, Math.max(1, 400 * progress), elapsed * 10);
			spotifyProgressBar.updateHitbox();
		}

		handleInputs(elapsed);
	}

	function handleInputs(elapsed:Float):Void
	{
		if (busy) return;

		// Navegación Teclado
		if (controls.UI_LEFT_P) changeSelection(-1);
		if (controls.UI_RIGHT_P) changeSelection(1);
		if (controls.UI_UP_P) changeSelection(-5);
		if (controls.UI_DOWN_P) changeSelection(5);

		// Navegación por Mouse
		if (FlxG.mouse.justMoved || FlxG.mouse.justPressed)
		{
			for (i in 0...spotifyCardsGroup.members.length)
			{
				var card:FlxSprite = spotifyCardsGroup.members[i];
				if (card != null && FlxG.mouse.overlaps(card, funnyCam))
				{
					if (curSelected != i)
					{
						changeSelection(i - curSelected);
					}

					if (FlxG.mouse.justPressed)
					{
						selectCurrentSong();
					}
				}
			}
		}

		if (controls.BACK)
		{
			busy = true;
			FunkinSound.playOnce(Paths.sound('cancelMenu'));
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			selectCurrentSong();
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);

		var activeCard:FlxSprite = spotifyCardsGroup.members[curSelected * 2]; // *2 por la imagen interna
		if (activeCard != null)
		{
			spotifySelector.x = activeCard.x - 4;
			spotifySelector.y = activeCard.y - 4;
		}

		var songData = songs[curSelected];
		if (songData != null)
		{
			spotifySongTitleText.text = songData.songName;
			spotifyArtistText.text = "Carpeta: " + songData.folder;
			playSongPreview(songData);
		}
		else
		{
			spotifySongTitleText.text = "🎲 Canción Aleatoria";
			spotifyArtistText.text = "Friday Night Funkin'";
		}
	}

	function playSongPreview(songData:FreeplaySongData):Void
	{
		if (songData == null) return;

		try {
			ModsHelper.loadModDir(songData.folder);
			FunkinSound.playMusic(songData.songId, {
				startingVolume: 0.0,
				overrideExisting: true,
				restartTrack: false,
				pathsFunction: INST,
				onLoad: function() {
					FlxG.sound.music.fadeIn(FADE_IN_DURATION, 0, FADE_IN_END_VOLUME);
				}
			});
		} catch (e:Dynamic) {}
	}

	function selectCurrentSong():Void
	{
		busy = true;
		var songData = songs[curSelected];

		if (songData == null)
		{
			// Si eligen Random, tomar una al azar
			var validSongs = songs.filter(s -> s != null);
			if (validSongs.length > 0) songData = FlxG.random.getObject(validSongs);
		}

		if (songData != null)
		{
			FunkinSound.playOnce(Paths.sound('confirmMenu'));
			PlayState.isStoryMode = false;
			PlayState.storyWeek = songData.levelId;

			new FlxTimer().start(0.4, function(tmr:FlxTimer) {
				FreeplayHelpers.moveToPlaystate(this, songData, currentDifficulty);
			});
		}
	}

	override public function destroy():Void
	{
		controls.isInSubstate = false;
		super.destroy();
		FlxG.cameras.remove(funnyCam);
	}
}