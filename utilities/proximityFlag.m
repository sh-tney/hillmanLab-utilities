function flagset = proximityFlag(c)
    %proximityFlag flags when the rat nose is in proximity to the sucrose
    %   Specifically working with the fixed pixel position of the food, and
    %   only so far working on the resulting csv file from the DLC video
    %   analysis, this compares the pixel distance away, and flags the 
    %   frame when the rat nose is within a fixed distance.
    
    location = [236, 163];              % // the location being scanned for
    flagDist = 10;         % // the "sensitivity" of the marking, in pixels
    frameRate = 25; % // the framerate the video, for timestamping purposes
    flagset = zeros(size(c)); % the output array, with raw distance & marks
    stamp = 25;    % // this number will set how many frames apart to stamp
    
    % Loops through and calculates the distance from location
    % when in flagDist pixels, the frame will be marked 
    % If a timestamp hasn't been displayed in the last q frames, one will
    % be displayed
    
    tick = stamp;
    for i = 1:size(c)
        
        x = c(i, :);
        deltaX = (x(1) - location(1))^2;
        deltaY = (x(2) - location(2))^2;
        d = sqrt(deltaX + deltaY); 
        flagset(i, 1) = d;
        
        if d < flagDist % mark if within threshold
            flagset(i, 2) = 1;
            if tick == stamp % if a timestamp hasn't been made recently
                min = floor(floor(i/frameRate)/60);
                sec = mod(floor(i/frameRate), 60);
                fprintf('%d:%02.0f\n', min, sec);
                tick = 0; % reset the stamp counter
            end
        end
        
        if tick < stamp % timestamp tick up, when not at max
            tick = tick+1;
        end
        
    end