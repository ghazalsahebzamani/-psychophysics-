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
inc = white - grey;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Define a simple spiral texture by defining X and Y coordinates with the
% meshgrid command, converting these to polar coordinates and finally
% defining the spiral texture
focus=[0 0 40 40];
centeredfocus = CenterRectOnPointd(focus, xCenter, yCenter);
fixCrossDimPix = 60;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 4;
[x, y] = meshgrid(-1500:1:1500, -800:1:800);
[th, r] = cart2pol(x, y);
spiral = grey + inc .* cos(r / 15 + th * 15);

% Make our sprial texure into a screen texture for drawing
spiralTexture = Screen('MakeTexture', window, spiral);
%%%%radius has been set to the same value of the second screen
circle = 449.7500.^2<( x.^2 + y.^2) &( x.^2 + y.^2) <= 778.9899^2;
checks = circle .* spiral + grey * ~circle;
radialCheckerboardTexture  = Screen('MakeTexture', window, checks);
times=[];
for i=1:1:3
Screen('DrawTexture', window, radialCheckerboardTexture);
Screen('FrameArc',window,[0 0 0],centeredfocus,0,90, 4,4)
Screen('FrameArc',window,[1 1 1],centeredfocus,0,-90, 4,4)
Screen('FrameArc',window,[1 1 1],centeredfocus,90,90, 4,4)
Screen('FrameArc',window,[0 0 0],centeredfocus,-90,-90, 4,4)
Screen('DrawLine', window ,[0 0 0],1200, 1670, 1170, 1728,10);
Screen('DrawLine', window ,[0 0 0],2000, 1670, 2030, 1728,10);
Screen('DrawLine', window ,[0 0 0],1444, 1200,1424, 1239,4);
Screen('DrawLine', window ,[0 0 0],1756, 1200,1776, 1239,4);
Screen('DrawLines', window, allCoords,...
    lineWidthPix, 0, [xCenter yCenter]);
Screen('Flip', window);
[secs, keyCode, deltaSecs]  = KbPressWait(0);
 
 times=[times,deltaSecs];
 Screen('FillRect', window,0.5,windowRect );
 Screen('Flip', window);
 WaitSecs(1);
end
KbStrokeWait;

sca;