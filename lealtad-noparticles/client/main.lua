-- Anti Particles and Panic Mode by VisiBait for LealtadRP

-- Quick Note: muchas gracias por todo de verdad. Ha sido un placer estar con vosotros este tiempo. He conocido a gente maravillosa en la administración y decir que me han tratado suuuper bien. Ojalá volver a formar parte de vuestro equipo en un futuro. <3

-- Básicamente este script lo que hace es eliminar las partículas cada 50ms, si se activa el modo de pánico (sería una vez el hacker haga tp a todo el mundo y ponga esposas) 
-- lo que hace es devolver a los jugadores a la posición que tenían hace 1 minuto, quitando las esposas. Una vez el modo panico se desactiva, el consumo del script baja totalmente y se estabiliza en 0.01,
-- y en cualquier momento puede volver a activarse.

-- He implementado otra opción en el panic mode. Una vez se activa, no se pueden spawnear ningún prop, se elimina automaticamente todo hasta que se ponga /panicmodeoff

-- RECOMIENDO ENCRIPTAR ESTO Y CAMBIAR TRIGGERS DEL POLICEJOB (Y ENCRIPTAR ESE ARCHIVO TMB) XD

-- USO: /panicmode (activa el panic mode), /panicmodeoff (lo desactiva)


local panicmode = false
local coords = nil

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        local xpos = 0.0
        local ypos = 0.0
        local zpos = 0.0
        local radio = 5000000000000.0
        RemoveParticleFxInRange(xpos, ypos, zpos, radio) -- quita todas las particulas del servidor cada 50ms. Si se usa el comando /protect se bajan los ms a 0 para que las partículas no afecten a la experiencia del usuario.
        if not panicmode then Citizen.Wait(50) end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(60000)
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        coords = pCoords
    end
end) 


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if panicmode then
            local objs = GetGamePool('CObject')
            for _, obj in ipairs(objs) do
                if NetworkGetEntityIsNetworked(obj) then
                    NetWorkDelete(obj)
            else
                    DeleteEntity(obj)
            end
        end
        end
end
end)

NetWorkDelete = function(entity)
    local intento = 0
    while not NetworkHasControlOfEntity(entity) and intento < 50 and DoesEntityExist(entity) do
            NetworkRequestControlOfEntity(entity)
            intento = intento + 1
    end
    if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
            SetEntityAsMissionEntity(entity, false, true)
            DeleteEntity(entity)
    end
end

gocoords = function()
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z);
end

RegisterCommand('panicmode', function () -- Recomiendo poner aqui para que vaya por permisos de admin
    panicmode = true
    ExecuteCommand("quitaresposas") -- Vendria bien poner un trigger aqui en vez del executecommand
    gocoords()
end, false)

RegisterCommand('panicmodeoff', function () -- Recomiendo poner aqui para que vaya por permisos de admin
    panicmode = false
end, false)
