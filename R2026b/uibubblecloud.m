classdef uibubblecloud < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        Title (1, 1) string = "Bubble Cloud"
        LegendTitle (1, 1) string = ""
        LegendVisible (1, 1) string = "on"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        BubbleCloud = []
    end
    
    methods
        function chart = plot(comp, varargin)
            %PLOT Recreate the wrapped chart using bubblecloud inputs.
            comp.replaceChart(false, varargin{:});
            comp.captureChartState();

            if nargout > 0
                chart = comp.BubbleCloud;
            end
        end
    end

    methods (Access = private)
        function replaceChart(comp, syncState, varargin)
            if ~isempty(comp.BubbleCloud) && isvalid(comp.BubbleCloud)
                delete(comp.BubbleCloud);
            end

            comp.BubbleCloud = bubblecloud(comp.Panel, varargin{:});
            comp.sizeChart();
            if syncState
                comp.syncChartState();
            end
        end

        function syncChartState(comp)
            comp.BubbleCloud.Title = char(comp.Title);
            comp.BubbleCloud.LegendTitle = char(comp.LegendTitle);
            comp.BubbleCloud.LegendVisible = char(comp.LegendVisible);
        end

        function captureChartState(comp)
            comp.Title = string(comp.BubbleCloud.Title);
            comp.LegendTitle = string(comp.BubbleCloud.LegendTitle);
            comp.LegendVisible = string(comp.BubbleCloud.LegendVisible);
        end

        function updatePanel(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) ...
                    max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end
        end

        function sizeChart(comp)
            comp.BubbleCloud.Units = "normalized";
            comp.BubbleCloud.OuterPosition = [0 0 1 1];
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.replaceChart(true, [12 9 7 5 3], ...
                ["MATLAB" "Apps" "Charts" "Data" "UI"]);
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            comp.updatePanel();
            if ~isempty(comp.BubbleCloud) && isvalid(comp.BubbleCloud)
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