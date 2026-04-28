# Google Sign-In Go-Live Checklist (Android)

Gunakan checklist ini setiap kali login Google gagal dengan error `10` / `DEVELOPER_ERROR`.

## 1. Pastikan identitas build release

- [ ] Buka `GitHub Actions > FinSage Release` run terbaru.
- [ ] Cek `Step Summary` untuk nilai:
  - `Android package (applicationId)`
  - `Release keystore SHA-1`
  - `Release keystore SHA-256`
- [ ] Atau download artifact `google-signin-release-metadata`.

## 2. Sinkronisasi Firebase

- [ ] Firebase Console > Project Settings > Your apps > Android app.
- [ ] `Android package name` sama persis dengan `applicationId` release.
- [ ] Tambahkan fingerprint:
  - SHA-1 release
  - SHA-256 release
- [ ] Jika pakai build debug lokal, tambahkan SHA debug juga.

## 3. Sinkronisasi Google Cloud OAuth

- [ ] Google Cloud Console > APIs & Services > Credentials.
- [ ] OAuth 2.0 Client ID tipe Android:
  - package name = `applicationId` release
  - SHA-1 = SHA-1 release
- [ ] OAuth 2.0 Client ID tipe Web dipakai sebagai `GOOGLE_SERVER_CLIENT_ID`.

## 4. Sinkronisasi secret repository

- [ ] `GOOGLE_CLIENT_ID` di GitHub Secrets terisi.
- [ ] `GOOGLE_SERVER_CLIENT_ID` di GitHub Secrets terisi.
- [ ] `ANDROID_APP_ORG` di GitHub Variables sesuai organisasi package.
- [ ] Jika `ANDROID_APP_ORG` berubah, update Firebase + OAuth agar tetap match.

## 5. Validasi pasca-rilis

- [ ] Install APK release terbaru.
- [ ] Login Google berhasil (tanpa error `10`).
- [ ] Backup Drive berhasil.
- [ ] Restore preview berhasil.

## 6. Pola error umum

- `sign_in_failed ... 10`:
  - hampir pasti mismatch package/SHA/OAuth.
- Login sukses di debug tapi gagal di release:
  - SHA release belum didaftarkan.
- Login gagal hanya dari APK Play Store:
  - SHA App Signing Play belum didaftarkan ke Firebase/OAuth.
