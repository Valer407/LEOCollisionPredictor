function export_for_ml(allPositions, collisions, tle_data)

    if isempty(collisions)
        disp('Brak kolizji -> collision_events.csv nie zostanie utworzony.');
    else
        collisionFilename = 'collision_events.csv';
        fid = fopen(collisionFilename, 'w');
        fprintf(fid, 'sat1,sat2,timeMin,distance,riskLevel\n');
        for i = 1:length(collisions)
            ev = collisions(i);
            fprintf(fid, '%d,%d,%.1f,%.6f,%s\n', ...
                ev.sat1, ev.sat2, ev.timeMin, ev.distance, ev.riskLevel);
        end
        fclose(fid);
        fprintf('Zapisano kolizje do %s\n', collisionFilename);
    end
    
    posFilename = 'all_positions.csv';
    fid2 = fopen(posFilename, 'w');
    fprintf(fid2, 'satIndex,timeMin,x_km,y_km,z_km\n');
    
    for s = 1:length(allPositions)
        satPos = allPositions{s};  
        for row = 1:size(satPos,1)
            tMin = satPos(row,1);
            xkm  = satPos(row,2);
            ykm  = satPos(row,3);
            zkm  = satPos(row,4);
            fprintf(fid2, '%d,%.2f,%.6f,%.6f,%.6f\n', s, tMin, xkm, ykm, zkm);
        end
    end
    
    fclose(fid2);
    fprintf('Zapisano wszystkie pozycje do %s\n', posFilename);
end
