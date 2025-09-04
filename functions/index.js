const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Inicializar o Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();

/**
 * Cloud Function que é executada quando um novo usuário é criado
 * Cria automaticamente uma coleção personalizada para o usuário
 */
exports.criarColecaoUsuario = functions.auth.user().onCreate(async (user) => {
    try {
        const uid = user.uid;
        const email = user.email;
        const displayName = user.displayName || 'Usuário';

        console.log(`Novo usuário criado: ${uid} - ${email}`);

        // Criar documento de perfil do usuário na coleção 'usuarios'
        await db.collection('usuarios').doc(uid).set({
            uid: uid,
            email: email,
            nome: displayName,
            dataCriacao: admin.firestore.FieldValue.serverTimestamp(),
            ativo: true
        });

        // Criar uma subcoleção específica para os dados do usuário
        // Exemplo: coleção de 'configuracoes' do usuário
        await db.collection('usuarios').doc(uid).collection('configuracoes').doc('inicial').set({
            tema: 'claro',
            idioma: 'pt-BR',
            notificacoes: true,
            dataCriacao: admin.firestore.FieldValue.serverTimestamp()
        });

        // Criar uma subcoleção para 'atividades' do usuário
        await db.collection('usuarios').doc(uid).collection('atividades').doc('welcome').set({
            tipo: 'cadastro',
            descricao: 'Usuário se cadastrou no sistema',
            data: admin.firestore.FieldValue.serverTimestamp()
        });

        // Opcional: Criar uma coleção separada com o ID do usuário
        // Útil para dados que precisam ser acessados diretamente
        await db.collection(`user_${uid}`).doc('perfil').set({
            uid: uid,
            email: email,
            nome: displayName,
            status: 'ativo',
            dataCriacao: admin.firestore.FieldValue.serverTimestamp()
        });

        console.log(`Coleções criadas com sucesso para o usuário: ${uid}`);

        return {
            success: true,
            message: `Coleções criadas para o usuário ${uid}`,
            uid: uid
        };

    } catch (error) {
        console.error('Erro ao criar coleções para o usuário:', error);

        // Não lance o erro para não impedir o cadastro do usuário
        // Apenas registre o erro para análise posterior
        return {
            success: false,
            error: error.message
        };
    }
});