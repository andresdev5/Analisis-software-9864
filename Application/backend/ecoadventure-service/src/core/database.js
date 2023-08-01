var pgp = require("pg-promise")({
    schema: 'public'
});

const {
    DB_USER,
    DB_PASSWORD,
    DB_HOST,
    DB_PORT,
    DB_NAME
} = process.env;

const db = pgp(`postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}`);

// singleton database
class Database {
    #_connection = null;
    static #instance = null;

    constructor() {
        this.#_connection = null;
    }

    static get instance() {
        if (!this.#instance) {
            this.#instance = new Database();
        }

        return this.#instance;
    }

    get connection() {
        return this.#_connection;
    }

    async connect() {
        try {
            this.#_connection = await db.connect();
            console.log('Database connected');
            return true;
        } catch (error) {
            console.log('Database connection failed');
            console.log(error);
            return false;
        }
    }
}

module.exports = {
    Database
};