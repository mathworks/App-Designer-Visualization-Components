classdef uiheatmap_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uiheatmap_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uiheatmapDemoAppUIFigure        matlab.ui.Figure
        plotButton                      matlab.ui.control.Button
        uiheatmap                       uiheatmap
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            load("patients.mat", "LastName", "Age", "Gender", ...
                "SelfAssessedHealthStatus", "Smoker", "Weight", "Location");
            tbl = table(LastName,Age,Gender,SelfAssessedHealthStatus, ...
                Smoker,Weight,Location);
            plot(app.uiheatmap,tbl,'Smoker','SelfAssessedHealthStatus');
            
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uiheatmap_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end