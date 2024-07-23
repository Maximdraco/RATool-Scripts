// Chronicles of Narnia, The: The Lion, the Witch and the Wardrobe
// #ID = 28384
// RA Hash = 380582e0d15d448f212a96cb2aba111b (USA version)

// == Functions to write logic more similar to the normal toolkit

// Deltas
function DeltaE(address, value) {return (prev(address) == value)}
function DeltaNE(address, value) {return (prev(address) != value)}
function DeltaB(address, value) {return (prev(address) > value)}
function DeltaS(address, value) {return (prev(address) < value)}
function DeltaBE(address, value) {return (prev(address) >= value)}
function DeltaSE(address, value) {return (prev(address) <= value)}

// ResetIf
function ResetIf(logic) {return (never(logic))}

// PauseIf
function PauseIf(logic) {return (unless(logic))}
function PauseIfUntil(logic) {disable_when(logic, until=always_false())}
function PauseIfUntil(logic, Until) {disable_when(logic, until=Until)}

// AddSource
function AddSourceChain(array) {
    return_logic = array[0]
    for index in range(1, length(array)-1) {
        return_logic = return_logic + array[index]
    }
    
    return (measured(return_logic == length(array), when=always_true(), format="raw"))
}

function AddSourceDeltaChain(array) {
    return_logic = prev(array[0])
    for index in range(1, length(array)-1) {
        return_logic = return_logic + prev(array[index])
    }
    
    return (return_logic == length(array)-1)
}

// == Code Notes ========
// Level complete screen
Level_complete_screen = byte(0x2468b7)
function Level_complete_screen(value) => (Level_complete_screen == value)
// 0x44 = Level complete screen

// Difficulty
Difficulty = byte(0x4e1f80)
function Difficulty(value) => (Difficulty == value)
// 0x00 = Normal
// 0x01 = Hard

// Level ID
Level_ID = byte(0x00484e23)
function Level_ID(value) => (Level_ID == value)

// Screen IDs
Screen_ID = byte(0x4deb7b)
function Screen_ID(value) => (Screen_ID == value)
// 0x00 = Starting the game
// 0x08 = Title Screen (intro custscene)
// 0x0e = Title Screen (options)
// 0xf4 = Load save screen
// 0xf5 = Confirm load save screen
// 0xff = Game and level select screen

Blocked_screens = (Screen_ID(0x00) ||
                   Screen_ID(0x08) ||
                   Screen_ID(0x0e) ||
                   Screen_ID(0xf4) ||
                   Screen_ID(0xf5) ||
                   Screen_ID(0xf6))

Changed_difficulty = DeltaNE(Difficulty, 0x01) && Difficulty(0x00)

Difficulty_check = PauseIfUntil(Changed_difficulty, Blocked_screens) && Difficulty(0x01)
         
Save_protection = (once(prior(Screen_ID) == 0xf6))

// Create alt groups so the reset can't be paused
reset = ResetIf(Screen_ID(0x00)) || ResetIf(Screen_ID(0x0e)) || (repeated(100, always_true()))

Level_complete_check = DeltaNE(Level_complete_screen, 0x44) && Level_complete_screen(0x44)

// Statues
Statues_not_used_in_Great_Battle = byte(0x004e09db)
Total_of_statues_in_Great_Battle = byte(0x004e09df)

// Shields
shields_address = [0x0049c513, 0x0049c517, 0x0049c51b,
                   0x0049c51f, 0x0049c523, 0x0049c527,
                   0x0049c52b, 0x0049c52f, 0x0049c533,
                   0x0049c537, 0x0049c53b, 0x0049c53f,
                   0x0049c543, 0x0049c547, 0x0049c54b]
                      
amount_of_shield = [21, 5, 16, 21, 29, 4, 13, 7, 16, 10, 12, 6, 5, 7, 5]

// Cheats
Down = 0x64 // Cheat input Down
Left = 0x6c // Cheat input Left
Right = 0x72 // Cheat input Right
Up = 0x75 // Cheat input Up
Starting_cheat_input_address = 0x36d648
function cheat_input(address, value) => (byte(address) == value)

// Serie of inputs
Unlock_all_bonus_level = [Down, Down, Right, Right, Down, Right, Up]
Unlock_all_abilities = [Down, Left, Right, Left, Up]
Restore_heal = [Down, Left, Left, Right]
Get_coins = [Down, Left, Right, Down, Down]
Open_all_levels = [Up, Up, Right, Right, Up, Right, Down]
Fill_combo_meter = [Up, Up, Right, Up]
Automatically_complete_level = [Down, Left, Down, Left, Down, Right, Down, Right, Up]
Cheat_mode = [Down, Down, Right, Up]

function Cheat(array){
    i = byte(Starting_cheat_input_address)
    cheat = DeltaE(i, array[0])
    for index in range(1, length(array)-1) {
        cheat = cheat && cheat_input(Starting_cheat_input_address + index, array[index])
    }
    return cheat
}

AntiCheats = PauseIfUntil(Cheat(Unlock_all_bonus_level), Screen_ID(0x00)) &&
             PauseIfUntil(Cheat(Unlock_all_abilities), Screen_ID(0x00)) &&
             PauseIfUntil(Cheat(Restore_heal), Screen_ID(0x00)) &&
             PauseIfUntil(Cheat(Get_coins), Screen_ID(0x00)) &&
             PauseIfUntil(Cheat(Open_all_levels), Screen_ID(0x00)) &&
             PauseIfUntil(Cheat(Fill_combo_meter), Screen_ID(0x00)) &&
             PauseIfUntil(Cheat(Automatically_complete_level), Screen_ID(0x00)) &&
             PauseIfUntil(Cheat(Cheat_mode), Screen_ID(0x00))

Pete_skills = [bit0(0x49a8bd), // Bit0 = Ogre Bane (Peter and Edmund)
               bit4(0x49a8bd), // Bit4 = Double Damage
               bit5(0x49a8bd), // Bit5 = Gift Sword
               bit6(0x49a8bd), // Bit6 = Team Attack (Peter and Susan)
               bit7(0x49a8bd), // Bit7 = Blade Spinner (Peter and Edmund)
               bit0(0x49a8be), // Bit0 = Wolf Bane (Peter and Edmund)
               bit1(0x49a8be), // Bit1 = Lion's Leap (Peter and Edmund)
               bit2(0x49a8be), // Bit2 = Ghoul Bane (Peter and Edmund)
               bit3(0x49a8be), // Bit3 = Lion's Roar (Peter and Edmund)
               bit4(0x49a8be), // Bit4 = Boogle Bane (Peter and Edmund)
               bit5(0x49a8be), // Bit5 = Shield Slam
               bit6(0x49a8be), // Bit6 = Minoboard Bane (Peter and Edmund)
               bit7(0x49a8be), // Bit7 = Lion's Claw (Peter and Edmund)
               bit0(0x49a8bf), // Bit0 = Valiant Heart (All Children)
               bit1(0x49a8bf), // Bit1 = Brave Heart (All Children)
               bit2(0x49a8bf), // Bit2 = Phoenix Heart (All Children)
               bit3(0x49a8bf)] // Bit3 = Lion Heart (All Children)

Susan_skills = [bit0(0x49a8c0), // Full Circle (Susan and Edmund)
               bit5(0x49a8c1), // Rain of Fire (Susan and Lucy)
               bit6(0x49a8c1), // Team Attack (Peter and Susan)
               bit1(0x49a8c2), // Fast Reload
               bit2(0x49a8c2), // Dryad's Melody
               bit3(0x49a8c2), // Hawkspeed
               bit4(0x49a8c2), // Stone Song
               bit5(0x49a8c2), // Panpipes
               bit6(0x49a8c2), // Gift Bow
               bit7(0x49a8c2), // Ivory Horn
               bit0(0x49a8c3), // Valiant Heart (All Children)
               bit1(0x49a8c3), // Brave Heart (All Children)
               bit2(0x49a8c3), // Phoenix Heart (All Children)
               bit3(0x49a8c3)] // Lion Heart (All Children)

Edmund_skills = [bit0(0x49a8c4), // Full Circle (Susan and Edmund)
                 bit0(0x49a8c5), // Ogre Bane (Peter and Edmund)
                 bit4(0x49a8c5), // Shield Shower (Edmund and Lucy)
                 bit7(0x49a8c5), // Blade Spinner (Peter and Edmund)
                 bit0(0x49a8c6), // Wolf Bane (Peter and Edmund)
                 bit1(0x49a8c6), // Lion's Leap (Peter and Edmund)
                 bit2(0x49a8c6), // Ghoul Bane (Peter and Edmund)
                 bit3(0x49a8c6), // Lion's Roar (Peter and Edmund)
                 bit4(0x49a8c6), // Boogle Bane (Peter and Edmund)
                 bit6(0x49a8c6), // Minoboard Bane (Peter and Edmund)
                 bit7(0x49a8c6), // Lion's Claw (Peter and Edmund)
                 bit0(0x49a8c7), // Valiant Heart (All Children)
                 bit1(0x49a8c7), // Brave Heart (All Children)
                 bit2(0x49a8c7), // Phoenix Heart (All Children)
                 bit3(0x49a8c7)] // Lion Heart (All Children)
              
Lucy_skills = [bit1(0x49a8c8), // Dryad's Cloak
               bit0(0x49a8c9), // Sun Fire
               bit1(0x49a8c9), // Boggle Tame
               bit2(0x49a8c9), // Fire Flower Cordial
               bit4(0x49a8c9), // Shield Shower (Edmund and Lucy)
               bit5(0x49a8c9), // Rain of Fire (Susan and Lucy)
               bit0(0x49a8ca), // First Aid
               bit1(0x49a8ca), // Wolf Tame
               bit2(0x49a8ca), // Ghoul Tame
               bit3(0x49a8ca), // Fire Fill
               bit4(0x49a8ca), // Minoboar Tame
               bit5(0x49a8ca), // Double Drop
               bit6(0x49a8ca), // Sun Speed
               bit7(0x49a8ca), // Triple Tipple
               bit0(0x49a8cb), // Valiant Heart (All Children)
               bit1(0x49a8cb), // Brave Heart (All Children)
               bit2(0x49a8cb), // Phoenix Heart (All Children)
               bit3(0x49a8cb)] // Lion Heart (All Children)

Level_names = ["The Air Raid",
               "Glimpse of Narnia",
               "The Spare Room",
               "Lantern Waste",
               "To Western Wood",
               "Beaver Dam",
               "Through the Tunnel",
               "Frozen Lake",
               "The Great River",
               "Rescue Edmund",
               "Follow Aslan",
               "Battle of Beruna",
               "The Witch's Castle",
               "The Great Battle",
               "The White Witch"]

Achievement_titles_Bonus_levels = ["To Western Wood Again",
                                   "Return to Allies Enclave",
                                   "The Winter is back",
                                   "Another Great River",
                                   "Stealth Mission",
                                   "The Witch's Second Castle"]
                          
Bonus_level_names = ["To Western Wood",
                     "Allies Enclave",
                     "Frozen Lake",
                     "The Great River",
                     "Follow Aslan",
                     "The Witch's Castle"]

// === Achievements =========

// Warning achievement
achievement(
    title = "WARNING!",
    description = "None of the achievements will trigger if you use any cheat, and only change the difficulty in the title screen.",
    points = 0,
    type = "",
    trigger = (repeated(100, always_true()))
)

// Cicle to create the main achievements of the set
for index in range(0x00, 0x0e) {
    // Normal difficulty achievements
    if index != 0x0e{
        achievement(
            title = Level_names[index],
            description = "Complete \"" + Level_names[index] + "\".",
            points = 5,
            type = "progression",
            trigger = (Level_ID(index) &&
                       Level_complete_check &&
                       Save_protection &&
                       AntiCheats) && reset
        )
    } else {
        achievement(
            title = Level_names[index],
            description = "Complete \"" + Level_names[index] + "\".",
            points = 5,
            type = "win_condition",
            trigger = (Level_ID(index) &&
                       Level_complete_check &&
                       Save_protection &&
                       AntiCheats) && reset
        )
    }
    // Hard mode achievements
    achievement(
        title = Level_names[index] + " [Hard]",
        description = "Complete \"" + Level_names[index] + "\" on Hard difficulty.",
        points = 5,
        type = "",
        trigger = (Level_ID(index) &&
                   Level_complete_check &&
                   Difficulty_check &&
                   Save_protection &&
                   AntiCheats) && reset
    )
    
    // Shield achievements
    achievement(
        title = "Gathering shields in " + Level_names[index],
        description = "Collect all shields in \"" + Level_names[index] + "\".",
        points = 3,
        type = "",
        trigger = (DeltaE(byte(shields_address[index]), amount_of_shield[index]-1) &&
                   byte(shields_address[index]) == amount_of_shield[index] &&
                   Save_protection &&
                   AntiCheats) && reset
    )
}

// Achievements for the Bonus levels
for index in range(0, 5) {
    // Normal difficulty achievements
    achievement(
        title = Achievement_titles_Bonus_levels[index],
        description = "Complete the bonus level \"" + Bonus_level_names[index] + "\".",
        points = 5,
        type = "",
        trigger = (Level_ID(index+15) &&
                   Level_complete_check &&
                   Save_protection &&
                   AntiCheats) && reset
    )
    // Hard difficulty achievements
    achievement(
        title = Achievement_titles_Bonus_levels[index] + " [Hard]",
        description = "Complete the bonus level \"" + Bonus_level_names[index] + "\" on Hard difficulty.",
        points = 5,
        type = "",
        trigger = (Level_ID(index+15) &&
                   Level_complete_check &&
                   Difficulty_check &&
                   Save_protection &&
                   AntiCheats) && reset
    )
}

// Achievements for unlocking all skills - Pete
achievement(
    title = "High King Peter the Magnificent",
    description = "Unlock all of Pete's skills.",
    points = 5,
    type = "",
    trigger = (AddSourceChain(Pete_skills) && AddSourceDeltaChain(Pete_skills) && Save_protection && AntiCheats) && reset
)
// Susan
achievement(
    title = "Queen Susan the Gentle",
    description = "Unlock all of Susan's skills.",
    points = 5,
    type = "",
    trigger = (AddSourceChain(Susan_skills) && AddSourceDeltaChain(Susan_skills) && Save_protection && AntiCheats) && reset
)
// Edmund
achievement(
    title = "King Edmund the Just",
    description = "Unlock all of Edmund's skills.",
    points = 5,
    type = "",
    trigger = (AddSourceChain(Edmund_skills) && AddSourceDeltaChain(Edmund_skills) && Save_protection && AntiCheats) && reset
)
// Lucy
achievement(
    title = "Queen Lucy the Valiant",
    description = "Unlock all of Lucy's skills.",
    points = 5,
    type = "",
    trigger = (AddSourceChain(Lucy_skills) && AddSourceDeltaChain(Lucy_skills) && Save_protection && AntiCheats) && reset
)

// No reinforcement achievements
achievement(
    title = "No Reinforcement Needed",
    description = "Complete \"The Great Battle\" without using statues.",
    points = 5,
    type = "",
    trigger = (Level_ID(13) &&
              AntiCheats &&
              Save_protection &&
              Level_complete_check && 
              Statues_not_used_in_Great_Battle == Total_of_statues_in_Great_Battle) && reset
)
// No reinforcement achievements Hard difficulty
achievement(
    title = "No Reinforcement Needed [Hard]",
    description = "Complete \"The Great Battle\" on Hard difficulty without using statues.",
    points = 5,
    type = "",
    trigger = (Level_ID(13) &&
               AntiCheats &&
               Save_protection &&
               Level_complete_check &&
               Difficulty_check &&
               Statues_not_used_in_Great_Battle == Total_of_statues_in_Great_Battle) && reset
)

// Achievements for collecting statues

function collecting_statues_achievements(Stage_name, Starting_address, Amount_of_statues){
    Statues = [bit0(Starting_address)]
    for index in range(0x01, Amount_of_statues-1){
        array_push(Statues, bit0(Starting_address+index))
    }
    Statues_chain = AddSourceChain(Statues)
    Delta_statues_chain = AddSourceDeltaChain(Statues)

    achievement(
        title = "Finding statues in " + Stage_name,
        description = "Collect all statues in \"" + Stage_name + "\".",
        points = 3,
        type = "",
        trigger = (Delta_statues_chain &&
                   Statues_chain &&
                   Save_protection &&
                   AntiCheats) && reset
    )
}

collecting_statues_achievements("Lantern Waste", 0x0049ab7c, 10)
collecting_statues_achievements("To Western Wood", 0x0049abbc, 15)
collecting_statues_achievements("Beaver Damn", 0x0049abfc, 6)
collecting_statues_achievements("Through the Tunnel", 0x0049ac3c, 12)
collecting_statues_achievements("Frozen Lake", 0x0049ac7c, 12)
collecting_statues_achievements("The Great River", 0x0049acbc, 4)
collecting_statues_achievements("Rescue Edmund", 0x0049acfc, 4)
collecting_statues_achievements("Follow Aslan", 0x0049ad3c, 5)
collecting_statues_achievements("Battle of Beruna", 0x0049ad7c, 4)