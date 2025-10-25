# YouTube Subtitle Generator

A desktop application built with Flutter to automatically generate and translate subtitle (SRT) files from YouTube videos. This tool streamlines the process of downloading a video, extracting its auto-captions, and translating them.

## Features

*   **Video Downloading**: Downloads the source video from YouTube.
*   **Subtitle Generation**: Extracts auto-caption data and converts it into a standard `.srt` file.
*   **Automatic Translation**: Uses the Google Gemini API to translate the generated subtitles into Japanese, creating a separate `_jp.srt` file.
*   **Simple UI**: A clean interface to paste a YouTube URL and start the process.
*   **Real-time Feedback**: Displays the current status of the process (e.g., downloading, transcribing, translating).

## Prerequisites

Before running the application, you need to have the following installed and configured on your system.

1.  **Flutter SDK**: Ensure the Flutter SDK is installed.
2.  **yt-dlp**: This application depends on `yt-dlp` to handle video and subtitle downloading.
    *   Install `yt-dlp` by following the instructions on the official repository.
    *   Make sure the `yt-dlp` executable is available in your system's `PATH`.
3.  **Gemini API Key**: The translation feature requires a Google Gemini API key.
    *   Obtain an API key from Google AI Studio.
    *   Set the key as an environment variable named `GEMINI_API_KEY`.

## How to Use

1.  Clone the repository:
    ```sh
    git clone https://github.com/your-username/youtube-srt-generator.git
    cd youtube-srt-generator
    ```
2.  Install dependencies:
    ```sh
    flutter pub get
    ```
3.  Run the application:
    ```sh
    flutter run -d windows
    ```
4.  Paste a YouTube video URL into the text field and click "Transcribe".
5.  The generated `.srt` and `_jp.srt` files will be saved in the specified output folder.
