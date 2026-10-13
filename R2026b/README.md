# Visualization Components for MATLAB R2026b

This folder contains text versions exported from the repository's App
Designer files using MATLAB R2026b. The original `.mlapp` files remain in the
parent folder for supported earlier releases and visual component design.

## Setup

Use MATLAB R2026b or newer with the products listed in the
[component reference](../README.md#included-components). Set this folder as
MATLAB's Current Folder, then run:

```matlab
addpath(pwd)
componentNames = setupPanelWrappedComponents;
uipolaraxes_demo
```

Restart App Designer to refresh its Component Library. This folder's setup
function checks the exported `.m` components against its local metadata.

Run [doc/GettingStarted.m](doc/GettingStarted.m) for a programmatic example:

```matlab
run("doc/GettingStarted.m")
```

The [main README](../README.md) describes all components and their APIs.

## Editing and File Layout

- The 17 component `.m` files are code-only classes. Edit them in the MATLAB
  Editor; use the original component `.mlapp` files for visual design.
- Twelve demo apps have a companion `.xml` file containing their App Designer
  layout. Both files are needed to run the app or edit it visually. Keep the
  pair together when moving or sharing an app. Open the demo `.m` file in
  App Designer for visual editing.
- Four demos are complete conventional MATLAB class exports, with their UI
  creation code included in the `.m` file. They do not need XML. Run them by
  name and edit their code in the MATLAB Editor. Use the original `.mlapp`
  files for visual editing:

  | MATLAB class export | Original App Designer file |
  | --- | --- |
  | [uiorthosliceviewer_demo.m](uiorthosliceviewer_demo.m) | [uiorthosliceviewer_demo.mlapp](../uiorthosliceviewer_demo.mlapp) |
  | [uisliceviewer_demo.m](uisliceviewer_demo.m) | [uisliceviewer_demo.mlapp](../uisliceviewer_demo.mlapp) |
  | [uismithplot_demo.m](uismithplot_demo.m) | [uismithplot_demo.mlapp](../uismithplot_demo.mlapp) |
  | [uivolshow_demo.m](uivolshow_demo.m) | [uivolshow_demo.mlapp](../uivolshow_demo.mlapp) |

  R2026b App Designer did not finish opening these four demos for native
  format conversion. Their complete class code was exported using R2026b
  instead.
- Keep `resources/` beside the component classes so App Designer can find
  the component names, categories, and embedded palette icons.
- MATLAB supplies the example data used by the demos, including `mri.mat`,
  `patients.mat`, `fisheriris.mat`, and `tsunamis.xlsx`.

Choose one version per MATLAB session. Restart MATLAB before switching
between this folder and the originals. Avoid `addpath(genpath(...))`, and
do not leave the original repository folder as the Current Folder when using
the text versions; the Current Folder takes precedence over the path.

These files are separate copies. Edits to a text version do not update its
original `.mlapp`. Regenerate exports after changing the original design,
then review any intentional changes to the text version.

The parent `package.ignore` excludes this folder from legacy packaging.
Distribute this folder separately when packaging the R2026b versions.

The repository [license](license.txt) applies to these copies.
