classdef setupPanelWrappedComponentsTest < matlab.unittest.TestCase
    %SETUPPANELWRAPPEDCOMPONENTSTEST Tests the public setup function.

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
        function findProjectRoot(testCase)
            testCase.ProjectRoot = string( ...
                fileparts(fileparts(mfilename("fullpath"))));
        end
    end

    methods (Test)
        function testReturnsEveryRegisteredComponent(testCase)
            componentNames = setupPanelWrappedComponents;

            testCase.verifyEqual( ...
                sort(componentNames), ...
                sort(testCase.ExpectedComponents));
        end

        function testAddsPathThatPersistsAfterChangingFolder(testCase)
            setupFunction = @setupPanelWrappedComponents;
            originalPath = path;
            testCase.addTeardown(@() path(originalPath));
            testCase.applyFixture( ...
                matlab.unittest.fixtures.WorkingFolderFixture);
            setupPanelWrappedComponentsTest.removePathEntry( ...
                testCase.ProjectRoot);

            componentNames = setupFunction();
            resolvedFile = string(which("uipattern"));

            testCase.verifyEqual(numel(componentNames), 17);
            testCase.verifyEqual( ...
                lower(resolvedFile), ...
                lower(fullfile( ...
                testCase.ProjectRoot, "uipattern.mlapp")));
        end

        function testMissingMetadataRaisesTargetedError(testCase)
            fixture = testCase.applyFixture( ...
                matlab.unittest.fixtures.WorkingFolderFixture);
            copyfile( ...
                fullfile(testCase.ProjectRoot, ...
                "setupPanelWrappedComponents.m"), ...
                fixture.Folder);

            testCase.verifyError( ...
                @() setupPanelWrappedComponentsTest.runSetupFrom( ...
                fixture.Folder), ...
                "PanelWrappedComponents:MissingMetadata");
        end

        function testMissingComponentsRaiseTargetedError(testCase)
            fixture = testCase.applyFixture( ...
                matlab.unittest.fixtures.WorkingFolderFixture);
            copyfile( ...
                fullfile(testCase.ProjectRoot, ...
                "setupPanelWrappedComponents.m"), ...
                fixture.Folder);
            mkdir(fullfile(fixture.Folder, "resources"));
            copyfile( ...
                fullfile(testCase.ProjectRoot, "resources", ...
                "appDesigner.json"), ...
                fullfile(fixture.Folder, "resources"));

            testCase.verifyError( ...
                @() setupPanelWrappedComponentsTest.runSetupFrom( ...
                fixture.Folder), ...
                "PanelWrappedComponents:MissingComponents");
        end

        function testSetupPassesCodeAnalyzer(testCase)
            issues = checkcode( ...
                fullfile(testCase.ProjectRoot, ...
                "setupPanelWrappedComponents.m"), ...
                "-id", "-struct");

            testCase.verifyEmpty(issues);
        end
    end

    methods (Static, Access = private)
        function removePathEntry(folder)
            pathEntries = string(strsplit(path, pathsep));
            while any(strcmpi(pathEntries, folder))
                rmpath(folder);
                pathEntries = string(strsplit(path, pathsep));
            end
        end

        function runSetupFrom(folder)
            originalPath = path;
            originalFolder = pwd;
            pathCleanup = onCleanup(@() path(originalPath));
            folderCleanup = onCleanup(@() cd(originalFolder));

            cd(folder);
            addpath(folder, "-begin");
            clear setupPanelWrappedComponents
            setupPanelWrappedComponents;
        end
    end
end
