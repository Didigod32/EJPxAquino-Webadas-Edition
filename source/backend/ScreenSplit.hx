package backend;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import openfl.display.Shape;
import states.PlayState;

typedef ShardData = {
    var cam:FlxCamera;
    var startX:Float;
    var startY:Float;
    var blastX:Float;
    var blastY:Float;
    var blastAngle:Float;
    var finalX:Float;
    var finalY:Float;
    var finalAngle:Float;
};

class ScreenSplit
{
    public static var activeCameras:Array<FlxCamera> = [];
    public static var isActive:Bool = false;
    public static var isRewinding:Bool = false;

    // =========================================================================
    // FASE 1: ROTURA TRIANGULAR DE CRISTAL (Step 32)
    // =========================================================================
    public static function splitGlass(impactX:Float = 640, impactY:Float = 360)
    {
        if (isActive || PlayState.instance == null) return;
        isActive = true;
        isRewinding = false;
        clearCameras();

        var screenW:Int = FlxG.width;
        var screenH:Int = FlxG.height;

        // Sonido, sacudida y fogonazo del golpe
        if (backend.Paths.fileExists('sounds/glass_break.ogg', SOUND))
            FlxG.sound.play(backend.Paths.sound('glass_break'), 1.0);

        FlxG.camera.shake(0.045, 0.35);
        if (PlayState.instance.camHUD != null)
            PlayState.instance.camHUD.shake(0.025, 0.25);
        FlxG.camera.flash(0xFFFFFFFF, 0.12);

        // Malla asimétrica para los triángulos
        var cols:Int = 4;
        var rows:Int = 3;
        var grid:Array<Array<{x:Float, y:Float}>> = [];

        for (c in 0...(cols + 1))
        {
            grid[c] = [];
            for (r in 0...(rows + 1))
            {
                var vx:Float = (c == 0) ? 0 : ((c == cols) ? screenW : (c * (screenW / cols) + FlxG.random.float(-40, 40)));
                var vy:Float = (r == 0) ? 0 : ((r == rows) ? screenH : (r * (screenH / rows) + FlxG.random.float(-30, 30)));
                grid[c][r] = {x: vx, y: vy};
            }
        }

        // Crear fragmentos triangulares
        for (c in 0...cols)
        {
            for (r in 0...rows)
            {
                var tl = grid[c][r];
                var tr = grid[c + 1][r];
                var bl = grid[c][r + 1];
                var br = grid[c + 1][r + 1];

                if ((c + r) % 2 == 0)
                {
                    createTriangleShard(tl, tr, br, impactX, impactY, screenH);
                    createTriangleShard(tl, br, bl, impactX, impactY, screenH);
                }
                else
                {
                    createTriangleShard(tr, br, bl, impactX, impactY, screenH);
                    createTriangleShard(tr, bl, tl, impactX, impactY, screenH);
                }
            }
        }

        protectUiCameras();
        assignGameSpritesToSplitCameras();
        PlayState.instance.camGame.visible = false;
    }

    static function createTriangleShard(v1:{x:Float, y:Float}, v2:{x:Float, y:Float}, v3:{x:Float, y:Float}, impactX:Float, impactY:Float, screenH:Int)
    {
        var minX:Float = Math.min(v1.x, Math.min(v2.x, v3.x));
        var maxX:Float = Math.max(v1.x, Math.max(v2.x, v3.x));
        var minY:Float = Math.min(v1.y, Math.min(v2.y, v3.y));
        var maxY:Float = Math.max(v1.y, Math.max(v2.y, v3.y));

        var w:Int = Std.int(Math.max(2, maxX - minX));
        var h:Int = Std.int(Math.max(2, maxY - minY));

        var cam = new FlxCamera(Std.int(minX), Std.int(minY), w, h);
        cam.bgColor = 0x00000000;
        cam.scroll.set(PlayState.instance.camGame.scroll.x + minX, PlayState.instance.camGame.scroll.y + minY);
        cam.zoom = 1.0;

        var p1x = v1.x - minX; var p1y = v1.y - minY;
        var p2x = v2.x - minX; var p2y = v2.y - minY;
        var p3x = v3.x - minX; var p3y = v3.y - minY;

        // Máscara triangular
        var maskShape:Shape = new Shape();
        maskShape.graphics.beginFill(0xFFFFFF);
        maskShape.graphics.moveTo(p1x, p1y);
        maskShape.graphics.lineTo(p2x, p2y);
        maskShape.graphics.lineTo(p3x, p3y);
        maskShape.graphics.lineTo(p1x, p1y);
        maskShape.graphics.endFill();
        cam.flashSprite.addChild(maskShape);
        cam.flashSprite.mask = maskShape;

        // Filo de cristal
        var edge:Shape = new Shape();
        edge.graphics.lineStyle(1.8, 0xD6F0FF, 0.9);
        edge.graphics.moveTo(p1x, p1y);
        edge.graphics.lineTo(p2x, p2y);
        edge.graphics.lineTo(p3x, p3y);
        edge.graphics.lineTo(p1x, p1y);
        cam.flashSprite.addChild(edge);

        FlxG.cameras.add(cam, false);
        activeCameras.push(cam);

        // Física radial
        var centerX:Float = (v1.x + v2.x + v3.x) / 3.0;
        var centerY:Float = (v1.y + v2.y + v3.y) / 3.0;

        var dirX:Float = centerX - impactX;
        var dirY:Float = centerY - impactY;
        var dist:Float = Math.sqrt(dirX * dirX + dirY * dirY);
        if (dist == 0) dist = 1;

        var normX:Float = dirX / dist;
        var normY:Float = dirY / dist;

        var blastDist:Float = FlxG.random.float(65, 140);
        var blastX:Float = minX + (normX * blastDist);
        var blastY:Float = minY + (normY * blastDist) - FlxG.random.float(40, 95);
        var blastAngle:Float = FlxG.random.float(-20, 20);

        var finalX:Float = blastX + (normX * FlxG.random.float(70, 180));
        var finalY:Float = screenH + FlxG.random.float(90, 260);
        var finalAngle:Float = blastAngle + FlxG.random.float(-35, 35);

        FlxTween.tween(cam, {x: blastX, y: blastY, angle: blastAngle}, 0.12, {
            ease: FlxEase.cubeOut,
            onComplete: function(_) {
                if (!isRewinding)
                {
                    FlxTween.tween(cam, {x: finalX, y: finalY, angle: finalAngle}, FlxG.random.float(0.85, 1.15), {
                        ease: FlxEase.quadIn
                    });
                }
            }
        });
    }

    // =========================================================================
    // FASE 2: REBOBINADO RÁPIDO CON 48 PANELES (Step 80)
    // =========================================================================
    public static function rewind(duration:Float = 0.75, ?onComplete:Void->Void)
    {
        if (!isActive || PlayState.instance == null) return;
        isRewinding = true;

        clearCameras();

        var screenW:Int = FlxG.width;
        var screenH:Int = FlxG.height;

        // 8 columnas x 6 filas = 48 paneles rectangulares exactos
        // 1280 / 8 = 160px exactos
        // 720 / 6 = 120px exactos
        var cols:Int = 8;
        var rows:Int = 6;
        var pieceW:Int = Std.int(screenW / cols);
        var pieceH:Int = Std.int(screenH / rows);

        for (r in 0...rows)
        {
            for (c in 0...cols)
            {
                var targetX:Int = c * pieceW;
                var targetY:Int = r * pieceH;

                // Ascienden desde el fondo con giros sutiles
                var startX:Float = targetX + FlxG.random.float(-25, 25);
                var startY:Float = screenH + FlxG.random.float(50, 180);
                var startAngle:Float = FlxG.random.float(-12, 12);

                var cam = new FlxCamera(Std.int(startX), Std.int(startY), pieceW, pieceH);
                cam.angle = startAngle;
                cam.bgColor = 0x00000000;
                cam.scroll.set(PlayState.instance.camGame.scroll.x + targetX, PlayState.instance.camGame.scroll.y + targetY);
                cam.zoom = 1.0;

                FlxG.cameras.add(cam, false);
                activeCameras.push(cam);

                // Movimiento más rápido y ágil
                var delay:Float = FlxG.random.float(0.0, 0.05);
                var time:Float = Math.max(0.25, duration - delay);

                FlxTween.tween(cam, {x: targetX, y: targetY, angle: 0}, time, {
                    ease: FlxEase.sineOut,
                    startDelay: delay
                });
            }
        }

        protectUiCameras();
        assignGameSpritesToSplitCameras();

        // Flash blanco al 75% del recorrido (justo antes de llegar)
        new FlxTimer().start(duration * 0.75, function(_) {
            if (PlayState.instance != null)
            {
                if (PlayState.instance.camOther != null)
                    PlayState.instance.camOther.flash(0xFFFFFFFF, 0.3);
                else
                    FlxG.camera.flash(0xFFFFFFFF, 0.3);
            }
        });

        // Al 100%: restaura la vista limpia del juego
        new FlxTimer().start(duration, function(_) {
            reset();
            if (onComplete != null) onComplete();
        });
    }

    // =========================================================================
    // RESTAURACIÓN Y PROTECCIÓN DEL MOTOR
    // =========================================================================
    public static function reset()
    {
        if (!isActive || PlayState.instance == null) return;
        isActive = false;
        isRewinding = false;

        restoreGameCameras();
        clearCameras();

        PlayState.instance.camGame.visible = true;
    }

    static function clearCameras()
    {
        for (cam in activeCameras)
        {
            if (cam != null)
            {
                FlxTween.cancelTweensOf(cam);
                FlxG.cameras.remove(cam);
                cam.destroy();
            }
        }
        activeCameras = [];
    }

    static function protectUiCameras()
    {
        if (PlayState.instance.camHUD != null)
        {
            FlxG.cameras.remove(PlayState.instance.camHUD, false);
            FlxG.cameras.add(PlayState.instance.camHUD, false);
        }
        if (PlayState.instance.camOther != null)
        {
            FlxG.cameras.remove(PlayState.instance.camOther, false);
            FlxG.cameras.add(PlayState.instance.camOther, false);
        }
    }

    static function assignGameSpritesToSplitCameras()
    {
        if (PlayState.instance == null) return;

        for (member in PlayState.instance.members)
        {
            applySplitCamerasToObject(member);
        }
    }

    static function applySplitCamerasToObject(basic:FlxBasic)
    {
        if (basic == null) return;

        if (basic is FlxGroup)
        {
            var grp:FlxGroup = cast basic;
            grp.forEach(function(sub:FlxBasic) {
                applySplitCamerasToObject(sub);
            });
            return;
        }

        if (basic.cameras != null)
        {
            var isHud:Bool = basic.cameras.contains(PlayState.instance.camHUD) 
                          || (PlayState.instance.camOther != null && basic.cameras.contains(PlayState.instance.camOther));

            if (!isHud)
            {
                basic.cameras.remove(PlayState.instance.camGame);
                for (cam in activeCameras)
                {
                    if (!basic.cameras.contains(cam))
                        basic.cameras.push(cam);
                }
            }
        }
    }

    static function restoreGameCameras()
    {
        if (PlayState.instance == null) return;

        for (member in PlayState.instance.members)
        {
            applyGameCamToObject(member);
        }
    }

    static function applyGameCamToObject(basic:FlxBasic)
    {
        if (basic == null) return;

        if (basic is FlxGroup)
        {
            var grp:FlxGroup = cast basic;
            grp.forEach(function(sub:FlxBasic) {
                applyGameCamToObject(sub);
            });
            return;
        }

        if (basic.cameras != null)
        {
            var isHud:Bool = basic.cameras.contains(PlayState.instance.camHUD) 
                          || (PlayState.instance.camOther != null && basic.cameras.contains(PlayState.instance.camOther));

            if (!isHud)
            {
                for (cam in activeCameras)
                {
                    if (cam != null)
                        basic.cameras.remove(cam);
                }

                if (!basic.cameras.contains(PlayState.instance.camGame))
                {
                    basic.cameras.push(PlayState.instance.camGame);
                }
            }
        }
    }
}