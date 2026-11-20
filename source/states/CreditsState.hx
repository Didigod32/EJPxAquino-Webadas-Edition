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

typedef CreditPerson =
{
    var name:String;
    var icon:String;
    var role:String;
    var desc:String;
    var socialUrl:String;
}

typedef SlideData =
{
    var isSectionTitle:Bool;
    var sectionTitle:String;
    var sectionSubtitle:String;
    var persons:Array<CreditPerson>;
    var speakerNote:String;
}

typedef PersonSlotUI =
{
    var avatar:FlxSprite;
    var name:FlxText;
    var role:FlxText;
    var desc:FlxText;
    var linkBtn:FlxSprite;
    var linkTxt:FlxText;
}

class CreditsState extends MusicBeatState
{
    var curSelected:Int = 0;
    var slides:Array<SlideData> = [];

    // Fondo Escritorio
    var desktopBg:FlxSprite;

    // Splash Microsoft 365
    var splashGroup:FlxTypedGroup<FlxSprite>;
    var splashShadow:FlxSprite;
    var splashCard:FlxSprite;
    var splashItemsGroup:FlxTypedGroup<FlxSprite>;
    var splashTextsGroup:FlxTypedGroup<FlxText>;
    var isStartingUp:Bool = true;
    var startupTimer:Float = 0;
    final STARTUP_DURATION:Float = 2.0;

    // Interfaz PowerPoint Dark Mode
    var pptGroup:FlxTypedGroup<FlxSprite>;
    var pptTextsGroup:FlxTypedGroup<FlxText>;

    // Botones de Ventana
    var titleBar:FlxSprite;
    var closeBtnBg:FlxSprite;
    var closeBtnTxt:FlxText;

    // Miniaturas Laterales
    var thumbCards:Array<FlxSprite> = [];
    var thumbNumbers:Array<FlxText> = [];

    // Diapositiva Principal (Estilo Faceta)
    var slideBg:FlxSprite;
    var slideRedTag:FlxSprite;
    var slideGuideBox:FlxSprite;

    // Elementos de Título (Sección)
    var sectionHeaderTxt:FlxText;
    var sectionDivider:FlxSprite;
    var sectionSubTxt:FlxText;

    // Ranuras para hasta 4 Integrantes por lámina (Cuadrícula 2x2)
    var personSlots:Array<PersonSlotUI> = [];

    // Notas del Orador
    var notesBodyTxt:FlxText;

    var isBusy:Bool = false;

    // Paleta de Colores
    final COLOR_TEAL_SLIDE:FlxColor = FlxColor.fromRGB(23, 75, 83);
    final COLOR_RED_TAG:FlxColor = FlxColor.fromRGB(205, 36, 42);
    final COLOR_DARK_BG:FlxColor = FlxColor.fromRGB(25, 25, 27);

    override function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        FlxG.mouse.visible = true;

        if (FlxG.sound.music == null || !FlxG.sound.music.playing)
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);

        parseCredits();

        desktopBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(20, 22, 26));
        add(desktopBg);

        pptGroup = new FlxTypedGroup<FlxSprite>();
        pptTextsGroup = new FlxTypedGroup<FlxText>();
        add(pptGroup);
        add(pptTextsGroup);

        buildFacetThemeUI();

        pptGroup.visible = false;
        pptTextsGroup.visible = false;

        buildModernSplashScreen();

        super.create();
    }

    function parseCredits():Void
    {
        slides = [];
        var rawLines:Array<String> = [];

        try {
            rawLines = CoolUtil.coolTextFile(Paths.txt('credits'));
        } catch (e:Dynamic) {
            rawLines = [];
        }

        if (rawLines.length == 0)
        {
            slides.push({
                isSectionTitle: true,
                sectionTitle: "P-Slice Team",
                sectionSubtitle: "MOTOR BASE Y OPTIMIZACIONES DEL MOD",
                persons: [],
                speakerNote: "Nota: Créditos a los creadores del motor base."
            });
            slides.push({
                isSectionTitle: false,
                sectionTitle: "",
                sectionSubtitle: "",
                persons: [
                    {name: "Diego Alexander", icon: "lechad", role: "Director / Programador", desc: "Diseño y programación de interfaces.", socialUrl: "https://twitter.com"},
                    {name: "Colaborador 1", icon: "lechad", role: "Tester / Chart", desc: "Revisión de patrones y notas.", socialUrl: ""},
                    {name: "Artista Principal", icon: "lechad", role: "Arte / Sprites", desc: "Ilustraciones del mod.", socialUrl: ""},
                    {name: "Músico Invitado", icon: "lechad", role: "Compositor", desc: "Pistas adicionales del proyecto.", socialUrl: ""}
                ],
                speakerNote: "Nota: Cuatro integrantes cargados correctamente."
            });
            return;
        }

        for (line in rawLines)
        {
            var trimmed:String = line.trim();
            if (trimmed.length == 0) continue;

            if (trimmed.startsWith("SECTION::"))
            {
                var parts = trimmed.split("::");
                slides.push({
                    isSectionTitle: true,
                    sectionTitle: parts[1].trim(),
                    sectionSubtitle: (parts.length >= 3) ? parts[2].trim().toUpperCase() : "",
                    persons: [],
                    speakerNote: (parts.length >= 4) ? parts[3].trim() : "Haga clic para agregar notas."
                });
            }
            else
            {
                var sideSplit = trimmed.split("||");
                var personsArr:Array<CreditPerson> = [];
                var note:String = "Haga clic para agregar notas.";

                for (segment in sideSplit)
                {
                    var segParts = segment.split("::");
                    if (segParts.length >= 5)
                    {
                        personsArr.push({
                            name: segParts[0].trim(),
                            icon: segParts[1].trim(),
                            role: segParts[2].trim(),
                            desc: segParts[3].replace("\\n", "\n").trim(),
                            socialUrl: segParts[4].trim()
                        });
                        if (segParts.length >= 6) note = segParts[5].replace("\\n", "\n").trim();
                    }
                }

                if (personsArr.length > 0)
                {
                    slides.push({
                        isSectionTitle: false,
                        sectionTitle: "",
                        sectionSubtitle: "",
                        persons: personsArr,
                        speakerNote: note
                    });
                }
            }
        }
    }

    function buildModernSplashScreen():Void
    {
        splashGroup = new FlxTypedGroup<FlxSprite>();
        splashItemsGroup = new FlxTypedGroup<FlxSprite>();
        splashTextsGroup = new FlxTypedGroup<FlxText>();

        add(splashGroup);
        add(splashItemsGroup);
        add(splashTextsGroup);

        var cardW:Float = 450;
        var cardH:Float = 260;
        var cardX:Float = (FlxG.width - cardW) / 2;
        var cardY:Float = (FlxG.height - cardH) / 2;

        splashShadow = new FlxSprite(cardX + 8, cardY + 8).makeGraphic(Std.int(cardW), Std.int(cardH), FlxColor.fromRGB(15, 15, 20));
        splashShadow.alpha = 0.4;
        splashGroup.add(splashShadow);

        splashCard = new FlxSprite(cardX, cardY).makeGraphic(Std.int(cardW), Std.int(cardH), FlxColor.WHITE);
        splashGroup.add(splashCard);

        var tagBg = new FlxSprite(cardX + 16, cardY + 14).makeGraphic(90, 18, FlxColor.fromRGB(254, 238, 236));
        splashItemsGroup.add(tagBg);

        var tagTxt = new FlxText(cardX + 16, cardY + 16, 90, "Microsoft 365", 9);
        tagTxt.setFormat(Paths.font("vcr.ttf"), 9, FlxColor.fromRGB(216, 59, 1), CENTER);
        splashTextsGroup.add(tagTxt);

        var winButtons = new FlxText(cardX + cardW - 70, cardY + 12, 60, "-  []  X", 10);
        winButtons.setFormat(Paths.font("vcr.ttf"), 10, FlxColor.fromRGB(160, 160, 160), RIGHT);
        splashTextsGroup.add(winButtons);

        var splashLogo = new FlxSprite(cardX + (cardW - 80) / 2, cardY + 75);
        if (Paths.fileExists('images/ppoint.png', IMAGE))
        {
            splashLogo.loadGraphic(Paths.image('ppoint'));
            splashLogo.setGraphicSize(80, 80);
            splashLogo.updateHitbox();
        }
        else
        {
            splashLogo.makeGraphic(80, 80, FlxColor.fromRGB(210, 71, 38));
        }
        splashItemsGroup.add(splashLogo);

        var brandTxt = new FlxText(cardX, cardY + 168, cardW, "Microsoft", 13);
        brandTxt.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(90, 90, 90), CENTER);
        splashTextsGroup.add(brandTxt);

        var statusTxt = new FlxText(cardX + 18, cardY + cardH - 24, cardW - 36, "Iniciando Microsoft PowerPoint...", 10);
        statusTxt.setFormat(Paths.font("vcr.ttf"), 10, FlxColor.fromRGB(130, 130, 130), LEFT);
        splashTextsGroup.add(statusTxt);
    }

    function buildFacetThemeUI():Void
    {
        // Fondo General
        var darkWorkspace = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, COLOR_DARK_BG);
        pptGroup.add(darkWorkspace);

        // 1. Barra de Título Superior
        titleBar = new FlxSprite(0, 0).makeGraphic(FlxG.width, 30, FlxColor.fromRGB(20, 20, 22));
        pptGroup.add(titleBar);

        var titleTxt = new FlxText(16, 7, FlxG.width - 200, "Créditos_AquinoMod.pptx - PowerPoint", 12);
        titleTxt.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(200, 200, 205), LEFT);
        pptTextsGroup.add(titleTxt);

        var minBtn = new FlxText(FlxG.width - 120, 6, 35, "—", 13);
        minBtn.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(180, 180, 180), CENTER);
        pptTextsGroup.add(minBtn);

        var maxBtn = new FlxText(FlxG.width - 82, 6, 35, "□", 13);
        maxBtn.setFormat(Paths.font("vcr.ttf"), 13, FlxColor.fromRGB(180, 180, 180), CENTER);
        pptTextsGroup.add(maxBtn);

        // BOTÓN "X" VISIBLE Y NÍTIDO
        closeBtnBg = new FlxSprite(FlxG.width - 46, 0).makeGraphic(46, 30, FlxColor.fromRGB(196, 43, 28));
        pptGroup.add(closeBtnBg);

        closeBtnTxt = new FlxText(FlxG.width - 46, 6, 46, "X", 14);
        closeBtnTxt.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        pptTextsGroup.add(closeBtnTxt);

        // 2. Barra de Pestañas Superior en Español (Limpia)
        var tabsBarBg = new FlxSprite(0, 30).makeGraphic(FlxG.width, 30, FlxColor.fromRGB(30, 30, 33));
        pptGroup.add(tabsBarBg);

        var tabsTxt = new FlxText(16, 37, FlxG.width - 40, "Archivo    Inicio    Insertar    Dibujar    Diseño    Transiciones    Animaciones    Presentación con diapositivas    Vista", 11);
        tabsTxt.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.fromRGB(215, 215, 220), LEFT);
        pptTextsGroup.add(tabsTxt);

        // Subrayado naranja sobre pestaña activa "Inicio"
        var homeUnderline = new FlxSprite(84, 58).makeGraphic(42, 2, FlxColor.fromRGB(225, 75, 40));
        pptGroup.add(homeUnderline);

        var ribbonBottomDivider = new FlxSprite(0, 60).makeGraphic(FlxG.width, 1, FlxColor.fromRGB(48, 48, 52));
        pptGroup.add(ribbonBottomDivider);

        // 3. Barra Lateral Izquierda (Miniaturas de Diapositivas)
        var sidebarW:Float = 185;
        var sidebarBg = new FlxSprite(0, 61).makeGraphic(Std.int(sidebarW), FlxG.height - 61, FlxColor.fromRGB(22, 22, 24));
        pptGroup.add(sidebarBg);

        var sideHeader = new FlxText(16, 70, 160, "Diapositivas", 11);
        sideHeader.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.fromRGB(150, 155, 165), LEFT);
        pptTextsGroup.add(sideHeader);

        thumbCards = [];
        thumbNumbers = [];

        var thumbY:Float = 94;
        for (i in 0...slides.length)
        {
            var posY:Float = thumbY + (i * 74);

            var numTxt = new FlxText(6, posY + 22, 18, '${i + 1}', 11);
            numTxt.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.fromRGB(170, 170, 175), CENTER);
            pptTextsGroup.add(numTxt);
            thumbNumbers.push(numTxt);

            var tCard = new FlxSprite(28, posY).makeGraphic(145, 60, COLOR_TEAL_SLIDE);
            tCard.ID = i;
            pptGroup.add(tCard);
            thumbCards.push(tCard);

            var tRedTag = new FlxSprite(28 + 145 - 14, posY).makeGraphic(9, 20, COLOR_RED_TAG);
            pptGroup.add(tRedTag);

            var label:String = slides[i].isSectionTitle ? slides[i].sectionTitle : (slides[i].persons.length > 0 ? slides[i].persons[0].name : "Diapositiva");
            var tLabel = new FlxText(32, posY + 18, 130, label, 10);
            tLabel.setFormat(Paths.font("vcr.ttf"), 10, FlxColor.WHITE, CENTER);
            pptTextsGroup.add(tLabel);
        }

        // 4. Diapositiva Central (Lámina Faceta con mayor altura)
        var canvasX:Float = sidebarW + 25;
        var canvasY:Float = 75;
        var canvasW:Float = FlxG.width - sidebarW - 50;
        var canvasH:Float = FlxG.height - 165;

        slideBg = new FlxSprite(canvasX, canvasY).makeGraphic(Std.int(canvasW), Std.int(canvasH), COLOR_TEAL_SLIDE);
        pptGroup.add(slideBg);

        slideRedTag = new FlxSprite(canvasX + canvasW - 70, canvasY).makeGraphic(45, 95, COLOR_RED_TAG);
        pptGroup.add(slideRedTag);

        slideGuideBox = new FlxSprite(canvasX + 35, canvasY + 35).makeGraphic(Std.int(canvasW - 70), Std.int(canvasH - 70), FlxColor.TRANSPARENT);
        flixel.util.FlxSpriteUtil.drawRect(slideGuideBox, 0, 0, canvasW - 70, canvasH - 70, FlxColor.TRANSPARENT, {thickness: 1, color: FlxColor.fromRGB(255, 255, 255)});
        slideGuideBox.alpha = 0.25;
        pptGroup.add(slideGuideBox);

        // Título de Sección
        sectionHeaderTxt = new FlxText(canvasX + 40, canvasY + 175, canvasW - 80, "", 48);
        sectionHeaderTxt.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, CENTER);
        pptTextsGroup.add(sectionHeaderTxt);

        sectionDivider = new FlxSprite(canvasX + 150, canvasY + 255).makeGraphic(Std.int(canvasW - 300), 2, FlxColor.WHITE);
        sectionDivider.alpha = 0.7;
        pptGroup.add(sectionDivider);

        sectionSubTxt = new FlxText(canvasX + 40, canvasY + 280, canvasW - 80, "", 22);
        sectionSubTxt.setFormat(Paths.font("vcr.ttf"), 22, FlxColor.fromRGB(220, 235, 240), CENTER);
        pptTextsGroup.add(sectionSubTxt);

        // Generar 4 Ranuras para Integrantes (Cuadrícula 2 Columnas x 2 Filas)
        personSlots = [];
        for (idx in 0...4)
        {
            var col:Int = idx % 2;
            var row:Int = Std.int(idx / 2);

            var slotX:Float = canvasX + 50 + (col * 490);
            var slotY:Float = canvasY + 50 + (row * 220);

            var av = new FlxSprite(slotX, slotY);
            pptGroup.add(av);

            var nTxt = new FlxText(slotX + 105, slotY + 2, 360, "", 22);
            nTxt.setFormat(Paths.font("vcr.ttf"), 22, FlxColor.WHITE, LEFT);
            pptTextsGroup.add(nTxt);

            var rTxt = new FlxText(slotX + 105, slotY + 30, 360, "", 14);
            rTxt.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.fromRGB(200, 225, 230), LEFT);
            pptTextsGroup.add(rTxt);

            var dTxt = new FlxText(slotX + 105, slotY + 54, 360, "", 12);
            dTxt.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(235, 245, 250), LEFT);
            pptTextsGroup.add(dTxt);

            var lBtn = new FlxSprite(slotX + 105, slotY + 105).makeGraphic(150, 26, FlxColor.fromRGB(15, 55, 62));
            pptGroup.add(lBtn);

            var lTxt = new FlxText(slotX + 105, slotY + 110, 150, "🌐 Red Social", 11);
            lTxt.setFormat(Paths.font("vcr.ttf"), 11, FlxColor.WHITE, CENTER);
            pptTextsGroup.add(lTxt);

            personSlots.push({
                avatar: av,
                name: nTxt,
                role: rTxt,
                desc: dTxt,
                linkBtn: lBtn,
                linkTxt: lTxt
            });
        }

        // 5. Panel Inferior de Notas del Orador
        var notesY:Float = FlxG.height - 75;
        var notesBg = new FlxSprite(canvasX, notesY).makeGraphic(Std.int(canvasW), 65, FlxColor.fromRGB(22, 22, 24));
        pptGroup.add(notesBg);

        var nHeader = new FlxText(canvasX + 16, notesY + 6, 300, "Notas del orador:", 10);
        nHeader.setFormat(Paths.font("vcr.ttf"), 10, FlxColor.fromRGB(130, 135, 145), LEFT);
        pptTextsGroup.add(nHeader);

        notesBodyTxt = new FlxText(canvasX + 16, notesY + 24, canvasW - 32, "", 12);
        notesBodyTxt.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.fromRGB(210, 215, 220), LEFT);
        pptTextsGroup.add(notesBodyTxt);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        FlxG.mouse.visible = true;

        if (isStartingUp)
        {
            startupTimer += elapsed;

            if (startupTimer >= STARTUP_DURATION)
            {
                isStartingUp = false;

                splashItemsGroup.visible = false;
                splashTextsGroup.visible = false;
                splashShadow.visible = false;

                FlxTween.tween(splashCard, {
                    x: 0,
                    y: 0,
                    "scale.x": FlxG.width / splashCard.width,
                    "scale.y": FlxG.height / splashCard.height
                }, 0.35, {
                    ease: FlxEase.cubeOut,
                    onComplete: function(_) {
                        splashGroup.visible = false;
                        pptGroup.visible = true;
                        pptTextsGroup.visible = true;
                        updateSlideSelection();
                    }
                });
            }
            return;
        }

        if (isBusy) return;

        if (controls.BACK || FlxG.keys.justPressed.ESCAPE)
        {
            exitCredits();
            return;
        }

        if (controls.UI_UP_P || controls.UI_LEFT_P) changeSlide(-1);
        if (controls.UI_DOWN_P || controls.UI_RIGHT_P) changeSlide(1);

        if (FlxG.mouse.wheel != 0)
            changeSlide(-FlxG.mouse.wheel);

        if (FlxG.mouse.justPressed)
        {
            if (FlxG.mouse.overlaps(closeBtnBg) || FlxG.mouse.overlaps(closeBtnTxt))
            {
                exitCredits();
                return;
            }

            var curSlide = slides[curSelected];
            if (!curSlide.isSectionTitle)
            {
                for (i in 0...curSlide.persons.length)
                {
                    var p = curSlide.persons[i];
                    if (p.socialUrl != "" && (FlxG.mouse.overlaps(personSlots[i].linkBtn) || FlxG.mouse.overlaps(personSlots[i].linkTxt)))
                    {
                        CoolUtil.browserLoad(p.socialUrl);
                        return;
                    }
                }
            }

            for (i in 0...thumbCards.length)
            {
                if (FlxG.mouse.overlaps(thumbCards[i]))
                {
                    if (curSelected != i)
                    {
                        curSelected = i;
                        changeSlide(0);
                    }
                    return;
                }
            }
        }
    }

    function changeSlide(change:Int = 0):Void
    {
        if (slides.length == 0) return;

        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected = FlxMath.wrap(curSelected + change, 0, slides.length - 1);
        updateSlideSelection();
    }

    function updateSlideSelection():Void
    {
        if (slides.length == 0) return;
        var slide = slides[curSelected];

        for (i in 0...thumbCards.length)
        {
            if (i == curSelected)
            {
                thumbCards[i].color = FlxColor.fromRGB(35, 105, 115);
                thumbNumbers[i].color = FlxColor.fromRGB(240, 75, 80);
            }
            else
            {
                thumbCards[i].color = COLOR_TEAL_SLIDE;
                thumbNumbers[i].color = FlxColor.fromRGB(150, 150, 150);
            }
        }

        notesBodyTxt.text = slide.speakerNote;

        if (slide.isSectionTitle)
        {
            sectionHeaderTxt.text = slide.sectionTitle;
            sectionSubTxt.text = slide.sectionSubtitle;
            sectionHeaderTxt.visible = true;
            sectionDivider.visible = true;
            sectionSubTxt.visible = true;

            for (slot in personSlots)
                setSlotVisible(slot, false);
        }
        else
        {
            sectionHeaderTxt.visible = false;
            sectionDivider.visible = false;
            sectionSubTxt.visible = false;

            for (i in 0...4)
            {
                if (i < slide.persons.length)
                {
                    loadSlotData(personSlots[i], slide.persons[i]);
                    setSlotVisible(personSlots[i], true);
                }
                else
                {
                    setSlotVisible(personSlots[i], false);
                }
            }
        }

        slideBg.alpha = 0.7;
        FlxTween.tween(slideBg, {alpha: 1.0}, 0.15, {ease: FlxEase.quadOut});
    }

    function loadSlotData(slot:PersonSlotUI, p:CreditPerson):Void
    {
        slot.name.text = p.name;
        slot.role.text = p.role;
        slot.desc.text = p.desc;

        var iconKey = (p.icon != "") ? p.icon : "lechad";
        if (Paths.fileExists('images/credits/' + iconKey + '.png', IMAGE))
            slot.avatar.loadGraphic(Paths.image('credits/' + iconKey));
        else if (Paths.fileExists('images/' + iconKey + '.png', IMAGE))
            slot.avatar.loadGraphic(Paths.image(iconKey));
        else
            slot.avatar.loadGraphic(Paths.image('lechad'));

        slot.avatar.setGraphicSize(85, 85);
        slot.avatar.updateHitbox();

        slot.linkBtn.visible = (p.socialUrl != "");
        slot.linkTxt.visible = (p.socialUrl != "");
    }

    function setSlotVisible(slot:PersonSlotUI, vis:Bool):Void
    {
        slot.avatar.visible = vis;
        slot.name.visible = vis;
        slot.role.visible = vis;
        slot.desc.visible = vis;
        slot.linkBtn.visible = vis;
        slot.linkTxt.visible = vis;
    }

    function exitCredits():Void
    {
        isBusy = true;
        FlxG.sound.play(Paths.sound('cancelMenu'));
        MusicBeatState.switchState(new MainMenuState());
    }
}