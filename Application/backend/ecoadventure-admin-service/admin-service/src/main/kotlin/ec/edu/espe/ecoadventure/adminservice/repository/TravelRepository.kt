package ec.edu.espe.ecoadventure.adminservice.repository

import ec.edu.espe.ecoadventure.adminservice.entity.Travel
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface TravelRepository : CrudRepository<Travel, Long> {}