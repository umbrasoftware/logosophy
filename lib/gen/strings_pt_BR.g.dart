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
	@override late final _TranslationsNavBarPtBr navBar = _TranslationsNavBarPtBr._(_root);
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
			case 'navBar.home': return 'Início';
			case 'navBar.books': return 'Livros';
			case 'navBar.search': return 'Pesquisar';
			case 'navBar.notes': return 'Notas';
			case 'navBar.settings': return 'Configurações';
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

