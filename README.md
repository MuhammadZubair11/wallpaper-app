# Wallpaper App

A Flutter-based Wallpaper App that allows users to browse, search, and download high-quality wallpapers using REST APIs.

## Features

- Browse latest and trending wallpapers  
- Search wallpapers by keywords  
- High-resolution images with dynamic loading  
- Pagination support for endless scrolling  
- Shimmer effect while loading images  
- Save or download wallpapers to your device  
- Dark mode support  

## Tech Stack

- **Flutter** (UI Framework)  
- **Dart** (Programming Language)  
- **REST API Integration** (Pexels/Unsplash or your chosen API)  
- **Provider** (State Management)  

## Project Structure

- `lib/services/api_services.dart` – API calls and data fetching  
- `lib/viewmodels/wallpaper_view_model.dart` – Business logic & state management  
- `lib/screens/` – App screens (Home, Search, Details)  
- `lib/widgets/` – Reusable UI components  

## Getting Started

### Prerequisites
- Flutter SDK installed  
- API key from your wallpaper provider (e.g., Pexels)  

### Installation
```bash
git clone https://github.com/yourusername/wallpaperapp.git
cd wallpaperapp
flutter pub get
flutter run
