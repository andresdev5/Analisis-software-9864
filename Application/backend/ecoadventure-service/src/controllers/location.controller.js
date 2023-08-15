const { Database } = require('../core/database.js');

async function getCities(req, res) {
    const data = await Database.instance.connection.any(`SELECT * FROM public.city`);

    return res.status(200).json({
        message: 'success',
        data: data,
    });
}

module.exports = {
    getCities,
};