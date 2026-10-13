classdef uiwordcloud_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uiwordcloud_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uiwordcloudDemoAppUIFigure      matlab.ui.Figure
        plotButton                      matlab.ui.control.Button
        uiwordcloud                     uiwordcloud
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            words = ["MATLAB" "App" "Designer" "Charts" "Data"];
            counts = [10 8 6 5 3];
            plot(app.uiwordcloud, words, counts);
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uiwordcloud_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end