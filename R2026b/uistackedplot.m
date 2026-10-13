classdef uistackedplot < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        SourceTable = uistackedplot.defaultSourceTable()
        DisplayVariables = string.empty(1, 0)
        XVariable (1, 1) string = ""
        Title string = "Stacked Plot"
        GridVisible (1, 1) string = "on"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        StackedPlot = []
    end

    methods (Access = private)
        function syncChartState(comp)
            comp.StackedPlot.SourceTable = comp.SourceTable;
            comp.StackedPlot.Title = char(comp.Title);
            comp.StackedPlot.GridVisible = char(comp.GridVisible);

            if ~isempty(comp.DisplayVariables)
                comp.StackedPlot.DisplayVariables = comp.DisplayVariables;
            end

            if strlength(comp.XVariable) > 0
                comp.StackedPlot.XVariable = char(comp.XVariable);
            end
        end
    end

    methods (Static, Access = private)
        function tt = defaultSourceTable()
            tt = timetable(minutes(1:20)', ...
                cumsum(randn(20, 1)), ...
                cumsum(randn(20, 1)), ...
                20 + randn(20, 1), ...
                'VariableNames', {'SignalA', 'SignalB', 'Temperature'});
        end
    end   

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.StackedPlot = stackedplot(comp.Panel, comp.SourceTable);
            comp.syncChartState();
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end

            if ~isempty(comp.StackedPlot) && isvalid(comp.StackedPlot)
                comp.StackedPlot.Units = "normalized";
                comp.StackedPlot.OuterPosition = [0 0 1 1];
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