# Android Google Sign-In Setup

1. Buka Google Cloud Console, pilih project yang dipakai aplikasi.
2. Aktifkan API berikut:
   - Google Drive API
3. Pada OAuth consent screen, tambahkan scope:
   - `email`
   - `https://www.googleapis.com/auth/drive.appdata`
4. Buat OAuth Client ID:
   - Android client (package name + SHA-1 debug/release)
   - Web client (dipakai sebagai `GOOGLE_SERVER_CLIENT_ID`)
   - Package name Android untuk release CI mengikuti:
     - GitHub Variable `ANDROID_APP_ORG` + project name `fin_sage`
     - default jika variable kosong: `com.financeapp.fin_sage`
   - Set `ANDROID_APP_ORG` di Repository Variables agar konsisten dengan Firebase/Google Cloud.
5. Isi GitHub Secrets untuk release Android:
   - `GOOGLE_CLIENT_ID`
   - `GOOGLE_SERVER_CLIENT_ID`
6. Ambil nilai client ID cepat dari Firebase CLI:

```bash
firebase apps:sdkconfig ANDROID --project finance-app-260329-1505
```

Gunakan:
- `client_type: 1` (Android) sebagai `GOOGLE_CLIENT_ID`
- `client_type: 3` (Web) sebagai `GOOGLE_SERVER_CLIENT_ID`

Contoh pada project `finance-app-260329-1505`:
- `GOOGLE_CLIENT_ID`: `609148169375-keaga5dbjj53si9n98258ld6s3m4i500.apps.googleusercontent.com`
- `GOOGLE_SERVER_CLIENT_ID`: `609148169375-v8m0oiutp3te7rio3848fp7tadriv5ri.apps.googleusercontent.com`

7. Untuk build lokal/manual, kirim `dart-define`:

```bash
flutter build apk --release \
  --dart-define=GOOGLE_CLIENT_ID=<your_google_client_id> \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=<your_google_server_client_id>
```

8. Pastikan akun tester sudah diizinkan pada OAuth consent screen jika status app masih testing.

## Troubleshooting `PlatformException(sign_in_failed, ... 10 ...)`

Error code `10` (`DEVELOPER_ERROR`) hampir selalu berarti mismatch konfigurasi OAuth/SHA-1.

Checklist perbaikan:

1. Verifikasi SHA-1 debug/release:

```bash
cd android
./gradlew signingReport
```

2. Tambahkan semua SHA-1 yang relevan ke Firebase Android App yang dipakai.
3. Pastikan OAuth Client Android di Google Cloud memakai:
   - Package name yang sama dengan aplikasi.
   - SHA-1 yang sama persis dengan hasil `signingReport`.
4. Pastikan `google-services.json` (jika digunakan) berasal dari project Firebase yang sama.
5. Untuk pipeline release repo ini, package name saat generate Android default-nya `com.financeapp.fin_sage` (atau `<ANDROID_APP_ORG>.fin_sage` jika variable diisi), jadi OAuth/Firebase harus cocok dengan package itu.
