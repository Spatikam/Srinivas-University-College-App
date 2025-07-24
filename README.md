# 🎓 Srinivas University App

> The official mobile app of Srinivas University and its 11 constituent institutes.

---

## 📱 Overview

The **Srinivas University App** is the official hub for all student-related information across the 11 institutes under Srinivas University. Built with accessibility and real-time data in mind, the app keeps students updated with announcements, events, placements, academic calendars, and much more.

It also includes a private **Admin Dashboard** for institute-level administrators to dynamically manage their respective content.

---

## 🚀 Features

### 🏫 Institute Dashboards
Each of the 11 institutes has its own personalized dashboard containing:
- 🗓️ Event Section: Past + upcoming events, articles, and statistics
- 🎓 Admission Info: Fetched directly from the institute’s official website
- ⚡ Quick Access: College’s contact numbers and social media
- 📣 Announcement Board: Notices and upcoming college-specific info

### 🔍 Explore Page
- 🎓 View recent placements
- 📚 Explore institute-specific data like:  
  Courses, Campus Life, Events, Alumni, Online Library, News & more

### 🖼️ Gallery
- Institute-wise gallery showcasing fests, college life, and activities

### 📆 Academic Calendar
- Scrollable calendar for academic year with official events and breaks

### ☰ Side Panel
- 🔄 Dark/Light mode toggle  
- 🔐 Admin Dashboard access  
- ℹ️ About Us, Privacy Policy & Help section (email contact)

---

## 🛠️ Admin Dashboard

Admins can:
- Login via Supabase Auth
- Update only their respective Institute’s data
- Perform CRUD operations for:
  - 📢 Announcements  
  - 🗞️ Articles  
  - 📅 Events  
  - 📷 Gallery Images  
  - 🎓 Placements  
- All updates reflect in real-time across all apps via Supabase

---

## ⚙️ Tech Stack


<table>
  <tr>
    <td align="center">
      <img src="https://img.icons8.com/color/96/flutter.png" width="48" height="48" alt="Flutter"/><br/>Flutter
    </td>
    <td align="center">
      <img src="https://img.icons8.com/color/96/dart.png" width="48" height="48" alt="Dart"/><br/>Dart
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/82957092?s=200&v=4" width="48" height="48" alt="Supabase"/><br/>Supabase
    </td>
    <td align="center" style="background-color:white; border-radius:8px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flask/flask-original.svg" width="48" height="48" alt="Flask"/><br/>Flask
    </td>
    <td align="center">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" width="48" height="48" alt="Python"/><br/>Python
    </td>
  </tr>
</table>

### Frontend
- **Flutter**  
- **Dart**

### Backend
- **Supabase**
  - Authentication
  - Postgres database
- **Flask (Python)**  
  - Hosted on PythonAnywhere  
  - Manages secure upload/delete/fetch of images to bypass Supabase’s storage limits

---

## 🏗️ Architecture

- **Frontend (Flutter)** handles routing, UI, state, and HTTP requests.
- **State Management**: `Provider`
- **Supabase** handles:
  - Admin authentication
  - Dynamic public data (Events, Announcements, etc.)
- **Flask Image Server** on PythonAnywhere for uploading/retrieving gallery images
- **Modular UI** per Institute (scoped by login account)

---

## 📁 Folder Structure
```bash
lib/
├── main.dart
├── config.dart
├── screens/
│ ├── views/
│ │ ├── admin_screen/ # Admin CRUD screens
│ │ ├── base_screen/ # Calendar, Explore, Gallery, Home
│ │ ├── content_pages/ # About, Help, Quick Access, etc.
│ │ ├── login_screen/ # Login
│ │ ├── main_screen/ # Landing Page
│ │ ├── splash_screen/ # App Splash Loader
│ ├── widget_common/ # Reusable widgets (AppBar, WebView, etc.)
assets/
├── animation/ # Lottie animations
├── fonts/
├── icons/
│ ├── app-icon.png, splash-logo.png, social icons
├── images/
│ ├── iahs/, ias/, icis/, ... # Images per Institute
│ ├── global/ # College-wide images
```

---

## 🧪 Setup & Installation
```bash
# 1. Clone the repo:
    git clone https://github.com/Spatikam/Srinivas-University-College-App.git

# 2. Install dependencies
    flutter pub get

# 3. Run
    flutter run
```

---

## 📦 Deployment
- ✅ Live App: [Download on Play Store](https://play.google.com/store/apps/details?id=com.webflow.rip_college_app)
- 🛠️ Source Code: [GitHub Repository](https://github.com/Spatikam/Srinivas-University-College-App)

---

## 🤝 Contribution
Contributions are welcome!
Refer to the [CONTRIBUTING.md](https://github.com/Spatikam/Srinivas-University-College-App/blob/main/Contribution.md) for guidelines.

---

## 🪤 Gotchas
"None yet... but don't jinx it." 😅  
(This section is reserved for bugs, workarounds, and things future devs should know!)

---

## 💬 Contact
For queries, feedback or issues, feel free to email us at [teamspatikam@gmail.com](mailto:teamspatikam@gmail.com)
