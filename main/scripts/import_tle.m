function tle_data = import_tle(filename)
    fileID = fopen(filename, 'r');
    if fileID == -1
        error('Nie można otworzyć pliku: %s', filename);
    end

    tle_raw = textscan(fileID, '%s', 'Delimiter', '\n');
    fclose(fileID);

    tle_data = struct('Name', {}, 'Line1', {}, 'Line2', {});

    lines = tle_raw{1};
    if mod(length(lines), 3) ~= 0
        error('Liczba linii w pliku TLE nie jest podzielna przez 3.');
    end

    for i = 1:3:length(lines)-2
        % Zapisz nazwę, pierwszą linię i drugą linię TLE
        tle_data(end+1).Name = strtrim(lines{i});
        tle_data(end).Line1 = lines{i+1};
        tle_data(end).Line2 = lines{i+2};
    end

    % Komunikat o powodzeniu
    fprintf('Wczytano %d rekordów TLE z pliku: %s\n', length(tle_data), filename);
end
