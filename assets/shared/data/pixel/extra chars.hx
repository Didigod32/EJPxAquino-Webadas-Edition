import objects.Character;

var locoPato:Character = null;
var c3joPato:Character = null;

function onCreatePost() {
    locoPato = new Character(0, 0, 'loco_pato', false);
    locoPato.x += game.dad.positionArray[0] - 80;
    locoPato.y += game.dad.positionArray[1] - 22;
    game.dadGroup.add(locoPato);

    c3joPato = new Character(0, 0, 'c3jo_pato', true);
    c3joPato.x += game.boyfriend.positionArray[0] + 200;
    c3joPato.y += game.boyfriend.positionArray[1] + 95;
    game.boyfriendGroup.add(c3joPato);
}

function onStepHit() {
    if (game.curStep == 776) {
        locoPato.playAnim('whentevas', true);
        locoPato.specialAnim = true;
    }

    if (game.curStep == 878) {
        locoPato.visible = true;
        locoPato.playAnim('butvuelves', true);
        locoPato.specialAnim = true;
    }

    if (game.curStep == 1200) {
        c3joPato.playAnim('saltodelpapu', true);
        c3joPato.specialAnim = true;
    }
}

function onUpdate(){
    if (locoPato.animation.curAnim.name == 'whentevas') {
        if (game.curStep >= 776 && game.curStep < 878) {
            if (locoPato.animation.curAnim.finished) locoPato.visible = false;
        }
    }

    if (locoPato.animation.curAnim.name == 'butvuelves') {
        if (locoPato.animation.curAnim.curFrame == 10) {
            FlxG.sound.play(Paths.sound('patos/jump'), 0.5);
        }

        if (locoPato.animation.curAnim.curFrame == 21) {
            game.dad.playAnim('whentedisparan', true);
            game.dad.specialAnim = true;

            var iconFlicker:FlxTimer = null;
            if (iconFlicker != null) {
                iconFlicker.cancel();
                iconFlicker.destroy();
            }
            iconFlicker = null;

            iconFlicker = new FlxTimer().start(1 / 30, function(tmr:FlxTimer) {
                game.iconP2.visible = !game.iconP2.visible;
                if(tmr.loopsLeft == 0)  {
                    game.iconP2.visible = true;
                    game.iconP2.changeIcon(locoPato.healthIcon);
                    game.healthBar.setColors(FlxColor.fromRGB(locoPato.healthColorArray[0], locoPato.healthColorArray[1], locoPato.healthColorArray[2]),
                    FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
                }
            }, 30);
        }

        if (locoPato.animation.curAnim.finished) {
            locoPato.y = 436;

            if (game.dad.animation.curAnim.name == 'whentedisparan')
                game.dad.visible = false;
        }
    }

    if (c3joPato.animation.curAnim.name == 'saltodelpapu') {
        if (c3joPato.animation.curAnim.curFrame == 1) {
            FlxG.sound.play(Paths.sound('patos/jump'), 0.5);

            game.boyfriend.playAnim('saltodelpato', true);
            game.boyfriend.specialAnim = true;
        }

        if (c3joPato.animation.curAnim.curFrame == 7) {
            c3joPato.x = 900;
            c3joPato.y = 405;
            game.iconP1.changeIcon(c3joPato.healthIcon);
            game.healthBar.setColors(FlxColor.fromRGB(locoPato.healthColorArray[0], locoPato.healthColorArray[1], locoPato.healthColorArray[2]),
            FlxColor.fromRGB(c3joPato.healthColorArray[0], c3joPato.healthColorArray[1], c3joPato.healthColorArray[2]));
        }
    }

    if (game.boyfriend.animation.curAnim.name == 'saltodelpato') {
        if (game.boyfriend.animation.curAnim.name == 2) {
            FlxG.sound.play(Paths.sound('patos/jump'), 0.5);   
        }

        if (game.boyfriend.animation.curAnim.finished) {
            game.boyfriend.x = 544;
            game.boyfriend.y = 434;
        }
    }

    if (game.curStep >= 900) {
        if (game.dad.visible == true) game.dad.visible = false;
        if (locoPato.y != 436) locoPato.y = 436;
        if (game.iconP2.char != locoPato.healthIcon) {
            game.iconP2.changeIcon(locoPato.healthIcon);
            game.healthBar.setColors(FlxColor.fromRGB(locoPato.healthColorArray[0], locoPato.healthColorArray[1], locoPato.healthColorArray[2]),
            FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
        }
    }

    if (game.curStep > 1205) {
        if (c3joPato.x != 900) c3joPato.x = 900;
        if (c3joPato.y != 405) c3joPato.y = 405;

        if (game.boyfriend.x != 544) game.boyfriend.x = 544;
        if (game.boyfriend.y != 434) game.boyfriend.y = 434;

        if (game.iconP1.char != c3joPato.healthIcon) {
            game.iconP1.changeIcon(c3joPato.healthIcon);
            game.healthBar.setColors(FlxColor.fromRGB(locoPato.healthColorArray[0], locoPato.healthColorArray[1], locoPato.healthColorArray[2]),
            FlxColor.fromRGB(c3joPato.healthColorArray[0], c3joPato.healthColorArray[1], c3joPato.healthColorArray[2]));
        }
    }
}

function onMoveCamera(t) {
    if (game.curStep > 890) {
        if (t == 'dad') {
            if (!PlayState.SONG.notes[game.curSection].gfSection ) {
                game.camFollow.setPosition(locoPato.getMidpoint().x + 150, locoPato.getMidpoint().y - 100);
                game.camFollow.x += locoPato.cameraPosition[0] + game.opponentCameraOffset[0];
                game.camFollow.y += locoPato.cameraPosition[1] + game.opponentCameraOffset[1];
            }
        }
    }

    if (game.curStep > 1205) {
        if (t == 'boyfriend') {
            if (!PlayState.SONG.notes[game.curSection].gfSection) {
                game.camFollow.setPosition(c3joPato.getMidpoint().x + 150, c3joPato.getMidpoint().y - 100);
                game.camFollow.x -= c3joPato.cameraPosition[0] + game.boyfriendCameraOffset[0];
                game.camFollow.y += c3joPato.cameraPosition[1] + game.boyfriendCameraOffset[1];
            }
        }
    }
}

function goodNoteHit(note) {
    if (note.noteType == 'Extra') {
        var animToPlay:String = game.singAnimations[Std.int(Math.abs(Math.min(game.singAnimations.length-1, note.noteData)))] + note.animSuffix;

        c3joPato.playAnim(animToPlay, true);
        c3joPato.holdTimer = 0;
    
        game.camFollow.setPosition(c3joPato.getMidpoint().x + 150, c3joPato.getMidpoint().y - 100);
        game.camFollow.x -= c3joPato.cameraPosition[0] + game.boyfriendCameraOffset[0];
        game.camFollow.y += c3joPato.cameraPosition[1] + game.boyfriendCameraOffset[1];

        game.healthBar.setColors(FlxColor.fromRGB(locoPato.healthColorArray[0], locoPato.healthColorArray[1], locoPato.healthColorArray[2]),
        FlxColor.fromRGB(c3joPato.healthColorArray[0], c3joPato.healthColorArray[1], c3joPato.healthColorArray[2]));
    } else {
        game.iconP1.changeIcon(game.boyfriend.healthIcon);
        game.healthBar.setColors(FlxColor.fromRGB(locoPato.healthColorArray[0], locoPato.healthColorArray[1], locoPato.healthColorArray[2]),
        FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], c3joPato.healthColorArray[2]));
    }
}

function opponentNoteHit(note) {
    if (game.curStep > 900) {
        var animToPlay:String = game.singAnimations[Std.int(Math.abs(Math.min(game.singAnimations.length-1, note.noteData)))] + note.animSuffix;

        if (!note.noAnimation) {
            locoPato.playAnim(animToPlay, true);
            locoPato.holdTimer = 0;
        }
    
        game.camFollow.setPosition(locoPato.getMidpoint().x + 150, locoPato.getMidpoint().y - 100);
        game.camFollow.x += locoPato.cameraPosition[0] + game.opponentCameraOffset[0];
        game.camFollow.y += locoPato.cameraPosition[1] + game.opponentCameraOffset[1];
    }
}

function onCountdownTick(_, c) {
    if (c % 2 == 0) {
        locoPato.playAnim('idlesinmicro', true);
        c3joPato.playAnim('idlesinmicro', true);
    }
}

function onBeatHit() {
    if (game.curBeat % 2 == 0) {
        if (locoPato.animation.curAnim.finished) 
            locoPato.playAnim(game.curStep > 890 ? 'idle' : 'idlesinmicro', true);

        if (c3joPato.animation.curAnim.finished) 
            c3joPato.playAnim(game.curStep > 1205 ? 'idle' : 'idlesinmicro', true);
    }
}