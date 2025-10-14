const { onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require('firebase-admin');
const { SecretManagerServiceClient } = require('@google-cloud/secret-manager');

// Initialize the admin SDK
admin.initializeApp();

const client = new SecretManagerServiceClient();

// v2 Callable Cloud Function to securely return the secret value.
exports.getAndroidKey = onCall({ enforceAppCheck: false }, async (request) => {
    // App Check is enforced by the 'enforceAppCheck: true' option.

    // Authentication verification. If a user is not signed in, request.auth is undefined.
    if (!request.auth) {
        throw new HttpsError(
            'unauthenticated',
            'The function must be called while authenticated.'
        );
    }

    // Authentication and App Check have passed. Now, access the secret.
    try {
        const name = 'projects/556742263663/secrets/android_encryption_key/versions/latest';
        const [accessResponse] = await client.accessSecretVersion({ name });
        const payload = accessResponse.payload && accessResponse.payload.data
            ? accessResponse.payload.data.toString('utf8')
            : null;

        if (!payload) {
            // Throw an error that the client can catch.
            throw new HttpsError('internal', 'Secret payload missing.');
        }

        // Return the secret to the client.
        return { data: payload };
    } catch (err) {
        console.error('Error in getAndroidKey:', err);
        // Re-throw HttpsError or create a new one for other errors.
        if (err instanceof HttpsError) {
            throw err;
        }
        throw new HttpsError('internal', 'Internal Server Error: ' + err.message);
    }
});
