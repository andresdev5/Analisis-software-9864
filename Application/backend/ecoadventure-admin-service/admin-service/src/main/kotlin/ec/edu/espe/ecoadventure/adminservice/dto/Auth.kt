package ec.edu.espe.ecoadventure.adminservice.dto

data class AuthResponseDto(
    val token: String
)

data class AuthCredentialsDto(
    val username: String,
    val password: String
)
