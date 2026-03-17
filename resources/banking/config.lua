-- FiveM Framework Configuration
-- Main configuration file for the entire framework

Config = {}

-- Server Configuration
Config.Server = {
    -- Database settings
    Database = {
        Host = "localhost",
        Port = 3306,
        Username = "fivem",
        Password = "password",
        Database = "fivem_db"
    },
    
    -- Server port
    Port = 30120,
    
    -- Max players
    MaxPlayers = 48,
    
    -- Server name
    ServerName = "FiveM Framework Server"
}

-- Job System Configuration
Config.Jobs = {
    SpawnPoint = {x = 425.4, y = -979.5, z = 29.4, heading = 0.0},
    
    Jobs = {
        police = {
            label = "Police Officer",
            grade = {
                [1] = {label = "Cadet", salary = 150},
                [2] = {label = "Officer", salary = 200},
                [3] = {label = "Sergeant", salary = 250},
                [4] = {label = "Lieutenant", salary = 300},
                [5] = {label = "Captain", salary = 350},
            }
        },
        
        medic = {
            label = "Paramedic",
            grade = {
                [1] = {label = "Student", salary = 100},
                [2] = {label = "Paramedic", salary = 200},
                [3] = {label = "Senior Paramedic", salary = 250},
            }
        },
        
        taxi = {
            label = "Taxi Driver",
            grade = {
                [1] = {label = "Taxi Driver", salary = 80},
            }
        },
    }
}

-- Inventory Configuration
Config.Inventory = {
    MaxSlots = 50,
    MaxWeight = 1000,
    
    Items = {
        money = {label = "Money", weight = 0, stackable = true},
        license = {label = "License", weight = 10, stackable = false},
        phone = {label = "Phone", weight = 200, stackable = false},
        keys = {label = "Keys", weight = 50, stackable = true},
    }
}

-- Banking Configuration
Config.Banking = {
    ATMLocations = {
        {x = 150.0, y = -885.0, z = 31.0},
        {x = 314.0, y = -279.0, z = 45.0},
        {x = -350.0, y = -52.0, z = 49.0},
    },
    
    StartingBalance = 5000,
    TransactionLimit = 999999,
}

-- Character Configuration
Config.Characters = {
    SpawnPoints = {
        {x = 425.4, y = -979.5, z = 29.4, heading = 0.0, label = "MRPD"},
        {x = -1035.0, y = -414.0, z = 58.6, heading = 179.5, label = "Pillbox Medical"},
    }
}

-- Vehicle Configuration
Config.Vehicles = {
    SpawnDistance = 50,
    GarageLimits = 10,
    
    VehicleList = {
        ["oracle"] = {label = "Oracle", category = "car"},
        ["police"] = {label = "Police Cruiser", category = "police"},
        ["ambulance"] = {label = "Ambulance", category = "emergency"},
        ["taxi"] = {label = "Taxi", category = "taxi"},
        ["blista"] = {label = "Blista", category = "car"},
    }
}

-- Police Configuration
Config.Police = {
    Precincts = {
        mrpd = {x = 425.4, y = -979.5, z = 29.4, label = "MRPD"}
    },
    
    CriminalsLocation = {x = 242.0, y = -952.0, z = 24.0},
}

-- NPC Configuration
Config.NPCs = {
    ScaleForm = "GTAO_FM_NPC_BACKGROUND",
}

-- UI Configuration
Config.UI = {
    Framework = "vue3",
    Theme = "dark",
    Language = "en"
}

-- Logging
Config.Logging = {
    Enabled = true,
    Level = "DEBUG", -- DEBUG, INFO, WARNING, ERROR
}
