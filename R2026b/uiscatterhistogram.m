classdef uiscatterhistogram < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        Title (1, 1) string = "Scatter Histogram"
        HistogramDisplayStyle (1, 1) string = "stairs"
        LegendVisible (1, 1) string = "on"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        ScatterHistogram = []
    end
    
    methods
        function chart = plot(comp, varargin)
            %PLOT Recreate the wrapped chart using scatterhistogram inputs.
            comp.replaceChart(false, varargin{:});
            comp.captureChartState();

            if nargout > 0
                chart = comp.ScatterHistogram;
            end
        end
    end

    methods (Access = private)
        function replaceChart(comp, syncState, varargin)
            if ~isempty(comp.ScatterHistogram) && isvalid(comp.ScatterHistogram)
                delete(comp.ScatterHistogram);
            end

            comp.ScatterHistogram = scatterhistogram(comp.Panel, varargin{:});
            comp.sizeChart();
            if syncState
                comp.syncChartState();
            end
        end

        function syncChartState(comp)
            comp.ScatterHistogram.Title = char(comp.Title);
            comp.ScatterHistogram.HistogramDisplayStyle = ...
                char(comp.HistogramDisplayStyle);
            comp.ScatterHistogram.LegendVisible = char(comp.LegendVisible);
        end

        function captureChartState(comp)
            comp.Title = string(comp.ScatterHistogram.Title);
            comp.HistogramDisplayStyle = ...
                string(comp.ScatterHistogram.HistogramDisplayStyle);
            comp.LegendVisible = string(comp.ScatterHistogram.LegendVisible);
        end

        function updatePanel(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) ...
                    max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end
        end

        function sizeChart(comp)
            comp.ScatterHistogram.Units = "normalized";
            comp.ScatterHistogram.OuterPosition = [0 0 1 1];
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            x = randn(50, 1);
            comp.replaceChart(true, x, 0.6*x + randn(50, 1));
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            comp.updatePanel();
            if ~isempty(comp.ScatterHistogram) && isvalid(comp.ScatterHistogram)
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