local boom = false

function onUpdate()
setProperty('camZoomingMult', false)
end

function onStepHit()
if boom then
    if curStep % 4 == 0 then
 triggerEvent("Add Camera Zoom",0.04, 0.04)
 end
    if curStep % 8 == 0 then
 triggerEvent("Add Camera Zoom",0.03, 0.03)
 end
end
end

function onBeatHit()
if curBeat == 32 then
  boom = true		
end
if curBeat == 224 then
  boom = false		
end
if curBeat == 256 then
  boom = true		
 end
end