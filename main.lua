--CONFIG
local SelectorKey = 'tab'










-- Copyright (C) 2017 - 2024 SmashHammer Games Inc. - All Rights Reserved.
----- Init UI -----
local win = Windows.CreateWindow()
win.SetAlignment(align_RightEdge, 20, 300)
win.SetAlignment(align_TopEdge, 80, 30)
local function onWindowClose()
    UnloadScript.Raise(ScriptName) -- Window closed, so unload this script.
end
win.OnClose.add(onWindowClose)
win.Title = 'Use <b>'.. SelectorKey .. '</b> to select a construction'
win.Show(true)
local basePveRPM = nil
local part = nil
local selectedParts = {
    ['crank'] = nil,
}
local Filters = {
    ['crank'] = {'Engine Crank Rear x2 Axle Resizable', 'Engine Crank Rear x1 Axle Resizable'},
}
local availible_Inputs = {
    [0]='RPM',
    [1]='Power',
    [2]='Torque',
    [3]='Vol. Eff.',
    [4]='throttle angle',
    [5]='Fuel Flow rate',
    [6]='intake flow rate',
}
local availible_Outputs = {
    [0]='Peak Power %',
    [1]='Peak Power RPM',
    [2]='Throttle Idle Min angle',
    [3]='Throttle Idle RPM',
    [4]='Max RPM',
    [5]='Fuel Ratio',
    [6]='Exhaust Effect',
    [7]='Peak Power RPM Retard'
}
local function CreateWindow(l, w, closefunc)
    local win = Windows.CreateWindow()
    win.SetAlignment(align_RightEdge, 20, l)
    win.SetAlignment(align_TopEdge, 80, w)
    win.OnClose.add(closefunc)
    win.Title = ""
    win.Show(true)
    return win
end
local Maps = {
    [0] = {
        --          0      1      2      3      4      5      6      7      8      9     10     11     12     13     14     15     16     17     18     19     20
        [0] = {     0,   200,   400,   600,   800,  1000,  1200,  1400,  1600,  1800,  2000,  2200,  2400,  2600,  2800,  3000,  3200,  3400,  3600,  3800,  4000,},  
        [1] = {   250,   350,   450,   550,   650,   750,   850,   950,  1050,  1150,  1250,  1350,  1450,  1550,  1650,  1750,  1850,  1950,  2050,  2150,   500,},  
        [2] = {   500,   600,   700,   800,   900,  1000,  1100,  1200,  1300,  1400,  1500,  1600,  1700,  1800,  1900,  2000,  2100,  2200,  2300,  2400,  1000,},  
        [3] = {   750,   850,   950,  1050,  1150,  1250,  1350,  1450,  1550,  1650,  1750,  1850,  1950,  2050,  2150,  2250,  2350,  2450,  2550,  2650,  1500,},  
        [4] = {  1000,  1100,  1200,  1300,  1400,  1500,  1600,  1700,  1800,  1900,  2000,  2100,  2200,  2300,  2400,  2500,  2600,  2700,  2800,  2900,  2000,},  
        [5] = {  1250,  1350,  1450,  1550,  1650,  1750,  1850,  1950,  2050,  2150,  2250,  2350,  2450,  2550,  2650,  2750,  2850,  2950,  3050,  3150,  2500,},  
        [6] = {  1500,  1600,  1700,  1800,  1900,  2000,  2100,  2200,  2300,  2400,  2500,  2600,  2700,  2800,  2900,  3000,  3100,  3200,  3300,  3400,  3000,},  
        [7] = {  1750,  1850,  1950,  2050,  2150,  2250,  2350,  2450,  2550,  2650,  2750,  2850,  2950,  3050,  3150,  3250,  3350,  3450,  3550,  3650,  3500,},  
        [8] = {     0,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,    00,},  
        [9] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [10] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [11] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [12] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [13] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [14] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [15] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [16] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [17] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [18] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [19] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},  
       [20] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
 ['inputs'] = {     3,     0},
['outputs'] = {     1},
 ['scales'] = {     5,   500,     1},
['meta']={
    ['window']= nil,
    ['objects'] = {
        ['x_dropdown'] = nil,
        ['y_dropdown'] = nil,
        ['output_dropdown'] = nil,
        ['x_scale'] = nil,
        ['y_scale'] = nil,
        ['output_scale'] = nil,
        ['x'] = nil,
        ['y'] = nil,
        ['output'] = nil,
        ['before'] = nil,
        ['after'] = nil,
        ['size'] = {21, 21}
    },
}
    }
}
----- Entry functions -----
function FixedUpdate()
    local localPlayer = LocalPlayer.Value
    local targetedPart
    if localPlayer and localPlayer.Targeter then
        targetedPart = localPlayer.Targeter.TargetedPart
    end
    -- Check for keyboard shortcuts.
    if Input.GetKey(SelectorKey) then
        if targetedPart then
            --aquire crank part
            local construction = targetedPart.ParentConstruction
            for part in construction.Parts do
                for partName, filter in pairs(Filters) do
                    for _, partFilter in pairs(filter) do
                        if part.AssetName == partFilter then
                            selectedParts[partName] = part
                            break
                        end
                    end
                end
            end
        end
        if selectedParts['crank'] then
            --aquire base Pve RPM:
            for behaviour in selectedParts['crank'].Behaviours do
                if behaviour.Name == 'Engine Crank' then
                    for cylinder in behaviour.LinkedCylinders do
                        local head = cylinder.Head
                        basePveRPM = head.GetTweakable( "Peak Volumetric Efficiency RPM" ).Value
                    end
                end
            end
            --generate window
            for i, map in pairs(Maps) do
                if Maps[i]['meta']['window'] == nil then
                    local tunewindow = CreateWindow(250, 350, function()
                        Maps[i]['meta']['window'] = nil
                    end)
                    Maps[i]['meta']['window'] = tunewindow
                    local maplabel = tunewindow.CreateLabel()
                    maplabel.SetAlignment(align_HorizEdges, 5, 5)
                    maplabel.SetAlignment(align_TopEdge, 5, 30)
                    maplabel.Text = "Map " .. i
                    local x_dropdown = tunewindow.CreateLabelledDropdown()
                    x_dropdown.SetAlignment(align_HorizEdges, 5, 5)
                    x_dropdown.SetAlignment(align_TopEdge, 30, 30)
                    x_dropdown.Text = "X Axis:"
                    for _, input in pairs(availible_Inputs) do
                        x_dropdown.AddOption(input)
                    end
                    if Maps[i]['inputs'][1] then
                        x_dropdown.Value = Maps[i]['inputs'][1]
                    end
                    Maps[i]['meta']['objects']['x_dropdown'] = x_dropdown
                    local y_dropdown = tunewindow.CreateLabelledDropdown()
                    y_dropdown.SetAlignment(align_HorizEdges, 5, 5)
                    y_dropdown.SetAlignment(align_TopEdge, 70, 30)
                    y_dropdown.Text = "Y Axis:"
                    for _, input in pairs(availible_Inputs) do
                        y_dropdown.AddOption(input)
                    end
                    if Maps[i]['inputs'][2] then
                        y_dropdown.Value = Maps[i]['inputs'][2]
                    end
                    Maps[i]['meta']['objects']['y_dropdown'] = y_dropdown
                    local output_dropdown = tunewindow.CreateLabelledDropdown()
                    output_dropdown.SetAlignment(align_HorizEdges, 5, 5)
                    output_dropdown.SetAlignment(align_TopEdge, 110, 30)
                    output_dropdown.Text = "Output:"
                    for _, output in pairs(availible_Outputs) do
                        output_dropdown.AddOption(output)
                    end
                    if Maps[i]['outputs'][1] then
                        output_dropdown.Value = Maps[i]['outputs'][1]
                    end
                    Maps[i]['meta']['objects']['output_dropdown'] = output_dropdown
                    local x_scale = tunewindow.CreateLabelledInputField()
                    x_scale.SetAlignment(align_HorizEdges, 5, 5)
                    x_scale.SetAlignment(align_TopEdge, 150, 30)
                    x_scale.Text = "X Scale:"
                    x_scale.Value = 1
                    if Maps[i]['scales'][1] then
                        x_scale.Value = Maps[i]['scales'][1]
                    end
                    Maps[i]['meta']['objects']['x_scale'] = x_scale
                    local y_scale = tunewindow.CreateLabelledInputField()
                    y_scale.SetAlignment(align_HorizEdges, 5, 5)
                    y_scale.SetAlignment(align_TopEdge, 190, 30)
                    y_scale.Text = "Y Scale:"
                    y_scale.Value = 1
                    if Maps[i]['scales'][2] then
                        y_scale.Value = Maps[i]['scales'][2]
                    end
                    Maps[i]['meta']['objects']['y_scale'] = y_scale
                    local output_scale = tunewindow.CreateLabelledInputField()
                    output_scale.SetAlignment(align_HorizEdges, 5, 5)
                    output_scale.SetAlignment(align_TopEdge, 230, 30)
                    output_scale.Text = "OutScale"
                    output_scale.Value = 1
                    if Maps[i]['scales'][3] then
                        output_scale.Value = Maps[i]['scales'][3]
                    end
                    Maps[i]['meta']['objects']['output_scale'] = output_scale
                    local x_label = tunewindow.CreateLabel()
                    x_label.SetAlignment(align_HorizEdges, 5, 5)
                    x_label.SetAlignment(align_TopEdge, 260, 30)
                    x_label.Text = "X: 0"
                    Maps[i]['meta']['objects']['x'] = x_label
                    local y_label = tunewindow.CreateLabel()
                    y_label.SetAlignment(align_HorizEdges, 80, 5)
                    y_label.SetAlignment(align_TopEdge, 260, 30)
                    y_label.Text = "Y: 0"
                    Maps[i]['meta']['objects']['y'] = y_label
                    local output_label = tunewindow.CreateLabel()
                    output_label.SetAlignment(align_HorizEdges, 140, 5)
                    output_label.SetAlignment(align_TopEdge, 260, 30)
                    output_label.Text = "Output: 0"
                    Maps[i]['meta']['objects']['output'] = output_label
                    local before_label = tunewindow.CreateLabel()
                    before_label.SetAlignment(align_HorizEdges, 5, 5)
                    before_label.SetAlignment(align_TopEdge, 290, 30)
                    before_label.Text = "Before: 0000"
                    Maps[i]['meta']['objects']['before'] = before_label
                    local after_label = tunewindow.CreateLabel()
                    after_label.SetAlignment(align_HorizEdges, 80, 5)
                    after_label.SetAlignment(align_TopEdge, 290, 30)
                    after_label.Text = "After: 0000"
                    Maps[i]['meta']['objects']['after'] = after_label
                end
            end
        end
    end
    if selectedParts['crank'] then
        for i, map in pairs(Maps) do
            if Maps[i]['meta']['window'] then
                local x = 0
                local y = 0
                local output = 0
                local x_scale = (Maps[i]['meta']['objects']['x_scale'].Value)
                local y_scale = (Maps[i]['meta']['objects']['y_scale'].Value)
                local output_scale = (Maps[i]['meta']['objects']['output_scale'].Value)
                local x_val = availible_Inputs[Maps[i]['meta']['objects']['x_dropdown'].Value]
                if x_val == "RPM" then
                    for behavior in selectedParts['crank'].Behaviours do
                        for channel in behavior.Channels do
                            if channel.Label == "RPM" then
                                x = channel.Value * (1 / x_scale)
                            end
                        end
                    end
                elseif x_val == "Power" then
                    for behavior in selectedParts['crank'].Behaviours do
                        for channel in behavior.Channels do
                            if channel.Label == "Power" then
                                x = channel.Value * (1 / x_scale)
                            end
                        end
                    end
                elseif x_val == "Torque" then
                    for behavior in selectedParts['crank'].Behaviours do
                        for channel in behavior.Channels do
                            if channel.Label == "Torque (Nm)" then 
                                x = channel.Value * (1 / x_scale)
                            end
                        end
                    end
                elseif x_val == "Vol. Eff." then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                for channel in head.Channels do
                                    if channel.Label == 'Volumetric Efficiency (%)' then
                                        x = channel.Value * (1 / x_scale)
                                    end
                                end
                            end
                        end
                    end
                elseif x_val == "throttle angle" then
                    for part in selectedParts['crank'].ParentConstruction.Parts do
                        for behavior in part.Behaviours do
                            for channel in behavior.Channels do
                                if channel.Label == "Butterfly Angle" then
                                    x = channel.Value * (1 / x_scale)
                                end
                            end
                        end
                    end
                elseif x_val == "Fuel Flow rate" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                for channel in head.Channels do
                                    if channel.Label == 'Fuel Flow Rate (g/s)' then
                                        x = channel.Value * (1 / x_scale)
                                    end
                                end
                            end
                        end 
                    end
                elseif x_val == "intake flow rate" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                for channel in head.Channels do
                                    if channel.Label == 'Intake Port Flow Rate (g/s)' then
                                        x = channel.Value * (1 / x_scale)
                                    end
                                end
                            end
                        end
                    end
                end
                x = math.floor(x)
                local y_val = availible_Inputs[Maps[i]['meta']['objects']['y_dropdown'].Value]
                if y_val == "RPM" then
                    for behavior in selectedParts['crank'].Behaviours do
                        for channel in behavior.Channels do
                            if channel.Label == "RPM" then
                                y = channel.Value * (1 / y_scale)
                            end
                        end
                    end
                elseif y_val == "Power" then
                    for behavior in selectedParts['crank'].Behaviours do
                        for channel in behavior.Channels do
                            if channel.Label == "Power" then
                                y = channel.Value * (1 / y_scale)
                            end
                        end
                    end
                elseif y_val == "Torque" then
                    for behavior in selectedParts['crank'].Behaviours do
                        for channel in behavior.Channels do
                            if channel.Label == "Torque (Nm)" then 
                                y = channel.Value * (1 / y_scale)
                            end
                        end
                    end
                elseif y_val == "Vol. Eff." then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                for channel in head.Channels do
                                    if channel.Label == 'Volumetric Efficiency (%)' then
                                        y = channel.Value * (1 / y_scale)
                                    end
                                end
                            end
                        end
                    end
                elseif y_val == "throttle angle" then
                    for part in selectedParts['crank'].ParentConstruction.Parts do
                        for behavior in part.Behaviours do
                            for channel in behavior.Channels do
                                if channel.Label == "Butterfly Angle" then
                                    y = channel.Value * (1 / y_scale)
                                end
                            end
                        end
                    end
                elseif y_val == "Fuel Flow rate" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                for channel in head.Channels do
                                    if channel.Label == 'Fuel Flow Rate (g/s)' then
                                        y = channel.Value * (1 / y_scale)
                                    end
                                end
                            end
                        end
                    end
                elseif y_val == "intake flow rate" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                for channel in head.Channels do
                                    if channel.Label == 'Intake Port Flow Rate (g/s)' then
                                        y = channel.Value * (1 / y_scale)
                                    end
                                end
                            end
                        end
                    end
                end
                y = math.floor(y)
                if y < 0 then
                    y = 0
                end
                if x < 0 then
                    x = 0
                end
                if y >= Maps[i]['meta']['objects']['size'][2] then
                    y = Maps[i]['meta']['objects']['size'][2] - 1
                    print("y out of bounds")
                end
                if x >= Maps[i]['meta']['objects']['size'][1] then
                    x = Maps[i]['meta']['objects']['size'][1] - 1
                    print("x out of bounds")
                end
                Maps[i]['meta']['objects']['y'].Text = "Y: " .. y
                Maps[i]['meta']['objects']['x'].Text = "X: " .. x
                local output_val = availible_Outputs[Maps[i]['meta']['objects']['output_dropdown'].Value]
                local output = Maps[i][y][x+1] * (1 / output_scale)
                local before = nil
                local after = nil
                Maps[i]['meta']['objects']['output'].Text = "Output: " .. output
                if output_val == "Peak Power %" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                local Pve = head.GetTweakable( "Peak Volumetric Efficiency" ) 
                                before = Pve.Value
                                Pve.Value = output
                                after = Pve.Value
                            end
                        end
                    end
                elseif output_val == "Peak Power RPM" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                local PveRPM = head.GetTweakable( "Peak Volumetric Efficiency RPM" ) 
                                before = PveRPM.Value
                                PveRPM.Value = output
                                after = PveRPM.Value
                            end
                        end
                    end
                elseif output_val == "Throttle Idle Min %" then
                    for part in selectedParts['crank'].ParentConstruction.Parts do
                        for _, filter in pairs(Filters) do
                            for _, partFilter in pairs(filter) do
                                if part.AssetName == partFilter then
                                    local Minidlepercent = part.GetTweakable("Idle Control Min %")
                                    before = Minidlepercent.Value
                                    Minidlepercent.Value = output
                                    after = Minidlepercent.Value
                                end
                            end
                        end
                    end
                elseif output_val == "Throttle Idle RPM" then
                    for part in selectedParts['crank'].ParentConstruction.Parts do
                        for _, filter in pairs(Filters) do
                            for _, partFilter in pairs(filter) do
                                if part.AssetName == partFilter then
                                    local idleRPM = part.GetTweakable("Idle RPM")
                                    before = idleRPM.Value
                                    idleRPM.Value = output
                                    after = idleRPM.Value
                                end
                            end
                        end
                    end
                elseif output_val == "Max RPM" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                local MaxRPM = head.GetTweakable( "Max RPM" )
                                before = MaxRPM.Value
                                MaxRPM.Value = output
                                after = MaxRPM.Value
                            end
                        end
                    end
                elseif output_val == "Fuel Ratio" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                local FR = head.GetTweakable( "Lambda" )
                                before = FR.Value
                                FR.Value = output
                                after = FR.Value
                            end
                        end
                    end
                elseif output_val == "Exhaust Effect" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                local exhaustamt = head.GetTweakable( "Exhaust Effect Amount" )
                                before = exhaustamt.Value
                                exhaustamt.Value = output
                                after = exhaustamt.Value
                            end
                        end
                    end
                elseif output_val == "Peak Power RPM Retard" then
                    for behaviour in selectedParts['crank'].Behaviours do
                        if behaviour.Name == 'Engine Crank' then
                            for cyl in behaviour.LinkedCylinders do
                                local head = cyl.Head
                                local Pverpm = head.GetTweakable( "Peak Volumetric Efficiency RPM" )
                                before = Pverpm.Value
                                Pverpm.Value = basePveRPM - output
                                after = Pverpm.Value
                            end
                        end
                    end
                end
                --draw before and after
                Maps[i]['meta']['objects']['after'].Text = 'after: ' .. after
                Maps[i]['meta']['objects']['before'].Text = 'before: ' .. before
            end
        end
    end
end
function Cleanup()
    Windows.DestroyWindow(win)
end
