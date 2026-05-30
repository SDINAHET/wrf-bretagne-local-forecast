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




v1_bretagne_9km_24h/

ubuntu24.04
mkdir -p v1_bretagne_9km_24h/{src,data/geog,data/gfs,runs,output,logs,scripts}
sudo apt update
sudo apt install -y \
  build-essential gfortran gcc g++ make m4 csh perl git wget curl unzip \
  libnetcdf-dev libnetcdff-dev netcdf-bin \
  mpich libmpich-dev \
  libpng-dev libjasper-dev zlib1g-dev
gfortran --version
mpif90 --version
nc-config --version
nf-config --version

ubuntu 22.04
root@UID7E:/mnt/d/Users/steph/Documents/projet_meteo/wrf-bretagne-local-forecast# docker compose build
docker compose run  wrf
[+] Building 105.6s (8/8) FINISHED                                                                                   docker:default
 => [wrf internal] load build definition from Dockerfile.wrf                                                                   0.1s
 => => transferring dockerfile: 505B                                                                                           0.0s
 => [wrf internal] load metadata for docker.io/library/ubuntu:22.04                                                            2.4s
 => [wrf internal] load .dockerignore                                                                                          0.1s
 => => transferring context: 2B                                                                                                0.0s
 => [wrf 1/3] FROM docker.io/library/ubuntu:22.04@sha256:4f838adc7181d9039ac795a7d0aba05a9bd9ecd480d294483169c5def983b64d      8.1s
 => => resolve docker.io/library/ubuntu:22.04@sha256:4f838adc7181d9039ac795a7d0aba05a9bd9ecd480d294483169c5def983b64d          0.0s
 => => sha256:86f1a8d7b38e7a014c249cf2ca573c8ff7ce3cca128c5c06dcee758813726f90 2.05kB / 2.05kB                                 0.0s
 => => sha256:40d16f30db405106ef8074779bdf41f012465c2a785bbeaa2eab9f2081099b47 29.74MB / 29.74MB                               5.4s
 => => sha256:4f838adc7181d9039ac795a7d0aba05a9bd9ecd480d294483169c5def983b64d 6.69kB / 6.69kB                                 0.0s
 => => sha256:ce941a2a18bbb922e434d6d6d2b31e571a5c3826eaf6ada0a41dcc905bd2d906 424B / 424B                                     0.0s
 => => extracting sha256:40d16f30db405106ef8074779bdf41f012465c2a785bbeaa2eab9f2081099b47                                      2.1s
 => [wrf 2/3] RUN apt-get update && apt-get install -y     build-essential     gfortran     gcc     g++     make     m4       91.3s
 => [wrf 3/3] WORKDIR /wrf-project                                                                                             0.2s
 => [wrf] exporting to image                                                                                                   3.1s
 => => exporting layers                                                                                                        2.9s
 => => writing image sha256:906bcbef9d65b0fb3abaa45c228fec93113de0b56e8f5d37954bd61ab0edcd9b                                   0.0s
 => => naming to docker.io/library/wrf-bretagne-local-forecast-wrf                                                             0.0s
 => [wrf] resolving provenance for metadata file                                                                               0.0s
[+] Creating 1/1
 ✔ Network wrf-bretagne-local-forecast_default  Created                                                                        0.3s
root@158c5d6448f2:/wrf-project# gfortran --version
mpif90 --version
nc-config --version
nf-config --version
GNU Fortran (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

GNU Fortran (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

netCDF 4.8.1
netCDF-Fortran 4.5.4
root@158c5d6448f2:/wrf-project# exit

cd /wrf-project/v1_bretagne_9km_24h/src
git clone --recurse-submodule https://github.com/wrf-model/WRF.git
git clone https://github.com/wrf-model/WPS.git


cd WRF
./configure
export NETCDF=/usr
export NETCDF_classic=1
./configure
root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF# ./configure
checking for perl5... no
checking for perl... found /usr/bin/perl (perl)
Will use NETCDF in dir: /usr
ADIOS2 not set in environment. Will configure WRF for use without.
HDF5 not set in environment. Will configure WRF for use without.
PHDF5 not set in environment. Will configure WRF for use without.
$JASPERLIB or $JASPERINC not found in environment, configuring to build without grib2 I/O...
------------------------------------------------------------------------
Please select from among the following Linux x86_64 options:

  1. (serial)   2. (smpar)   3. (dmpar)   4. (dm+sm)   PGI (pgf90/gcc)
  5. (serial)   6. (smpar)   7. (dmpar)   8. (dm+sm)   PGI (pgf90/pgcc): SGI MPT
  9. (serial)  10. (smpar)  11. (dmpar)  12. (dm+sm)   PGI (pgf90/gcc): PGI accelerator
 13. (serial)  14. (smpar)  15. (dmpar)  16. (dm+sm)   INTEL (ifort/icc)
                                         17. (dm+sm)   INTEL (ifort/icc): Xeon Phi (MIC architecture)
 18. (serial)  19. (smpar)  20. (dmpar)  21. (dm+sm)   INTEL (ifort/icc): Xeon (SNB with AVX mods)
 22. (serial)  23. (smpar)  24. (dmpar)  25. (dm+sm)   INTEL (ifort/icc): SGI MPT
 26. (serial)  27. (smpar)  28. (dmpar)  29. (dm+sm)   INTEL (ifort/icc): IBM POE
 30. (serial)               31. (dmpar)                PATHSCALE (pathf90/pathcc)
 32. (serial)  33. (smpar)  34. (dmpar)  35. (dm+sm)   GNU (gfortran/gcc)
 36. (serial)  37. (smpar)  38. (dmpar)  39. (dm+sm)   IBM (xlf90_r/cc_r)
 40. (serial)  41. (smpar)  42. (dmpar)  43. (dm+sm)   PGI (ftn/gcc): Cray XC CLE
 44. (serial)  45. (smpar)  46. (dmpar)  47. (dm+sm)   CRAY CCE (ftn $(NOOMP)/cc): Cray XE and XC
 48. (serial)  49. (smpar)  50. (dmpar)  51. (dm+sm)   INTEL (ftn/icc): Cray XC
 52. (serial)  53. (smpar)  54. (dmpar)  55. (dm+sm)   PGI (pgf90/pgcc)
 56. (serial)  57. (smpar)  58. (dmpar)  59. (dm+sm)   PGI (pgf90/gcc): -f90=pgf90
 60. (serial)  61. (smpar)  62. (dmpar)  63. (dm+sm)   PGI (pgf90/pgcc): -f90=pgf90
 64. (serial)  65. (smpar)  66. (dmpar)  67. (dm+sm)   INTEL (ifort/icc): HSW/BDW
 68. (serial)  69. (smpar)  70. (dmpar)  71. (dm+sm)   INTEL (ifort/icc): KNL MIC
 72. (serial)  73. (smpar)  74. (dmpar)  75. (dm+sm)   AMD (flang/clang) :  AMD ZEN1/ ZEN2/ ZEN3 Architectures
 76. (serial)  77. (smpar)  78. (dmpar)  79. (dm+sm)   INTEL (ifx/icx) : oneAPI LLVM
 80. (serial)  81. (smpar)  82. (dmpar)  83. (dm+sm)   FUJITSU (frtpx/fccpx): FX10/FX100 SPARC64 IXfx/Xlfx

Enter selection [1-83] :
38 ne fonctionne pas









root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF# rm -f configure.wrf
root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF# export NETCDF=/usr
export NETCDF_classic=1
./configure
checking for perl5... no
checking for perl... found /usr/bin/perl (perl)
Will use NETCDF in dir: /usr
ADIOS2 not set in environment. Will configure WRF for use without.
HDF5 not set in environment. Will configure WRF for use without.
PHDF5 not set in environment. Will configure WRF for use without.
$JASPERLIB or $JASPERINC not found in environment, configuring to build without grib2 I/O...
------------------------------------------------------------------------
Please select from among the following Linux x86_64 options:

  1. (serial)   2. (smpar)   3. (dmpar)   4. (dm+sm)   PGI (pgf90/gcc)
  5. (serial)   6. (smpar)   7. (dmpar)   8. (dm+sm)   PGI (pgf90/pgcc): SGI MPT
  9. (serial)  10. (smpar)  11. (dmpar)  12. (dm+sm)   PGI (pgf90/gcc): PGI accelerator
 13. (serial)  14. (smpar)  15. (dmpar)  16. (dm+sm)   INTEL (ifort/icc)
                                         17. (dm+sm)   INTEL (ifort/icc): Xeon Phi (MIC architecture)
 18. (serial)  19. (smpar)  20. (dmpar)  21. (dm+sm)   INTEL (ifort/icc): Xeon (SNB with AVX mods)
 22. (serial)  23. (smpar)  24. (dmpar)  25. (dm+sm)   INTEL (ifort/icc): SGI MPT
 26. (serial)  27. (smpar)  28. (dmpar)  29. (dm+sm)   INTEL (ifort/icc): IBM POE
 30. (serial)               31. (dmpar)                PATHSCALE (pathf90/pathcc)
 32. (serial)  33. (smpar)  34. (dmpar)  35. (dm+sm)   GNU (gfortran/gcc)
 36. (serial)  37. (smpar)  38. (dmpar)  39. (dm+sm)   IBM (xlf90_r/cc_r)
 40. (serial)  41. (smpar)  42. (dmpar)  43. (dm+sm)   PGI (ftn/gcc): Cray XC CLE
 44. (serial)  45. (smpar)  46. (dmpar)  47. (dm+sm)   CRAY CCE (ftn $(NOOMP)/cc): Cray XE and XC
 48. (serial)  49. (smpar)  50. (dmpar)  51. (dm+sm)   INTEL (ftn/icc): Cray XC
 52. (serial)  53. (smpar)  54. (dmpar)  55. (dm+sm)   PGI (pgf90/pgcc)
 56. (serial)  57. (smpar)  58. (dmpar)  59. (dm+sm)   PGI (pgf90/gcc): -f90=pgf90
 60. (serial)  61. (smpar)  62. (dmpar)  63. (dm+sm)   PGI (pgf90/pgcc): -f90=pgf90
 64. (serial)  65. (smpar)  66. (dmpar)  67. (dm+sm)   INTEL (ifort/icc): HSW/BDW
 68. (serial)  69. (smpar)  70. (dmpar)  71. (dm+sm)   INTEL (ifort/icc): KNL MIC
 72. (serial)  73. (smpar)  74. (dmpar)  75. (dm+sm)   AMD (flang/clang) :  AMD ZEN1/ ZEN2/ ZEN3 Architectures
 76. (serial)  77. (smpar)  78. (dmpar)  79. (dm+sm)   INTEL (ifx/icx) : oneAPI LLVM
 80. (serial)  81. (smpar)  82. (dmpar)  83. (dm+sm)   FUJITSU (frtpx/fccpx): FX10/FX100 SPARC64 IXfx/Xlfx

Enter selection [1-83] : 34
------------------------------------------------------------------------
Compile for nesting? (1=basic, 2=preset moves, 3=vortex following) [default 1]: 1

Configuration successful!
------------------------------------------------------------------------
testing for fseeko and fseeko64
fseeko64 is supported
------------------------------------------------------------------------

# Settings for    Linux x86_64 ppc64le, gfortran compiler with gcc   (dmpar)
#
DESCRIPTION     =       GNU ($SFC/$SCC)
DMPARALLEL      =        1
OMPCPP          =       # -D_OPENMP
OMP             =       # -fopenmp
OMPCC           =       # -fopenmp
SFC             =       gfortran
SCC             =       gcc
CCOMP           =       gcc
DM_FC           =       mpif90 -f90=$(SFC)
DM_CC           =       mpicc -cc=$(SCC)
FC              =        $(DM_FC)
CC              =       $(DM_CC) -DFSEEKO64_OK
LD              =       $(FC)
RWORDSIZE       =       4
PROMOTION       =       #-fdefault-real-8
ARCH_LOCAL      =       -DNONSTANDARD_SYSTEM_SUBR  -DWRF_USE_CLM
# to validate WRF correctness on aarch64 against x86_64; compile with x86 this alternate ARCH_LOCAL option; able to achieve identical output model on ubuntu 18.04 with gcc 10.2 (on graviton and intel processors)
# ARCH_LOCAL      =       -DNONSTANDARD_SYSTEM_SUBR  -DWRF_USE_CLM -DAARCH64_X86_CORRECTNESS_FIX
CFLAGS_LOCAL    =       -w -O3 -c  # -DRSL0_ONLY
LDFLAGS_LOCAL   =
CPLUSPLUSLIB    =
ESMF_LDFLAG     =       $(CPLUSPLUSLIB)
FCOPTIM         =       -O2 -ftree-vectorize -funroll-loops
FCREDUCEDOPT    =       $(FCOPTIM)
FCNOOPT         =       -O0
FCDEBUG         =       # -g $(FCNOOPT) # -ggdb -fbacktrace -fcheck=bounds,do,mem,pointer -ffpe-trap=invalid,zero,overflow
FORMAT_FIXED    =       -ffixed-form
FORMAT_FREE     =       -ffree-form -ffree-line-length-none
FCSUFFIX        =
FCCOMPAT        =
BYTESWAPIO      =       -fconvert=big-endian -frecord-marker=4
FCBASEOPTS_NO_G =       -w $(FORMAT_FREE) $(BYTESWAPIO) $(FCCOMPAT)
FCBASEOPTS      =       $(FCBASEOPTS_NO_G) $(FCDEBUG)
MODULE_SRCH_FLAG =
TRADFLAG        =      -traditional-cpp
CPP             =      /lib/cpp -P -nostdinc
AR              =      ar
ARFLAGS         =      ru
M4              =      m4 -G
RANLIB          =      ranlib
RLFLAGS         =
CC_TOOLS        =      $(SCC)


###########################################################
######################
# POSTAMBLE

FGREP = fgrep -iq
### Used throughout the build system to inform promotion to double precision
DOUBLE_PRECISION =

ARCHFLAGS       =    $(COREDEFS) -DIWORDSIZE=$(IWORDSIZE) -DDWORDSIZE=$(DWORDSIZE) -DRWORDSIZE=$(RWORDSIZE) -DLWORDSIZE=$(LWORDSIZE)  \
                     $(ARCH_LOCAL) \
                     $(DA_ARCHFLAGS) \
                      -DDM_PARALLEL \
                       \
                      -DNETCDF \
                       \
                       \
                       \
                       \
                       \
                       \
                       \
                       \
                       \
                       \
                       -DLANDREAD_STUB=1 \
                       \
                       \
                      -DUSE_ALLOCATABLES \
                      -Dwrfmodel \
                      -DGRIB1 \
                      -DINTIO \
                      -DKEEP_INT_AROUND \
                      -DLIMIT_ARGS \
                      -DBUILD_RRTMG_FAST=0 \
                      -DBUILD_RRTMK=0 \
                      -DBUILD_SBM_FAST=1 \
                      -DSHOW_ALL_VARS_USED=0 \
                      -DCONFIG_BUF_LEN=$(CONFIG_BUF_LEN) \
                      -DMAX_DOMAINS_F=$(MAX_DOMAINS) \
                      -DMAX_HISTORY=$(MAX_HISTORY) \
                      -DNMM_NEST=$(WRF_NMM_NEST)
CFLAGS          =    $(CFLAGS_LOCAL) -DDM_PARALLEL  \
                      -DLANDREAD_STUB=1 \
                      -DMAX_HISTORY=$(MAX_HISTORY) -DNMM_CORE=$(WRF_NMM_CORE)
FCFLAGS         =    $(FCOPTIM) $(FCBASEOPTS)
ESMF_LIB_FLAGS  =
# ESMF 5 -- these are defined in esmf.mk, included above
 ESMF_IO_LIB     =    -L$(WRF_SRC_ROOT_DIR)/external/esmf_time_f90 -lesmf_time
ESMF_IO_LIB_EXT =    -L$(WRF_SRC_ROOT_DIR)/external/esmf_time_f90 -lesmf_time
INCLUDE_MODULES =    $(MODULE_SRCH_FLAG) \
                     $(ESMF_MOD_INC) $(ESMF_LIB_FLAGS) \
                      -I$(WRF_SRC_ROOT_DIR)/main \
                      -I$(WRF_SRC_ROOT_DIR)/external/io_netcdf \
                      -I$(WRF_SRC_ROOT_DIR)/external/io_int \
                      -I$(WRF_SRC_ROOT_DIR)/frame \
                      -I$(WRF_SRC_ROOT_DIR)/share \
                      -I$(WRF_SRC_ROOT_DIR)/phys \
                      -I$(WRF_SRC_ROOT_DIR)/wrftladj \
                      -I$(WRF_SRC_ROOT_DIR)/chem -I$(WRF_SRC_ROOT_DIR)/inc \
                      -I$(NETCDFPATH)/include \

REGISTRY        =    Registry
CC_TOOLS_CFLAGS = -DNMM_CORE=$(WRF_NMM_CORE)

LIB             =    $(LIB_BUNDLED) $(LIB_EXTERNAL) $(LIB_LOCAL) $(LIB_WRF_HYDRO)
LDFLAGS         =    $(OMP) $(FCFLAGS) $(LDFLAGS_LOCAL)
ENVCOMPDEFS     =
WRF_CHEM        =       0
CPPFLAGS        =    $(ARCHFLAGS) $(ENVCOMPDEFS) -I$(LIBINCLUDE) $(TRADFLAG)
NETCDFPATH      =    /usr
HDF5PATH        =
WRFPLUSPATH     =
RTTOVPATH       =
PNETCDFPATH     =
ADIOS2PATH      =
NETCDFPAR_BUILD =    echo SKIPPING


bundled:  io_only
external: io_only $(WRF_SRC_ROOT_DIR)/external/RSL_LITE/librsl_lite.a gen_comms_rsllite module_dm_rsllite $(ESMF_TARGET)
io_only:  esmf_time wrfio_nf     \
          wrf_ioapi_includes wrfio_grib_share wrfio_grib1 wrfio_int fftpack


######################
------------------------------------------------------------------------
Settings listed above are written to configure.wrf.
If you wish to change settings, please edit that file.
If you wish to change the default options, edit the file:
     arch/configure.defaults
NetCDF users note:
 This installation of NetCDF supports large file support.  To DISABLE large file
 support in NetCDF, set the environment variable WRFIO_NCD_NO_LARGE_FILE_SUPPORT
 to 1 and run configure again. Set to any other value to avoid this message.

************************** W A R N I N G ************************************

The moving nest option is not available due to missing rpc/types.h file.
Copy landread.c.dist to landread.c in share directory to bypass compile error.

*****************************************************************************
*****************************************************************************
This build of WRF will use classic (non-compressed) NETCDF format
*****************************************************************************

root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF#

  34 puis 1



root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF# cd /wrf-project/v1_bretagne_9km_24h/src/WRF

ls -lh main/real.exe
ls -lh main/wrf.exe
ls: cannot access 'main/real.exe': No such file or directory
ls: cannot access 'main/wrf.exe': No such file or directory
root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF# nf-config --flibs
nf-config --fflags
nc-config --libs
nc-config --cflags
-L/usr/lib/x86_64-linux-gnu -lnetcdff -Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -flto=auto -Wl,-z,relro -Wl,-z,now -lnetcdf -lnetcdf -lm
-I/usr/include -I/usr/include
-L/usr/lib/x86_64-linux-gnu -L/usr/lib/x86_64-linux-gnu/hdf5/serial -lnetcdf
-I/usr/include -I/usr/include/hdf5/serial
root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF# ls /usr/lib/x86_64-linux-gnu/libnetcdff*
ls /usr/lib/x86_64-linux-gnu/libnetcdf*
/usr/lib/x86_64-linux-gnu/libnetcdff.a         /usr/lib/x86_64-linux-gnu/libnetcdff.so.7
/usr/lib/x86_64-linux-gnu/libnetcdff.settings  /usr/lib/x86_64-linux-gnu/libnetcdff.so.7.1.0
/usr/lib/x86_64-linux-gnu/libnetcdff.so
/usr/lib/x86_64-linux-gnu/libnetcdf.settings  /usr/lib/x86_64-linux-gnu/libnetcdff.settings
/usr/lib/x86_64-linux-gnu/libnetcdf.so        /usr/lib/x86_64-linux-gnu/libnetcdff.so
/usr/lib/x86_64-linux-gnu/libnetcdf.so.19     /usr/lib/x86_64-linux-gnu/libnetcdff.so.7
/usr/lib/x86_64-linux-gnu/libnetcdff.a        /usr/lib/x86_64-linux-gnu/libnetcdff.so.7.1.0
root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF# cd /wrf-project/v1_bretagne_9km_24h/src/WRF

sed -i 's|-L/usr/lib|-L/usr/lib/x86_64-linux-gnu -lnetcdff -lnetcdf|g' configure.wrf
root@a4e6ea953d88:/wrf-project/v1_bretagne_9km_24h/src/WRF#

./clean -a
export NETCDF=/usr
export NETCDF_classic=1
./configure
# choix 34 puis 1
sed -i 's|-L/usr/lib|-L/usr/lib/x86_64-linux-gnu -lnetcdff -lnetcdf|g' configure.wrf
./compile em_real 2>&1 | tee ../../logs/wrf_compile.log
