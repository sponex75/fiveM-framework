// FiveM Framework UI Application

class FrameworkUI {
    constructor() {
        this.isOpen = false;
        this.currentMenu = null;
        this.notifications = [];
        
        this.initializeEventListeners();
        this.setupNUI();
    }

    // Initialize all event listeners
    initializeEventListeners() {
        // Close buttons
        document.querySelectorAll('.close-btn').forEach(btn => {
            btn.addEventListener('click', () => this.closeMenu());
        });

        // Menu buttons
        document.querySelectorAll('.menu-button').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const action = e.target.getAttribute('data-action');
                this.openSubMenu(action);
            });
        });

        // Action buttons
        document.querySelectorAll('.action-button').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const action = e.target.getAttribute('data-action');
                this.handleAction(action);
            });
        });

        // ESC key closes menu
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.closeMenu();
            }
        });
    }

    // Setup NUI messaging
    setupNUI() {
        window.addEventListener('message', (event) => {
            const data = event.data;

            switch (data.action) {
                case 'notify':
                    this.addNotification(data.title, data.message, data.type, data.duration);
                    break;
                case 'openMenu':
                    this.openMenu(data.menu, data.data);
                    break;
                case 'closeMenu':
                    this.closeMenu();
                    break;
                case 'updateInventory':
                    this.updateInventory(data.inventory);
                    break;
                case 'updateJob':
                    this.updateJobInfo(data.job);
                    break;
                case 'updateBank':
                    this.updateBankInfo(data.bank);
                    break;
                case 'updateCharacter':
                    this.updateCharacterInfo(data.character);
                    break;
            }
        });
    }

    // Add notification
    addNotification(title, message, type = 'info', duration = 3000) {
        const container = document.getElementById('notifications');
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = `
            <div class="notification-title">${title}</div>
            <div class="notification-message">${message}</div>
        `;

        container.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideIn 0.3s ease-out reverse';
            setTimeout(() => notification.remove(), 300);
        }, duration);
    }

    // Open menu
    openMenu(menuName, data = {}) {
        const menu = document.getElementById(menuName);
        if (menu) {
            menu.classList.remove('hidden');
            this.currentMenu = menuName;
            this.isOpen = true;

            // Update menu content
            this.updateMenuContent(menuName, data);
        }
    }

    // Close menu
    closeMenu() {
        if (this.currentMenu) {
            const menu = document.getElementById(this.currentMenu);
            if (menu) {
                menu.classList.add('hidden');
            }
        }
        this.currentMenu = null;
        this.isOpen = false;

        // Send close event to server
        this.sendNUICallback('menuCallback', { action: 'closeMenu' });
    }

    // Open submenu
    openSubMenu(action) {
        const menuMap = {
            'inventory': 'inventoryMenu',
            'job': 'jobMenu',
            'bank': 'bankMenu',
            'character': 'characterMenu',
            'vehicles': 'vehiclesMenu',
            'police': 'policeMenu'
        };

        if (menuMap[action]) {
            this.openMenu(menuMap[action]);
        }
    }

    // Update menu content
    updateMenuContent(menuName, data) {
        switch (menuName) {
            case 'inventoryMenu':
                this.renderInventory(data);
                break;
            case 'jobMenu':
                this.renderJobInfo(data);
                break;
            case 'bankMenu':
                this.renderBankInfo(data);
                break;
            case 'characterMenu':
                this.renderCharacterInfo(data);
                break;
            case 'vehiclesMenu':
                this.renderVehiclesList(data);
                break;
            case 'policeMenu':
                this.renderPoliceInfo(data);
                break;
            case 'npcDialog':
                this.renderNPCDialog(data);
                break;
        }
    }

    // Render inventory
    renderInventory(inventory) {
        const slotsContainer = document.getElementById('inventorySlots');
        slotsContainer.innerHTML = '';

        if (inventory.slots) {
            inventory.slots.forEach((slot, index) => {
                const slotEl = document.createElement('div');
                slotEl.className = 'inventory-slot';
                slotEl.innerHTML = `
                    <div class="inventory-slot-item">${slot.label || slot.name}</div>
                    <div class="inventory-slot-quantity">x${slot.quantity}</div>
                `;
                slotsContainer.appendChild(slotEl);
            });
        }

        // Add empty slots
        const totalSlots = inventory.maxSlots || 50;
        for (let i = (inventory.slots ? inventory.slots.length : 0); i < totalSlots; i++) {
            const emptySlot = document.createElement('div');
            emptySlot.className = 'inventory-slot empty';
            slotsContainer.appendChild(emptySlot);
        }

        // Update weight
        document.getElementById('inventoryWeight').textContent = inventory.totalWeight || 0;
        document.getElementById('inventoryMaxWeight').textContent = inventory.maxWeight || 1000;
    }

    // Render job info
    renderJobInfo(job) {
        const jobInfo = document.getElementById('jobInfo');
        if (job && job.name) {
            jobInfo.innerHTML = `
                <p><strong>Job:</strong> ${job.label}</p>
                <p><strong>Grade:</strong> ${job.gradeLabel}</p>
                <p><strong>Salary:</strong> $${job.salary}</p>
            `;
        } else {
            jobInfo.innerHTML = '<p>No job assigned</p>';
        }
    }

    // Render bank info
    renderBankInfo(bank) {
        document.getElementById('bankBalance').textContent = (bank && bank.balance) || 0;

        if (bank && bank.transactions) {
            const history = document.getElementById('transactionHistory');
            history.innerHTML = '';
            bank.transactions.slice(-5).reverse().forEach(trans => {
                const item = document.createElement('div');
                item.className = 'transaction-item';
                item.innerHTML = `
                    <strong>${trans.type}</strong>: 
                    <span style="color: ${trans.type.includes('OUT') ? '#ff0000' : '#00ff00'}">
                        $${trans.amount}
                    </span>
                    <br>
                    <small>${trans.timestamp}</small>
                `;
                history.appendChild(item);
            });
        }
    }

    // Render character info
    renderCharacterInfo(character) {
        const charInfo = document.getElementById('characterInfo');
        if (character && character.firstName) {
            charInfo.innerHTML = `
                <p><strong>Name:</strong> ${character.firstName} ${character.lastName}</p>
                <p><strong>Level:</strong> ${character.level || 1}</p>
                <p><strong>Experience:</strong> ${character.experience || 0}</p>
                <p><strong>Created:</strong> ${character.createdAt}</p>
            `;
        } else {
            charInfo.innerHTML = '<p>No character loaded</p>';
        }
    }

    // Render vehicles list
    renderVehiclesList(vehicles) {
        const listContainer = document.getElementById('vehiclesList') || document.getElementById('garageVehicles');
        if (!listContainer) return;

        listContainer.innerHTML = '';

        if (vehicles && vehicles.length > 0) {
            vehicles.forEach(vehicle => {
                const item = document.createElement('div');
                item.className = 'vehicle-item';
                item.innerHTML = `
                    <div class="vehicle-info">
                        <h4>${vehicle.model}</h4>
                        <div class="vehicle-plate">${vehicle.plate}</div>
                        <div class="health-bar">
                            <div class="health-fill" style="width: ${(vehicle.engineHealth / 1000) * 100}%"></div>
                        </div>
                    </div>
                    <div class="vehicle-actions">
                        <button class="vehicle-btn" onclick="sendNUICallback('spawn', {id: '${vehicle.id}'})">Spawn</button>
                        <button class="vehicle-btn" onclick="sendNUICallback('delete', {id: '${vehicle.id}'})">Delete</button>
                    </div>
                `;
                listContainer.appendChild(item);
            });
        } else {
            listContainer.innerHTML = '<p>No vehicles in garage</p>';
        }
    }

    // Render police info
    renderPoliceInfo(police) {
        document.getElementById('wantedLevel').textContent = (police && police.wanted) || 0;
    }

    // Render NPC dialog
    renderNPCDialog(data) {
        document.getElementById('npcName').textContent = data.npcName || 'NPC';
        const dialoguesList = document.getElementById('dialoguesList');
        dialoguesList.innerHTML = '';

        if (data.dialogues && data.dialogues.length > 0) {
            data.dialogues.forEach((dialogue, index) => {
                const button = document.createElement('button');
                button.className = 'dialogue-button';
                button.textContent = dialogue.text;
                button.onclick = () => {
                    this.sendNUICallback('npcDialogue', { index: index });
                };
                dialoguesList.appendChild(button);
            });
        }
    }

    // Handle actions
    handleAction(action) {
        switch (action) {
            case 'deposit':
                this.handleDeposit();
                break;
            case 'withdraw':
                this.handleWithdraw();
                break;
            case 'clockin':
                this.sendToServer('jobs:clockIn');
                break;
            case 'clockout':
                this.sendToServer('jobs:clockOut');
                break;
        }
    }

    // Handle deposit
    handleDeposit() {
        const amount = prompt('Enter amount to deposit:');
        if (amount) {
            this.sendToServer('banking:deposit', parseInt(amount));
        }
    }

    // Handle withdraw
    handleWithdraw() {
        const amount = prompt('Enter amount to withdraw:');
        if (amount) {
            this.sendToServer('banking:withdraw', parseInt(amount));
        }
    }

    // Send NUI callback
    sendNUICallback(type, data) {
        fetch(`https://${GetParentResourceName()}/menuCallback`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                type: type,
                data: data
            })
        }).then(response => response.json()).catch(error => console.error('Error:', error));
    }

    // Send to server
    sendToServer(event, data) {
        this.sendNUICallback(event, data || {});
    }
}

// Initialize
const ui = new FrameworkUI();

// Helper function - Get parent resource name (for development)
function GetParentResourceName() {
    return 'fiveM-framework';
}
