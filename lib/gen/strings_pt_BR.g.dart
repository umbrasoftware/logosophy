///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsPtBr implements Translations {
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
	@override late final _TranslationsNotesPagePtBr notesPage = _TranslationsNotesPagePtBr._(_root);
	@override late final _TranslationsSettingsPagePtBr settingsPage = _TranslationsSettingsPagePtBr._(_root);
	@override late final _TranslationsSearchPagePtBr searchPage = _TranslationsSearchPagePtBr._(_root);
	@override late final _TranslationsAuthMessagesPtBr authMessages = _TranslationsAuthMessagesPtBr._(_root);
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
	@override String get home => 'Início';
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

// Path: notesPage
class _TranslationsNotesPagePtBr implements TranslationsNotesPageEn {
	_TranslationsNotesPagePtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get bookNotes => 'Anotações do livro';
	@override String get noBookNotes => 'Nenhuma anotação encontrada para este livro.';
	@override String get editNote => 'Editar anotação';
	@override String newNote({required Object page}) => 'Nova anotação para a página ${page}';
	@override String get writeNotes => 'Escreva sua anotação aqui...';
	@override String get noteUpdated => 'Anotação atualizada!';
	@override String get noteDeleted => 'Anotação deletada.';
	@override String get confirmDelete => 'Tem certeza que deseja deletar esta anotação?';
	@override String get newNoteSaved => 'Nova anotação salva!';
	@override String get myNotes => 'Minhas anotações';
	@override String get filters => 'Filtros';
	@override String get filterByBook => 'Filtrar por livro';
	@override String get allBooks => 'Todos os livros';
	@override String get afterDate => 'Depois...';
	@override String get beforeDate => 'Antes...';
	@override String get clearFilters => 'Limpar filtros';
	@override String get noNotesFound => 'Nenhuma anotação encontrada com os filtros aplicados.';
	@override String get generalNotes => 'Anotações gerais';
	@override String get deleteNote => 'Deletar anotação';
	@override String get deleteConfirmation => 'Tem certeza que deseja deletar esta anotação?';
	@override String get noteDeletedSuccess => 'Anotação deletada com sucesso!';
	@override String get createGeneralNote => 'Criar anotação geral';
	@override String get noteSaved => 'Anotação salva!';
	@override String get writeHere => 'Escreva sua anotação aqui...';
	@override String bookNoteAdd({required Object bookName}) => 'Adicionar anotação ao ${bookName}';
	@override String bookNoteEdit({required Object bookName}) => 'Editar anotação em ${bookName}';
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
	@override String get signOut => 'Sair';
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
}

// Path: authMessages
class _TranslationsAuthMessagesPtBr implements TranslationsAuthMessagesEn {
	_TranslationsAuthMessagesPtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthMessagesPromptPtBr prompt = _TranslationsAuthMessagesPromptPtBr._(_root);
	@override late final _TranslationsAuthMessagesErrorPtBr error = _TranslationsAuthMessagesErrorPtBr._(_root);
}

// Path: authMessages.prompt
class _TranslationsAuthMessagesPromptPtBr implements TranslationsAuthMessagesPromptEn {
	_TranslationsAuthMessagesPromptPtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get askPassword => 'Digite a senha';
	@override String get askEmail => 'Digite seu email';
	@override String get askAuthenticate => 'Por favor, se autentique para entrar no aplicativo.';
	@override String get retypePassword => 'Digite a senha novamente';
	@override String get forgotPassword => 'Esqueceu sua senha?';
	@override String get alreadyHaveAccount => 'Já tem uma conta? Faça login.';
	@override String get dontHaveAccount => 'Não tem uma conta? Cadastre-se.';
}

// Path: authMessages.error
class _TranslationsAuthMessagesErrorPtBr implements TranslationsAuthMessagesErrorEn {
	_TranslationsAuthMessagesErrorPtBr._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get unknown => 'Um erro desconhecido ocorreu. Por favor, entre em contato com a equipe de suporte.';
	@override String get emailAddressInvalid => 'Email inválido. Tente novamente, por favor.';
	@override String get emailExists => 'Este email já está em uso.';
	@override String get emailNotConfirmed => 'Confirme sua conta clicando no link enviado para seu email.';
	@override String get invalidCredentials => 'Seu email ou senha está incorreto.';
	@override String get passwordMismatch => 'As senhas não são iguais.';
	@override String get passwordTooShort => 'Sua senha precisa ter pelo menos 8 caracteres.';
	@override String get samePassword => 'Você não pode usar a mesma senha de antes.';
	@override String get weakPassword => 'Sua senha precisa ter pelo menos 1 caractere maiúsculo, 1 minúsculo, 1 número e 1 caractere especial.';
	@override String get overRequestRateLimit => 'Você está fazendo muitas solicitações. Por favor, tente novamente mais tarde.';
	@override String get wrongPassword => 'Senha errada';
	@override String get nameTooLong => 'Seu nome não pode ter mais de 100 caracteres.';
	@override String get noConnection => 'Sem conexão com a internet.';
	@override String get unprocessableEntity => 'O servidor não pôde satisfazer sua solicitação. Por favor, tente novamente mais tarde.';
	@override String get tooManyRequests => 'Os servidores estão sobrecarregados agora. Por favor, tente novamente mais tarde.';
	@override String get internalServerError => 'Houve um erro ao processar sua solicitação. Por favor, tente novamente mais tarde.';
	@override String get tryLoginAgain => 'Um erro ocorreu. Por favor, tente fazer login novamente.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsPtBr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'btnActions.confirm': return 'Confirmar';
			case 'btnActions.cancel': return 'Cancelar';
			case 'btnActions.authenticate': return 'Autenticar';
			case 'btnActions.register': return 'Registrar';
			case 'btnActions.registrationSuccess': return 'Registro bem-sucedido! Você pode fazer login agora.';
			case 'btnActions.registerWithGoogle': return 'Registrar com Google';
			case 'btnActions.registerWithApple': return 'Registrar com Apple';
			case 'btnActions.password': return 'Senha';
			case 'btnActions.email': return 'Email';
			case 'btnActions.logIn': return 'Entrar';
			case 'btnActions.backToLogin': return 'Voltar para a página de login';
			case 'btnActions.changeFont': return 'Mudar fonte';
			case 'btnActions.continueAction': return 'Continuar';
			case 'btnActions.save': return 'Salvar';
			case 'btnActions.clear': return 'Limpar';
			case 'btnActions.add': return 'Adicionar';
			case 'btnActions.delete': return 'Deletar';
			case 'btnActions.confirmDelete': return 'Confirmar Exclusão';
			case 'btnActions.apply': return 'Aplicar';
			case 'setup.noBooks': return 'Parece que você não tem nenhum livro ainda. Por favor, selecione uma língua para os livros para começar a usar o aplicativo!';
			case 'setup.starting': return 'Iniciando download';
			case 'setup.downloadingBooks': return 'Baixando livros';
			case 'setup.downloadProgress': return ({required Object filename, required Object current, required Object total}) => 'Baixando ${filename}\n(${current} de ${total})';
			case 'setup.downloadComplete': return 'Download concluído!';
			case 'navBar.home': return 'Início';
			case 'navBar.books': return 'Livros';
			case 'navBar.search': return 'Pesquisar';
			case 'navBar.notes': return 'Notas';
			case 'navBar.settings': return 'Configurações';
			case 'bookPage.find': return 'Procurar...';
			case 'bookPage.clearText': return 'Limpar texto';
			case 'bookPage.searchResult': return 'Resultado da pesquisa';
			case 'bookPage.noResult': return 'Nenhum resultado';
			case 'bookPage.cancelSearch': return 'Cancelar pesquisa';
			case 'bookPage.noMoreResults': return 'Nenhuma outra ocorrência encontrada. Gostaria de continuar a pesquisa desde o início?';
			case 'bookPage.YES': return 'SIM';
			case 'bookPage.NO': return 'NÃO';
			case 'bookPage.previous': return 'Anterior';
			case 'bookPage.next': return 'Próximo';
			case 'bookPage.previousInstance': return 'Instância anterior';
			case 'bookPage.nextInstance': return 'Próxima instância';
			case 'bookPage.of': return 'de';
			case 'bookPage.highlight': return 'Destacar';
			case 'bookPage.underline': return 'Sublinhar';
			case 'bookPage.strikethrough': return 'Riscar';
			case 'bookPage.squiggly': return 'Ondular';
			case 'bookPage.copy': return 'Copiar';
			case 'bookPage.page': return ({required Object page}) => 'Página ${page}';
			case 'bookPage.bookAnnotations': return 'Anotações do livro';
			case 'notesPage.bookNotes': return 'Anotações do livro';
			case 'notesPage.noBookNotes': return 'Nenhuma anotação encontrada para este livro.';
			case 'notesPage.editNote': return 'Editar anotação';
			case 'notesPage.newNote': return ({required Object page}) => 'Nova anotação para a página ${page}';
			case 'notesPage.writeNotes': return 'Escreva sua anotação aqui...';
			case 'notesPage.noteUpdated': return 'Anotação atualizada!';
			case 'notesPage.noteDeleted': return 'Anotação deletada.';
			case 'notesPage.confirmDelete': return 'Tem certeza que deseja deletar esta anotação?';
			case 'notesPage.newNoteSaved': return 'Nova anotação salva!';
			case 'notesPage.myNotes': return 'Minhas anotações';
			case 'notesPage.filters': return 'Filtros';
			case 'notesPage.filterByBook': return 'Filtrar por livro';
			case 'notesPage.allBooks': return 'Todos os livros';
			case 'notesPage.afterDate': return 'Depois...';
			case 'notesPage.beforeDate': return 'Antes...';
			case 'notesPage.clearFilters': return 'Limpar filtros';
			case 'notesPage.noNotesFound': return 'Nenhuma anotação encontrada com os filtros aplicados.';
			case 'notesPage.generalNotes': return 'Anotações gerais';
			case 'notesPage.deleteNote': return 'Deletar anotação';
			case 'notesPage.deleteConfirmation': return 'Tem certeza que deseja deletar esta anotação?';
			case 'notesPage.noteDeletedSuccess': return 'Anotação deletada com sucesso!';
			case 'notesPage.createGeneralNote': return 'Criar anotação geral';
			case 'notesPage.noteSaved': return 'Anotação salva!';
			case 'notesPage.writeHere': return 'Escreva sua anotação aqui...';
			case 'notesPage.bookNoteAdd': return ({required Object bookName}) => 'Adicionar anotação ao ${bookName}';
			case 'notesPage.bookNoteEdit': return ({required Object bookName}) => 'Editar anotação em ${bookName}';
			case 'settingsPage.settings': return 'Configurações';
			case 'settingsPage.language': return 'Idioma';
			case 'settingsPage.selectLanguage': return 'Selecionar idioma';
			case 'settingsPage.portuguese': return 'Português (Brasil)';
			case 'settingsPage.english': return 'English (US)';
			case 'settingsPage.signOut': return 'Sair';
			case 'searchPage.unkownBook': return 'Livro desconhecido';
			case 'searchPage.typeYourSearch': return 'Digite sua busca';
			case 'searchPage.startSearch': return 'Digite algo para iniciar a busca';
			case 'searchPage.noResultFound': return 'Nenhum resultado encontrado';
			case 'authMessages.prompt.askPassword': return 'Digite a senha';
			case 'authMessages.prompt.askEmail': return 'Digite seu email';
			case 'authMessages.prompt.askAuthenticate': return 'Por favor, se autentique para entrar no aplicativo.';
			case 'authMessages.prompt.retypePassword': return 'Digite a senha novamente';
			case 'authMessages.prompt.forgotPassword': return 'Esqueceu sua senha?';
			case 'authMessages.prompt.alreadyHaveAccount': return 'Já tem uma conta? Faça login.';
			case 'authMessages.prompt.dontHaveAccount': return 'Não tem uma conta? Cadastre-se.';
			case 'authMessages.error.unknown': return 'Um erro desconhecido ocorreu. Por favor, entre em contato com a equipe de suporte.';
			case 'authMessages.error.emailAddressInvalid': return 'Email inválido. Tente novamente, por favor.';
			case 'authMessages.error.emailExists': return 'Este email já está em uso.';
			case 'authMessages.error.emailNotConfirmed': return 'Confirme sua conta clicando no link enviado para seu email.';
			case 'authMessages.error.invalidCredentials': return 'Seu email ou senha está incorreto.';
			case 'authMessages.error.passwordMismatch': return 'As senhas não são iguais.';
			case 'authMessages.error.passwordTooShort': return 'Sua senha precisa ter pelo menos 8 caracteres.';
			case 'authMessages.error.samePassword': return 'Você não pode usar a mesma senha de antes.';
			case 'authMessages.error.weakPassword': return 'Sua senha precisa ter pelo menos 1 caractere maiúsculo, 1 minúsculo, 1 número e 1 caractere especial.';
			case 'authMessages.error.overRequestRateLimit': return 'Você está fazendo muitas solicitações. Por favor, tente novamente mais tarde.';
			case 'authMessages.error.wrongPassword': return 'Senha errada';
			case 'authMessages.error.nameTooLong': return 'Seu nome não pode ter mais de 100 caracteres.';
			case 'authMessages.error.noConnection': return 'Sem conexão com a internet.';
			case 'authMessages.error.unprocessableEntity': return 'O servidor não pôde satisfazer sua solicitação. Por favor, tente novamente mais tarde.';
			case 'authMessages.error.tooManyRequests': return 'Os servidores estão sobrecarregados agora. Por favor, tente novamente mais tarde.';
			case 'authMessages.error.internalServerError': return 'Houve um erro ao processar sua solicitação. Por favor, tente novamente mais tarde.';
			case 'authMessages.error.tryLoginAgain': return 'Um erro ocorreu. Por favor, tente fazer login novamente.';
			default: return null;
		}
	}
}

