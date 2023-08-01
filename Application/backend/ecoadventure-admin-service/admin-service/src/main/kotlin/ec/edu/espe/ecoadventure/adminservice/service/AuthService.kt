package ec.edu.espe.ecoadventure.adminservice.service

import ec.edu.espe.ecoadventure.adminservice.dto.AuthCredentialsDto
import ec.edu.espe.ecoadventure.adminservice.dto.AuthResponseDto
import org.springframework.http.HttpStatus
import org.springframework.web.server.ResponseStatusException
import org.springframework.security.crypto.bcrypt.BCrypt
import org.springframework.stereotype.Service

@Service
class AuthService(
    private val userService: UserService,
    private val tokenService: TokenService) {
    fun login(credentials: AuthCredentialsDto): AuthResponseDto {
        val user = userService.findByUsername(credentials.username)

        if (user == null || !checkBcrypt(credentials.password, user.password)) {
            throw ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials")
        }

        val token = tokenService.createToken(user)
        return AuthResponseDto(token)
    }

    fun hashBcrypt(password: String): String {
        return BCrypt.hashpw(password, BCrypt.gensalt())
    }

    private fun checkBcrypt(input: String, hash: String): Boolean {
        return BCrypt.checkpw(input, hash)
    }
}