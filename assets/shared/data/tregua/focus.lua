local focusEnabled = false

local startStep = 512
local endStep = 576

function onCreate()

    makeLuaSprite('dramaticBlackBG', '', -800, -400)
    makeGraphic('dramaticBlackBG', screenWidth * 4, screenHeight * 4, '000000')

    setProperty('dramaticBlackBG.alpha', 0)
    addLuaSprite('dramaticBlackBG', false)

end

function onStepHit()

    if curStep >= startStep and curStep < endStep then

        if not focusEnabled then

            focusEnabled = true

            doTweenAlpha(
                'dramaticBGIn',
                'dramaticBlackBG',
                0.35,
                0.4,
                'linear'
            )

        end

    else

        if focusEnabled then

            focusEnabled = false

            resetFocus()

            doTweenAlpha(
                'dramaticBGOut',
                'dramaticBlackBG',
                0,
                0.4,
                'linear'
            )

        end

    end

end

function goodNoteHit(id, direction, noteType, isSustainNote)

    if focusEnabled and not isSustainNote then
        focusBF()
    end

end

function opponentNoteHit(id, direction, noteType, isSustainNote)

    if focusEnabled and not isSustainNote then
        focusDad()
    end

end

function focusBF()

    doTweenAlpha('dadFade', 'dad', 0.5, 0.12, 'linear')
    doTweenAlpha('gfFade', 'gf', 0.45, 0.12, 'linear')

    doTweenAlpha('bfFocus', 'boyfriend', 1, 0.12, 'linear')

    doTweenColor('dadColor', 'dad', '666666', 0.12, 'linear')
    doTweenColor('gfColor', 'gf', '666666', 0.12, 'linear')

    doTweenColor('bfColor', 'boyfriend', 'FFFFFF', 0.12, 'linear')

end

function focusDad()

    doTweenAlpha('bfFade', 'boyfriend', 0.5, 0.12, 'linear')
    doTweenAlpha('gfFade', 'gf', 0.45, 0.12, 'linear')

    doTweenAlpha('dadFocus', 'dad', 1, 0.12, 'linear')

    doTweenColor('bfColor', 'boyfriend', '666666', 0.12, 'linear')
    doTweenColor('gfColor', 'gf', '666666', 0.12, 'linear')

    doTweenColor('dadColor', 'dad', 'FFFFFF', 0.12, 'linear')

end

function resetFocus()

    doTweenAlpha('dadReset', 'dad', 1, 0.2, 'linear')
    doTweenAlpha('bfReset', 'boyfriend', 1, 0.2, 'linear')
    doTweenAlpha('gfReset', 'gf', 1, 0.2, 'linear')

    doTweenColor('dadResetColor', 'dad', 'FFFFFF', 0.2, 'linear')
    doTweenColor('bfResetColor', 'boyfriend', 'FFFFFF', 0.2, 'linear')
    doTweenColor('gfResetColor', 'gf', 'FFFFFF', 0.2, 'linear')

end