erDiagram

    %% ---------------------------------------------------------
    %% Tables Principales (Utilisateurs et Logs)
    %% ---------------------------------------------------------

    users {
        bigint id PK
        varchar username
        varchar email
        varchar password_hash
        numeric pokedollars
        numeric lifetime_earnings
        bigint total_clicks
        double_precision latitude
        double_precision longitude
        timestamp last_sync
    }

    auth_logs {
        bigint id PK
        bigint user_id FK
        varchar email
        varchar action
        timestamp timestamp
    }

    transaction_logs {
        bigint id PK
        bigint user_id FK
        varchar transaction_type
        numeric amount
        text description
        timestamp timestamp
    }

    %% ---------------------------------------------------------
    %% Tables de Référence (Données du jeu)
    %% ---------------------------------------------------------

    ref_pokemon {
        bigint id PK
        varchar name
        text description
        numeric base_cost
        numeric base_production
        varchar rarity
        varchar region_origin
    }

    ref_infrastructures {
        bigint id PK
        varchar name
        text description
        numeric base_cost
        float production_bonus
        integer capacity
    }

    ref_upgrades {
        bigint id PK
        varchar name
        text description
        varchar effect_type
        float effect_value
        numeric cost
    }

    %% ---------------------------------------------------------
    %% Tables de Liaison (Inventaires Joueur)
    %% ---------------------------------------------------------

    user_pokemon {
        bigint user_id PK, FK
        bigint pokemon_id PK, FK
        integer quantity
        timestamp date_acquired
    }

    user_infrastructures {
        bigint user_id PK, FK
        bigint infrastructure_id PK, FK
        integer quantity
        timestamp date_built
    }

    user_upgrades {
        bigint user_id PK, FK
        bigint upgrade_id PK, FK
        integer quantity
        timestamp acquired_at
    }

    %% ---------------------------------------------------------
    %% Relations
    %% ---------------------------------------------------------

    %% Un utilisateur peut avoir plusieurs logs
    users ||--o{ auth_logs : "génère"
    users ||--o{ transaction_logs : "effectue"

    %% Gestion des Pokemons (Relation Many-to-Many via user_pokemon)
    users ||--o{ user_pokemon : "possède"
    ref_pokemon ||--o{ user_pokemon : "défini"

    %% Gestion des Infrastructures (Relation Many-to-Many via user_infrastructures)
    users ||--o{ user_infrastructures : "construit"
    ref_infrastructures ||--o{ user_infrastructures : "défini"

    %% Gestion des Upgrades (Relation Many-to-Many via user_upgrades)
    users ||--o{ user_upgrades : "débloque"
    ref_upgrades ||--o{ user_upgrades : "défini"