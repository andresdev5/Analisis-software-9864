const { Database } = require('../core/database.js');

async function getTravels(req, res) {
    const user_id = req.user.id;

    const data = await Database.instance.connection.any(`
        SELECT t.*, d.name as destination_name, d.image as destination_image, d.description as destination_description,
        d.latitude as destination_latitude, d.longitude as destination_longitude, d.altitude as destination_altitude,
        c.id as city_id, c.name as city_name, u.username as user_name, u.email as user_email
        FROM travel as t
        LEFT JOIN destination as d ON t.destination_id = d.id
        LEFT JOIN city as c ON d.city_id = c.id
        LEFT JOIN "user" as u ON u.id = t.user_id
        WHERE t.user_id = $1
        ORDER BY t.id DESC
    `, [user_id]);

    const rows = data.map(row => ({
        id: row.id,
        createdAt: row.created_at,
        finishedAt: row.finished_at,
        destination: {
            id: row.destination_id,
            name: row.destination_name,
            image: row.destination_image,
            description: row.destination_description,
            latitude: row.destination_latitude,
            longitude: row.destination_longitude,
            altitude: row.destination_altitude,
            city: {
                id: row.city_id,
                name: row.city_name,
            }
        },
        user: {
            id: row.user_id,
            username: row.user_name,
            email: row.user_email,
        }
    }));

    return res.status(200).json({
        message: 'success',
        data: rows,
    });
}

async function getCompletedTravels(req, res) {
    const user_id = req.user.id;

    const data = await Database.instance.connection.any(`
        SELECT t.*, d.name as destination_name, d.image as destination_image, d.description as destination_description,
        d.latitude as destination_latitude, d.longitude as destination_longitude, d.altitude as destination_altitude,
        c.id as city_id, c.name as city_name, u.username as user_name, u.email as user_email
        FROM travel as t
        LEFT JOIN destination as d ON t.destination_id = d.id
        LEFT JOIN city as c ON d.city_id = c.id
        LEFT JOIN "user" as u ON u.id = t.user_id
        WHERE t.user_id = $1 AND t.finished_at IS NOT NULL
        ORDER BY t.id DESC
    `, [user_id]);

    const rows = data.map(row => ({
        id: row.id,
        createdAt: row.created_at,
        finishedAt: row.finished_at,
        destination: {
            id: row.destination_id,
            name: row.destination_name,
            image: row.destination_image,
            description: row.destination_description,
            latitude: row.destination_latitude,
            longitude: row.destination_longitude,
            altitude: row.destination_altitude,
            city: {
                id: row.city_id,
                name: row.city_name,
            }
        },
        user: {
            id: row.user_id,
            username: row.user_name,
            email: row.user_email,
        }
    }));

    console.log(rows);

    return res.status(200).json({
        message: 'success',
        data: rows,
    });
}

async function getTravel(req, res) {
    const user_id = req.user.id;
    const travel_id = req.params.id;

    const data = await Database.instance.connection.one(`
        SELECT t.*, d.name as destination_name, d.image as destination_image, d.description as destination_description,
        d.latitude as destination_latitude, d.longitude as destination_longitude, d.altitude as destination_altitude,
        c.id as city_id, c.name as city_name, u.username as user_name, u.email as user_email
        FROM travel as t
        LEFT JOIN destination as d ON t.destination_id = d.id
        LEFT JOIN city as c ON d.city_id = c.id
        LEFT JOIN "user" as u ON u.id = t.user_id
        WHERE t.user_id = $1 AND t.id = $2
    `, [user_id, travel_id]);

    if (!data) {
        return res.status(404).json({
            message: 'Travel not found',
            data: null,
        });
    }

    const row = {
        id: data.id,
        createdAt: data.created_at,
        finishedAt: data.finished_at,
        destination: {
            id: data.destination_id,
            name: data.destination_name,
            image: data.destination_image,
            description: data.destination_description,
            latitude: data.destination_latitude,
            longitude: data.destination_longitude,
            altitude: data.destination_altitude,
            city: {
                id: data.city_id,
                name: data.city_name,
            }
        },
        user: {
            id: data.user_id,
            username: data.user_name,
            email: data.user_email,
        }
    };

    return res.status(200).json({
        message: 'success',
        data: row,
    });
}

async function createTravel(req, res) {
    const userId = req.user.id;
    const { destinationId } = req.body;

    if (!destinationId) {
        return res.status(400).json({
            message: 'Destination is required',
        });
    }

    // check if destination exists
    const destination = await Database.instance.connection.oneOrNone(`
        SELECT * FROM destination WHERE id = $1
    `, [destinationId]);

    if (!destination) {
        return res.status(404).json({
            message: 'Destination not found',
        });
    }

    // now for postgresql timestamp
    const data = await Database.instance.connection.one(`
        INSERT INTO travel(destination_id, user_id, created_at) VALUES($1, $2, $3) RETURNING id
    `, [destinationId, userId, new Date()]);

    const row = {
        id: data.id,
        destination_id: destinationId,
        user_id: userId,
        created_at: new Date(),
    };

    return res.status(200).json({
        message: 'success',
        data: row,
    });
}

async function completeTravel(req, res) {
    const user_id = req.user.id;
    const travel_id = req.params.id;

    const data = await Database.instance.connection.one(`
        UPDATE travel SET finished_at = $1 WHERE id = $2 AND user_id = $3 RETURNING id
    `, [new Date(), travel_id, user_id]);

    const row = {
        id: data.id,
        finished_at: new Date(),
    };

    return res.status(200).json({
        message: 'success',
        data: row,
    });
}

async function getActiveUserTravel(req, res) {
    const destinationId = req.params.id;
    const userId = req.user.id;

    const data = await Database.instance.connection.oneOrNone(`
        SELECT t.*, d.name as destination_name, d.image as destination_image, d.description as destination_description,
        d.latitude as destination_latitude, d.longitude as destination_longitude, d.altitude as destination_altitude,
        c.id as city_id, c.name as city_name, u.username as user_name, u.email as user_email
        FROM travel as t
        LEFT JOIN destination as d ON t.destination_id = d.id
        LEFT JOIN city as c ON d.city_id = c.id
        LEFT JOIN "user" as u ON u.id = t.user_id
        WHERE t.user_id = $1 AND t.destination_id = $2 AND t.finished_at IS NULL
    `, [userId, destinationId]);

    if (!data) {
        return res.status(404).json({
            message: 'Travel not found',
        });
    }

    const row = {
        id: data.id,
        createdAt: data.created_at,
        finishedAt: data.finished_at,
        destination: {
            id: data.destination_id,
            name: data.destination_name,
            image: data.destination_image,
            description: data.destination_description,
            latitude: data.destination_latitude,
            longitude: data.destination_longitude,
            altitude: data.destination_altitude,
            city: {
                id: data.city_id,
                name: data.city_name,
            }
        },
        user: {
            id: data.user_id,
            username: data.user_name,
            email: data.user_email,
        }
    };

    return res.status(200).json({
        message: 'success',
        data: row,
    });
}

async function userIsTravelling(req, res) {
    const userId = req.user.id;

    const data = await Database.instance.connection.oneOrNone(`
        SELECT * FROM travel WHERE user_id = $1 AND finished_at IS NULL
        LIMIT 1
    `, [userId]);

    return res.status(200).json({
        message: 'success',
        data: data ? true : false,
    });
}

async function getUserTravels(req, res) {
    const userId = req.user.id;

    const data = await Database.instance.connection.manyOrNone(`
        SELECT t.*, d.name as destination_name, d.image as destination_image, d.description as destination_description,
        d.latitude as destination_latitude, d.longitude as destination_longitude, d.altitude as destination_altitude,
        c.id as city_id, c.name as city_name, u.username as user_name, u.email as user_email
        FROM travel as t
        LEFT JOIN destination as d ON t.destination_id = d.id
        LEFT JOIN city as c ON d.city_id = c.id
        LEFT JOIN "user" as u ON u.id = t.user_id
        WHERE t.user_id = $1
    `, [userId]);

    const rows = data.map(row => ({
        id: row.id,
        createdAt: row.created_at,
        finishedAt: row.finished_at,
        destination: {
            id: row.destination_id,
            name: row.destination_name,
            image: row.destination_image,
            description: row.destination_description,
            latitude: row.destination_latitude,
            longitude: row.destination_longitude,
            altitude: row.destination_altitude,
            city: {
                id: row.city_id,
                name: row.city_name,
            }
        },
        user: {
            id: row.user_id,
            username: row.user_name,
            email: row.user_email,
        }
    }));

    return res.status(200).json({
        message: 'success',
        data: rows,
    });
}

async function createReview(req, res) {
    const userId = req.user.id;
    const travelId = req.params.id;
    const { rating, content } = req.body;

    if (!rating) {
        return res.status(400).json({
            message: 'Rating is required',
        });
    }

    const data = await Database.instance.connection.one(`
        INSERT INTO review(travel_id, user_id, score, content, created_at) VALUES($1, $2, $3, $4, $5) RETURNING id
    `, [travelId, userId, rating, content, new Date()]);

    const row = {
        id: data.id,
        travel: {
            id: travelId,
        },
        user: {
            id: userId
        },
        score: rating,
        content: content,
        createdAt: new Date(),
    };

    return res.status(200).json({
        message: 'success',
        data: row,
    });
}

module.exports = {
    getTravels,
    getTravel,
    createTravel,
    completeTravel,
    getCompletedTravels,
    getActiveUserTravel,
    userIsTravelling,
    getUserTravels,
    createReview,
};