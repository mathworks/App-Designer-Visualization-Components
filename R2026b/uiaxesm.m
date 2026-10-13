classdef uiaxesm < matlab.ui.componentcontainer.ComponentContainer
    % Copyright 2026 The MathWorks, Inc.

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        Panel  matlab.ui.container.Panel
    end

    %UIAXESM Classic axesm-based map component for App Designer.
    %   UIAXESM wraps an axesm-based map in a panel-backed component. Use
    %   classic Mapping Toolbox functions such as PLOTM, GEOSHOW, SURFACEM,
    %   CONTOURM, GRIDM, and FRAMEM with the component as the first input.

    properties (Dependent)
        MapProjection (1, 1) string
        MapLatitudeLimits (1, 2) double
        MapLongitudeLimits (1, 2) double
        FrameVisible (1, 1) string
        GridVisible (1, 1) string
        MeridianLabelVisible (1, 1) string
        ParallelLabelVisible (1, 1) string
    end

    properties (SetAccess = private, Transient, NonCopyable)
        MapAxes matlab.graphics.axis.Axes = ...
            matlab.graphics.axis.Axes.empty
    end

    properties (Access = private)
        MapProjection_ (1, 1) string = "mercator"
        MapLatitudeLimits_ (1, 2) double = [-80 80]
        MapLongitudeLimits_ (1, 2) double = [-180 180]
        FrameVisible_ (1, 1) string = "on"
        GridVisible_ (1, 1) string = "on"
        MeridianLabelVisible_ (1, 1) string = "on"
        ParallelLabelVisible_ (1, 1) string = "on"
    end
    methods
        function value = get.MapProjection(comp)
            value = comp.MapProjection_;
        end

        function set.MapProjection(comp, value)
            value = string(value);
            validateattributes(value, {'string'}, {'scalar', 'nonempty'});
            comp.MapProjection_ = value;
            comp.rebuildMapIfReady();
        end

        function value = get.MapLatitudeLimits(comp)
            value = comp.MapLatitudeLimits_;
        end

        function set.MapLatitudeLimits(comp, value)
            value = comp.validateLimits(value, "MapLatitudeLimits");
            if any(value < -90 | value > 90)
                error("uiaxesm:InvalidMapLatitudeLimits", ...
                    "MapLatitudeLimits values must be in the range [-90, 90].");
            end
            comp.MapLatitudeLimits_ = value;
            comp.rebuildMapIfReady();
        end

        function value = get.MapLongitudeLimits(comp)
            value = comp.MapLongitudeLimits_;
        end

        function set.MapLongitudeLimits(comp, value)
            comp.MapLongitudeLimits_ = comp.validateLimits( ...
                value, "MapLongitudeLimits");
            comp.rebuildMapIfReady();
        end

        function value = get.FrameVisible(comp)
            value = comp.FrameVisible_;
        end

        function set.FrameVisible(comp, value)
            comp.FrameVisible_ = comp.validateOnOff(value);
            comp.applyMapPropertyIfReady("Frame", comp.FrameVisible_);
        end

        function value = get.GridVisible(comp)
            value = comp.GridVisible_;
        end

        function set.GridVisible(comp, value)
            comp.GridVisible_ = comp.validateOnOff(value);
            comp.applyMapPropertyIfReady("Grid", comp.GridVisible_);
        end

        function value = get.MeridianLabelVisible(comp)
            value = comp.MeridianLabelVisible_;
        end

        function set.MeridianLabelVisible(comp, value)
            comp.MeridianLabelVisible_ = comp.validateOnOff(value);
            comp.applyMapPropertyIfReady( ...
                "MeridianLabel", comp.MeridianLabelVisible_);
        end

        function value = get.ParallelLabelVisible(comp)
            value = comp.ParallelLabelVisible_;
        end

        function set.ParallelLabelVisible(comp, value)
            comp.ParallelLabelVisible_ = comp.validateOnOff(value);
            comp.applyMapPropertyIfReady( ...
                "ParallelLabel", comp.ParallelLabelVisible_);
        end

        function mapAxes = resetmap(comp, projection, varargin)
            %RESETMAP Clear the map and configure an axesm projection.
            %   RESETMAP(COMP,PROJECTION) creates a new axesm-based map.
            %   RESETMAP(COMP,PROJECTION,NAME,VALUE) also applies axesm
            %   name-value arguments.
            arguments
                comp
                projection (1, 1) string
            end
            arguments (Repeating)
                varargin
            end

            comp.MapProjection_ = projection;
            comp.createMapAxes(varargin{:});
            mapAxes = comp.MapAxes;
        end

        function varargout = plotm(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "plotm", varargin{:});
        end

        function varargout = plot3m(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "plot3m", varargin{:});
        end

        function varargout = scatterm(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "scatterm", varargin{:});
        end

        function varargout = geoshow(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "geoshow", varargin{:});
        end

        function varargout = mapshow(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "mapshow", varargin{:});
        end

        function varargout = surfacem(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "surfacem", varargin{:});
        end

        function varargout = meshm(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "meshm", varargin{:});
        end

        function varargout = contourm(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "contourm", varargin{:});
        end

        function varargout = contourfm(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "contourfm", varargin{:});
        end

        function varargout = patchm(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "patchm", varargin{:});
        end

        function varargout = fillm(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "fillm", varargin{:});
        end

        function varargout = textm(comp, varargin)
            [varargout{1:nargout}] = comp.invokeMapFunction( ...
                "textm", varargin{:});
        end

        function gridm(comp, varargin)
            comp.invokeMapFunction("gridm", varargin{:});
            comp.captureMapState();
        end

        function framem(comp, varargin)
            comp.invokeMapFunction("framem", varargin{:});
            comp.captureMapState();
        end

        function mlabel(comp, varargin)
            comp.invokeMapFunction("mlabel", varargin{:});
            comp.captureMapState();
        end

        function plabel(comp, varargin)
            comp.invokeMapFunction("plabel", varargin{:});
            comp.captureMapState();
        end

        function tightmap(comp, varargin)
            comp.invokeMapFunction("tightmap", varargin{:});
        end

        function setm(comp, varargin)
            comp.invokeMapFunction("setm", comp.MapAxes, varargin{:});
            comp.captureMapState();
        end

        function varargout = getm(comp, varargin)
            [varargout{1:nargout}] = getm(comp.MapAxes, varargin{:});
        end

        function clma(comp, varargin)
            comp.invokeMapFunction("clma", varargin{:});
        end

        function varargout = title(comp, varargin)
            [varargout{1:nargout}] = title(comp.MapAxes, varargin{:});
        end

        function varargout = legend(comp, varargin)
            [varargout{1:nargout}] = legend(comp.MapAxes, varargin{:});
        end

        function hold(comp, varargin)
            hold(comp.MapAxes, varargin{:});
        end

        function varargout = colormap(comp, varargin)
            [varargout{1:nargout}] = colormap(comp.MapAxes, varargin{:});
        end
    end

    methods (Access = private)
        function createMapAxes(comp, varargin)
            if comp.isMapAxesReady()
                delete(comp.MapAxes);
            end

            rootObject = groot;
            previousFigure = rootObject.CurrentFigure;
            sourceFigure = figure(Visible = "off");
            rootObject.CurrentFigure = sourceFigure;
            sourceCleanup = onCleanup(@() ...
                uiaxesm.restoreCurrentFigureAndDelete( ...
                sourceFigure, previousFigure));

            comp.MapAxes = axesm(comp.MapProjection_, ...
                "MapLatLimit", comp.MapLatitudeLimits_, ...
                "MapLonLimit", comp.MapLongitudeLimits_, ...
                "Frame", comp.FrameVisible_, ...
                "Grid", comp.GridVisible_, ...
                "MeridianLabel", comp.MeridianLabelVisible_, ...
                "ParallelLabel", comp.ParallelLabelVisible_, ...
                varargin{:});

            comp.MapAxes.Parent = comp.Panel;
            comp.configureAxesPosition();
            comp.captureMapState();
            clear sourceCleanup
        end

        function rebuildMapIfReady(comp)
            if ~isempty(comp.Panel) && isvalid(comp.Panel)
                comp.createMapAxes();
            end
        end

        function applyMapPropertyIfReady(comp, propertyName, value)
            if comp.isMapAxesReady()
                switch propertyName
                    case "Frame"
                        comp.invokeMapFunction("framem", value);
                    case "Grid"
                        comp.invokeMapFunction("gridm", value);
                    case "MeridianLabel"
                        comp.invokeMapFunction("mlabel", value);
                    case "ParallelLabel"
                        comp.invokeMapFunction("plabel", value);
                end
            end
        end

        function varargout = invokeMapFunction(comp, functionName, varargin)
            if ~comp.isMapAxesReady()
                error("uiaxesm:MapAxesUnavailable", ...
                    "The wrapped axesm-based map is not available.");
            end

            mapAxes = comp.MapAxes;
            originalParent = mapAxes.Parent;
            originalUnits = mapAxes.Units;
            originalOuterPosition = mapAxes.OuterPosition;
            rootObject = groot;
            previousFigure = rootObject.CurrentFigure;
            hostFigure = figure(Visible = "off");
            rootObject.CurrentFigure = hostFigure;
            restoreCleanup = onCleanup(@() uiaxesm.restoreHostedMapAxes( ...
                mapAxes, originalParent, originalUnits, ...
                originalOuterPosition, hostFigure, previousFigure));

            mapAxes.Parent = hostFigure;
            mapAxes.Units = "normalized";
            mapAxes.OuterPosition = [0 0 1 1];
            axes(mapAxes);

            [varargout{1:nargout}] = feval(functionName, varargin{:});
            clear restoreCleanup
        end

        function configureAxesPosition(comp)
            if comp.isMapAxesReady()
                comp.MapAxes.Units = "normalized";
                comp.MapAxes.OuterPosition = [0 0 1 1];
            end
        end

        function captureMapState(comp)
            if ~comp.isMapAxesReady()
                return
            end

            comp.MapProjection_ = string(getm( ...
                comp.MapAxes, "MapProjection"));
            comp.MapLatitudeLimits_ = double(getm( ...
                comp.MapAxes, "MapLatLimit"));
            comp.MapLongitudeLimits_ = double(getm( ...
                comp.MapAxes, "MapLonLimit"));
            comp.FrameVisible_ = string(getm(comp.MapAxes, "Frame"));
            comp.GridVisible_ = string(getm(comp.MapAxes, "Grid"));
            comp.MeridianLabelVisible_ = string(getm( ...
                comp.MapAxes, "MeridianLabel"));
            comp.ParallelLabelVisible_ = string(getm( ...
                comp.MapAxes, "ParallelLabel"));
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

        function value = validateOnOff(value)
            value = string(value);
            mustBeMember(value, ["on" "off"]);
        end

        function deleteIfValid(object)
            if ~isempty(object) && isvalid(object)
                delete(object);
            end
        end

        function restoreHostedMapAxes(mapAxes, parent, units, ...
                outerPosition, hostFigure, previousFigure)
            if ~isempty(mapAxes) && isvalid(mapAxes) && ...
                    ~isempty(parent) && isvalid(parent)
                mapAxes.Parent = parent;
                mapAxes.Units = units;
                mapAxes.OuterPosition = outerPosition;
                mapAxes.Units = "normalized";
                mapAxes.OuterPosition = [0 0 1 1];
            end
            uiaxesm.restoreCurrentFigureAndDelete( ...
                hostFigure, previousFigure);
        end

        function restoreCurrentFigureAndDelete(temporaryFigure, ...
                previousFigure)
            uiaxesm.deleteIfValid(temporaryFigure);
            rootObject = groot;
            if ~isempty(previousFigure) && isvalid(previousFigure)
                rootObject.CurrentFigure = previousFigure;
            else
                rootObject.CurrentFigure = [];
            end
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function postSetupFcn(comp)
            comp.createMapAxes();
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