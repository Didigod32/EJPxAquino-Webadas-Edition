local ghostEnabled = false
local ghostTag = 0

local startStep = 512
local endStep = 576

function onStepHit()

    ghostEnabled = curStep >= startStep and curStep < endStep

end

function goodNoteHit(id, direction, noteType, isSustainNote)

    if ghostEnabled and not isSustainNote then
        makeGhost('boyfriend')
    end

end

function opponentNoteHit(id, direction, noteType, isSustainNote)

    if ghostEnabled and not isSustainNote then
        makeGhost('dad')
    end

end

function makeGhost(char)

    ghostTag = ghostTag + 1

    local tag = 'ghost'..ghostTag

    makeAnimatedLuaSprite(
        tag,
        getProperty(char..'.imageFile'),
        getProperty(char..'.x'),
        getProperty(char..'.y')
    )

    addAnimationByPrefix(
        tag,
        'anim',
        getProperty(char..'.animation.curAnim.name'),
        24,
        false
    )

    objectPlayAnimation(tag, 'anim', true)

    setProperty(tag..'.alpha', 0.35)

    setProperty(tag..'.flipX', getProperty(char..'.flipX'))

    setProperty(tag..'.scale.x', getProperty(char..'.scale.x'))
    setProperty(tag..'.scale.y', getProperty(char..'.scale.y'))

    setProperty(tag..'.offset.x', getProperty(char..'.offset.x'))
    setProperty(tag..'.offset.y', getProperty(char..'.offset.y'))

    addLuaSprite(tag, false)

    doTweenAlpha(
        tag..'Fade',
        tag,
        0,
        0.25,
        'linear'
    )

    runTimer(tag..'Delete', 0.25)

end

function onTimerCompleted(tag)

    if string.find(tag, 'Delete') then

        local sprite = string.gsub(tag, 'Delete', '')

        removeLuaSprite(sprite, true)

    end
end
