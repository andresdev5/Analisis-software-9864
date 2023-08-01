package ec.edu.espe.ecoadventure.adminservice.controller

import ec.edu.espe.ecoadventure.adminservice.config.toUser
import ec.edu.espe.ecoadventure.adminservice.dto.TravelDto
import ec.edu.espe.ecoadventure.adminservice.entity.Travel
import ec.edu.espe.ecoadventure.adminservice.service.TokenService
import ec.edu.espe.ecoadventure.adminservice.service.TravelService
import ec.edu.espe.ecoadventure.adminservice.service.UserService
import org.springframework.security.core.Authentication
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api")
class TravelController(private val travelService: TravelService) {
    @GetMapping("/travels")
    fun getTravels(): List<Travel> {
        return travelService.getTravels();
    }

    @GetMapping("/travels/{id}")
    fun getTravel(@PathVariable id: Long): Travel {
        return travelService.getTravel(id);
    }

    @PostMapping("/travels")
    fun saveTravel(@RequestBody travel: TravelDto): Travel {
        return travelService.saveTravel(travel);
    }

    @PutMapping("/travels")
    fun updateTravel(@RequestBody travel: TravelDto): Travel {
        return travelService.updateTravel(travel);
    }

    @DeleteMapping("/travels/{id}")
    fun deleteTravel(@PathVariable id: Long) {
        travelService.deleteTravel(id);
    }
}