# TOR Generator

เว็บฟอร์มสำหรับจัดทำ TOR/SoW และ export เอกสารจากหน้า `index.html`

## เปิดใช้งานในเครื่อง

เปิด `index.html` ใน browser ได้ทันที หรือใช้ static server ภายในทีม

## Deploy ด้วย GitHub Pages

repo นี้เตรียม workflow ไว้แล้วที่ `.github/workflows/deploy-pages.yml`

1. ไปที่ GitHub repo `Settings > Pages`
2. ที่ `Build and deployment` เลือก `Source: GitHub Actions`
3. push ขึ้น branch `main`
4. รอ workflow `Deploy GitHub Pages` ทำงานเสร็จ
5. GitHub จะสร้าง URL สำหรับใช้งานหน้าเว็บให้

## หมายเหตุสำหรับทีม

- ข้อมูล Draft ถูกเก็บใน `localStorage` ของ browser แต่ละคน
- ค่า Anthropic API Key ถูกเก็บใน browser ของแต่ละคนเช่นกัน
- ถ้าจะใช้ปุ่ม AI แต่ละคนควรใช้ API Key ของตัวเอง
- ไม่ควร hardcode API Key ลงใน `index.html`

## อัปเดตงานขึ้น repo

```powershell
git add .
git commit -m "update site"
git push
```
