forkState = 'MainMenuState' -- used to fork states variables.

function onUpdatePost()
    if keyJustPressed('debug_2') then
        switchState('AF_Flashing')
    end
end