# System Architecture Documentation

This document outlines the system architecture of the Flutter Online Card Game project using Mermaid diagrams.

## System Architecture

```mermaid
---
config:
  theme: 'neutral'
---
graph
    subgraph Hosting ["Firebase Hosting"]
        subgraph "Client (Flutter Web)"
            UI[View]
            Repo[Repository]
        end
    end
    
    subgraph "Backend (Firebase)"
        Auth[Firebase Auth]
        Functions[Cloud Functions]
        RTDB[Realtime Database]
        AppCheck[App Check<br/>Token Verification]
    end
    
    UI --> Repo
    Repo --> Auth
    Functions <--Read/Write--> RTDB
    Repo --Read--> RTDB
    Repo <--> Functions
    
    Auth -.- AppCheck
    Functions -.- AppCheck
    RTDB -.- AppCheck
```

## Security Architecture

```mermaid
---
config:
  theme: 'neutral'
---
graph TB
    subgraph "Client Security"
        AnonymousAuth[Anonymous Authentication]
        TokenValidation[Token Validation]
    end
    
    subgraph "Backend Security"
        CloudFunctions[Authenticated Cloud Functions]
        InputValidation[Input Validation]
    end

    subgraph "Realtime Database"
        DatabaseRules[Database Security Rules]
        RealtimeDB[(Realtime Database)]
    end
    
    AnonymousAuth --> TokenValidation
    TokenValidation --> CloudFunctions
    CloudFunctions --> InputValidation
    InputValidation --> DatabaseRules
    
    DatabaseRules --> RealtimeDB[(Realtime Database)]
```

## Screens

```mermaid
---
config:
  theme: 'neutral'
---
flowchart TB
    Launch(( ))

    subgraph "Top Screens"
        Startup[Startup Screen]
        Top[Top Screen]
        Join[Join Game Screen]
    end
    
    subgraph GameScreens ["Game Screens"]
        direction TB
        Matching[Matching Screen]
        Playing[Playing Screen]
        Result[Result Screen]
    end

    Launch --> Startup
    Startup --If entered with<br>invitation URL--> Join
    Startup --If already<br>in game--> GameScreens

    Startup --> Top
    Top --Join Game--> Join
    Top --Create Game--> GameScreens
    Join --> GameScreens
    
    Matching --> Playing
    Playing --> Result
```

## Data Flow Architecture

```mermaid
---
config:
  theme: 'neutral'
---
sequenceDiagram
    participant Client as Flutter Client
    participant Auth as Firebase Auth
    participant Functions as Cloud Functions
    participant RTDB as Realtime Database
    
    Client->>Auth: Anonymous Login
    Auth-->>Client: User Token
    
    Client->>Functions: Create/Join Game
    Functions->>RTDB: Store Game Data
    Functions-->>Client: Game Info
    
    Client->>RTDB: Listen to Game State
    RTDB-->>Client: Real-time Updates
    
    Client->>Functions: Game Actions
    Functions->>RTDB: Update Game State
    RTDB-->>Client: State Changes
```