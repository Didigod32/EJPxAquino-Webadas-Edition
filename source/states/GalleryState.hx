package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import backend.Paths;
import backend.ClientPrefs;
import backend.CoolUtil;

class GalleryState extends MusicBeatState
{
    var curSelected:Int = 0;
    var galleryData:Array<String> = [];
    var parsedData:Array<{file:String, desc:String}> = [];

    // Estructura de Ventana Clásica
    var windowBg:FlxSprite;
    var titleBar:FlxSprite;
    var titleText:FlxText;
    var closeBtnBg:FlxSprite;
    var closeBtnTxt:FlxText;
    
    // Área de Trabajo
    var photoCanvasBg:FlxSprite;
    var currentArtSprite:FlxSprite;
    var descText:FlxText;
    var counterText:FlxText;

    // Barra de Herramientas Inferior
    var bottomBarBg:FlxSprite;
    var btnPrev:FlxSprite;
    var btnPrevTxt:FlxText;
    var btnNext:FlxSprite;
    var btnNextTxt:FlxText;
    var btnPlayCircle:FlxSprite;
    var btnPlayIcon:FlxText;
    var btnZoomIn:FlxText;
    var btnZoomOut:FlxText;
    var btnRotate:FlxText;

    // Capa de Pantalla Completa
    var fullscreenGroup:FlxTypedGroup<FlxSprite>;
    var fullscreenBg:FlxSprite;
    var fullscreenArtSprite:FlxSprite;
    var fullscreenHintText:FlxText;
    var isFullscreen:Bool = false;

    // Variables de visualización
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

        // 1. Lectura de Datos
        try {
            galleryData = CoolUtil.coolTextFile(Paths.txt('galleryData'));
        } catch (e:Dynamic) {
            galleryData = [];
        }

        for (line in galleryData)
        {
            var data:Array<String> = line.split('::');
            if (data.length >= 2)
                parsedData.push({file: data[0], desc: data[1].replace("\\n", "\n")});
            else if (data.length == 1 && data[0].length > 0)
                parsedData.push({file: data[0], desc: ""});
        }

        // 2. Fondo de Pantalla (Escritorio / Base)
        var desktopBg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(24, 28, 34));
        add(desktopBg);

        // 3. Ventana del Visor de Fotos
        windowBg = new FlxSprite(20, 20).makeGraphic(FlxG.width - 40, FlxG.height - 40, FlxColor.fromRGB(238, 238, 242));
        add(windowBg);

        // Barra Superior de la Ventana
        titleBar = new FlxSprite(20, 20).makeGraphic(FlxG.width - 40, 32, FlxColor.fromRGB(215, 222, 235));
        add(titleBar);

        titleText = new FlxText(34, 28, FlxG.width - 150, "Visor de fotos de Windows", 12);
        titleText.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(40, 40, 45), LEFT);
        add(titleText);

        closeBtnBg = new FlxSprite(FlxG.width - 55, 22).makeGraphic(30, 26, FlxColor.fromRGB(205, 70, 60));
        add(closeBtnBg);

        closeBtnTxt = new FlxText(FlxG.width - 55, 27, 30, "X", 12);
        closeBtnTxt.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.WHITE, CENTER);
        add(closeBtnTxt);

        // Lienzo central
        photoCanvasBg = new FlxSprite(35, 60).makeGraphic(FlxG.width - 70, FlxG.height - 170, FlxColor.fromRGB(255, 255, 255));
        add(photoCanvasBg);

        // Sprite de la ilustración actual
        currentArtSprite = new FlxSprite();
        add(currentArtSprite);

        // Descripción al pie del lienzo
        descText = new FlxText(45, FlxG.height - 145, FlxG.width - 90, "", 14);
        descText.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.fromRGB(30, 30, 30), CENTER, OUTLINE, FlxColor.WHITE);
        add(descText);

        // 4. Barra de Herramientas Inferior
        bottomBarBg = new FlxSprite(20, FlxG.height - 95).makeGraphic(FlxG.width - 40, 75, FlxColor.fromRGB(225, 230, 240));
        add(bottomBarBg);

        var dividerLine:FlxSprite = new FlxSprite(20, FlxG.height - 96).makeGraphic(FlxG.width - 40, 1, FlxColor.fromRGB(190, 195, 205));
        add(dividerLine);

        // Contador de imágenes
        counterText = new FlxText(40, FlxG.height - 68, 200, "[ 1 / 1 ]", 14);
        counterText.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.fromRGB(70, 75, 85), LEFT);
        add(counterText);

        // 5. Controles con Capas Correctas (Fondo -> Texto)
        btnZoomOut = new FlxText(FlxG.width / 2 - 140, FlxG.height - 74, 40, "🔍-", 20);
        btnZoomOut.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.fromRGB(60, 65, 75), CENTER);
        add(btnZoomOut);

        // Botón Anterior (Base Circular)
        btnPrev = new FlxSprite(FlxG.width / 2 - 80, FlxG.height - 78).makeGraphic(36, 36, FlxColor.TRANSPARENT);
        flixel.util.FlxSpriteUtil.drawCircle(btnPrev, 18, 18, 17, FlxColor.fromRGB(190, 205, 230));
        add(btnPrev);

        // Botón Anterior (Glifo Flecha)
        btnPrevTxt = new FlxText(FlxG.width / 2 - 80, FlxG.height - 70, 36, "<", 18);
        btnPrevTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.fromRGB(30, 35, 45), CENTER);
        add(btnPrevTxt);

        // Botón Central (Base Circular)
        btnPlayCircle = new FlxSprite(FlxG.width / 2 - 24, FlxG.height - 86).makeGraphic(48, 48, FlxColor.TRANSPARENT);
        flixel.util.FlxSpriteUtil.drawCircle(btnPlayCircle, 24, 24, 23, FlxColor.fromRGB(65, 140, 235));
        add(btnPlayCircle);

        // Botón Central (Ícono Pantalla Completa / Play)
        btnPlayIcon = new FlxText(FlxG.width / 2 - 24, FlxG.height - 74, 48, "⛶", 20);
        btnPlayIcon.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER);
        add(btnPlayIcon);

        // Botón Siguiente (Base Circular)
        btnNext = new FlxSprite(FlxG.width / 2 + 45, FlxG.height - 78).makeGraphic(36, 36, FlxColor.TRANSPARENT);
        flixel.util.FlxSpriteUtil.drawCircle(btnNext, 18, 18, 17, FlxColor.fromRGB(190, 205, 230));
        add(btnNext);

        // Botón Siguiente (Glifo Flecha)
        btnNextTxt = new FlxText(FlxG.width / 2 + 45, FlxG.height - 70, 36, ">", 18);
        btnNextTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.fromRGB(30, 35, 45), CENTER);
        add(btnNextTxt);

        // Botón Zoom +
        btnZoomIn = new FlxText(FlxG.width / 2 + 100, FlxG.height - 74, 40, "🔍+", 20);
        btnZoomIn.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.fromRGB(60, 65, 75), CENTER);
        add(btnZoomIn);

        // Botón Rotar
        btnRotate = new FlxText(FlxG.width / 2 + 145, FlxG.height - 74, 40, "↻", 20);
        btnRotate.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.fromRGB(60, 65, 75), CENTER);
        add(btnRotate);

        // 6. Grupo Modal para Vista Pantalla Completa
        fullscreenGroup = new FlxTypedGroup<FlxSprite>();
        add(fullscreenGroup);

        fullscreenBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(10, 10, 10));
        fullscreenBg.alpha = 0.95;
        fullscreenGroup.add(fullscreenBg);

        fullscreenArtSprite = new FlxSprite();
        fullscreenGroup.add(fullscreenArtSprite);

        fullscreenHintText = new FlxText(0, FlxG.height - 40, FlxG.width, "Haz clic en cualquier parte o pulsa ESCAPE para salir de la pantalla completa", 13);
        fullscreenHintText.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(180, 180, 180), CENTER);
        fullscreenGroup.add(fullscreenHintText);

        fullscreenGroup.visible = false;

        if (parsedData.length > 0)
            loadCurrentPhoto();

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        currentArtSprite.angle = FlxMath.lerp(currentArtSprite.angle, targetRotation, elapsed * 10);

        if (isBusy) return;

        // --- MANEJO DE PANTALLA COMPLETA ---
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

        // Clics de Ratón
        if (FlxG.mouse.justPressed)
        {
            if (FlxG.mouse.overlaps(closeBtnBg) || FlxG.mouse.overlaps(closeBtnTxt))
            {
                exitGallery();
                return;
            }

            // Abrir pantalla completa al cliquear la imagen o el botón central
            if (FlxG.mouse.overlaps(currentArtSprite) || FlxG.mouse.overlaps(btnPlayCircle) || FlxG.mouse.overlaps(btnPlayIcon))
            {
                openFullscreen();
                return;
            }

            if (FlxG.mouse.overlaps(btnPrev) || FlxG.mouse.overlaps(btnPrevTxt))
                changeItem(-1);

            if (FlxG.mouse.overlaps(btnNext) || FlxG.mouse.overlaps(btnNextTxt))
                changeItem(1);

            if (FlxG.mouse.overlaps(btnZoomIn))
                adjustZoom(0.15);

            if (FlxG.mouse.overlaps(btnZoomOut))
                adjustZoom(-0.15);

            if (FlxG.mouse.overlaps(btnRotate))
                targetRotation += 90;
        }
    }

    function changeItem(change:Int = 0):Void
    {
        if (parsedData.length == 0) return;

        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected = FlxMath.wrap(curSelected + change, 0, parsedData.length - 1);
        
        currentScaleMult = 1.0;
        targetRotation = 0;
        currentArtSprite.angle = 0;

        loadCurrentPhoto();
    }

    function loadCurrentPhoto():Void
    {
        var item = parsedData[curSelected];
        var imagePath:String = 'gallery/art/' + item.file;

        currentArtSprite.loadGraphic(Paths.image(imagePath));
        currentArtSprite.antialiasing = ClientPrefs.data.antialiasing;

        var maxWidth:Float = photoCanvasBg.width - 40;
        var maxHeight:Float = photoCanvasBg.height - 60;

        var scale:Float = Math.min(maxWidth / currentArtSprite.width, maxHeight / currentArtSprite.height);
        if (scale > 1) scale = 1;

        currentArtSprite.scale.set(scale * currentScaleMult, scale * currentScaleMult);
        currentArtSprite.updateHitbox();

        currentArtSprite.x = photoCanvasBg.x + (photoCanvasBg.width - currentArtSprite.width) / 2;
        currentArtSprite.y = photoCanvasBg.y + (photoCanvasBg.height - currentArtSprite.height) / 2 - 10;

        titleText.text = '${item.file}.png - Visor de fotos de Windows';
        descText.text = item.desc;
        counterText.text = '[ ${curSelected + 1} / ${parsedData.length} ]';
    }

    function openFullscreen():Void
    {
        if (parsedData.length == 0) return;

        isFullscreen = true;
        var item = parsedData[curSelected];
        var imagePath:String = 'gallery/art/' + item.file;

        fullscreenArtSprite.loadGraphic(Paths.image(imagePath));
        fullscreenArtSprite.antialiasing = ClientPrefs.data.antialiasing;

        // Escalar al 90% del tamaño total de la pantalla conservando proporción
        var maxW:Float = FlxG.width * 0.92;
        var maxH:Float = FlxG.height * 0.88;

        var scale:Float = Math.min(maxW / fullscreenArtSprite.width, maxH / fullscreenArtSprite.height);
        fullscreenArtSprite.scale.set(scale, scale);
        fullscreenArtSprite.updateHitbox();
        fullscreenArtSprite.screenCenter();

        fullscreenGroup.visible = true;
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.5);
    }

    function closeFullscreen():Void
    {
        isFullscreen = false;
        fullscreenGroup.visible = false;
        FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
    }

    function adjustZoom(amount:Float):Void
    {
        currentScaleMult = FlxMath.bound(currentScaleMult + amount, 0.4, 2.0);
        loadCurrentPhoto();
    }

    function exitGallery():Void
    {
        isBusy = true;
        FlxG.sound.play(Paths.sound('cancelMenu'));
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
        MusicBeatState.switchState(new MainMenuState());
    }
}