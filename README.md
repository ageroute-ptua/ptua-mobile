# 📱 PTUA Mobile - Application Terrain AGEROUTE

Application mobile "Offline-First" conçue pour les enquêteurs du Projet de Transport Urbain d'Abidjan (PTUA). Elle permet de collecter les informations relatives aux Personnes Affectées par le Projet (PAP) directement sur le terrain, même sans connexion internet.

## ✨ Fonctionnalités Principales

- **Architecture Offline-First** : Utilisation de `sqflite` pour stocker toutes les données localement sur la tablette.
- **Formulaire Dynamique Avancé** : Système de Stepper résilient pour la saisie des données PAP, Biens Impactés, Vulnérabilité, et Plan de Restauration.
- **Intelligence Artificielle (OCR)** : Intégration de l'API **Gemini AI** pour scanner et extraire automatiquement les informations des Cartes Nationales d'Identité (CNI).
- **Géolocalisation & Cartographie** : Intégration de `flutter_map` (OpenStreetMap) pour le positionnement GPS précis des biens impactés.
- **Multimédia & Preuves** : Capture de photos (biens, empreintes) et système de signature électronique intégré (`signature`).
- **Synchronisation Sécurisée** : Moteur d'envoi en masse "Multipart" pour synchroniser les enquêtes et les fichiers lourds avec le backend Spring Boot via JWT.

## 🛠️ Prérequis

- **Flutter SDK** : Version 3.10 ou supérieure.
- **Dart SDK** : Version 3.0 ou supérieure.
- **Android Studio / Xcode** (pour l'émulation et le build).

## 🚀 Installation & Lancement

1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/ageroute-ptua/ptua-mobile.git
   cd ptua-mobile
   ```

2. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

3. **Configuration des Secrets (Variables d'Environnement)** :
   Créez un fichier `.env` à la racine du projet et ajoutez votre clé API Google Gemini :
   ```env
   GEMINI_API_KEY=votre_cle_api_gemini_ici
   ```
   *(Ce fichier est ignoré par Git pour des raisons de sécurité).*

4. **Lancer l'application** :
   ```bash
   flutter run
   ```

## 📂 Architecture du Projet (Clean Architecture)

- `lib/models/` : Modèles de données (PAP, Biens, Finances, etc.).
- `lib/screens/` : Interfaces graphiques principales (Listes, Formulaires, Stepper).
- `lib/widgets/` : Composants UI réutilisables (Dropdowns premium, cartes, etc.).
- `lib/services/` : Logique métier et appels externes (OCR Gemini, Sync API, Database).
- `lib/providers/` : Gestion d'état globale via Riverpod (Thème sombre/clair, etc.).

## 🔒 Sécurité
Les tokens JWT et les identifiants de session sont stockés de manière cryptée grâce à `flutter_secure_storage`.
