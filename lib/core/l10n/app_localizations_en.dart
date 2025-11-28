// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titleCatalog => 'Components Catalog';

  @override
  String get buttonsDemo => 'Buttons';

  @override
  String get buttonsSubtitle => 'Variants, states and sizes';

  @override
  String get badgesDemo => 'Badges';

  @override
  String get badgesSubtitle => 'States and categories';

  @override
  String get preferences => 'Preferences';

  @override
  String get more => 'More';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get badgesFilterTitle => 'Filter badges';

  @override
  String get filterAll => 'All';

  @override
  String get filterMusic => 'Music';

  @override
  String get filterArt => 'Art';

  @override
  String get filterSports => 'Sports';

  @override
  String get statusTitle => 'Status';

  @override
  String get rewardTitle => 'Reward';

  @override
  String get infoTitle => 'Info';

  @override
  String get categoryTitle => 'Category';

  @override
  String get active => 'Active';

  @override
  String get reviews => 'Reviews';

  @override
  String get primaryButtonsTitle => 'Primary (Download / Share)';

  @override
  String get download => 'Download';

  @override
  String get share => 'Share';

  @override
  String get dangerButtonsTitle => 'Danger (Cancel / Delete)';

  @override
  String get cancelTicket => 'Cancel ticket';

  @override
  String get disabled => 'Disabled';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String points(num value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value points',
      one: '1 point',
      zero: '0 points',
    );
    return '$_temp0';
  }

  @override
  String get filterChipsDemo => 'Filter Chips';

  @override
  String get filterChipsSubtitle => 'Selectable filter options';

  @override
  String get filterChipsTitle => 'Filter options';

  @override
  String get navigationDemo => 'Navigation';

  @override
  String get navigationDemoSubtitle => 'AppBar and bottom bar';

  @override
  String get navEvents => 'Events';

  @override
  String get navTickets => 'Tickets';

  @override
  String get navScan => 'Scan';

  @override
  String get navExplore => 'Explore';

  @override
  String get navProfile => 'Profile';

  @override
  String currentTab(int value) {
    return 'Current tab: $value';
  }

  @override
  String get discoverEvents => 'Discover Events';

  @override
  String get findAmazingEvents => 'Find amazing events near you';

  @override
  String get featuredEvents => 'Featured Events';

  @override
  String errorLoadingCategories(String error) {
    return 'Error loading categories: $error';
  }

  @override
  String get errorLoadingEvents => 'Error loading events';

  @override
  String get retry => 'Retry';

  @override
  String get noEventsAvailable => 'No events available';

  @override
  String get tryAnotherCategory => 'Try selecting another category';

  @override
  String get noMoreEvents => 'No more events';

  @override
  String get noLocation => 'No location';

  @override
  String get allCategories => 'All';

  @override
  String get cardsDemo => 'Cards';

  @override
  String get cardsSubtitle => 'Event cards with horizontal layout';

  @override
  String get cardsDemoTitle => 'Event Card';

  @override
  String get eventTapped => 'Event tapped!';

  @override
  String get sampleEventTitle => 'Summer Music Festival';

  @override
  String get sampleEventLocation => 'Central Park';

  @override
  String get textFieldsDemo => 'Text Fields';

  @override
  String get textFieldsSubtitle => 'Text, email and password variants';

  @override
  String get textFieldsTextVariantTitle =>
      'Text variant (with and without icon)';

  @override
  String get textFieldsEmailVariantTitle =>
      'Email variant (with and without icon)';

  @override
  String get textFieldsPasswordVariantTitle =>
      'Password variant (with and without icon)';

  @override
  String get textFieldsDisabledTitle => 'Disabled state';

  @override
  String get textFieldsNameLabel => 'Name';

  @override
  String get textFieldsNameHint => 'Enter your name';

  @override
  String get textFieldsEmailLabel => 'Email';

  @override
  String get textFieldsEmailHint => 'your@email.com';

  @override
  String get textFieldsPasswordLabel => 'Password';

  @override
  String get signInRegister => 'Sign In / Register';

  @override
  String get exploreWithoutSignIn =>
      'You can still explore events and POIs without signing in';

  @override
  String get signInToViewTickets => 'Sign in to View Tickets';

  @override
  String get signInToViewTicketsDesc =>
      'Create an account or sign in to purchase tickets, manage bookings, and access your QR codes.';

  @override
  String get signInToScanQR => 'Sign in to Scan QR Codes';

  @override
  String get signInToScanQRDesc =>
      'Create an account or sign in to scan QR codes, validate tickets, and access exclusive content.';

  @override
  String get signInToYourProfile => 'Sign in to Your Profile';

  @override
  String get signInToYourProfileDesc =>
      'Create an account to personalize your experience, manage settings, and view your activity history.';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get name => 'Name';

  @override
  String get lastname => 'Lastname';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String welcomeMessage(String name) {
    return 'Welcome to PoiQuest, $name!';
  }

  @override
  String errorLogin(String error) {
    return 'Error signing in: $error';
  }

  @override
  String errorRegister(String error) {
    return 'Error registering: $error';
  }

  @override
  String get userRegistered => 'User registered successfully';

  @override
  String get featureInDevelopment => 'Feature in development';

  @override
  String get filledButtonsSmall => 'Filled Buttons - Small';

  @override
  String get filledButtonsMedium => 'Filled Buttons - Medium (Default)';

  @override
  String get filledButtonsLarge => 'Filled Buttons - Large';

  @override
  String get withoutIcon => 'Without icon';

  @override
  String get withIcon => 'With icon';

  @override
  String get loadingState => 'Loading State';

  @override
  String get toggleLoading => 'Toggle Loading';

  @override
  String get processing => 'Processing...';

  @override
  String get smallButton => 'Small Button';

  @override
  String get mediumButton => 'Medium Button';

  @override
  String get largeButton => 'Large Button';

  @override
  String validatorRequired(String fieldName) {
    return 'Please enter $fieldName';
  }

  @override
  String get validatorRequiredDefault => 'Please enter this field';

  @override
  String get validatorEmailRequired => 'Please enter your email';

  @override
  String get validatorEmailInvalid => 'Enter a valid email';

  @override
  String validatorInvalid(String fieldName) {
    return '$fieldName is invalid';
  }

  @override
  String validatorEmailMaxLength(int maxLength) {
    return 'Email cannot exceed $maxLength characters';
  }

  @override
  String get validatorPasswordRequired => 'Please enter a password';

  @override
  String validatorPasswordMinLength(int minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String get validatorPasswordStrong =>
      'Must include lowercase, uppercase and number';

  @override
  String get validatorConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get validatorPasswordMismatch => 'Passwords do not match';

  @override
  String validatorMaxLength(String fieldName, int maxLength) {
    return '$fieldName cannot exceed $maxLength characters';
  }

  @override
  String validatorMaxLengthDefault(int maxLength) {
    return 'This field cannot exceed $maxLength characters';
  }

  @override
  String get validatorNameRequired => 'your name';

  @override
  String validatorNameMaxLength(int maxLength) {
    return 'Name cannot exceed $maxLength characters';
  }

  @override
  String get validatorLastnameRequired => 'your lastname';

  @override
  String validatorLastnameMaxLength(int maxLength) {
    return 'Lastname cannot exceed $maxLength characters';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get accountTitle => 'Account';

  @override
  String get sessionTitle => 'Session';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editProfileSubtitle => 'Update your personal information';

  @override
  String get changeAvatar => 'Change Avatar';

  @override
  String get changeAvatarSubtitle => 'Update your profile picture';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Update your password';

  @override
  String get logout => 'Logout';

  @override
  String get logoutSubtitle => 'Close session on this device';

  @override
  String get logoutAllDevices => 'Logout All Devices';

  @override
  String get logoutAllDevicesSubtitle => 'Close all sessions everywhere';

  @override
  String get logoutDialogTitle => 'Logout';

  @override
  String get logoutDialogContent => 'Do you want to logout from this device?';

  @override
  String get logoutAllDialogTitle => 'Logout All Sessions';

  @override
  String get logoutAllDialogContent =>
      'Do you want to logout from all your devices? You will need to login again on all of them.';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get profileLoadError => 'Could not load profile';

  @override
  String get profileLoadErrorTitle => 'Error loading profile';

  @override
  String logoutError(String error) {
    return 'Error logging out: $error';
  }

  @override
  String logoutAllError(String error) {
    return 'Error logging out from all sessions: $error';
  }

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'Tell us about yourself...';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String profileUpdateError(String error) {
    return 'Error updating profile: $error';
  }

  @override
  String get avatarUrl => 'Avatar URL';

  @override
  String get avatarUrlHint => 'https://example.com/avatar.jpg';

  @override
  String get avatarUrlHelp => 'Enter the URL of your new profile image';

  @override
  String get updateAvatar => 'Update Avatar';

  @override
  String get avatarUpdatedSuccess => 'Avatar updated successfully';

  @override
  String avatarUpdateError(String error) {
    return 'Error updating avatar: $error';
  }

  @override
  String get oldPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordUpdatedTitle => 'Password Updated';

  @override
  String get passwordUpdatedContent =>
      'All your sessions have been closed. Please login again.';

  @override
  String get passwordChangeError => 'Error changing password';

  @override
  String get passwordIncorrect => 'The current password is incorrect';

  @override
  String get ok => 'OK';

  @override
  String get logoutAllButton => 'Logout All';

  @override
  String get passwordRequirementsTitle => 'Password requirements:';

  @override
  String get passwordRequirementMinLength => '• Minimum 12 characters';

  @override
  String get passwordRequirementUppercase => '• At least one uppercase letter';

  @override
  String get passwordRequirementLowercase => '• At least one lowercase letter';

  @override
  String get passwordRequirementNumber => '• At least one number';

  @override
  String level(int levelNumber) {
    return 'Level $levelNumber';
  }

  @override
  String get createevent => 'Create Event';

  @override
  String get editevent => 'Edit Event';

  @override
  String get eventname => 'Event Name';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get location => 'Location';

  @override
  String get startdate => 'Start Date';

  @override
  String get enddate => 'End Date';

  @override
  String get imageurl => 'Image URL';

  @override
  String get pleaseselectacategory => 'Please select a category';

  @override
  String get atleastoneimagerequired => 'At least one image is required';

  @override
  String get invalidurl => 'Invalid URL';

  @override
  String get fieldisrequired => 'This field is required';

  @override
  String get eventcreatedsuccessfully => 'Event created successfully';

  @override
  String get eventupdatedsuccessfully => 'Event updated successfully';

  @override
  String get eventdeletedsuccessfully => 'Event deleted successfully';

  @override
  String get create => 'Create';

  @override
  String get save => 'Save';

  @override
  String get deleteevent => 'Delete Event';

  @override
  String get deleteeventconfirm =>
      'Are you sure you want to delete this event? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get activeevents => 'Active Events';

  @override
  String get manageevents => 'Manage your events';

  @override
  String get adminCreateFirstEventHint =>
      'Create your first event with the + button';

  @override
  String get invalidCredentials => 'Email or password incorrect';
}
