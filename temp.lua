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
                        if channel.Name == "Power" then
                            y = channel.Value * (1 / y_scale)
                        end
                    end
                end
            elseif y_val == "Torque" then
                for behavior in selectedParts['crank'].Behaviours do
                    for channel in behavior.Channels do
                        if channel.Name == "Torque (Nm)" then 
                            y = channel.Value * (1 / y_scale)
                        end
                    end
                end
            elseif y_val == "Vol. Eff." then
                for behaviour in selectedParts['crank'].Behaviours do
                    if behaviour.Name == 'Engine Crank' then
                        local cyl1 = behaviour.LinkedCylinders[0]
                        local head1 = cyl1.Head
                        for channel in head.Channels do
                            if channel.Label == 'Volumetric Efficiency (%)' then
                                y = channel.Value * (1 / y_scale)
                            end
                        end
                    end
                end
            elseif y_val == "throttle angle" then
                for part in selectedParts['crank'].ParentConstruction.Parts do
                    for behavior in part.Behaviours do
                        for channel in behavior.Channels do
                            if channel.Name == "Butterfly Angle" then
                                y = channel.Value * (1 / y_scale)
                            end
                        end
                    end
                end
            elseif y_val == "Fuel Flow rate" then
                for behaviour in selectedParts['crank'].Behaviours do
                    if behaviour.Name == 'Engine Crank' then
                        local cyl1 = behaviour.LinkedCylinders[0]
                        local head1 = cyl1.Head
                        for channel in head.Channels do
                            if channel.Label == 'Fuel Flow Rate (g/s)' then
                                y = channel.Value * (1 / y_scale)
                            end
                        end
                    end
                end
            elseif y_val == "intake flow rate" then
                for behaviour in selectedParts['crank'].Behaviours do
                    if behaviour.Name == 'Engine Crank' then
                        local cyl1 = behaviour.LinkedCylinders[0]
                        local head1 = cyl1.Head
                        for channel in head.Channels do
                            if channel.Label == 'Intake Port Flow Rate (g/s)' then
                                y = channel.Value * (1 / y_scale)
                            end
                        end
                    end
                end
            end
            y = math.floor(y * 100) / 100
            Maps[i]['meta']['objects']['y'].Teyt = "y: " .. y