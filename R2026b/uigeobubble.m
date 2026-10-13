classdef uigeobubble < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        Title (1, 1) string = "Geographic Bubbles"
        Basemap (1, 1) string = "darkwater"
        MapLayout (1, 1) string = "normal"
        LegendVisible (1, 1) string = "on"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        GeoBubble = []
    end
    
    methods
        function chart = plot(comp, varargin)
            %PLOT Recreate the wrapped chart using geobubble inputs.
            comp.replaceChart(false, varargin{:});
            comp.captureChartState();

            if nargout > 0
                chart = comp.GeoBubble;
            end
        end
    end
    methods (Access = private)
        function replaceChart(comp, syncState, varargin)
            if ~isempty(comp.GeoBubble) && isvalid(comp.GeoBubble)
                delete(comp.GeoBubble);
            end

            comp.GeoBubble = geobubble(comp.Panel, varargin{:});
            comp.sizeChart();
            if syncState
                comp.syncChartState();
            end
        end

        function syncChartState(comp)
            comp.GeoBubble.Title = char(comp.Title);
            comp.GeoBubble.Basemap = char(comp.Basemap);
            comp.GeoBubble.MapLayout = char(comp.MapLayout);
            comp.GeoBubble.LegendVisible = char(comp.LegendVisible);
        end

        function captureChartState(comp)
            comp.Title = string(comp.GeoBubble.Title);
            comp.Basemap = string(comp.GeoBubble.Basemap);
            comp.MapLayout = string(comp.GeoBubble.MapLayout);
            comp.LegendVisible = string(comp.GeoBubble.LegendVisible);
        end

        function updatePanel(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) ...
                    max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end
        end

        function sizeChart(comp)
            comp.GeoBubble.Units = "normalized";
            comp.GeoBubble.OuterPosition = [0 0 1 1];
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            latitude = [42.3601; 40.7128; 38.9072];
            longitude = [-71.0589; -74.0060; -77.0369];
            comp.replaceChart(true, latitude, longitude, ...
                Basemap = comp.Basemap);
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            comp.updatePanel();
            if ~isempty(comp.GeoBubble) && isvalid(comp.GeoBubble)
                comp.sizeChart();
                comp.syncChartState();
            end
        end

        % Create the underlying components
        function setup(comp)

            comp.Position = [1 1 320 240];

            % Create Panel
            comp.Panel = uipanel(comp);
            comp.Panel.AutoResizeChildren = 'off';
            comp.Panel.BorderType = 'none';
            comp.Panel.BackgroundColor = [1 1 1];
            comp.Panel.Position = [1 1 320 240];
            
            % Execute the startup function
            postSetupFcn(comp)
        end
    end
end