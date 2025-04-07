Flash Garage ESX
Descrizione
Flash Garage è un sistema avanzato di gestione garage per FiveM basato su ESX Legacy. Questo script offre un'interfaccia utente moderna e reattiva per gestire i veicoli dei giocatori, con supporto per garage personali , e integrazione con vari sistemi di carburante.

Caratteristiche Principali
Interfaccia NUI moderna: Design elegante e reattivo con animazioni fluide
Supporto per garage multipli: Configurazione semplice per aggiungere nuovi garage in tutta la mappa
Visualizzazione 3D dei veicoli: Anteprima del veicolo prima di ritirarlo
Informazioni dettagliate: Visualizza stato del motore, carrozzeria, carburante e modifiche
Integrazione con sistemi di carburante: Supporto automatico per LegacyFuel, ox_fuel, ps-fuel e altri
Supporto per NPC o marker: Flessibilità nella configurazione dei punti di interazione
Sistema di ricerca: Trova rapidamente i tuoi veicoli con la funzione di ricerca
Comandi utili: Localizza i tuoi veicoli e visualizza informazioni dettagliate
Dipendenze
ESX Legacy: Framework principale (https://github.com/esx-framework/esx-legacy)
MySQL-Async: Per la gestione del database
Font Awesome: Per le icone nell'interfaccia
Sistemi di carburante supportati
Sistema nativo di GTA
LegacyFuel
ox_fuel
ps-fuel
Facilmente estendibile per altri sistemi
Installazione
Assicurati di avere ESX Legacy installato e funzionante
Importa la tabella SQL nel tuo database
Aggiungi ensure Flash_garage al tuo server.cfg
Configura il file config.lua secondo le tue esigenze
Struttura del Database
La risorsa utilizza la tabella owned_vehicles con i seguenti campi:

id: Identificatore unico auto-incrementale
owner: Identificatore del proprietario
plate: Targa del veicolo
vehicle: Proprietà del veicolo in formato JSON
type: Tipo di veicolo
job: Lavoro associato al veicolo
stored: Indica se il veicolo è immagazzinato
garage: Nome del garage in cui è parcheggiato
pound: Indica se il veicolo è sequestrato
vehiclename: Nome del veicolo

Il file config.lua permette di personalizzare:

Posizioni dei garage
Sistema di carburante da utilizzare
Nomi personalizzati dei veicoli
Utilizzo di NPC o marker
Distanze di interazione
E molto altro
Crediti
Sviluppato da Flash per la community di FiveM.

## Screenshot

![Menu principale del garage](https://i.ibb.co/1tRx93gj/Screenshot-26.png)


Supporto
Per supporto o segnalazione di bug, apri una issue su GitHub.

Tags
#fivem #esx #garage #vehicles #nui #interface #esx-legacy #fivem-script #fivem-resource #fivem-garage #esx-garage #vehicle-management #fivem-vehicles #fivem-cars #gta5 #gtav #roleplay #rp-server #fivem-development #esx-framework #fivem-ui #nui-interface #fivem-nui #vehicle-system #car-management #fivem-resource-development #esx-script #fivem-server #fivem-roleplay #gta-roleplay

Funzionalità Avanzate
Sistema di Marker Personalizzabile con gridsystem