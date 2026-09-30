import 'package:intl/intl.dart' as intl;

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
  String get homeSearchHint => 'အားကစားကွင်း သို့မဟုတ် မြို့နယ် ရှာရန်';

  @override
  String get homeNextGame => 'နောက်ပွဲ';

  @override
  String get homeAllBookings => 'ဘိုကင်အားလုံး';

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

  @override
  String get errBlacklisted => 'ဤအားကစားကွင်းသည် သင့်အကောင့်မှ ဘိုကင်များကို လက်မခံပါ။ ကွင်းသို့ ဆက်သွယ်ပါ။';

  @override
  String get blacklistTitle => 'အမည်ပျက်စာရင်း';

  @override
  String get blacklistSubtitle => 'သင့်ဆိုင်တွင် ဘိုကင်မလုပ်နိုင်သော ဖောက်သည်များ';

  @override
  String get blacklistIntro => 'အမည်ပျက်စာရင်းရှိ ဖောက်သည်များသည် သင့်ဆိုင်တွင် ဘိုကင်အသစ် မလုပ်နိုင်ပါ။ ရှိပြီးသား ဘိုကင်များ ဆက်ရှိပြီး အခြားဆိုင်များတွင် ဘိုကင်လုပ်နိုင်ပါသည်။';

  @override
  String get blacklistEmptyTitle => 'အမည်ပျက်စာရင်းတွင် မည်သူမျှ မရှိပါ';

  @override
  String get blacklistEmptyMessage => 'ဖောက်သည်၏ ပရိုဖိုင် သို့မဟုတ် မလာခဲ့သော ဘိုကင်မှ အမည်ပျက်စာရင်း သွင်းနိုင်ပါသည်။';

  @override
  String get blacklistAdd => 'အမည်ပျက်စာရင်း သွင်းရန်';

  @override
  String get blacklistNoShowAction => 'မလာခဲ့ပါ · အမည်ပျက်စာရင်း သွင်းရန်';

  @override
  String get blacklistRemove => 'အမည်ပျက်စာရင်းမှ ဖယ်ရန်';

  @override
  String blacklistRemoveTitle(String name) {
    return '$name ကို အမည်ပျက်စာရင်းမှ ဖယ်မလား?';
  }

  @override
  String get blacklistRemoveMessage => 'သင့်ဆိုင်တွင် ပြန်လည် ဘိုကင်လုပ်နိုင်ပါမည်။';

  @override
  String get blacklistRemoveConfirm => 'ဖယ်ရန်';

  @override
  String get blacklistKeep => 'ဆက်ထားမည်';

  @override
  String blacklistSheetTitle(String name) {
    return '$name ကို အမည်ပျက်စာရင်း သွင်းရန်';
  }

  @override
  String get blacklistSheetMessage => 'သင့်ဆိုင်တွင် ဘိုကင်အသစ် မလုပ်နိုင်တော့ပါ။ ရှိပြီးသား ဘိုကင်များ ဆက်ရှိပါမည်။';

  @override
  String get blacklistReasonNoShow => 'ဘိုကင်လုပ်ပြီး မလာခဲ့';

  @override
  String get blacklistConfirm => 'အမည်ပျက်စာရင်း သွင်းမည်';

  @override
  String blacklistAdded(String name) {
    return '$name ကို အမည်ပျက်စာရင်း သွင်းပြီးပါပြီ';
  }

  @override
  String blacklistRemoved(String name) {
    return '$name ပြန်လည် ဘိုကင်လုပ်နိုင်ပါပြီ';
  }

  @override
  String get blacklistedBadge => 'အမည်ပျက်စာရင်းဝင်';

  @override
  String blacklistedOn(String date) {
    return '$date တွင် စာရင်းသွင်းခဲ့';
  }

  @override
  String get stadiumsEmptyTitle => 'ပထမဆုံး အားကစားကွင်းကို ထည့်ပါ';

  @override
  String get stadiumsEmptyMessage => 'ဖွင့်ချိန် သတ်မှတ်ပြီးနောက် ဖောက်သည်များ ဘိုကင်လုပ်နိုင်မည့် ကွင်းများကို ထည့်ပါ။';

  @override
  String get staffFilterUpcoming => 'လာမည့်';

  @override
  String get staffFilterPast => 'ပြီးခဲ့သော';

  @override
  String get staffFilterAll => 'အားလုံး';

  @override
  String get staffNoBookingsTitle => 'ဤနေရာတွင် ဘိုကင် မရှိပါ';

  @override
  String get staffTryAnotherFilter => 'အခြား စစ်ထုတ်မှုကို ရွေးကြည့်ပါ။';

  @override
  String get markPaymentPending => 'ငွေပေးချေမှု စောင့်ဆိုင်းဆဲ အဖြစ် မှတ်ရန်';

  @override
  String get markAsPaid => 'ပေးချေပြီး အဖြစ် မှတ်ရန်';

  @override
  String get markAsRefunded => 'ငွေပြန်အမ်းပြီး အဖြစ် မှတ်ရန်';

  @override
  String get confirmBooking => 'ဘိုကင် အတည်ပြုရန်';

  @override
  String get markAsCompleted => 'ပြီးဆုံးပြီး အဖြစ် မှတ်ရန်';

  @override
  String get rejectBooking => 'ဘိုကင် ငြင်းပယ်ရန်';

  @override
  String get rejectBookingTitle => 'ဤဘိုကင်ကို ငြင်းပယ်မလား?';

  @override
  String get rejectBookingMessage => 'ဖောက်သည်ထံ အကြောင်းကြားပြီး အချိန်အပိုင်းများကို ပြန်ဖွင့်ပေးပါမည်။';

  @override
  String get rejectAction => 'ငြင်းပယ်ရန်';

  @override
  String get keepBooking => 'ဘိုကင် ဆက်ထားမည်';

  @override
  String get searchNameOrPhone => 'အမည် သို့မဟုတ် ဖုန်းဖြင့် ရှာရန်';

  @override
  String get noCustomersFound => 'ဖောက်သည် ရှာမတွေ့ပါ';

  @override
  String bookingCount(int count) {
    return 'ဘိုကင် $count ခု';
  }

  @override
  String lastPlayedOn(String date) {
    return 'နောက်ဆုံး $date တွင် ကစားခဲ့';
  }

  @override
  String joinedOn(String date) {
    return '$date တွင် စာရင်းသွင်းခဲ့';
  }

  @override
  String get statusDisabled => 'ပိတ်ထား';

  @override
  String get accountPrefix => 'အကောင့်';

  @override
  String get mmkOnPlatform => 'ပလက်ဖောင်းတစ်ခုလုံးတွင် (ကျပ်)';

  @override
  String get mmkAtYourShop => 'သင့်ဆိုင်တွင် (ကျပ်)';

  @override
  String get bookingHistory => 'ဘိုကင် မှတ်တမ်း';

  @override
  String get noBookingsYet => 'ဘိုကင် မရှိသေးပါ';

  @override
  String totalPaidAmount(String amount) {
    return 'စုစုပေါင်း ပေးချေပြီး: $amount';
  }

  @override
  String get settingsShopProfile => 'ဆိုင် ပရိုဖိုင်';

  @override
  String get settingsShopProfileSub => 'အမည်၊ ဆက်သွယ်ရန်နှင့် လိပ်စာ';

  @override
  String get blockedTimesTitle => 'ပိတ်ထားသော အချိန်များ';

  @override
  String get blockedTimesSub => 'ပြုပြင်ထိန်းသိမ်းမှု၊ ပွဲများ၊ ပိတ်ရက်များ';

  @override
  String get stadiumsAndCourts => 'အားကစားကွင်းနှင့် ကွင်းများ';

  @override
  String get editShopProfile => 'ဆိုင် ပရိုဖိုင် ပြင်ရန်';

  @override
  String get commonEdit => 'ပြင်ရန်';

  @override
  String get shopStatusPrefix => 'ဆိုင် အခြေအနေ';

  @override
  String get listingPrefix => 'ပြသမှု';

  @override
  String get addressLabel => 'လိပ်စာ';

  @override
  String get statusManagedByPlatform => 'အခြေအနေနှင့် ပြသမှုကို ပလက်ဖောင်းအဖွဲ့က စီမံပါသည်။';

  @override
  String get visibilityUnlisted => 'သင့်ဆိုင်ကို မပြသထားသဖြင့် ဖောက်သည်များ မမြင်ရ၊ ဘိုကင် မလုပ်နိုင်ပါ။';

  @override
  String get visibilityPending => 'သင့်ဆိုင်သည် အတည်ပြုချက် စောင့်ဆိုင်းနေပါသည်။ အားကစားကွင်းနှင့် ကွင်းများကို ယခုပင် ပြင်ဆင်ထားနိုင်ပြီး အတည်ပြုပြီးနောက် ဖောက်သည်များ မြင်ရပါမည်။';

  @override
  String get visibilitySuspended => 'သင့်ဆိုင်ကို ဆိုင်းငံ့ထားပါသည်။ ဖောက်သည်များ မမြင်ရ၊ ဘိုကင် မလုပ်နိုင်ပါ။ ပလက်ဖောင်းအဖွဲ့ကို ဆက်သွယ်ပါ။';

  @override
  String get visibilityInactive => 'သင့်ဆိုင် အသုံးမပြုနိုင်သေးပါ။ ဖောက်သည်များ မမြင်ရ၊ ဘိုကင် မလုပ်နိုင်ပါ။';

  @override
  String get venueActive => 'ဖွင့်ထား';

  @override
  String get venueInactive => 'ရပ်နားထား';

  @override
  String get visibleToCustomers => 'ဖောက်သည်များ မြင်ရသည်';

  @override
  String get hiddenLabel => 'ဝှက်ထား';

  @override
  String get discoveryPrefix => 'ရှာဖွေမှု';

  @override
  String get bookableLabel => 'ဘိုကင်လုပ်နိုင်';

  @override
  String get noneListed => 'မရှိပါ';

  @override
  String get descriptionLabel => 'ဖော်ပြချက်';

  @override
  String get noCourtsYet => 'ကွင်း မရှိသေးပါ';

  @override
  String get noCourtsMessage => 'ဖောက်သည်များ ဘိုကင်လုပ်နိုင်ရန် ဈေးနှုန်းနှင့် အချိန်အပိုင်း ကြာချိန်ဖြင့် ကွင်းတစ်ခု ထည့်ပါ။';

  @override
  String get noPrice => 'ဈေးနှုန်း မရှိ';

  @override
  String get noPriceSet => 'ဈေးနှုန်း မသတ်မှတ်ရသေးပါ';

  @override
  String get pricePerHourTitle => 'တစ်နာရီ ဈေးနှုန်း';

  @override
  String slotMinutesValue(int minutes) {
    return '$minutes မိနစ်';
  }

  @override
  String get playersLabel => 'ကစားသမား ဦးရေ';

  @override
  String get surfaceLabel => 'ကွင်းမျက်နှာပြင်';

  @override
  String get blockCourtSub => 'ပြုပြင်ထိန်းသိမ်းမှု၊ ပွဲများ စသည်တို့အတွက် ဤကွင်းကို ပိတ်ရန်';

  @override
  String get blockedTimesNote => 'ပိတ်ထားသော အချိန်များကို ဖောက်သည်များ ဘိုကင် မလုပ်နိုင်ပါ။';

  @override
  String get removeBlock => 'ပိတ်ထားမှု ဖယ်ရန်';

  @override
  String venueCounts(int stadiums, int courts) {
    return 'အားကစားကွင်း $stadiums ခု · ကွင်း $courts ခု';
  }

  @override
  String get statBookingsFooter => 'ဘိုကင်';

  @override
  String get statNeedReply => 'အကြောင်းပြန်ရန်';

  @override
  String get statCollected => 'ရရှိငွေ';

  @override
  String get statMmkFromPaid => 'ပေးချေပြီး ဘိုကင်များမှ (ကျပ်)';

  @override
  String get statBookedWithYou => 'သင့်ထံ ဘိုကင်လုပ်ခဲ့သူ';

  @override
  String get needsYourReply => 'အကြောင်းပြန်ရန် လိုအပ်';

  @override
  String get allCaughtUp => 'အားလုံး ပြီးပါပြီ';

  @override
  String get allCaughtUpMessage => 'ဘိုကင် တောင်းဆိုမှု အသစ်များ ဤနေရာတွင် ပေါ်လာပါမည်။';

  @override
  String get todaysSchedule => 'ယနေ့ အစီအစဉ်';

  @override
  String get noGamesToday => 'ယနေ့ ပွဲ မရှိပါ';

  @override
  String get locationLabel => 'တည်နေရာ';

  @override
  String get shopAdminsSub => 'ဤဆိုင်ကို စီမံနိုင်သူများ';

  @override
  String get explainPending => 'စိစစ်ရန် စောင့်ဆိုင်းဆဲ။ ဖောက်သည်များကို မပြသေးပါ။ ဆိုင်စီမံသူများက အားကစားကွင်းနှင့် ကွင်းများကို ယခုပင် ပြင်ဆင်နိုင်ပါသည်။';

  @override
  String get explainLive => 'ဖွင့်ထား: ဖောက်သည်များ ရှာဖွေ၍ ဘိုကင်လုပ်နိုင်ပါသည်။';

  @override
  String get explainUnlisted => 'အတည်ပြုပြီးသော်လည်း မပြသထား: ဖောက်သည်များကို မပြ၊ ဘိုကင်အသစ် မလက်ခံပါ။';

  @override
  String get explainSuspended => 'ဆိုင်းငံ့ထား: ဖောက်သည်များကို မပြ၊ ဘိုကင်အသစ် မလက်ခံပါ။ ရှိပြီးသား ဘိုကင်များ မပြောင်းလဲပါ။';

  @override
  String get explainRejected => 'ငြင်းပယ်ထား: ဖောက်သည်များကို မပြပါ။';

  @override
  String get explainInactive => 'ရပ်နားထား: ဖောက်သည်များကို မပြ၊ ဘိုကင်အသစ် မလက်ခံပါ။';

  @override
  String get commonCancel => 'မလုပ်တော့ပါ';

  @override
  String get commonRemove => 'ဖယ်ရန်';

  @override
  String get approveAndList => 'အတည်ပြုပြီး ပြသရန်';

  @override
  String get shopApprovedListed => 'ဆိုင်ကို အတည်ပြုပြီး ပြသထားပါပြီ';

  @override
  String get reactivateAction => 'ပြန်ဖွင့်ရန်';

  @override
  String get shopReactivated => 'ဆိုင်ကို ပြန်ဖွင့်ပြီးပါပြီ';

  @override
  String get deactivateShop => 'ဆိုင် ရပ်နားရန်';

  @override
  String get shopDeactivated => 'ဆိုင်ကို ရပ်နားထားပါပြီ';

  @override
  String get deactivateShopTitle => 'ဤဆိုင်ကို ရပ်နားမလား?';

  @override
  String get deactivateShopMessage => 'ဖောက်သည်များကို မပြတော့ဘဲ ဘိုကင်အသစ် မလက်ခံတော့ပါ။ နောက်မှ ပြန်ဖွင့်နိုင်ပါသည်။';

  @override
  String get deactivateAction => 'ရပ်နားရန်';

  @override
  String get shopRejectedDone => 'ဆိုင်ကို ငြင်းပယ်ပြီးပါပြီ';

  @override
  String get rejectShopTitle => 'ဤဆိုင်ကို ငြင်းပယ်မလား?';

  @override
  String get rejectShopMessage => 'ဖောက်သည်များကို ဆက်၍ မပြပါ။ နောက်မှ အတည်ပြုနိုင်ပါသေးသည်။';

  @override
  String get listedForCustomers => 'ဖောက်သည်များအတွက် ပြသမည်';

  @override
  String get listedForCustomersSub => 'ပိတ်ထားပါက ဆိုင်ကို မပြဘဲ ဘိုကင်အသစ် မလက်ခံပါ။';

  @override
  String get shopListedDone => 'ဆိုင်ကို ပြသထားပါပြီ';

  @override
  String get shopUnlistedDone => 'ဆိုင်ကို မပြသတော့ပါ';

  @override
  String get suspendAction => 'ဆိုင်းငံ့ရန်';

  @override
  String get shopSuspendedDone => 'ဆိုင်ကို ဆိုင်းငံ့ထားပါပြီ';

  @override
  String get suspendShopTitle => 'ဤဆိုင်ကို ဆိုင်းငံ့မလား?';

  @override
  String get suspendShopMessage => 'ဖောက်သည်များ မမြင်ရတော့ဘဲ ဘိုကင်အသစ် မလက်ခံတော့ပါ။ ရှိပြီးသား ဘိုကင်များကို မပယ်ဖျက်ပါ။';

  @override
  String get ownerNameLabel => 'ပိုင်ရှင် အမည်';

  @override
  String get ownerPhoneLabel => 'ပိုင်ရှင် ဖုန်း';

  @override
  String get suspensionReason => 'ဆိုင်းငံ့ရသည့် အကြောင်းရင်း';

  @override
  String get nothingToReview => 'စိစစ်ရန် မရှိပါ';

  @override
  String get nothingToReviewMessage => 'ဆိုင်အသစ်များကို သင် အတည်ပြု သို့မဟုတ် ငြင်းပယ်သည်အထိ ဤနေရာတွင် ပြပါမည်။';

  @override
  String get noShopsYet => 'ဆိုင် မရှိသေးပါ';

  @override
  String get noShopsMessage => 'ပထမဆုံး ဆိုင်ကို ဖန်တီးပြီး ၎င်း၏ စီမံသူကို သတ်မှတ်ပါ။';

  @override
  String shopAdminsOf(String shop) {
    return '$shop စီမံသူများ';
  }

  @override
  String get addAdmin => 'စီမံသူ ထည့်ရန်';

  @override
  String get noAdminsYet => 'စီမံသူ မရှိသေးပါ';

  @override
  String get noAdminsMessage => 'ဤဆိုင်ကို လုပ်ကိုင်သူကို ထည့်ပါ။ ၎င်းတွင် ဖောက်သည်အကောင့် ရှိထားရပါမည်။';

  @override
  String get accountDisabledBadge => 'အကောင့် ပိတ်ထား';

  @override
  String get removeAdmin => 'စီမံသူ ဖယ်ရန်';

  @override
  String get removeAdminTitle => 'ဤစီမံသူကို ဖယ်မလား?';

  @override
  String removeAdminMessage(String name) {
    return '$name သည် ဆိုင်ကို စီမံခွင့် ချက်ချင်း ဆုံးရှုံးပြီး ဖောက်သည် ဖြစ်သွားပါမည်။';
  }

  @override
  String get adminRemoved => 'စီမံသူကို ဖယ်ပြီးပါပြီ';

  @override
  String shopCount(int count) {
    return 'ဆိုင် $count ဆိုင်';
  }

  @override
  String platformSummary(int active, int pending) {
    return 'အသုံးပြုနေ $active · စိစစ်ရန် $pending';
  }

  @override
  String get activeShops => 'အသုံးပြုနေသော ဆိုင်';

  @override
  String ofTotal(int total) {
    return 'စုစုပေါင်း $total အနက်';
  }

  @override
  String get toReview => 'စိစစ်ရန်';

  @override
  String get newShopsFooter => 'ဆိုင်အသစ်';

  @override
  String get lastTwoWeeks => 'ပြီးခဲ့သော ၂ ပတ်';

  @override
  String get waitingForReview => 'စိစစ်ရန် စောင့်ဆိုင်းဆဲ';

  @override
  String get reviewAction => 'စိစစ်ရန်';

  @override
  String get latestBookings => 'နောက်ဆုံး ဘိုကင်များ';

  @override
  String get disableAccount => 'အကောင့် ပိတ်ရန်';

  @override
  String disableUserTitle(String name) {
    return '$name ကို ပိတ်မလား?';
  }

  @override
  String get disableUserMessage => 'အကောင့်ကို ပြန်ဖွင့်သည်အထိ အကောင့်မှ ထွက်သွားပြီး ဘိုကင် မလုပ်နိုင်တော့ပါ။';

  @override
  String get disableAction => 'ပိတ်ရန်';

  @override
  String get keepActive => 'ဆက်ဖွင့်ထားမည်';

  @override
  String get enableAccount => 'အကောင့် ပြန်ဖွင့်ရန်';

  @override
  String get announcementsTitle => 'ကြေညာချက်များ';

  @override
  String get announcementsSub => 'ဖောက်သည်နှင့် ဆိုင်များထံ ပို့သော စာများ';

  @override
  String get shopsPendingReview => 'စိစစ်ရန် စောင့်ဆိုင်းနေသော ဆိုင်များ';

  @override
  String get newShort => 'အသစ်';

  @override
  String get sentToPrefix => 'ပို့သည့် လက်ခံသူ';

  @override
  String homeOpenSlots(String day) {
    return '$day ကစားနိုင်သော အချိန်များ';
  }

  @override
  String get homeNoOpenSlots => 'ဤနေ့အတွက် ဘိုကင် ပြည့်နေပါပြီ';

  @override
  String bookSlotAt(String court, String time) {
    return '$time တွင် $court ဘိုကင်လုပ်ရန်';
  }

  @override
  String get mapDirections => 'လမ်းညွှန်';

  @override
  String get mapOpenInGoogleMaps => 'Google Maps တွင် ဖွင့်ရန်';

  @override
  String get mapOpenFailed => 'Google Maps ကို ဖွင့်၍ မရပါ';

  @override
  String mapPinSemantics(String name) {
    return '$name ကို ပြသော မြေပုံ။ Google Maps ကို ဖွင့်ပါမည်';
  }

  @override
  String get locationNotSet => 'မြေပုံ တည်နေရာ မထည့်ရသေးပါ';

  @override
  String get locationNote => 'ဖောက်သည်များ မြေပုံပေါ်တွင် မြင်ရပြီး လမ်းညွှန် ရယူနိုင်ပါသည်။';

  @override
  String get locationPickOnMap => 'မြေပုံပေါ်တွင် ရွေးရန်';

  @override
  String get locationChangeOnMap => 'မြေပုံပေါ်တွင် ပြောင်းရန်';

  @override
  String get locationPasteLabel => 'ကိုဩဒိနိတ် သို့မဟုတ် Google Maps လင့်ခ်';

  @override
  String get locationPasteHelper => 'ဥပမာ 16.84090, 96.17350';

  @override
  String get locationInvalid => 'တည်နေရာကို ဖတ်၍ မရပါ။ 16.84090, 96.17350 ကဲ့သို့ ကိုဩဒိနိတ်ကို ထည့်ပါ။';

  @override
  String get locationShortLink => 'လင့်ခ်အတိုကို ဖတ်၍ မရပါ။ လင့်ခ်ကို ဖွင့်ပြီး လင့်ခ်အပြည့် သို့မဟုတ် ကိုဩဒိနိတ်ကို ကူးယူပါ။';

  @override
  String get locationClear => 'တည်နေရာ ဖယ်ရန်';

  @override
  String get pickLocationTitle => 'ကွင်းတည်နေရာ သတ်မှတ်ရန်';

  @override
  String get pickLocationHint => 'ပင်သည် သင့်ကွင်းပေါ် ကျရောက်သည်အထိ မြေပုံကို ရွှေ့ပါ။';

  @override
  String get useThisLocation => 'ဤတည်နေရာကို သုံးမည်';

  @override
  String get notifBookingRequestedTitle => 'ဘိုကင် တောင်းဆိုမှု အသစ်';

  @override
  String get notifBookingCancelledTitle => 'ဖောက်သည်က ဘိုကင်ကို ပယ်ဖျက်လိုက်သည်';

  @override
  String get notifBookingConfirmedTitle => 'ဘိုကင် အတည်ပြုပြီးပါပြီ';

  @override
  String get notifBookingRejectedTitle => 'ဘိုကင်ကို ငြင်းပယ်လိုက်သည်';

  @override
  String notifReason(String reason) {
    return 'အကြောင်းရင်း - $reason';
  }

  @override
  String get notificationsEmptyTitle => 'အသိပေးချက် မရှိသေးပါ';

  @override
  String get notificationsEmptyMessage => 'ဆိုင်က သင့်ဘိုကင်ကို အတည်ပြု သို့မဟုတ် ငြင်းပယ်သည့်အခါ ဤနေရာတွင် မြင်ရပါမည်။';

  @override
  String get notificationsEmptyMessageShop => 'ဘိုကင် တောင်းဆိုမှုအသစ်များနှင့် ပယ်ဖျက်မှုများကို ဤနေရာတွင် ပြပါမည်။';

  @override
  String get notificationsOpen => 'အသိပေးချက်များ ဖွင့်ရန်';

  @override
  String get notificationView => 'ကြည့်ရန်';

  @override
  String get tourSkip => 'ကျော်မည်';

  @override
  String get tourNext => 'ရှေ့သို့';

  @override
  String get tourBack => 'နောက်သို့';

  @override
  String get tourDone => 'နားလည်ပါပြီ';

  @override
  String tourStepOf(int current, int total) {
    return '$total ခုအနက် $current';
  }

  @override
  String get tourReplay => 'အက်ပ် လမ်းညွှန်';

  @override
  String get tourReplaySub => 'အက်ပ် အသုံးပြုပုံကို ပြန်ကြည့်ရန်';

  @override
  String get tourCustSearchTitle => 'ကွင်း ရှာပါ';

  @override
  String get tourCustSearchBody => 'အနီးနားရှိ ကွင်းများကို ကြည့်ရန် အားကစားကွင်းအမည် သို့မဟုတ် မြို့နယ်ဖြင့် ရှာပါ။';

  @override
  String get tourCustDayTitle => 'နေ့ ရွေးပါ';

  @override
  String get tourCustDayBody => 'ကစားလိုသည့်နေ့ကို ရွေးပါ။ အောက်ရှိ အားလပ်ချိန်များ ထိုနေ့အတိုင်း ပြောင်းပါမည်။';

  @override
  String get tourCustVenuesTitle => 'တစ်ချက်နှိပ်ရုံဖြင့် ဘိုကင်လုပ်ပါ';

  @override
  String get tourCustVenuesBody => 'အားလပ်ချိန်တစ်ခုကို နှိပ်ပြီး ထိုကွင်းကို တိုက်ရိုက် ဘိုကင်လုပ်ပါ။';

  @override
  String get tourCustBookingsTitle => 'သင့်ဘိုကင်များ';

  @override
  String get tourCustBookingsBody => 'လာမည့်ပွဲများနှင့် အခြေအနေကို ကြည့်ပါ။ အစီအစဉ်ပြောင်းလျှင် ပယ်ဖျက်နိုင်ပါသည်။';

  @override
  String get tourCustNotifTitle => 'အသိပေးချက်များ';

  @override
  String get tourCustNotifBody => 'ဆိုင်က သင့်ဘိုကင်ကို အတည်ပြု သို့မဟုတ် ငြင်းပယ်သည့်အခါ ဤနေရာတွင် အသိပေးပါမည်။';

  @override
  String get tourCustProfileTitle => 'ပရိုဖိုင်နှင့် ဘာသာစကား';

  @override
  String get tourCustProfileBody => 'အချက်အလက် ပြင်ရန်၊ မြန်မာ/အင်္ဂလိပ် ပြောင်းရန် သို့မဟုတ် ဤလမ်းညွှန်ကို ပြန်ကြည့်ရန်။';

  @override
  String get tourShopStatsTitle => 'ယနေ့ အခြေအနေ';

  @override
  String get tourShopStatsBody => 'ယနေ့ ဘိုကင်များ၊ စောင့်ဆိုင်းနေသော တောင်းဆိုမှုများနှင့် ရရှိပြီး ငွေ။';

  @override
  String get tourShopBellTitle => 'ဘိုကင် အသိပေးချက်';

  @override
  String get tourShopBellBody => 'တောင်းဆိုမှုအသစ်နှင့် ပယ်ဖျက်မှုများ ဤနေရာသို့ ရောက်လာပါမည်။ မဖတ်ရသေးသည့် အရေအတွက်ကို ပြပါသည်။';

  @override
  String get tourShopBookingsTitle => 'ဘိုကင် စီမံရန်';

  @override
  String get tourShopBookingsBody => 'တောင်းဆိုမှုများကို အတည်ပြု သို့မဟုတ် ငြင်းပယ်ပြီး ငွေပေးချေမှုကို မှတ်တမ်းတင်ပါ။';

  @override
  String get tourShopStadiumsTitle => 'အားကစားကွင်းနှင့် ကွင်းများ';

  @override
  String get tourShopStadiumsBody => 'အားကစားကွင်း၊ ဖွင့်ချိန်၊ ကွင်းများနှင့် တစ်နာရီဈေးနှုန်းကို ထည့်ပါ။';

  @override
  String get tourShopCustomersBody => 'သင့်ထံ ဘိုကင်လုပ်သူများနှင့် ၎င်းတို့၏ မှတ်တမ်းကို ကြည့်ပါ။';

  @override
  String get tourShopSettingsBody => 'ဆိုင်ပရိုဖိုင်၊ ပိတ်ထားသော အချိန်များ၊ အမည်ပျက်စာရင်းနှင့် ဤလမ်းညွှန်။';

  @override
  String get tourAdminStatsTitle => 'ပလက်ဖောင်း အခြေအနေ';

  @override
  String get tourAdminStatsBody => 'ပလက်ဖောင်းတစ်ခုလုံးရှိ ဆိုင်များ၊ ဘိုကင်များနှင့် လှုပ်ရှားမှုများ။';

  @override
  String get tourAdminShopsBody => 'ဆိုင်အသစ်များကို စစ်ဆေးပါ၊ ဖွင့်ပါ သို့မဟုတ် ဆိုင်းငံ့ပါ၊ ဆိုင်စီမံသူများကို သတ်မှတ်ပါ။';

  @override
  String get tourAdminBookingsTitle => 'ဘိုကင်အားလုံး';

  @override
  String get tourAdminBookingsBody => 'ပလက်ဖောင်းပေါ်ရှိ မည်သည့်ဘိုကင်ကိုမဆို ရှာကြည့်ပါ။';

  @override
  String get tourAdminCustomersBody => 'ဖောက်သည်များကို ရှာပြီး အကောင့်အခြေအနေကို စီမံပါ။';

  @override
  String get tourAdminSettingsBody => 'ကြေညာချက်များ၊ စစ်ဆေးရန် စောင့်နေသော ဆိုင်များနှင့် ဤလမ်းညွှန်။';

  @override
  String get tourHelp => 'ဤစာမျက်နှာ အသုံးပြုပုံ';

  @override
  String get tourSaveTitle => 'သိမ်းဆည်းရန်';

  @override
  String get tourSaveBody => 'ပြီးလျှင် ဤနေရာကို နှိပ်ပါ။ မနှိပ်မချင်း ဘာမှ မသိမ်းရသေးပါ။';

  @override
  String get tourLoginEmailTitle => 'သင့်အီးမေးလ်';

  @override
  String get tourLoginEmailBody => 'စာရင်းသွင်းခဲ့သော အီးမေးလ်နှင့် စကားဝှက်ဖြင့် ဝင်ပါ။';

  @override
  String get tourLoginForgotTitle => 'စကားဝှက် မေ့နေပါသလား';

  @override
  String get tourLoginForgotBody => 'ဤနေရာကို နှိပ်ပါ၊ စကားဝှက်အသစ် သတ်မှတ်ရန် လင့်ခ်ကို အီးမေးလ်ဖြင့် ပို့ပေးပါမည်။';

  @override
  String get tourLoginRegisterTitle => 'အသစ်လား';

  @override
  String get tourLoginRegisterBody => 'တစ်မိနစ်ခန့်အတွင်း အခမဲ့ အကောင့်ဖွင့်ပါ။';

  @override
  String get tourLanguageTitle => 'ဘာသာစကား';

  @override
  String get tourLanguageBody => 'မြန်မာနှင့် အင်္ဂလိပ်ကို အချိန်မရွေး ပြောင်းနိုင်ပါသည်။';

  @override
  String get tourRegisterNameTitle => 'သင့်အမည်';

  @override
  String get tourRegisterNameBody => 'ဆိုင်များက သင့်ဘိုကင်တွင် ဤအမည်ကို မြင်ရပါမည်။';

  @override
  String get tourRegisterPhoneTitle => 'ဖုန်း (မဖြစ်မနေ မဟုတ်)';

  @override
  String get tourRegisterPhoneBody => 'ဘိုကင်အကြောင်း ဆိုင်က သင့်ကို ဖုန်းဆက်နိုင်ပါမည်။';

  @override
  String get tourRegisterButtonTitle => 'အကောင့် ဖွင့်ပါ';

  @override
  String get tourRegisterButtonBody => 'ပြီးလျှင် နှိပ်ပါ။ အချက်အလက်များကို နောက်မှ ပရိုဖိုင်တွင် ပြင်နိုင်ပါသည်။';

  @override
  String get tourForgotEmailTitle => 'စကားဝှက် ပြန်သတ်မှတ်ရန်';

  @override
  String get tourForgotEmailBody => 'သင့်အကောင့် အီးမေးလ်ကို ထည့်ပါ။';

  @override
  String get tourForgotButtonTitle => 'လင့်ခ် ပို့ပါ';

  @override
  String get tourForgotButtonBody => 'ထို့နောက် inbox (နှင့် spam) ကို စစ်ပြီး လင့်ခ်အတိုင်း လုပ်ပါ။';

  @override
  String get tourExploreSearchTitle => 'ကွင်း ရှာရန်';

  @override
  String get tourExploreSearchBody => 'အားကစားကွင်းအမည် သို့မဟုတ် မြို့နယ်ကို ရိုက်ပါ။';

  @override
  String get tourExploreFiltersTitle => 'အထောက်အကူပစ္စည်းဖြင့် စစ်ရန်';

  @override
  String get tourExploreFiltersBody => 'ကားပါကင်၊ ရေချိုးခန်း စသည့် လိုအပ်သည်ကို နှိပ်ပါ။ ပြန်ဖြုတ်ရန် ထပ်နှိပ်ပါ။';

  @override
  String get tourStadiumIntroTitle => 'ကွင်း အသေးစိတ်';

  @override
  String get tourStadiumIntroBody => 'ဖွင့်ချိန်၊ ဈေးနှုန်း၊ အထောက်အကူပစ္စည်း၊ တည်နေရာနှင့် ဤကွင်းရှိ ကွင်းများ။';

  @override
  String get tourStadiumCourtsTitle => 'ကွင်း ရွေးပါ';

  @override
  String get tourStadiumCourtsBody => 'ကွင်းတစ်ခုကို နှိပ်ပြီး အားလပ်ချိန်များကို ကြည့်ပါ။';

  @override
  String get tourStadiumBookTitle => 'ကွင်း ဘိုကင်လုပ်ရန်';

  @override
  String get tourStadiumBookBody => 'သို့မဟုတ် ဤနေရာကို နှိပ်ပြီး ကွင်း၊ နေ့နှင့် အချိန် ရွေးပါ။';

  @override
  String get tourSlotsCourtTitle => 'ကွင်း ရွေးပါ';

  @override
  String get tourSlotsCourtBody => 'ကွင်းတစ်ခုစီတွင် ဈေးနှုန်း ကွဲပြားနိုင်ပါသည်။';

  @override
  String get tourSlotsDayTitle => 'နေ့ ရွေးပါ';

  @override
  String get tourSlotsDayBody => 'ရက် ၃၀ အထိ ကြိုတင် ဘိုကင်လုပ်နိုင်ပါသည်။';

  @override
  String get tourSlotsGridTitle => 'အချိန် ရွေးပါ';

  @override
  String get tourSlotsGridBody => 'စတင်ချိန်ကို နှိပ်ပါ၊ ပိုကြာကြာ ကစားလိုလျှင် နောက်ထပ် အားလပ်ချိန်များကို ဆက်နှိပ်ပါ။ မီးခိုးရောင်သည် ဘိုကင်ပြီး သို့မဟုတ် ပိတ်ထားသည်။';

  @override
  String get tourSlotsContinueTitle => 'ဆက်လုပ်ရန်';

  @override
  String get tourSlotsContinueBody => 'အချိန်နှင့် ဈေးနှုန်းကို စစ်ပြီး တောင်းဆိုမှု ပို့ပါ။';

  @override
  String get tourReviewIntroTitle => 'ဘိုကင်ကို စစ်ဆေးပါ';

  @override
  String get tourReviewIntroBody => 'ကွင်း၊ ရက်စွဲ၊ အချိန်နှင့် ဈေးနှုန်း မှန်ကန်ကြောင်း စစ်ပါ။';

  @override
  String get tourReviewSendTitle => 'တောင်းဆိုမှု ပို့ပါ';

  @override
  String get tourReviewSendBody => 'ဆိုင်က အတည်ပြု သို့မဟုတ် ငြင်းပယ်ပြီး သင့်ကို အသိပေးပါမည်။ ငွေကို ကွင်းတွင် ပေးချေပါ။';

  @override
  String get tourConfirmIntroTitle => 'တောင်းဆိုမှု ပို့ပြီးပါပြီ';

  @override
  String get tourConfirmIntroBody => 'ဆိုင်က အတည်ပြုသည်အထိ ဘိုကင်သည် စောင့်ဆိုင်းဆဲ ဖြစ်ပါသည်။ အသိပေးချက် ရရှိပါမည်။';

  @override
  String get tourConfirmViewTitle => 'ဘိုကင် ကြည့်ရန်';

  @override
  String get tourConfirmViewBody => 'အခြေအနေနှင့် အသေးစိတ်ကို အချိန်မရွေး ကြည့်နိုင်ပါသည်။';

  @override
  String get tourBookingsIntroTitle => 'ဘိုကင် အခြေအနေ';

  @override
  String get tourBookingsIntroBody => 'စောင့်ဆိုင်းဆဲ - ဆိုင်ကို စောင့်နေသည်။ အတည်ပြုပြီး - ကွင်းတွင် တွေ့မည်။ ငြင်းပယ်/ပယ်ဖျက်ပြီး - အချိန် ပြန်လွတ်သွားပြီ။';

  @override
  String get tourBookingsTabsTitle => 'လာမည့်ပွဲနှင့် ပြီးခဲ့သည့်ပွဲ';

  @override
  String get tourBookingsTabsBody => 'လာမည့်ပွဲများနှင့် ကစားပြီးသော ပွဲများကြား ပြောင်းကြည့်ပါ။';

  @override
  String get tourBookingDetailIntroTitle => 'သင့်ဘိုကင်';

  @override
  String get tourBookingDetailIntroBody => 'ဤဘိုကင်၏ အခြေအနေ၊ အချိန်၊ ကွင်းနှင့် ဈေးနှုန်း။';

  @override
  String get tourBookingDetailVenueTitle => 'ကွင်း';

  @override
  String get tourBookingDetailVenueBody => 'တည်နေရာနှင့် လမ်းညွှန်အတွက် ကွင်းစာမျက်နှာကို ဖွင့်ပါ။';

  @override
  String get tourBookingDetailCancelTitle => 'ပယ်ဖျက်ရန်';

  @override
  String get tourBookingDetailCancelBody => 'အစီအစဉ် ပြောင်းသွားပါသလား။ အခြားသူ ကစားနိုင်ရန် စတင်ချိန်မတိုင်မီ ပယ်ဖျက်ပါ။';

  @override
  String get tourNotifIntroTitle => 'သင့် အသိပေးချက်များ';

  @override
  String get tourNotifIntroBody => 'ဘိုကင် အခြေအနေများ ဤနေရာတွင် ပေါ်ပါမည်။ တစ်ခုကို နှိပ်ပြီး ထိုဘိုကင်ကို ဖွင့်ပါ။';

  @override
  String get tourNotifShopIntroBody => 'ဘိုကင် တောင်းဆိုမှုအသစ်နှင့် ပယ်ဖျက်မှုများ ဤနေရာတွင် ပေါ်ပါမည်။ တစ်ခုကို နှိပ်ပြီး ထိုဘိုကင်ကို ဖွင့်ပါ။';

  @override
  String get tourNotifMarkTitle => 'အားလုံး ဖတ်ပြီးအဖြစ် မှတ်ရန်';

  @override
  String get tourNotifMarkBody => 'မဖတ်ရသေးသော အမှတ်အသားများကို တစ်ချက်တည်းဖြင့် ရှင်းပါ။';

  @override
  String get tourProfileIntroTitle => 'သင့်ပရိုဖိုင်';

  @override
  String get tourProfileIntroBody => 'ဆိုင်များ မြင်ရသည့် သင့်အမည်၊ အီးမေးလ်နှင့် ဖုန်း။';

  @override
  String get tourProfileEditTitle => 'ပရိုဖိုင် ပြင်ရန်';

  @override
  String get tourProfileEditBody => 'အမည် သို့မဟုတ် ဖုန်းနံပါတ် ပြောင်းပါ။';

  @override
  String get tourEditPhoneBody => 'ဘိုကင်အကြောင်း ဆိုင်က ဆက်သွယ်နိုင်ရန် ဖုန်းနံပါတ် ထည့်ပါ။';

  @override
  String get tourPasswordCurrentTitle => 'လက်ရှိ စကားဝှက်';

  @override
  String get tourPasswordCurrentBody => 'လုံခြုံရေးအတွက် လက်ရှိသုံးနေသော စကားဝှက်ကို ထည့်ပါ။';

  @override
  String get tourPasswordNewTitle => 'စကားဝှက် အသစ်';

  @override
  String get tourPasswordNewBody => 'အနည်းဆုံး အက္ခရာ ၈ လုံး သုံးပါ၊ အခြားအက်ပ်မှ စကားဝှက်ကို ပြန်မသုံးပါနှင့်။';

  @override
  String get tourStaffStadiumFilterTitle => 'အားကစားကွင်းအလိုက် စစ်ရန်';

  @override
  String get tourStaffStadiumFilterBody => 'အားကစားကွင်း တစ်ခုတည်း၏ ဘိုကင်များကိုသာ ပြပါ။';

  @override
  String get tourStaffFiltersTitle => 'စာရင်းကို စစ်ရန်';

  @override
  String get tourStaffFiltersBody => 'စောင့်ဆိုင်းဆဲ ဆိုသည်မှာ ဆုံးဖြတ်ချက် စောင့်နေခြင်း ဖြစ်သည်။ လာမည့်၊ ပြီးခဲ့သည့် သို့မဟုတ် အားလုံးသို့ ပြောင်းပါ။';

  @override
  String get tourStaffBlockTitle => 'အချိန် ပိတ်ရန်';

  @override
  String get tourStaffBlockBody => 'ပြုပြင်ထိန်းသိမ်းမှု သို့မဟုတ် သီးသန့်ပွဲအတွက် ကွင်းကို ပိတ်ပြီး မည်သူမျှ ဘိုကင်မလုပ်နိုင်အောင် ထားပါ။';

  @override
  String get tourStaffDetailIntroTitle => 'ဘိုကင်';

  @override
  String get tourStaffDetailIntroBody => 'ဖောက်သည်၊ အချိန်၊ ကွင်း၊ ဈေးနှုန်းနှင့် ငွေပေးချေမှု။ ဖောက်သည်ကို နှိပ်ပြီး မှတ်တမ်း ကြည့်ပါ။';

  @override
  String get tourStaffConfirmTitle => 'အတည်ပြုရန်';

  @override
  String get tourStaffConfirmBody => 'တောင်းဆိုမှုကို လက်ခံပါ။ ဖောက်သည်ထံ အသိပေးချက် ရောက်ပါမည်။';

  @override
  String get tourStaffPaymentTitle => 'ငွေပေးချေမှု';

  @override
  String get tourStaffPaymentBody => 'ငွေပေးချေမှုကို အဆင့်လိုက် မှတ်ပါ - စောင့်ဆိုင်းဆဲ၊ ထို့နောက် ပေးပြီး။';

  @override
  String get tourStaffRejectTitle => 'ငြင်းပယ်ရန်';

  @override
  String get tourStaffRejectBody => 'အချိန်ကို အခြားသူများအတွက် လွတ်စေပါသည်။ ဖောက်သည်ကို အသိပေးပါမည်။';

  @override
  String get tourShopCustomersIntroBody => 'သင့်ဆိုင်တွင် ဘိုကင်လုပ်ဖူးသူ အားလုံး။ အသေးစိတ်အတွက် အမည်ကို နှိပ်ပါ။';

  @override
  String get tourCustomerSearchTitle => 'ဖောက်သည် ရှာရန်';

  @override
  String get tourCustomerSearchBody => 'အမည် သို့မဟုတ် ဖုန်းနံပါတ်ဖြင့် ရှာပါ။';

  @override
  String get tourCustomerDetailIntroTitle => 'ဖောက်သည်';

  @override
  String get tourCustomerDetailIntroBody => 'ဆက်သွယ်ရန် အချက်အလက်နှင့် ဘိုကင် မှတ်တမ်း။';

  @override
  String get tourBlacklistActionTitle => 'အမည်ပျက်စာရင်း';

  @override
  String get tourBlacklistActionBody => 'မကြာခဏ မလာသူကို သင့်ဆိုင်တွင် ဘိုကင်မလုပ်နိုင်အောင် တားပါသည်။ အခြားဆိုင်များကို မထိခိုက်ပါ။';

  @override
  String get tourShopSettingsIntroTitle => 'ဆက်တင်များ';

  @override
  String get tourShopSettingsIntroBody => 'ဆိုင်ပရိုဖိုင်၊ ပိတ်ထားသော အချိန်၊ အမည်ပျက်စာရင်းနှင့် အားကစားကွင်းများ တစ်နေရာတည်းတွင်။';

  @override
  String get tourShopProfileIntroTitle => 'ဆိုင်ပရိုဖိုင်';

  @override
  String get tourShopProfileIntroBody => 'ဖောက်သည်များ မြင်ရမည့် သင့်ဆိုင်ပုံစံ။';

  @override
  String get tourShopProfileEditTitle => 'ပြင်ရန်';

  @override
  String get tourShopProfileEditBody => 'အမည်၊ ဖုန်းနှင့် လိပ်စာကို ပြင်ပါ။';

  @override
  String get tourStadiumsIntroTitle => 'သင့် အားကစားကွင်းများ';

  @override
  String get tourStadiumsIntroBody => 'အားကစားကွင်းတိုင်းတွင် ကိုယ်ပိုင် ဖွင့်ချိန်နှင့် ကွင်းများ ရှိသည်။ စီမံရန် တစ်ခုကို နှိပ်ပါ။';

  @override
  String get tourStadiumsAddTitle => 'အားကစားကွင်း ထည့်ရန်';

  @override
  String get tourStadiumsAddBody => 'ဤနေရာမှ စပါ - ကွင်းကို ထည့်ပြီး ၎င်း၏ ကွင်းများကို ထည့်ပါ။';

  @override
  String get tourStadiumEditTitle => 'အားကစားကွင်း ပြင်ရန်';

  @override
  String get tourStadiumEditBody => 'အမည်၊ လိပ်စာ၊ ဖွင့်ချိန်နှင့် အထောက်အကူပစ္စည်းများကို ပြင်ပါ။';

  @override
  String get tourStadiumAddCourtTitle => 'ကွင်း ထည့်ရန်';

  @override
  String get tourStadiumAddCourtBody => 'ကွင်းတစ်ခုစီတွင် ကိုယ်ပိုင် ဈေးနှုန်းနှင့် အချိန်အပိုင်း ရှိသည်။';

  @override
  String get tourStadiumFormNameTitle => 'အားကစားကွင်း အမည်';

  @override
  String get tourStadiumFormNameBody => 'ဖောက်သည်များ မြင်ရပြီး ရှာမည့် အမည်။';

  @override
  String get tourStadiumFormMapTitle => 'မြေပုံ တည်နေရာ';

  @override
  String get tourStadiumFormMapBody => 'ဖောက်သည်များ လမ်းညွှန် ရနိုင်ရန် ကွင်းကို ပင်ထိုးပါ။';

  @override
  String get tourStadiumFormHoursTitle => 'ဖွင့်ချိန်';

  @override
  String get tourStadiumFormHoursBody => 'ဖောက်သည်များ ဤအချိန်အတွင်းသာ ဘိုကင်လုပ်နိုင်ပါသည်။';

  @override
  String get tourStadiumFormFacilitiesTitle => 'အထောက်အကူပစ္စည်းများ';

  @override
  String get tourStadiumFormFacilitiesBody => 'သင်ပေးနိုင်သည်များကို ရွေးပါ။ ဖောက်သည်များ ဤအချက်ဖြင့် ကွင်းများကို စစ်ပါသည်။';

  @override
  String get tourCourtIntroTitle => 'ကွင်း';

  @override
  String get tourCourtIntroBody => 'ဈေးနှုန်း၊ အချိန်အပိုင်းနှင့် ဖောက်သည်များ ဘိုကင်လုပ်နိုင်/မနိုင်။';

  @override
  String get tourCourtEditTitle => 'ကွင်း ပြင်ရန်';

  @override
  String get tourCourtEditBody => 'အမည် သို့မဟုတ် ဈေးနှုန်း ပြင်ရန်၊ သို့မဟုတ် ဘိုကင် ပိတ်ရန်။';

  @override
  String get tourCourtFormNameTitle => 'ကွင်း အမည်';

  @override
  String get tourCourtFormNameBody => 'ဥပမာ “ကွင်း A” သို့မဟုတ် “အမိုးအကာပါ ကွင်း”။';

  @override
  String get tourCourtFormPriceTitle => 'တစ်နာရီ ဈေးနှုန်း';

  @override
  String get tourCourtFormPriceBody => 'တစ်နာရီလျှင် ကျပ်ဖြင့်။ ဘိုကင်ဈေးကို ဤနှုန်းမှ တွက်ပါသည်။';

  @override
  String get tourCourtFormSlotTitle => 'အချိန်အပိုင်း';

  @override
  String get tourCourtFormSlotBody => 'မိနစ် ၃၀ သို့မဟုတ် ၆၀။ နောက်မှ ပြောင်း၍ မရသဖြင့် သေချာ ရွေးပါ။';

  @override
  String get tourBlockedIntroTitle => 'ပိတ်ထားသော အချိန်များ';

  @override
  String get tourBlockedIntroBody => 'သင် ပိတ်ထားသော အချိန်များ။ ဖောက်သည်များ ဘိုကင်မလုပ်နိုင်ပါ။';

  @override
  String get tourBlockedAddBody => 'ပြုပြင်ထိန်းသိမ်းမှု၊ သန့်ရှင်းရေး သို့မဟုတ် ပွဲအတွက် ကွင်းကို ပိတ်ပါ။';

  @override
  String get tourBlockFormWhereTitle => 'မည်သည့်နေရာ';

  @override
  String get tourBlockFormWhereBody => 'အားကစားကွင်းကို ရွေးပြီး ပိတ်မည့် ကွင်းကို ရွေးပါ။';

  @override
  String get tourBlockFormButtonBody => 'ဘိုကင်ပြီးသော အချိန်ကို ပိတ်၍ မရပါ။ ထိုဘိုကင်ကို အရင် ငြင်းပယ်ပါ။';

  @override
  String get tourBlacklistIntroTitle => 'အမည်ပျက်စာရင်း';

  @override
  String get tourBlacklistIntroBody => 'ဤစာရင်းရှိ ဖောက်သည်များ သင့်ဆိုင်တွင် ဘိုကင်အသစ် မလုပ်နိုင်ပါ။ ပြန်ခွင့်ပြုရန် ဖယ်ရှားရန် အိုင်ကွန်ကို နှိပ်ပါ။';

  @override
  String get tourMapTitle => 'မြေပုံကို ရွှေ့ပါ';

  @override
  String get tourMapBody => 'ပင်သည် သင့်ကွင်းပေါ် ရောက်သည်အထိ ဆွဲရွှေ့ပါ။ ချဲ့ရန် လက်နှစ်ချောင်းဖြင့် ဖြန့်ပါ။';

  @override
  String get tourMapUseTitle => 'ဤတည်နေရာကို သုံးမည်';

  @override
  String get tourMapUseBody => 'ပင်ကို အားကစားကွင်း ဖောင်တွင် သိမ်းပါသည်။';

  @override
  String get tourShopsSegmentsTitle => 'အားလုံး သို့မဟုတ် စစ်ဆေးရန် ကျန်';

  @override
  String get tourShopsSegmentsBody => 'ဆိုင်အသစ် လျှောက်ထားမှုများ သင် အတည်ပြုသည်အထိ စစ်ဆေးရန် ကျန်တွင် စောင့်ပါသည်။';

  @override
  String get tourShopsAddTitle => 'ဆိုင် ထည့်ရန်';

  @override
  String get tourShopsAddBody => 'ဆိုင်ကို ကိုယ်တိုင် ဖန်တီးပြီး ဆိုင်စီမံသူကို သတ်မှတ်ပါ။';

  @override
  String get tourShopDetailEditTitle => 'ဆိုင် ပြင်ရန်';

  @override
  String get tourShopDetailEditBody => 'အမည်၊ ဆက်သွယ်ရန်နှင့် ပိုင်ရှင် အချက်အလက်ကို ပြင်ပါ။';

  @override
  String get tourShopDetailStatusTitle => 'ဆိုင် အခြေအနေ';

  @override
  String get tourShopDetailStatusBody => 'အတည်ပြု၊ ဆိုင်းငံ့ သို့မဟုတ် ပြန်ဖွင့်ပါ။ ဆိုင်းငံ့ထားသော သို့မဟုတ် စာရင်းမပြသော ဆိုင်များ ဘိုကင်အသစ် မရပါ။';

  @override
  String get tourShopDetailAdminsTitle => 'ဆိုင်စီမံသူများ';

  @override
  String get tourShopDetailAdminsBody => 'ဤဆိုင်ကို စီမံသူများကို ကြည့်ပြီး သတ်မှတ်ပါ။';

  @override
  String get tourShopFormNameTitle => 'ဆိုင် အမည်';

  @override
  String get tourShopFormNameBody => 'ဤဆိုင်၏ အားကစားကွင်းတိုင်းတွင် ဖောက်သည်များကို ပြပါသည်။';

  @override
  String get tourShopFormOwnerTitle => 'ပိုင်ရှင် အချက်အလက်';

  @override
  String get tourShopFormOwnerBody => 'သီးသန့် - သင်နှင့် ဆိုင်စီမံသူများသာ မြင်ရပါသည်။';

  @override
  String get tourShopAdminsIntroTitle => 'ဆိုင်စီမံသူများ';

  @override
  String get tourShopAdminsIntroBody => 'ဤဆိုင်ကို စီမံသူများ။ ၎င်းတို့ ဤဆိုင်၏ အချက်အလက်ကိုသာ မြင်ရပါသည်။';

  @override
  String get tourShopAdminsAddTitle => 'စီမံသူ ထည့်ရန်';

  @override
  String get tourShopAdminsAddBody => 'ထိုသူသည် ဖောက်သည်အကောင့်ကို အရင် ဖွင့်ထားရပါမည်။';

  @override
  String get tourInviteEmailTitle => 'အကောင့် ရှာရန်';

  @override
  String get tourInviteEmailBody => '၎င်းတို့ စာရင်းသွင်းခဲ့သော အီးမေးလ်ကို ထည့်ပါ။';

  @override
  String get tourInviteFindTitle => 'ရှာရန်';

  @override
  String get tourInviteFindBody => 'ထို့နောက် အမည်ကို စစ်ပြီး ဤဆိုင်၏ စီမံသူ အဖြစ် သတ်မှတ်ပါ။';

  @override
  String get tourAnnouncementsIntroTitle => 'ကြေညာချက်များ';

  @override
  String get tourAnnouncementsIntroBody => 'အသုံးပြုသူများထံ သင် ပို့ခဲ့သော စာများ။';

  @override
  String get tourAnnouncementsAddTitle => 'ကြေညာချက် အသစ်';

  @override
  String get tourAnnouncementsAddBody => 'ဖောက်သည်၊ ဆိုင်စီမံသူ သို့မဟုတ် အားလုံးအတွက် စာ ရေးပါ။';

  @override
  String get tourAnnounceAudienceTitle => 'ပို့မည့်သူ';

  @override
  String get tourAnnounceAudienceBody => 'မည်သူ လက်ခံမည်ကို ရွေးပါ။';

  @override
  String get tourAnnounceSendTitle => 'ပို့ရန်';

  @override
  String get tourAnnounceSendBody => 'စာသားကို အရင် စစ်ပါ - ပို့ပြီးလျှင် ပြန်ရုပ်သိမ်း၍ မရပါ။';

  @override
  String get tourAdminCustomersIntroBody => 'ပလက်ဖောင်းရှိ ဖောက်သည် အားလုံး။ အသေးစိတ်အတွက် အမည်ကို နှိပ်ပါ။';

  @override
  String get tourAdminCustomerDetailBody => 'ဆက်သွယ်ရန် အချက်အလက်နှင့် ဘိုကင်များ။ အောက်ရှိ ခလုတ်ဖြင့် အကောင့်ကို ပိတ် သို့မဟုတ် ပြန်ဖွင့်ပါ။';

  @override
  String get tourAdminSettingsIntroBody => 'ကြေညာချက်များ၊ စစ်ဆေးရန် စောင့်နေသော ဆိုင်များနှင့် ဤလမ်းညွှန်။';
}
