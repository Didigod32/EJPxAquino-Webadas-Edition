package states;

import pslice.compatibility.ModsHelper;
import pslice.vslice.freeplay.FreeplayState;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0'; // This is also used for Discord RPC
	public static var pSliceVersion:String = '2.1'; 
	public static var funkinVersion:String = '0.5.1'; // Version of funkin' we are emulationg
	public static var curSelected:Int = 0;
	var allowMouse:Bool = true; //Turn this off to block mouse movement in menus

	var menuItems:FlxTypedGroup<FlxSprite>;

	//Centered/Text options
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'gallery',
		'options'
	];

	public function new(isDisplayingRank:Bool = false) {

		super();
	}

	override function create()
	{
		Paths.clearUnusedMemory();
		ModsHelper.clearStoredWithoutStickers();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = persistentDraw = true;

		var bgBot:FlxSprite = new FlxSprite(-2900, -20);
		bgBot.frames = Paths.getSparrowAtlas('mainmenu/menu_bot');
		bgBot.antialiasing = ClientPrefs.data.antialiasing;
		bgBot.scale.set(1.1, 1.1);
		bgBot.updateHitbox();
		bgBot.animation.addByPrefix('idle', 'idle', 24, true);
		bgBot.animation.play('idle');
		bgBot.scrollFactor.set(0, 0);
		add(bgBot);

		var murito:FlxSprite = new FlxSprite(-475, 0).loadGraphic(Paths.image('mainmenu/murito'));
		murito.scrollFactor.set(0, 0);
		murito.antialiasing = ClientPrefs.data.antialiasing;
		add(murito);

		var murito2:FlxSprite = new FlxSprite(1020, -145).loadGraphic(Paths.image('mainmenu/murito2'));
		murito2.scrollFactor.set(0, 0);
		murito2.antialiasing = ClientPrefs.data.antialiasing;
		add(murito2);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (num => option in optionShit)
		{
			var item:FlxSprite = createMenuItem(option, 0, 0);
			item.y += (4 - optionShit.length) * 70; // Offsets for when you have anything other than 4 items
			item.screenCenter(X);

			switch(num) {
				case 0:
					item.setPosition(30, 75);
				case 1:
					item.setPosition(175, 200);
				case 2:
					item.setPosition(45, 325);
				case 3:
					item.setPosition(215, 450);
				case 4:
					item.setPosition(75, 575);
			}
		}

		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 18, FlxG.width, "Friday Night Funkin' v" + funkinVersion + ' | (P-slice ${pSliceVersion})', 12);

		psychVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
		psychVer.scrollFactor.set();
		fnfVer.scrollFactor.set();
		add(psychVer);
		add(fnfVer);
		changeItem();

		super.create();
	}

	function createMenuItem(name:String, x:Float, y:Float):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();
		menuItem.scale.set(0.7, 0.7);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
		return menuItem;
	}

	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (!selectedSomethin) {
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			var allowMouse:Bool = allowMouse;
			if (allowMouse && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)) { //FlxG.mouse.deltaScreenX/Y checks is more accurate than FlxG.mouse.justMoved
				allowMouse = false;
				FlxG.mouse.visible = true;
				timeNotMoving = 0;

				var selectedItem:FlxSprite;
				selectedItem = menuItems.members[curSelected];

				var dist:Float = -1;
				var distItem:Int = -1;
				for (i in 0...optionShit.length) {
					var memb:FlxSprite = menuItems.members[i];
					if (FlxG.mouse.overlaps(memb)) {
						var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
						if (dist < 0 || distance < dist) {
							dist = distance;
							distItem = i;
							allowMouse = true;
						}
					}
				}

				if (distItem != -1 && selectedItem != menuItems.members[distItem]) {
					curSelected = distItem;
					changeItem();
				}
			} else {
				timeNotMoving += elapsed;
				if(timeNotMoving > 2) FlxG.mouse.visible = false;
			}

			if (controls.BACK) {
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT || (FlxG.mouse.justPressed && allowMouse)) {
				FlxG.sound.play(Paths.sound('confirmMenu'));

				selectedSomethin = true;
				FlxG.mouse.visible = false;

				var item:FlxSprite;
				var option:String;

				option = optionShit[curSelected];
				item = menuItems.members[curSelected];
				var choice = option != 'freeplay' ? true : false;

				FlxFlicker.flicker(item, 0.6, 0.06, false, choice, function(flick:FlxFlicker) {
					switch (option) {
						case 'story_mode':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':{
							persistentDraw = true;
							persistentUpdate = false;
							// Freeplay has its own custom transition
							FlxTransitionableState.skipNextTransIn = true;	
							FlxTransitionableState.skipNextTransOut = true;

							openSubState(new FreeplayState());
							subStateOpened.addOnce(state -> {
								for (i in 0...menuItems.members.length) {
									menuItems.members[i].revive();
									menuItems.members[i].alpha = 1;
									menuItems.members[i].visible = true;
									selectedSomethin = false;
								}
								changeItem(0);
							});
							
						}
						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'gallery':
							MusicBeatState.switchState(new GalleryState());
						case 'options':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null) {
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
					}
				});

				if (option != 'freeplay') {
					FlxTween.tween(FlxG.camera, {zoom: 2}, 3.5, {ease:FlxEase.cubeInOut});
					FlxTween.tween(FlxG.camera, {angle: 15}, 3.5, {ease:FlxEase.cubeInOut});
				}
			}
			
			if (#if TOUCH_CONTROLS_ALLOWED touchPad.buttonE.justPressed || #end controls.justPressed('debug_1')) {
				selectedSomethin = true;
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			} else if (controls.justPressed('debug_2')) {
				MusicBeatState.switchState(new ModsMenuState());
			}
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (item in menuItems) {
			item.animation.play('idle');
			item.centerOffsets();
		}

		var selectedItem:FlxSprite;
		selectedItem = menuItems.members[curSelected];
		selectedItem.animation.play('selected');
		selectedItem.centerOffsets();
	}
}