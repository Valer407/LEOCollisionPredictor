function satPositions = calc_orbits(satrec, durationMinutes, stepSec)
    totalSteps = floor(durationMinutes*60 / stepSec) + 1;
    satPositions = zeros(totalSteps,4);
    
    for i = 1:totalSteps
        timeMin = (i-1)*(stepSec/60);
        
        rv = rvhandle();
        ok = SGP4.sgp4(satrec, timeMin, rv);
        if ~ok
            warning('SGP4 error at t=%.6f min (code=%d)', timeMin, satrec.error);
        end
        
        satPositions(i,1) = timeMin;
        satPositions(i,2) = rv.r(1);  % x 
        satPositions(i,3) = rv.r(2);  % y 
        satPositions(i,4) = rv.r(3);  % z 
    end
end
