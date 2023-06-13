```mermaid
flowchart TD
    subgraph Frontend
        Login
        Home
        Destiny-Activities
        Environment-Information
        Profile
    end
    subgraph Backend
        subgraph API-Gateway
            Login-&-Register
            Search
            View-Destiny
            Login-&-Register -->|API Calls| Search
            Login-&-Register -->|API Calls| View-Destiny
        end
    end
    subgraph Database
        subgraph Primary-database
            Save-data
        end
        subgraph Redis
            Hash-Caching
        end
    end
    Frontend -->|HTTP Requests| API-Gateway
    API-Gateway -->|CRUD| Primary-database
    API-Gateway -->|API Calls| Login-&-Register
    API-Gateway -->|API Calls| Search
    API-Gateway -->|API Calls| View-Destiny
    API-Gateway -->|Caching| Hash-Caching
 ```   
