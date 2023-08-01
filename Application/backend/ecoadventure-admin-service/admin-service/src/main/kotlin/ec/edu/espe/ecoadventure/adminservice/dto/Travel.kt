package ec.edu.espe.ecoadventure.adminservice.dto

import ec.edu.espe.ecoadventure.adminservice.entity.Travel

data class TravelDto(
    val id: Long? = null,
    val name: String
);

fun TravelDto.toEntity() = Travel(
    id = id ?: 0,
    name = name
);