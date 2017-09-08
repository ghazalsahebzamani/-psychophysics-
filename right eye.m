% Clear the workspace and the screen
Screen('Preference', 'SkipSyncTests', 1);
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
[xCenter, yCenter] = RectCenter(windowRect);
focus=[0 0 40 40];
centeredfocus = CenterRectOnPointd(focus, xCenter, yCenter);
fixCrossDimPix = 60;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];

% Here we calculate the radial distance from the center of the screen to
% the X and Y edges
xRadius = windowRect(3) / 2;
yRadius = windowRect(4) / 2;

% Screen resolution in Y
screenYpix = windowRect(4);

allCoords = [xCoords; yCoords];
lineWidthPix = 4;


% Number of white/black circle pairs
rcycles = 1;

% Number of white/black angular segment pairs (integer)
tcycles = 24;

% Now we make our checkerboard pattern
xylim = 2 * pi * rcycles;
[x, y] = meshgrid(-xylim: 2 * xylim / (screenYpix - 1): xylim,...
    -xylim: 2 * xylim / (screenYpix - 1): xylim);
at = atan2(y, x);
checks = ((1 + ...
    1.* sign(sin(at * tcycles) + eps) * (white - black) - 0.5));
circle =x.^2 + y.^2 >= xylim^2/4 & x.^2 + y.^2 <= xylim^2*3/4;
checks = circle .* checks + grey * ~circle;

% Now we make this into a PTB texture
radialCheckerboardTexture  = Screen('MakeTexture', window, checks);

% Draw our texture to the screen
times=[];
for i=1:1:3
Screen('DrawTexture', window, radialCheckerboardTexture);
Screen('DrawLine', window ,[0 0 0],1200, 1670, 1170, 1728,10);
Screen('DrawLine', window ,[0 0 0],2000, 1670, 2030, 1728,10);
Screen('DrawLine', window ,[0 0 0],1444, 1200,1424, 1239,4);
Screen('DrawLine', window ,[0 0 0],1756, 1200,1776, 1239,4);
Screen('DrawLines', window, allCoords,...
    lineWidthPix, 0, [xCenter yCenter]);
Screen('FrameArc',window,[0 0 0],centeredfocus,0,90, 4,4)
Screen('FrameArc',window,[1 1 1],centeredfocus,0,-90, 4,4)
Screen('FrameArc',window,[1 1 1],centeredfocus,90,90, 4,4)
Screen('FrameArc',window,[0 0 0],centeredfocus,-90,-90, 4,4)
 Screen('Flip', window);
[secs, keyCode, deltaSecs]  = KbPressWait(0);
 
 times=[times,deltaSecs];
 Screen('FillRect', window,0.5,windowRect );
 Screen('Flip', window);
 WaitSecs(1);
end


% Wait for a keypress

KbStrokeWait;

% Clear up and leave the building
sca;
