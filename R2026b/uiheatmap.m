classdef uiheatmap < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties (Access = private, Transient, NonCopyable)
        DataMode (1, 1) string = "matrix"
    end

    properties
        ColorData double = magic(5)
        Title string = "Heatmap"
        Colormap double = parula(64)
        ColorLimits = []
        XDisplayLabels = {}
        YDisplayLabels = {}
        ColorbarVisible (1, 1) string = "on"
        GridVisible (1, 1) string = "on"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        Heatmap = []
    end

    methods
        function setData(comp, data, xLabels, yLabels)
            comp.ColorData = data;
            if nargin >= 3
                comp.XDisplayLabels = xLabels;
            end
            if nargin >= 4
                comp.YDisplayLabels = yLabels;
            end
        end

        function chart = plot(comp, varargin)
            %PLOT Recreate the wrapped chart using heatmap data arguments.
            %
            % plot(comp, tbl, xVariable, yVariable) accepts the same data
            % arguments as heatmap(tbl, xVariable, yVariable).
            comp.DataMode = "forwarded";
            comp.replaceHeatmap(false, varargin{:});
            comp.captureChartState();

            if nargout > 0
                chart = comp.Heatmap;
            end
        end
    end
    
    methods (Access = private)
        function syncChartState(comp)
            if comp.DataMode == "matrix"
                comp.Heatmap.ColorData = comp.ColorData;
            end

            comp.Heatmap.Title = char(comp.Title);
            comp.Heatmap.Colormap = comp.Colormap;
            comp.Heatmap.ColorbarVisible = char(comp.ColorbarVisible);
            comp.Heatmap.GridVisible = char(comp.GridVisible);

            if ~isempty(comp.ColorLimits)
                comp.Heatmap.ColorLimits = comp.ColorLimits;
            end

            if ~isempty(comp.XDisplayLabels)
                comp.Heatmap.XDisplayLabels = comp.XDisplayLabels;
            end

            if ~isempty(comp.YDisplayLabels)
                comp.Heatmap.YDisplayLabels = comp.YDisplayLabels;
            end
        end

        function replaceHeatmap(comp, syncState, varargin)
            if ~isempty(comp.Heatmap) && isvalid(comp.Heatmap)
                delete(comp.Heatmap);
            end

            comp.Heatmap = heatmap(comp.Panel, varargin{:});
            comp.Heatmap.Units = "normalized";
            comp.Heatmap.Position = [0 0 1 1];
            if syncState
                comp.syncChartState();
            end
        end

        function captureChartState(comp)
            comp.Title = string(comp.Heatmap.Title);
            comp.Colormap = comp.Heatmap.Colormap;
            comp.ColorLimits = comp.Heatmap.ColorLimits;
            comp.XDisplayLabels = comp.Heatmap.XDisplayLabels;
            comp.YDisplayLabels = comp.Heatmap.YDisplayLabels;
            comp.ColorbarVisible = string(comp.Heatmap.ColorbarVisible);
            comp.GridVisible = string(comp.Heatmap.GridVisible);
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.replaceHeatmap(true, comp.ColorData);
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
           if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end

            if ~isempty(comp.Heatmap) && isvalid(comp.Heatmap)
                comp.Heatmap.Units = "normalized";
                comp.Heatmap.OuterPosition = [0 0 1 1];
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