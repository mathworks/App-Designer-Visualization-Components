classdef componentPackTest < matlab.unittest.TestCase
    %COMPONENTPACKTEST Verifies component files and App Designer metadata.

    properties (TestParameter)
        ComponentName = struct( ...
            uigeoaxes="uigeoaxes", ...
            uimapaxes="uimapaxes", ...
            uiaxesm="uiaxesm", ...
            uipolaraxes="uipolaraxes", ...
            uiheatmap="uiheatmap", ...
            uiparallelplot="uiparallelplot", ...
            uistackedplot="uistackedplot", ...
            uiscatterhistogram="uiscatterhistogram", ...
            uismithplot="uismithplot", ...
            uiwordcloud="uiwordcloud", ...
            uibubblecloud="uibubblecloud", ...
            uigeobubble="uigeobubble", ...
            uiconfusionchart="uiconfusionchart", ...
            uisliceviewer="uisliceviewer", ...
            uiorthosliceviewer="uiorthosliceviewer", ...
            uivolshow="uivolshow", ...
            uipattern="uipattern")
    end

    properties (Constant, Access = private)
        ExpectedComponents = [
            "uigeoaxes"
            "uimapaxes"
            "uiaxesm"
            "uipolaraxes"
            "uiheatmap"
            "uiparallelplot"
            "uistackedplot"
            "uiscatterhistogram"
            "uismithplot"
            "uiwordcloud"
            "uibubblecloud"
            "uigeobubble"
            "uiconfusionchart"
            "uisliceviewer"
            "uiorthosliceviewer"
            "uivolshow"
            "uipattern"
        ]
    end

    properties (SetAccess = private)
        ProjectRoot (1, 1) string
    end

    methods (TestClassSetup)
        function setUpComponentPath(testCase)
            testCase.ProjectRoot = string( ...
                fileparts(fileparts(mfilename("fullpath"))));
            testCase.applyFixture( ...
                matlab.unittest.fixtures.PathFixture( ...
                testCase.ProjectRoot));
            setupPanelWrappedComponents;
        end
    end

    methods (Test)
        function testManifestMatchesExpectedInventory(testCase)
            metadata = componentPackTest.readMetadata( ...
                testCase.ProjectRoot);
            componentNames = string({metadata.components.className})';

            testCase.verifyEqual( ...
                sort(componentNames), ...
                sort(testCase.ExpectedComponents));
            testCase.verifyEqual( ...
                numel(unique(componentNames)), ...
                numel(componentNames));
        end

        function testComponentFileExists(testCase, ComponentName)
            componentFile = fullfile( ...
                testCase.ProjectRoot, ComponentName + ".mlapp");

            testCase.verifyTrue(isfile(componentFile));
        end

        function testStandaloneIconExistsAndIsReadable( ...
                testCase, ComponentName)
            [iconFile, iconCandidates] = ...
                componentPackTest.findStandaloneIcon( ...
                    testCase.ProjectRoot, ComponentName);

            testCase.assertNotEmpty( ...
                iconFile, ...
                "No standalone icon found. Expected one of: " + ...
                strjoin(iconCandidates, ", "));

            iconInfo = imfinfo(iconFile);
            testCase.verifyEqual( ...
                lower(string(iconInfo.Format)), "png");
            testCase.verifyGreaterThan(iconInfo.Width, 0);
            testCase.verifyGreaterThan(iconInfo.Height, 0);
        end

        function testComponentResolvesFromPack(testCase, ComponentName)
            componentFile = fullfile( ...
                testCase.ProjectRoot, ComponentName + ".mlapp");
            resolvedFile = string(which(ComponentName));

            testCase.verifyEqual( ...
                lower(resolvedFile), lower(componentFile));
        end

        function testAppDesignerRegistration(testCase, ComponentName)
            componentFile = fullfile( ...
                testCase.ProjectRoot, ComponentName + ".mlapp");
            model = appdesigner.internal.usercomponent.metadata.Model( ...
                char(componentFile));
            testCase.addTeardown(@() delete(model));
            componentMetadata = model.getComponentMetadata();

            testCase.verifyTrue(model.getModelValidity());
            testCase.verifyEqual( ...
                string(componentMetadata.status), "Registered");
        end

        function testPaletteMetadataIsComplete(testCase, ComponentName)
            metadata = componentPackTest.readMetadata( ...
                testCase.ProjectRoot);
            component = componentPackTest.findComponentMetadata( ...
                metadata, ComponentName);

            testCase.verifyTrue(startsWith( ...
                string(component.icon), ...
                "data:image/png;base64,"));
            testCase.verifyTrue(startsWith( ...
                string(component.avatar), ...
                "data:image/png;base64,"));
            testCase.verifyTrue(startsWith( ...
                string(component.avatarDark), ...
                "data:image/png;base64,"));
        end

        function testPaletteIconIsAppDesignerSize( ...
                testCase, ComponentName)
            metadata = componentPackTest.readMetadata( ...
                testCase.ProjectRoot);
            component = componentPackTest.findComponentMetadata( ...
                metadata, ComponentName);
            iconBytes = matlab.net.base64decode( ...
                extractAfter(string(component.icon), ","));
            iconBytes = iconBytes(:);

            testCase.assertGreaterThanOrEqual( ...
                numel(iconBytes), 24);
            testCase.verifyEqual( ...
                iconBytes(1:8), ...
                uint8([137, 80, 78, 71, 13, 10, 26, 10])');
            testCase.verifyEqual( ...
                string(char(iconBytes(13:16)')), "IHDR");

            byteWeights = [2^24; 2^16; 2^8; 1];
            iconSize = [
                double(iconBytes(17:20))' * byteWeights
                double(iconBytes(21:24))' * byteWeights
            ]';
            expectedSize = double( ...
                appdesigner.internal.usercomponent.metadata. ...
                Constants.ComponentLibIconSize);

            testCase.verifyEqual(iconSize, expectedSize);
        end

        function testPaletteIconMatchesStandaloneIcon( ...
                testCase, ComponentName)
            [iconFile, iconCandidates] = ...
                componentPackTest.findStandaloneIcon( ...
                    testCase.ProjectRoot, ComponentName);
            testCase.assertNotEmpty( ...
                iconFile, ...
                "No standalone icon found. Expected one of: " + ...
                strjoin(iconCandidates, ", "));

            [expectedIcon, ~, expectedAlpha] = imread(iconFile);
            paletteSize = ...
                appdesigner.internal.usercomponent.metadata. ...
                Constants.ComponentLibIconSize;
            expectedIcon = imresize(expectedIcon, paletteSize);
            if ~isempty(expectedAlpha)
                expectedAlpha = imresize(expectedAlpha, paletteSize);
            end

            metadata = componentPackTest.readMetadata( ...
                testCase.ProjectRoot);
            component = componentPackTest.findComponentMetadata( ...
                metadata, ComponentName);
            [actualIcon, actualAlpha] = ...
                componentPackTest.decodePaletteIcon( ...
                    component.icon);

            testCase.verifyEqual(actualIcon, expectedIcon);
            testCase.verifyEqual(actualAlpha, expectedAlpha);
        end

        function testComponentPassesCodeAnalyzer( ...
                testCase, ComponentName)
            componentFile = fullfile( ...
                testCase.ProjectRoot, ComponentName + ".mlapp");
            issues = checkcode(char(componentFile), "-id", "-struct");

            testCase.verifyEmpty(issues);
        end
    end

    methods (Test, TestTags = ["Integration", "Slow"])
        function testRuntimeConstruction(testCase, ComponentName)
            figureHandle = uifigure(Visible="off");
            testCase.addTeardown(@() delete(figureHandle));

            component = feval(ComponentName, figureHandle);
            drawnow;

            testCase.verifyEqual(string(class(component)), ComponentName);
            testCase.verifyEqual(component.Parent, figureHandle);
        end
    end

    methods (Static, Access = private)
        function metadata = readMetadata(projectRoot)
            metadataFile = fullfile( ...
                projectRoot, "resources", "appDesigner.json");
            metadata = jsondecode(fileread(metadataFile));
        end

        function component = findComponentMetadata( ...
                metadata, componentName)
            classNames = string({metadata.components.className});
            component = metadata.components(classNames == componentName);
        end

        function [iconFile, iconCandidates] = findStandaloneIcon( ...
                projectRoot, componentName)
            iconCandidates = [
                fullfile(projectRoot, ...
                    extractAfter(componentName, 2) + "_icon.png")
                fullfile(projectRoot, componentName + "_icon.png")
            ];
            iconFile = iconCandidates( ...
                find(isfile(iconCandidates), 1));
        end

        function [icon, alpha] = decodePaletteIcon(dataUri)
            iconBytes = matlab.net.base64decode( ...
                extractAfter(string(dataUri), ","));
            tempFile = string(tempname) + ".png";
            cleanup = onCleanup(@() delete(tempFile));

            fileId = fopen(tempFile, "w");
            fwrite(fileId, iconBytes, "uint8");
            fclose(fileId);
            [icon, ~, alpha] = imread(tempFile);
        end
    end
end
