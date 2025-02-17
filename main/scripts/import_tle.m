function tle_data = import_tle(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('Nie można otworzyć pliku: %s', filename);
    end
    
    raw_lines = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    
    lines = raw_lines{1};
    numLines = length(lines);
    if mod(numLines,3) ~= 0
        error('Liczba linii (%d) w pliku TLE nie jest podzielna przez 3.', numLines);
    end
    
    tle_data = struct('Name',{}, 'Line1',{}, 'Line2',{});
    
    idx = 1;
    while idx <= numLines
        nameLine = strtrim(lines{idx});
        line1    = strtrim(lines{idx+1});
        line2    = strtrim(lines{idx+2});
        
        idx = idx + 3;
        
        tle_data(end+1).Name  = nameLine;  
        tle_data(end).Line1   = line1;
        tle_data(end).Line2   = line2;
    end
    
    fprintf('Wczytano %d TLE z pliku: %s\n', length(tle_data), filename);
end
