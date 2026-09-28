import 'app_localizations.dart';

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get splashTagline => 'စက္ကန့်ပိုင်းအတွင်း ကွင်းဘိုကင်လုပ်ပါ';

  @override
  String get splashSettingUp => 'သင့်အကောင့်ကို ပြင်ဆင်နေသည်…';

  @override
  String get splashLoadingAccount => 'သင့်အကောင့်ကို ဖွင့်နေသည်';

  @override
  String get splashLoadError => 'သင့်အကောင့်ကို ဖွင့်၍မရပါ';

  @override
  String get commonTryAgain => 'ထပ်ကြိုးစားပါ';

  @override
  String get commonRetry => 'ပြန်စမ်းပါ';

  @override
  String get commonSeeAll => 'အားလုံးကြည့်ရန်';

  @override
  String get commonLoading => 'ဖွင့်နေသည်';

  @override
  String get commonContinue => 'ဆက်လုပ်ရန်';

  @override
  String get commonSaveChanges => 'ပြောင်းလဲမှုများ သိမ်းရန်';

  @override
  String get commonDiscard => 'မသိမ်းတော့ပါ';

  @override
  String get commonKeepEditing => 'ဆက်ပြင်မည်';

  @override
  String get commonDiscardTitle => 'ပြောင်းလဲမှုများကို ပယ်ဖျက်မလား?';

  @override
  String get commonNotAdded => 'မထည့်ရသေးပါ';

  @override
  String get languageTitle => 'ဘာသာစကား';

  @override
  String get languageSubtitle => 'အက်ပ်ဘာသာစကား ရွေးပါ';

  @override
  String get languageMyanmar => 'မြန်မာ';

  @override
  String get languageEnglish => 'English';

  @override
  String get demoBanner => 'နမူနာဒေတာ · အစမ်းကြည့်ရန်သာ၊ ပြောင်းလဲမှုများ မသိမ်းပါ';

  @override
  String previewOnly(String action) {
    return '$action · အစမ်းကြည့်ရန်သာ၊ ဘာမှမသိမ်းထားပါ';
  }

  @override
  String get logOut => 'ထွက်ရန်';

  @override
  String get logOutConfirmTitle => 'အကောင့်မှ ထွက်မလား?';

  @override
  String get logOutConfirmMessage => 'အက်ပ်ကို ပြန်သုံးရန် ထပ်မံဝင်ရောက်ရပါမည်။';

  @override
  String get stayLoggedIn => 'ဆက်ဝင်ထားမည်';

  @override
  String get signOut => 'ထွက်ရန်';

  @override
  String get accountUnavailableTitle => 'အကောင့် အသုံးမပြုနိုင်ပါ';

  @override
  String get accountDisabledMessage => 'သင့်အကောင့်ကို ပိတ်ထားပါသည်။ အမှားဖြစ်သည်ဟု ထင်ပါက အကူအညီဌာနသို့ ဆက်သွယ်ပါ။';

  @override
  String get accountMissingShopMessage => 'သင့်ဆိုင်ဝင်ခွင့် မပြင်ဆင်ရသေးပါ။ ပလက်ဖောင်းအဖွဲ့ကို ဆက်သွယ်ပါ။';

  @override
  String get passwordLabel => 'စကားဝှက်';

  @override
  String get showPassword => 'စကားဝှက် ပြရန်';

  @override
  String get hidePassword => 'စကားဝှက် ဖျောက်ရန်';

  @override
  String get searchHint => 'ရှာရန်';

  @override
  String get errorOfflineTitle => 'အင်တာနက် မရှိပါ';

  @override
  String get errorNoAccessTitle => 'ဝင်ခွင့် မရှိပါ';

  @override
  String get errorNotFoundTitle => 'ရှာမတွေ့ပါ';

  @override
  String get errorGenericTitle => 'တစ်ခုခု မှားယွင်းသွားပါသည်';

  @override
  String get errAuthentication => 'ဆက်လက်လုပ်ဆောင်ရန် ထပ်မံဝင်ရောက်ပါ။';

  @override
  String get errInvalidCredentials => 'အီးမေးလ် သို့မဟုတ် စကားဝှက် မှားနေပါသည်။';

  @override
  String get errInvalidEmail => 'မှန်ကန်သော အီးမေးလ်လိပ်စာ ထည့်ပါ။';

  @override
  String get errEmailInUse => 'ဤအီးမေးလ်ဖြင့် အကောင့်ရှိပြီးသား ဖြစ်ပါသည်။ ဝင်ရောက်မလား?';

  @override
  String get errWeakPassword => 'အနည်းဆုံး စာလုံး ၈ လုံး သုံးပါ။';

  @override
  String get errTooManyRequests => 'ကြိုးစားမှု များလွန်းပါသည်။ မိနစ်အနည်းငယ်အကြာတွင် ထပ်ကြိုးစားပါ။';

  @override
  String get errIncorrectPassword => 'လက်ရှိစကားဝှက် မှားနေပါသည်။';

  @override
  String get errSetupTimeout => 'သင့်အကောင့် ဖွင့်၍မပြီးပါ။ အင်တာနက်ချိတ်ဆက်မှုကို စစ်ပြီး ထပ်ကြိုးစားပါ။';

  @override
  String get errUnauthorizedRole => 'ဤအကောင့်သည် အက်ပ်ကို သုံးခွင့်မရှိပါ။ အကူအညီဌာနသို့ ဆက်သွယ်ပါ။';

  @override
  String get errPermissionDenied => 'ဤလုပ်ဆောင်ချက်ကို လုပ်ခွင့်မရှိပါ။';

  @override
  String get errNetwork => 'အင်တာနက် မရှိပါ။ ချိတ်ဆက်မှုကို စစ်ပြီး ထပ်ကြိုးစားပါ။';

  @override
  String get errNotFound => 'ရှာနေသည့်အရာကို ရှာမတွေ့ပါ။';

  @override
  String get errInvalidVenueDetails => 'အချက်အလက်အချို့ မမှန်ကန်ပါ။ ဖောင်ကို စစ်ပြီး ထပ်ကြိုးစားပါ။';

  @override
  String get errShopAdminAssignment => 'ဤအကောင့်ကို ဆိုင်စီမံသူအဖြစ် သတ်မှတ်၍မရပါ။';

  @override
  String get errBookingConflict => 'ထိုအချိန်ကို အခြားသူ ဘိုကင်လုပ်သွားပြီ ဖြစ်ပါသည်။ အခြားအချိန် ရွေးပါ။';

  @override
  String get errCourtUnavailable => 'ဤကွင်းကို ယခု ဘိုကင်လုပ်၍ မရပါ။';

  @override
  String get errStadiumUnavailable => 'ဤအားကစားကွင်းကို ယခု ဘိုကင်လုပ်၍ မရပါ။';

  @override
  String get errShopUnavailable => 'ဤနေရာသည် ယခု ဘိုကင် လက်မခံပါ။';

  @override
  String get errInvalidBookingTime => 'ထိုအချိန်ကို ဘိုကင်လုပ်၍မရပါ။ ဖွင့်ချိန်ကို စစ်ပြီး အခြားအချိန် ရွေးပါ။';

  @override
  String get errBookingTooLong => 'တစ်ကြိမ်လျှင် အချိန်အပိုင်း ၄ ခုအထိသာ ဘိုကင်လုပ်နိုင်ပါသည်။';

  @override
  String get errProfileIncomplete => 'ဘိုကင်မလုပ်မီ ပရိုဖိုင်တွင် သင့်အမည် ထည့်ပါ။';

  @override
  String get errInvalidBookingChange => 'ဤဘိုကင်ကို ထိုသို့ ပြောင်းလဲ၍ မရတော့ပါ။';

  @override
  String get errInvalidDate => 'ထိုရက်ကို ဘိုကင်လုပ်၍မရပါ။ အခြားရက် ရွေးပါ။';

  @override
  String get errServer => 'ကျွန်ုပ်တို့ဘက်တွင် အမှားဖြစ်သွားပါသည်။ ထပ်ကြိုးစားပါ။';

  @override
  String get errUnknown => 'တစ်ခုခု မှားယွင်းသွားပါသည်။ ထပ်ကြိုးစားပါ။';

  @override
  String get valNameRequired => 'အမည် ထည့်ပါ';

  @override
  String get valNameTooLong => 'စာလုံး ၈၀ ထက် မပိုပါစေနှင့်';

  @override
  String get valEmailRequired => 'အီးမေးလ် ထည့်ပါ';

  @override
  String get valEmailInvalid => 'မှန်ကန်သော အီးမေးလ်လိပ်စာ ထည့်ပါ';

  @override
  String get valPhoneInvalid => 'မှန်ကန်သော ဖုန်းနံပါတ် ထည့်ပါ';

  @override
  String get valPasswordRequired => 'စကားဝှက် ထည့်ပါ';

  @override
  String get valPasswordTooShort => 'အနည်းဆုံး စာလုံး ၈ လုံး သုံးပါ';

  @override
  String get valCurrentPasswordRequired => 'လက်ရှိစကားဝှက် ထည့်ပါ';

  @override
  String get valPasswordSame => 'လက်ရှိစကားဝှက်နှင့် မတူသော စကားဝှက်ကို ရွေးပါ';

  @override
  String get navHome => 'ပင်မ';

  @override
  String get navExplore => 'ရှာဖွေရန်';

  @override
  String get navBookings => 'ဘိုကင်များ';

  @override
  String get navNotifications => 'အသိပေးချက်';

  @override
  String get navProfile => 'ပရိုဖိုင်';

  @override
  String get navDashboard => 'ဒက်ရှ်ဘုတ်';

  @override
  String get navStadiums => 'အားကစားကွင်း';

  @override
  String get navCustomers => 'ဖောက်သည်များ';

  @override
  String get navSettings => 'ဆက်တင်';

  @override
  String get navShops => 'ဆိုင်များ';

  @override
  String navBadgeNew(String label, int count) {
    return '$label၊ အသစ် $count ခု';
  }

  @override
  String get bookingPending => 'စောင့်ဆိုင်းဆဲ';

  @override
  String get bookingConfirmed => 'အတည်ပြုပြီး';

  @override
  String get bookingRejected => 'ငြင်းပယ်ထား';

  @override
  String get bookingCancelled => 'ပယ်ဖျက်ပြီး';

  @override
  String get bookingCompleted => 'ပြီးဆုံးပြီး';

  @override
  String get paymentUnpaid => 'မပေးချေရသေး';

  @override
  String get paymentPending => 'ငွေပေးချေမှု စောင့်ဆိုင်းဆဲ';

  @override
  String get paymentPaid => 'ပေးချေပြီး';

  @override
  String get paymentRefunded => 'ငွေပြန်အမ်းပြီး';

  @override
  String get shopPendingReview => 'စိစစ်ရန် စောင့်ဆိုင်းဆဲ';

  @override
  String get shopActive => 'အသုံးပြုနေ';

  @override
  String get shopSuspended => 'ဆိုင်းငံ့ထား';

  @override
  String get shopRejected => 'ငြင်းပယ်ထား';

  @override
  String get shopInactive => 'ရပ်နားထား';

  @override
  String get shopListed => 'ပြသထား';

  @override
  String get shopUnlisted => 'မပြသထား';

  @override
  String get bookingStatusPrefix => 'ဘိုကင် အခြေအနေ';

  @override
  String get paymentStatusPrefix => 'ငွေပေးချေမှု အခြေအနေ';

  @override
  String get facilityParking => 'ကားပါကင်';

  @override
  String get facilityShower => 'ရေချိုးခန်း';

  @override
  String get facilityChangingRoom => 'အဝတ်လဲခန်း';

  @override
  String get facilityDrinkingWater => 'သောက်ရေ';

  @override
  String get facilityFloodLights => 'မီးမောင်းများ';

  @override
  String get facilitySeating => 'ထိုင်ခုံ';

  @override
  String get facilityRestroom => 'အိမ်သာ';

  @override
  String get facilityCafe => 'ကော်ဖီဆိုင်';

  @override
  String get facilityEquipmentRental => 'ပစ္စည်းငှားရမ်းခြင်း';

  @override
  String get reasonMaintenance => 'ပြုပြင်ထိန်းသိမ်းမှု';

  @override
  String get reasonPrivateEvent => 'သီးသန့်ပွဲ';

  @override
  String get reasonCleaning => 'သန့်ရှင်းရေး';

  @override
  String get reasonTournament => 'ပြိုင်ပွဲ';

  @override
  String get reasonTemporaryClosure => 'ယာယီပိတ်';

  @override
  String get reasonOther => 'အခြား';

  @override
  String get slotAvailable => 'ရနိုင်';

  @override
  String get slotSelected => 'ရွေးထား';

  @override
  String get slotBooked => 'ဘိုကင်ပြီး';

  @override
  String get slotBlocked => 'ပိတ်ထား';

  @override
  String get slotClosed => 'ပိတ်';

  @override
  String get slotUnavailable => 'မရနိုင်';

  @override
  String get dayToday => 'ယနေ့';

  @override
  String get dayTomorrow => 'မနက်ဖြန်';

  @override
  String get dayYesterday => 'မနေ့က';

  @override
  String durationMinutes(int minutes) {
    return '$minutes မိနစ်';
  }

  @override
  String get durationOneHour => '၁ နာရီ';

  @override
  String durationHours(String hours) {
    return '$hours နာရီ';
  }

  @override
  String get agoJustNow => 'ယခုလေးတင်';

  @override
  String agoMinutes(int count) {
    return '$count မိနစ်က';
  }

  @override
  String agoHours(int count) {
    return '$count နာရီက';
  }

  @override
  String agoDays(int count) {
    return '$count ရက်က';
  }

  @override
  String get loginHeadline => 'ပြန်လည်ကြိုဆိုပါသည်';

  @override
  String get loginSubtitle => 'နောက်ပွဲအတွက် ကွင်းဘိုကင်လုပ်ရန် ဝင်ရောက်ပါ။';

  @override
  String get emailLabel => 'အီးမေးလ်';

  @override
  String get forgotPasswordLink => 'စကားဝှက် မေ့နေပါသလား?';

  @override
  String get loginButton => 'ဝင်ရောက်ရန်';

  @override
  String get newHere => 'အသစ်လား?';

  @override
  String get createAccountLink => 'အကောင့်ဖွင့်ရန်';

  @override
  String get registerHeadline => 'အကောင့်ဖွင့်ပါ';

  @override
  String get registerSubtitle => 'ဖူဆယ်ကွင်းများကို အလွယ်တကူ ဘိုကင်လုပ်ပါ။';

  @override
  String get fullNameLabel => 'အမည်အပြည့်အစုံ';

  @override
  String get phoneOptionalLabel => 'ဖုန်းနံပါတ် (မထည့်လည်းရ)';

  @override
  String get phoneHelper => 'ဘိုကင်နှင့်ပတ်သက်၍ ကွင်းများက သင့်ကို ဆက်သွယ်ရန်';

  @override
  String get passwordHelper => 'အနည်းဆုံး စာလုံး ၈ လုံး';

  @override
  String get termsNote => 'ဆက်လုပ်ခြင်းဖြင့် စည်းမျဉ်းများနှင့် ကိုယ်ရေးအချက်အလက်မူဝါဒကို သဘောတူပါသည်။';

  @override
  String get venueOwnerNote => 'ဖူဆယ်ကွင်း ပိုင်ဆိုင်ပါသလား? ဆိုင်အကောင့်များကို ကျွန်ုပ်တို့အဖွဲ့က ဖွင့်ပေးပါသည် — ပါဝင်ရန် ဆက်သွယ်ပါ။';

  @override
  String get createAccountButton => 'အကောင့်ဖွင့်ရန်';

  @override
  String get haveAccount => 'အကောင့်ရှိပြီးသားလား?';

  @override
  String get forgotHeadline => 'စကားဝှက် ပြန်သတ်မှတ်ပါ';

  @override
  String get forgotSubtitle => 'သင့်အီးမေးလ် ထည့်ပါ၊ ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ပေးပါမည်။';

  @override
  String get sendResetLink => 'လင့်ခ် ပို့ရန်';

  @override
  String get backToLogin => 'ဝင်ရောက်ရန် စာမျက်နှာသို့';

  @override
  String get resetSentHeadline => 'အီးမေးလ် စစ်ကြည့်ပါ';

  @override
  String resetSentMessage(String email) {
    return '$email အတွက် အကောင့်ရှိပါက ပြန်သတ်မှတ်ရန် လင့်ခ် ပို့ထားပါသည်။';
  }

  @override
  String get resetResent => 'လင့်ခ် ထပ်ပို့ပြီးပါပြီ';

  @override
  String get resend => 'ထပ်ပို့ရန်';

  @override
  String resendIn(int seconds) {
    return '$seconds စက္ကန့်အကြာတွင် ထပ်ပို့နိုင်မည်';
  }

  @override
  String get profilePhone => 'ဖုန်း';

  @override
  String get editProfile => 'ပရိုဖိုင် ပြင်ရန်';

  @override
  String get changePassword => 'စကားဝှက် ပြောင်းရန်';

  @override
  String get addYourName => 'သင့်အမည် ထည့်ပါ';

  @override
  String get profileUpdated => 'ပရိုဖိုင် ပြင်ဆင်ပြီးပါပြီ';

  @override
  String get profileDiscardMessage => 'ပရိုဖိုင်တွင် ပြင်ထားသည်များ မသိမ်းပါ။';

  @override
  String get emailCantChange => 'ဤနေရာတွင် အီးမေးလ် ပြောင်း၍မရပါ';

  @override
  String get passwordUpdated => 'စကားဝှက် ပြောင်းပြီးပါပြီ';

  @override
  String get currentPasswordLabel => 'လက်ရှိစကားဝှက်';

  @override
  String get newPasswordLabel => 'စကားဝှက်အသစ်';

  @override
  String get updatePassword => 'စကားဝှက် ပြောင်းရန်';

  @override
  String get loadingProfile => 'ပရိုဖိုင် ဖွင့်နေသည်';

  @override
  String get profileNotReadyTitle => 'ပရိုဖိုင် မအဆင်သင့်သေးပါ';

  @override
  String get profileNotReadyMessage => 'ပုံမှန်ထက် ကြာနေပါသည်။ အင်တာနက်ကို စစ်ပြီး ထပ်ကြိုးစားပါ။';

  @override
  String homeGreeting(String name) {
    return 'မင်္ဂလာပါ $name';
  }

  @override
  String get homeReady => 'ကစားဖို့ အဆင်သင့်လား?';

  @override
  String get homeSearchHint => 'အားကစားကွင်း သို့မဟုတ် မြို့နယ် ရှာရန်';

  @override
  String get homeNextGame => 'နောက်ပွဲ';

  @override
  String get homeAllBookings => 'ဘိုကင်အားလုံး';

  @override
  String get homeNoGames => 'ဘိုကင် မရှိသေးပါ။ အောက်တွင် ကွင်းရွေးပါ။';

  @override
  String get homePopular => 'အနီးအနားရှိ လူကြိုက်များသော အားကစားကွင်းများ';

  @override
  String get exploreEmptyTitle => 'အားကစားကွင်း ရှာမတွေ့ပါ';

  @override
  String get exploreEmptyMessage => 'အခြားအမည်ဖြင့် ရှာပါ သို့မဟုတ် စစ်ထုတ်မှုကို ဖယ်ပါ။';

  @override
  String priceFromPerHour(String price) {
    return '$price/နာရီ မှစ၍';
  }

  @override
  String pricePerHour(String price) {
    return '$price/နာရီ';
  }

  @override
  String pricePerHourLong(String price) {
    return 'တစ်နာရီ $price';
  }

  @override
  String get priceOnRequest => 'ဈေးနှုန်း မေးမြန်းပါ';

  @override
  String get priceFrom => 'မှစ၍';

  @override
  String get bookACourt => 'ကွင်း ဘိုကင်လုပ်ရန်';

  @override
  String openDaily(String hours) {
    return 'နေ့စဉ် $hours ဖွင့်သည်';
  }

  @override
  String byShop(String shop) {
    return '$shop မှ';
  }

  @override
  String get facilitiesTitle => 'ဝန်ဆောင်မှုများ';

  @override
  String get courtsTitle => 'ကွင်းများ';

  @override
  String upToPlayers(int count) {
    return 'ကစားသမား $count ဦးအထိ';
  }

  @override
  String slotLengthLabel(int minutes) {
    return '$minutes မိနစ် အပိုင်းများ';
  }

  @override
  String get courtLabel => 'ကွင်း';

  @override
  String get dayLabel => 'နေ့';

  @override
  String get pickStartTime => 'စတင်ချိန် ရွေးပါ';

  @override
  String slotRules(int max, int minutes, String price) {
    return 'ဆက်တိုက် $minutes မိနစ် အပိုင်း $max ခုအထိ · $price/နာရီ';
  }

  @override
  String get reviewTitle => 'ဘိုကင် စစ်ဆေးရန်';

  @override
  String get reviewNothingTitle => 'စစ်ဆေးစရာ မရှိပါ';

  @override
  String get reviewNothingMessage => 'ကွင်းနှင့် အချိန် အရင်ရွေးပါ။';

  @override
  String get reviewPickTime => 'အချိန် ရွေးရန်';

  @override
  String requestBookingButton(String total) {
    return 'ဘိုကင် တောင်းဆိုရန် · $total';
  }

  @override
  String get bookingRequestAction => 'ဘိုကင် တောင်းဆိုမှု';

  @override
  String get dateLabel => 'ရက်စွဲ';

  @override
  String get timeLabel => 'အချိန်';

  @override
  String get totalLabel => 'စုစုပေါင်း';

  @override
  String get payAtVenueNote => 'ကွင်းတွင် ငွေပေးချေပါ။ ဆိုင်က သင့်တောင်းဆိုမှုကို များသောအားဖြင့် နာရီအနည်းငယ်အတွင်း အတည်ပြုပေးပါသည်။';

  @override
  String get confirmTitle => 'ဘိုကင် တောင်းဆိုပြီးပါပြီ';

  @override
  String confirmMessage(String stadium) {
    return '$stadium က အတည်ပြုသည်နှင့် အကြောင်းကြားပေးပါမည်။';
  }

  @override
  String get totalPayAtVenue => 'စုစုပေါင်း · ကွင်းတွင် ပေးချေရန်';

  @override
  String get viewBooking => 'ဘိုကင် ကြည့်ရန်';

  @override
  String get backToHome => 'ပင်မသို့ ပြန်ရန်';

  @override
  String tabUpcoming(int count) {
    return 'လာမည့် ($count)';
  }

  @override
  String tabPast(int count) {
    return 'ပြီးခဲ့သော ($count)';
  }

  @override
  String get emptyUpcomingTitle => 'လာမည့်ပွဲ မရှိပါ';

  @override
  String get emptyUpcomingMessage => 'ကွင်းဘိုကင်လုပ်ပါက ဤနေရာတွင် ပေါ်ပါမည်။';

  @override
  String get emptyPastTitle => 'ယခင်ဘိုကင် မရှိပါ';

  @override
  String get emptyPastMessage => 'ကစားခဲ့သောပွဲများ ဤနေရာတွင် ပေါ်ပါမည်။';

  @override
  String allStadiums(int count) {
    return 'အားကစားကွင်း အားလုံး ($count)';
  }

  @override
  String get bookingTitle => 'ဘိုကင်';

  @override
  String get viewVenue => 'အားကစားကွင်း ကြည့်ရန်';

  @override
  String get cancelBooking => 'ဘိုကင် ပယ်ဖျက်ရန်';

  @override
  String get cancelBookingTitle => 'ဤဘိုကင်ကို ပယ်ဖျက်မလား?';

  @override
  String get cancelBookingMessage => 'ကွင်းကို အခြားသူများအတွက် ပြန်ဖွင့်ပေးပါမည်။';

  @override
  String get keepIt => 'မပယ်ဖျက်ပါ';

  @override
  String reasonLabel(String reason) {
    return 'အကြောင်းရင်း - $reason';
  }

  @override
  String get venueLabel => 'အားကစားကွင်း';

  @override
  String get shopLabel => 'ဆိုင်';

  @override
  String get noPhone => 'ဖုန်းနံပါတ် မရှိပါ';

  @override
  String get markAllRead => 'အားလုံး ဖတ်ပြီး';

  @override
  String get markAllReadAction => 'အားလုံး ဖတ်ပြီးအဖြစ် မှတ်ရန်';

  @override
  String get unreadPrefix => 'မဖတ်ရသေး။';

  @override
  String get formDiscardMessage => 'ပြောင်းလဲထားသည်များ မသိမ်းပါ။';

  @override
  String get formFixFields => 'အမှတ်အသားပြထားသော အကွက်များကို ပြင်ပါ';

  @override
  String get notFoundRemoved => 'ဖျက်ထားပြီး ဖြစ်နိုင်ပါသည်။';

  @override
  String get addressOptional => 'လိပ်စာ (မထည့်လည်းရ)';

  @override
  String get townshipOptional => 'မြို့နယ် (မထည့်လည်းရ)';

  @override
  String get cityOptional => 'မြို့ (မထည့်လည်းရ)';

  @override
  String get descriptionOptional => 'ဖော်ပြချက် (မထည့်လည်းရ)';

  @override
  String get emailOptional => 'အီးမေးလ် (မထည့်လည်းရ)';

  @override
  String get openForBookings => 'ဘိုကင် လက်ခံမည်';

  @override
  String valMaxChars(int max) {
    return 'စာလုံး $max ထက် မပိုပါစေနှင့်';
  }

  @override
  String get valPriceRequired => 'တစ်နာရီဈေးနှုန်း ထည့်ပါ';

  @override
  String get valPriceDigits => 'ကျပ်ငွေကို ဂဏန်းဖြင့်သာ ထည့်ပါ';

  @override
  String valPriceMax(int max) {
    return 'ဈေးနှုန်း $max အထိသာ ထည့်ပါ';
  }

  @override
  String valCapacityRange(int max) {
    return '1 မှ $max အတွင်း ဂဏန်း ထည့်ပါ';
  }

  @override
  String get stadiumNew => 'အားကစားကွင်းအသစ်';

  @override
  String get stadiumEdit => 'အားကစားကွင်း ပြင်ရန်';

  @override
  String get stadiumNotFound => 'အားကစားကွင်း ရှာမတွေ့ပါ';

  @override
  String get stadiumNameLabel => 'အားကစားကွင်း အမည်';

  @override
  String get stadiumNameRequired => 'အားကစားကွင်း အမည် ထည့်ပါ';

  @override
  String get stadiumAdded => 'အားကစားကွင်း ထည့်ပြီးပါပြီ။ ယခု ကွင်းများ ထည့်ပါ။';

  @override
  String get stadiumUpdated => 'အားကစားကွင်း ပြင်ဆင်ပြီးပါပြီ';

  @override
  String get openingHoursTitle => 'ဖွင့်ချိန်';

  @override
  String get opensLabel => 'ဖွင့်ချိန်';

  @override
  String get closesLabel => 'ပိတ်ချိန်';

  @override
  String get openingHoursNote => 'အားကစားကွင်းများသည် နာရီအပြည့်တွင် ဖွင့်ရပါမည်။ ဖွင့်ချိန် ပြောင်းခြင်းသည် ရှိပြီးသား ဘိုကင်များကို မရွှေ့၊ မပယ်ဖျက်ပါ။';

  @override
  String get stadiumOpenSubtitle => 'ပိတ်ထားပါက ဖောက်သည်များ ဤအားကစားကွင်းကို မမြင်ရ၊ ဘိုကင် မလုပ်နိုင်ပါ။';

  @override
  String get addStadium => 'အားကစားကွင်း ထည့်ရန်';

  @override
  String get courtNew => 'ကွင်းအသစ်';

  @override
  String get courtEdit => 'ကွင်း ပြင်ရန်';

  @override
  String get courtNotFound => 'ကွင်း ရှာမတွေ့ပါ';

  @override
  String get courtNameLabel => 'ကွင်းအမည်';

  @override
  String get courtNameRequired => 'ကွင်းအမည် ထည့်ပါ (ဥပမာ \"Court 1\")';

  @override
  String get courtAdded => 'ကွင်း ထည့်ပြီးပါပြီ';

  @override
  String get courtUpdated => 'ကွင်း ပြင်ဆင်ပြီးပါပြီ';

  @override
  String pricePerHourLabel(String currency) {
    return 'တစ်နာရီဈေးနှုန်း ($currency)';
  }

  @override
  String get priceHelper => 'ကျပ်ငွေ အပြည့်ဖြင့် ထည့်ပါ။ ရှိပြီးသား ဘိုကင်များသည် ဘိုကင်လုပ်စဉ်က ဈေးနှုန်းအတိုင်း ရှိပါမည်။';

  @override
  String get slotLengthTitle => 'အချိန်အပိုင်း ကြာချိန်';

  @override
  String slotLengthNote(int max) {
    return 'ဖောက်သည်များ တစ်ကြိမ်လျှင် အပိုင်း 1–$max ခု ဘိုကင်လုပ်နိုင်ပါသည်။ ကွင်း ဖန်တီးပြီးနောက် ပြောင်း၍မရပါ။';
  }

  @override
  String slotLengthFixed(int minutes) {
    return '$minutes မိနစ် အပိုင်းများ။ ရှိပြီးသား ဘိုကင်များနှင့် မထပ်စေရန် ကွင်း ဖန်တီးစဉ်က သတ်မှတ်ထားပါသည်။';
  }

  @override
  String get playersOptional => 'ကစားသမား ဦးရေ (မထည့်လည်းရ)';

  @override
  String get playersHint => 'ဥပမာ 10';

  @override
  String get surfaceOptional => 'ကွင်းမျက်နှာပြင် (မထည့်လည်းရ)';

  @override
  String get surfaceHint => 'ဥပမာ အတုမြက်ခင်း';

  @override
  String get courtOpenSubtitle => 'ပိတ်ထားပါက ဖောက်သည်များ ဤကွင်းကို မမြင်ရ၊ ဘိုကင် မလုပ်နိုင်ပါ။ ရှိပြီးသား ဘိုကင်များ ဆက်ရှိပါမည်။';

  @override
  String get addCourt => 'ကွင်း ထည့်ရန်';

  @override
  String get shopNew => 'ဆိုင်အသစ်';

  @override
  String get shopEdit => 'ဆိုင် ပြင်ရန်';

  @override
  String get shopNotFound => 'ဆိုင် ရှာမတွေ့ပါ';

  @override
  String get shopNameLabel => 'ဆိုင်အမည်';

  @override
  String get shopNameRequired => 'ဆိုင်အမည် ထည့်ပါ';

  @override
  String get shopCreated => 'ဆိုင် ဖန်တီးပြီးပါပြီ။ အတည်ပြုရန် စိစစ်ပါ။';

  @override
  String get shopUpdated => 'ဆိုင် ပြင်ဆင်ပြီးပါပြီ';

  @override
  String get shopNewNote => 'ဆိုင်အသစ်များသည် \"စိစစ်ရန် စောင့်ဆိုင်းဆဲ\" အဖြစ် စတင်ပြီး သင် အတည်ပြုသည်အထိ ဖောက်သည်များကို မပြပါ။';

  @override
  String get shopPhoneHelper => 'ဖောက်သည်များကို ပြသမည်';

  @override
  String get ownerPrivateTitle => 'ပိုင်ရှင် (သီးသန့်)';

  @override
  String get ownerPrivateNote => 'သင်နှင့် ဤဆိုင်၏ စီမံသူများသာ မြင်နိုင်ပါသည်။';

  @override
  String get ownerNameOptional => 'ပိုင်ရှင်အမည် (မထည့်လည်းရ)';

  @override
  String get ownerPhoneOptional => 'ပိုင်ရှင်ဖုန်း (မထည့်လည်းရ)';

  @override
  String get createShop => 'ဆိုင် ဖန်တီးရန်';

  @override
  String get addShopAdminTitle => 'ဆိုင်စီမံသူ ထည့်ရန်';

  @override
  String get inviteIntro => 'ဆိုင်ပိုင်ရှင်ကို ၎င်း၏ အီးမေးလ်ဖြင့် အက်ပ်တွင် အရင် စာရင်းသွင်းခိုင်းပါ။ ထို့နောက် ဤနေရာတွင် အကောင့်ကို ရှာပါ။';

  @override
  String get accountEmailLabel => 'အကောင့် အီးမေးလ်';

  @override
  String get findAccount => 'အကောင့် ရှာရန်';

  @override
  String noAccountForEmail(String email) {
    return '$email ဖြင့် အကောင့် မရှိပါ။ ဤအီးမေးလ်ဖြင့် စာရင်းသွင်းခိုင်းပြီး ထပ်ကြိုးစားပါ။';
  }

  @override
  String nowShopAdmin(String name) {
    return '$name သည် ယခု ဆိုင်စီမံသူ ဖြစ်ပါပြီ';
  }

  @override
  String get cantChangeOwnRole => 'ကိုယ့်ရာထူးကို ကိုယ်တိုင် ပြောင်း၍မရပါ။';

  @override
  String get platformAdminCantBeShopAdmin => 'ပလက်ဖောင်းစီမံသူများသည် ဆိုင်စီမံသူ မဖြစ်နိုင်ပါ။ ရာထူးကို အရင်ပြောင်းပါ။';

  @override
  String get alreadyAdminHere => 'ဤဆိုင်၏ စီမံသူ ဖြစ်ပြီးသားပါ။';

  @override
  String get managesOtherShop => 'ဤအကောင့်သည် အခြားဆိုင်ကို စီမံနေပါသည်။ ဤနေရာတွင် ထည့်ပါက ထိုဆိုင်မှ ဖယ်ရှားပါမည်။';

  @override
  String get roleUnknownFix => 'ဤအကောင့်၏ ရာထူးကို မသိရပါ။ Console တွင် ပြင်ပါ။';

  @override
  String currentRole(String role) {
    return 'လက်ရှိ ရာထူး - $role';
  }

  @override
  String get roleUnknown => 'မသိ';

  @override
  String get accountDisabledTag => 'အကောင့် ပိတ်ထား';

  @override
  String get makeShopAdmin => 'ဆိုင်စီမံသူ ပြုလုပ်ရန်';

  @override
  String get rolePlatformAdmin => 'ပလက်ဖောင်းစီမံသူ';

  @override
  String get roleShopAdmin => 'ဆိုင်စီမံသူ';

  @override
  String get roleCustomer => 'ဖောက်သည်';

  @override
  String get blockTimeTitle => 'အချိန် ပိတ်ရန်';

  @override
  String get stadiumLabel => 'အားကစားကွင်း';

  @override
  String get fromLabel => 'စတင်ချိန်';

  @override
  String get slotsLabel => 'အပိုင်း';

  @override
  String get reasonFieldLabel => 'အကြောင်းရင်း';

  @override
  String get noteOptional => 'မှတ်ချက် (မထည့်လည်းရ)';

  @override
  String get newAnnouncementTitle => 'ကြေညာချက်အသစ်';

  @override
  String sendTo(String audience) {
    return '$audience ထံ ပို့ရန်';
  }

  @override
  String get sendAnnouncementAction => 'ကြေညာချက် ပို့ခြင်း';

  @override
  String get audienceLabel => 'ပို့မည့်သူများ';

  @override
  String get titleLabel => 'ခေါင်းစဉ်';

  @override
  String get messageLabel => 'စာ';

  @override
  String get audienceEveryone => 'အားလုံး';

  @override
  String get audienceCustomers => 'ဖောက်သည်များ';

  @override
  String get audienceShopAdmins => 'ဆိုင်စီမံသူများ';
}
