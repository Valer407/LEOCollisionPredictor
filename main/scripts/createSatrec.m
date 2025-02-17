function satrec = createSatrec(line1, line2, whichconst, opsmode)
    % Tworzy obiekt elsetrec i wywołuje sgp4init, z dodatkowymi debugami.
    disp('--- DEBUG createSatrec.m ---');
    disp('--- line1 ---');
    disp(line1);
    disp(['length(line1)=', num2str(length(line1))]);
    for c = 1:length(line1)
        disp([num2str(c), ' -> ', line1(c)]);
    end
    
    if nargin < 3
        whichconst = SGP4.wgs72;
    end
    if nargin < 4
        opsmode = 'a';  
    end
    
    satrec = elsetrec();
    satrec.whichconst = whichconst;
    
    satnum_str = strtrim(line1(3:7));
    satrec.satnum = str2double(satnum_str);
    
    epochyear_str = strtrim(line1(19:20));
    epochdays_str = strtrim(line1(21:32));
    
    disp(['epochyear_str="', epochyear_str, '" (len=', ...
          num2str(length(epochyear_str)), ')']);
    disp(['epochdays_str="', epochdays_str, '" (len=', ...
          num2str(length(epochdays_str)), ')']);
    
    epochyear = str2double(epochyear_str);
    if epochyear < 57
        year_full = 2000 + epochyear;
    else
        year_full = 1900 + epochyear;
    end
    epochdays = str2double(epochdays_str);
    
    disp(['DEBUG => epochyear=', num2str(epochyear), ...
          '  epochdays=', num2str(epochdays), '  => year_full=', ...
          num2str(year_full)]);
    
    satrec.epochyr   = epochyear;
    satrec.epochdays = epochdays;
    
    bstar_str = [line1(54:59), 'E', line1(60:61)];
    satrec.bstar = str2double(bstar_str);
    
    incl_str = line2(9:16);
    incl_deg = str2double(incl_str);
    satrec.inclo = incl_deg * pi/180;
    
    raan_str = line2(18:25);
    raan_deg = str2double(raan_str);
    satrec.nodeo = raan_deg * pi/180;
    
    ecc_str = ['.', line2(27:33)];
    satrec.ecco = str2double(ecc_str);
    
    argp_str = line2(35:42);
    argp_deg = str2double(argp_str);
    satrec.argpo = argp_deg * pi/180;
    
    mo_str = line2(44:51);
    mo_deg = str2double(mo_str);
    satrec.mo = mo_deg * pi/180;
    
    mm_str = line2(53:63);
    mean_motion = str2double(mm_str);
    satrec.no_kozai = mean_motion * 2*pi / 1440.0;
    
    JDvals = SGP4.jday(year_full, 1, 0, 0, 0, 0);
    disp(['JDvals size=', mat2str(size(JDvals)), ...
          ', JDvals=', num2str(JDvals)]);
    
    jd     = JDvals(1);
    jdFrac = JDvals(2);
    
    jdFull = jd + jdFrac + epochdays;
    satrec.jdsatepoch  = floor(jdFull);
    satrec.jdsatepochF = jdFull - satrec.jdsatepoch;
    
    disp(['DEBUG => jd=', num2str(jd), ...
          ' jdFrac=', num2str(jdFrac), ...
          ' jdFull=', num2str(jdFull), ...
          ' jdsatepoch=', num2str(satrec.jdsatepoch), ...
          ' jdsatepochF=', num2str(satrec.jdsatepochF)]);
    
    SGP4.sgp4init(opsmode, satrec);
    disp('--- createSatrec.m COMPLETE! ---');
end

