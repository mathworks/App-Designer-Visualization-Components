classdef uiaxesm_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uiaxesm_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uiaxesmDemoAppUIFigure          matlab.ui.Figure
        plotButton                      matlab.ui.control.Button
        uiaxesm                         uiaxesm
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            % Configure an Albers equal-area projection
            resetmap(app.uiaxesm, "eqaconic", ...
                MapLatLimit=[24 50], ...
                MapLonLimit=[-125 -66], ...
                MapParallels=[29.5 45.5], ...
                Origin=[0 -96 0]);

            % Display U.S. states
            states = readgeotable("usastatelo.shp");
            geoshow(app.uiaxesm, states, ...
                FaceColor=[0.90 0.93 0.84], ...
                EdgeColor=[0.4 0.4 0.4]);

            % Plot and label a route
            hold(app.uiaxesm, "on")
            lat = [34.0522 41.8781 40.7128];
            lon = [-118.2437 -87.6298 -74.0060];

            plotm(app.uiaxesm, lat, lon, "-o", ...
                LineWidth=2.5, ...
                MarkerFaceColor=[0.85 0.325 0.098]);

            textm(app.uiaxesm, lat, lon, ...
                [" Los Angeles", " Chicago", " New York"]);

            % Map decorations
            gridm(app.uiaxesm, "on")
            framem(app.uiaxesm, "on")
            mlabel(app.uiaxesm, "on")
            plabel(app.uiaxesm, "on")
            tightmap(app.uiaxesm)
            title(app.uiaxesm, "Cross-Country Route")
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uiaxesm_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end