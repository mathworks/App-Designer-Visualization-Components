classdef uiorthosliceviewer < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties (Access = private, Transient, NonCopyable)
        HostPanel matlab.ui.container.Panel
    end

    properties
        ScaleFactors (1, 3) double = [1 1 1]
        DisplayRangeInteraction (1, 1) string = "on"
        CrosshairEnable (1, 1) string = "on"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        OrthosliceViewer = []
    end
    
    methods
        function viewer = plot(comp, volumeData, varargin)
            %PLOT Recreate the wrapped orthosliceViewer for volumeData.
            comp.replaceViewer(false, volumeData, varargin{:});
            comp.captureViewerState();

            if nargout > 0
                viewer = comp.OrthosliceViewer;
            end
        end
    end

     methods (Access = private)
        function replaceViewer(comp, syncState, volumeData, varargin)
            if ~isempty(comp.OrthosliceViewer) && ...
                    isvalid(comp.OrthosliceViewer)
                delete(comp.OrthosliceViewer);
            end
            if isempty(comp.Panel) || ~isvalid(comp.Panel)
                comp.createPanel();
            end

            comp.OrthosliceViewer = orthosliceViewer(volumeData, ...
                varargin{:}, Parent = comp.Panel);
            if syncState
                comp.syncViewerState();
            end
        end

        function syncViewerState(comp)
            comp.OrthosliceViewer.ScaleFactors = comp.ScaleFactors;
            comp.OrthosliceViewer.DisplayRangeInteraction = ...
                char(comp.DisplayRangeInteraction);
            comp.OrthosliceViewer.CrosshairEnable = ...
                char(comp.CrosshairEnable);
        end

        function captureViewerState(comp)
            comp.ScaleFactors = comp.OrthosliceViewer.ScaleFactors;
            comp.DisplayRangeInteraction = ...
                string(comp.OrthosliceViewer.DisplayRangeInteraction);
            comp.CrosshairEnable = ...
                string(comp.OrthosliceViewer.CrosshairEnable);
        end

        function updatePanel(comp)
            if ~isempty(comp.HostPanel) && isvalid(comp.HostPanel)
                comp.HostPanel.Position = [1 1 max(comp.Position(3), 1) ...
                    max(comp.Position(4), 1)];
                comp.HostPanel.BackgroundColor = comp.BackgroundColor;
            end
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end
        end

        function createPanel(comp)
            comp.Panel = uipanel(comp.HostPanel, ...
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
            shell = abs(sqrt(x.^2 + y.^2 + z.^2) - 0.55);
            volumeData = uint8(255 * exp(-40 * shell.^2));
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            % orthosliceViewer deletes its parent when the viewer is
            % deleted. Keep a stable host so the disposable viewer panel
            % can be recreated after component setup.
            comp.HostPanel = uipanel(comp, ...
                BorderType = "none", ...
                AutoResizeChildren = "on", ...
                Units = "pixels", ...
                BackgroundColor = comp.BackgroundColor, ...
                Position = [1 1 560 360]);
            comp.createPanel();
            comp.replaceViewer(true, comp.defaultVolume());
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            comp.updatePanel();
            if ~isempty(comp.OrthosliceViewer) && ...
                    isvalid(comp.OrthosliceViewer)
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