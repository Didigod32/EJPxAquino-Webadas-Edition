function onEvent(n, v1, v2) {
    if (n == 'Misterio Events') {
        if (v1 == 'pixel') {
            if (v2 == '1') {
                PlayState.isPixelStage = true;
                PlayState.stageUI = 'pixel';
            } else {
                PlayState.isPixelStage = false;
                PlayState.stageUI = 'normal';
            }
            for (i in 0...game.strumLineNotes.length) game.strumLineNotes.members[i].reloadNote();
        }
    }
}

function onSpawnNote(note) {
    for (notes in game.notes.members) {
        notes.reloadNote();
    }
    
    if (PlayState.isPixelStage) {
        if (note.isSustainNote) {
            note.offsetX -= 12;
            note.scale.y *= Note.SUSTAIN_SIZE / note.frameHeight;
            note.scale.y /= game.playbackRate;
            note.updateHitbox();
        }
    }
}