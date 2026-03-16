# Complete Command Reference

## 📋 All Available Commands

### 🔧 System Commands

| Command | Usage | Example | Admin |
|---------|-------|---------|-------|
| `/status` | Check server status | `/status` | Yes |
| `/inventory` | Open/close inventory | `/inventory` | No |
| `/closeinventory` | Close inventory menu | `/closeinventory` | No |

---

### 💼 Job Commands

| Command | Parameter | Description | Example | Admin |
|---------|-----------|-------------|---------|-------|
| `/setjob` | player_id job_name [grade] | Assign job to player | `/setjob 1 police 2` | ✅ |
| `/removejob` | player_id | Remove player's job | `/removejob 1` | ✅ |
| `/jobs` | - | List all available jobs | `/jobs` | No |
| `/jobinfo` | - | Display current job info | `/jobinfo` | No |
| `/jobclock` | in \| out | Clock in or out of job | `/jobclock in` | No |

---

### 💰 Banking Commands

| Command | Parameter | Description | Example | Admin |
|---------|-----------|-------------|---------|-------|
| `/balance` | - | Check bank balance | `/balance` | No |
| `/deposit` | amount | Deposit money to bank | `/deposit 5000` | No |
| `/withdraw` | amount | Withdraw from bank | `/withdraw 2000` | No |
| `/atm` | - | Access ATM (if nearby) | `/atm` | No |

---

### 📦 Inventory Commands

| Command | Parameter | Description | Administrator | Example |
|---------|-----------|-------------|---------|---------|
| `/additem` | player_id item_name quantity | Add item to inventory | ✅ | `/additem 1 money 5000` |
| `/removeitem` | player_id item_name quantity | Remove item from inventory | ✅ | `/removeitem 1 money 1000` |

### Inventory Details

**Max Slots**: 50
**Max Weight**: 1000 (units)

**Default Items**:
- `money` - Currency, weight: 0
- `license` - License documents, weight: 10
- `phone` - Mobile device, weight: 200
- `keys` - Vehicle/property keys, weight: 50

---

### 👤 Character Commands

| Command | Parameter | Description | Example | Admin |
|---------|-----------|-------------|---------|-------|
| `/newchar` | first_name last_name [gender] | Create new character | `/newchar John Doe` | No |
| `/selectchar` | - | Open character selection | `/selectchar` | No |
| `/delchar` | character_id | Delete character | `/delchar char_123456` | ✅ |

**Starting Resources**:
- Starting Balance: $5,000
- Starting Items: Phone, License, Keys
- Default Level: 1
- Default Job: Unemployed

---

### 🚗 Vehicle Commands

| Command | Parameter | Description | Example | Admin |
|---------|-----------|-------------|---------|-------|
| `/garage` | - | Open vehicle garage | `/garage` | No |
| `/spawnvehicle` | model [plate] | Spawn vehicle from list | `/spawnvehicle police` | ✅ |
| `/deletevehicle` | vehicle_id | Delete spawned vehicle | `/deletevehicle veh_123` | ✅ |
| `/engine` | - | Toggle engine on/off | `/engine` | No |
| `/lockvehicle` | - | Lock/unlock vehicle | `/lockvehicle` | No |
| `/storevehicle` | - | Store vehicle in garage | `/storevehicle` | No |

**Available Vehicles**:
- `oracle` - Oracle sports car
- `police` - Police Cruiser
- `ambulance` - Ambulance
- `taxi` - Taxi cab
- `blista` - Blista compact car

**Garage Limits**: 10 vehicles per player

---

### 🚔 Police Commands

| Command | Parameter | Description | Example | Admin |
|---------|-----------|-------------|---------|-------|
| `/arrest` | player_id charges | Arrest player (LEO only) | `/arrest 2 Grand Theft Auto` | ✅ |
| `/warrant` | player_id reason | Issue warrant (LEO only) | `/warrant 3 Armed Robbery` | ✅ |
| `/removewanted` | player_id | Clear wanted status | `/removewanted 1` | ✅ |
| `/wantedlevel` | player_id level | Set wanted level (0-5) | `/wantedlevel 1 3` | ✅ |

**Wanted Levels**:
- 0 = Clear
- 1 = Minor
- 2 = Wanted
- 3 = High Priority
- 4 = Extreme
- 5 = Most Wanted

**Arrest Details**:
- Jail Location: PDM Prison
- Base Jail Time: 60 seconds
- Bail Available: Yes

---

### 👥 NPC Commands

| Command | Parameter | Description | Example | Admin |
|---------|-----------|-------------|---------|-------|
| `/createnpc` | model x y z [name] | Create new NPC | `/createnpc a_m_m_business_1 100 200 30 shopkeeper` | ✅ |
| `/deletenpc` | npc_id | Delete specific NPC | `/deletenpc npc_123456` | ✅ |

**Default NPCs**:
1. **Taxi Driver** - 425.4, -979.5, 29.4
2. **Bank Teller** - 150.0, -885.0, 31.0
3. **Hospital Receptionist** - -1035.0, -414.0, 58.6

**Interaction**: Press 'E' when near an NPC

---

## 🎮 UI/Menu System

### Main Menu
Press `/menu` or bind ESC to access main menu with options:
- 📦 Inventory
- 💼 Job Info
- 🏦 Bank
- 👤 Character
- 🚗 Vehicles
- 🚔 Police

### Hotkeys
- **ESC** - Close current menu
- **E** - Interact with nearby NPCs
- **T** - Open character menu

---

## 📊 Abbreviated Command List

```
Jobs:         /setjob /removejob /jobs /jobinfo /jobclock
Banking:      /balance /deposit /withdraw /atm
Inventory:    /inventory /closeinventory /additem /removeitem
Characters:   /newchar /selectchar /delchar
Vehicles:     /garage /spawnvehicle /deletevehicle /engine /lockvehicle /storevehicle
Police:       /arrest /warrant /removewanted /wantedlevel
NPCs:         /createnpc /deletenpc
```

---

## 🔐 Permission Levels

### Admin Commands (✅)
These require admin/developer privileges:
- `/setjob` - Set player jobs
- `/removejob` - Remove jobs
- `/spawnvehicle` - Spawn vehicles
- `/deletevehicle` - Delete vehicles
- `/additem` - Add items
- `/removeitem` - Remove items
- `/createnpc` - Create NPCs
- `/deletenpc` - Delete NPCs
- `/delchar` - Delete characters
- `/arrest` - Arrest players
- `/warrant` - Issue warrants
- `/removewanted` - Clear warrants
- `/wantedlevel` - Set wanted levels

### Player Commands (No Admin)
These work for any player:
- `/inventory` - View/manage inventory
- `/balance` - Check bank
- `/deposit` - Deposit money
- `/withdraw` - Withdraw money
- `/atm` - Use ATM
- `/garage` - Access garage
- `/engine` - Control vehicle
- `/lockvehicle` - Lock/unlock
- `/storevehicle` - Store vehicle
- `/newchar` - Create character
- `/selectchar` - Select character
- `/jobs` - View jobs
- `/jobinfo` - Check job status
- `/jobclock` - Clock in/out

---

## 🔤 Command Syntax Guide

### Standard Format
```
/command argument1 argument2 [optional]
```

### Examples
- `/setjob 1 police 2` - Set player 1 to police grade 2
- `/additem 1 money 5000` - Add 5000 money to player 1
- `/spawnvehicle police` - Spawn police cruiser
- `/createnpc a_m_m_business_2 100 200 30 "My NPC"` - Create NPC

### Error Messages
- "You must be near..." - Distance requirement not met
- "You don't have a job" - Command requires active job
- "Insufficient funds" - Not enough money
- "Inventory full" - Too many items
- "Vehicle not found" - Invalid vehicle model

---

## 💡 Tips & Tricks

### Quick Commands
1. Bind commands to hotkeys for faster access
2. Use Tab to auto-complete commands
3. Use `/help [command]` for command-specific help

### Common Workflows
```
New Player Setup:
1. /newchar FirstName LastName
2. /selectchar
3. /setjob [playerid] taxi 1
4. /additem [playerid] money 5000
5. /spawnvehicle taxi

Police Officer Setup:
1. /setjob [playerid] police 1
2. /spawnvehicle police
3. /wantedlevel 0 (Clear any flags)

Bank Visit:
1. /balance (Check balance)
2. /deposit 1000 (Deposit money)
3. /inventory (Verify)
```

---

## 🚀 Advanced Usage

### Creating Custom Commands
Edit any resource server.lua and add:
```lua
RegisterCommand("mycommand", function(source, args, rawCommand)
    TriggerClientEvent("framework:notify", source, {
        title = "Custom Command",
        message = "Your message here",
        type = "success"
    })
end, false)
```

### Command with Arguments
```lua
RegisterCommand("pay", function(source, args, rawCommand)
    if args[1] and args[2] then
        local targetId = tonumber(args[1])
        local amount = tonumber(args[2])
        -- Your logic here
    end
end, false)
```

Usage: `/pay 2 1000`

---

## ❓ FAQ

**Q: Can I create custom jobs?**
A: Yes! Edit `config/config.lua` and add to `Config.Jobs.Jobs`

**Q: How do I add more items?**
A: Add to `Config.Inventory.Items` in config.lua

**Q: Can players have multiple vehicles?**
A: Yes! Limit is 10 per player by default (configurable)

**Q: How do I change salaries?**
A: Edit job grades in `Config.Jobs.Jobs` in config.lua

**Q: Are commands case-sensitive?**
A: No, commands work in any case (/SETJOB, /setjob, /SetJob)

**Q: Can I disable a system?**
A: Yes, remove the resource line from fxmanifest.lua

---

## 📝 Notes

- Commands are executed from server console or in-game chat
- Some commands are restricted to admins only
- Player IDs are numeric and visible in player list
- Use `/players` to see list of players in server
- Maximum 128 players supported by default
- Salaries paid every 60 seconds
- Jobs are cleared when player disconnects

---

**Last Updated**: March 2026
**Version**: 1.0.0
**Status**: Complete ✅
