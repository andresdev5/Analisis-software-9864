```mermaid
flowchart TD
    subgraph Frontend
        hoteles
        clientes
        habitaciones
        reservacion
    end
    subgraph Backend
        subgraph API-Gateway
            menu
            Search
            View-Destiny
            python -->|API Calls| Search
            go -->|API Calls| search
        end
    end
    subgraph Database
        subgraph Primary-database
            Save-data
        end
    end
    Frontend -->|HTTP Requests| API-Gateway
    API-Gateway -->|CRUD| Primary-database
    API-Gateway -->|API Calls| hoteles
    API-Gateway -->|API Calls| clientes
    API-Gateway -->|API Calls| habitaciones
    API-Gateway -->|API Calls| reservacion
 ```   
