# Tradly Shop App

## Overview

- This document provides the requirement for Flutter Advanced and apply state
  management detailed estimate of Flutter for the practice.

## Design

- This is the design of the app :
  [link](https://www.figma.com/design/cbyU4pamdddEA1uowX8Am8/grocery-marketplace-tradly.app?node-id=0-1&p=f&t=1gTQ8lihGdQYaCQL-0)

## Team Size

- 1 Dev

_**Start date :**_ 25/4/2025

_**Timeline:**_ 3 weeks (25/4/2025 - Update)

_**Target :**_

- Flutter Form Builder: Learn to create dynamic forms using various field types
  and validate inputs (e.g., email, phone number). Handle form submissions and
  data saving.
- Material 3 Design System: Explore the evolution to Material 3 and integrate
  components like buttons and sliders, with a focus on dynamic theming and
  responsive UIs.
- Advanced UI & Animation: Handle scrolling views, learn animation basics
  (AnimationController, Tween), and implement responsive UIs for mobile and
  tablet devices.
- State Management with BLoC: Master BLoC architecture, event/state flow, and
  manage app state with asynchronous API calls and error handling.
- Native Features Integration: Use image_picker for image selection, manage app
  permissions, and handle gallery access.
- Set up a CI/CD pipeline using GitHub Actions
- Learn and apply Accessibility for practice
- Integrate push notifications with Firebase Cloud Messaging (FCM)

## Prerequisites

Before you continue, ensure you meet the following requirements:

- You have installed flutter sdk with version >= 3.33.0
- You have installed Dart sdk with version >= 3.9.0

## Documents

- [Plan Training Flutter Advanced](https://docs.google.com/document/d/1C4MEFCHJKRIw8ieLzrNhMHKxs5QFlprqjpIcl45ATTc/edit?tab=t.0)
- [Estimate](https://docs.google.com/document/d/1n18975kA_qqnYDn0qf391Ew0WILNyV4SO2RlZZHMaGs/edit?tab=t.0#heading=h.r7uza4gjahs1)
- [Issues board Gitlab for management plan](https://gitlab.asoft-python.com/sang.duong/flutter-training/-/boards)
  ​

## Deployment Plan

- [x] Epic 1: Flutter Form Builder: Learn to create dynamic forms using various
      field types and validate inputs (e.g., email, phone number). Handle form
      submissions and data saving.
- [x] Epic 2: Material 3 Design System: Explore the evolution to Material 3 and
      integrate components like buttons and sliders, with a focus on dynamic
      theming and responsive UIs.
- [x] Epic 3: Advanced UI & Animation: Handle scrolling views, learn animation
      basics (AnimationController, Tween), and implement responsive UIs for
      mobile and tablet devices.
- [x] Epic 4: State Management with BLoC: Master BLoC architecture, event/state
      flow, and manage app state with asynchronous API calls and error handling.
- [x] Epic 5: Native Features Integration: Use image_picker for image selection,
      manage app permissions, and handle gallery access.
- [x] Epic 6: Integrate push notifications with Firebase Cloud Messaging (FCM).
- [x] Epic 7: Implement Semantics widgets to enhance screen reader support.

## Implement UI + Handle State Management

- [x] Sign In Screen + State Management(BLoC) + Supabase
- [x] Sign Up Screen + State Management(BLoC) + Supabase
- [x] Home Screen + State Management(BLoC) + API
- [x] Product Detail Screen + State Management(BLoC) + API
- [x] Browse Screen + State Management(BLoC) + API
- [x] My Store Screen + State Management(BLoC) + API
- [x] Order History Screen + State Management(BLoC) + API
- [x] Checkout Screen + State Management(BLoC) + Supabase
- [x] Profile Screen + State Management(BLoC)
- [x] WishList Screen + State Management(BLoC)

## Installation

1. Clone the repository: ​
   ```
   git@gitlab.asoft-python.com:sang.duong/flutter-training.git
   ```
2. Checkout branch: ​
   ```
   git checkout <develop>
   ```
3. Pull origin branch: ​
   ```
   git pull origin <develop>
   ```
4. Run project
   ```
   Run app:
     flutter run ./tradly-app/lib/main.dart
   ```

   ```
   Run Device Preview:
     flutter run ./tradly-app/lib/main_device_preview.dart
   ```
