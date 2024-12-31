-- Copyright (C) 2017 - 2024 SmashHammer Games Inc. - All Rights Reserved.
----- Init UI -----
local win = Windows.CreateWindow()
win.SetAlignment(align_RightEdge, 20, 250)
win.SetAlignment(align_TopEdge, 80, 350)
local function onWindowClose()
    UnloadScript.Raise(ScriptName) -- Window closed, so unload this script.
end
win.OnClose.add(onWindowClose)
win.Title = 'Press <i>Tab</i> to select a part'
win.Show(true)

local forceSlider = win.CreateLabelledSlider()
forceSlider.SetAlignment(align_HorizEdges, 5, 5)
forceSlider.SetAlignment(align_TopEdge, 10, 30)
forceSlider.MinValue = 0
forceSlider.MaxValue = 1000
forceSlider.Value = 5
forceSlider.Text = 'Force'
local pverpmlabel = win.CreateLabel()
pverpmlabel.SetAlignment(align_HorizEdges, 5, 5)
pverpmlabel.SetAlignment(align_TopEdge, 50, 30)
pverpmlabel.Text = 'Pve RPM:'
local pverpm = win.CreateLabel()
pverpm.SetAlignment(align_HorizEdges, 65, 5)
pverpm.SetAlignment(align_TopEdge, 50, 30)
pverpm.Text = 'Test'
local selectedcranklabel = win.CreateLabel()
selectedcranklabel.SetAlignment(align_HorizEdges, 5, 5)
selectedcranklabel.SetAlignment(align_TopEdge, 80, 30)
selectedcranklabel.Text = 'Selected Crank:'
local selectedcrank = win.CreateLabel()
selectedcrank.SetAlignment(align_HorizEdges, 100, 5)
selectedcrank.SetAlignment(align_TopEdge, 80, 30)
selectedcrank.Text = "Test"
local Powerlabel = win.CreateLabel()
Powerlabel.SetAlignment(align_HorizEdges, 5, 5)
Powerlabel.SetAlignment(align_TopEdge, 140, 30)
Powerlabel.Text = 'Power:'
local Power = win.CreateLabel()
Power.SetAlignment(align_HorizEdges, 50, 5)
Power.SetAlignment(align_TopEdge, 140, 30)
Power.Text = "Test"
local rpmlabel = win.CreateLabel()
rpmlabel.SetAlignment(align_HorizEdges, 5, 5)
rpmlabel.SetAlignment(align_TopEdge, 110, 30)
rpmlabel.Text = 'Rpm:'
local rpm = win.CreateLabel()
rpm.SetAlignment(align_HorizEdges, 40, 5)
rpm.SetAlignment(align_TopEdge, 110, 30)
rpm.Text = "Test"
local trqlabel = win.CreateLabel()
trqlabel.SetAlignment(align_HorizEdges, 5, 5)
trqlabel.SetAlignment(align_TopEdge, 170, 30)
trqlabel.Text = 'Tourqe:'
local trq = win.CreateLabel()
trq.SetAlignment(align_HorizEdges, 55, 5)
trq.SetAlignment(align_TopEdge, 170, 30)
trq.Text = "Test"
local xlabel = win.CreateLabel()
xlabel.SetAlignment(align_HorizEdges, 5, 5)
xlabel.SetAlignment(align_TopEdge, 200, 30)
xlabel.Text = 'x:'
local _x = win.CreateLabel()
_x.SetAlignment(align_HorizEdges, 20, 5)
_x.SetAlignment(align_TopEdge, 200, 30)
_x.Text = "Test"
local ylabel = win.CreateLabel()
ylabel.SetAlignment(align_HorizEdges, 5, 5)
ylabel.SetAlignment(align_TopEdge, 230, 30)
ylabel.Text = 'y:'
local _y = win.CreateLabel()
_y.SetAlignment(align_HorizEdges, 20, 5)
_y.SetAlignment(align_TopEdge, 230, 30)
_y.Text = "Test"
local velabel = win.CreateLabel()
velabel.SetAlignment(align_HorizEdges, 5, 5)
velabel.SetAlignment(align_TopEdge, 260, 30)
velabel.Text = 've:'
local ve = win.CreateLabel()
ve.SetAlignment(align_HorizEdges, 25, 5)
ve.SetAlignment(align_TopEdge, 260, 30)
ve.Text = "Test"
local boostlabel = win.CreateLabel()
boostlabel.SetAlignment(align_HorizEdges, 5, 5)
boostlabel.SetAlignment(align_TopEdge, 290, 30)
boostlabel.Text = 'boost:'
local boost = win.CreateLabel()
boost.SetAlignment(align_HorizEdges, 45, 5)
boost.SetAlignment(align_TopEdge, 290, 30)
boost.Text = "Test"
local currentrpm = nil
local part = nil
local playerAimDirection
local targetPosition
local currentpwr = nil
local currenttrq = nil
local basePve = nil
local basePveRPM = nil
local selectedParts = {
    ['crank'] = nil,

}
local Filters = {
    ['crank'] = {'Engine Crank Rear x2 Axle Resizable', 'Engine Crank Rear x1 Axle Resizable'},
}
local boostgraph = {
          --x = current Vol. Eff. % x5, y= current RPM x500, result =  base PveRPM retard Val
          --    0    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20
          --  000  005  010  015  020  025  030  035  040  045  050  055  060  065  070  075  080  085  090  095  100
      [0] = {1500,1500,1500,1500,1500,1500,1500,1500,1500,1500,1500,1250,   0,   0,   0,   0,   0,   0,   0,   0,   0,},  -- 0000
      [1] = {1250,1250,1250,1250,1250,1250,1250,1250,1250,1250,1250,   0,-250,-250,-250,-250,-250,-750,-250,   0,   0,},  -- 0500
      [2] = {1125,1125,1125,1125,1125,1125,1125,1125,1125,1125,   0,-250,-500,-500,-500,-500,-500,-500,   0,   0,   0,},  -- 1000
      [3] = {1000,1000,1000,1000,1000,1000,1000,1000,1000,   0,-250,-500,-750,-750,-750,-750,-750,   0,   0,   0,   0,},  -- 1500
      [4] = { 500, 500, 500, 500, 500, 500, 500, 500,   0,-250,-500,-750,-800,-800,-800,-800,   0,   0,   0,   0,   0,},  -- 2000
      [5] = {   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,},  -- 2500
      [6] = {-250,-250,-250,-250,-250,-250,   0,-250,-250,-750,-800,-850,-900,-900,   0,   0,   0,   0,   0,   0,   0,},  -- 3000
      [7] = {-500,-500,-500,-500,-500,   0,-500,-500,-500,-800,-850,-900,-950,   0,   0,   0,   0,   0,   0,   0,   0,},  -- 3500
      [8] = {-750,-750,-750,-750,   0,-750,-750,-750,-750,-850,-900,-950,   0,   0,   0,   0,   0,   0,   0,   0,   0,},  -- 4000
}
----- Entry functions -----
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
        local crank = selectedParts['crank']
        if crank then
            for behaviour in crank.Behaviours do
                if behaviour.Name == 'Engine Crank' then
                    for cylinder in behaviour.LinkedCylinders do
                        local head = cylinder.Head
                        basePve = head.GetTweakable( "Peak Volumetric Efficiency" ).Value
                        basePveRPM = head.GetTweakable( "Peak Volumetric Efficiency RPM" ).Value
                    end
                end
            end
        end
    end
    local crank = selectedParts['crank']
    if crank then
        selectedcrank.Text = crank.AssetName
        for behaviour in crank.Behaviours do
            for channel in behaviour.Channels do
                if type( channel.Value ) == 'number' and channel.Label == 'RPM' then
                    currentrpm = channel.Value
                    rpm.Text = currentrpm
                end
                if type( channel.Value ) == 'number' and channel.Label == 'Torque (Nm)' then
                    currenttrq = channel.Value
                    trq.Text = currenttrq
                end
                if type( channel.Value ) == 'number' and channel.Label == 'Power' then
                    currentpwr = channel.Value
                    Power.Text = currentpwr
                end
            end
            if behaviour.Name == 'Engine Crank' then
                for cylinder in behaviour.LinkedCylinders do
                    local head = cylinder.Head
                    local _maxrpm = head.GetTweakable( "Max RPM" ) 
                    local int_maxrpm = _maxrpm.Value
                    local Pve = head.GetTweakable( "Peak Volumetric Efficiency" ) 
                    local int_Pve = Pve.Value
                    local Pverpm = head.GetTweakable( "Peak Volumetric Efficiency RPM" ) 
                    local int_Pverpm = Pverpm.Value
                    pverpm.Text = int_Pverpm
                    local y = math.floor(currentrpm / 500)
                    local currentVe = nil
                    for channel in head.Channels do
                        if channel.Label == 'Volumetric Efficiency (%)' then
                            currentVe = channel.Value
                        end
                    end
                    currentVe = (currentVe / (basePve*100)) * 100
                    local x = math.floor(currentVe/5)
                    _x.Text = x
                    _y.Text = y
                    ve.Text = math.floor(currentVe)
                    local boostval = boostgraph[y][x]
                    boost.Text = boostval
                    Pverpm.Value = basePveRPM - boostval
                    head.SyncTweakables()
                end
            end
        end
    end
end

function Cleanup()
    Windows.DestroyWindow(win)
end
