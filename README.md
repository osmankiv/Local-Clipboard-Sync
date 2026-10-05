# 📋 Local Clipboard Sync (الحافظة المحلية)

نظام سريعة ومباشر لمزامنة النص المنسوخ (Clipboard) من حاسوب Windows إلى تطبيق أندرويد عبر **الشبكة المحلية (Local Wi-Fi)** فورًا وبدون الحاجة لخدمات سحابية أو تطبيقات خارجية.

---

## 🚀 المميزات الرئيسية

* **مزامنة فورية**: بمجرد نسخ أي نص على الحاسوب (`Ctrl + C`) يتم إرساله فورًا للهاتف.
* **نسخ تلقائي**: يستقبل تطبيق الهاتف النص ويضعه مباشرة في الحافظة (Clipboard) لتسهيل الترجمة أو اللصق.
* **محلي وآمن 100%**: يعمل بالكامل داخل شبكة الـ Wi-Fi المحلية دون الحاجة لاتصال بالإنترنت.
* **بدون خوادم خارجية**: تعتمد البنية الأساسية على خادم HTTP خفيف مبني داخل التطبيق وخوادم CMD/PowerShell خفيفة.

---

## 📁 هيكلية المشروع (Project Structure)

```text
.
├── desktop/
│   └── sync.bat          # سكريبت CMD/PowerShell لمراقبة الحافظة وإرسال النصوص
└── mobile/
    ├── lib/
    │   └── main.dart     # تطبيق Flutter لمراقبة المنفذ 8080 ونسخ النص للحافظة
    └── pubspec.yaml
```
## 🛠️ متطلبات التشغيل (Prerequisites)
على الحاسوب: نظام تشغيل Windows مفعل به PowerShell وcurl.

على الهاتف: نظام أندرويد مع تفعيل الاتصال بنفس شبكة الـ Wi-Fi المتصل بها الحاسوب.
سكريبت الحاسوب (Desktop Script)
افتح ملف desktop/sync.bat.

قم بتعديل متغير الـ IP ليكون مطابقًا لعنوان IP هاتفك الظاهر في التطبيق:

DOS
set "PHONE_IP=10.168.253.243"
قم بتشغيل ملف sync.bat.

ابدأ بنسخ أي نص من ملفات الـ PDF أو المتصفح، وسيصل فورًا إلى حافظة هاتفك!

🧰 التقنيات المستخدمة (Tech Stack)
Mobile App: Flutter, shelf (HTTP Server), network_info_plus.

Desktop Script: Windows CMD, PowerShell (Get-Clipboard, Invoke-RestMethod).

📄 الترخيص (License)
هذا المشروع مرخص بموجب رخصة MIT.


---

<ElicitationsGroup message="إذا كنت تريد تخصيص هذا الملف بشكل أكبر:">
  <Elicitation label="إضافة شارات (Badges) توضح تقنيات المشروع وصوره" query="أضف شارات GitHub Badges وشاشة توضيحية (Screenshots Section) إلى ملف الـ README."/>
  <Elicitation label="توليد ملف README باللغة الإنجليزية كاملة" query="قم بترجمة وتنسيق ملف README هذا باللغة الإنجليزية للمستودعات العالمية."/>
</ElicitationsGroup>
