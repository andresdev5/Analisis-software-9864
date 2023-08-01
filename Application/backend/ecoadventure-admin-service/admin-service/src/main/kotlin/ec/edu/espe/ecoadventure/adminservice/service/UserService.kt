package ec.edu.espe.ecoadventure.adminservice.service

import ec.edu.espe.ecoadventure.adminservice.entity.User
import ec.edu.espe.ecoadventure.adminservice.repository.UserRepository
import org.springframework.stereotype.Service
import java.util.Optional

@Service
class UserService(private val userRepository: UserRepository) {
    fun findById(userId: Long): Optional<User> {
        return userRepository.findById(userId);
    }

    fun findByUsername(username: String): User? {
        return userRepository.findByUsername(username);
    }
}