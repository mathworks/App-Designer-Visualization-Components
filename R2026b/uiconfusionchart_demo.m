classdef uiconfusionchart_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uiconfusionchart_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        plotButton                      matlab.ui.control.Button
        uiconfusionchart                uiconfusionchart
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            load("fisheriris.mat", "meas", "species");
            X = meas;
            Y = species;
         
            Mdl = fitcknn(X,Y,'NumNeighbors',5,'Standardize',1);
            predictedY = resubPredict(Mdl);
            plot(app.uiconfusionchart,Y,predictedY);
            
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uiconfusionchart_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end