classdef uismithplot_demo < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        uismithplotDemoAppUIFigure  matlab.ui.Figure
        uismithplot                 uismithplot
        plotButton                  matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: plotButton
        function plotButtonPushed(app, event)
            % data = 0.5*exp(1i*linspace(0,pi,50));
            % plot(app.uismithplot, data);

            net = sparameters('default.s2p');
            plot(app.uismithplot, net, 1, 1);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create uismithplotDemoAppUIFigure and hide until all components are created
            app.uismithplotDemoAppUIFigure = uifigure('Visible', 'off');
            app.uismithplotDemoAppUIFigure.Position = [100 100 640 480];
            app.uismithplotDemoAppUIFigure.Name = 'uismithplot Demo App';

            % Create plotButton
            app.plotButton = uibutton(app.uismithplotDemoAppUIFigure, 'push');
            app.plotButton.ButtonPushedFcn = createCallbackFcn(app, @plotButtonPushed, true);
            app.plotButton.Position = [518 18 100 22];
            app.plotButton.Text = 'plot';

            % Create uismithplot
            app.uismithplot = uismithplot(app.uismithplotDemoAppUIFigure);
            app.uismithplot.Position = [15 53 603 414];

            % Show the figure after all components are created
            app.uismithplotDemoAppUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = uismithplot_demo

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.uismithplotDemoAppUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.uismithplotDemoAppUIFigure)
        end
    end
end