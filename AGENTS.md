# PetNote Repository Guide

## Scope

These instructions apply to the entire repository. Keep changes focused on the requested task and preserve unrelated worktree changes.

## Project Overview

PetNote is a SwiftUI iOS application with a WidgetKit extension. The Xcode project is `mymx-oss.xcodeproj`; the main shared scheme is `mymx`, and building it also builds `PetWidgetExtension`.

- `mymx/Views/`: SwiftUI screens, grouped by feature.
- `mymx/ViewModel/`: UI state, networking, and feature coordination.
- `mymx/Model/`: Codable models and response types.
- `mymx/Data/`: static and mock data.
- `mymx/Resources/`: localization catalogs and bundled data.
- `mymx/Assets.xcassets/`: application images and colors.
- `PetWidget/`: WidgetKit extension sources and assets.
- `mymx-oss.xcodeproj/`: targets, build settings, and Swift Package Manager references.

The project uses Swift 6. The main app targets iOS 17.0 and the widget extension targets iOS 17.5. Alamofire, Nuke, and Mantis are resolved through Swift Package Manager. Open the `.xcodeproj`; there is no root workspace or CocoaPods setup.

## Build and Verification

Use a simulator build for normal validation. A generic destination avoids relying on a particular simulator model:

```sh
xcodebuild \
  -project mymx-oss.xcodeproj \
  -scheme mymx \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/PetNoteDerivedData \
  CODE_SIGNING_ALLOWED=NO \
  build
```

When XcodeBuildMCP is available, set the project to `mymx-oss.xcodeproj`, the scheme to `mymx`, and use an available iOS simulator. Build the `mymx` scheme rather than only the widget scheme so both targets are checked.

There are currently no unit-test or UI-test targets. Every code change must at least pass the full `mymx` Debug simulator build. Report new warnings or failures and do not claim success from a partial target build.

## Swift and SwiftUI Conventions

- Match the surrounding file's style and keep feature logic in the existing Views, ViewModel, and Model layers.
- Treat Swift 6 concurrency diagnostics as correctness errors. Keep observable UI state on `@MainActor`; do not mutate captured local variables from concurrent or `@Sendable` closures.
- Perform UI state updates on the main actor. Keep networking and decoding code asynchronous without blocking the main thread.
- Prefer small, targeted changes over broad rewrites. Preserve behavior, navigation, persistence keys, API payload shapes, and image ordering unless the task explicitly changes them.
- Reuse existing assets, colors, localization keys, models, and networking conventions before introducing new abstractions or dependencies.
- Add user-visible text to `mymx/Resources/Localizable.xcstrings` when localization is appropriate. Do not casually rename asset catalog entries or bundled resources.
- Never commit API secrets, tokens, signing certificates, provisioning profiles, or developer-specific settings. Keep Debug and Release entitlement files aligned when changing capabilities.

## Xcode Project Hygiene

- Add or remove source files through the Xcode project as needed and confirm target membership for both the app and widget.
- Do not edit or commit `xcuserdata`, `UserInterfaceState.xcuserstate`, DerivedData, or other machine-local Xcode state.
- Avoid reformatting `project.pbxproj` or unrelated Swift files. Swift Package version changes should be intentional and verified with a clean dependency resolution and build.
- Before handing off, review `git diff`, distinguish pre-existing changes from your own, and include the exact build command and result in the summary.
