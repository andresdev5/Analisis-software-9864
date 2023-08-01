package ec.edu.espe.ecoadventure.adminservice.entity

import jakarta.persistence.*

@Entity
@Table(name = "user", schema = "public")
data class User(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_id_generator")
    @SequenceGenerator(name = "user_id_generator", sequenceName = "user_id_seq", allocationSize = 1)
    val id: Long,

    val username: String,
    val password: String,
    val email: String,

    @ManyToOne
    @JoinColumn(name = "role_id")
    val role: Role,
)