import hxcodec.flixel.FlxVideo;
import psychlua.LuaUtils;

var sprite:FlxSprite;
var video:FlxVideo = null;
var videoTimer:FlxTimer = null;

function onCreate() {
    video = new FlxVideo();
    video.play(Paths.video('mysterio'));
    video.alpha = 0;

    videoTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer) {
        videoTimer.destroy();
        if (video != null) video.dispose(); 
    });

    dummySprite = new FlxSprite(0, 0);
    dummySprite.alpha = 0;
    dummySprite.camera = LuaUtils.cameraFromString('camOther');
    game.add(dummySprite);
}

function onEvent(n, v1, v2) {
    if (n == 'Misterio Events') {
        if (v1 == 'video') {
            var video:FlxVideo = new FlxVideo();
            video.play(Paths.video('mysterio'));
            video.alpha = 0;
            video.position = 0;

            video.onTextureSetup.add(function() {
                dummySprite.alpha = 1;
                dummySprite.loadGraphic(video.bitmapData);
            });

            video.onEndReached.add(function(){
                video.dispose();
                dummySprite.destroy();
            }, true);
        }
    }
}

function onPause() {
    if (video != null) video.pause();
}

function onResume() {
    if (video != null) video.resume();
}