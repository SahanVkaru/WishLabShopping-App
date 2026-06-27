# Mini E-Commerce Flutter App — Implementation Plan

## Overview

Build a polished, production-quality Flutter mini e-commerce app using **local/mock data** with a clean architecture, modern UI, and all bonus features. The app targets the CyphLab Flutter Developer Intern practical assessment.

---

## Tech Stack & Key Decisions

| Concern | Choice | Rationale |
|---|---|---|
| **State Management** | **Provider** | Lightweight, official recommendation, easy to understand and explain |
| **Navigation** | Named routes via `MaterialApp.routes` | Simple, readable, sufficient for 5 screens |
| **Local Storage** | `shared_preferences` | Persist cart & dark mode preference across sessions |
| **Mock Data** | Local JSON asset (`assets/data/products.json`) | Meets the "local JSON file" requirement explicitly |
| **Theming** | Custom light + dark themes with `ThemeData` | Bonus: dark mode toggle |
| **Animations** | Hero animations, `AnimatedContainer`, page transitions | Bonus: clean animations |

---

## App Architecture & Folder Structure

```
lib/
├── main.dart                      # App entry, theme, routes, providers
├── constants/
│   ├── app_colors.dart            # Color palette (light & dark)
│   ├── app_strings.dart           # Static strings
│   └── app_styles.dart            # Text styles, padding, border radius
├── models/
│   ├── product.dart               # Product data model (fromJson)
│   ├── cart_item.dart             # CartItem (product + quantity)
│   └── category.dart              # Category enum/model
├── providers/
│   ├── product_provider.dart      # Load products, search, filter
│   ├── cart_provider.dart         # Cart CRUD, total calculation
│   └── theme_provider.dart        # Dark/light mode toggle
├── screens/
│   ├── splash_screen.dart         # Animated splash → login
│   ├── login_screen.dart          # Mock login with validation
│   ├── home_screen.dart           # Product grid + search + category filter
│   ├── product_detail_screen.dart # Full product details + add to cart
│   ├── cart_screen.dart           # Cart items + qty controls + total
│   └── profile_screen.dart        # Mock profile + order history
├── widgets/
│   ├── product_card.dart          # Reusable product grid tile
│   ├── cart_item_tile.dart        # Single cart row with qty controls
│   ├── category_chip.dart         # Filterable category chip
│   ├── rating_stars.dart          # Star rating display
│   ├── search_bar.dart            # Custom search bar widget
│   ├── custom_bottom_nav.dart     # Bottom navigation bar
│   └── empty_state.dart           # Empty cart / no results widget
├── services/
│   └── product_service.dart       # Load & parse JSON from assets
└── utils/
    ├── formatters.dart            # Currency formatter, etc.
    └── routes.dart                # Route names & generator
assets/
├── data/
│   └── products.json              # 15-20 mock products with categories
└── images/
    └── logo.png                   # App logo for splash
```

---

## Screen-by-Screen Design

### 1. Splash Screen
- Animated logo (scale + fade in) centered on a gradient background
- Auto-navigates to Login Screen after ~2.5 seconds
- Uses `AnimationController` for smooth entrance

### 2. Login Screen (Mock)
- Clean card-based form with email and password fields
- Basic client-side validation (non-empty, email format)
- "Login" button navigates to Home Screen (no real auth)
- Subtle gradient background, rounded input fields
- Option to toggle password visibility

### 3. Home Screen (Product Listing)
- **AppBar**: App name, dark mode toggle icon, cart icon with badge (item count)
- **Search Bar**: Filters products by name in real-time
- **Category Chips**: Horizontal scrollable row (All, Electronics, Clothing, Accessories, Footwear, etc.)
- **Product Grid**: 2-column `GridView` with `ProductCard` widgets
  - Each card: product image, name, price (LKR formatted), rating stars
  - `Hero` animation on image for smooth transition to detail screen
  - Tap navigates to Product Detail Screen
- **Bottom Navigation**: Home, Cart, Profile (3 tabs)

### 4. Product Detail Screen
- **Hero image** at top (large, with gradient overlay for text readability)
- Product name, category badge, price, rating with review count
- Full description text
- Quantity selector (+ / −) before adding to cart
- **"Add to Cart"** button (full-width, animated feedback via `SnackBar`)
- Back button in AppBar

### 5. Cart Screen
- List of `CartItemTile` widgets, each showing:
  - Product image (small thumbnail)
  - Name, unit price
  - Quantity controls (−, qty, +)
  - Remove button (swipe-to-dismiss with `Dismissible`)
- **Order Summary** section at bottom:
  - Subtotal, item count
  - "Checkout" button (shows a mock success dialog)
- Empty cart state with illustration and "Continue Shopping" CTA
- Persisted via `shared_preferences` (JSON-encoded cart)

### 6. Profile / Orders Screen
- Profile header: avatar, name, email (mock data)
- "Order History" section with 2-3 static mock orders
  - Each order: order ID, date, total, status badge (Delivered/Processing)
- Settings section: dark mode toggle switch
- "Logout" button → navigates back to Login Screen

---

## Mock Data Design

`products.json` will contain **16 products** across **4 categories**:

| Category | Products (4 each) |
|---|---|
| Electronics | Wireless Earbuds, Smart Watch, Portable Speaker, Phone Case |
| Clothing | Casual T-Shirt, Denim Jacket, Summer Dress, Hoodie |
| Accessories | Leather Wallet, Sunglasses, Backpack, Wrist Watch |
| Footwear | Running Shoes, Casual Sneakers, Sandals, Boots |

Each product object:
```json
{
  "id": "1",
  "name": "Wireless Earbuds",
  "category": "Electronics",
  "price": 4500.00,
  "rating": 4.5,
  "reviewCount": 128,
  "description": "High-quality wireless earbuds with noise cancellation...",
  "image": "https://picsum.photos/seed/earbuds/400/400"
}
```

> [!NOTE]
> Images will use `picsum.photos` seeded URLs for consistent, royalty-free placeholder images. This avoids bundling large image assets and works offline-like since the seeds are deterministic.

---

## Bonus Features Checklist

| Feature | Approach |
|---|---|
| ✅ Product Search | Real-time text search in `ProductProvider` |
| ✅ Category Filter | Chip-based filter with "All" default |
| ✅ Dark Mode | `ThemeProvider` with `shared_preferences` persistence |
| ✅ Local Storage | Cart and theme preference persisted via `shared_preferences` |
| ✅ Clean Animations | Hero transitions, animated cart badge, page transitions, shimmer loading |
| ✅ Responsive Design | `LayoutBuilder` / `MediaQuery` for adaptive grid columns |
| ✅ Clean Git History | Atomic commits per feature/screen |

---

## Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  shared_preferences: ^2.3.4
  cached_network_image: ^3.4.1    # Image loading with placeholder/error
  google_fonts: ^6.2.1             # Modern typography (Inter/Poppins)
  flutter_staggered_animations: ^1.1.1  # Grid entry animations
  intl: ^0.19.0                    # Currency formatting

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## Proposed Changes

### Phase 1 — Project Scaffold & Core

#### [NEW] Flutter project initialization
- Run `flutter create` with proper org name
- Configure `pubspec.yaml` with all dependencies
- Set up asset declarations

#### [NEW] [app_colors.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/constants/app_colors.dart)
- Define primary, secondary, surface, background colors for light/dark

#### [NEW] [app_styles.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/constants/app_styles.dart)
- Text styles, padding constants, border radius values

#### [NEW] [routes.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/utils/routes.dart)
- Named route constants and route generator

---

### Phase 2 — Models & Data

#### [NEW] [product.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/models/product.dart)
- `Product` class with `fromJson` / `toJson`

#### [NEW] [cart_item.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/models/cart_item.dart)
- `CartItem` wrapping `Product` + `quantity`

#### [NEW] [products.json](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/assets/data/products.json)
- 16 products across 4 categories

#### [NEW] [product_service.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/services/product_service.dart)
- Load and parse JSON from assets

---

### Phase 3 — State Management (Providers)

#### [NEW] [product_provider.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/providers/product_provider.dart)
- Products list, search query, selected category, filtered results

#### [NEW] [cart_provider.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/providers/cart_provider.dart)
- Add/remove/update cart items, total price, persist to `shared_preferences`

#### [NEW] [theme_provider.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/providers/theme_provider.dart)
- Dark mode toggle, persist preference

---

### Phase 4 — Reusable Widgets

#### [NEW] All widgets in `lib/widgets/`
- `product_card.dart` — Grid tile with Hero image
- `cart_item_tile.dart` — Cart row with swipe-to-dismiss
- `category_chip.dart` — Selectable filter chip
- `rating_stars.dart` — Star rating row
- `search_bar.dart` — Animated search input
- `custom_bottom_nav.dart` — Bottom navigation
- `empty_state.dart` — Empty cart / no results

---

### Phase 5 — Screens

#### [NEW] [splash_screen.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/screens/splash_screen.dart)
- Animated logo + auto-navigate

#### [NEW] [login_screen.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/screens/login_screen.dart)
- Mock login form

#### [NEW] [home_screen.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/screens/home_screen.dart)
- Product grid + search + category filter + bottom nav

#### [NEW] [product_detail_screen.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/screens/product_detail_screen.dart)
- Full detail view + add to cart

#### [NEW] [cart_screen.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/screens/cart_screen.dart)
- Cart list + total + checkout

#### [NEW] [profile_screen.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/screens/profile_screen.dart)
- Mock profile + orders + settings

---

### Phase 6 — App Entry & Theming

#### [NEW] [main.dart](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/lib/main.dart)
- `MultiProvider` setup, theme configuration, route table

---

### Phase 7 — Polish & Documentation

#### [NEW] [README.md](file:///c:/Users/Gaming/Desktop/Gmail%20Flutter/README.md)
- Setup instructions, screenshots placeholder, AI tools disclosure, architecture overview

---

## Verification Plan

### Automated Tests
```bash
flutter analyze     # Zero warnings/errors
flutter test        # Unit tests pass (if time permits)
flutter build apk   # Successful release build
```

### Manual Verification
- Run on Android emulator/device and verify all 5 screens
- Test cart add/remove/quantity change logic
- Test search filtering and category filtering
- Toggle dark mode and verify persistence across app restart
- Verify responsive layout on different screen sizes
- Test navigation flow: Splash → Login → Home → Detail → Cart → Profile → Logout

---

## Open Questions

> [!IMPORTANT]
> **Currency**: The task mentions LKR (Sri Lankan Rupee). Should prices be displayed as `LKR 4,500.00` or `Rs. 4,500.00`? I'll default to `LKR` format since that's mentioned in the task.

> [!IMPORTANT]
> **App Name**: Any preference for the app name? I'll default to **"ShopLab"** — a clean, brandable name that subtly references CyphLab.

> [!IMPORTANT]
> **Color Scheme**: I'm planning a modern teal/cyan primary with dark charcoal accents. The dark mode will use deep navy surfaces. Does that work for you, or do you have a preferred palette?

> [!IMPORTANT]
> **Flutter SDK**: Do you have Flutter installed on your machine? If not, I'll need to guide you through setup. Also, which Flutter channel/version are you on? This affects dependency compatibility.
