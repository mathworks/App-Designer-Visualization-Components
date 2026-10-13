classdef uisliceviewer_demo < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        uisliceviewerDemoAppUIFigure  matlab.ui.Figure
        uisliceviewer                 uisliceviewer
        ChangeButton                  matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ChangeButton
        function ChangeButtonPushed(app, event)
            load("mri.mat", "D");
            V = squeeze(D);

            plot(app.uisliceviewer, V);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create uisliceviewerDemoAppUIFigure and hide until all components are created
            app.uisliceviewerDemoAppUIFigure = uifigure('Visible', 'off');
            app.uisliceviewerDemoAppUIFigure.Position = [100 100 640 480];
            app.uisliceviewerDemoAppUIFigure.Name = 'uisliceviewer Demo App';

            % Create ChangeButton
            app.ChangeButton = uibutton(app.uisliceviewerDemoAppUIFigure, 'push');
            app.ChangeButton.ButtonPushedFcn = createCallbackFcn(app, @ChangeButtonPushed, true);
            app.ChangeButton.Position = [510 26 100 22];
            app.ChangeButton.Text = 'Change';

            % Create uisliceviewer
            app.uisliceviewer = uisliceviewer(app.uisliceviewerDemoAppUIFigure);
            app.uisliceviewer.Position = [1 62 609 419];

            % Show the figure after all components are created
            app.uisliceviewerDemoAppUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = uisliceviewer_demo

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.uisliceviewerDemoAppUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.uisliceviewerDemoAppUIFigure)
        end
    end
end