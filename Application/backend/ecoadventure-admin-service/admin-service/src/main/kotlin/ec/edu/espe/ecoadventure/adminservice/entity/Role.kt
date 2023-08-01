package ec.edu.espe.ecoadventure.adminservice.entity

import jakarta.persistence.*

@Entity
data class Role(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "role_id_generator")
    @SequenceGenerator(name = "role_id_generator", sequenceName = "role_id_seq", allocationSize = 1)
    val id: Long,
    val name: String,
    val description: String,
)