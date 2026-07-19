import flixel.addons.display.FlxBackdrop;

var smb3BG:FlxBackdrop;
function onCreate() {

    smb3BG = new FlxBackdrop(Paths.image('mario-maker/smb3/Fondo3'), 0x01);
    smb3BG.velocity.set(-1000, 0);
    smb3BG.scale.set(6,6);
    smb3BG.x = -330;
    smb3BG.y = -150;
    smb3BG.alpha = 0;
    game.addBehindGF(smb3BG);
}

function onEvent(n, v1) {
    if (n == 'MM Change') {
        if (v1 == 'smb3') {
            smb3BG.alpha = 1;
        } else {
            smb3BG.alpha = 0;
        }
    }
}