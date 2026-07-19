package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;

/* Gallery code by TeamTBD (Used in DDTO+)
   Modified by ElSebas1231
   Some assets and code are from Squidbowl's GalleryState
*/

class GalleryState extends MusicBeatState
{
	var curSelected:Int = 0;

	var grpGalleryArtwork:FlxTypedGroup<GalleryItem>;

	var artwork:FlxSprite;
    var descBox:FlxSprite;
	var descText:FlxText;
    var backspace:FlxSprite;

    var background:FlxSprite;
	var artworkData:Array<String> = [];
	var galleryData:Array<String> = CoolUtil.coolTextFile(Paths.txt('galleryData'));

	override function create()
	{
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		FlxG.sound.playMusic(Paths.music('galleryMenu'));

        background = new FlxSprite(10, 50).loadGraphic(Paths.image("gallery/ui/void"));
        background.screenCenter();
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);

        var check:FlxBackdrop = new FlxBackdrop(Paths.image('gallery/ui/checkered'), XY, 0, 0);
        check.scrollFactor.set(0.3, 0.3);
        check.velocity.set(-10, 0);
        check.antialiasing = ClientPrefs.data.antialiasing;
        add(check);

        background = new FlxSprite(10, 50).loadGraphic(Paths.image("gallery/ui/bars"));
        background.setGraphicSize(Std.int(background.width * 1));
        background.screenCenter();
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);

		grpGalleryArtwork = new FlxTypedGroup<GalleryItem>();
		add(grpGalleryArtwork);

		var num:Int = 0;
		for (i in 0...galleryData.length) {
            var data:Array<String> = galleryData[i].split('::');

			var galleryItem:GalleryItem = new GalleryItem(0, 0, data[0], data[1].replace("\\n", "\n"));
			galleryItem.targetY = num;
			galleryItem.screenCenter(Y);
			grpGalleryArtwork.add(galleryItem);
			
			num++;
		}

        descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(0, 0, 0, "", 8);
		descText.setFormat(Paths.font("vcr.ttf"), 29, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.antialiasing = ClientPrefs.data.antialiasing;
		add(descText);

        backspace = new FlxSprite(20, 560);
        backspace.frames = Paths.getSparrowAtlas('gallery/ui/backspace');
		backspace.animation.addByPrefix('exit', "backspace to exit", 24);
        backspace.animation.addByPrefix('exit white', "backspace to exit white", 24);
        backspace.animation.addByPrefix('exit pressed', "backspace PRESSED", 24, true);
        backspace.animation.play('exit white');
        backspace.updateHitbox();
        backspace.antialiasing = ClientPrefs.data.antialiasing;
        add(backspace);

		changeItem();

		trace('Total images loaded: ' + galleryData.length + (galleryData.length < 20 ? '\nKinda a lot of art to display...' : "\nDamn that's a lot of art to display."));
		super.create();
	} 

	override function update(elapsed:Float) {
        
        var shiftMult:Int = 1;

        if(FlxG.keys.pressed.SHIFT){
            shiftMult = 3;
        }
        
		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.8){
            FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
        }

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
            backspace.y -= 50;
            backspace.animation.play('exit pressed');

			FlxFlicker.flicker(backspace, 1, 0.06, false, false);
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.UI_LEFT_P){
			changeItem(-shiftMult);
        }

		if (controls.UI_RIGHT_P){
			changeItem(shiftMult);
        }
        
        if(FlxG.mouse.wheel != 0){
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
            changeItem(-shiftMult * FlxG.mouse.wheel, false);
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected = FlxMath.wrap(curSelected + change, 0, galleryData.length-1);

		var bullShit:Int = 0;
		for (item in grpGalleryArtwork.members) {
			item.targetY = bullShit - curSelected;
			item.alpha = 0.6;

			if (item.targetY == Std.int(0)){
				item.alpha = 1;

				descText.text = item.description;
				descText.screenCenter(X);
				descText.y = item.y + item.height + 15;

				trace('Width: ' + item.width + ' | Height: ' + item.height);

				descBox.setPosition(descText.x - 10, descText.y - 10);
				descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
				descBox.updateHitbox();
			}
			bullShit++;
		}
	}
}

class GalleryItem extends FlxSprite {
	public var targetY:Float = 0;
	public var description:String;

	public function new(x:Float, y:Float, ?image:String = '', ?description:String = '')
	{
		super(x, y);
		loadGraphic(Paths.getPath('images/gallery/art/' + image + '.png', IMAGE));
		setGraphicSize(0, Std.int(FlxG.height * 0.8));
		updateHitbox();

		if (width >= 1000)
			setGraphicSize(Std.int(FlxG.width * 0.75), 0);
		
		antialiasing = ClientPrefs.data.antialiasing;
		this.description = description;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		screenCenter(Y);
		x = FlxMath.lerp(x, targetY * 880 + (FlxG.width - width) / 2 + 480, FlxMath.bound(elapsed * 8, 0, 1));
	}
}