classdef uigeoaxes < matlab.ui.componentcontainer.ComponentContainer

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    properties (Dependent)
        Basemap (1, 1) string
        LatitudeLimits (1, 2) double
        LongitudeLimits (1, 2) double
        MapCenter (1, 2) double
        ZoomLevel (1, 1) double
    end

    properties (SetAccess = private, Transient, NonCopyable)
        GeoAxes matlab.graphics.axis.GeographicAxes = matlab.graphics.axis.GeographicAxes.empty
    end

    properties (Access = private)
        Basemap_ (1, 1) string = "streets-light"
        LatitudeLimits_ (1, 2) double = [-90 90]
        LongitudeLimits_ (1, 2) double = [-180 180]
        MapCenter_ (1, 2) double = [0 0]
        ZoomLevel_ (1, 1) double = NaN
    end

    methods
        function value = get.Basemap(comp)
            if comp.isGeoAxesReady()
                value = string(comp.GeoAxes.Basemap);
            else
                value = comp.Basemap_;
            end
        end

        function set.Basemap(comp, value)
            comp.Basemap_ = string(value);
            if comp.isGeoAxesReady()
                geobasemap(comp.GeoAxes, comp.Basemap_);
            end
        end

        function value = get.LatitudeLimits(comp)
            if comp.isGeoAxesReady()
                value = comp.GeoAxes.LatitudeLimits;
            else
                value = comp.LatitudeLimits_;
            end
        end

        function set.LatitudeLimits(comp, value)
            comp.LatitudeLimits_ = comp.validateLimits(value, "LatitudeLimits");
            comp.applyLimitsIfReady();
        end

        function value = get.LongitudeLimits(comp)
            if comp.isGeoAxesReady()
                value = comp.GeoAxes.LongitudeLimits;
            else
                value = comp.LongitudeLimits_;
            end
        end

        function set.LongitudeLimits(comp, value)
            comp.LongitudeLimits_ = comp.validateLimits(value, "LongitudeLimits");
            comp.applyLimitsIfReady();
        end

        function value = get.MapCenter(comp)
            if comp.isGeoAxesReady()
                value = comp.GeoAxes.MapCenter;
            else
                value = comp.MapCenter_;
            end
        end

        function set.MapCenter(comp, value)
            validateattributes(value, {'numeric'}, {'real', 'finite', 'size', [1 2]}, '', 'MapCenter');
            comp.MapCenter_ = double(value);
            if comp.isGeoAxesReady()
                comp.GeoAxes.MapCenter = comp.MapCenter_;
                comp.captureViewState();
            end
        end

        function value = get.ZoomLevel(comp)
            if comp.isGeoAxesReady()
                value = comp.GeoAxes.ZoomLevel;
            else
                value = comp.ZoomLevel_;
            end
        end

        function set.ZoomLevel(comp, value)
            validateattributes(value, {'numeric'}, {'real', 'scalar', 'finite', 'positive'}, '', 'ZoomLevel');
            comp.ZoomLevel_ = double(value);
            if comp.isGeoAxesReady()
                comp.GeoAxes.ZoomLevel = comp.ZoomLevel_;
                comp.captureViewState();
            end
        end

        function varargout = geoplot(comp, varargin)
            [varargout{1:nargout}] = geoplot(comp.GeoAxes, varargin{:});
        end

        function varargout = geoscatter(comp, varargin)
            [varargout{1:nargout}] = geoscatter(comp.GeoAxes, varargin{:});
        end

        function varargout = geobubble(comp, varargin)
            [varargout{1:nargout}] = geobubble(comp.GeoAxes, varargin{:});
        end

        function varargout = geodensityplot(comp, varargin)
            [varargout{1:nargout}] = geodensityplot(comp.GeoAxes, varargin{:});
        end

        function varargout = geolimits(comp, varargin)
            [varargout{1:nargout}] = geolimits(comp.GeoAxes, varargin{:});
            comp.captureViewState();
        end

        function geobasemap(comp, basemapName)
            geobasemap(comp.GeoAxes, basemapName);
            comp.Basemap_ = string(comp.GeoAxes.Basemap);
        end

        function hold(comp, varargin)
            hold(comp.GeoAxes, varargin{:});
        end

        function cla(comp, varargin)
            cla(comp.GeoAxes, varargin{:});
        end

        function varargout = title(comp, varargin)
            [varargout{1:nargout}] = title(comp.GeoAxes, varargin{:});
        end

        function varargout = subtitle(comp, varargin)
            [varargout{1:nargout}] = subtitle(comp.GeoAxes, varargin{:});
        end

        function varargout = xlabel(comp, varargin)
            [varargout{1:nargout}] = xlabel(comp.GeoAxes, varargin{:});
        end

        function varargout = ylabel(comp, varargin)
            [varargout{1:nargout}] = ylabel(comp.GeoAxes, varargin{:});
        end
    end


    methods (Access = private)
        function applyLimitsIfReady(comp)
            if comp.isGeoAxesReady()
                geolimits(comp.GeoAxes, comp.LatitudeLimits_, comp.LongitudeLimits_);
                comp.captureViewState();
            end
        end

        function syncViewToAxes(comp)
            if ~comp.isGeoAxesReady()
                return
            end

            geolimits(comp.GeoAxes, comp.LatitudeLimits_, comp.LongitudeLimits_);
            comp.GeoAxes.MapCenter = comp.MapCenter_;

            if isfinite(comp.ZoomLevel_)
                comp.GeoAxes.ZoomLevel = comp.ZoomLevel_;
            end

            comp.captureViewState();
        end

        function captureViewState(comp)
            if ~comp.isGeoAxesReady()
                return
            end

            comp.Basemap_ = string(comp.GeoAxes.Basemap);
            comp.LatitudeLimits_ = comp.GeoAxes.LatitudeLimits;
            comp.LongitudeLimits_ = comp.GeoAxes.LongitudeLimits;
            comp.MapCenter_ = comp.GeoAxes.MapCenter;
            comp.ZoomLevel_ = comp.GeoAxes.ZoomLevel;
        end

        function tf = isGeoAxesReady(comp)
            tf = ~isempty(comp.GeoAxes) && isvalid(comp.GeoAxes);
        end
    end

    methods (Static, Access = private)
        function value = validateLimits(value, argumentName)
            validateattributes(value, {'numeric'}, {'real', 'finite', 'increasing', 'size', [1 2]}, '', argumentName);
            value = double(value);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.GeoAxes = geoaxes(comp.Panel);

            comp.syncViewToAxes();
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a property is changed
        function update(comp)
            % Use this function to update the underlying components
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.Panel.Position = [1 1 max(comp.Position(3), 1) max(comp.Position(4), 1)];
                comp.Panel.BackgroundColor = comp.BackgroundColor;
            end

            if comp.isGeoAxesReady()
                comp.GeoAxes.Units = "normalized";
                comp.GeoAxes.Position = [0 0 1 1];
                geobasemap(comp.GeoAxes, comp.Basemap_);
                comp.syncViewToAxes();
            end
        end

        % Create the underlying components
        function setup(comp)

            comp.Position = [1 1 320 240];
            comp.BackgroundColor = [1 1 1];

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