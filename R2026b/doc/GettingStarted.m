%% Getting Started with the R2026b Visualization Component Exports
% This component pack adds 17 visualization components to the App Designer
% Component Library. The components wrap MATLAB charts, axes, maps, and
% image viewers so they can be placed and resized on an app canvas.
% Requires MATLAB R2026b or newer. Keep this guide in R2026b/doc so that
% its setup resolves the exported components and their local metadata.

%% Set Up the Component Pack
% Run the setup function once per MATLAB session. If App Designer is already
% open, restart it afterward to refresh the Component Library.

componentRoot = fileparts(fileparts(mfilename("fullpath")));
addpath(componentRoot)
componentNames = setupPanelWrappedComponents;

disp(componentNames)

%% Find the Components in App Designer
% Open or create an app and look under *Visualization - Axes & Maps*,
% *Visualization - Charts*, *Visualization - Image & Volume*, or
% *Visualization - RF & Antennas*. Drag a component onto the canvas, then
% access it through the property name shown in the Component Browser.

%% Create a Polar Plot Programmatically
% Custom components can also be parented to a UI figure from code. The
% plotting method accepts the same data arguments as |polarplot| while the
% component manages the parent container.

galleryFigure = uifigure( ...
    Name="Visualization Component Example", ...
    Position=[100 100 640 480], ...
    Visible="off");

polarComponent = uipolaraxes(galleryFigure);
polarComponent.Position = [20 20 600 440];

theta = linspace(0, 2*pi, 200);
rho = abs(sin(3*theta));
polarplot(polarComponent, theta, rho);
title(polarComponent, "Three-Lobed Polar Plot");

galleryFigure.Visible = "on";

%% Work with Other Components
% The same pattern applies throughout the pack:
%
% * Use |geoplot(component,latitude,longitude)| with |uigeoaxes|.
% * Assign a table or timetable to |uistackedplot.SourceTable|.
% * Use |plot(component,volumeData)| with the image and volume viewers.
% * Access the wrapped visualization through the component's documented
%   read-only object property when advanced customization is needed.
%
% See the component gallery in the repository's |README.md| and the local
% |*_demo.m| files for complete examples. For demos with a companion XML
% file, keep it beside the MATLAB file for running and App Designer editing.
% The local README identifies the four conventional class exports that use
% their original .mlapp files for visual editing.

%% Next Steps
% * Open App Designer: |appdesigner|
% * Read setup help: |help setupPanelWrappedComponents|
% * Read local setup notes: |open README.md|
% * Explore the component gallery: |open ../README.md|

% Copyright 2026 The MathWorks, Inc.
