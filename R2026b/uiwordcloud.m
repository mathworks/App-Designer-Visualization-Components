classdef uiwordcloud < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties (Access = private, Transient, NonCopyable)
        DataMode (1, 1) string = "arrays"
    end
    
    properties
        WordData string = ["MATLAB" "App" "Designer" "Map" "Chart" "UI" "Component"]
        SizeData double = [12 10 9 8 7 6 5]
        Title string = "Word Cloud"
        Shape (1, 1) string = "oval"
        MaxDisplayWords (1, 1) double = 100
        LayoutNum (1, 1) double = 1
    end

    properties (SetAccess = private, Transient, NonCopyable)
        WordCloud = []
    end

    methods
        function chart = plot(comp, varargin)
            %PLOT Recreate the wrapped chart using wordcloud data arguments.
            %
            % plot(comp, tbl, wordVariable, sizeVariable) accepts the same
            % data arguments as wordcloud(tbl, wordVariable, sizeVariable).
            comp.DataMode = "forwarded";
            comp.replaceWordCloud(false, varargin{:});
            comp.captureChartState();

            if nargout > 0
                chart = comp.WordCloud;
            end
        end
    end

    methods (Access = private)
        function syncChartState(comp)
            if comp.DataMode == "arrays"
                comp.WordCloud.WordData = comp.WordData;
                comp.WordCloud.SizeData = comp.SizeData;
            end

            comp.WordCloud.Title = char(comp.Title);
            comp.WordCloud.Shape = char(comp.Shape);
            comp.WordCloud.MaxDisplayWords = comp.MaxDisplayWords;
            comp.WordCloud.LayoutNum = comp.LayoutNum;
        end

        function replaceWordCloud(comp, syncState, varargin)
            if ~isempty(comp.WordCloud) && isvalid(comp.WordCloud)
                delete(comp.WordCloud);
            end

            comp.WordCloud = wordcloud(comp.Panel, varargin{:});
            comp.WordCloud.Units = "normalized";
            comp.WordCloud.OuterPosition = [0 0 1 1];
            if syncState
                comp.syncChartState();
            end
        end

        function captureChartState(comp)
            comp.Title = string(comp.WordCloud.Title);
            comp.Shape = string(comp.WordCloud.Shape);
            comp.MaxDisplayWords = comp.WordCloud.MaxDisplayWords;
            comp.LayoutNum = comp.WordCloud.LayoutNum;
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.replaceWordCloud(true, comp.WordData, comp.SizeData);
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
             if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end

            if ~isempty(comp.WordCloud) && isvalid(comp.WordCloud)
                comp.WordCloud.Units = "normalized";
                comp.WordCloud.OuterPosition = [0 0 1 1];
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