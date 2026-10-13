classdef uismithplot < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        LegendVisible (1, 1) logical = true
        TitleTop string = "Smith Plot"
        TitleBottom string = ""
        GridVisible (1, 1) logical = true
    end

    properties (SetAccess = private, Transient, NonCopyable)
        SmithPlot = []
    end

    methods
        function chart = plot(comp, varargin)
            %PLOT Recreate the wrapped chart using smithplot arguments.
            %
            % plot(comp, data), plot(comp, frequency, data), and network
            % parameter inputs accept the same arguments as smithplot.
            comp.replaceSmithPlot(false, varargin{:});
            comp.captureChartState();

            if nargout > 0
                chart = comp.SmithPlot;
            end
        end

        function addData(comp, varargin)
            add(comp.SmithPlot, varargin{:});
        end
    end

    methods (Access = private)
        function replaceSmithPlot(comp, syncState, varargin)
            if ~isempty(comp.SmithPlot) && isvalid(comp.SmithPlot)
                delete(comp.SmithPlot);
            end

            [chartArguments, legendLabels] = comp.normalizeNetworkArguments(varargin);
            comp.SmithPlot = smithplot(comp.Panel, chartArguments{:});
            if ~isempty(legendLabels)
                comp.SmithPlot.LegendLabels = legendLabels;
            end

            if syncState
                comp.syncChartState();
            end
        end

        function syncChartState(comp)
            comp.SmithPlot.LegendVisible = comp.LegendVisible;
            comp.SmithPlot.TitleTop = char(comp.TitleTop);
            comp.SmithPlot.TitleBottom = char(comp.TitleBottom);
            comp.SmithPlot.GridVisible = comp.GridVisible;
        end

        function captureChartState(comp)
            comp.LegendVisible = comp.SmithPlot.LegendVisible;
            comp.TitleTop = string(comp.SmithPlot.TitleTop);
            comp.TitleBottom = string(comp.SmithPlot.TitleBottom);
            comp.GridVisible = comp.SmithPlot.GridVisible;
        end

        function [arguments, legendLabels] = normalizeNetworkArguments(~, arguments)
            legendLabels = {};
            if isempty(arguments) || ...
                    ~isa(arguments{1}, "rf.internal.netparams.Interface")
                return
            end

            network = arguments{1};
            remainingArguments = arguments(2:end);
            if numel(remainingArguments) >= 2 && ...
                    isnumeric(remainingArguments{1}) && isscalar(remainingArguments{1}) && ...
                    isnumeric(remainingArguments{2}) && isscalar(remainingArguments{2})
                parameterPairs = [remainingArguments{1}, remainingArguments{2}];
                remainingArguments = remainingArguments(3:end);
            elseif ~isempty(remainingArguments) && ...
                    isnumeric(remainingArguments{1}) && ...
                    size(remainingArguments{1}, 2) == 2
                parameterPairs = remainingArguments{1};
                remainingArguments = remainingArguments(2:end);
            else
                ports = 1:network.NumPorts;
                parameterPairs = [repelem(ports(:), network.NumPorts), ...
                    repmat(ports(:), network.NumPorts, 1)];
            end

            if any(parameterPairs(:) < 1) || ...
                    any(parameterPairs(:) > network.NumPorts) || ...
                    any(parameterPairs(:) ~= fix(parameterPairs(:)))
                error("uismithplot_exported:InvalidParameterIndex", ...
                    "Network parameter indices must be integers from 1 through %d.", ...
                    network.NumPorts);
            end

            frequency = network.Frequencies(:);
            data = zeros(numel(frequency), size(parameterPairs, 1), ...
                "like", network.Parameters);
            for pairIndex = 1:size(parameterPairs, 1)
                data(:, pairIndex) = reshape(network.Parameters( ...
                    parameterPairs(pairIndex, 1), ...
                    parameterPairs(pairIndex, 2), :), [], 1);
            end

            parameterType = upper(extractBefore(string(class(network)), "parameters"));
            legendLabels = cellstr(compose("%s%d%d", parameterType, ...
                parameterPairs(:, 1), parameterPairs(:, 2)));
            arguments = [{frequency, data}, remainingArguments];
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            defaultData = exp(1i * linspace(0, 2*pi, 64)) .* ...
                linspace(0.2, 0.9, 64);
            comp.replaceSmithPlot(true, defaultData);
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
           if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end

            if ~isempty(comp.SmithPlot) && isvalid(comp.SmithPlot)
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