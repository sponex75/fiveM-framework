# FiveM Framework

A comprehensive, production-ready FiveM framework with multiple game systems and features.

## Features

### ✅ Implemented Systems

- **Job System**: Multiple jobs with grades and salaries
- **Inventory System**: Weight-based inventory with stackable items
- **Banking System**: Bank accounts, deposits, withdrawals, transfers
- **Character Management**: Character creation and selection
- **Vehicle System**: Vehicle registration, spawning, and garage management
- **Police System**: Warrants, arrests, wanted levels
- **NPC Interactions**: Dialogue system with NPC interactions
- **Notification/UI System**: Modern dark-themed UI with notifications

## Project Structure

```
fiveM-framework/
├── config/
│   ├── config.lua          # Main configuration file
│   └── shared.lua          # Shared utilities
├── resources/
│   ├── base/               # Core framework
│   │   ├── server.lua
│   │   └── client.lua
│   ├── jobs/               # Job system
│   ├── inventory/          # Inventory system
│   ├── banking/            # Banking system
│   ├── characters/         # Character management
│   ├── vehicles/           # Vehicle system
│   ├── police/             # Police system
│   ├── npcs/               # NPC system
│   └── ui/                 # User interface
│       └── html/
│           ├── index.html
│           ├── css/
│           │   └── style.css
│           └── js/
│               └── app.js
└── fxmanifest.lua          # FiveM manifest file
```

## Installation

1. **Clone or extract the framework** into your FiveM `resources` folder:
   ```
   cp -r fiveM-framework FiveM/resources/
   ```

2. **Update server.cfg** to load the framework:
   ```
   ensure fiveM-framework
   ```

3. **Install dependencies**:
   - PolyZone (for zone management)
   - oxmysql (for database operations) - optional

4. **Start your server** and the framework will initialize

## Configuration

Edit `config/config.lua` to customize:

- Server settings (port, max players)
- Jobs and salaries
- Inventory limits
- Banking features
- Vehicle settings
- ATM locations
- Spawn points

## Usage

### Commands

#### Job System
- `/setjob <player_id> <job_name> [grade]` - Set player job
- `/removejob <player_id>` - Remove player job
- `/jobs` - List all available jobs
- `/jobinfo` - Display current job info
- `/jobclock in|out` - Clock in/out

#### Inventory
- `/inventory` - Open inventory
- `/additem <player_id> <item_name> <quantity>` - Add item
- `/removeitem <player_id> <item_name> <quantity>` - Remove item

#### Banking
- `/balance` - Check bank balance
- `/deposit <amount>` - Deposit to bank
- `/withdraw <amount>` - Withdraw from bank
- `/atm` - Access ATM

#### Vehicles
- `/garage` - Open vehicle garage
- `/spawnvehicle <model> [plate]` - Spawn a vehicle
- `/deletevehicle <id>` - Delete vehicle
- `/engine` - Toggle engine
- `/lockvehicle` - Lock/unlock vehicle
- `/storevehicle` - Store vehicle in garage

#### Characters
- `/createchar <first_name> <last_name>` - Create character
- `/selectchar` - Select character
- `/delchar <char_id>` - Delete character

#### Police
- `/arrest <player_id> <charges>` - Arrest player
- `/warrant <player_id> <reason>` - Issue warrant
- `/removewanted <player_id>` - Remove wanted status
- `/wantedlevel <player_id> <level>` - Set wanted level

#### NPC
- `/createnpc <model> <x> <y> <z> [name]` - Create NPC
- `/deletenpc <npc_id>` - Delete NPC

### Events (Client)

```lua
-- Listen for framework ready
RegisterNetEvent("framework:clientReady")
AddEventHandler("framework:clientReady", function()
    -- Framework is ready
end)

-- Listen for player job change
RegisterNetEvent("framework:setJob")
AddEventHandler("framework:setJob", function(jobData)
    -- New job data
end)

-- Listen for inventory update
RegisterNetEvent("inventory:update")
AddEventHandler("inventory:update", function(inventory)
    -- Updated inventory
end)
```

### Events (Server)

```lua
-- Trigger events on server
TriggerEvent("banking:addMoney", playerId, amount)
TriggerEvent("npcs:action_police", playerId, action)
```

### Exports

```lua
-- Check if framework is ready
exports.base:isFrameworkReady()

-- Get player data
local playerData = GetPlayerData(playerId)

-- Get player job
local job = GetPlayerJob(playerId)

-- Get inventory
local inventory = GetInventory(playerId)

-- Check if player has item
local hasItem = HasItem(playerId, itemName, quantity)
```

## Developer Guide

### Adding a New Job

In `config/config.lua`:

```lua
Config.Jobs.Jobs.electrician = {
    label = "Electrician",
    grade = {
        [1] = {label = "Apprentice", salary = 120},
        [2] = {label = "Electrician", salary = 180},
        [3] = {label = "Master", salary = 250},
    }
}
```

### Adding a New Item

In `config/config.lua`:

```lua
Config.Inventory.Items.crowbar = {
    label = "Crowbar", 
    weight = 500, 
    stackable = false
}
```

### Creating a Custom NPC

In your client script:

```lua
TriggerServerEvent("npcs:create", {
    model = "a_m_m_business_1",
    x = 100.0,
    y = 200.0,
    z = 30.0,
    heading = 0.0,
    name = "Custom NPC",
    dialogues = {
        {text = "Hello!", action = "custom_action"}
    }
})
```

## Database Setup

For production use with oxmysql, create these tables:

```sql
CREATE TABLE characters (
    id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT NOT NULL,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    level INT DEFAULT 1,
    money INT DEFAULT 5000,
    bank_balance INT DEFAULT 5000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT NOT NULL,
    model VARCHAR(50),
    plate VARCHAR(20),
    fuel INT DEFAULT 100,
    engine_health INT DEFAULT 1000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bank_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT NOT NULL,
    type VARCHAR(50),
    amount INT,
    balance INT,
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Customization

### Changing the UI Theme

Edit `resources/ui/html/css/style.css` to modify colors, spacing, and layout.

### Default Colors
- Primary: `#00d4ff` (Cyan)
- Success: `#00ff00` (Green)
- Error: `#ff0000` (Red)
- Warning: `#ffaa00` (Orange)

### Adding New Menu Pages

1. Add HTML in `resources/ui/html/index.html`
2. Add CSS styles in `resources/ui/html/css/style.css`
3. Add JavaScript handlers in `resources/ui/html/js/app.js`
4. Create Lua client event handlers in resource scripts

## Performance Optimization

- Main update loop runs at controlled intervals
- NPC interactions checked every 300ms
- Salary payments every 60 seconds
- Distance-based rendering for vehicles

## Dependencies

- **PolyZone** - For zone management (optional)
- **oxmysql** - For database operations (optional)

## Troubleshooting

### Framework not initializing?
- Check server console for error messages
- Ensure all Lua files have valid syntax
- Verify fxmanifest.lua is present

### UI not appearing?
- Check browser console (F8 in game)
- Ensure UI page is set in fxmanifest.lua
- Verify NUI callbacks are registered

### Commands not working?
- Use proper player ID (server-side in console)
- Check if player has required permissions
- Log messages should appear in server console

## License

Community License - Free to use and modify for private servers

## Support

For issues, questions, or contributions, check the framework documentation or server logs.

## Changelog

### Version 1.0.0
- Initial release with core systems
- Job, inventory, banking, vehicles, characters
- Police system with wanted levels
- NPC interaction system
- Modern dark-themed UI
- 50+ commands and exports

---

**Happy Scripting!** 🎮
