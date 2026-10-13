classdef uiparallelplot < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        Data double = rand(12, 4)
        GroupData = categorical(randi(3, 12, 1))
        Title string = "Parallel Coordinates"
        DataNormalization (1, 1) string = "range"
        LegendVisible (1, 1) string = "on"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        ParallelPlot = []
    end

    methods
        function chart = plot(comp, varargin)
            %PLOT Recreate the wrapped chart using parallelplot arguments.
            %
            % plot(comp, tbl) and plot(comp, tbl, Name, Value) accept the
            % same data arguments as the corresponding parallelplot calls.
            comp.validateTableVariables(varargin);
            comp.Panel.UserData = "forwarded";
            comp.replaceParallelPlot(false, varargin{:});
            comp.captureChartState();

            if nargout > 0
                chart = comp.ParallelPlot;
            end
        end
    end

    methods (Access = private)
        function syncChartState(comp)
            if comp.isMatrixMode()
                comp.ParallelPlot.Data = comp.Data;

                if ~isempty(comp.GroupData) && numel(comp.GroupData) == size(comp.Data, 1)
                    comp.ParallelPlot.GroupData = comp.GroupData;
                else
                    comp.ParallelPlot.GroupData = [];
                end
            end

            comp.ParallelPlot.Title = char(comp.Title);
            comp.ParallelPlot.DataNormalization = char(comp.DataNormalization);
            comp.ParallelPlot.LegendVisible = char(comp.LegendVisible);
        end

        function replaceParallelPlot(comp, syncState, varargin)
            if ~isempty(comp.ParallelPlot) && isvalid(comp.ParallelPlot)
                delete(comp.ParallelPlot);
            end

            comp.ParallelPlot = parallelplot(comp.Panel, varargin{:});
            comp.ParallelPlot.Units = "normalized";
            comp.ParallelPlot.OuterPosition = [0 0 1 1];
            if syncState
                comp.syncChartState();
            end
        end

        function captureChartState(comp)
            comp.Title = string(comp.ParallelPlot.Title);
            comp.DataNormalization = string(comp.ParallelPlot.DataNormalization);
            comp.LegendVisible = string(comp.ParallelPlot.LegendVisible);
        end

        function tf = isMatrixMode(comp)
            tf = isempty(comp.Panel.UserData) || ...
                string(comp.Panel.UserData) == "matrix";
        end

        function validateTableVariables(comp, arguments)
            if isempty(arguments) || ~istable(arguments{1})
                return
            end

            variableNames = string(arguments{1}.Properties.VariableNames);
            for argumentIndex = 2:2:(numel(arguments) - 1)
                parameterName = arguments{argumentIndex};
                if ~(ischar(parameterName) || ...
                        (isstring(parameterName) && isscalar(parameterName)))
                    continue
                end

                parameterValue = arguments{argumentIndex + 1};
                if strcmpi(parameterName, "CoordinateVariables")
                    comp.validateVariableNames( ...
                        parameterValue, variableNames, "CoordinateVariables");
                elseif strcmpi(parameterName, "GroupVariable")
                    comp.validateVariableNames( ...
                        parameterValue, variableNames, "GroupVariable");
                end
            end
        end
    end

    methods (Static, Access = private)
        function validateVariableNames(value, variableNames, parameterName)
            if ischar(value)
                requestedNames = string({value});
            elseif isstring(value)
                requestedNames = value;
            elseif iscellstr(value)
                requestedNames = string(value);
            else
                return
            end

            missingNames = requestedNames(~ismember(requestedNames, variableNames));
            if ~isempty(missingNames)
                error("uiparallelplot_exported:UnknownTableVariable", ...
                    "%s refers to unknown table variable(s): %s. Available variables: %s.", ...
                    parameterName, strjoin(missingNames, ", "), ...
                    strjoin(variableNames, ", "));
            end
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.replaceParallelPlot(true, comp.Data);
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end

            if ~isempty(comp.ParallelPlot) && isvalid(comp.ParallelPlot)
                comp.ParallelPlot.Units = "normalized";
                comp.ParallelPlot.OuterPosition = [0 0 1 1];
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