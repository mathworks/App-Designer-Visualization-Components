classdef uigeoaxes_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uigeoaxes_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uigeoaxesDemoAppUIFigure        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        ControlsGridLayout              matlab.ui.container.GridLayout
        ResetViewButton                 matlab.ui.control.Button
        BasemapDropDown                 matlab.ui.control.DropDown
        BasemapLabel                    matlab.ui.control.Label
        uigeoaxes                       uigeoaxes
    end

    % Callbacks that handle component events
    methods

        % Code that executes after component creation
        function startupFcn(app)
            latitude = [47.6062 45.5152 37.7749 34.0522];
            longitude = [-122.3321 -122.6784 -122.4194 -118.2437];

            geoplot(app.uigeoaxes, latitude, longitude, '-o', ...
                'Color', [0.8500 0.3250 0.0980], ...
                'LineWidth', 2, ...
                'MarkerSize', 7, ...
                'MarkerFaceColor', [0.8500 0.3250 0.0980]);
            geobasemap(app.uigeoaxes, app.BasemapDropDown.Value);
            geolimits(app.uigeoaxes, [32 50], [-126 -116]);
            title(app.uigeoaxes, 'West Coast Route');
        end

        % Value changed function: BasemapDropDown
        function BasemapDropDownValueChanged(app, event)
            geobasemap(app.uigeoaxes, event.Value);
            geolimits(app.uigeoaxes, [32 50], [-126 -116]);
        end

        % Button pushed function: ResetViewButton
        function ResetViewButtonPushed(app, event)
            geolimits(app.uigeoaxes, [32 50], [-126 -116]);
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uigeoaxes_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end