classdef uivolshow_demo < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        uivolshowDemoAppUIFigure  matlab.ui.Figure
        uivolshow                 uivolshow
        interactButton            matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: interactButton
        function interactButtonPushed(app, event)
            load("mri.mat", "D");
            V = squeeze(D);
            plot(app.uivolshow,V)
            % volshow(V)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create uivolshowDemoAppUIFigure and hide until all components are created
            app.uivolshowDemoAppUIFigure = uifigure('Visible', 'off');
            app.uivolshowDemoAppUIFigure.Position = [100.333333333333 100.333333333333 640 480];
            app.uivolshowDemoAppUIFigure.Name = 'uivolshow Demo App';

            % Create interactButton
            app.interactButton = uibutton(app.uivolshowDemoAppUIFigure, 'push');
            app.interactButton.ButtonPushedFcn = createCallbackFcn(app, @interactButtonPushed, true);
            app.interactButton.Position = [507 12 100 22];
            app.interactButton.Text = 'interact';

            % Create uivolshow
            app.uivolshow = uivolshow(app.uivolshowDemoAppUIFigure);
            app.uivolshow.Position = [13 47 594 415];

            % Show the figure after all components are created
            app.uivolshowDemoAppUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = uivolshow_demo

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.uivolshowDemoAppUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.uivolshowDemoAppUIFigure)
        end
    end
end