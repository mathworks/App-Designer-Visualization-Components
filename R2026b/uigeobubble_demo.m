classdef uigeobubble_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uigeobubble_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uigeobubbleDemoAppUIFigure      matlab.ui.Figure
        uigeobubble                     uigeobubble
        plotButton                      matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            tsunamis = readtable("tsunamis.xlsx");
            tsunamis.Cause = categorical(tsunamis.Cause);
            plot(app.uigeobubble,tsunamis,"Latitude","Longitude", ...
                SizeVariable="MaxHeight",ColorVariable="Cause")
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uigeobubble_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end