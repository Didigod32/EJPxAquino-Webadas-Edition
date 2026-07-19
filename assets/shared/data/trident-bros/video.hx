import hxcodec.flixel.FlxVideo;
import psychlua.LuaUtils;

var sprite:FlxSprite;
var video:FlxVideo;

function onCreate() {
    if (!ClientPrefs.data.lowQuality) {
        PlayState.skipCountdown = true;
        game.camGame.visible = false;
        game.camHUD.visible = false;
    
        dummySprite = new FlxSprite();
        dummySprite.alpha = 0;
        dummySprite.camera = LuaUtils.cameraFromString('camOther');
        game.add(dummySprite);
    }
}

function onEvent(n, v1, v2) {
    if (n == 'Video') {
        if (!ClientPrefs.data.lowQuality) {
            video = new FlxVideo();
            video.play(Paths.video('SMMintro'));
            video.alpha = 0;
            video.position = 0;
    
            video.onTextureSetup.add(function() {
                dummySprite.alpha = 1;
                dummySprite.loadGraphic(video.bitmapData);
            });
    
            video.onEndReached.add(function(){
                video.dispose();
                dummySprite.destroy();
                
                game.camGame.visible = true;
                game.camHUD.visible = true;
            }, true);
        } else {
            if (!PlayState.chartingMode) {
                // Sets when the songs starts
                game.camGame.visible = true;
                game.camHUD.visible = true;
        
                FlxG.sound.music.time = 23000;
                game.vocals.time = 23000;
                Conductor.songPosition = 23000;
            }
        }
    }
}

function onUpdate() {
    if (!ClientPrefs.data.lowQuality) {
        if (FlxG.keys.justPressed.Y) {
            if (game.curStep <= 197) {
                // Sets when the songs starts
                game.camGame.visible = true;
                game.camHUD.visible = true;
    
                video.dispose();
                dummySprite.destroy();
    
                FlxG.sound.music.time = 24000;
                game.vocals.time = 24000;
                Conductor.songPosition = 24000;
    
                debugPrint('Cutscene skipped!');
            }
        }
    }
}

function onPause() {
    if (video != null) {
        video.pause();

        if (FlxG.signals.focusGained.has(video.resume)) FlxG.signals.focusGained.remove(video.resume);

        if (FlxG.signals.focusLost.has(video.pause)) FlxG.signals.focusLost.remove(video.pause);
    }
}

function onResume() {
    if (video != null) {
        video.resume();

        if (!FlxG.signals.focusGained.has(video.resume)) FlxG.signals.focusGained.remove(video.resume);

        if (!FlxG.signals.focusLost.has(video.pause)) FlxG.signals.focusLost.remove(video.pause);
    }
}