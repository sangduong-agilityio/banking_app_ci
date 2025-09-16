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
[Figma Design Link](https://www.figma.com/design/KpEEAF0zp2rMWBP8oxplBI/Untitled?t=SSkNVOJHFQZMf8d3-0)

## Team Structure

**Team Size:** 1 Developer\
**Front-end Developer:** Duong Sang\
**Menter:** Nhan Doan

**Timeline:**

- Reading Phase: 10 days
- Practice Phase: 10 days
- **Start Date:** 16/9/2025
- **End Date:** 29/9/2025

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

### Architecture & Organization

- Select and apply Clean or Feature-First Architecture
- Organize project modules around core flows (Transfer, Bill Payment, Account, Reports, Utilities)

#### Supabase Data Table Organization

- Design normalized schema for banking
- Define relations, indexes, and optimize queries

#### Dependency Injection (DI)

- Use GetIt with service locator
- Manage dependencies per feature/layer

#### Caching & Offline Support

- Cache transaction history, exchange rates, and beneficiary lists
- Implement offline-first for transaction drafts & bill payments

#### Error Handling and Custom Exceptions

- Define custom exceptions for banking flows (transfer failed, invalid OTP, insufficient funds)

#### Transaction Security

- Integrate biometrics (Touch ID, Face ID) to confirm sensitive actions
- Provide OTP fallback when biometrics fail or unavailable

#### State Management with BLoC

- Apply feature-based BLoC for authentication, transfer, bill payment, account management,settings
- Handle async API calls, validation, and error propagation gracefully

#### Performance Optimization

- Optimize widget rendering for transaction history and charts
- Profile memory usage when switching between multiple flows

#### App Lifecycle Handling

- Handle session timeout, background/foreground transitions securely

#### Testing & Code Quality

- Unit tests for services (transfer, bill payment).
- Widget tests for transaction confirmation flow and OTP/biometric validation
- Golden tests for consistent UI screens (Transfer, Bill, Reports)

## Features Scope

- **Landing Page** - Welcome and app introduction
- **Sign In** - User authentication with email/password
- **Sign Up** - User registration with validation
- **Home Dashboard** - Account overview with quick actions
- **Search** - User registration with validation
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
│   │   ├── repositories/
│   │   │   └── auth_repository.dart
│   │   ├── states/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── views/
│   │   │   ├── landing_screen.dart
│   │   │   ├── sign_in_screen.dart
│   │   │   ├── sign_up_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   └── widgets/
│   │       ├── auth_form.dart
│   │       └── auth_header.dart
│   ├── home/
│   │   ├── models/
│   │   │   ├── account_model.dart
│   │   │   └── quick_action_model.dart
│   │   ├── repositories/
│   │   │   └── home_repository.dart
│   │   ├── states/
│   │   │   ├── home_bloc.dart
│   │   │   ├── home_event.dart
│   │   │   └── home_state.dart
│   │   ├── views/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       ├── welcome_section.dart
│   │       ├── account_card.dart
│   │       └── quick_actions_grid.dart
│   ├── search/
│   │   ├── models/
│   │   │   └── search_model.dart
│   │   ├── repositories/
│   │   │   └── search_repository.dart
│   │   ├── states/
│   │   │   ├── search_bloc.dart
│   │   │   ├── search_event.dart
│   │   │   └── search_state.dart
│   │   ├── views/
│   │   │   └── search_screen.dart
│   │   └── widgets/
│   │       └── currency_card.dart
│   ├── account/
│   │   ├── models/
│   │   │   └── account_model.dart
│   │   ├── repositories/
│   │   │   └── account_repository.dart
│   │   ├── states/
│   │   │   ├── account_bloc.dart
│   │   │   ├── account_event.dart
│   │   │   └── account_state.dart
│   │   ├── views/
│   │   │   └── account_screen.dart
│   │   └── widgets/
│   │       └── account_card.dart
│   ├── transactions/
│   │   ├── models/
│   │   │   └── transaction_model.dart
│   │   ├── repositories/
│   │   │   └── transaction_repository.dart
│   │   ├── states/
│   │   │   ├── transaction_bloc.dart
│   │   │   ├── transaction_event.dart
│   │   │   └── transaction_state.dart
│   │   ├── views/
│   │   │   └── transaction_history_screen.dart
│   │   └── widgets/
│   │       └── transaction_item.dart
│   ├── transfer/
│   │   ├── models/
│   │   │   ├── transfer_model.dart
│   │   ├── repositories/
│   │   │   └── transfer_repository.dart
│   │   ├── states/
│   │   │   ├── transfer_bloc.dart
│   │   │   ├── transfer_event.dart
│   │   │   └── transfer_state.dart
│   │   ├── views/
│   │   │   ├── transfer_screen.dart
│   │   └── widgets/
│   │       ├── contact_item.dart
│   │       └── amount_input.dart
│   ├── bills/
│   │   ├── models/
│   │   │   └── bill_model.dart
│   │   ├── repositories/
│   │   │   └── bill_repository.dart
│   │   ├── states/
│   │   │   ├── bill_bloc.dart
│   │   │   ├── bill_event.dart
│   │   │   └── bill_state.dart
│   │   ├── views/
│   │   │   └── bill_payment_screen.dart
│   │   └── widgets/
│   │       └── bill_detail_card.dart
│   └── setting/
│       ├── models/
│       │   └── user_model.dart
│       ├── repositories/
│       │   └── setting_repository.dart
│       ├── states/
│       │   ├── setting_bloc.dart
│       │   ├── setting_event.dart
│       │   └── setting_state.dart
│       ├── views/
│       │   └── setting_screen.dart
│       └── widgets/
│           └── card_detail.dart
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
