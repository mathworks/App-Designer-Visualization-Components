classdef uivolshow < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties
        Title (1, 1) string = "Volume"
        RenderingStyle (1, 1) string = "VolumeRendering"
        BackgroundGradient (1, 1) string = "on"
        Denoising (1, 1) string = "off"
    end

    properties (SetAccess = private, Transient, NonCopyable)
        Viewer = []
        Volume = []
    end
    
    methods
        function volumeObject = plot(comp, volumeData, varargin)
            %PLOT Recreate the wrapped volshow object for volumeData.
            comp.replaceVolume(false, volumeData, varargin{:});
            comp.captureViewerState();

            if nargout > 0
                volumeObject = comp.Volume;
            end
        end
    end

    methods (Access = private)
        function replaceVolume(comp, syncState, volumeData, varargin)
            if ~isempty(comp.Volume) && isvalid(comp.Volume)
                delete(comp.Volume);
            end

            comp.Volume = volshow(volumeData, varargin{:}, ...
                Parent = comp.Viewer);
            if syncState
                comp.syncViewerState();
            end
        end

        function syncViewerState(comp)
            comp.Viewer.Title = comp.Title;
            comp.Viewer.BackgroundGradient = char(comp.BackgroundGradient);
            comp.Viewer.Denoising = char(comp.Denoising);
            if ~isempty(comp.Volume) && isvalid(comp.Volume)
                comp.Volume.RenderingStyle = char(comp.RenderingStyle);
            end
        end

        function captureViewerState(comp)
            comp.Title = string(comp.Viewer.Title);
            comp.BackgroundGradient = ...
                string(comp.Viewer.BackgroundGradient);
            comp.Denoising = string(comp.Viewer.Denoising);
            comp.RenderingStyle = string(comp.Volume.RenderingStyle);
        end

        function updatePanel(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) ...
                    max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end
        end
    end

    methods (Static, Access = private)
        function volumeData = defaultVolume()
            [x, y, z] = ndgrid(linspace(-1, 1, 64), ...
                linspace(-1, 1, 64), linspace(-1, 1, 48));
            volumeData = uint8(255 * exp(-5 * ...
                (x.^2 + 1.4*y.^2 + 0.8*z.^2)));
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.Viewer = viewer3d(comp.Panel);
            comp.replaceVolume(true, comp.defaultVolume());
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            comp.updatePanel();
            if ~isempty(comp.Viewer) && isvalid(comp.Viewer)
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