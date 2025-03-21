# ✨ Snipp Code Editor

Snipp is a modern, AI-powered Flutter-based code editor that allows users to write, run, and debug code seamlessly. It supports real-time code execution, intelligent error suggestions, cloud history saving, and an elegant UI inspired by cutting-edge developer tools.

---

## 🚀 Features

- 🔤 **Multi-language Code Editing** (Python & C++ supported)
- ⚡ **Live Code Execution** via secure backend (Docker + Node.js)
- 🤖 **AI-Powered Error Suggestions**
- ☁ **Firestore Integration** for Code History per User
- 🌈 **Monokai Syntax Highlighting**
- 🧠 **AI Code Fix Panel & Suggestions Box**
- 📂 **Multi-file Support (coming soon)**
- 🎨 **Sleek UI with Glassmorphism & Animated Transitions**
- 🔒 **Firebase Auth Support** (Email & Anonymous Login)

---

## 📁 Project Structure

snipp_code_editor/ │ ├── lib/ │ ├── main.dart │ ├── home_screen.dart │ ├── widgets/ │ │ ├── code_editor_widget.dart │ │ ├── ai_suggestion_widget.dart │ ├── services/ │ │ ├── firebase_service.dart │ │ └── backend_service.dart │ ├── assets/ │ └── monokai_syntax_theme.json │ ├── pubspec.yaml └── README.md

---

## 🔧 Backend Code Execution

The backend is deployed using **Node.js + Docker on Render**, executing code inside containers securely and efficiently.

### 🔙 Supported Languages:
- Python 3
- C++ (GCC/Clang)

### Backend Features:
- Execution timeout handling
- AI error fixing suggestions via OpenAI/HuggingFace
- Standard input support (Python)

🔗 [Backend Repo (Optional)](https://github.com/your-backend-repo)

---

## 🔐 Firebase Integration

- Firebase Auth (Email/Anonymous)
- Firestore for saving execution history

### Setup:
1. Add `google-services.json` and `GoogleService-Info.plist`
2. Configure Firebase project:
   - Project ID: `snipp-code`
   - Package Name: `com.arc.snipp`

---

## 🛠 Setup Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/snipp_code_editor.git
   cd snipp_code_editor

   Install dependencies:

bash
Copy code
flutter pub get
Configure Firebase (android & ios)

Run the app:

bash
Copy code
flutter run

🤝 Contributions
Feel free to fork the repo, suggest features, or open pull requests. Contributions are welcome!

💬 Contact
Created with ❤️ by Archishman
Email: archishmanmittal@gmail.com
Project ID: snipp-code

