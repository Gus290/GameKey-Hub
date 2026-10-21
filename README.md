# GameKey Hub Android (.apk) — Flutter DEMO

โปรเจกต์ Flutter สำหรับสร้างแอป Android แจกคีย์เกมผ่านมือถือ (ตัวอย่างทำงานแบบออฟไลน์)

## Build APK

1. ติดตั้ง Flutter SDK + Android SDK และเปิดโฟลเดอร์นี้ใน VS Code
2. เปิด Terminal แล้วรัน:

```powershell
flutter doctor
flutter pub get
flutter build apk --debug
```

ไฟล์จะอยู่ที่ `build/app/outputs/flutter-apk/app-debug.apk`

หรือถ้าต้องการทดสอบบนเครื่อง Android ที่เชื่อม USB:

```powershell
flutter run
```

## ข้อจำกัดสำคัญ
- ตัวอย่างนี้ยังไม่เชื่อมฐานข้อมูลจริงและไม่มีระบบบัญชีผู้ใช้
- คีย์ DEMO เป็นคีย์สมมติ ใช้เปิดเกมไม่ได้
- รายการคีย์และประวัติอยู่ในหน่วยความจำ รีเซ็ตเมื่อเปิดแอปใหม่
- ก่อนแจกคีย์จริงต้องใช้ Backend จัดสรรคีย์อย่างปลอดภัยและระบบยืนยันตัวตน
- ไม่ได้ Build APK ในสภาพแวดล้อมนี้เพราะไม่มี Flutter/Android SDK ให้ใช้งาน
