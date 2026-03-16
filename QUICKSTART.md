# Quick Start Guide

## Installation (5 minutes)

### Step 1: Add to FiveM Resources
```bash
# Copy the framework to your FiveM resources folder
cp -r fiveM-framework C:\Path\To\Your\FiveM\resources\
```

### Step 2: Update server.cfg
```
# Add this line to your server.cfg
ensure fiveM-framework
```

### Step 3: Restart Server
```
# In server console
restart all
```

## First Steps

### 1. Create a Character
```
/newchar John Doe
/selectchar
```

### 2. Get a Job
```
/setjob <your_id> police 1
```

### 3. Spawn a Vehicle
```
/spawnvehicle police
```

### 4. Add Money
```
/additem <your_id> money 5000
```

### 5. Open Menus
- **Inventory**: `/inventory`
- **Job Info**: `/jobinfo`
- **Bank**: `/balance`
- **Garage**: `/garage`

## Basic Customization

### Change Starting Money
Edit `config/config.lua`:
```lua
Config.Banking.StartingBalance = 10000  -- Changed from 5000
```

### Add a New Job
Edit `config/config.lua`:
```lua
mechanic = {
    label = "Mechanic",
    grade = {
        [1] = {label = "Apprentice", salary = 150},
        [2] = {label = "Master Mechanic", salary = 300},
    }
}
```

### Customize UI Colors
Edit `resources/ui/html/css/style.css`:
```css
/* Change primary color from cyan to green */
border-color: #00ff00;  /* Green */
color: #00ff00;
```

## For Developers

### Add a Custom Command

In `resources\base\server.lua`:
```lua
RegisterCommand("hello", function(source, args, rawCommand)
    TriggerClientEvent("framework:notify", source, {
        title = "Hello",
        message = "Hello, " .. (args[1] or "friend") .. "!",
        type = "info"
    })
end, false)
```

### Trigger Server Event

In any client script:
```lua
TriggerServerEvent("eventName", arg1, arg2)
```

### Create an NPC

```lua
TriggerServerEvent("npcs:create", {
    model = "a_m_m_business_1",
    x = 100.0, y = 200.0, z = 30.0,
    name = "Shop Owner",
    dialogues = {
        {text = "Welcome!", action = "shop_open"}
    }
})
```

## Common Fixes

### Problem: Inventory not showing items
**Solution**: Restart the script or rejoin server after command execution

### Problem: UI menu won't close
**Solution**: Press ESC key or click close button (✕)

### Problem: Wanted level not updating
**Solution**: Ensure player has loaded properly with `/wantedlevel <id> <level>`

## Next Steps

1. ✅ Framework installed and running
2. 📖 Read full [README.md](README.md) for all features
3. 🔧 Customize config for your server
4. 💾 Set up database (oxmysql) for persistence
5. 📝 Create custom jobs and items
6. 🎨 Theme the UI to match your server

## Command Cheat Sheet

| Command | Usage | Example |
|---------|-------|---------|
| `/setjob` | Assign job | `/setjob 1 police 2` |
| `/spawnvehicle` | Spawn vehicle | `/spawnvehicle police` |
| `/additem` | Add item | `/additem 1 money 5000` |
| `/arrest` | Arrest player | `/arrest 2 robbing` |
| `/createnpc` | Create NPC | `/createnpc a_m_m_business_1 100 200 30` |
| `/balance` | Check balance | `/balance` |
| `/jobs` | List jobs | `/jobs` |

## Need Help?

- Check the [README.md](README.md) for full documentation
- Review `config/config.lua` for configuration options
- Check server console for error messages
- Each Lua file has detailed comments explaining functions

---

**Welcome to FiveM Framework! Happy coding! 🚀**
