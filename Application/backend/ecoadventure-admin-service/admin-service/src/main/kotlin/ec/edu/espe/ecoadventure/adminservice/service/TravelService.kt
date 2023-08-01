package ec.edu.espe.ecoadventure.adminservice.service

import ec.edu.espe.ecoadventure.adminservice.dto.TravelDto
import ec.edu.espe.ecoadventure.adminservice.dto.toEntity
import ec.edu.espe.ecoadventure.adminservice.entity.Travel
import ec.edu.espe.ecoadventure.adminservice.repository.TravelRepository
import org.springframework.stereotype.Service

@Service
class TravelService(private val travelRepository: TravelRepository) {
    fun getTravels(): List<Travel> {
        return travelRepository.findAll().toList();
    }

    fun getTravel(id: Long): Travel {
        return travelRepository.findById(id).get();
    }

    fun saveTravel(travel: TravelDto): Travel {
        return travelRepository.save(travel.toEntity());
    }

    fun updateTravel(travel: TravelDto): Travel {
        return travelRepository.save(travel.toEntity());
    }

    fun deleteTravel(id: Long) {
        travelRepository.deleteById(id);
    }
}