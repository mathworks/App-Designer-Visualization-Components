classdef uipolaraxes < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    
    properties (Dependent)
        ThetaLim (1, 2) double
        RLim (1, 2) double
        ThetaDir (1, 1) string
    end

    properties (SetAccess = private, Transient, NonCopyable)
        PolarAxes = []
    end

    properties (Access = private)
        ThetaLim_ (1, 2) double = [0 360]
        RLim_ (1, 2) double = [0 1]
        ThetaDir_ (1, 1) string = "counterclockwise"
    end


    methods
        function value = get.ThetaLim(comp)
            if comp.isAxesReady()
                value = comp.PolarAxes.ThetaLim;
            else
                value = comp.ThetaLim_;
            end
        end

        function set.ThetaLim(comp, value)
            validateattributes(value, {'numeric'}, {'real', 'finite', 'increasing', 'size', [1 2]}, '', 'ThetaLim');
            comp.ThetaLim_ = double(value);
            if comp.isAxesReady()
                thetalim(comp.PolarAxes, comp.ThetaLim_);
            end
        end

        function value = get.RLim(comp)
            if comp.isAxesReady()
                value = comp.PolarAxes.RLim;
            else
                value = comp.RLim_;
            end
        end

        function set.RLim(comp, value)
            validateattributes(value, {'numeric'}, {'real', 'finite', 'increasing', 'size', [1 2]}, '', 'RLim');
            comp.RLim_ = double(value);
            if comp.isAxesReady()
                rlim(comp.PolarAxes, comp.RLim_);
            end
        end

        function value = get.ThetaDir(comp)
            if comp.isAxesReady()
                value = string(comp.PolarAxes.ThetaDir);
            else
                value = comp.ThetaDir_;
            end
        end

        function set.ThetaDir(comp, value)
            comp.ThetaDir_ = string(value);
            if comp.isAxesReady()
                comp.PolarAxes.ThetaDir = char(comp.ThetaDir_);
            end
        end

        function varargout = polarplot(comp, varargin)
            [varargout{1:nargout}] = polarplot(comp.PolarAxes, varargin{:});
        end

        function varargout = polarscatter(comp, varargin)
            [varargout{1:nargout}] = polarscatter(comp.PolarAxes, varargin{:});
        end

        function varargout = polarhistogram(comp, varargin)
            [varargout{1:nargout}] = polarhistogram(comp.PolarAxes, varargin{:});
        end

        function varargout = title(comp, varargin)
            [varargout{1:nargout}] = title(comp.PolarAxes, varargin{:});
        end

        function varargout = legend(comp, varargin)
            [varargout{1:nargout}] = legend(comp.PolarAxes, varargin{:});
        end

        function hold(comp, varargin)
            hold(comp.PolarAxes, varargin{:});
        end

        function cla(comp, varargin)
            cla(comp.PolarAxes, varargin{:});
        end
    end

    methods (Access = private)
        function syncAxesState(comp)
            thetalim(comp.PolarAxes, comp.ThetaLim_);
            rlim(comp.PolarAxes, comp.RLim_);
            comp.PolarAxes.ThetaDir = char(comp.ThetaDir_);
        end

        function tf = isAxesReady(comp)
            tf = ~isempty(comp.PolarAxes) && isvalid(comp.PolarAxes);
        end
    end

    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.PolarAxes = polaraxes(comp.Panel, ...
                Units = "normalized", ...
                Position = [0 0 1 1]);

            comp.syncAxesState();
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end

            if comp.isAxesReady()
                comp.PolarAxes.Units = "normalized";
                comp.PolarAxes.Position = [0 0 1 1];
                comp.syncAxesState();
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