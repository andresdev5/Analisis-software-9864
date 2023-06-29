var pgp = require("pg-promise")({
    schema: 'public'
});

const db = pgp('postgres://postgres:postgres@localhost:5432/ecoadventure');


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
        } catch (error) {
            console.log('Database connection failed');
            console.log(error);
        }
    }
}

Database.instance.connect();


module.exports = {
    Database
};