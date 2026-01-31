///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
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
	late final TranslationsSettingsPageEn settingsPage = TranslationsSettingsPageEn._(_root);
	late final TranslationsSearchPageEn searchPage = TranslationsSearchPageEn._(_root);
	late final TranslationsFeedbackPageEn feedbackPage = TranslationsFeedbackPageEn._(_root);
	late final TranslationsFilterEn filter = TranslationsFilterEn._(_root);
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

	/// en: 'Send'
	String get send => 'Send';
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

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';

	/// en: 'System'
	String get system => 'System';

	/// en: 'Select theme'
	String get selectTheme => 'Select theme';

	/// en: 'Font size'
	String get fontSize => 'Font size';

	/// en: 'Change the font size'
	String get changeFontSize => 'Change the font size';

	/// en: 'Book title'
	String get bookTitle => 'Book title';

	/// en: 'Example of the font size of a passage from the book, which will appear on the search page. For demonstration purposes only.'
	String get fontBookSnippet => 'Example of the font size of a passage from the book, which will appear on the search page. For demonstration purposes only.';
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

	/// en: 'Search history'
	String get searchHistory => 'Search history';

	/// en: 'No search history yet'
	String get noHistoryYet => 'No search history yet';

	/// en: 'Search...'
	String get search => 'Search...';
}

// Path: feedbackPage
class TranslationsFeedbackPageEn {
	TranslationsFeedbackPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Contact Us'
	String get contactUs => 'Contact Us';

	/// en: 'Give a suggestion or report a problem'
	String get desc => 'Give a suggestion or report a problem';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Message'
	String get message => 'Message';

	/// en: 'Type a bit more, please.'
	String get typeMore => 'Type a bit more, please.';

	/// en: 'Is a problem?'
	String get isProblem => 'Is a problem?';

	/// en: 'Can we contact you?'
	String get canContact => 'Can we contact you?';

	/// en: 'Thank you for your message.'
	String get okMessage => 'Thank you for your message.';

	/// en: 'An error happened. Please check your connection and try again.'
	String get errorMessage => 'An error happened. Please check your connection and try again.';
}

// Path: filter
class TranslationsFilterEn {
	TranslationsFilterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'You have filters active.'
	String get activateFilters => 'You have filters active.';

	/// en: 'Include only these books on the search:'
	String get includeOnly => 'Include only these books on the search:';

	/// en: 'Exclude only these books on the search:'
	String get excludeOnly => 'Exclude only these books on the search:';

	/// en: 'Clear filters'
	String get clear => 'Clear filters';

	/// en: 'The book $title have already been added.'
	String alreadyAdded({required Object title}) => 'The book ${title} have already been added.';

	/// en: 'Select a book'
	String get selectBook => 'Select a book';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'btnActions.confirm' => 'Confirm',
			'btnActions.cancel' => 'Cancel',
			'btnActions.authenticate' => 'Authenticate',
			'btnActions.register' => 'Register',
			'btnActions.registrationSuccess' => 'Registration successful! You can now log in.',
			'btnActions.registerWithGoogle' => 'Register with Google',
			'btnActions.registerWithApple' => 'Register with Apple',
			'btnActions.password' => 'Password',
			'btnActions.email' => 'Email',
			'btnActions.logIn' => 'Login',
			'btnActions.backToLogin' => 'Back to login page',
			'btnActions.changeFont' => 'Change font',
			'btnActions.continueAction' => 'Continue',
			'btnActions.save' => 'Save',
			'btnActions.clear' => 'Clear',
			'btnActions.add' => 'Add',
			'btnActions.delete' => 'Delete',
			'btnActions.confirmDelete' => 'Confirm delete',
			'btnActions.apply' => 'Apply',
			'btnActions.send' => 'Send',
			'setup.noBooks' => 'It seems you don\'t have any books yet. Please select a language for the books to start using the app!',
			'setup.starting' => 'Starting download',
			'setup.downloadingBooks' => 'Downloading books',
			'setup.downloadProgress' => ({required Object filename, required Object current, required Object total}) => 'Downloading ${filename}\n(${current} of ${total})',
			'setup.downloadComplete' => 'Download complete!',
			'navBar.books' => 'Books',
			'navBar.search' => 'Search',
			'navBar.notes' => 'Notes',
			'navBar.settings' => 'Settings',
			'bookPage.find' => 'Find...',
			'bookPage.clearText' => 'Clear text',
			'bookPage.searchResult' => 'Search Result',
			'bookPage.noResult' => 'No result',
			'bookPage.cancelSearch' => 'Cancel search',
			'bookPage.noMoreResults' => 'No more occurrences found. Would you like to continue to search from the beginning?',
			'bookPage.YES' => 'YES',
			'bookPage.NO' => 'NO',
			'bookPage.previous' => 'Previous',
			'bookPage.next' => 'Next',
			'bookPage.previousInstance' => 'Previous instance',
			'bookPage.nextInstance' => 'Next instance',
			'bookPage.of' => 'of',
			'bookPage.highlight' => 'Highlight',
			'bookPage.underline' => 'Underline',
			'bookPage.strikethrough' => 'Strikethrough',
			'bookPage.squiggly' => 'Squiggly',
			'bookPage.copy' => 'Copy',
			'bookPage.page' => ({required Object page}) => 'Page ${page}',
			'bookPage.bookAnnotations' => 'Book annotations',
			'settingsPage.settings' => 'Settings',
			'settingsPage.portuguese' => 'Português (Brasil)',
			'settingsPage.english' => 'English (US)',
			'settingsPage.selectLanguage' => 'Select Language',
			'settingsPage.language' => 'Language',
			'settingsPage.theme' => 'Theme',
			'settingsPage.light' => 'Light',
			'settingsPage.dark' => 'Dark',
			'settingsPage.system' => 'System',
			'settingsPage.selectTheme' => 'Select theme',
			'settingsPage.fontSize' => 'Font size',
			'settingsPage.changeFontSize' => 'Change the font size',
			'settingsPage.bookTitle' => 'Book title',
			'settingsPage.fontBookSnippet' => 'Example of the font size of a passage from the book, which will appear on the search page. For demonstration purposes only.',
			'searchPage.unkownBook' => 'Unkown book',
			'searchPage.typeYourSearch' => 'Type your search',
			'searchPage.startSearch' => 'Type something to start your search',
			'searchPage.noResultFound' => 'No results found',
			'searchPage.searchHistory' => 'Search history',
			'searchPage.noHistoryYet' => 'No search history yet',
			'searchPage.search' => 'Search...',
			'feedbackPage.contactUs' => 'Contact Us',
			'feedbackPage.desc' => 'Give a suggestion or report a problem',
			'feedbackPage.name' => 'Name',
			'feedbackPage.message' => 'Message',
			'feedbackPage.typeMore' => 'Type a bit more, please.',
			'feedbackPage.isProblem' => 'Is a problem?',
			'feedbackPage.canContact' => 'Can we contact you?',
			'feedbackPage.okMessage' => 'Thank you for your message.',
			'feedbackPage.errorMessage' => 'An error happened. Please check your connection and try again.',
			'filter.activateFilters' => 'You have filters active.',
			'filter.includeOnly' => 'Include only these books on the search:',
			'filter.excludeOnly' => 'Exclude only these books on the search:',
			'filter.clear' => 'Clear filters',
			'filter.alreadyAdded' => ({required Object title}) => 'The book ${title} have already been added.',
			'filter.selectBook' => 'Select a book',
			_ => null,
		};
	}
}
