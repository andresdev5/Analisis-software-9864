package ec.edu.espe.ecoadventure.adminservice.entity

import jakarta.persistence.*

@Entity
data class Travel(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "travel_id_generator")
    @SequenceGenerator(name = "travel_id_generator", sequenceName = "travel_id_seq", allocationSize = 1)
    val id: Long,
    val name: String
);