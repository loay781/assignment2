# نظام المصادقة الطلابي — MVC + Repository

مشروع Flutter/Dart ينفذ نظام المصادقة بنمط MVC المعزز بنمط المستودع، مع تحقق صارم من النماذج، ويتضمن أيضًا إعادة تنفيذ تطبيق العداد التفاعلي مرتين للمقارنة بين GetX وModern Riverpod 2.x.

## التكليف الأول — مقارنة إدارة الحالة

من شاشة الدخول اضغط «تجربة تطبيق العداد وإدارة الحالة». ستجد تبويبين مستقلين: الأول يستخدم `GetxController` و`Rx` و`Obx`، والثاني يستخدم `Notifier` و`Consumer` من Riverpod 2.x. كل نسخة تدعم الزيادة والنقصان وإعادة التعيين وتشغيل/إيقاف المؤقت، كما تسجل حالة دورة حياة التطبيق وتوقف المؤقت عند مغادرة التطبيق.

## التشغيل

1. ثبّت Flutter SDK ثم نفّذ داخل مجلد المشروع:

```bash
flutter pub get
flutter run
```

2. افتح المشروع في Android Studio أو VS Code واختر جهاز Android/Emulator.

## بيانات التجربة

- البريد: `student@university.edu`
- الرقم الأكاديمي: `123456789`
- كلمة المرور: `Student1`
- رمز OTP التجريبي: `123456`

يمكن أيضًا إنشاء مستخدم جديد من شاشة التسجيل؛ البيانات تحفظ في الذاكرة لمحاكاة الشبكة فقط.

## الهيكل

- `lib/models/`: `UserModel` وطلبات Login/Register/Reset.
- `lib/repositories/`: العقد `AuthRepository` والتطبيق `AuthRepositoryImpl` مع محاكاة تأخير الشبكة.
- `lib/controllers/`: `AuthController extends ChangeNotifier` وإدارة التحميل والأخطاء.
- `lib/utils/`: `FormValidators` للتحقق النقي والقابل لإعادة الاستخدام.
- `lib/views/auth/`: الشاشات الأربع وودجات الواجهة المشتركة.
- `lib/controllers/getx_counter_controller.dart`: منطق العداد باستخدام GetX.
- `lib/controllers/riverpod_counter_notifier.dart`: منطق العداد باستخدام Riverpod Notifier.
- `lib/views/counter_comparison_page.dart`: شاشتا العداد داخل تبويبين للمقارنة.

## الشاشات

1. LoginPage: تسجيل الدخول، تذكرني، إظهار/إخفاء كلمة المرور، وروابط التنقل.
2. RegisterPage: الاسم، الرقم، البريد، سياسة كلمة المرور، المطابقة والموافقة على الشروط.
3. ForgotPasswordPage: إرسال رمز التحقق مع رسالة نجاح والتنقل التلقائي.
4. ResetPasswordPage: OTP، كلمة المرور الجديدة، نافذة نجاح والعودة لتسجيل الدخول.

> ملاحظة أكاديمية: طبقة المستودع الحالية محاكاة محلية كما طلب التكليف، ويمكن استبدالها لاحقًا بطلبات API دون تعديل الواجهات أو المتحكم.
