# Taskify -  Task Manager  

Taskify is a **Flutter-based task management app** powered by **Firebase Realtime Database**.  
It helps users manage their daily tasks efficiently with **multi-user support**, **real-time updates**, and a **priority-based color system**.  

---

## 🚀 Features  

- 🔥 **Firebase Realtime Database** – All tasks are stored and synced in real-time.  
- 👥 **Multi-User Support** – Each user can securely log in and manage their own tasks.  
- 📌 **Task Management** – Add, update, and delete tasks seamlessly.  
- 🎨 **Priority-Based Colors** – Tasks are highlighted in different colors based on priority:  
  
- 📅 **Live Updates** – Any changes appear instantly .  

---


 

---

## 🛠️ Tech Stack  

- **Frontend**: Flutter (Dart)  
- **Backend**: Firebase Realtime Database + Firebase Authentication  
- **State Management**: FirebaseAnimatedList  

---

## 📂 Project Structure  

```bash
lib/
 ┣ screens/
 ┃ ┣ home_screen.dart     # Displays tasks in real-time
 ┃ ┣ addTask_screen.dart  # Add new tasks
 ┣ constants/
 ┃ ┗ colors.dart          # Priority-based color scheme
 ┣ main.dart              # App entry point
