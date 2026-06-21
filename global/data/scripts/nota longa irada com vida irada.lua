function goodNoteHit(id, noteData, noteType, isSustainNote) -- provavelmente usar dps
    if isSustainNote then
        local currentHealth = getProperty('health');
        
        if currentHealth < 2 then
            setProperty('health', currentHealth + 0.0165);
        end
    end
end