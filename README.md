# NoteFlow — Offline Notes

NoteFlow is a Flutter notes app designed for a simple, calm, offline-first experience. This repository is a temporary development workspace.

## Current features

- Create, edit, search, pin, categorize, and delete notes.
- Local persistence with SharedPreferences; no account or custom server is required.
- Light and dark themes.
- Category browser and pinned-notes view.
- Demo mode seeds example notes for screenshots.
- GitHub Actions runs formatting, static analysis, widget tests, then builds an Android APK and a web preview.

## Get the screenshot/demo APK

1. Open the repository's Actions tab.
2. Open the latest successful "Build NoteFlow demo" run.
3. Download the artifact named "NoteFlow-Android-Demo-APK".
4. Extract the ZIP and install app-release.apk on an Android device.

The workflow also uploads a web build as "NoteFlow-Web-Demo". GitHub stores these artifacts for 14 days.

## Build details

The GitHub Actions workflow creates a fresh Flutter Android/web platform scaffold, then overlays the checked-in Flutter source. This keeps the repository focused on the app source while still producing a real installable APK. The release APK is currently a demo build (DEMO_MODE=true) with sample notes for product screenshots.

## Important status

The build is not confirmed until the latest GitHub Actions run finishes successfully. Check the Actions tab for the actual test and build result. The demo APK is for preview/testing, not yet a Play Store or commercial release.

This public repository is temporary, as requested. Do not place credentials, private customer data, or secrets here. Anyone can read public source while the repository is public.
