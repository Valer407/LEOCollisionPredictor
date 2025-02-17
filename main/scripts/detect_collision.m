function collisionEvents = detect_collision(allPositions, thresholdKM, highRiskKM)
    nSats = length(allPositions);
    collisionEvents = struct('sat1',{}, 'sat2',{}, 'timeMin',{}, 'distance',{}, 'riskLevel',{});
    
    for i = 1:nSats-1
        pos1 = allPositions{i};
        for j = i+1:nSats
            pos2 = allPositions{j};
            nSteps = min(size(pos1,1), size(pos2,1));
            
            for step = 1:nSteps
                x1 = pos1(step,2); y1 = pos1(step,3); z1 = pos1(step,4);
                x2 = pos2(step,2); y2 = pos2(step,3); z2 = pos2(step,4);
                
                distKM = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
                if distKM < 0.001
                    continue;  
                end
                if distKM < highRiskKM
                    ev.sat1 = i; ev.sat2 = j;
                    ev.timeMin = pos1(step,1);
                    ev.distance = distKM;
                    ev.riskLevel = 'HIGH_RISK_0.5km';
                    collisionEvents(end+1) = ev; 
                elseif distKM < thresholdKM
                    ev.sat1 = i; ev.sat2 = j;
                    ev.timeMin = pos1(step,1);
                    ev.distance = distKM;
                    ev.riskLevel = 'STANDARD_RISK_1km';
                    collisionEvents(end+1) = ev; 
                end
            end
        end
    end
end
