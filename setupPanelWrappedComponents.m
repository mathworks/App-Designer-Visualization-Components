function componentNames = setupPanelWrappedComponents()
%SETUPPANELWRAPPEDCOMPONENTS Set up the visualization component pack.
%   SETUPPANELWRAPPEDCOMPONENTS validates the App Designer metadata and
%   component files, adds the component folder to the MATLAB path, and
%   verifies that every registered component resolves from that folder.
%
%   COMPONENTNAMES = SETUPPANELWRAPPEDCOMPONENTS also returns the names of
%   all registered components as a column string array.
%
%   Syntax:
%       setupPanelWrappedComponents
%       componentNames = setupPanelWrappedComponents
%
%   See also APPDESIGNER.CUSTOMCOMPONENT.CONFIGUREMETADATA, ADDPATH, REHASH
%
%   Copyright 2026 The MathWorks, Inc.

fprintf("Checking files...\n");
rootDir = fileparts(mfilename("fullpath"));
metadataFile = fullfile(rootDir, "resources", "appDesigner.json");

if ~isfile(metadataFile)
    error("PanelWrappedComponents:MissingMetadata", ...
        "App Designer metadata is missing: %s", metadataFile);
end

try
    metadata = jsondecode(fileread(metadataFile));
catch cause
    exception = MException( ...
        "PanelWrappedComponents:InvalidMetadata", ...
        "App Designer metadata could not be read: %s", metadataFile);
    exception = addCause(exception, cause);
    throwAsCaller(exception);
end

requiredFields = ["className", "componentName", "icon"];
if ~isstruct(metadata) || ~isfield(metadata, "components") || ...
        ~isstruct(metadata.components) || isempty(metadata.components) || ...
        ~all(isfield(metadata.components, requiredFields))
    error("PanelWrappedComponents:InvalidMetadata", ...
        "App Designer metadata does not contain valid component entries.");
end

componentEntries = metadata.components;
classNames = string({componentEntries.className})';
displayNames = string({componentEntries.componentName})';
paletteIcons = string({componentEntries.icon})';

if any(strlength(classNames) == 0) || ...
        numel(unique(classNames)) ~= numel(classNames) || ...
        ~isequal(classNames, displayNames)
    error("PanelWrappedComponents:InvalidMetadata", ...
        "App Designer component names must be nonempty, unique, and match their class names.");
end

componentsWithoutPaletteIcons = classNames( ...
    strlength(paletteIcons) == 0 | ...
    ~startsWith(paletteIcons, "data:image/png;base64,"));
if ~isempty(componentsWithoutPaletteIcons)
    error("PanelWrappedComponents:MissingPaletteIcons", ...
        "App Designer palette icons are missing for: %s", ...
        strjoin(componentsWithoutPaletteIcons, ", "));
end

componentFiles = fullfile(rootDir, classNames + ".mlapp");
missingFiles = classNames(~isfile(componentFiles));
if ~isempty(missingFiles)
    error("PanelWrappedComponents:MissingComponents", ...
        "The component pack is incomplete. Missing: %s", ...
        strjoin(missingFiles, ", "));
end

filesOnDisk = dir(fullfile(rootDir, "ui*.mlapp"));
fileNamesOnDisk = string({filesOnDisk.name})';
fileNamesOnDisk = fileNamesOnDisk(~endsWith(fileNamesOnDisk, "_demo.mlapp"));
classesOnDisk = erase(fileNamesOnDisk, ".mlapp");
unregisteredComponents = setdiff(classesOnDisk, classNames, "stable");
if ~isempty(unregisteredComponents)
    error("PanelWrappedComponents:UnregisteredComponents", ...
        "These component files are not registered with App Designer: %s", ...
        strjoin(unregisteredComponents, ", "));
end

addpath(rootDir);
rehash toolboxcache;

resolvedFiles = arrayfun(@(name) string(which(name)), classNames);
unresolvedComponents = classNames(strlength(resolvedFiles) == 0);
if ~isempty(unresolvedComponents)
    error("PanelWrappedComponents:SetupFailed", ...
        "MATLAB could not resolve these components: %s", ...
        strjoin(unresolvedComponents, ", "));
end

unexpectedResolutions = classNames( ...
    ~strcmpi(resolvedFiles, componentFiles));
if ~isempty(unexpectedResolutions)
    error("PanelWrappedComponents:SetupFailed", ...
        "These component names resolve outside the component pack: %s", ...
        strjoin(unexpectedResolutions, ", "));
end

componentNames = classNames;

fprintf("Set up %d App Designer visualization components from:\n%s\n", ...
    numel(componentNames), rootDir);
fprintf("Restart App Designer if it is already open so that the ");
fprintf("Component Library refreshes.\n");
end
