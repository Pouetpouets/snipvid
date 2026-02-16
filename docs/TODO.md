# Snipvid — TODO & Améliorations

*Dernière mise à jour : 2026-02-16*

---

## 🚀 MVP (en cours)

- [x] Structure projet Flutter
- [x] Navigation (go_router)
- [x] UI : Home, Photos, Music, Vibe, Processing, Export
- [ ] **Musique** : Bundle 10-15 tracks royalty-free
- [ ] **FFmpeg** : Assemblage photos + musique → vidéo
- [ ] **Export** : Sauvegarde galerie + share sheet
- [ ] **Watermark** : Logo en overlay (exports gratuits)

---

## 🎵 Musique

### MVP — Tracks bundlées
- Télécharger 10-15 tracks depuis Pixabay Music (download manuel)
- Catégories : Upbeat, Chill, Emotional, Epic
- Stocker dans `assets/audio/`
- Durées variées : 1-3 min

### V2 — API externe
- **Jamendo API** (gratuit, attribution requise)
  - Docs : https://developer.jamendo.com/
  - Énorme catalogue
  - Nécessite affichage crédit artiste
- Alternative : Uppbeat (payant mais quali pro)

### ⚠️ Note importante
Pixabay n'a **PAS d'API pour la musique** — seulement images et vidéos.
La section musique du site existe mais sans endpoint public.

---

## 🎬 FFmpeg — Montage vidéo

### Commande de base (à implémenter)
```bash
ffmpeg -framerate 1/3 -i photo%d.jpg -i music.mp3 \
  -c:v libx264 -pix_fmt yuv420p -c:a aac \
  -shortest output.mp4
```

### Paramètres par vibe
| Vibe | Durée/photo | Transition | Effet |
|------|-------------|------------|-------|
| Dynamique | 0.5-1s | Cut sec | Beat-sync |
| Lent | 3-4s | Fade/dissolve | Ken Burns |
| Mix | 1-3s (random) | Varié | — |
| Épique | Progressif | Build-up | Crescendo |

### Beat-sync (V2)
- Détecter BPM avec `ffmpeg -af astats`
- Ou package Dart : `beat_detection`
- Caler les transitions sur les beats

---

## 📱 Export

### Formats
- **9:16** (1080x1920) — Reels, TikTok, Stories
- **1:1** (1080x1080) — Feed Instagram
- **16:9** (1920x1080) — YouTube

### Watermark
- Position : coin bas droit
- Opacity : 70%
- Taille : ~10% de la largeur
- FFmpeg : `-vf "movie=watermark.png [wm]; [in][wm] overlay=W-w-10:H-h-10"`

### Share
- iOS : `Share.shareXFiles()` (package `share_plus`)
- Android : idem
- Sauvegarder aussi dans galerie (`image_gallery_saver`)

---

## 💰 Monétisation

### In-App Purchase
- Package : `in_app_purchase`
- Produit : "Remove Watermark" — 3.99€ (one-time)
- Optionnel : Lifetime unlock 14.99€

### Revenue estimée
- Conversion freemium → paid : ~2-5%
- Si 10k users, ~200-500 achats = 800-2000€

---

## 🐛 Bugs connus

*(À remplir au fil du dev)*

---

## 📚 Ressources

- FFmpeg Flutter : https://pub.dev/packages/ffmpeg_kit_flutter
- Pixabay Music (manual DL) : https://pixabay.com/music/
- Jamendo API : https://developer.jamendo.com/
- Share Plus : https://pub.dev/packages/share_plus

---

## 🗓️ Changelog

### 2026-02-16
- Setup projet Flutter
- UI complète (6 écrans)
- Décision : tracks bundlées pour MVP (pas d'API musique dispo)
