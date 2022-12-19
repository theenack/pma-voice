RegisterCommand('+radiotalk', function()
    if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
    if isDead() or LocalPlayer.state.disableRadio then return end

    if not radioPressed and radioEnabled then
        if radioChannel > 0 then
            logger.info('[radio] Start broadcasting, update targets and notify server.')
            playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
            TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
            radioPressed = true
            playMicClicks(true)
            --if GetConvarInt('voice_enableRadioAnim', 0) == 1 and not (GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1 and IsPedInAnyVehicle(PlayerPedId(), false)) and not disableRadioAnim then
                RequestAnimDict('random@arrests')
                while not HasAnimDictLoaded('random@arrests') do
                    Wait(10)
                end
                TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
            --end
            CreateThread(function()
                TriggerEvent("pma-voice:radioActive", true)
                while radioPressed and not LocalPlayer.state.disableRadio do
                    Wait(0)
                    SetControlNormal(0, 249, 1.0)
                    SetControlNormal(1, 249, 1.0)
                    SetControlNormal(2, 249, 1.0)
                end
            end)
        end
    end
end, false)

RegisterCommand('-radiotalk', function()
    if (radioChannel > 0 or radioEnabled) and radioPressed then
        radioPressed = false
        MumbleClearVoiceTargetPlayers(voiceTarget)
        playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
        TriggerEvent("pma-voice:radioActive", false)
        playMicClicks(false)
        --if GetConvarInt('voice_enableRadioAnim', 0) == 1 then
            StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -4.0)
        --end
        TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
    end
end, false)
if gameVersion == 'fivem' then
    RegisterKeyMapping('+radiotalk', 'Talk over Radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
end
