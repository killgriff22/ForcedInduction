-- Copyright (C) 2017 - 2024 SmashHammer Games Inc. - All Rights Reserved.
----- Init UI -----
local win = Windows.CreateWindow()
win.SetAlignment(align_RightEdge, 20, 250)
win.SetAlignment(align_TopEdge, 80, 250)
local function onWindowClose()
    UnloadScript.Raise(ScriptName) -- Window closed, so unload this script.
end
win.OnClose.add(onWindowClose)
win.Title = 'Press <i>Tab</i> to select a part'
win.Show(true)

local forceSlider = win.CreateLabelledSlider()
forceSlider.SetAlignment(align_HorizEdges, 5, 5)
forceSlider.SetAlignment(align_TopEdge, 10, 30)
forceSlider.MinValue = -10
forceSlider.MaxValue = 10
forceSlider.Value = -5
forceSlider.Text = 'Force'
local maxrpmslider = win.CreateLabelledSlider()
maxrpmslider.SetAlignment(align_HorizEdges, 5, 5)
maxrpmslider.SetAlignment(align_TopEdge, 50, 30)
maxrpmslider.MinValue = 0
maxrpmslider.MaxValue = 10000
maxrpmslider.Value = 4000
maxrpmslider.Text = 'RPM:'
local selectedcranklabel = win.CreateLabel()
selectedcranklabel.SetAlignment(align_HorizEdges, 5, 5)
selectedcranklabel.SetAlignment(align_TopEdge, 80, 30)
selectedcranklabel.Text = 'Selected Crank:'
local selectedcrank = win.CreateLabel()
selectedcrank.SetAlignment(align_HorizEdges, 100, 5)
selectedcrank.SetAlignment(align_TopEdge, 80, 30)
selectedcrank.Text = "Test"
local selectedchrgrlabel = win.CreateLabel()
selectedchrgrlabel.SetAlignment(align_HorizEdges, 5, 5)
selectedchrgrlabel.SetAlignment(align_TopEdge, 110, 30)
selectedchrgrlabel.Text = 'Selected Charger:'
local selectedchrgr = win.CreateLabel()
selectedchrgr.SetAlignment(align_HorizEdges, 115, 5)
selectedchrgr.SetAlignment(align_TopEdge, 110, 30)
selectedchrgr.Text = "Test"
local rpmlabel = win.CreateLabel()
rpmlabel.SetAlignment(align_HorizEdges, 5, 5)
rpmlabel.SetAlignment(align_TopEdge, 140, 30)
rpmlabel.Text = 'Rpm:'
local rpm = win.CreateLabel()
rpm.SetAlignment(align_HorizEdges, 40, 5)
rpm.SetAlignment(align_TopEdge, 140, 30)
rpm.Text = "Test"
local trqlabel = win.CreateLabel()
trqlabel.SetAlignment(align_HorizEdges, 5, 5)
trqlabel.SetAlignment(align_TopEdge, 170, 30)
trqlabel.Text = 'Tourqe:'
local trq = win.CreateLabel()
trq.SetAlignment(align_HorizEdges, 55, 5)
trq.SetAlignment(align_TopEdge, 170, 30)
trq.Text = "Test"
local currentrpm = nil
local part = nil
local playerAimDirection
local targetPosition
local selectedParts = {
    ['crank'] = nil,

}
local Filters = {
    ['crank'] = {'Engine Crank Rear x2 Axle Resizable', 'Engine Crank Rear x1 Axle Resizable'},
--    ['chargerside'] = {'Bevel Gear Hi x2 (16T)', 'Bevel Gear Lo x2 (16T)', 'Spur Gear x1 (8T)', 'Spur Gear x1.25 (10T)',
--                       'Spur Gear x1.5 (12T)', 'Clutch Gear x1 (8T)', 'Clutch Gear x1.5 (12T)', 'Ratchet Gear x1 (8T)',
--                       'Ratchet Gear x1.5 (12T)'}
}
function keepLeftmostDigits(num, digits)
    local str = tostring(num)
    return tonumber(str:sub(1, digits))
end
----- Entry functions -----
function Update()
    for partName, part in pairs(selectedParts) do
        if part then
            if partName == 'crank' then
                selectedcrank.Text = part.AssetName
                for behaviour in part.Behaviours do
                    for channel in behaviour.Channels do
                        if type( channel.Value ) == 'number' and channel.Label == 'RPM' then
                            currentrpm = channel.Value
                        end
                    end
                end
                rpm.Text = currentrpm
                local diff = maxrpmslider.Value - currentrpm
                local torque = diff / 10
                trq.Text = torque
            end
        end
    end
end
function FixedUpdate()
    local localPlayer = LocalPlayer.Value
    local targetedPart
    if localPlayer and localPlayer.Targeter then
        targetedPart = localPlayer.Targeter.TargetedPart
    end
    -- Check for keyboard shortcuts.
    if Input.GetKey('tab') then
        if targetedPart then
            for partName, filter in pairs(Filters) do
                    for _, partFilter in pairs(filter) do
                        if targetedPart.AssetName == partFilter or targetedPart.FullDisplayName == partFilter then
                            selectedParts[partName] = targetedPart
                            print('Selected part: ' .. partName)
                    end
                end
            end
        end
    end
    local crank = selectedParts['crank']
    if crank then
        local force = forceSlider.Value
        local maxrpm = maxrpmslider.Value
        local diff = maxrpm - currentrpm
        local torque = diff / 10
        crank.ApplyForce( (Vector3.Forward)* torque, crank.Position, forceMode_Force )
    end
end

function Cleanup()
    Windows.DestroyWindow(win)
end
