// Variabili globali
let currentVehicles = [];
let selectedVehicleIndex = 0;
let currentGarage = "";

// Funzione per inizializzare l'interfaccia
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.type === 'open') {
        // Salva i dati ricevuti
        currentVehicles = data.vehicles || [];
        currentGarage = data.garage || "Garage";
        
        // Aggiorna l'interfaccia
        const garageNameElement = document.getElementById('garage-name');
        if (garageNameElement) {
            garageNameElement.textContent = currentGarage;
        }
        
        // Popola la lista dei veicoli
        populateVehicleList();
        
        // Seleziona il primo veicolo se disponibile
        if (currentVehicles.length > 0) {
            // Riabilita i pulsanti di navigazione se ci sono veicoli
            document.getElementById('prev-vehicle').disabled = false;
            document.getElementById('next-vehicle').disabled = false;
            document.getElementById('take-vehicle').disabled = false;
            
            selectVehicle(0);
        } else {
            // Mostra messaggio "nessun veicolo"
            const vehiclesList = document.getElementById('vehicles-list');
            if (vehiclesList) {
                vehiclesList.innerHTML = `
                    <div class="empty-message">
                        <i class="fas fa-car-crash"></i>
                        <p>Nessun veicolo disponibile in questo garage</p>
                    </div>
                `;
            }
            
            const vehicleDetails = document.getElementById('vehicle-details');
            if (vehicleDetails) {
                vehicleDetails.classList.add('hidden');
            }
            
            // Disabilita i pulsanti di navigazione e ritiro
            document.getElementById('prev-vehicle').disabled = true;
            document.getElementById('next-vehicle').disabled = true;
            document.getElementById('take-vehicle').disabled = true;
        }
        
        // Mostra l'interfaccia
        document.body.style.display = 'block';
    } else if (data.type === 'close') {
        // Nascondi l'interfaccia
        document.body.style.display = 'none';
        
        // Resetta i dati
        currentVehicles = [];
        selectedVehicleIndex = 0;
    }
});

// Funzione per popolare la lista dei veicoli
function populateVehicleList() {
    const vehiclesList = document.getElementById('vehicles-list');
    if (!vehiclesList) return;
    
    vehiclesList.innerHTML = '';
    
    currentVehicles.forEach((vehicle, index) => {
        const vehicleItem = document.createElement('div');
        vehicleItem.className = 'vehicle-item';
        vehicleItem.dataset.index = index;
        
        if (index === selectedVehicleIndex) {
            vehicleItem.classList.add('selected');
        }
        
        let badgesHTML = '';
        if (vehicle.pound) {
            badgesHTML += '<span class="badge sequestrato">Sequestrato</span>';
        }
        if (vehicle.isFaction) {
            badgesHTML += '<span class="badge fazione">Fazione</span>';
        }
        
        // Usa vehicle.label invece di getVehicleDisplayName
        vehicleItem.innerHTML = `
            <div class="vehicle-name">${vehicle.label || "Veicolo sconosciuto"}</div>
            <div class="vehicle-plate">${vehicle.plate}</div>
            <div class="vehicle-badges">${badgesHTML}</div>
        `;
        
        vehicleItem.addEventListener('click', () => {
            selectVehicle(index);
        });
        
        vehiclesList.appendChild(vehicleItem);
    });
}

// Funzione per selezionare un veicolo
function selectVehicle(index) {
    if (index < 0 || index >= currentVehicles.length) return;
    
    // Aggiorna l'indice selezionato
    selectedVehicleIndex = index;
    
    // Aggiorna la classe selezionata nella lista
    const vehicleItems = document.querySelectorAll('.vehicle-item');
    vehicleItems.forEach(item => {
        item.classList.remove('selected');
        if (parseInt(item.dataset.index) === selectedVehicleIndex) {
            item.classList.add('selected');
            // Assicurati che l'elemento sia visibile nella lista
            item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    });
    
    // Ottieni il veicolo selezionato
    const vehicle = currentVehicles[selectedVehicleIndex];
    
    // Assicurati che i pulsanti di navigazione siano abilitati se ci sono veicoli
    if (currentVehicles.length > 0) {
        document.getElementById('prev-vehicle').disabled = false;
        document.getElementById('next-vehicle').disabled = false;
        
        // Il pulsante di ritiro è disabilitato solo se il veicolo è sequestrato
        document.getElementById('take-vehicle').disabled = vehicle.pound;
    }
    
    // Aggiorna i dettagli del veicolo
    updateVehicleDetails(vehicle);
    
    // Invia un messaggio al client per cambiare il veicolo visualizzato
    fetch(`https://${GetParentResourceName()}/changeVehicle`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            vehicleProps: vehicle.props
        })
    });
}

// Funzione per aggiornare i dettagli del veicolo
function updateVehicleDetails(vehicle) {
    const vehicleDetails = document.getElementById('vehicle-details');
    if (!vehicleDetails) return;
    
    // Mostra i dettagli
    vehicleDetails.classList.remove('hidden');
    
    // Aggiorna nome e targa
    // Usa il nome del veicolo fornito dal server invece di chiamare getVehicleDisplayName
    document.getElementById('vehicle-name').textContent = vehicle.label || "Veicolo sconosciuto";
    document.getElementById('vehicle-plate').textContent = vehicle.plate;
    
    // Aggiorna badge
    const sequestratoElement = document.getElementById('badge-sequestrato');
    const fazioneElement = document.getElementById('badge-fazione');
    
    if (vehicle.pound) {
        sequestratoElement.classList.remove('hidden');
    } else {
        sequestratoElement.classList.add('hidden');
    }
    
    if (vehicle.isFaction) {
        fazioneElement.classList.remove('hidden');
    } else {
        fazioneElement.classList.add('hidden');
    }
    
    // Aggiorna statistiche del veicolo
    updateVehicleStats(vehicle);
    
    // Aggiorna modifiche del veicolo
    updateVehicleMods(vehicle);
    
    // Abilita/disabilita pulsante ritiro
    const takeButton = document.getElementById('take-vehicle');
    if (takeButton) {
        if (vehicle.pound) {
            takeButton.disabled = true;
            takeButton.title = "Veicolo sequestrato";
        } else {
            takeButton.disabled = false;
            takeButton.title = "";
        }
    }
}

// Funzione per aggiornare le modifiche del veicolo
function updateVehicleMods(vehicle) {
    const props = vehicle.props;
    
    // Mappa dei livelli delle modifiche
    const modLevels = {
        0: "Stock",
        1: "Livello 1",
        2: "Livello 2",
        3: "Livello 3",
        4: "Livello 4",
        5: "Livello 5"
    };
    
    // Aggiorna motore (mod 11)
    const engineLevel = props.modEngine !== undefined ? props.modEngine + 1 : 0;
    updateModItem('mod-engine', modLevels[engineLevel], engineLevel);
    
    // Aggiorna freni (mod 12)
    const brakesLevel = props.modBrakes !== undefined ? props.modBrakes + 1 : 0;
    updateModItem('mod-brakes', modLevels[brakesLevel], brakesLevel);
    
    // Aggiorna trasmissione (mod 13)
    const transmissionLevel = props.modTransmission !== undefined ? props.modTransmission + 1 : 0;
    updateModItem('mod-transmission', modLevels[transmissionLevel], transmissionLevel);
    
    // Aggiorna sospensioni (mod 15)
    const suspensionLevel = props.modSuspension !== undefined ? props.modSuspension + 1 : 0;
    updateModItem('mod-suspension', modLevels[suspensionLevel], suspensionLevel);
    
    // Aggiorna armatura (mod 16)
    const armorLevel = props.modArmor !== undefined ? props.modArmor + 1 : 0;
    updateModItem('mod-armor', modLevels[armorLevel], armorLevel);
    
    // Aggiorna turbo (mod 18)
    const turboEnabled = props.modTurbo === true || props.modTurbo === 1;
    updateModItem('mod-turbo', turboEnabled ? "Installato" : "Non installato", turboEnabled ? 1 : 0);
}

// Funzione di supporto per aggiornare un singolo elemento di modifica
function updateModItem(id, text, level) {
    const element = document.getElementById(id);
    if (!element) return;
    
    const valueElement = element.querySelector('.mod-value');
    if (valueElement) {
        valueElement.textContent = text;
        
        // Rimuovi tutte le classi di livello
        for (let i = 0; i <= 5; i++) {
            valueElement.classList.remove(`mod-level-${i}`);
        }
        
        // Aggiungi la classe appropriata per il livello
        valueElement.classList.add(`mod-level-${level}`);
    }
}

// Funzione per aggiornare le statistiche del veicolo
function updateVehicleStats(vehicle) {
    // Carburante
    const fuelLevel = vehicle.props.fuelLevel !== undefined ? vehicle.props.fuelLevel : 100;
    const fuelPercent = Math.max(0, Math.min(100, fuelLevel));
    document.getElementById('fuel-value').textContent = `${Math.round(fuelPercent)}%`;
    document.getElementById('fuel-level').style.width = `${fuelPercent}%`;
    
    // Motore
    const engineHealth = vehicle.props.engineHealth || 1000;
    const enginePercent = Math.max(0, Math.min(100, engineHealth / 10));
    document.getElementById('engine-value').textContent = `${Math.round(enginePercent)}%`;
    document.getElementById('engine-level').style.width = `${enginePercent}%`;
    
    // Carrozzeria
    const bodyHealth = vehicle.props.bodyHealth || 1000;
    const bodyPercent = Math.max(0, Math.min(100, bodyHealth / 10));
    document.getElementById('body-value').textContent = `${Math.round(bodyPercent)}%`;
    document.getElementById('body-level').style.width = `${bodyPercent}%`;
    
    // Rimuovi o commenta queste righe per eliminare i messaggi di debug
    // console.log("Fuel Level:", fuelLevel, "Fuel Percent:", fuelPercent);
    // console.log("Engine Health:", engineHealth, "Engine Percent:", enginePercent);
    // console.log("Body Health:", bodyHealth, "Body Percent:", bodyPercent);
}

// Funzione per ottenere il nome visualizzato del veicolo
function getVehicleDisplayName(model) {
    // Qui puoi implementare la logica per ottenere il nome del veicolo dal modello
    // Per ora restituiamo un nome generico
    return model ? `Veicolo ${model}` : "Veicolo sconosciuto";
}

// Gestione della ricerca
document.getElementById('search-input').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    
    const vehicleItems = document.querySelectorAll('.vehicle-item');
    vehicleItems.forEach(item => {
        const vehicleName = item.querySelector('.vehicle-name').textContent.toLowerCase();
        const vehiclePlate = item.querySelector('.vehicle-plate').textContent.toLowerCase();
        
        if (vehicleName.includes(searchTerm) || vehiclePlate.includes(searchTerm)) {
            item.style.display = 'block';
        } else {
            item.style.display = 'none';
        }
    });
});

// Gestione dei pulsanti di navigazione
document.getElementById('prev-vehicle').addEventListener('click', function() {
    if (selectedVehicleIndex > 0) {
        selectVehicle(selectedVehicleIndex - 1);
    } else {
        // Vai all'ultimo veicolo se siamo al primo
        selectVehicle(currentVehicles.length - 1);
    }
});

document.getElementById('next-vehicle').addEventListener('click', function() {
    if (selectedVehicleIndex < currentVehicles.length - 1) {
        selectVehicle(selectedVehicleIndex + 1);
    } else {
        // Torna al primo veicolo se siamo all'ultimo
        selectVehicle(0);
    }
});

// Gestione del pulsante di ritiro veicolo
document.getElementById('take-vehicle').addEventListener('click', function() {
    if (selectedVehicleIndex >= 0 && selectedVehicleIndex < currentVehicles.length) {
        const vehicle = currentVehicles[selectedVehicleIndex];
        
        // Invia un messaggio al client per ritirare il veicolo
        fetch(`https://${GetParentResourceName()}/takeVehicle`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                plate: vehicle.plate,
                props: vehicle.props
            })
        });
        
        // Chiudi l'interfaccia
        closeUI();
    }
});

// Gestione del pulsante di chiusura
document.getElementById('close-button').addEventListener('click', function() {
    closeUI();
});

// Funzione per chiudere l'interfaccia
function closeUI() {
    // Nascondi l'interfaccia immediatamente
    document.body.style.display = 'none';
    
    // Invia la richiesta al client
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}

// Gestione dei tasti
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeUI();
    } else if (event.key === 'ArrowLeft') {
        document.getElementById('prev-vehicle').click();
    } else if (event.key === 'ArrowRight') {
        document.getElementById('next-vehicle').click();
    } else if (event.key === 'Enter') {
        const takeButton = document.getElementById('take-vehicle');
        if (takeButton && !takeButton.disabled) {
            takeButton.click();
        }
    }
});
