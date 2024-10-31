if string.len(UI.LCD) > 7 then  --check if string lenght is larger than 8 (maximum number to be displayed in the LCD
   UI.LCD = string.sub(UI.LCD, -7) -- shows the last 8 digits of the string only
end