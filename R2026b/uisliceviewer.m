classdef uisliceviewer < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        SliceDirection (1, 1) string = "Z"
        ScaleFactors (1, 3) double = [1 1 1]
        DisplayRangeInteraction (1, 1) string = "on"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        SliceViewer = []
    end
    properties (Access = private, Transient, NonCopyable)
        ViewerPanel matlab.ui.container.Panel
    end

    methods
        function viewer = plot(comp, volumeData, varargin)
            %PLOT Recreate the wrapped sliceViewer for volumeData.
            comp.replaceViewer(false, volumeData, varargin{:});
            comp.captureViewerState();

            if nargout > 0
                viewer = comp.SliceViewer;
            end
        end
    end
    
    methods (Access = private)
        function replaceViewer(comp, syncState, volumeData, varargin)
            if ~isempty(comp.SliceViewer) && isvalid(comp.SliceViewer)
                delete(comp.SliceViewer);
            end
            if isempty(comp.ViewerPanel) || ~isvalid(comp.ViewerPanel)
                comp.createPanel();
            end

            comp.SliceViewer = sliceViewer(volumeData, varargin{:}, ...
                Parent = comp.ViewerPanel);
            if syncState
                comp.syncViewerState();
            end
        end

        function syncViewerState(comp)
            comp.SliceViewer.SliceDirection = char(comp.SliceDirection);
            comp.SliceViewer.ScaleFactors = comp.ScaleFactors;
            comp.SliceViewer.DisplayRangeInteraction = ...
                char(comp.DisplayRangeInteraction);
        end

        function captureViewerState(comp)
            direction = comp.SliceViewer.SliceDirection;
            if isnumeric(direction) || islogical(direction)
                directionNames = ["X" "Y" "Z"];
                comp.SliceDirection = directionNames(logical(direction));
            else
                comp.SliceDirection = string(direction);
            end
            comp.ScaleFactors = comp.SliceViewer.ScaleFactors;
            comp.DisplayRangeInteraction = ...
                string(comp.SliceViewer.DisplayRangeInteraction);
        end

        function updatePanel(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) ...
                    max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end
            if ~isempty(comp.ViewerPanel) && isvalid(comp.ViewerPanel)
                comp.ViewerPanel.BackgroundColor = comp.BackgroundColor;
            end
        end

        function createPanel(comp)
            comp.ViewerPanel = uipanel(comp.Panel, ...
                BorderType = "none", ...
                AutoResizeChildren = "on", ...
                Units = "normalized", ...
                BackgroundColor = comp.BackgroundColor, ...
                Position = [0 0 1 1]);
        end
    end

    methods (Static, Access = private)
        function volumeData = defaultVolume()
            [x, y, z] = ndgrid(linspace(-1, 1, 64), ...
                linspace(-1, 1, 64), linspace(-1, 1, 32));
            volumeData = uint8(255 * exp(-4 * (x.^2 + y.^2 + z.^2)));
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.createPanel();
            comp.replaceViewer(true, comp.defaultVolume());
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            comp.updatePanel();
            if ~isempty(comp.SliceViewer) && isvalid(comp.SliceViewer)
                comp.syncViewerState();
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