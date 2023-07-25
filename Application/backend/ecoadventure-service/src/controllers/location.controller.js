const { Database } = require('../core/database.js');

async function getCountries(req, res) {
    const data = await Database.instance.connection.any(`SELECT * FROM public.country`);

    return res.status(200).json({
        message: 'success',
        data: data,
    });
}

module.exports = {
    getCountries,
};