package ec.edu.espe.ecoadventure.adminservice.config

import ec.edu.espe.ecoadventure.adminservice.entity.User
import org.springframework.security.core.Authentication

fun Authentication.toUser(): User {
    return principal as User
}