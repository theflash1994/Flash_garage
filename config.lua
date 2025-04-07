GarageCFG = {}

-- Impostazioni generali
GarageCFG.VehicleMenu = true -- Abilita se vuoi un menu veicolo
GarageCFG.RangeCheck = 25.0 -- Distanza massima per controllare il veicolo

-- Configurazione per il tipo di interazione con il garage
GarageCFG.UseNPC = false -- true = usa NPC, false = usa marker
GarageCFG.NPCModel = "s_m_y_valet_01" -- Modello del ped parcheggiatore (default: valet)
GarageCFG.NPCScenario = "WORLD_HUMAN_CLIPBOARD" -- Scenario/animazione per l'NPC

-- Distanza di interazione con NPC o marker
GarageCFG.InteractionDistance = 3.0

-- Configurazione per il sistema di interazione
GarageCFG.InteractionSystem = "text3d" -- Opzioni: "text3d", "ox_target"

GarageCFG.MarkerSystem = "default" -- Opzioni: "default", "gridsystem"

-- Aggiungi queste configurazioni per i marker standard
GarageCFG.DefaultMarker = {
    type = 36,                -- Tipo di marker (36 = cerchio con auto)
    size = vector3(1.0, 1.0, 1.0), -- Dimensione del marker
    color = {r = 0, g = 150, b = 255, a = 200}, -- Colore del marker (azzurro semi-trasparente)
    bobUpAndDown = false,     -- Se il marker deve muoversi su e giù
    faceCamera = true,        -- Se il marker deve orientarsi verso la camera
    rotate = true,            -- Se il marker deve ruotare
    drawDistance = 10.0,      -- Distanza di visualizzazione
    interactionDistance = 2.0 -- Distanza di interazione
}


-- Lista dei nomi personalizzati dei veicoli
GarageCFG.nomiveicoli = {
    ["lwgtr"] = "Nissan GT-R",
    ["xadv"] = "X-ADV",
    ["mansm2"] = "BMW M2",
    ["rmod240sx"] = "240SX",
    ["nh2r"] = "Ninja",
    ["nqsrt"] = "Charger SRT",
    ["mansgt"] = "McLaren",
    ["tmaxdx"] = "TmaX",
    ["mansm8"] = "BMW M8",
    ["mansurus"] = "Urus",
    ["mansgtr50"] = "GT-R50",
    ["dtdmansq60"] = "Infinity Q60",
    ["mansamgt21"] = "AMG GT",
    ["mansaug992"] = "Porche 911",
    ["mansroma"] = "Ferrari Roma",
    ["manssf90"] = "Ferrari SF90"
}

-- Configurazione dei garage disponibili
GarageCFG.Garages = {

    ["A"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(215.58, -809.73, 30.74),
                --["heading"] = 248.84 -- Aggiungi l'heading per l'NPC
            },
            ["vehicle"] = {
                ["position"] = vector3(232.6, -795.24, 30.5),
                ["heading"] = 160.84
            }
        }
    },

    ["B"] = { 
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(870.4, -13.06, 78.76)
            },
            ["vehicle"] = {
                ["position"] = vector3(869.08, -25.54, 78.76), 
                ["heading"] = 324.66
            }
        }
    },
    
    ["C"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(708.65, -1105.82, 23.22)
            },
            ["vehicle"] = {
                ["position"] = vector3(700.28, -1107.91, 22.47), 
                ["heading"] = 338.96
            }
        },
    },

    ["D"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-3153.04, 1056.71, 20.82)
            },
            ["vehicle"] = {
                ["position"] = vector3(-3143.79, 1060.03, 20.50), 
                ["heading"] = 320.0
            }
        },
    },

    ["F"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-152.47, -1313.88, 32.3)
            },
            ["vehicle"] = {
                ["position"] = vector3(-163.4, -1306.06, 31.34), 
                ["heading"] = 94.43
            }
        },
    },

    ["G"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1293.45, 272.45, 64.34)
            },
            ["vehicle"] = {
                ["position"] = vector3(-1299.75, 270.24, 63.82), 
                ["heading"] = 329.1
            }
        },
    },	

    ["H"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-777.05, -1323.27, 5.15)
            },
            ["vehicle"] = {
                ["position"] = vector3(-801.53, -1308.02, 5.0), 
                ["heading"] = 232.0
            }
        },
    },
	
    ["I"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(797.76, -2988.56, 6.02)
            },
            ["vehicle"] = {
                ["position"] = vector3(779.97, -2972.75, 5.8), 
                ["heading"] = 232.0
            }
        },
    },
    
    ["K"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(161.72, -1306.95, 29.35)
            },
            ["vehicle"] = {
                ["position"] = vector3(165.22, -1283.45, 29.3), 
                ["heading"] = 232.0
            }
        },
    },

    ["L"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1737.87, 3709.1, 34.13)
            },
            ["vehicle"] = {
                ["position"] = vector3(1728.06, 3708.77, 34.19), 
                ["heading"] = 232.0
            }
        },
    },

    ["M"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(122.92, 6629.35, 31.91)
            },
            ["vehicle"] = {
                ["position"] = vector3(129.75, 6621.79, 31.77), 
                ["heading"] = 48.0
            }
        },
    },


    ["N"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(963.25, -1019.89, 40.85)
            },
            ["vehicle"] = {
                ["position"] = vector3(974.78, -1020.29, 41.05), 
                ["heading"] = 48.0
            }
        },
    },

	["O"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(441.06, 271.65, 103.18)
            },
            ["vehicle"] = {
                ["position"] = vector3(437.5, 255.67, 103.21), 
                ["heading"] = 48.0
            }
        },
    },

    ["P"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-808.82690429688, -749.09844970703, 23.106824874878)
            },
            ["vehicle"] = {
                ["position"] = vector3(-811.94610595703, -753.31787109375, 22.687032699585), 
                ["heading"] = 130.0
            }
        },
    },

    ["Q"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-395.99447631836, 205.29391479492, 83.582763671875)
            },
            ["vehicle"] = {
                ["position"] = vector3(-401.84576416016, 207.5599822998, 83.244667053223), 
                ["heading"] = 335.00
            }
        },
    },

    ["Bellevue"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-3051.764, 111.6321, 11.608095)
            },
            ["vehicle"] = {
                ["position"] = vector3(-3045.834, 119.33327, 11.603512), 
                ["heading"] = 226.08
            }
        },
    },

    ["L"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-27.26, -1661.56, 29.48)
            },
            ["vehicle"] = {
                ["position"] = vector3(-21.14, -1646.4, 29.48), 
                ["heading"] = 48.0
            }
        },
    },
    
    ["Barche A"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-780.08, -1496.69, 1.72)
            },
            ["vehicle"] = {
                ["position"] = vector3(-800.4, -1505.34, 1), 
                ["heading"] = 103.19
            }
        },
    },	
	
    ["U"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-449.68, 6042.17, 31.49)
            },
            ["vehicle"] = {
                ["position"] = vector3(-445.4, 6048.6, 31.34), 
                ["heading"] = 48.0
            }
        },
    },

    ["Z"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-796.28, 336.24, 86.0)
            },
            ["vehicle"] = {
                ["position"] = vector3(-791.77, 333.13, 85.7), 
                ["heading"] = 177.18
            }
        },
    },
	
    ["AB"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-474.28, -629.63, 31.32)
            },
            ["vehicle"] = {
                ["position"] = vector3(-484.62, -599.41, 31.17), 
                ["heading"] = 48.0
            }
        },
    },	


    ["AC"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-561.71, 321.69, 84.40)
            },
            ["vehicle"] = {
                ["position"] = vector3(-580.40, 316.51, 84.77), 
                ["heading"] = 48.0
            }
        },
    },

    ["AD"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1210.96, 1858.0, 78.91)
            },
            ["vehicle"] = {
                ["position"] = vector3(1210.58, 1868.91, 78.91), 
                ["heading"] = 137.31
            }
        },
    },

    ["AH"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1198.0544, 2663.2231, 37.81406)
            },
            ["vehicle"] = {
                ["position"] = vector3(1210.6594, 2665.6809, 37.809741), 
                ["heading"] = 0.32
            }
        },
    },

    ["JP - (Privato)"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(195.0, 1243.15, 225.46)
            },
            ["vehicle"] = {
                ["position"] = vector3(201.22, 1238.09, 225.46), 
                ["heading"] = 182.32
            }
        },
    },

    ["Barche B"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-3426.65, 953.77, 8.35)
            },
            ["vehicle"] = {
                ["position"] = vector3(-3426.65, 946.77, 1.00), 
                ["heading"] = 320.0
            }
        },
    },

    ["Elicotteri A"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1100.13, -2881.79, 13.95)
            },
            ["vehicle"] = {
                ["position"] = vector3(-1112.27, -2883.7, 13.95), 
                ["heading"] = 148.5
            }
        },
    },

    ["Car Zone"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-537.13696289063, -886.84680175781, 25.187515258789)
            },
            ["vehicle"] = {
                ["position"] = vector3(-548.9357, -895.4522, 24.546291), 
                ["heading"] = 180.0
            }
        },
    },

    ["LSC529"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-359.15759277344, -130.31709289551, 38.75705581665)
            },
            ["vehicle"] = {
                ["position"] = vector3(-365.43853759766, -121.82320404053, 38.757540283203), 
                ["heading"] = 270.0
            }
        },
        ["camera"] = { 
            ["x"] = -362.438, 
            ["y"] = -121.823, 
            ["z"] = 40.69, 
            ["rotationX"] = -30.0, 
            ["rotationY"] = 10.0, 
            ["rotationZ"] = 60.0
        }
    },

    ["Arm60"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(843.88250732422, -2118.2893066406, 30.521062850952)
            },
            ["vehicle"] = {
                ["position"] = vector3(835.55505371094, -2120.6638183594, 29.499687194824), 
                ["heading"] = 220.0
            }
        },
    },    

    ["Chicha"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-429.13195800781, -44.081398010254, 46.227855682373)
            },
            ["vehicle"] = {
                ["position"] = vector3(-421.50479125977, -34.585968017578, 46.822133636475), 
                ["heading"] = 220.0
            }
        },
    }, 

    ["890"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-773.84918212891, 869.28204345703, 203.41395568848)
            },
            ["vehicle"] = {
                ["position"] = vector3(-782.29925537109, 871.88983154297, 203.4703338623), 
                ["heading"] = 180.0
            }
        },
    }, 

    ["39"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(144.19528198242, -3004.0051269531, 7.0309209823608)
            },
            ["vehicle"] = {
                ["position"] = vector3(143.76824951172, -2995.564453125, 7.2311303138733), 
                ["heading"] = 90.0
            }
        },
    }, 

    ["CatCafe"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-602.345703125, -1068.5550537109, 22.32306098938)
            },
            ["vehicle"] = {
                ["position"] = vector3(-616.56353759766, -1083.1101074219, 22.378750991821), 
                ["heading"] = 90.0
            }
        },
    },

    ["385"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-314.34234619141, -1513.2069091797, 27.803970336914)
            },
            ["vehicle"] = {
                ["position"] = vector3(-319.50283813477, -1517.025390625, 27.556131362915), 
                ["heading"] = 178.18687438964844
            }
        },
    },
    
    ["2027"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(3335.8100585938, 5165.2338867188, 18.32671546936)
            },
            ["vehicle"] = {
                ["position"] = vector3(3332.4035644531, 5158.001953125, 18.301723480225), 
                ["heading"] = 154.18783569335938
            }
        },
    },

    ["Conc"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-758.7956, -1031.393, 13.07031)
            },
            ["vehicle"] = {
                ["position"] = vector3(-740.2813, -1045.53, 12.36267), 
                ["heading"] = 240.9449
            }
        },
    },

    ["Import"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1199.736, -3234.752, 6.010254)
            },
            ["vehicle"] = {
                ["position"] = vector3(1201.78, -3230.268, 5.942871), 
                ["heading"] = 340.1575
            }
        },
    },

    ["Mirror"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1322.494, -1083.01, 6.9489855)
            },
            ["vehicle"] = {
                ["position"] = vector3(-1326.684, -1077.141, 6.948985), 
                ["heading"] = 295.84
            }
        },
    },

    ["307"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1185.329, -1507.511, 4.379673)
            },
            ["vehicle"] = {
                ["position"] = vector3(-1188.928, -1497.505, 4.3796715), 
                ["heading"] = 211.84
            }
        },
    },

    ["139"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(265.99017, -2057.199, 17.456033)
            },
            ["vehicle"] = {
                ["position"] = vector3(279.49829, -2082.129, 16.700328), 
                ["heading"] = 135.84
            }
        },
    },

    ["177"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1166.384, -1318.954, 34.742763)
            },
            ["vehicle"] = {
                ["position"] = vector3(1152.6893, -1327.605, 34.696582), 
                ["heading"] = 263.84
            }
        },
    },

    ["Rimozione Forzata"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(485.45007, -1286.595, 29.535816)
            },
            ["vehicle"] = {
                ["position"] = vector3(476.85717, -1280.151, 29.53935),
                ["heading"] = 0.84
            }
        },
    },

    ["Popolari"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1328.597, -935.0715, 11.352455)
            },
            ["vehicle"] = {
                ["position"] = vector3(-1316.864, -911.4888, 11.309354),
                ["heading"] = 200.84
            }
        },
    },
}


-- Aggiungi questa sezione alla fine del file config.lua
GarageCFG.FuelSystem = {
    -- Impostazione predefinita: usa il sistema nativo di GTA
    default = "native",
    
    -- Supporto per diversi sistemi di carburante
    systems = {
        ["native"] = {
            -- Funzione per ottenere il livello del carburante (sistema nativo)
            getFuel = function(vehicle)
                return GetVehicleFuelLevel(vehicle)
            end,
            -- Funzione per impostare il livello del carburante (sistema nativo)
            setFuel = function(vehicle, level)
                SetVehicleFuelLevel(vehicle, level)
            end,
            -- Scala del carburante (min, max)
            scale = {0, 100}
        },
        
        ["LegacyFuel"] = {
            -- Funzione per ottenere il livello del carburante (LegacyFuel)
            getFuel = function(vehicle)
                return exports['LegacyFuel']:GetFuel(vehicle)
            end,
            -- Funzione per impostare il livello del carburante (LegacyFuel)
            setFuel = function(vehicle, level)
                exports['LegacyFuel']:SetFuel(vehicle, level)
            end,
            -- Scala del carburante (min, max)
            scale = {0, 100}
        },
        
        ["esx_fuel"] = {
            -- Funzione per ottenere il livello del carburante (esx_fuel)
            getFuel = function(vehicle)
                return exports['esx_fuel']:GetFuel(vehicle)
            end,
            -- Funzione per impostare il livello del carburante (esx_fuel)
            setFuel = function(vehicle, level)
                exports['esx_fuel']:SetFuel(vehicle, level)
            end,
            -- Scala del carburante (min, max)
            scale = {0, 100}
        },
        
        ["ox_fuel"] = {
            -- Funzione per ottenere il livello del carburante (ox_fuel)
            getFuel = function(vehicle)
                return exports['ox_fuel']:GetFuel(vehicle)
            end,
            -- Funzione per impostare il livello del carburante (ox_fuel)
            setFuel = function(vehicle, level)
                exports['ox_fuel']:SetFuel(vehicle, level)
            end,
            -- Scala del carburante (min, max)
            scale = {0, 100}
        },
        
        ["ps-fuel"] = {
            -- Funzione per ottenere il livello del carburante (ps-fuel)
            getFuel = function(vehicle)
                return exports['ps-fuel']:GetFuel(vehicle)
            end,
            -- Funzione per impostare il livello del carburante (ps-fuel)
            setFuel = function(vehicle, level)
                exports['ps-fuel']:SetFuel(vehicle, level)
            end,
            -- Scala del carburante (min, max)
            scale = {0, 100}
        }
        
        -- Puoi aggiungere altri sistemi di carburante qui
    }
}

-- Funzione per rilevare automaticamente il sistema di carburante
GarageCFG.DetectFuelSystem = function()
    local systems = {
        "LegacyFuel",
        "esx_fuel",
        "ox_fuel",
        "ps-fuel"
        -- Aggiungi altri sistemi di carburante qui
    }
    
    for _, system in ipairs(systems) do
        if GetResourceState(system) == 'started' then
            print("^2[Flash_garage] Rilevato sistema di carburante: " .. system .. "^7")
            return system
        end
    end
    
    print("^3[Flash_garage] Nessun sistema di carburante rilevato, utilizzo del sistema nativo^7")
    return "native"
end

-- Imposta il sistema di carburante attivo
GarageCFG.ActiveFuelSystem = GarageCFG.DetectFuelSystem()

-- Funzioni di utilità per il carburante
GarageCFG.GetFuel = function(vehicle)
    local system = GarageCFG.FuelSystem.systems[GarageCFG.ActiveFuelSystem]
    if system then
        local success, result = pcall(system.getFuel, vehicle)
        if success then
            return result
        else
            print("^1[Flash_garage] Errore nel recupero del carburante: " .. tostring(result) .. "^7")
            return 100 -- Valore predefinito in caso di errore
        end
    else
        return GetVehicleFuelLevel(vehicle) -- Fallback al sistema nativo
    end
end

GarageCFG.SetFuel = function(vehicle, level)
    local system = GarageCFG.FuelSystem.systems[GarageCFG.ActiveFuelSystem]
    if system then
        local success, result = pcall(system.setFuel, vehicle, level)
        if not success then
            print("^1[Flash_garage] Errore nell'impostazione del carburante: " .. tostring(result) .. "^7")
            SetVehicleFuelLevel(vehicle, level) -- Fallback al sistema nativo
        end
    else
        SetVehicleFuelLevel(vehicle, level) -- Fallback al sistema nativo
    end
end

GarageCFG.GetFuelScale = function()
    local system = GarageCFG.FuelSystem.systems[GarageCFG.ActiveFuelSystem]
    if system and system.scale then
        return system.scale
    else
        return {0, 100} -- Scala predefinita
    end
end



GarageCFG.Labels = {
    ["menu"] = "Premi [~y~E~w~] per aprire il Garage %s",
    ["vehicle"] = "Premi [~y~E~w~] per depositare il veicolo %s"
}

GarageCFG.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

GarageCFG.AlignMenu = "right" -- this is where the menu is located [left, right, center, top-right, top-left etc.]