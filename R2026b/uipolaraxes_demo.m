classdef uipolaraxes_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uipolaraxes_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uipolaraxesDemoAppUIFigure      matlab.ui.Figure
        PlotButton                      matlab.ui.control.Button
        uipolaraxes                     uipolaraxes
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            theta = 0:0.01:2*pi;
            rho = sin(2*theta).*cos(2*theta);
            polarplot(app.uipolaraxes,theta,rho)
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uipolaraxes_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end