///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsBtnActionsEn btnActions = TranslationsBtnActionsEn._(_root);
	late final TranslationsAuthMessagesEn authMessages = TranslationsAuthMessagesEn._(_root);
}

// Path: btnActions
class TranslationsBtnActionsEn {
	TranslationsBtnActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Authenticate'
	String get authenticate => 'Authenticate';

	/// en: 'Register'
	String get register => 'Register';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Login'
	String get logIn => 'Login';

	/// en: 'Back to login page'
	String get backToLogin => 'Back to login page';

	/// en: 'Change font'
	String get changeFont => 'Change font';
}

// Path: authMessages
class TranslationsAuthMessagesEn {
	TranslationsAuthMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthMessagesPromptEn prompt = TranslationsAuthMessagesPromptEn._(_root);
	late final TranslationsAuthMessagesErrorEn error = TranslationsAuthMessagesErrorEn._(_root);
}

// Path: authMessages.prompt
class TranslationsAuthMessagesPromptEn {
	TranslationsAuthMessagesPromptEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enter password'
	String get askPassword => 'Enter password';

	/// en: 'Please authenticate to enter the app.'
	String get askAuthenticate => 'Please authenticate to enter the app.';

	/// en: 'Retype your password'
	String get retypePassword => 'Retype your password';

	/// en: 'Forgot your password?'
	String get forgotPassword => 'Forgot your password?';
}

// Path: authMessages.error
class TranslationsAuthMessagesErrorEn {
	TranslationsAuthMessagesErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'An unknown error occurred. Please contact the support team.'
	String get unknown => 'An unknown error occurred. Please contact the support team.';

	/// en: 'Invalid email. Try again, please.'
	String get emailAddressInvalid => 'Invalid email. Try again, please.';

	/// en: 'This email is already in use.'
	String get emailExists => 'This email is already in use.';

	/// en: 'Confirm your account by clicking in the link sent to your email.'
	String get emailNotConfirmed => 'Confirm your account by clicking in the link sent to your email.';

	/// en: 'Your email or password is incorrect.'
	String get invalidCredentials => 'Your email or password is incorrect.';

	/// en: 'The passwords are not the same.'
	String get passwordMismatch => 'The passwords are not the same.';

	/// en: 'Your password needs to have at least 8 characters.'
	String get passwordTooShort => 'Your password needs to have at least 8 characters.';

	/// en: 'You cannot use the same password as before.'
	String get samePassword => 'You cannot use the same password as before.';

	/// en: 'Your password needs to have at least 1 upper case character, 1 lowercase, 1 number and 1 special character.'
	String get weakPassword => 'Your password needs to have at least 1 upper case character, 1 lowercase, 1 number and 1 special character.';

	/// en: 'You are making too many requests. Please try again later.'
	String get overRequestRateLimit => 'You are making too many requests. Please try again later.';

	/// en: 'Wrong password'
	String get wrongPassword => 'Wrong password';

	/// en: 'Your name cannot be bigger than 100 characters.'
	String get nameTooLong => 'Your name cannot be bigger than 100 characters.';

	/// en: 'No internet connection'
	String get noConnection => 'No internet connection';

	/// en: 'The server could not satisfy your request. Please try again later.'
	String get unprocessableEntity => 'The server could not satisfy your request. Please try again later.';

	/// en: 'Servers are overloaded right now. Please try again later.'
	String get tooManyRequests => 'Servers are overloaded right now. Please try again later.';

	/// en: 'There was an error processing your request. Please try again later.'
	String get internalServerError => 'There was an error processing your request. Please try again later.';

	/// en: 'An error occurred. Please try to login again.'
	String get tryLoginAgain => 'An error occurred. Please try to login again.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'btnActions.confirm': return 'Confirm';
			case 'btnActions.cancel': return 'Cancel';
			case 'btnActions.authenticate': return 'Authenticate';
			case 'btnActions.register': return 'Register';
			case 'btnActions.password': return 'Password';
			case 'btnActions.logIn': return 'Login';
			case 'btnActions.backToLogin': return 'Back to login page';
			case 'btnActions.changeFont': return 'Change font';
			case 'authMessages.prompt.askPassword': return 'Enter password';
			case 'authMessages.prompt.askAuthenticate': return 'Please authenticate to enter the app.';
			case 'authMessages.prompt.retypePassword': return 'Retype your password';
			case 'authMessages.prompt.forgotPassword': return 'Forgot your password?';
			case 'authMessages.error.unknown': return 'An unknown error occurred. Please contact the support team.';
			case 'authMessages.error.emailAddressInvalid': return 'Invalid email. Try again, please.';
			case 'authMessages.error.emailExists': return 'This email is already in use.';
			case 'authMessages.error.emailNotConfirmed': return 'Confirm your account by clicking in the link sent to your email.';
			case 'authMessages.error.invalidCredentials': return 'Your email or password is incorrect.';
			case 'authMessages.error.passwordMismatch': return 'The passwords are not the same.';
			case 'authMessages.error.passwordTooShort': return 'Your password needs to have at least 8 characters.';
			case 'authMessages.error.samePassword': return 'You cannot use the same password as before.';
			case 'authMessages.error.weakPassword': return 'Your password needs to have at least 1 upper case character, 1 lowercase, 1 number and 1 special character.';
			case 'authMessages.error.overRequestRateLimit': return 'You are making too many requests. Please try again later.';
			case 'authMessages.error.wrongPassword': return 'Wrong password';
			case 'authMessages.error.nameTooLong': return 'Your name cannot be bigger than 100 characters.';
			case 'authMessages.error.noConnection': return 'No internet connection';
			case 'authMessages.error.unprocessableEntity': return 'The server could not satisfy your request. Please try again later.';
			case 'authMessages.error.tooManyRequests': return 'Servers are overloaded right now. Please try again later.';
			case 'authMessages.error.internalServerError': return 'There was an error processing your request. Please try again later.';
			case 'authMessages.error.tryLoginAgain': return 'An error occurred. Please try to login again.';
			default: return null;
		}
	}
}

