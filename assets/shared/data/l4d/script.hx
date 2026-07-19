import flixel.group.FlxTypedGroup;

import flixel.util.FlxSort;
import flixel.util.FlxDestroyUtil;

import backend.Song;

// Sucks that I can't use map or other awesome stuff in hscript...
var zombieGroup:FlxTypedGroup;
var animationNotesBF:Array<Dynamic> = [];
var animationNotesDad:Array<Dynamic> = [];

var sprites:Array<FlxSprite>;
var spriteData:Array<{strumTime:Float, isDad:Bool, isKilled:Bool, endingOffset:Float, scrollSpeed:Float}>;

function onCreate() {
    zombieGroup = new FlxTypedGroup();
    game.addBehindBF(zombieGroup);

    sprites = [];
    spriteData = [];

    // Notes that are in the "balas.json"
    loadNoteAnims('balas', Song.loadedSongName);
}

function onCreatePost() {
    for (i in 0...animationNotesBF.length) {
        spawnSprite(-200, 400, animationNotesBF[i][0], false);
    }

    for (i in 0...animationNotesDad.length) {
        spawnSprite(1200, 380, animationNotesDad[i][0], true);
    }
}

function onSectionHit() {
    if (game.curStep <= 560) game.defaultCamZoom = (PlayState.SONG.notes[game.curSection].mustHitSection == true ? 0.9 : 1);
}

// Loads all the notes from the chart
function loadNoteAnims(jsonToLoad:String, path:String) {
    var songData:SwagSong = Song.getChart(jsonToLoad, Paths.formatToSongPath(path));
    if (songData != null) {
        for (section in songData.notes) {
            if (section.mustHitSection == true) {
                for (songNotes in section.sectionNotes) {
                    animationNotesBF.push(songNotes);
                }
            } else {
                for (songNotes in section.sectionNotes) {
                    animationNotesDad.push(songNotes);
                }
            }
        }
    }
    animationNotesBF.sort(sortAnims);
    animationNotesDad.sort(sortAnims);
}

function sortAnims(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int {
    return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
}

// Creates the "bunny" sprite
function spawnSprite(x:Float, y:Float, strumTime:Float, isDad:Bool) {
    if (isDad == null) isDad = false;
    if (x == null) x = 0;
    if (y == null) y = 0;
    if (strumTime == null) strumTime = 0;

    var conejito = new FlxSprite(x, y);
    conejito.frames = Paths.getSparrowAtlas('l4dStage/zombinejo', 'freeplay_weeks');
    
    conejito.animation.addByPrefix('run', 'wabbit', 24, true);
    conejito.animation.addByPrefix('ded', 'ded', 24, false);
    conejito.animation.play('run');
    conejito.flipX = isDad;
    conejito.scale.set(1.6, 1.6);
    conejito.antialiasing = ClientPrefs.data.antialiasing;
    conejito.cameras = [game.camGame];
    zombieGroup.add(conejito);

    sprites.push(conejito);

    var endingOffset = FlxG.random.float(50, 200);
    var scrollSpeed = FlxG.random.float(0.6, 1);

    spriteData.push({ strumTime: strumTime, isDad: isDad, isKilled: false, endingOffset: endingOffset, scrollSpeed: scrollSpeed });
}

function goodNoteHit(note) {
    if (note.noteType == 'bala') {
        for (i in 0...sprites.length) {
            var data = spriteData[i];
            if (note.strumTime == data.strumTime) data.isKilled = true;
        }
    }
}

function onUpdate(elapsed) {
    for (i in 0...sprites.length) {
        var sprite = sprites[i];
        var data = spriteData[i];

        if (sprite != null) {
            //sprite.visible = (sprite.x > -0.5 * FlxG.width && sprite.x < 1.2 * FlxG.width);

            if (sprite.animation.curAnim.name == 'run') {
                var speed:Float = (Conductor.songPosition - data.strumTime) * data.scrollSpeed;
                if (data.isDad == true) { 
                    sprite.x = (1.45 * FlxG.width + data.endingOffset) - speed;
                } else {
                    sprite.x = (0.2 * FlxG.width - data.endingOffset) + speed;
                }
            } else if (sprite.animation.curAnim.finished) {
                zombieGroup.remove(sprite, true);

                sprites.splice(i, 1);
                spriteData.splice(i, 1);
            }

            if (Conductor.songPosition > data.strumTime || data.isKilled) {
                if (!data.isKilled) data.isKilled = true;

                if (data.isDad) {
                    sprite.offset.x = -32;
                    sprite.offset.y = 84;
                } else {
                    sprite.offset.x = 300;
                    sprite.offset.y = 84;
                }
                sprite.animation.play('ded');
            }
        }
    }
}