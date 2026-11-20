package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import backend.Paths;
import backend.ClientPrefs;
import backend.CoolUtil;

#if VIDEOS_ALLOWED
import objects.VideoSprite;
#end
#if sys
import sys.FileSystem;
#end

class GalleryState extends MusicBeatState
{
    var curSelected:Int = 0;
    var galleryData:Array<String> = [];
    var parsedData:Array<{file:String, desc:String, isVideo:Bool}> = [];

    // Dimensiones maestras de la ventana
    final WIN_X:Float = 20;
    final WIN_Y:Float = 20;
    var WIN_W:Float = 0;
    var WIN_H:Float = 0;

    final TITLE_H:Float = 36;
    final BOTTOM_H:Float = 74;
    var CANVAS_X:Float = 0;
    var CANVAS_Y:Float = 0;
    var CANVAS_W:Float = 0;
    var CANVAS_H:Float = 0;

    // Capas Base
    var desktopBg:FlxSprite;
    var windowBg:FlxSprite;
    var photoCanvasBg:FlxSprite;
    var currentArtSprite:FlxSprite;
    var descText:FlxText;
    var counterText:FlxText;

    // Video
    var videoPlayOverlay:FlxSprite;
    var videoPlayOverlayIcon:FlxText;
    var isVideoPlaying:Bool = false;
    #if VIDEOS_ALLOWED
    var videoSprite:VideoSprite = null;
    #end

    // Máscaras de recorte exterior (Ocultan la imagen si el zoom sobrepasa la ventana)
    var maskTopDesktop:FlxSprite;
    var maskBottomDesktop:FlxSprite;
    var maskLeftDesktop:FlxSprite;
    var maskRightDesktop:FlxSprite;

    // Barra de Título
    var titleBar:FlxSprite;
    var titleText:FlxText;
    var closeBtnBg:FlxSprite;
    var closeBtnTxt:FlxText;

    // Barra Inferior de Herramientas
    var bottomBarBg:FlxSprite;
    var btnPrev:FlxSprite;
    var btnPrevTxt:FlxText;
    var btnNext:FlxSprite;
    var btnNextTxt:FlxText;
    var btnPlayCircle:FlxSprite;
    var btnPlayIcon:FlxSprite;
    var btnZoomIn:FlxText;
    var btnZoomOut:FlxText;
    var btnRotate:FlxText;
    var windowBorder:FlxSprite;

    // Capa de Pantalla Completa
    var fullscreenGroup:FlxTypedGroup<FlxSprite>;
    var fullscreenBg:FlxSprite;
    var fullscreenArtSprite:FlxSprite;
    var fullscreenHintText:FlxText;
    var isFullscreen:Bool = false;

    var currentScaleMult:Float = 1.0;
    var targetRotation:Float = 0;
    var isBusy:Bool = false;

    override function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        FlxG.mouse.visible = true;

        if (FlxG.sound.music == null || !FlxG.sound.music.playing)
            FlxG.sound.playMusic(Paths.music('galleryMenu'), 0.7);

        // Geometría unificada de la ventana
        WIN_W = FlxG.width - (WIN_X * 2); // 1240
        WIN_H = FlxG.height - (WIN_Y * 2); // 680

        CANVAS_X = WIN_X;
        CANVAS_Y = WIN_Y + TITLE_H; // 56
        CANVAS_W = WIN_W;
        CANVAS_H = WIN_H - TITLE_H - BOTTOM_H; // 570

        try {
            galleryData = CoolUtil.coolTextFile(Paths.txt('galleryData'));
        } catch (e:Dynamic) {
            galleryData = [];
        }

        for (line in galleryData)
        {
            var data:Array<String> = line.split('::');
            var fileName:String = data[0].trim();
            var desc:String = (data.length >= 2) ? data[1].replace("\\n", "\n") : "";
            
            var isVideoFile:Bool = fileName.endsWith('.mp4');
            #if sys
            var videoPathCheck:String = Paths.getPath('images/gallery/videos/' + fileName + (isVideoFile ? '' : '.mp4'), TEXT);
            if (FileSystem.exists(videoPathCheck)) isVideoFile = true;
            #end

            var cleanName:String = isVideoFile && fileName.endsWith('.mp4') ? fileName.substr(0, fileName.length - 4) : fileName;
            parsedData.push({file: cleanName, desc: desc, isVideo: isVideoFile});
        }

        // 1. CAPAS DE FONDO
        desktopBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(24, 28, 34));
        add(desktopBg);

        windowBg = new FlxSprite(WIN_X, WIN_Y).makeGraphic(Std.int(WIN_W), Std.int(WIN_H), FlxColor.fromRGB(238, 238, 242));
        add(windowBg);

        photoCanvasBg = new FlxSprite(CANVAS_X, CANVAS_Y).makeGraphic(Std.int(CANVAS_W), Std.int(CANVAS_H), FlxColor.WHITE);
        add(photoCanvasBg);

        // 2. SPRITE DE LA FOTO / VIDEO (Capa intermedia para poder hacer zoom libremente)
        currentArtSprite = new FlxSprite();
        add(currentArtSprite);

        videoPlayOverlay = new FlxSprite().makeGraphic(70, 70, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawCircle(videoPlayOverlay, 35, 35, 34, FlxColor.fromRGB(30, 30, 30));
        videoPlayOverlay.alpha = 0.85;
        add(videoPlayOverlay);

        videoPlayOverlayIcon = new FlxText(0, 0, 70, "▶", 28);
        videoPlayOverlayIcon.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER);
        add(videoPlayOverlayIcon);

        videoPlayOverlay.visible = false;
        videoPlayOverlayIcon.visible = false;

        descText = new FlxText(CANVAS_X + 20, CANVAS_Y + CANVAS_H - 35, CANVAS_W - 40, "", 14);
        descText.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.fromRGB(40, 40, 40), CENTER, OUTLINE, FlxColor.WHITE);
        add(descText);

        // 3. MÁSCARAS DE RECORTE EXTERIOR (Se dibujan SOBRE la foto para evitar cualquier fuga de píxeles)
        maskTopDesktop = new FlxSprite(0, 0).makeGraphic(FlxG.width, Std.int(WIN_Y), FlxColor.fromRGB(24, 28, 34));
        add(maskTopDesktop);

        maskBottomDesktop = new FlxSprite(0, WIN_Y + WIN_H).makeGraphic(FlxG.width, Std.int(FlxG.height - (WIN_Y + WIN_H)), FlxColor.fromRGB(24, 28, 34));
        add(maskBottomDesktop);

        maskLeftDesktop = new FlxSprite(0, 0).makeGraphic(Std.int(WIN_X), FlxG.height, FlxColor.fromRGB(24, 28, 34));
        add(maskLeftDesktop);

        maskRightDesktop = new FlxSprite(WIN_X + WIN_W, 0).makeGraphic(Std.int(FlxG.width - (WIN_X + WIN_W)), FlxG.height, FlxColor.fromRGB(24, 28, 34));
        add(maskRightDesktop);

        // 4. BARRA DE TÍTULO (Sobre la foto)
        titleBar = new FlxSprite(WIN_X, WIN_Y).makeGraphic(Std.int(WIN_W), Std.int(TITLE_H), FlxColor.fromRGB(215, 222, 235));
        add(titleBar);

        titleText = new FlxText(WIN_X + 14, WIN_Y + 10, WIN_W - 80, "Visor de fotos de Windows", 12);
        titleText.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(40, 40, 45), LEFT);
        add(titleText);

        closeBtnBg = new FlxSprite(WIN_X + WIN_W - 46, WIN_Y).makeGraphic(46, Std.int(TITLE_H), FlxColor.fromRGB(205, 70, 60));
        add(closeBtnBg);

        closeBtnTxt = new FlxText(WIN_X + WIN_W - 46, WIN_Y + 9, 46, "X", 13);
        closeBtnTxt.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.WHITE, CENTER);
        add(closeBtnTxt);

        // 5. BARRA INFERIOR DE HERRAMIENTAS (Sobre la foto)
        var bottomBarY:Float = WIN_Y + WIN_H - BOTTOM_H;
        bottomBarBg = new FlxSprite(WIN_X, bottomBarY).makeGraphic(Std.int(WIN_W), Std.int(BOTTOM_H), FlxColor.fromRGB(225, 230, 240));
        add(bottomBarBg);

        var dividerLine:FlxSprite = new FlxSprite(WIN_X, bottomBarY).makeGraphic(Std.int(WIN_W), 1, FlxColor.fromRGB(190, 195, 205));
        add(dividerLine);

        var barCenterY:Float = bottomBarY + (BOTTOM_H / 2);

        counterText = new FlxText(WIN_X + 25, barCenterY - 8, 200, "[ 1 / 1 ]", 14);
        counterText.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.fromRGB(70, 75, 85), LEFT);
        add(counterText);

        var midX:Float = FlxG.width / 2;

        btnZoomOut = new FlxText(midX - 140, barCenterY - 12, 35, "🔍-", 18);
        btnZoomOut.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.fromRGB(60, 65, 75), CENTER);
        add(btnZoomOut);

        btnPrev = new FlxSprite(midX - 80, barCenterY - 18).makeGraphic(36, 36, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawCircle(btnPrev, 18, 18, 17, FlxColor.fromRGB(190, 205, 230));
        add(btnPrev);

        btnPrevTxt = new FlxText(midX - 80, barCenterY - 11, 36, "<", 18);
        btnPrevTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.fromRGB(30, 35, 45), CENTER);
        add(btnPrevTxt);

        btnPlayCircle = new FlxSprite(midX - 24, barCenterY - 24).makeGraphic(48, 48, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawCircle(btnPlayCircle, 24, 24, 23, FlxColor.fromRGB(65, 140, 235));
        add(btnPlayCircle);

        btnPlayIcon = new FlxSprite(midX - 10, barCenterY - 8).makeGraphic(20, 16, FlxColor.WHITE);
        FlxSpriteUtil.drawRect(btnPlayIcon, 2, 2, 16, 12, FlxColor.fromRGB(65, 140, 235));
        add(btnPlayIcon);

        btnNext = new FlxSprite(midX + 44, barCenterY - 18).makeGraphic(36, 36, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawCircle(btnNext, 18, 18, 17, FlxColor.fromRGB(190, 205, 230));
        add(btnNext);

        btnNextTxt = new FlxText(midX + 44, barCenterY - 11, 36, ">", 18);
        btnNextTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.fromRGB(30, 35, 45), CENTER);
        add(btnNextTxt);

        btnZoomIn = new FlxText(midX + 105, barCenterY - 12, 35, "🔍+", 18);
        btnZoomIn.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.fromRGB(60, 65, 75), CENTER);
        add(btnZoomIn);

        btnRotate = new FlxText(midX + 155, barCenterY - 12, 35, "↻", 18);
        btnRotate.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.fromRGB(60, 65, 75), CENTER);
        add(btnRotate);

        // Contorno de la Ventana
        windowBorder = new FlxSprite(WIN_X, WIN_Y).makeGraphic(Std.int(WIN_W), Std.int(WIN_H), FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawRect(windowBorder, 0, 0, WIN_W, WIN_H, FlxColor.TRANSPARENT, {thickness: 1, color: FlxColor.fromRGB(160, 170, 185)});
        add(windowBorder);

        // 6. CAPA DE PANTALLA COMPLETA
        fullscreenGroup = new FlxTypedGroup<FlxSprite>();
        add(fullscreenGroup);

        fullscreenBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(10, 10, 10));
        fullscreenBg.alpha = 0.95;
        fullscreenGroup.add(fullscreenBg);

        fullscreenArtSprite = new FlxSprite();
        fullscreenGroup.add(fullscreenArtSprite);

        fullscreenHintText = new FlxText(0, FlxG.height - 40, FlxG.width, "Haz clic en cualquier parte o pulsa ESCAPE para salir", 13);
        fullscreenHintText.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(180, 180, 180), CENTER);
        fullscreenGroup.add(fullscreenHintText);

        fullscreenGroup.visible = false;

        if (parsedData.length > 0)
            loadCurrentItem();

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        FlxG.mouse.visible = true;

        currentArtSprite.angle = FlxMath.lerp(currentArtSprite.angle, targetRotation, elapsed * 10);

        if (isBusy || isVideoPlaying) return;

        if (isFullscreen)
        {
            if (controls.BACK || FlxG.keys.justPressed.ESCAPE || FlxG.mouse.justPressed)
            {
                closeFullscreen();
            }
            return;
        }

        var shiftMult:Int = FlxG.keys.pressed.SHIFT ? 3 : 1;

        if (controls.BACK || FlxG.keys.justPressed.ESCAPE)
        {
            exitGallery();
            return;
        }

        if (controls.UI_LEFT_P) changeItem(-shiftMult);
        if (controls.UI_RIGHT_P) changeItem(shiftMult);

        if (FlxG.mouse.wheel != 0)
            changeItem(-shiftMult * FlxG.mouse.wheel);

        if (FlxG.mouse.justPressed)
        {
            if (FlxG.mouse.overlaps(closeBtnBg) || FlxG.mouse.overlaps(closeBtnTxt))
            {
                exitGallery();
                return;
            }

            if (FlxG.mouse.overlaps(btnPrev) || FlxG.mouse.overlaps(btnPrevTxt))
            {
                changeItem(-1);
                return;
            }

            if (FlxG.mouse.overlaps(btnNext) || FlxG.mouse.overlaps(btnNextTxt))
            {
                changeItem(1);
                return;
            }

            var currentItem = parsedData[curSelected];

            if (!currentItem.isVideo)
            {
                if (FlxG.mouse.overlaps(btnZoomIn))
                {
                    adjustZoom(0.2);
                    return;
                }

                if (FlxG.mouse.overlaps(btnZoomOut))
                {
                    adjustZoom(-0.2);
                    return;
                }

                if (FlxG.mouse.overlaps(btnRotate))
                {
                    targetRotation += 90;
                    loadCurrentItem();
                    return;
                }
            }

            if (FlxG.mouse.overlaps(btnPlayCircle) || FlxG.mouse.overlaps(btnPlayIcon))
            {
                if (currentItem.isVideo)
                    playCurrentVideo();
                else
                    openFullscreen();
                return;
            }

            // Clic en el área de la imagen
            if (!FlxG.mouse.overlaps(bottomBarBg) && !FlxG.mouse.overlaps(titleBar))
            {
                if (FlxG.mouse.overlaps(photoCanvasBg))
                {
                    if (currentItem.isVideo)
                        playCurrentVideo();
                    else
                        openFullscreen();
                    return;
                }
            }
        }
    }

    function changeItem(change:Int = 0):Void
    {
        if (parsedData.length == 0) return;

        #if VIDEOS_ALLOWED
        if (videoSprite != null)
        {
            videoSprite.destroy();
            remove(videoSprite);
            videoSprite = null;
        }
        #end
        isVideoPlaying = false;

        curSelected = FlxMath.wrap(curSelected + change, 0, parsedData.length - 1);
        
        currentScaleMult = 1.0;
        targetRotation = 0;
        currentArtSprite.angle = 0;

        loadCurrentItem();
    }

    function loadCurrentItem():Void
    {
        var item = parsedData[curSelected];

        if (item.isVideo)
        {
            var thumbPath:String = 'gallery/art/' + item.file;
            if (Paths.fileExists('images/' + thumbPath + '.png', IMAGE))
                currentArtSprite.loadGraphic(Paths.image(thumbPath));
            else
                currentArtSprite.makeGraphic(640, 360, FlxColor.fromRGB(20, 20, 20));

            titleText.text = '${item.file}.mp4 - Visor de videos';

            videoPlayOverlay.visible = true;
            videoPlayOverlayIcon.visible = true;
        }
        else
        {
            var imagePath:String = 'gallery/art/' + item.file;
            currentArtSprite.loadGraphic(Paths.image(imagePath));
            titleText.text = '${item.file}.png - Visor de fotos de Windows';

            videoPlayOverlay.visible = false;
            videoPlayOverlayIcon.visible = false;
        }

        currentArtSprite.antialiasing = ClientPrefs.data.antialiasing;

        if (currentArtSprite.graphic != null)
        {
            var origW:Float = currentArtSprite.graphic.width;
            var origH:Float = currentArtSprite.graphic.height;

            var isRotatedSide:Bool = (Math.round(Math.abs(targetRotation / 90)) % 2 == 1);
            var effW:Float = isRotatedSide ? origH : origW;
            var effH:Float = isRotatedSide ? origW : origH;

            // Tamaño base inicial que encaja holgadamente en el lienzo (con 50px de margen)
            var fitW:Float = CANVAS_W - 50;
            var fitH:Float = CANVAS_H - 50;

            var baseScale:Float = Math.min(fitW / effW, fitH / effH);
            if (baseScale > 1.0) baseScale = 1.0;

            // Escala libre multiplicada por el zoom actual
            var finalScale:Float = baseScale * currentScaleMult;
            currentArtSprite.scale.set(finalScale, finalScale);
            currentArtSprite.updateHitbox();

            // Centrado en el lienzo
            currentArtSprite.x = CANVAS_X + (CANVAS_W - currentArtSprite.width) / 2;
            currentArtSprite.y = CANVAS_Y + (CANVAS_H - currentArtSprite.height) / 2 - 10;

            if (item.isVideo)
            {
                videoPlayOverlay.x = currentArtSprite.x + (currentArtSprite.width - videoPlayOverlay.width) / 2;
                videoPlayOverlay.y = currentArtSprite.y + (currentArtSprite.height - videoPlayOverlay.height) / 2;
                videoPlayOverlayIcon.setPosition(videoPlayOverlay.x, videoPlayOverlay.y + 18);
            }
        }

        descText.text = item.desc;
        counterText.text = '[ ${curSelected + 1} / ${parsedData.length} ]';
    }

    function playCurrentVideo():Void
    {
        #if VIDEOS_ALLOWED
        var item = parsedData[curSelected];
        var videoPath:String = Paths.video('gallery/videos/' + item.file);

        if (FileSystem.exists(videoPath))
        {
            if (videoSprite != null)
            {
                videoSprite.destroy();
                remove(videoSprite);
                videoSprite = null;
            }

            isVideoPlaying = true;
            videoPlayOverlay.visible = false;
            videoPlayOverlayIcon.visible = false;

            if (FlxG.sound.music != null)
                FlxG.sound.music.pause();

            videoSprite = new VideoSprite(videoPath, false, true, false);
            videoSprite.setGraphicSize(Std.int(currentArtSprite.width), Std.int(currentArtSprite.height));
            videoSprite.updateHitbox();
            videoSprite.setPosition(currentArtSprite.x, currentArtSprite.y);
            
            // Insertar el video debajo de las máscaras de la interfaz
            insert(members.indexOf(maskTopDesktop), videoSprite);

            videoSprite.finishCallback = function()
            {
                isVideoPlaying = false;
                videoPlayOverlay.visible = true;
                videoPlayOverlayIcon.visible = true;
                if (FlxG.sound.music != null)
                    FlxG.sound.music.resume();
            };

            videoSprite.play();
        }
        #end
    }

    function openFullscreen():Void
    {
        if (parsedData.length == 0) return;

        isFullscreen = true;
        var item = parsedData[curSelected];
        var imagePath:String = 'gallery/art/' + item.file;

        fullscreenArtSprite.loadGraphic(Paths.image(imagePath));
        fullscreenArtSprite.antialiasing = ClientPrefs.data.antialiasing;

        var maxW:Float = FlxG.width * 0.92;
        var maxH:Float = FlxG.height * 0.88;

        var origW:Float = fullscreenArtSprite.graphic != null ? fullscreenArtSprite.graphic.width : fullscreenArtSprite.width;
        var origH:Float = fullscreenArtSprite.graphic != null ? fullscreenArtSprite.graphic.height : fullscreenArtSprite.height;

        var scale:Float = Math.min(maxW / origW, maxH / origH);
        fullscreenArtSprite.scale.set(scale, scale);
        fullscreenArtSprite.updateHitbox();
        fullscreenArtSprite.screenCenter();

        fullscreenGroup.visible = true;
    }

    function closeFullscreen():Void
    {
        isFullscreen = false;
        fullscreenGroup.visible = false;
    }

    function adjustZoom(amount:Float):Void
    {
        // Rango de zoom amplio: desde 0.4x hasta 3.0x
        currentScaleMult = FlxMath.bound(currentScaleMult + amount, 0.4, 3.0);
        loadCurrentItem();
    }

    function exitGallery():Void
    {
        isBusy = true;
        #if VIDEOS_ALLOWED
        if (videoSprite != null)
        {
            videoSprite.destroy();
            videoSprite = null;
        }
        #end
        FlxG.sound.play(Paths.sound('cancelMenu'));
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
        MusicBeatState.switchState(new MainMenuState());
    }
}