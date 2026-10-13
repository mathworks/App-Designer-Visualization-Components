classdef uimapaxes < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties (Dependent)
        ProjectedCRS (1, 1) projcrs
        LatitudeLimits (1, 2) double
        LongitudeLimits (1, 2) double
        MapLayout (1, 1) string
        ScalebarVisible (1, 1) string
    end
    properties (SetAccess = private, Transient, NonCopyable)
        MapAxes map.graphics.axis.MapAxes = ...
            map.graphics.axis.MapAxes.empty
    end
    properties (Access = private)
        ProjectedCRS_ (1, 1) projcrs = projcrs(8857)
        LatitudeLimits_ (1, 2) double = [-90 90]
        LongitudeLimits_ (1, 2) double = [-180 180]
        MapLayout_ (1, 1) string = "normal"
        ScalebarVisible_ (1, 1) string = "on"
    end
    methods
        function value = get.ProjectedCRS(comp)
            if comp.isMapAxesReady()
                value = comp.MapAxes.ProjectedCRS;
            else
                value = comp.ProjectedCRS_;
            end
        end

        function set.ProjectedCRS(comp, value)
            comp.ProjectedCRS_ = value;
            if comp.isMapAxesReady()
                comp.MapAxes.ProjectedCRS = value;
                comp.captureAxesState();
            end
        end

        function value = get.LatitudeLimits(comp)
            if comp.isMapAxesReady()
                [value, ~] = geolimits(comp.MapAxes);
            else
                value = comp.LatitudeLimits_;
            end
        end

        function set.LatitudeLimits(comp, value)
            value = comp.validateLimits(value, "LatitudeLimits");
            if any(value < -90 | value > 90)
                error("uimapaxes:InvalidLatitudeLimits", ...
                    "LatitudeLimits values must be in the range [-90, 90].");
            end

            comp.LatitudeLimits_ = value;
            comp.applyLimitsIfReady();
        end

        function value = get.LongitudeLimits(comp)
            if comp.isMapAxesReady()
                [~, value] = geolimits(comp.MapAxes);
            else
                value = comp.LongitudeLimits_;
            end
        end

        function set.LongitudeLimits(comp, value)
            comp.LongitudeLimits_ = comp.validateLimits( ...
                value, "LongitudeLimits");
            comp.applyLimitsIfReady();
        end

        function value = get.MapLayout(comp)
            if comp.isMapAxesReady()
                value = string(comp.MapAxes.MapLayout);
            else
                value = comp.MapLayout_;
            end
        end

        function set.MapLayout(comp, value)
            value = string(value);
            mustBeMember(value, ["normal" "maximized"]);
            comp.MapLayout_ = value;
            if comp.isMapAxesReady()
                comp.MapAxes.MapLayout = value;
            end
        end

        function value = get.ScalebarVisible(comp)
            if comp.isMapAxesReady()
                value = string(comp.MapAxes.Scalebar.Visible);
            else
                value = comp.ScalebarVisible_;
            end
        end

        function set.ScalebarVisible(comp, value)
            value = string(value);
            mustBeMember(value, ["on" "off"]);
            comp.ScalebarVisible_ = value;
            if comp.isMapAxesReady()
                comp.MapAxes.Scalebar.Visible = value;
            end
        end

        function mapAxes = newmap(comp, varargin)
            %NEWMAP Clear and reconfigure the wrapped map axes.
            %   NEWMAP(COMP) restores the default projected CRS.
            %   NEWMAP(COMP,PROJ) uses the specified PROJCRS object.
            comp.MapAxes = newmap(comp.MapAxes, varargin{:});
            comp.configureAxesPosition();
            comp.captureAxesState();
            mapAxes = comp.MapAxes;
        end

        function varargout = geoplot(comp, varargin)
            [varargout{1:nargout}] = geoplot( ...
                comp.MapAxes, varargin{:});
            comp.captureLimits();
        end

        function varargout = geoscatter(comp, varargin)
            [varargout{1:nargout}] = geoscatter( ...
                comp.MapAxes, varargin{:});
            comp.captureLimits();
        end

        function varargout = geolimits(comp, varargin)
            [varargout{1:nargout}] = geolimits( ...
                comp.MapAxes, varargin{:});
            comp.captureLimits();
        end

        function varargout = geotickformat(comp, varargin)
            [varargout{1:nargout}] = geotickformat( ...
                comp.MapAxes, varargin{:});
        end

        function varargout = title(comp, varargin)
            [varargout{1:nargout}] = title( ...
                comp.MapAxes, varargin{:});
        end

        function varargout = subtitle(comp, varargin)
            [varargout{1:nargout}] = subtitle( ...
                comp.MapAxes, varargin{:});
        end

        function varargout = legend(comp, varargin)
            [varargout{1:nargout}] = legend( ...
                comp.MapAxes, varargin{:});
        end

        function hold(comp, varargin)
            hold(comp.MapAxes, varargin{:});
        end

        function cla(comp, varargin)
            cla(comp.MapAxes, varargin{:});
        end

        function varargout = colormap(comp, varargin)
            [varargout{1:nargout}] = colormap( ...
                comp.MapAxes, varargin{:});
        end
    end
    methods (Access = private)
        function applyLimitsIfReady(comp)
            if comp.isMapAxesReady()
                geolimits(comp.MapAxes, ...
                    comp.LatitudeLimits_, comp.LongitudeLimits_);
                comp.captureLimits();
            end
        end

        function configureAxesPosition(comp)
            if comp.isMapAxesReady()
                comp.MapAxes.Units = "normalized";
                comp.MapAxes.OuterPosition = [0 0 1 1];
            end
        end

        function captureAxesState(comp)
            if ~comp.isMapAxesReady()
                return
            end

            comp.ProjectedCRS_ = comp.MapAxes.ProjectedCRS;
            comp.MapLayout_ = string(comp.MapAxes.MapLayout);
            comp.ScalebarVisible_ = ...
                string(comp.MapAxes.Scalebar.Visible);
            comp.captureLimits();
        end

        function captureLimits(comp)
            if ~comp.isMapAxesReady()
                return
            end

            [comp.LatitudeLimits_, comp.LongitudeLimits_] = ...
                geolimits(comp.MapAxes);
        end

        function tf = isMapAxesReady(comp)
            tf = ~isempty(comp.MapAxes) && isvalid(comp.MapAxes);
        end
    end
    methods (Static, Access = private)
        function value = validateLimits(value, argumentName)
            validateattributes(value, {'numeric'}, ...
                {'real', 'finite', 'increasing', 'size', [1 2]}, ...
                '', argumentName);
            value = double(value);
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.MapAxes = mapaxes(comp.Panel, ...
                ProjectedCRS = comp.ProjectedCRS_, ...
                Units = "normalized", ...
                OuterPosition = [0 0 1 1]);

            comp.MapAxes.MapLayout = comp.MapLayout_;
            comp.MapAxes.Scalebar.Visible = comp.ScalebarVisible_;
            geolimits(comp.MapAxes, ...
                comp.LatitudeLimits_, comp.LongitudeLimits_);
            comp.captureAxesState();  
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 ...
                    max(comp.Position(3), 1) ...
                    max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end

            comp.configureAxesPosition();
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