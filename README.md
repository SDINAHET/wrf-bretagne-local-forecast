# wrf-bretagne-local-forecast
Moteur météo local WRF pour la Bretagne : simulations 9 km/3 km, prévisions 24h/72h, analyse Python et comparaison Open-Meteo/GFS/AROME.


V1 - Bretagne 9 km / 24h
- installer WRF + WPS
- domaine Bretagne
- GFS 0.25°
- sortie wrfout 24h

V2 - Bretagne 9 km / 72h
- même domaine
- prévision sur 3 jours
- comparaison Open-Meteo
- écarts à 8h, 12h, 15h, 20h, 23h

V3 - Bretagne 3 km / 24h
- domaine plus précis
- meilleure résolution locale
- plus lourd CPU/RAM
- comparaison avec AROME/Open-Meteo


Le projet vise à construire progressivement une plateforme de prévision météo locale autonome en comparant plusieurs sources :

- WRF
- GFS
- Open-Meteo
- AROME
- IA locale de correction des prévisions

---

## 🎯 Objectifs

- Faire fonctionner WRF localement sous Linux / WSL
- Générer des prévisions météo pour la Bretagne
- Comparer les résultats avec Open-Meteo et AROME
- Mesurer automatiquement les écarts de prévision
- Construire un moteur météo autonome open source

---

## 🚀 Roadmap

| Version | Modèle | Résolution | Durée simulée | Temps estimé | RAM estimée | Espace disque |
|----------|----------|----------|----------|----------|----------|----------|
| V1 | Bretagne | 9 km | 24h | 5 à 15 min | 2 à 4 Go | 5 à 10 Go |
| V2 | Bretagne | 9 km | 72h | 15 à 45 min | 4 à 8 Go | 10 à 20 Go |
| V3 | Bretagne | 3 km | 24h | 30 min à 2h | 8 à 20 Go | 20 à 50 Go |

---

## 🖥️ Configuration cible

Machine de développement :

| Composant | Configuration |
|------------|------------|
| CPU | Intel Core i7 |
| RAM | 64 Go DDR4 |
| GPU | NVIDIA GTX 1650 4 Go |
| OS | Ubuntu 22.04 LTS (WSL2) |
| Stockage | SSD NVMe |

---

## 📂 Structure du projet

```text
wrf-bretagne-local-forecast/
├── v1_bretagne_9km_24h/
│   ├── WRF/
│   ├── WPS/
│   ├── data/
│   └── output/
│
├── v2_bretagne_9km_72h/
│   ├── WRF/
│   ├── WPS/
│   ├── data/
│   └── output/
│
├── v3_bretagne_3km_24h/
│   ├── WRF/
│   ├── WPS/
│   ├── data/
│   └── output/
│
├── scripts/
│   ├── download_gfs.py
│   ├── compare_openmeteo.py
│   ├── compare_arome.py
│   ├── extract_wrf.py
│   └── generate_report.py
│
├── docs/
│   ├── installation.md
│   ├── architecture.md
│   └── roadmap.md
│
├── data/
│   ├── geog/
│   ├── gfs/
│   ├── arome/
│   └── observations/
│
├── logs/
│
├── output/
│
├── README.md
├── requirements.txt
└── docker-compose.yml
```

---

## 🔄 Pipeline

```text
GFS / AROME
      │
      ▼
     WPS
      │
      ▼
     WRF
      │
      ▼
   wrfout
      │
      ▼
 Extraction Python
      │
      ▼
 Comparaison Open-Meteo
      │
      ▼
 Historique PostgreSQL
      │
      ▼
 Analyse IA locale
      │
      ▼
 Dashboard Web
```

---

## 📊 Comparaison automatique

Le moteur comparera automatiquement :

- Température
- Pluie
- Humidité
- Vent moyen
- Rafales
- Pression

Aux heures :

```text
08h00
12h00
15h00
20h00
23h00
```

---

## 🔮 Évolutions futures

- WRF Bretagne 1 km
- Assimilation de données météo locales
- IA de correction des prévisions
- Radar pluie temps réel
- Prévisions maritimes Bretagne
- Prévisions agricoles
- Cartographie Leaflet
- Interface Web complète

---

## 👨‍💻 Auteur

Stéphane Dinahet

Projet expérimental de prévision météo locale open source.
