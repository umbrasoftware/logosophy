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
	late final TranslationsSetupEn setup = TranslationsSetupEn._(_root);
	late final TranslationsNavBarEn navBar = TranslationsNavBarEn._(_root);
	late final TranslationsBookPageEn bookPage = TranslationsBookPageEn._(_root);
	late final TranslationsNotesPageEn notesPage = TranslationsNotesPageEn._(_root);
	late final TranslationsSettingsPageEn settingsPage = TranslationsSettingsPageEn._(_root);
	late final TranslationsSearchPageEn searchPage = TranslationsSearchPageEn._(_root);
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

	/// en: 'Registration successful! You can now log in.'
	String get registrationSuccess => 'Registration successful! You can now log in.';

	/// en: 'Register with Google'
	String get registerWithGoogle => 'Register with Google';

	/// en: 'Register with Apple'
	String get registerWithApple => 'Register with Apple';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Login'
	String get logIn => 'Login';

	/// en: 'Back to login page'
	String get backToLogin => 'Back to login page';

	/// en: 'Change font'
	String get changeFont => 'Change font';

	/// en: 'Continue'
	String get continueAction => 'Continue';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Confirm delete'
	String get confirmDelete => 'Confirm delete';

	/// en: 'Apply'
	String get apply => 'Apply';
}

// Path: setup
class TranslationsSetupEn {
	TranslationsSetupEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'It seems you don't have any books yet. Please select a language for the books to start using the app!'
	String get noBooks => 'It seems you don\'t have any books yet. Please select a language for the books to start using the app!';

	/// en: 'Starting download'
	String get starting => 'Starting download';

	/// en: 'Downloading books'
	String get downloadingBooks => 'Downloading books';

	/// en: 'Downloading $filename ($current of $total)'
	String downloadProgress({required Object filename, required Object current, required Object total}) => 'Downloading ${filename}\n(${current} of ${total})';

	/// en: 'Download complete!'
	String get downloadComplete => 'Download complete!';
}

// Path: navBar
class TranslationsNavBarEn {
	TranslationsNavBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Books'
	String get books => 'Books';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Notes'
	String get notes => 'Notes';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: bookPage
class TranslationsBookPageEn {
	TranslationsBookPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find...'
	String get find => 'Find...';

	/// en: 'Clear text'
	String get clearText => 'Clear text';

	/// en: 'Search Result'
	String get searchResult => 'Search Result';

	/// en: 'No result'
	String get noResult => 'No result';

	/// en: 'Cancel search'
	String get cancelSearch => 'Cancel search';

	/// en: 'No more occurrences found. Would you like to continue to search from the beginning?'
	String get noMoreResults => 'No more occurrences found. Would you like to continue to search from the beginning?';

	/// en: 'YES'
	String get YES => 'YES';

	/// en: 'NO'
	String get NO => 'NO';

	/// en: 'Previous'
	String get previous => 'Previous';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Previous instance'
	String get previousInstance => 'Previous instance';

	/// en: 'Next instance'
	String get nextInstance => 'Next instance';

	/// en: 'of'
	String get of => 'of';

	/// en: 'Highlight'
	String get highlight => 'Highlight';

	/// en: 'Underline'
	String get underline => 'Underline';

	/// en: 'Strikethrough'
	String get strikethrough => 'Strikethrough';

	/// en: 'Squiggly'
	String get squiggly => 'Squiggly';

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Page $page'
	String page({required Object page}) => 'Page ${page}';

	/// en: 'Book annotations'
	String get bookAnnotations => 'Book annotations';
}

// Path: notesPage
class TranslationsNotesPageEn {
	TranslationsNotesPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Book notes'
	String get bookNotes => 'Book notes';

	/// en: 'No notes found for this book.'
	String get noBookNotes => 'No notes found for this book.';

	/// en: 'Edit note'
	String get editNote => 'Edit note';

	/// en: 'New note for page $page'
	String newNote({required Object page}) => 'New note for page ${page}';

	/// en: 'Write your notes here...'
	String get writeNotes => 'Write your notes here...';

	/// en: 'Note updated!'
	String get noteUpdated => 'Note updated!';

	/// en: 'Note deleted.'
	String get noteDeleted => 'Note deleted.';

	/// en: 'Are you sure you want to delete this note?'
	String get confirmDelete => 'Are you sure you want to delete this note?';

	/// en: 'New note saved!'
	String get newNoteSaved => 'New note saved!';

	/// en: 'My notes'
	String get myNotes => 'My notes';

	/// en: 'Filters'
	String get filters => 'Filters';

	/// en: 'Filter by book'
	String get filterByBook => 'Filter by book';

	/// en: 'All books'
	String get allBooks => 'All books';

	/// en: 'After...'
	String get afterDate => 'After...';

	/// en: 'Before...'
	String get beforeDate => 'Before...';

	/// en: 'Clear filters'
	String get clearFilters => 'Clear filters';

	/// en: 'No notes found with the applied filters.'
	String get noNotesFound => 'No notes found with the applied filters.';

	/// en: 'General notes'
	String get generalNotes => 'General notes';

	/// en: 'Delete note'
	String get deleteNote => 'Delete note';

	/// en: 'Are you sure you want to delete this note?'
	String get deleteConfirmation => 'Are you sure you want to delete this note?';

	/// en: 'Note deleted successfully!'
	String get noteDeletedSuccess => 'Note deleted successfully!';

	/// en: 'Create general note'
	String get createGeneralNote => 'Create general note';

	/// en: 'Note saved!'
	String get noteSaved => 'Note saved!';

	/// en: 'Write your note here ...'
	String get writeHere => 'Write your note here ...';

	/// en: 'Add note to $bookName'
	String bookNoteAdd({required Object bookName}) => 'Add note to ${bookName}';

	/// en: 'Edit note in $bookName'
	String bookNoteEdit({required Object bookName}) => 'Edit note in ${bookName}';
}

// Path: settingsPage
class TranslationsSettingsPageEn {
	TranslationsSettingsPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Português (Brasil)'
	String get portuguese => 'Português (Brasil)';

	/// en: 'English (US)'
	String get english => 'English (US)';

	/// en: 'Select Language'
	String get selectLanguage => 'Select Language';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Sign out'
	String get signOut => 'Sign out';
}

// Path: searchPage
class TranslationsSearchPageEn {
	TranslationsSearchPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unkown book'
	String get unkownBook => 'Unkown book';

	/// en: 'Type your search'
	String get typeYourSearch => 'Type your search';

	/// en: 'Type something to start your search'
	String get startSearch => 'Type something to start your search';

	/// en: 'No results found'
	String get noResultFound => 'No results found';
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

	/// en: 'Enter email'
	String get askEmail => 'Enter email';

	/// en: 'Please authenticate to enter the app.'
	String get askAuthenticate => 'Please authenticate to enter the app.';

	/// en: 'Retype your password'
	String get retypePassword => 'Retype your password';

	/// en: 'Forgot your password?'
	String get forgotPassword => 'Forgot your password?';

	/// en: 'Already have an account? Log in.'
	String get alreadyHaveAccount => 'Already have an account? Log in.';

	/// en: 'Don't have an account? Sign up.'
	String get dontHaveAccount => 'Don\'t have an account? Sign up.';
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
			case 'btnActions.registrationSuccess': return 'Registration successful! You can now log in.';
			case 'btnActions.registerWithGoogle': return 'Register with Google';
			case 'btnActions.registerWithApple': return 'Register with Apple';
			case 'btnActions.password': return 'Password';
			case 'btnActions.email': return 'Email';
			case 'btnActions.logIn': return 'Login';
			case 'btnActions.backToLogin': return 'Back to login page';
			case 'btnActions.changeFont': return 'Change font';
			case 'btnActions.continueAction': return 'Continue';
			case 'btnActions.save': return 'Save';
			case 'btnActions.clear': return 'Clear';
			case 'btnActions.add': return 'Add';
			case 'btnActions.delete': return 'Delete';
			case 'btnActions.confirmDelete': return 'Confirm delete';
			case 'btnActions.apply': return 'Apply';
			case 'setup.noBooks': return 'It seems you don\'t have any books yet. Please select a language for the books to start using the app!';
			case 'setup.starting': return 'Starting download';
			case 'setup.downloadingBooks': return 'Downloading books';
			case 'setup.downloadProgress': return ({required Object filename, required Object current, required Object total}) => 'Downloading ${filename}\n(${current} of ${total})';
			case 'setup.downloadComplete': return 'Download complete!';
			case 'navBar.home': return 'Home';
			case 'navBar.books': return 'Books';
			case 'navBar.search': return 'Search';
			case 'navBar.notes': return 'Notes';
			case 'navBar.settings': return 'Settings';
			case 'bookPage.find': return 'Find...';
			case 'bookPage.clearText': return 'Clear text';
			case 'bookPage.searchResult': return 'Search Result';
			case 'bookPage.noResult': return 'No result';
			case 'bookPage.cancelSearch': return 'Cancel search';
			case 'bookPage.noMoreResults': return 'No more occurrences found. Would you like to continue to search from the beginning?';
			case 'bookPage.YES': return 'YES';
			case 'bookPage.NO': return 'NO';
			case 'bookPage.previous': return 'Previous';
			case 'bookPage.next': return 'Next';
			case 'bookPage.previousInstance': return 'Previous instance';
			case 'bookPage.nextInstance': return 'Next instance';
			case 'bookPage.of': return 'of';
			case 'bookPage.highlight': return 'Highlight';
			case 'bookPage.underline': return 'Underline';
			case 'bookPage.strikethrough': return 'Strikethrough';
			case 'bookPage.squiggly': return 'Squiggly';
			case 'bookPage.copy': return 'Copy';
			case 'bookPage.page': return ({required Object page}) => 'Page ${page}';
			case 'bookPage.bookAnnotations': return 'Book annotations';
			case 'notesPage.bookNotes': return 'Book notes';
			case 'notesPage.noBookNotes': return 'No notes found for this book.';
			case 'notesPage.editNote': return 'Edit note';
			case 'notesPage.newNote': return ({required Object page}) => 'New note for page ${page}';
			case 'notesPage.writeNotes': return 'Write your notes here...';
			case 'notesPage.noteUpdated': return 'Note updated!';
			case 'notesPage.noteDeleted': return 'Note deleted.';
			case 'notesPage.confirmDelete': return 'Are you sure you want to delete this note?';
			case 'notesPage.newNoteSaved': return 'New note saved!';
			case 'notesPage.myNotes': return 'My notes';
			case 'notesPage.filters': return 'Filters';
			case 'notesPage.filterByBook': return 'Filter by book';
			case 'notesPage.allBooks': return 'All books';
			case 'notesPage.afterDate': return 'After...';
			case 'notesPage.beforeDate': return 'Before...';
			case 'notesPage.clearFilters': return 'Clear filters';
			case 'notesPage.noNotesFound': return 'No notes found with the applied filters.';
			case 'notesPage.generalNotes': return 'General notes';
			case 'notesPage.deleteNote': return 'Delete note';
			case 'notesPage.deleteConfirmation': return 'Are you sure you want to delete this note?';
			case 'notesPage.noteDeletedSuccess': return 'Note deleted successfully!';
			case 'notesPage.createGeneralNote': return 'Create general note';
			case 'notesPage.noteSaved': return 'Note saved!';
			case 'notesPage.writeHere': return 'Write your note here ...';
			case 'notesPage.bookNoteAdd': return ({required Object bookName}) => 'Add note to ${bookName}';
			case 'notesPage.bookNoteEdit': return ({required Object bookName}) => 'Edit note in ${bookName}';
			case 'settingsPage.settings': return 'Settings';
			case 'settingsPage.portuguese': return 'Português (Brasil)';
			case 'settingsPage.english': return 'English (US)';
			case 'settingsPage.selectLanguage': return 'Select Language';
			case 'settingsPage.language': return 'Language';
			case 'settingsPage.signOut': return 'Sign out';
			case 'searchPage.unkownBook': return 'Unkown book';
			case 'searchPage.typeYourSearch': return 'Type your search';
			case 'searchPage.startSearch': return 'Type something to start your search';
			case 'searchPage.noResultFound': return 'No results found';
			case 'authMessages.prompt.askPassword': return 'Enter password';
			case 'authMessages.prompt.askEmail': return 'Enter email';
			case 'authMessages.prompt.askAuthenticate': return 'Please authenticate to enter the app.';
			case 'authMessages.prompt.retypePassword': return 'Retype your password';
			case 'authMessages.prompt.forgotPassword': return 'Forgot your password?';
			case 'authMessages.prompt.alreadyHaveAccount': return 'Already have an account? Log in.';
			case 'authMessages.prompt.dontHaveAccount': return 'Don\'t have an account? Sign up.';
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

