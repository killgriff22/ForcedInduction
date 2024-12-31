-- Copyright (C) 2017 - 2024 SmashHammer Games Inc. - All Rights Reserved.
----- Init UI -----
local win = Windows.CreateWindow()
win.SetAlignment(align_RightEdge, 20, 300)
win.SetAlignment(align_TopEdge, 80, 30)
local function onWindowClose()
    UnloadScript.Raise(ScriptName) -- Window closed, so unload this script.
end
win.OnClose.add(onWindowClose)
win.Title = 'Use <b>Tab</b> to select a construction'
win.Show(true)

local part = nil
local selectedParts = {
    ['crank'] = nil,
}
local Filters = {
    ['crank'] = {'Engine Crank Rear x2 Axle Resizable', 'Engine Crank Rear x1 Axle Resizable'},
}
local availible_Inputs = {
    'RPM',
    'Power',
    'Torque',
    'Vol. Eff.',
    'throttle angle',
    'Fuel Flow rate',
    'intake flow rate',
}
local availible_Outputs = {
    'Peak Power %',
    'Peak Power RPM',
    'Throttle Idle Min angle',
    'Throttle Idle RPM',
    'Max RPM',
    'Fuel Ratio',
    'Exhaust Effect',
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
        --          0      1      2      3      4      5      6      7      8      9      10     11     12     13     14     15     16     17     18     19    20
        [0] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
        [1] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
        [2] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
        [3] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
        [4] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
        [5] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
        [6] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
        [7] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
        [8] = {     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,},
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
 ['inputs'] = {   nil,   nil                                                                                                                                      },
['outputs'] = {   nil                                                                                                                                             },
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
    if Input.GetKey('tab') then
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
        --generate window
        if selectedParts['crank'] then
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
                    Maps[i]['meta']['objects']['x_dropdown'] = x_dropdown
                    local y_dropdown = tunewindow.CreateLabelledDropdown()
                    y_dropdown.SetAlignment(align_HorizEdges, 5, 5)
                    y_dropdown.SetAlignment(align_TopEdge, 80, 30)
                    y_dropdown.Text = "Y Axis:"
                    for _, input in pairs(availible_Inputs) do
                        y_dropdown.AddOption(input)
                    end
                    Maps[i]['meta']['objects']['y_dropdown'] = y_dropdown
                    local output_dropdown = tunewindow.CreateLabelledDropdown()
                    output_dropdown.SetAlignment(align_HorizEdges, 5, 5)
                    output_dropdown.SetAlignment(align_TopEdge, 130, 30)
                    output_dropdown.Text = "Output:"
                    for _, output in pairs(availible_Outputs) do
                        output_dropdown.AddOption(output)
                    end
                    Maps[i]['meta']['objects']['output_dropdown'] = output_dropdown
                    local x_scale = tunewindow.CreateLabelledInputField()
                    x_scale.SetAlignment(align_HorizEdges, 5, 5)
                    x_scale.SetAlignment(align_TopEdge, 180, 30)
                    x_scale.Text = "X Scale:"
                    x_scale.Value = 1
                    Maps[i]['meta']['objects']['x_scale'] = x_scale
                    local y_scale = tunewindow.CreateLabelledInputField()
                    y_scale.SetAlignment(align_HorizEdges, 5, 5)
                    y_scale.SetAlignment(align_TopEdge, 230, 30)
                    y_scale.Text = "Y Scale:"
                    y_scale.Value = 1
                    Maps[i]['meta']['objects']['y_scale'] = y_scale
                    local x_label = tunewindow.CreateLabel()
                    x_label.SetAlignment(align_HorizEdges, 5, 5)
                    x_label.SetAlignment(align_TopEdge, 260, 30)
                    x_label.Text = "X: 0"
                    Maps[i]['meta']['objects']['x'] = x_label
                    local y_label = tunewindow.CreateLabel()
                    y_label.SetAlignment(align_HorizEdges, 60, 5)
                    y_label.SetAlignment(align_TopEdge, 260, 30)
                    y_label.Text = "Y: 0"
                    Maps[i]['meta']['objects']['y'] = y_label
                    local output_label = tunewindow.CreateLabel()
                    output_label.SetAlignment(align_HorizEdges, 120, 5)
                    output_label.SetAlignment(align_TopEdge, 260, 30)
                    output_label.Text = "Output: 0"
                    Maps[i]['meta']['objects']['output'] = output_label
                end
            end
        end
    end
    if selectedParts['crank'] then
        for i, map in pairs(Maps) do
            if not Maps[i]['inputs'][0] == Maps[i]['meta']['objects']['x_dropdown'].Value then
                Maps[i]['inputs'][0] = Maps[i]['meta']['objects']['x_dropdown'].Value
            end
            if not Maps[i]['inputs'][1] == Maps[i]['meta']['objects']['y_dropdown'].Value then
                Maps[i]['inputs'][1] = Maps[i]['meta']['objects']['y_dropdown'].Value
            end
            if not Maps[i]['outputs'][0] == Maps[i]['meta']['objects']['output_dropdown'].Value then
                Maps[i]['outputs'][0] = Maps[i]['meta']['objects']['output_dropdown'].Value
            end
        end
        for i, map in pairs(Maps) do
            local x = 0
            local y = 0
            local output = 0
            local x_scale = tonumber(Maps[i]['meta']['objects']['x_scale'].Value)
            local y_scale = tonumber(Maps[i]['meta']['objects']['y_scale'].Value)
            local output_scale = 1
            local x_val = map['inputs'][0]
            if x_val == "RPM" then
                print("RPM")
                for behavior in selectedParts['crank'].Behaviours do
                    for channel in behavior.Channels do
                        if channel.Name == "RPM" then
                            x = channel.Value * (1 / x_scale)
                        end
                    end
                end
            elseif x_val == "Power" then
                for behavior in selectedParts['crank'].Behaviours do
                    for channel in behavior.Channels do
                        if channel.Name == "Power" then
                            x = channel.Value * (1 / x_scale)
                        end
                    end
                end
            elseif x_val == "Torque" then
                for behavior in selectedParts['crank'].Behaviours do
                    for channel in behavior.Channels do
                        if channel.Name == "Torque (Nm)" then 
                            x = channel.Value * (1 / x_scale)
                        end
                    end
                end
            elseif x_val == "Vol. Eff." then
                for behaviour in selectedParts['crank'].Behaviours do
                    if behaviour.Name == 'Engine Crank' then
                        local cyl1 = behaviour.LinkedCylinders[0]
                        local head1 = cyl1.Head
                        for channel in head.Channels do
                            if channel.Label == 'Volumetric Efficiency (%)' then
                                x = channel.Value * (1 / x_scale)
                            end
                        end
                    end
                end
            elseif x_val == "throttle angle" then
                for part in selectedParts['crank'].ParentConstruction.Parts do
                    for behavior in part.Behaviours do
                        for channel in behavior.Channels do
                            if channel.Name == "Butterfly Angle" then
                                x = channel.Value * (1 / x_scale)
                            end
                        end
                    end
                end
            elseif x_val == "Fuel Flow rate" then
                for behaviour in selectedParts['crank'].Behaviours do
                    if behaviour.Name == 'Engine Crank' then
                        local cyl1 = behaviour.LinkedCylinders[0]
                        local head1 = cyl1.Head
                        for channel in head.Channels do
                            if channel.Label == 'Fuel Flow Rate (g/s)' then
                                x = channel.Value * (1 / x_scale)
                            end
                        end
                    end
                end
            end
            Maps[i]['meta']['objects']['x'].Text = "X: " .. x
        end
    end
end

function Cleanup()
    Windows.DestroyWindow(win)
end
