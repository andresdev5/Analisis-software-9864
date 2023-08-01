package ec.edu.espe.ecoadventure.adminservice.service

import ec.edu.espe.ecoadventure.adminservice.entity.User
import org.springframework.security.oauth2.jwt.*
import org.springframework.stereotype.Service
import java.time.Instant
import java.time.temporal.ChronoUnit

@Service
class TokenService(
    private val jwtDecoder: JwtDecoder,
    private val jwtEncoder: JwtEncoder,
    private val userService: UserService,
) {
    fun createToken(user: User): String {
        val data = mapOf(
            "id" to user.id,
            "username" to user.username,
            "email" to user.email,
            "role" to mapOf(
                "id" to user.role.id,
                "name" to user.role.name,
            )
        )

        val jwsHeader = JwsHeader.with { "HS256" }.build()
        val claims = JwtClaimsSet.builder()
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plus(31L, ChronoUnit.DAYS))
            .subject(user.username)
            .claim("data", data)
            .build()
        return jwtEncoder.encode(JwtEncoderParameters.from(jwsHeader, claims)).tokenValue
    }

    fun parseToken(token: String): User? {
        return try {
            val jwt = jwtDecoder.decode(token)
            val data = jwt.claims["data"] as Map<*, *>
            val userId = data["id"] as Long
            userService.findById(userId).orElse(null)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}