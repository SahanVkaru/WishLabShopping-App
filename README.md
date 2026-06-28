# WishShopLab - Mini E-Commerce App

A mini e-commerce Flutter application built as a practical task for the CyphLab Flutter Developer Intern position.

## Features

- **Splash & Login Screen**: Smooth animated splash screen leading to a clean login interface.
- **Home Screen**: Product listing with category filters and real-time search.
- **Product Detail Screen**: Detailed view with descriptions, ratings, and quantity controls.
- **Cart System**: Fully functional cart with add/remove/update capabilities.
- **Dark/Light Mode**: Full theme support with preferences saved locally.
- **Responsive & Animated**: Clean animations and responsive layout structure.

## Technical Details

- **Framework**: Flutter
- **State Management**: Provider (`provider`)
- **Data Persistence**: Local Storage (`shared_preferences`)
- **Images**: Cached Network Image (`cached_network_image`)
- **Animations**: Flutter Staggered Animations (`flutter_staggered_animations`)
- **Architecture**: MVVM-inspired with separate directories for models, providers, screens, widgets, and services.
- **Mock Data**: Products are loaded from a local JSON file (`assets/data/products.json`).

## Setup & Run Instructions

1. Ensure you have Flutter installed on your machine.
2. Clone this repository or open the project folder.
3. Fetch the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## AI Assistance Disclosure

This project was developed extensively with the assistance of **Antigravity (Google DeepMind)**, acting as an advanced pair-programming assistant. Additionally, **Gemini Veo** was used for asset generation.

While the AI generated the vast majority of the boilerplate and UI code, I acted as the Lead Developer to guide the architecture, define the UI/UX requirements, and orchestrate the development flow. Specifically, I directed the AI to:
- Set up the core folder structure (`screens`, `widgets`, `providers`, `models`).
- Implement robust state management using the `Provider` package (e.g., Cart and Order logic).
- Iterate on the UI to ensure a premium, modern feel (e.g., tweaking Lottie animations, fixing responsive layouts, adding staggered entrance animations, and matching color themes across the app).
- Debug device-specific rendering issues (such as case-sensitivity issues with asset paths on physical devices).

**Custom Animated Assets Workflow:**
For the animated splash screen logo, I used **Gemini Veo** to generate the initial video and then converted it into a lightweight JSON Lottie file using the [VizGPT Video-to-Lottie Converter](https://vizgpt.ai/tools/video-to-lottie-converter). This ensured high-performance, seamless rendering in Flutter.

By acting as the architect, I ensured the code remained clean, well-organized, and met all the technical requirements of the assessment.
