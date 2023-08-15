const { Database } = require('../core/database.js');

async function getDestinations(req, res) {
    const data = await Database.instance.connection.any(`
        SELECT d.*, 
            COALESCE((SELECT AVG(r.score) FROM review as r 
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0)::decimal as score,
            COALESCE((SELECT COUNT(r.id)
                FROM review as r
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination as d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0)::int as total_reviews
        FROM destination as d
        ORDER BY id DESC
    `);

    return res.status(200).json({
        message: 'success',
        data: data,
    });
}

async function getDestination(req, res) {
    const id = req.params.id;

    const data = await Database.instance.connection.oneOrNone(`
        SELECT d.*, 
            COALESCE((SELECT AVG(r.score) FROM review as r 
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0)::decimal as score,
            COALESCE((SELECT COUNT(r.id)
                FROM review as r
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination as d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0)::int as total_reviews,
            c.id as city_id, c.name as city_name
        FROM destination as d
        LEFT JOIN city as c ON d.city_id = c.id
        WHERE d.id = $1
    `, [id]);

    if (!data) {
        return res.status(404).json({ message: 'destination not found' });
    }

    data['city'] = {
        id: data.city_id,
        name: data.city_name,
    };

    return res.status(200).json({
        message: 'success',
        data: data,
    });
}

async function getPopularDestinations(req, res) {
    const data = await Database.instance.connection.any(`
            SELECT d.*, 
            COALESCE((SELECT AVG(r.score) FROM review as r 
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0)::decimal as score,
            COALESCE((SELECT COUNT(r.id)
                FROM review as r
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination as d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0)::int as total_reviews
        FROM destination as d
        ORDER BY score DESC
    `);

    return res.status(200).json({
        message: 'success',
        data: data,
    });
}

async function searchDestination(req, res) {
    let search = req.query.search;

    if (!search) {
        return res.status(400).json({ message: 'search query is required' });
    }

    search = search.trim().toLowerCase();
    const data = await Database.instance.connection.any(`
        SELECT d.*,
            COALESCE((SELECT COUNT(r.id)
                FROM review as r
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination as d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0)::int as total_reviews,
            COALESCE((SELECT AVG(r.score) FROM review as r
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0) as score
        FROM destination as d
        WHERE name ILIKE '%${search}%' OR description ILIKE '%${search}%'
        ORDER BY ((name ILIKE '%${search}%')::int + (description ILIKE '%${search}%')::int + COALESCE((SELECT AVG(r.score) FROM review as r
                LEFT JOIN travel as t ON r.travel_id = t.id
                LEFT JOIN destination d2 on t.destination_id = d2.id
                WHERE d2.id = d.id), 0)) DESC
    `);

    return res.status(200).json({
        message: 'success',
        data: data,
    });
}

async function getReviews(req, res) {
    const data = await Database.instance.connection.any(`
        SELECT r.*, u.username as user_name, u.email as user_email,
            d.id as destination_id, d.name as destination_name
        FROM review as r
        LEFT JOIN travel as t ON r.travel_id = t.id
        LEFT JOIN destination as d on t.destination_id = d.id
        LEFT JOIN "user" as u on r.user_id = u.id
        ORDER BY r.id DESC
    `);

    const rows = data.map((review) => ({
        id: review.id,
        content: review.content,
        score: review.score,
        createdAt: review.created_at,
        user: {
            id: review.user_id,
            username: review.user_name,
            email: review.user_email,
        },
        destination: {
            id: review.destination_id,
            name: review.destination_name,
        }
    }));

    return res.status(200).json({
        message: 'success',
        data: rows,
    });
}

async function getDestinationReviews(req, res) {
    const id = req.params.id;

    const data = await Database.instance.connection.any(`
        SELECT r.*, u.username as user_name, u.email as user_email
        FROM review as r
        LEFT JOIN travel as t ON r.travel_id = t.id
        LEFT JOIN destination as d on t.destination_id = d.id
        LEFT JOIN "user" as u on r.user_id = u.id
        WHERE d.id = $1
        ORDER BY r.id DESC
    `, [id]);

    const rows = data.map((review) => ({
        id: review.id,
        content: review.content,
        score: review.score,
        createdAt: review.created_at,
        user: {
            id: review.user_id,
            username: review.user_name,
            email: review.user_email,
        }
    }));

    return res.status(200).json({
        message: 'success',
        data: rows,
    });
}

module.exports = {
    getDestinations,
    searchDestination,
    getPopularDestinations,
    getReviews,
    getDestination,
    getDestinationReviews
};