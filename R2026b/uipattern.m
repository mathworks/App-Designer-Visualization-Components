classdef uipattern < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        GridLayout  matlab.ui.container.GridLayout
        UIAxes      matlab.ui.control.UIAxes
    end

    properties
        Title (1, 1) string = "Radiation Pattern"
        DynamicRange (1, 1) double {mustBePositive} = 40
        ShowColorbar (1, 1) string = "on"
        Colormap (:, 3) double = parula(256)
    end
    
    properties (SetAccess = private, Transient, NonCopyable)
        Surface matlab.graphics.chart.primitive.Surface = ...
            matlab.graphics.chart.primitive.Surface.empty
        Colorbar matlab.graphics.illustration.ColorBar = ...
            matlab.graphics.illustration.ColorBar.empty
    end
    
    properties (Access = private, Transient, NonCopyable)
        PatternData double = double.empty
        Azimuth double = double.empty
        Elevation double = double.empty
    end

    methods
        function surfaceObject = plot(comp, antennaObject, frequency, varargin)
            %PLOT Calculate and display an antenna radiation pattern.
            %   PLOT(COMP,OBJECT,FREQUENCY) accepts the same calculation
            %   inputs as PATTERN(OBJECT,FREQUENCY), but renders the
            %   resulting data in the component's UI axes.
            %
            %   PLOT(COMP,OBJECT,FREQUENCY,AZIMUTH,ELEVATION) specifies the
            %   angular sample locations.
            %
            %   PLOT(COMP,...,Name=Value) forwards name-value arguments to
            %   the antenna object's PATTERN method.
            [patternData, azimuth, elevation] = pattern( ...
                antennaObject, frequency, varargin{:});

            comp.validatePatternData(patternData, azimuth, elevation);
            comp.PatternData = double(patternData);
            comp.Azimuth = double(azimuth(:).');
            comp.Elevation = double(elevation(:));
            comp.renderPattern();

            if nargout > 0
                surfaceObject = comp.Surface;
            end
        end
    end

    methods (Access = private)
        function renderPattern(comp)
            finiteValues = comp.PatternData(isfinite(comp.PatternData));
            if isempty(finiteValues)
                error("uipattern:NonfinitePattern", ...
                    "The calculated pattern contains no finite values.");
            end

            maximum = max(finiteValues);
            lowerLimit = max(min(finiteValues), ...
                maximum - comp.DynamicRange);
            clippedData = max(comp.PatternData, lowerLimit);

            if maximum > lowerLimit
                radius = (clippedData - lowerLimit) ./ ...
                    (maximum - lowerLimit);
            else
                radius = ones(size(clippedData));
            end
            radius(~isfinite(radius)) = 0;

            [azimuthGrid, elevationGrid] = meshgrid( ...
                comp.Azimuth, comp.Elevation);
            x = radius .* cosd(elevationGrid) .* cosd(azimuthGrid);
            y = radius .* cosd(elevationGrid) .* sind(azimuthGrid);
            z = radius .* sind(elevationGrid);

            set(comp.Surface, XData = x, YData = y, ZData = z, ...
                CData = comp.PatternData);
            if maximum > lowerLimit
                clim(comp.UIAxes, [lowerLimit maximum]);
            else
                clim(comp.UIAxes, maximum + [-0.5 0.5]);
            end
            axis(comp.UIAxes, "equal");
            axis(comp.UIAxes, "vis3d");
            view(comp.UIAxes, 3);
        end

        function applyAppearance(comp)
            title(comp.UIAxes, comp.Title);
            colormap(comp.UIAxes, comp.Colormap);
            comp.Colorbar.Visible = char(comp.ShowColorbar);
        end
    end

    methods (Static, Access = private)
        function validatePatternData(patternData, azimuth, elevation)
            if ~isnumeric(patternData) || ~ismatrix(patternData)
                error("uipattern:UnsupportedPatternData", ...
                    "PATTERN must return a numeric 2-D pattern matrix.");
            end
            if size(patternData, 1) ~= numel(elevation) || ...
                    size(patternData, 2) ~= numel(azimuth)
                error("uipattern:UnsupportedPatternSize", ...
                    "The pattern size must be elevation-by-azimuth.");
            end
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.UIAxes.Toolbar.Visible = "on";
            comp.Surface = surf(comp.UIAxes, nan(2), nan(2), nan(2), ...
                nan(2), EdgeColor = "none", FaceColor = "interp");
            comp.Colorbar = colorbar(comp.UIAxes);
            title(comp.UIAxes, comp.Title);
            comp.applyAppearance();
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            if isempty(comp.UIAxes) || ~isvalid(comp.UIAxes)
                return
            end

            comp.applyAppearance();
            if ~isempty(comp.PatternData)
                comp.renderPattern();
            end
        end

        % Create the underlying components
        function setup(comp)

            comp.Position = [1 1 320 240];

            % Create GridLayout
            comp.GridLayout = uigridlayout(comp);
            comp.GridLayout.ColumnWidth = {'1x'};
            comp.GridLayout.RowHeight = {'1x'};
            comp.GridLayout.ColumnSpacing = 0;
            comp.GridLayout.RowSpacing = 0;
            comp.GridLayout.Padding = [0 0 0 0];

            % Create UIAxes
            comp.UIAxes = uiaxes(comp.GridLayout);
            title(comp.UIAxes, 'Title')
            xlabel(comp.UIAxes, 'X')
            ylabel(comp.UIAxes, 'Y')
            zlabel(comp.UIAxes, 'Z')
            comp.UIAxes.View = [-37.5 30];
            comp.UIAxes.Projection = 'perspective';
            comp.UIAxes.DataAspectRatioMode = 'manual';
            comp.UIAxes.Layout.Row = 1;
            comp.UIAxes.Layout.Column = 1;
            
            % Execute the startup function
            postSetupFcn(comp)
        end
    end
end