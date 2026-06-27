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

This project was developed with the assistance of **Antigravity (Claude/Gemini models)**. The AI assisted with:
- Bootstrapping the Flutter project architecture and folder structure.
- Writing boilerplate code for the UI components (cards, tiles, screens).
- Setting up the Provider state management for products, cart, and theme.
- Generating the mock JSON data.

*Note: All generated code was thoroughly reviewed, properly organized, and tested to ensure it meets the requirements of a production-quality application.*
