///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsPtBr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPtBr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ptBr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pt-BR>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsPtBr _root = this; // ignore: unused_field

	@override 
	TranslationsPtBr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPtBr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsBtnActionsPtBr btnActions = _TranslationsBtnActionsPtBr._(_root);
	@override late final _TranslationsSetupPtBr setup = _TranslationsSetupPtBr._(_root);
	@override late final _TranslationsNavBarPtBr navBar = _TranslationsNavBarPtBr._(_root);
	@override late final _TranslationsBookPagePtBr bookPage = _TranslationsBookPagePtBr._(_root);
	@override late final _TranslationsSettingsPagePtBr settingsPage = _TranslationsSettingsPagePtBr._(_root);
	@override late final _TranslationsSearchPagePtBr searchPage = _TranslationsSearchPagePtBr._(_root);
}

// Path: btnActions
class _TranslationsBtnActionsPtBr implements TranslationsBtnActionsEn {
	_TranslationsBtnActionsPtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Confirmar';
	@override String get cancel => 'Cancelar';
	@override String get authenticate => 'Autenticar';
	@override String get register => 'Registrar';
	@override String get registrationSuccess => 'Registro bem-sucedido! Você pode fazer login agora.';
	@override String get registerWithGoogle => 'Registrar com Google';
	@override String get registerWithApple => 'Registrar com Apple';
	@override String get password => 'Senha';
	@override String get email => 'Email';
	@override String get logIn => 'Entrar';
	@override String get backToLogin => 'Voltar para a página de login';
	@override String get changeFont => 'Mudar fonte';
	@override String get continueAction => 'Continuar';
	@override String get save => 'Salvar';
	@override String get clear => 'Limpar';
	@override String get add => 'Adicionar';
	@override String get delete => 'Deletar';
	@override String get confirmDelete => 'Confirmar Exclusão';
	@override String get apply => 'Aplicar';
}

// Path: setup
class _TranslationsSetupPtBr implements TranslationsSetupEn {
	_TranslationsSetupPtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get noBooks => 'Parece que você não tem nenhum livro ainda. Por favor, selecione uma língua para os livros para começar a usar o aplicativo!';
	@override String get starting => 'Iniciando download';
	@override String get downloadingBooks => 'Baixando livros';
	@override String downloadProgress({required Object filename, required Object current, required Object total}) => 'Baixando ${filename}\n(${current} de ${total})';
	@override String get downloadComplete => 'Download concluído!';
}

// Path: navBar
class _TranslationsNavBarPtBr implements TranslationsNavBarEn {
	_TranslationsNavBarPtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get books => 'Livros';
	@override String get search => 'Pesquisar';
	@override String get notes => 'Notas';
	@override String get settings => 'Configurações';
}

// Path: bookPage
class _TranslationsBookPagePtBr implements TranslationsBookPageEn {
	_TranslationsBookPagePtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get find => 'Procurar...';
	@override String get clearText => 'Limpar texto';
	@override String get searchResult => 'Resultado da pesquisa';
	@override String get noResult => 'Nenhum resultado';
	@override String get cancelSearch => 'Cancelar pesquisa';
	@override String get noMoreResults => 'Nenhuma outra ocorrência encontrada. Gostaria de continuar a pesquisa desde o início?';
	@override String get YES => 'SIM';
	@override String get NO => 'NÃO';
	@override String get previous => 'Anterior';
	@override String get next => 'Próximo';
	@override String get previousInstance => 'Instância anterior';
	@override String get nextInstance => 'Próxima instância';
	@override String get of => 'de';
	@override String get highlight => 'Destacar';
	@override String get underline => 'Sublinhar';
	@override String get strikethrough => 'Riscar';
	@override String get squiggly => 'Ondular';
	@override String get copy => 'Copiar';
	@override String page({required Object page}) => 'Página ${page}';
	@override String get bookAnnotations => 'Anotações do livro';
}

// Path: settingsPage
class _TranslationsSettingsPagePtBr implements TranslationsSettingsPageEn {
	_TranslationsSettingsPagePtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Configurações';
	@override String get language => 'Idioma';
	@override String get selectLanguage => 'Selecionar idioma';
	@override String get portuguese => 'Português (Brasil)';
	@override String get english => 'English (US)';
	@override String get theme => 'Tema';
	@override String get light => 'Claro';
	@override String get dark => 'Escuro';
	@override String get system => 'Sistema';
	@override String get selectTheme => 'Selecionar tema';
}

// Path: searchPage
class _TranslationsSearchPagePtBr implements TranslationsSearchPageEn {
	_TranslationsSearchPagePtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get unkownBook => 'Livro desconhecido';
	@override String get typeYourSearch => 'Digite sua busca';
	@override String get startSearch => 'Digite algo para iniciar a busca';
	@override String get noResultFound => 'Nenhum resultado encontrado';
	@override String get searchHistory => 'Histórico de pesquisa';
	@override String get noHistoryYet => 'Sem histórico de pesquisa ainda';
	@override String get search => 'Pesquisar...';
}

/// The flat map containing all translations for locale <pt-BR>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPtBr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'btnActions.confirm' => 'Confirmar',
			'btnActions.cancel' => 'Cancelar',
			'btnActions.authenticate' => 'Autenticar',
			'btnActions.register' => 'Registrar',
			'btnActions.registrationSuccess' => 'Registro bem-sucedido! Você pode fazer login agora.',
			'btnActions.registerWithGoogle' => 'Registrar com Google',
			'btnActions.registerWithApple' => 'Registrar com Apple',
			'btnActions.password' => 'Senha',
			'btnActions.email' => 'Email',
			'btnActions.logIn' => 'Entrar',
			'btnActions.backToLogin' => 'Voltar para a página de login',
			'btnActions.changeFont' => 'Mudar fonte',
			'btnActions.continueAction' => 'Continuar',
			'btnActions.save' => 'Salvar',
			'btnActions.clear' => 'Limpar',
			'btnActions.add' => 'Adicionar',
			'btnActions.delete' => 'Deletar',
			'btnActions.confirmDelete' => 'Confirmar Exclusão',
			'btnActions.apply' => 'Aplicar',
			'setup.noBooks' => 'Parece que você não tem nenhum livro ainda. Por favor, selecione uma língua para os livros para começar a usar o aplicativo!',
			'setup.starting' => 'Iniciando download',
			'setup.downloadingBooks' => 'Baixando livros',
			'setup.downloadProgress' => ({required Object filename, required Object current, required Object total}) => 'Baixando ${filename}\n(${current} de ${total})',
			'setup.downloadComplete' => 'Download concluído!',
			'navBar.books' => 'Livros',
			'navBar.search' => 'Pesquisar',
			'navBar.notes' => 'Notas',
			'navBar.settings' => 'Configurações',
			'bookPage.find' => 'Procurar...',
			'bookPage.clearText' => 'Limpar texto',
			'bookPage.searchResult' => 'Resultado da pesquisa',
			'bookPage.noResult' => 'Nenhum resultado',
			'bookPage.cancelSearch' => 'Cancelar pesquisa',
			'bookPage.noMoreResults' => 'Nenhuma outra ocorrência encontrada. Gostaria de continuar a pesquisa desde o início?',
			'bookPage.YES' => 'SIM',
			'bookPage.NO' => 'NÃO',
			'bookPage.previous' => 'Anterior',
			'bookPage.next' => 'Próximo',
			'bookPage.previousInstance' => 'Instância anterior',
			'bookPage.nextInstance' => 'Próxima instância',
			'bookPage.of' => 'de',
			'bookPage.highlight' => 'Destacar',
			'bookPage.underline' => 'Sublinhar',
			'bookPage.strikethrough' => 'Riscar',
			'bookPage.squiggly' => 'Ondular',
			'bookPage.copy' => 'Copiar',
			'bookPage.page' => ({required Object page}) => 'Página ${page}',
			'bookPage.bookAnnotations' => 'Anotações do livro',
			'settingsPage.settings' => 'Configurações',
			'settingsPage.language' => 'Idioma',
			'settingsPage.selectLanguage' => 'Selecionar idioma',
			'settingsPage.portuguese' => 'Português (Brasil)',
			'settingsPage.english' => 'English (US)',
			'settingsPage.theme' => 'Tema',
			'settingsPage.light' => 'Claro',
			'settingsPage.dark' => 'Escuro',
			'settingsPage.system' => 'Sistema',
			'settingsPage.selectTheme' => 'Selecionar tema',
			'searchPage.unkownBook' => 'Livro desconhecido',
			'searchPage.typeYourSearch' => 'Digite sua busca',
			'searchPage.startSearch' => 'Digite algo para iniciar a busca',
			'searchPage.noResultFound' => 'Nenhum resultado encontrado',
			'searchPage.searchHistory' => 'Histórico de pesquisa',
			'searchPage.noHistoryYet' => 'Sem histórico de pesquisa ainda',
			'searchPage.search' => 'Pesquisar...',
			_ => null,
		};
	}
}
