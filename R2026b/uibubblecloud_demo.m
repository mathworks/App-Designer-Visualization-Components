classdef uibubblecloud_demo < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './uibubblecloud_demo.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        uibubblecloudDemoAppUIFigure    matlab.ui.Figure
        uibubblecloud                   uibubblecloud
        plotButton                      matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            n = [58 115 81 252 180 124 40 80 50 20]';
            loc = ["NJ" "NY" "MA" "OH" "NH" "ME" "CT" "PA" "RI" "VT"]';
            plant = ["Plant A" "Plant A" "Plant A" "Plant A" ...
                "Plant A" "Plant A" "Plant A" "Plant B" "Plant B" "Plant B"]';
            tbl = table(n,loc,plant,'VariableNames',["Mislabeled" "State" "Manufacturing Plant"]);
            plot(app.uibubblecloud,tbl,"Mislabeled","State")
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = uibubblecloud_demo(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end