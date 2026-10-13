classdef uiparallelplot_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uiparallelplot_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uiparallelplotDemoAppUIFigure   matlab.ui.Figure
        uiparallelplot                  uiparallelplot
        plotButton                      matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            load("patients.mat", "Age", "Height", "Weight", ...
                "Systolic", "Diastolic", "Smoker");
            tbl = table(Age,Height,Weight,Systolic,Diastolic,Smoker);
            plot(app.uiparallelplot,tbl, ...
                'CoordinateVariables',{'Age','Height','Weight'}, ...
                'GroupVariable','Smoker');
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uiparallelplot_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end