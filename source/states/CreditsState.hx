package states;

import objects.AttachedSprite;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:FlxColor;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled) pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['El Juego Popular X Aquino'],
			[''],
			['Owners del mod'],
			[''],
			['Steveguay99', 		'face', 			'Director del mod\n"putamare un hueco"', 																'https://www.youtube.com/@steveguay99', 							'a1a1a1'],
			['Murther', 			'murther', 			'Owner del mod\n"Aguante un accidente automovilistico y un acribillamiento por saber boxear"', 			'https://twitter.com/MurtherSoy', 									'fffaff'],
			['Arielo_018', 			'arielo', 			'Creador del mod\n"Los odio a todos, mueranse"', 														'https://gamebanana.com/mods/471693', 								'fffaff'],
			['Zaeozz', 				'zaeozz', 			'Co-creador\nMenos mal sabía dibujar cuando entre al mod', 												'https://twitter.com/zaeozzz5', 									'120741'],
			['Programadores'],
			['DidiRuano', 			'didi', 			'Programador líder y fiel al server\n"Hola soy el mismísimo DildoEnelAno. Besitos Creisi."',			'https://gamebanana.com/mods/471693', 								'd73332'],
			['DuduGD2023', 			'dudu', 			'Programador\n"Increíble mod está genial, ojalá lo cancelen"', 											'https://twitter.com/DuduGD2023', 									'909090'],
			['ElSebas1231',      	'ElSebas', 			'Programador\n"Trabajé en este mod, yei"', 																'https://www.youtube.com/watch?v=dQw4w9WgXcQ',						'ff0000'],
			['SanfordXD',      		'sanford', 			'Programador', 																							'https://www.youtube.com/@sanfordxdd',								'ca637f'],
			['Músicos'],
			['Stefano', 			'stefano', 			'Músico líder', 																						'https://www.youtube.com/channel/UCR0sga97VFeeJ1mINxw09RA', 		'f8c807'],
			['Amaro', 				'amaro', 			'Músico', 																								'https://www.youtube.com/channel/UC1CWyKgvJSRSVYAUuYttTyA', 		'08aad9'],
			['NexoV', 				'nexo', 			'Músico', 																								'https://twitter.com/NexoSimphonyOwO', 								'fdd1f0'],
			['TheGunatrix', 		'guna', 			'Músico', 																								'https://twitter.com/TGunatrix',									'785ed2'],
			['MasterMusic28', 		'face', 			'Músico', 																								'hhttps://twitter.com/MasterMusic28',								'a1a1a1'],
			['Creadores de Cromaticas'],
			['Ste-Mv', 				'face', 			'Creador de cromaticas', 																				'https://gamebanana.com/members/2395996', 							'a1a1a1'],
			['Animadores y artistas'],
			['Jerpez', 				'jerpez', 			'Artista líder', 																						'https://www.youtube.com/channel/UC-3kSazPL7MNdlS1-ixwLNg', 		'd73332'],
			['RED', 				'red', 				'Animador líder\n"Ya podemos enfriar choros"', 															'https://gamebanana.com/mods/471693', 								'd93236'],
			['Arielo_018', 			'arielo', 			'Artista', 																								'https://gamebanana.com/mods/471693', 								'fffaff'],
			['StarM1608', 			'face', 			'Artista', 																								'https://gamebanana.com/mods/471693',								'a1a1a1'],
			['TEKO', 				'face', 			'Artista/Animador', 																					'https://twitter.com/Orange_sty',									'a1a1a1'],
			['Dujam', 				'face', 			'Artista/Animador', 																					'https://gamebanana.com/mods/471693', 								'a1a1a1'],
			['Zaeozz', 				'zaeozz', 			'Artista', 																								'https://twitter.com/zaeozzz5', 									'120741'],
			['SleepyGGHOST', 		'sleepy', 			'Artista\n"Quemen Chiclayo"', 				'https://gamebanana.com/mods/471693', 								'e8e8e8'],
			['Mateo_sketch', 		'mateosketch', 		'Artista', 									'https://x.com/Mateo41Draws?t=maPmgUGSi4ujgLplEkeB1w&s=09 ', 		'25bc00'],
			['HKaizer', 			'face', 			'Artista/Animador', 						'https://twitter.com/Hkaizer09', 									'a1a1a1'],
			['Jonathan-Bass', 		'face', 			'Artista/Animador', 						'https://twitter.com/Jonatha_FNF', 									'a1a1a1'],
			['JuanfeSS', 			'juanfess', 		'Artista/Animador', 						'https://twitter.com/ss_juanfe', 									'e8e8e8'],
			['Charters'],
			['Murther', 			'murther', 			'Charter líder', 							'https://twitter.com/MurtherSoy', 									'fffaff'],
			['Roval',      			'roval', 			'Charter', 									'https://www.youtube.com/@RovalOriginal',							'edbb0f'],
			['DuduGD2023', 			'dudu', 			'Charter', 									'https://twitter.com/DuduGD2023', 									'909090'],
			['ElSebas1231',      	'ElSebas', 			'Charter', 									'https://www.youtube.com/watch?v=dQw4w9WgXcQ',						'620d10'],
			['Ballade X',      		'ballade', 			'Charter', 									'https://youtube.com/@balladex951?si=GTWU3KxZiuQlj2Xx',				'5f708f'],
			['D3nki', 				'face', 			'Charter', 									'https://twitter.com/_D3NKI', 										'a1a1a1'],
			[''],
			['Redes Sociales'],
			['Twitter',				'twitter',			'Cuenta de Twitter del Mod (Enter para ir)',						'https://twitter.com/Thellamascorp18',					'23ffff'],
			['Canal de YouTube',	'yt',				'Canal de YouTube del Mod (Enter para ir)',							'https://www.youtube.com/@LlamitasCorporationTeam',		'ff2849'],
			[''],
			['Agradecimientos especiales'],
			['TeamTBD',				'TBDLogo',			'Código de la galería\n(Modificado por ElSebas1231)',		'https://github.com/Jorge-SunSpirit/Doki-Doki-Takeover/blob/main/source/GalleryArtState.hx#L25-L26',			'ff90ba'],
			['Squidbowl',			'tinki',			'Assets usados en la galería',								'https://gamebanana.com/tools/13883',																			'ffffff'],
			['Farhad_SH',			'face',				'Botón de usado para la galería',							'https://gamebanana.com/mods/464244',																			'a1a1a1'],
			[''],
			['P-Slice Engine Team'],
			['Mikolka9144',			'mikolka',			'Did everything for P-slice',								 'https://gamebanana.com/members/3329541',									'2ebcfa'],
			['mcagabe19',			'lily',             'Porter of P-slice for mobile devices and creator of linc_luajit-rewritten (used for mobile builds)',                       'https://youtube.com/@mcagabe19',		'FFE7C0'],
			[""],
			["Psych Engine Team"],
			["Shadow Mario",		"shadowmario",		"Main Programmer and Head of Psych Engine",					"https://ko-fi.com/shadowmario",	"444444"],
			["Riveren",				"riveren",			"Main Artist/Animator of Psych Engine",						"https://x.com/riverennn",			"14967B"],
			[""],
			["Former Engine Members"],
			["bb-panzu",			"bb",				"Ex-Programmer of Psych Engine",							"https://x.com/bbsub3",				"3E813A"],
			[""],
			["Engine Contributors"],
			["crowplexus",			"crowplexus",		"HScript Iris, Input System v3, and Other PRs",				"https://github.com/crowplexus",	"CFCFCF"],
			["Kamizeta",			"kamizeta",			"Creator of Pessy, Psych Engine's mascot.",				"https://www.instagram.com/cewweey/",	"D21C11"],
			["MaxNeton",			"maxneton",			"Loading Screen Easter Egg Artist/Animator.",	"https://bsky.app/profile/maxneton.bsky.social","3C2E4E"],
			["Keoiki",				"keoiki",			"Note Splash Animations and Latin Alphabet",				"https://x.com/Keoiki_",			"D2D2D2"],
			["SqirraRNG",			"sqirra",			"Crash Handler and Base code for\nChart Editor's Waveform",	"https://x.com/gedehari",			"E1843A"],
			["EliteMasterEric",		"mastereric",		"Runtime Shaders support and Other PRs",					"https://x.com/EliteMasterEric",	"FFBD40"],
			["MAJigsaw77",			"majigsaw",			".MP4 Video Loader Library (hxvlc)",						"https://x.com/MAJigsaw77",			"5F5F5F"],
			["Tahir Toprak Karabekiroglu",	"tahir",	"Note Splash Editor and Other PRs",							"https://x.com/TahirKarabekir",		"A04397"],
			["iFlicky",				"flicky",			"Composer of Psync and Tea Time\nAnd some sound effects",	"https://x.com/flicky_i",			"9E29CF"],
			["KadeDev",				"kade",				"Fixed some issues on Chart Editor and Other PRs",			"https://x.com/kade0912",			"64A250"],
			["superpowers04",		"superpowers04",	"LUA JIT Fork",												"https://x.com/superpowers04",		"B957ED"],
			["CheemsAndFriends",	"cheems",			"Creator of FlxAnimate",									"https://x.com/CheemsnFriendos",	"E1E1E1"],
			[""],
			["The Funkin' Crew Inc"],
			["ninjamuffin99",		"ninjamuffin99",	"Programmer of Friday Night Funkin'",						"https://x.com/ninja_muffin99",		"CF2D2D"],
			["PhantomArcade",		"phantomarcade",	"Animator of Friday Night Funkin'",							"https://x.com/PhantomArcade3K",	"FADC45"],
			["evilsk8r",			"evilsk8r",			"Artist of Friday Night Funkin'",							"https://x.com/evilsk8r",			"5ABD4B"],
			["kawaisprite",			"kawaisprite",		"Composer of Friday Night Funkin'",							"https://x.com/kawaisprite",		"378FC7"],
		];
		
		for(i in defaultList)
			creditsStuff.push(i);
	
		for (i => credit in creditsStuff)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, credit[0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(isSelectable)
			{
				if(credit[5] != null)
					Mods.currentModDirectory = credit[5];

				var str:String = 'credits/missing_icon';
				if(credit[1] != null && credit[1].length > 0)
				{
					var fileName = 'credits/' + credit[1];
					if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;
					else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE)) str = fileName + '-pixel';
				}

				var icon:AttachedSprite = new AttachedSprite(str);
				if(str.endsWith('-pixel')) icon.antialiasing = false;
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Mods.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			else optionText.alignment = CENTERED;
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		intendedColor = bg.color;
		changeSelection();
		#if TOUCH_CONTROLS_ALLOWED
		addTouchPad('UP_DOWN', 'A_B');
		#end
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				var lerpVal:Float = Math.exp(-elapsed * 12);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(item.x - 70, lastX, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(200 + -40 * Math.abs(item.targetY), item.x, lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do
		{
			curSelected = FlxMath.wrap(curSelected + change, 0, creditsStuff.length - 1);
		}
		while(unselectableCheck(curSelected));

		var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		//trace('The BG color is: $newColor');
		if(newColor != intendedColor)
		{
			intendedColor = newColor;
			FlxTween.cancelTweensOf(bg);
			FlxTween.color(bg, 1, bg.color, intendedColor);
		}

		for (num => item in grpOptions.members)
		{
			item.targetY = num - curSelected;
			if(!unselectableCheck(num)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		if(descText.text.trim().length > 0)
		{
			descText.visible = descBox.visible = true;
			descText.y = FlxG.height - descText.height + offsetThing - 60;
	
			if(moveTween != null) moveTween.cancel();
			moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});
	
			descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
			descBox.updateHitbox();
		}
		else descText.visible = descBox.visible = false;
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = Paths.mods(folder + '/data/credits.txt');
		
		#if TRANSLATIONS_ALLOWED
		//trace('/data/credits-${ClientPrefs.data.language}.txt');
		var translatedCredits:String = Paths.mods(folder + '/data/credits-${ClientPrefs.data.language}.txt');
		#end

		if (#if TRANSLATIONS_ALLOWED (FileSystem.exists(translatedCredits) && (creditsFile = translatedCredits) == translatedCredits) || #end FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
