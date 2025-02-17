function main()
    addpath('scripts');
    addpath('scripts/SGP4');
    
    tleFile = fullfile('data','3le.txt');
    tle_data = import_tle(tleFile);

    nSats = length(tle_data);
    if nSats < 2
        error('Potrzeba co najmniej dwóch satelitów, by sprawdzić możliwe kolizje!');
    end
    
    satrecs = cell(nSats,1);
    for i = 1:nSats
        satrecs{i} = createSatrec(tle_data(i).Line1, tle_data(i).Line2, SGP4.wgs72, 'a');
        fprintf('Zainicjalizowano satelitę #%d: "%s" (satnum=%d)\n', ...
            i, tle_data(i).Name, satrecs{i}.satnum);
    end
    
    durationMinutes = 1440;   
    stepSec = 60;             
    
    allPositions = cell(nSats,1);
    
    for i = 1:nSats
        fprintf('Propagacja orbity sat #%d -> %s\n', i, tle_data(i).Name);
        satPositions = calc_orbits(satrecs{i}, durationMinutes, stepSec);
        allPositions{i} = satPositions;
    end
    
    thresholdKM = 1.0;
    highRiskKM  = 0.5;
    collisions = detect_collision(allPositions, thresholdKM, highRiskKM);
    
    if isempty(collisions)
        disp('Brak kolizji w zadanym oknie czasowym.');
    else
        disp('Wykryto możliwe kolizje:');
        for c = 1:length(collisions)
            ev = collisions(c);
            fprintf('  Sat%d vs Sat%d, t=%.1f min, dist=%.6f km, %s\n', ...
                ev.sat1, ev.sat2, ev.timeMin, ev.distance, ev.riskLevel);
        end
    end
    disp('--- Checking TLE for sat11 vs sat12 ---');
    disp(tle_data(11).Name);
    disp(tle_data(11).Line1);
    disp(tle_data(11).Line2);
    disp(tle_data(12).Name);
    disp(tle_data(12).Line1);
    disp(tle_data(12).Line2);
    export_for_ml(allPositions, collisions, tle_data);
end
