classdef uimapaxes_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uimapaxes_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uimapeaxesDemoAppUIFigure       matlab.ui.Figure
        uimapaxes                       uimapaxes
        plotButton                      matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods

        % Code that executes after component creation
        function startupFcn(app)
             app.uimapaxes.ProjectedCRS = projcrs(26918);

             % Draw geographic context
             land = readgeotable("landareas.shp");
             geoplot(app.uimapaxes, land, ...
                 FaceColor=[0.85 0.90 0.80], ...
                 EdgeColor=[0.35 0.35 0.35]);

             hold(app.uimapaxes, "on")

             % Draw route
             latitude = [42.3601 41.8240 40.7128];
             longitude = [-71.0589 -71.4128 -74.0060];

             geoplot(app.uimapaxes, latitude, longitude, "-o", ...
                 Color=[0.85 0.20 0.10], ...
                 LineWidth=2, ...
                 MarkerFaceColor=[0.85 0.20 0.10]);

             hold(app.uimapaxes, "off")

             geolimits(app.uimapaxes, [40 43], [-75 -70]);
             title(app.uimapaxes, "Boston to New York");
        end

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            newmap(app.uimapaxes, projcrs(3857));

            % Draw geographic context
            land = readgeotable("landareas.shp");
            geoplot(app.uimapaxes, land, ...
                FaceColor=[0.85 0.90 0.80], ...
                EdgeColor=[0.35 0.35 0.35]);

            hold(app.uimapaxes, "on")

            % Add locations
            latitude = [42.3601 40.7128];
            longitude = [-71.0589 -74.0060];

            geoscatter(app.uimapaxes, ...
                latitude, longitude, 80, "filled", ...
                MarkerFaceColor=[0.85 0.20 0.10]);

            hold(app.uimapaxes, "off")


        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uimapaxes_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end