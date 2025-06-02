# Product Requirements Document: Subscription Manager Flutter App

## 1. Introduction

*   **Project Name:** Subscription Manager App
*   **Brief Description:** A Flutter mobile application designed to help users efficiently track, manage, and get insights into their various subscriptions. The app will prioritize a clean user interface, smooth animations, and local data persistence.
*   **Design Reference:** Based on the Dribbble design provided (refer to attached image/OCR).

## 2. Goals & Objectives

*   Develop a fully functional subscription management application for iOS and Android.
*   Implement all core features as depicted in the design reference, including the "My Subscriptions" screen, "Add Subscription" flow, and optionally the "General" dashboard.
*   Deliver a polished user experience through intuitive navigation and subtle animations.
*   Ensure the application state and user data are reliably persisted locally across app restarts.
*   Adhere to CLEAN architecture principles for a scalable, maintainable, and testable codebase.
*   Utilize specified technologies: Bloc for state management, Hive for local storage, and Google Fonts for typography.

## 3. Target Audience

*   Mobile users (iOS and Android) who subscribe to multiple services and seek a centralized tool to manage their subscription expenses and renewal dates.

## 4. Core Features

### 4.1. Get Started Screen
*   **Description:** An initial screen to welcome users to the app.
*   **Functionality:**
    *   May include a brief overview of app features.
    *   Navigation to the main application interface (e.g., "My Subscriptions" screen).

### 4.2. My Subscriptions Screen
*   **Description:** The primary screen for users to view and manage their active subscriptions.
*   **UI Elements (based on design):**
    *   Header: Hamburger menu, Screen Title ("My Subs"), Wallet icon (inactive), Notification icon.
    *   Filter Tabs: "All subs", "Entertainment", potentially user-creatable categories, and a "+" icon.
        *   The "+" icon opens a bottom sheet to allow users to **add a new category** and assign existing subscriptions to it.
    *   Subscription List: A scrollable list of individual subscription cards.
*   **Subscription Card Details:**
    *   Service Icon (e.g., Spotify, Netflix from `assets/icons/`).
    *   Service Name.
    *   Price and billing frequency (e.g., "$8/month", "$67.57/year").
    *   Distinct background color for visual differentiation.
*   **Functionality:**
    *   Display all added subscriptions.
    *   Allow filtering of subscriptions by category (e.g., "Entertainment", user-defined categories).
    *   Allow users to add new categories via the "+" icon in the filter tab bar.
    *   Allow viewing details of a subscription (on tap - TBD).
    *   Allow editing or deleting a subscription (e.g., via swipe action or long press - TBD).

### 4.3. Add/Edit Subscription Bottom Sheet (or Screen)
*   **Description:** A form, likely presented as a bottom sheet, for users to input or modify subscription details.
*   **Functionality:**
    *   Input fields for:
        *   Service Name (Text)
        *   Price (Numeric)
        *   Billing Cycle (e.g., Dropdown: Monthly, Yearly, Weekly)
        *   First Payment Date / Start Date (Date Picker)
        *   Category (Selector/Text Input, e.g., "Entertainment", "Work" - can also select from user-created categories)
        *   Icon (Selector from predefined list in `assets/icons/`)
        *   Card Color (Color picker or selection from a predefined palette)
        *   Notes (Optional, Text Area)
    *   Save/Add button to persist the subscription.
    *   Cancel/Dismiss option.

### 4.4. General Screen
*   **Description:** A dashboard providing an overview of spending and upcoming payments.
*   **UI Elements (based on design):**
    *   Header: Hamburger menu, Screen Title ("General"), Wallet icon (active), Notification icon.
    *   Spending Summary: "Spent for [Month]" (e.g., "$31.45"), percentage change.
    *   Upcoming Payment Highlight: Prominent display of a near-due subscription (Icon, Name, Price, Due Date).
    *   Payment History: List of recent payments/transactions (Icon, Name, Date, Amount).
*   **Functionality:**
    *   Display total spending for a selected period (e.g., current month).
    *   Highlight upcoming subscription payments.
    *   Show a log of past payments (if this level of detail is tracked).

### 4.5. Animations
*   **Description:** Subtle animations to enhance user experience.
*   **Examples:**
    *   Smooth screen transitions.
    *   Animated feedback on button presses or interactive elements.
    *   List item animations (e.g., on add, remove, reorder).
    *   Loading indicators.

## 5. Technical Specifications

### 5.1. Platform
*   Flutter (Targeting iOS and Android)

### 5.2. State Management
*   **Bloc:** Utilize BLoC/Cubit for managing UI state, business logic, and event handling.
    *   Separate Blocs/Cubits for different features/screens (e.g., `SubscriptionListBloc`, `SubscriptionFormBloc`, `GeneralDashboardBloc`).

### 5.3. Persistent Storage
*   **Hive:** Use Hive for local data persistence.
    *   Store `Subscription` objects and related user preferences.
    *   Define Hive adapters for custom data models.

### 5.4. UI & Styling
*   **Fonts (via `google_fonts` package):**
    *   **Red Hat Display:** For headings and prominent text.
    *   **Unbounded:** For body text and other UI elements.
*   **Primary Colors:**
    *   Background/Dark Theme Base: `#18181C`
    *   Primary Accent (Blue): `#026ACB` (for buttons, interactive elements, highlights)
    *   Secondary Accent (Green): `#05B862` (for positive indicators, specific highlights like the Spotify card in the "General" screen example)
*   **Subscription Card Colors:**
    *   The design shows varied colors (yellow, pink, green, purple, red) for subscription cards. A palette for these will need to be defined. This could be a fixed set, user-selectable, or automatically assigned.
*   **Icons:**
    *   Utilize the predefined brand icons located in the `assets/icons/` directory.

### 5.5. Architecture
*   **CLEAN Architecture:**
    *   **Presentation Layer:** Flutter Widgets, Blocs/Cubits, UI-specific logic.
    *   **Domain Layer:** Core business logic, Use Cases (Interactors), Entities (e.g., `Subscription`), Abstract Repository Interfaces. This layer is independent of Flutter and specific data sources.
    *   **Data Layer:** Concrete implementations of Repository Interfaces, Data Sources (Hive for local storage), Data Transfer Objects (DTOs) if needed.

### 5.6. Data Model (Example `Subscription` Entity - Domain Layer)
*   `id`: String (Unique identifier, e.g., UUID)
*   `name`: String (e.g., "Spotify", "Netflix")
*   `price`: double
*   `billingCycle`: Enum (e.g., `monthly`, `yearly`, `weekly`, `quarterly`)
*   `startDate`: DateTime (The date the subscription started or the first payment date)
*   `iconAssetPath`: String (Path to the local asset, e.g., `assets/icons/ic_spotify.png`)
*   `cardColorHex`: String (Hex string for the card's background color, e.g., "#05B862")
*   `category`: String (User-defined or predefined, e.g., "Entertainment", "Work", "Utilities")
*   `notes`: String (Optional, for user remarks)
*   _(Calculated fields like `nextPaymentDate` will be derived in the domain or presentation layer)_

## 6. Code Quality & Maintainability

*   **Reusability:** Develop common widgets (e.g., `SubscriptionListItem`, `CustomButton`, `StyledTextInput`) and utility functions.
*   **Modularity:** Organize code into logical modules based on features and layers (Clean Architecture).
*   **Readability:** Follow Dart best practices, use meaningful names, and ensure consistent formatting.
*   **Comments:** Add comments to explain complex logic, public APIs, and critical sections of code.
*   **Scalability:** Design the architecture to accommodate future features and enhancements with minimal refactoring.
*   **Testing:** (Consideration for future) Plan for unit tests for Blocs/Use Cases and widget tests for UI components.

## 7. Data Management

*   All user-generated data, including subscription details and application settings, will be stored locally on the device using Hive.
*   No external network calls will be made for fetching or storing core application data.
*   Backup/Restore functionality is out of scope for the initial version unless specified.

## 8. Evaluation Criteria (Summary from User Request)

*   **Functionality:**
    *   App works as intended.
    *   All core features are properly implemented.
    *   Effective error handling and management of edge cases.
*   **User Experience & Front-End Design:**
    *   Intuitive, easy-to-navigate, and user-friendly UI.
    *   Close alignment with the provided Dribbble design reference.
    *   Clean, professional, and visually appealing interface.
    *   Smooth animations that enhance the overall experience.
*   **Code Quality & Cleanliness:**
    *   Well-structured, readable, and maintainable code.
    *   Creation of reusable widgets and components to avoid redundancy.
    *   Modular and well-organized logic.
    *   Effective use of comments to explain key parts of the code.
    *   Scalable architecture for future enhancements.

---

This PRD will be the guiding document for the project.
