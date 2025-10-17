# 📚 App de Libros — Proyecto Final Flutter

**Autor:** David Daniel Lucana Mamani  
**Materia:** Programación Móvil II — INFocal La Paz  
**Fecha:** Octubre 2025  

## 🧾 Descripción
Aplicación móvil Flutter que consume la **API de Google Books** y permite:
- Buscar libros por nombre.
- Ver detalles con descripción, calificación y enlace a Google Books.
- Agregar y eliminar libros de una lista personal.
- Confirmación al eliminar.
- **Modo oscuro / claro.**
- **Persistencia local** con SharedPreferences.

## 🧩 Tecnologías utilizadas
- Flutter 3.x
- Dart
- Provider (gestión de estado)
- HTTP (consumo de API)
- SharedPreferences (almacenamiento local)
- url_launcher (enlaces externos)

## 📱 Capturas de pantalla
*(Agrega aquí tus capturas reales cuando las tomes)*  
![Pantalla principal](screenshots/home.png)
![Detalle del libro](screenshots/detail.png)
![Modo oscuro](screenshots/darkmode.png)

## 💾 Instalación del APK
Descargar el archivo APK:  
👉 [app_libros_final.apk](./releases/app_libros_final.apk)

## 🧠 Ejecución local
```bash
flutter pub get
flutter run
