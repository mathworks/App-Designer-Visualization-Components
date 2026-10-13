classdef uiscatterhistogram_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uiscatterhistogram_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        plotButton                      matlab.ui.control.Button
        uiscatterhistogram              uiscatterhistogram
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            load("patients.mat", "Age", "Weight", "Gender");
            tbl = table(Age,Weight,Gender);
            plot(app.uiscatterhistogram, tbl, 'Age', 'Weight', ...
                'GroupVariable', 'Gender');
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uiscatterhistogram_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end