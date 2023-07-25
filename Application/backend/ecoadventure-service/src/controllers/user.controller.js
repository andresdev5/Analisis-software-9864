const { Database } = require('../core/database.js');
const jsonwebtoken = require('jsonwebtoken');
const bcrypt = require('bcrypt');

async function getUser(req, res) {
    const data = await Database.instance.connection.any(`
        SELECT u.id, u.username, u.email, r.id as role_id, r.name AS role_name, r.description AS role_description
        FROM public.user as u 
        LEFT JOIN public.role r ON u.role_id = r.id
        WHERE u.id = $1`, 
        [req.user.id]
    );

    if (data.length === 0) {
        return res.status(400).json({
            message: 'User not found',
        });
    }

    const row = data[0];

    return res.status(200).json({
        message: 'success',
        data: {
            id: row.id,
            username: row.username,
            email: row.email,
            role: {
                id: row.role_id,
                name: row.role_name,
                description: row.role_description
            }
        },
    });
}

async function getProfile(req, res) {
    const data = await Database.instance.connection.any(`
        SELECT u.id, u.username, u.email, up.firstname, up.lastname, up.about, up.birthday, up.phone,
               up.avatar, c.code AS country_code, c.name AS country_name, r.id as role_id, r.name AS role_name,
               r.description AS role_description
        FROM public.user u
        LEFT JOIN public.role r ON u.role_id = r.id
        LEFT JOIN public.user_profile up ON u.id = up.user_id
        LEFT JOIN public.country c ON up.country_code = c.code
        WHERE u.id = $1
    `, [req.user.id]);

    if (data.length === 0) {
        return res.status(400).json({
            message: 'User not found',
        });
    }

    const row = data[0];
    const output = {
        user: {
            id: row.id,
            username: row.username,
            email: row.email,
            role: {
                id: row.role_id,
                name: row.role_name,
                description: row.role_description
            }
        },
        profile: {
            firstname: row.firstname,
            lastname: row.lastname,
            about: row.about,
            birthday: row.birthday,
            phone: row.phone,
            avatar: row.avatar,
            country: {
                code: row.country_code,
                name: row.country_name
            }
        }
    };

    console.log(output);

    return res.status(200).json({
        message: 'success',
        data: {
            user: {
                id: row.id,
                username: row.username,
                email: row.email,
                role: {
                    id: row.role_id,
                    name: row.role_name,
                    description: row.role_description
                }
            },
            profile: {
                firstname: row.firstname,
                lastname: row.lastname,
                about: row.about,
                birthday: row.birthday,
                phone: row.phone,
                avatar: row.avatar,
                country: {
                    code: row.country_code,
                    name: row.country_name
                }
            }
        },
    });
}

async function updateProfile(req, res) {
    const userId = req.params.id;

    const { firstname, lastname, about, birthday, phone, avatar, country } = req.body;
    const country_code = country ? (country.code || null) : null;

    const user = await Database.instance.connection.any(`SELECT * FROM public.user WHERE id = $1`, [userId]);

    if (user.length === 0) {
        return res.status(400).json({
            message: 'User not found',
        });
    }

    const data = await Database.instance.connection.any(`
        UPDATE public.user_profile
        SET firstname = $1, lastname = $2, about = $3, birthday = $4, phone = $5, avatar = $6, country_code = $7
        WHERE user_id = $8
    `, [firstname, lastname, about, birthday, phone, avatar, country_code, userId]);

    return res.status(200).json({
        message: 'success',
    });
}

module.exports = {
    getUser,
    getProfile,
    updateProfile
};