# Shopiki Admin

A modern, fully-featured, and responsive Flutter Admin App for managing an online product sales business.

## Features
- **Authentication:** Secure login with Firebase Auth (email/password)
- **Role-based Access:** (Planned) Restrict access to admin features
- **Product Management:** Add, update, delete, search, and filter products
- **Category Management:** Manage categories and subcategories
- **Order Management:** View, update status, assign delivery, export reports (CSV/PDF)
- **User Management:** View users, change roles (user/admin)
- **Sales Dashboard:** Animated charts (fl_chart), KPIs, and metrics
- **Inventory Alerts:** Low stock warnings
- **Push Notifications:** (Planned) Firebase Messaging for offers/alerts
- **Modern UI/UX:** Material 3, light/dark theme, animated transitions, Lottie icons, shimmer loaders
- **Responsive Layout:** Mobile, tablet, and web support

## Tech Stack
- **Flutter** (mobile + web)
- **Firebase:** Auth, Firestore, Storage, Messaging, Cloud Functions
- **State Management:** provider
- **UI Libraries:**
  - flutter_animate (animations)
  - fl_chart (charts)
  - lottie (animated icons)
  - shimmer (loading states)
  - responsive_framework (responsive layouts)
- **Other:** csv, pdf, intl, shared_preferences

## Project Structure
```
lib/
 ┣ screens/
 ┃ ┣ admin/
 ┃ ┃ ┣ dashboard_screen.dart
 ┃ ┃ ┣ manage_products.dart
 ┃ ┃ ┣ manage_orders.dart
 ┃ ┃ ┣ manage_users.dart
 ┃ ┃ ┗ notifications.dart
 ┃ ┗ auth/
 ┃   ┗ login_screen.dart
 ┣ models/ (product.dart, order.dart, user.dart, category.dart)
 ┣ services/firebase/ (firebase_service.dart)
 ┣ controllers/ (app_controllers.dart)
 ┣ widgets/ (animated_dashboard_card.dart)
 ┣ themes/ (app_theme.dart)
 ┣ main.dart
```

## Getting Started
1. **Clone the repo:**
   ```sh
   git clone <your-repo-url>
   cd shopiki_admin
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Firebase Setup:**
   - Create a Firebase project
   - Enable Auth, Firestore, Storage, Messaging
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS), and add to respective folders
   - For web, update `index.html` and add Firebase config
4. **Run the app:**
   ```sh
   flutter run -d chrome   # For web
   flutter run -d android  # For Android
   flutter run -d ios      # For iOS
   ```

## Customization & Extending
- Add your own Lottie/3D icons to `assets/lottie/` and `assets/icons/`
- Extend models and services for more business logic
- Implement role-based access and push notifications as needed

## License
MIT
