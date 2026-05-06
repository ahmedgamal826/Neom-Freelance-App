import 'package:flutter/material.dart';

/// AR/EN strings keyed by [Locale.languageCode] (used with [LocaleProvider]).
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  bool get _isAr => locale.languageCode == 'ar';

  // —— Sign in ——
  String get signInTitle => _isAr ? 'تسجيل الدخول' : 'Sign in';
  String get emailHint => _isAr ? 'البريد الالكتروني' : 'Email';
  String get emailRequired => _isAr
      ? 'الرجاء ادخال بريدك الالكتروني'
      : 'Please enter your email';
  String get emailInvalid => _isAr
      ? 'الرجاء ادخال بريد الكتروني صحيح'
      : 'Please enter a valid email';
  String get passwordHint => _isAr ? 'كلمة المرور' : 'Password';
  String get passwordRequired => _isAr
      ? 'كلمة المرور يجب الا تكون فارغة'
      : 'Password cannot be empty';
  String get passwordMinLength => _isAr
      ? 'يجب ان تكون كلمة المرور على الأقل 8 حروف'
      : 'Password must be at least 8 characters';
  String get signingIn => _isAr ? 'جاري الدخول...' : 'Signing in...';
  String get signInButton => _isAr ? 'تسجيل الدخول' : 'Sign in';
  String get signInFailed => _isAr
      ? 'فشل تسجيل الدخول. تأكد من البريد وكلمة المرور.'
      : 'Sign-in failed. Check your email and password.';
  String get orDivider => _isAr ? 'او' : 'or';
  String get googleSignInFailed => _isAr
      ? 'تعذر تسجيل الدخول عبر Google. تحقق من إعدادات Firebase.'
      : 'Google sign-in failed. Check your Firebase setup.';
  String get signInWithGoogle => _isAr
      ? 'تسجيل الدخول باستخدام Google'
      : 'Sign in with Google';
  String get createAccount => _isAr ? 'انشاء حساب' : 'Create account';

  // —— Sign up ——
  String get signUpTitle => _isAr ? 'انشاء الحساب' : 'Create account';
  String get firstNameHint => _isAr ? 'الاسم الاول' : 'First name';
  String get firstNameRequired => _isAr
      ? 'الرجاء ادخال اسمك الاول'
      : 'Please enter your first name';
  String get secondNameHint => _isAr ? 'الاسم الثاني' : 'Last name';
  String get secondNameRequired => _isAr
      ? 'الرجاء ادخال اسمك الثاني'
      : 'Please enter your last name';
  String get createAccountButton => _isAr ? 'انشاء حساب' : 'Create account';
  String get signInNav => _isAr ? 'تسجيل الدخول' : 'Sign in';

  // —— Home / navigation ——
  String get navHome => _isAr ? 'الرئيسية' : 'Home';
  String get navLeaders => _isAr ? 'قادة نيوم' : 'NEOM Leaders';
  String get navImages => _isAr ? 'الصور' : 'Images';
  String get navChat => _isAr ? 'شاشة الدردشة' : 'Chat';
  String get signOut => _isAr ? 'تسجيل الخروج' : 'Sign out';

  /// Home timeline section heading.
  String get ourJourney => _isAr ? 'رحلتنا' : 'OUR JOURNEY';

  // —— About Neom screen ——
  String get aboutNeomTitle => _isAr ? 'عن نيوم' : 'About Neom';
  String get aboutNeomHeroSubtitle => _isAr
      ? 'رؤية طموحة لبناء مدن المستقبل بالابتكار والاستدامة'
      : 'An ambitious vision to build the cities of the future through '
          'innovation and sustainability';
  String get aboutWhatIsNeom => _isAr ? 'ما هي نيوم؟' : 'What is NEOM?';
  String get aboutWhatIsNeomBody => _isAr
      ? 'نيوم مشروع عملاق ورؤيوي أطلقته المملكة العربية السعودية كجزء من '
          'مبادرة رؤية 2030؛ يهدف إلى إنشاء بيئة حضرية ذكية مستدامة تعتمد على '
          'أحدث التقنيات وتوفر جودة حياة استثنائية.'
      : 'NEOM is a giant and visionary project launched by the Kingdom of '
          'Saudi Arabia as part of the Vision 2030 initiative; it aims to '
          'create a sustainable smart urban environment that relies on the '
          'latest technologies and provides an exceptional quality of life.';
  String get tagEconomicGrowth =>
      _isAr ? 'النمو الاقتصادي' : 'Economic growth';
  String get tagInnovation => _isAr ? 'الابتكار' : 'Innovation';
  String get tagStrategicLocation =>
      _isAr ? 'الموقع الاستراتيجي' : 'Strategic location';
  String get tagSustainability => _isAr ? 'الاستدامة' : 'Sustainability';
  String get aboutWhyNeom => _isAr ? 'لماذا نيوم؟' : 'Why NEOM?';
  String get aboutNeoMeaning => _isAr
      ? 'كلمة يونانية تعني "جديد"'
      : 'A Greek word meaning "new"';
  String get aboutMMeaning =>
      _isAr ? 'ترمز إلى "مستقبل"' : 'Symbolizes "future"';

  // —— NEOM Leaders page ——
  String get leadersPageFooter => _isAr
      ? 'أكبر مشروع في العالم يحتاج إلى بعض من أكثر الأشخاص موهبة في العالم. '
          'لهذا السبب يتكون فريق قيادة نيوم من مبتكرين ورؤيويين يعملون بطريقة مختلفة.'
      : 'The world\'s largest project needs some of the most talented people in '
          'the world. For this reason, the NEOM leadership team consists of '
          'innovators and visionaries who work in a different way.';

  // —— Chat page ——
  String get chatRagTitle =>
      _isAr ? 'شات بوت نيوم' : 'NEOM Chatbot';
  String get chatPrepareModelSubtitle => _isAr
      ? 'جهّز المودل أولاً ثم ابدأ المحادثة'
      : 'Prepare the model first, then start the conversation';
  String get chatServerOnline => _isAr ? 'السيرفر متصل' : 'Server connected';
  String get chatServerOffline =>
      _isAr ? 'السيرفر غير متصل' : 'Server disconnected';
  String get chatTapCheckFirst => _isAr
      ? 'اضغط على "فحص اتصال السيرفر" أولاً.'
      : 'Tap "Check server connection" first.';
  String get chatCheckingServer => _isAr
      ? 'جاري التحقق من حالة الخادم...'
      : 'Checking server status...';
  String get chatModelReadyTapLoad => _isAr
      ? 'المودل جاهز على السيرفر. اضغط "تحميل المودل" للدخول إلى الشات.'
      : 'The model is ready on the server. Tap "Load model" to open chat.';
  String get chatServerOkTapLoadModel => _isAr
      ? 'الخادم متصل. اضغط "تحميل المودل" لبدء تحميل النموذج.'
      : 'Server is connected. Tap "Load model" to start loading the model.';
  String get chatCheckServerConnection => _isAr
      ? 'فحص اتصال السيرفر'
      : 'Check server connection';
  String get chatLoadModel => _isAr ? 'تحميل المودل' : 'Load model';
  String get chatLoading => _isAr ? 'جاري التحميل...' : 'Loading...';
  String get chatLoadingModelWait => _isAr
      ? 'جاري تحميل المودل، قد يستغرق ذلك عدة دقائق...'
      : 'Loading the model; this may take several minutes...';
  String get chatOpeningChat => _isAr
      ? 'المودل كان محملاً بالفعل. جاري فتح شاشة المحادثة...'
      : 'The model was already loaded. Opening chat...';
  String get chatServerOfflineCheckFirst => _isAr
      ? 'السيرفر غير متصل. نفّذ فحص الاتصال أولاً.'
      : 'Server is offline. Run a connection check first.';
  String get chatServerConnectedGenerating => _isAr
      ? 'الخادم متصل - جاري توليد الرد...'
      : 'Server connected — generating reply...';
  String get chatServerConnectedReady => _isAr
      ? 'الخادم متصل - المودل محمل وجاهز للمحادثة'
      : 'Server connected — model loaded and ready to chat';
  String get chatInputHint => _isAr
      ? 'اكتب سؤالك عن نيوم...'
      : 'Ask your question about NEOM...';
  String get chatCurrentUserName => _isAr ? 'المستخدم' : 'User';
  String get chatWelcomeMessage => _isAr
      ? 'مرحباً بك! أنا مساعد نيوم الذكي. اسألني أي سؤال متعلق بمشروع NEOM.'
      : 'Welcome! I am the NEOM smart assistant. Ask me anything about the NEOM project.';
  String chatSendError(Object error) => _isAr
      ? 'حدث خطأ أثناء التواصل مع الخادم: $error'
      : 'An error occurred while contacting the server: $error';

  String get chatErrorServerConnectionTimeout => _isAr
      ? 'انتهت مهلة الاتصال بالسيرفر. تحقق من الشبكة أو من حالة الخادم.'
      : 'The connection to the server timed out. Check your network or the '
          'server status.';
  String get chatErrorLoadModelTimeout => _isAr
      ? 'تحميل المودل استغرق وقتاً أطول من المتوقع. قد يكون التحميل ما زال جارياً على الخادم.'
      : 'Loading the model took longer than expected. It may still be running '
          'on the server.';
  String get chatErrorSendMessageTimeout => _isAr
      ? 'انتهت مهلة إرسال الرسالة. حاول مجدداً.'
      : 'Sending the message timed out. Please try again.';

  String chatModelLoadSummary(
    String apiMessage,
    String modelName,
    int questionsCount,
  ) {
    final modelLabel = _isAr ? 'المودل' : 'Model';
    final qLabel = _isAr ? 'عدد الأسئلة' : 'Questions';
    return '$apiMessage\n$modelLabel: $modelName\n$qLabel: $questionsCount';
  }
}
