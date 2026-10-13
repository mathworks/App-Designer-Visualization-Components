classdef uipattern_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uipattern_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uipatternDemoAppUIFigure        matlab.ui.Figure
        plotButton                      matlab.ui.control.Button
        uipattern                       uipattern
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            ant = design(cavity, 1e9);
            plot(app.uipattern, ant, 1e9, ...
                Type="directivity")
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uipattern_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end