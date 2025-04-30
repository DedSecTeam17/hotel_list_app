
# 🏨 Hotel List App

[![Codemagic build status](https://api.codemagic.io/apps/6811f04982b41899d6fb942f/6811f04982b41899d6fb942e/status_badge.svg)](https://codemagic.io/app/6811f04982b41899d6fb942f/6811f04982b41899d6fb942e/latest_build)

A Flutter application that displays a list of hotels with advanced features including filtering, offline support, deep linking, and a clean architecture based on MVVM (Model-View-ViewModel).

## ❓ Why This Architecture?

This app was built as a modular and scalable solution to simulate a real-world hotel browsing experience. The decisions behind each feature were made with long-term maintainability, testability, and user experience in mind:

- **MVVM + Provider**: To ensure a clear separation between business logic and UI. This keeps the presentation layer lean and reactive, while ViewModels handle state and behavior.

- **Clean Architecture**: Promotes testability and scalability by isolating concerns into `Data`, `Domain`, and `Presentation` layers. It allows you to plug in new data sources (e.g., real API) without impacting business logic or UI.

- **Filtering System**: Dynamically powered by backend-configured categories, supporting flexible feature additions with no UI hardcoding.

- **Offline Caching**: Improves user experience in poor or no network conditions by persisting the last loaded data using `path_provider` and local JSON files.

- **Deep Linking**: Supports direct navigation to a specific hotel’s detail screen, useful for marketing links, push notifications, or bookmarks.

- **Pagination Support**: Structured from data to presentation to support future API scaling and infinite scrolling.

- **CI + Local GitHub Actions**: Ensures that tests and builds run automatically using a self-hosted macOS runner, simulating production CI behavior efficiently without cloud costs.

This approach makes the app resilient to changes, easier to onboard other developers, and ready to scale for larger product needs like authentication, search, or booking.



## 📐 Project Architecture

This project follows a layered **Clean Architecture** approach: 

![enter image description here](https://github-production-user-asset-6210df.s3.amazonaws.com/34925145/439181207-084249ea-5585-4153-98c2-351202d795c8.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA/20250430/us-east-1/s3/aws4_request&X-Amz-Date=20250430T100809Z&X-Amz-Expires=300&X-Amz-Signature=1d4482235396e9c29a30da3caff553d4dbbbc3404fb862762d4c3d40e80b04b5&X-Amz-SignedHeaders=host)

### 🔁 Data Flow Overview
  ```mermaid
graph TD  
    subgraph Presentation  
        UI[Widgets/Pages] --> VM[ViewModel]  
    end  
  
    subgraph Domain  
        VM --> UC[UseCase]  
        UC --> REPO[HotelRepository (abstract)]  
    end  
  
    subgraph Data  
        REPO_IMPL[HotelRepositoryImpl] --> REMOTE[RemoteDataSource]  
        REPO_IMPL --> LOCAL[LocalDataSource]  
        REMOTE --> JSON[Mock JSON/API]  
        LOCAL --> FileCache  
    end  
  
    REPO -->|Implemented by| REPO_IMPL
   ```

🚀 How to Run the Application

✅ Requirements

- **Flutter**: 3.22+
- **macOS** with **Xcode** for iOS build
- **CocoaPods** installed
- **Self-hosted GitHub Runner** (optional)

### ▶️ Run App

```bash
flutter pub get
flutter run 
flutter test
flutter test integration_test
```

### 🧪 Run Tests
```bash 
flutter test
flutter test integration_test
```

### 🏗️ Build iOS
```bash 
flutter build ios --debug --no-codesign
```
## 🧪 Testing Approach
The app uses:

-   **Unit tests** for domain and view models

-   **Widget tests** for UI behavior (e.g., card rendering, carousel)

-   **Integration tests** for end-to-end user flows (e.g., filter selection → navigation)

-   **GitHub Actions** run locally via a self-hosted Mac runner to simulate PR checks instantly


### Sample Test Cases

-   Load hotel list from JSON

-   Select filters and verify displayed results

-   Navigate to hotel details from grid or deep link

-   Validate shimmer loading and retry after error

## 🔌 Third-Party Libraries Used
| Package                | Purpose                            |
|------------------------|-------------------------------------|
| `provider`             | State management (MVVM)             |
| `get_it`               | Dependency injection                |
| `cached_network_image` | Caching hotel images                |
| `uni_links`            | Handle deep links (cold/hot)        |
| `path_provider`        | Local storage for offline cache     |
| `http`                 | Mock API reading from JSON          |
| `integration_test`     | Full end-to-end test support        |



## 🌐 Deep Linking

The app supports universal deep links like:

```perl
myapp://hotel/Address%20Creek%20Harbour 
```

-   Handles cold start using `getInitialUri()`

-   Supports live stream with `uriLinkStream`

-   Navigates to detail screen once data is available

## 📦 Offline Support

When no internet:

-   Loads previously cached JSON file (HotelsDataModel)

-   Paginates locally and ensures no duplicates


All hotels and filters are cached via local JSON using `path_provider`.


## 💡 Design Decisions

### 🧱 Clean Architecture

-   Promotes scalability and testability

-   Separates UI, business logic, and data handling


### 💠 MVVM + Provider

-   Allows a reactive UI with ViewModel logic isolated

-   Easy to test ViewModels separately


### ⚡ Shimmer Loading

-   Enhances perceived performance with smooth UX


### 🔁 Pagination Logic

-   Implemented in ViewModel with scroll listener debounce

-   Data sliced and extended while avoiding duplicates


### 🔗 Deep Linking Flow

```bash
`SplashScreen → HotelListPage → Navigate to HotelDetailPage (if  link present)`
```

## 🧱 Challenges Faced

-   Coordinating deep links across app states (cold/warm start)

-   Building reusable shimmer + filter UI with performance

-   Managing offline caching and pagination correctly

-   Ensuring fast build/test feedback on local runner

## 🤖 CI/CD via GitHub Actions & Codemagic

### ✅ CI/CD Overview

-   ✅ Used **Codemagic** to build and distribute iOS apps

-   ✅ Locally executed GitHub Actions on **self-hosted Mac runner** for rapid PR simulations

-   ✅ CI runs all tests and builds iOS app in debug mode

-   ✅ Fast feedback without needing external build infrastructure


## 📍 Final Notes

You can build and test locally via:

```bash 
flutter pub get
flutter test flutter build ios --debug --no-codesign` 
```

Or use Codemagic for distribution, and self-hosted GitHub Actions to run everything automatically on PR.
![enter image description here](https://github-production-user-asset-6210df.s3.amazonaws.com/34925145/439187080-ed232ecb-8228-44b1-a08d-58555f2fce3f.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA/20250430/us-east-1/s3/aws4_request&X-Amz-Date=20250430T102114Z&X-Amz-Expires=300&X-Amz-Signature=dfc7bb95b97f8b93cca85bb779a1b9e27413e71e41b3691534446a53b9ae72e1&X-Amz-SignedHeaders=host)

> Built with 💙 Flutter, GetIt, Provider, and a Clean Architecture mindset.







