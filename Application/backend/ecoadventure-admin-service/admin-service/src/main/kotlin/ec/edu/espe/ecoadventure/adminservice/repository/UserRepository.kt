package ec.edu.espe.ecoadventure.adminservice.repository

import ec.edu.espe.ecoadventure.adminservice.entity.User
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface UserRepository : CrudRepository<User, Long> {
    fun findByUsername(username: String): User?
}