classdef uiconfusionchart < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        Title (1, 1) string = "Confusion Matrix"
        Normalization (1, 1) string = "absolute"
        RowSummary (1, 1) string = "off"
        ColumnSummary (1, 1) string = "off"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        ConfusionChart = []
    end
    
    methods
        function chart = plot(comp, varargin)
            %PLOT Recreate the wrapped chart using confusionchart inputs.
            comp.replaceChart(false, varargin{:});
            comp.captureChartState();

            if nargout > 0
                chart = comp.ConfusionChart;
            end
        end
    end

    methods (Access = private)
        function replaceChart(comp, syncState, varargin)
            if ~isempty(comp.ConfusionChart) && isvalid(comp.ConfusionChart)
                delete(comp.ConfusionChart);
            end

            comp.ConfusionChart = confusionchart(comp.Panel, varargin{:});
            comp.sizeChart();
            if syncState
                comp.syncChartState();
            end
        end

        function syncChartState(comp)
            comp.ConfusionChart.Title = char(comp.Title);
            comp.ConfusionChart.Normalization = char(comp.Normalization);
            comp.ConfusionChart.RowSummary = char(comp.RowSummary);
            comp.ConfusionChart.ColumnSummary = char(comp.ColumnSummary);
        end

        function captureChartState(comp)
            comp.Title = string(comp.ConfusionChart.Title);
            comp.Normalization = string(comp.ConfusionChart.Normalization);
            comp.RowSummary = string(comp.ConfusionChart.RowSummary);
            comp.ColumnSummary = string(comp.ConfusionChart.ColumnSummary);
        end

        function updatePanel(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) ...
                    max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end
        end

        function sizeChart(comp)
            comp.ConfusionChart.Units = "normalized";
            comp.ConfusionChart.OuterPosition = [0 0 1 1];
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.replaceChart(true, [18 2 1; 3 15 2; 1 2 16], ...
                ["Class A" "Class B" "Class C"]);
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
             comp.updatePanel();
            if ~isempty(comp.ConfusionChart) && isvalid(comp.ConfusionChart)
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