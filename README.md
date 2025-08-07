# Banking App - Advanced Flutter Training

## Overview

This advanced Dart & Flutter training plan is designed to help experienced
developers deepen their expertise with Flutter 3.29.2 and Dart 3.7.2, focusing
on advanced application architecture, performance optimization, and
platform-specific integrations. The project implements a comprehensive banking
application with modern features and best practices for production-grade Android
and iOS applications.

## Design

This is the design of the app:
[Figma Design Link](https://www.figma.com/design/oIm4TAgD2uIB00Xdq9Nqr6/Banking---E-Money-MBanking---E-Money-Management-App-%7CDigital-%7C-Finance-Mobile-Banking--Community-?node-id=0-1&p=f&t=ybZ47hmoEjAjvwjB-0)

## Team Structure

**Team Size:** 1 Developer\
**Front-end Developer:** Duong Sang\
**Menter:** Nhan Doan

**Timeline:**

- Reading Phase: 10 days
- Practice Phase: 15 days
- **Start Date:** [To be updated based on practice start]
- **End Date:** [To be updated based on start date + timeline]

## Tech Stack

- **Dart:** SDK version >= 3.9.0
- **Flutter:** SDK version >= 3.35.0
- **Backend:** Supabase
- **State Management:** BLoC
- **HTTP Client:** Dio
- **Monorepo Management:** Melos
- **Flutter Version Management:** Puro
- **Device Testing:** Device_preview

## Development Tools

- **Version Control:** GitLab
- **IDE:** VSCode
- **Mobile Development:** XCode/Android Studio

## Device Support

### Supported Platforms

- **iOS:** iOS >= 18.2
- **Android:** Android API 23+ (Android 6.0 and newer)

## Learning Objectives

### Architecture & Project Organization

- Research and compare different architectural patterns (MVC, MVVM, Clean
  Architecture)
- Organize project structure based on selected architecture
- Feature-first architecture implementation

### Advanced Flutter Concepts

#### Supabase Data Table Organization

- Proper data table organization on Supabase
- Design normalized database schema for banking operations
- Implement proper relationships between tables
- Optimize queries and data access patterns

#### Dependency Injection (DI)

- Research and learn DI organization for Flutter projects
- Implement dependency injection with GetIt
- Create proper service locator patterns
- Manage dependencies across different layers

#### Cache Management Implementation

- Apply proper cached management strategies using flutter_cache_manager package
- Offline-first architecture design
- Handle network connectivity changes
- Offline data storage and conflict resolution

#### Error Handling and Custom Exceptions

- Design comprehensive error handling system
- Create custom exception classes for different scenarios
- Implement proper error propagation through layers
- User-friendly error messaging and recovery

#### State Management with BLoC

- Deep dive into BLoC architecture, naming conventions, and event/state flow
- Practice with asynchronous API calls and error handling
- Learn how to manage application state efficiently across multiple widgets

#### Performance Optimization

- Implement memory management best practices
- Performance profiling and optimization techniques
- Widget lifecycle optimization
- Resource management and disposal

#### App Lifecycle Handling

- Comprehensive understanding of Flutter app lifecycle states
- Implement proper lifecycle event handling
- Demo different lifecycle scenarios and responses

#### Testing & Code Quality

- Research widget testing best practices
- Write comprehensive widget tests
- Code organization and naming conventions
- Documentation and code comments

## Features Scope

### Core Features

- **Landing Page** - Welcome and app introduction
- **Sign In** - User authentication with email/password
- **Sign Up** - User registration with validation
- **Forgot Password** - Password recovery flow
- **Home Dashboard** - Account overview with quick actions
- **Transaction History** - Complete transaction records with filtering
- **Transfer Money** - P2P and bank transfers
- **Pay Bills** - Utility bills and service payments
- **Account Management** - Profile and settings

## Project Structure

```
Feature-First Architecture

lib/
├── main_device_preview.dart
├── main.dart
├── app/
│   ├── app.dart
│   ├── routes.dart
│   ├── theme.dart
│   └── constants.dart
├── core/
│   ├── services/
│   │   ├── supabase_service.dart
│   │   └── auth_service.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── extensions.dart
│   ├── errors/
│   │   └── app_exceptions.dart
│   └── widgets/
│       ├── buttons.dart
│       ├── inputs.dart
│       ├── cards.dart
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   └── auth_request.dart
│   │   ├── services/
│   │   │   └── auth_repository.dart
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── pages/
│   │   │   ├── landing_page.dart
│   │   │   ├── sign_in_page.dart
│   │   │   ├── sign_up_page.dart
│   │   │   └── forgot_password_page.dart
│   │   └── widgets/
│   │       ├── auth_form.dart
│   │       └── auth_header.dart
│   ├── dashboard/
│   │   ├── models/
│   │   │   ├── account_model.dart
│   │   │   └── quick_action_model.dart
│   │   ├── services/
│   │   │   └── dashboard_repository.dart
│   │   ├── bloc/
│   │   │   ├── dashboard_bloc.dart
│   │   │   ├── dashboard_event.dart
│   │   │   └── dashboard_state.dart
│   │   ├── pages/
│   │   │   └── home_page.dart
│   │   └── widgets/
│   │       ├── welcome_section.dart
│   │       ├── account_card.dart
│   │       └── quick_actions_grid.dart
│   ├── transactions/
│   │   ├── models/
│   │   │   └── transaction_model.dart
│   │   ├── services/
│   │   │   └── transaction_repository.dart
│   │   ├── bloc/
│   │   │   ├── transaction_bloc.dart
│   │   │   ├── transaction_event.dart
│   │   │   └── transaction_state.dart
│   │   ├── pages/
│   │   │   └── transaction_history_page.dart
│   │   └── widgets/
│   │       └── transaction_item.dart
│   ├── transfer/
│   │   ├── models/
│   │   │   ├── contact_model.dart
│   │   │   └── transfer_model.dart
│   │   ├── services/
│   │   │   └── transfer_repository.dart
│   │   ├── bloc/
│   │   │   ├── transfer_bloc.dart
│   │   │   ├── transfer_event.dart
│   │   │   └── transfer_state.dart
│   │   ├── pages/
│   │   │   ├── contact_selection_page.dart
│   │   │   ├── transfer_amount_page.dart
│   │   │   └── transfer_success_page.dart
│   │   └── widgets/
│   │       ├── contact_item.dart
│   │       └── amount_input.dart
│   ├── bills/
│   │   ├── models/
│   │   │   └── bill_model.dart
│   │   ├── services/
│   │   │   └── bill_repository.dart
│   │   ├── bloc/
│   │   │   ├── bill_bloc.dart
│   │   │   ├── bill_event.dart
│   │   │   └── bill_state.dart
│   │   ├── pages/
│   │   │   ├── bill_categories_page.dart
│   │   │   └── bill_payment_page.dart
│   │   └── widgets/
│   │       └── bill_category_card.dart
│   └── profile/
│       ├── models/
│       │   └── profile_model.dart
│       ├── services/
│       │   └── profile_repository.dart
│       ├── bloc/
│       │   ├── profile_bloc.dart
│       │   ├── profile_event.dart
│       │   └── profile_state.dart
│       ├── pages/
│       │   └── account_page.dart
│       └── widgets/
│           └── profile_card.dart
```

## Development Roadmap

### Core Features Implementation

- [] **Authentication Flow**
  - Sign In Screen + BLoC + Supabase
  - Sign Up Screen + BLoC + Supabase
  - Forgot Password functionality
- [] **Dashboard & Navigation**
  - Home Screen + BLoC + API integration
  - Navigation system with bottom navigation
- [] **Financial Operations**
  - Transaction History + BLoC + API
  - Transfer Money functionality + BLoC + Supabase
  - Bill Payment system + BLoC + API
- [] **User Management**
  - Profile Screen + BLoC
  - Account settings and preferences

### Advanced Features & Optimization

- [ ] Performance optimization and profiling
- [ ] Comprehensive error handling implementation
- [ ] Offline support and cache management
- [ ] Widget testing implementation

## Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone git@gitlab.asoft-python.com:sang.duong/flutter-training.git
   ```

2. **Checkout banking branch:**
   ```bash
   git checkout feat/implement-banking-application
   ```

3. **Pull latest changes:**
   ```bash
   git pull origin feat/implement-banking-application
   ```

4. **Install dependencies:**
   ```bash
   flutter pub get
   ```

5. **Run the application:**
   ```bash
   # Standard run
   flutter run ./tradly-app/lib/main.dart

   # With Device Preview
   flutter run ./tradly-app/lib/main_device_preview.dart
   ```

## Key Features Implementation

### Authentication System

- Email/password authentication via Supabase
- Form validation with custom validators
- Secure token management
- Password reset functionality

### Dashboard

- **Welcome Section:** Personalized greeting with username
- **Account Cards:** Horizontal scrollable card carousel showing account
  balances
- **Quick Actions Grid:**
  - Transfer money - Quick access to transfer flows
  - Withdraw funds - ATM and bank withdrawal options
  - Mobile recharge - Prepaid mobile top-up
  - Pay bills - Utility and service bill payments
  - Credit card management - Card settings and limits
  - Transaction reports - Detailed transaction analytics
  - Account settings - Profile and security settings

### Financial Operations

#### Transfer Money

- **Contact Selection:** Search contacts by name, phone, or card number
- **Recent Recipients:** List of recent transfer recipients
- **Transfer Form:** Amount input with currency formatting and limits
- **Success/Failure Handling:** Comprehensive transaction result management

#### Transaction History

- **Transaction List:** Chronological transaction display with infinite scroll
- **Filter Options:** Date range, type, amount, status filtering
- **Search Functionality:** Search by description or amount

#### Bill Payment

- **Bill Categories:**
  - Electricity bills with provider selection
  - Water utility bills
  - Internet and cable bills
- **Payment Processing:** Secure payment flow with confirmation

#### Account Management

- **Account Overview:** Complete account details with real-time balance
- **Personal Information:** Profile editing and contact information updates
- **Security Settings:** Privacy and security configuration options

## Resources

- [Plan Training Flutter Advanced](https://docs.google.com/document/d/1wdaeaLT-tdKSUVn9UCTgnRcpOei406j5h2QCP0dzDw0/edit?tab=t.0)
- [Issues Board GitLab](https://gitlab.asoft-python.com/sang.duong/flutter-training/-/boards)
