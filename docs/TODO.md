# Snipvid — TODO & Améliorations

*Dernière mise à jour : 2026-02-16*

---

## ✅ Fait

- [x] Structure projet Flutter
- [x] Navigation (go_router)
- [x] UI : Home, Photos, Music, Vibe, Processing, Export
- [x] 10 tracks audio bundlées (Pixabay royalty-free)
- [x] MusicService avec catégories
- [x] Testé sur simulateur iOS (iPhone 17 Pro)

---

## 🚀 MVP — Prochaines étapes

### 1. Génération vidéo cloud (PRIORITÉ)

**Problème** : `ffmpeg_kit_flutter` incompatible avec Xcode 26 / iOS 26

**Solution** : Creatomate API
- REST API cloud pour générer vidéos à partir d'images
- Pricing : 1 min vidéo 720p = ~14 credits
- Free trial : 50 credits (sans CB)
- Docs : https://creatomate.com/docs/api/introduction

**Implémentation** :
```dart
// 1. Upload photos vers storage temporaire (Firebase/Cloudflare R2)
// 2. Appeler Creatomate API avec URLs des photos + musique
// 3. Récupérer URL de la vidéo générée
// 4. Télécharger et sauvegarder dans galerie
```

### 2. Export vers galerie
- Package : `image_gallery_saver`
- Share sheet : `share_plus`

### 3. Watermark
- Créer logo Snipvid
- L'ajouter via Creatomate (en overlay)

---

## 🎵 Musique

### Actuel — Tracks bundlées ✅
10 tracks dans `assets/audio/` :
- Upbeat : vlog_hiphop, groovy_trap, no_sleep
- Chill : summer_lounge, lofi_jazzy, nature_ambient
- Cinematic : cinematic_inspiring
- Epic : epic_adventure, sport_rock, dark_cyberpunk

### V2 — API externe
- Jamendo API (gratuit, attribution requise)
- Ou Uppbeat (payant, meilleure qualité)

---

## 🎬 Creatomate API — Détails

### Pricing
| Plan | Credits | ~Vidéos 1min 720p | Prix |
|------|---------|-------------------|------|
| Trial | 50 | ~3 | Gratuit |
| Essential | 2,000 | ~140 | $? |
| Growth | 10,000 | ~700 | $? |

### Endpoints clés
```
POST /v1/renders
  - source: template JSON ou URL
  - modifications: données dynamiques (photos, musique)
  
GET /v1/renders/{id}
  - status: rendering, completed, failed
  - url: URL de la vidéo générée
```

### Template pour slideshow
```json
{
  "output_format": "mp4",
  "width": 1080,
  "height": 1920,
  "elements": [
    {
      "type": "image",
      "source": "{{photo_url}}",
      "animations": [{"type": "fade"}]
    },
    {
      "type": "audio",
      "source": "{{music_url}}"
    }
  ]
}
```

---

## 💰 Monétisation

### In-App Purchase
- Package : `in_app_purchase`
- Produit : "Remove Watermark" — 3.99€ (one-time)

---

## 🐛 Problèmes connus

| Problème | Status | Solution |
|----------|--------|----------|
| FFmpeg incompatible Xcode 26 | ⏸️ | Utiliser Creatomate cloud |
| iPhone MDM corporate | ⏸️ | Tester sur simulateur |

---

## 📚 Ressources

- **Creatomate** : https://creatomate.com/docs/api/introduction
- **Shotstack** (alternative) : https://shotstack.io/docs/
- **Share Plus** : https://pub.dev/packages/share_plus
- **Image Gallery Saver** : https://pub.dev/packages/image_gallery_saver_plus

---

## 🗓️ Changelog

### 2026-02-16
- Setup projet Flutter complet
- 6 écrans UI fonctionnels
- 10 tracks audio bundlées
- FFmpeg désactivé (incompatible Xcode 26)
- Décision : utiliser Creatomate API pour génération cloud
