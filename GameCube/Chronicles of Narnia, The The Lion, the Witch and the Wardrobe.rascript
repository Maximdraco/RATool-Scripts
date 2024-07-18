// Chronicles of Narnia, The: The Lion, the Witch and the Wardrobe
// #ID = 28384
// RA Hash = 380582e0d15d448f212a96cb2aba111b (USA version)

// == Variables ========
// 0x4deb7b: [8 Bits] Can be used for screen check
// 00 = Just starting the game
// FF = In game and select level screen

// 0x4e1f80: Difficulty, 01 = Hard
Difficulty_Check = disable_when(
                               prev(byte(0x4e1f80)) == 1 && byte(0x4e1f80) == 0,
                               until=byte(0x4deb7b) == 0||
                               byte(0x4deb7b) == 0x08 ||
                               byte(0x4deb7b) == 0x0e ||
                               byte(0x4deb7b) == 0xf4 ||
                               byte(0x4deb7b) == 0xf5
                               ) &&
                               disable_when(
                               byte(0x4e1f80) == 0 &&
                               byte(0x4deb7b) == 255,
                               until=byte(0x4deb7b) == 0||
                               byte(0x4deb7b) == 0x08 ||
                               byte(0x4deb7b) == 0x0e ||
                               byte(0x4deb7b) == 0xf4 ||
                               byte(0x4deb7b) == 0xf5
                               )
                               
// Save protection, it use the screen ID
Save_Protection = prev(byte(0x4deb7b)) != 0xf4 && prev(byte(0x4deb7b)) != 0xf5

// Reset all hit counts when the game resets
reset = byte(0x004deb7b) == 0

// Create all groups so the reset can't be paused
general_reset = (
                never(reset) ||
                (repeated(100, always_true()))
                )

// Checks if the player is on the level complete screen
level_completed = (prev(byte(0x002468b7)) != 68 && byte(0x002468b7) == 68)

level_names = ["The Air Raid",
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

achievement_titles = ["To Western Wood Again",
                      "Return to Allies Enclave",
                      "The Winter is back",
                      "Another Great River",
                      "Stealth Mission",
                      "The Witch's Second Castle"]
                          
bonus_level_names = ["To Western Wood",
                     "Allies Enclave",
                     "Frozen Lake",
                     "The Great River",
                     "Follow Aslan",
                     "The Witch's Castle"]

// 0x36d648: [9 Bytes] Cheats, the first byte change to 0 after pressing the last button.
AntiCheats =(
    // Unlock All Bonus Levels = 64 64 72 72 64 72 75
    disable_when(
    prev(byte(0x36d648))==0x64 &&
    byte(0x36d648+1)==0x64 &&
    byte(0x36d648+2)==0x72 &&
    byte(0x36d648+3)==0x72 &&
    byte(0x36d648+4)==0x64 &&
    byte(0x36d648+5)==0x72 &&
    byte(0x36d648+6)==0x75,
    until=byte(0x4deb7b) == 0) &&
    
    // Unlock All Abilities in Inventory = 64 6c 72 6c 75
    disable_when(
    prev(byte(0x36d648))==0x64 &&
    byte(0x36d648+1)==0x6c &&
    byte(0x36d648+2)==0x72 &&
    byte(0x36d648+3)==0x6c &&
    byte(0x36d648+4)==0x75,
    until=byte(0x4deb7b) == 0) &&
    
    // Restore all Children's Health = 64 6c 6c 72
    disable_when(
    prev(byte(0x36d648))==0x64 &&
    byte(0x36d648+1)==0x6c &&
    byte(0x36d648+2)==0x6c &&
    byte(0x36d648+3)==0x72,
    until=byte(0x4deb7b) == 0) &&
    
    // Receive 10,000 Coins = 64 6c 72 64 64
    disable_when(
    prev(byte(0x36d648))==0x64 &&
    byte(0x36d648+1)==0x6c &&
    byte(0x36d648+2)==0x72 &&
    byte(0x36d648+3)==0x64 &&
    byte(0x36d648+4)==0x64,
    until=byte(0x4deb7b) == 0) &&

    // Open All Levels = 75 75 72 72 75 72 64
    disable_when(
    prev(byte(0x36d648))==0x75 &&
    byte(0x36d648+1)==0x75 &&
    byte(0x36d648+2)==0x72 &&
    byte(0x36d648+3)==0x72 &&
    byte(0x36d648+4)==0x75 &&
    byte(0x36d648+5)==0x72 &&
    byte(0x36d648+6)==0x64,
    until=byte(0x4deb7b) == 0) &&

    // Fill Combo Meter = 75 75 72 75
    disable_when(
    prev(byte(0x36d648))==0x75 &&
    byte(0x36d648+1)==0x75 &&
    byte(0x36d648+2)==0x72 &&
    byte(0x36d648+3)==0x75,
    until=byte(0x4deb7b) == 0) &&

    // Automatically Complete Level = 64 6c 64 6c 64 72 64 72 75
    disable_when(
    prev(byte(0x36d648))==0x64 &&
    byte(0x36d648+1)==0x6c &&
    byte(0x36d648+2)==0x64 &&
    byte(0x36d648+3)==0x6c &&
    byte(0x36d648+4)==0x64 &&
    byte(0x36d648+5)==0x72 &&
    byte(0x36d648+6)==0x64 &&
    byte(0x36d648+7)==0x72 &&
    byte(0x36d648+8)==0x75,
    until=byte(0x4deb7b) == 0) &&

    // Cheat Mode = 64 64 72 75
    disable_when(
    prev(byte(0x36d648))==0x64 &&
    byte(0x36d648+1)==0x64 &&
    byte(0x36d648+2)==0x72 &&
    byte(0x36d648+3)==0x75,
    until=byte(0x4deb7b) == 0)
    )

// 0x49a8bd, 0x49a8be, 0x49a8bf: Pete's Skills
Pete_Skill = (
             bit0(0x49a8bd) + // Bit0 = Ogre Bane (Peter and Edmund)
             bit4(0x49a8bd) + // Bit4 = Double Damage
             bit5(0x49a8bd) + // Bit5 = Gift Sword
             bit6(0x49a8bd) + // Bit6 = Team Attack (Peter and Susan)
             bit7(0x49a8bd) + // Bit7 = Blade Spinner (Peter and Edmund)
             bit0(0x49a8be) + // Bit0 = Wolf Bane (Peter and Edmund)
             bit1(0x49a8be) + // Bit1 = Lion's Leap (Peter and Edmund)
             bit2(0x49a8be) + // Bit2 = Ghoul Bane (Peter and Edmund)
             bit3(0x49a8be) + // Bit3 = Lion's Roar (Peter and Edmund)
             bit4(0x49a8be) + // Bit4 = Boogle Bane (Peter and Edmund)
             bit5(0x49a8be) + // Bit5 = Shield Slam
             bit6(0x49a8be) + // Bit6 = Minoboard Bane (Peter and Edmund)
             bit7(0x49a8be) + // Bit7 = Lion's Claw (Peter and Edmund)
             bit0(0x49a8bf) + // Bit0 = Valiant Heart (All Children)
             bit1(0x49a8bf) + // Bit1 = Brave Heart (All Children)
             bit2(0x49a8bf) + // Bit2 = Phoenix Heart (All Children)
             bit3(0x49a8bf) // Bit3 = Lion Heart (All Children)
             ) == 17
             &&             
             (
             prev(bit0(0x49a8bd)) + // Bit0 = Ogre Bane (Peter and Edmund)
             prev(bit4(0x49a8bd)) + // Bit4 = Double Damage
             prev(bit5(0x49a8bd)) + // Bit5 = Gift Sword
             prev(bit6(0x49a8bd)) + // Bit6 = Team Attack (Peter and Susan)
             prev(bit7(0x49a8bd)) + // Bit7 = Blade Spinner (Peter and Edmund)
             prev(bit0(0x49a8be)) + // Bit0 = Wolf Bane (Peter and Edmund)
             prev(bit1(0x49a8be)) + // Bit1 = Lion's Leap (Peter and Edmund)
             prev(bit2(0x49a8be)) + // Bit2 = Ghoul Bane (Peter and Edmund)
             prev(bit3(0x49a8be)) + // Bit3 = Lion's Roar (Peter and Edmund)
             prev(bit4(0x49a8be)) + // Bit4 = Boogle Bane (Peter and Edmund)
             prev(bit5(0x49a8be)) + // Bit5 = Shield Slam
             prev(bit6(0x49a8be)) + // Bit6 = Minoboard Bane (Peter and Edmund)
             prev(bit7(0x49a8be)) + // Bit7 = Lion's Claw (Peter and Edmund)
             prev(bit0(0x49a8bf)) + // Bit0 = Valiant Heart (All Children)
             prev(bit1(0x49a8bf)) + // Bit1 = Brave Heart (All Children)
             prev(bit2(0x49a8bf)) + // Bit2 = Phoenix Heart (All Children)
             prev(bit3(0x49a8bf)) // Bit3 = Lion Heart (All Children)
             ) == 16

// 0x49a8c0, 0x49a8c1, 0x49a8c2, 0x49a8c3: Susan's Skills
Susan_Skill = (
             prev(bit0(0x49a8c0)) + // Full Circle (Susan and Edmund)
             prev(bit5(0x49a8c1)) + // Rain of Fire (Susan and Lucy)
             prev(bit6(0x49a8c1)) + // Team Attack (Peter and Susan)
             prev(bit1(0x49a8c2)) + // Fast Reload
             prev(bit2(0x49a8c2)) + // Dryad's Melody
             prev(bit3(0x49a8c2)) + // Hawkspeed
             prev(bit4(0x49a8c2)) + // Stone Song
             prev(bit5(0x49a8c2)) + // Panpipes
             prev(bit6(0x49a8c2)) + // Gift Bow
             prev(bit7(0x49a8c2)) + // Ivory Horn
             prev(bit0(0x49a8c3)) + // Valiant Heart (All Children)
             prev(bit1(0x49a8c3)) + // Brave Heart (All Children)
             prev(bit2(0x49a8c3)) + // Phoenix Heart (All Children)
             prev(bit3(0x49a8c3)) // Lion Heart (All Children)
             ) == 13
             &&
             (
             bit0(0x49a8c0) + // Full Circle (Susan and Edmund)
             bit5(0x49a8c1) + // Rain of Fire (Susan and Lucy)
             bit6(0x49a8c1) + // Team Attack (Peter and Susan)
             bit1(0x49a8c2) + // Fast Reload
             bit2(0x49a8c2) + // Dryad's Melody
             bit3(0x49a8c2) + // Hawkspeed
             bit4(0x49a8c2) + // Stone Song
             bit5(0x49a8c2) + // Panpipes
             bit6(0x49a8c2) + // Gift Bow
             bit7(0x49a8c2) + // Ivory Horn
             bit0(0x49a8c3) + // Valiant Heart (All Children)
             bit1(0x49a8c3) + // Brave Heart (All Children)
             bit2(0x49a8c3) + // Phoenix Heart (All Children)
             bit3(0x49a8c3) // Lion Heart (All Children)
             ) == 14

// 0x49a8c4, 0x49a8c5, 0x49a8c6, 0x49a8c7:Edmund's Skills
Edmund_Skill = (
              bit0(0x49a8c4) + // Full Circle (Susan and Edmund)
              bit0(0x49a8c5) + // Ogre Bane (Peter and Edmund)
              bit4(0x49a8c5) + // Shield Shower (Edmund and Lucy)
              bit7(0x49a8c5) + // Blade Spinner (Peter and Edmund)
              bit0(0x49a8c6) + // Wolf Bane (Peter and Edmund)
              bit1(0x49a8c6) + // Lion's Leap (Peter and Edmund)
              bit2(0x49a8c6) + // Ghoul Bane (Peter and Edmund)
              bit3(0x49a8c6) + // Lion's Roar (Peter and Edmund)
              bit4(0x49a8c6) + // Boogle Bane (Peter and Edmund)
              bit6(0x49a8c6) + // Minoboard Bane (Peter and Edmund)
              bit7(0x49a8c6) + // Lion's Claw (Peter and Edmund)
              bit0(0x49a8c7) + // Valiant Heart (All Children)
              bit1(0x49a8c7) + // Brave Heart (All Children)
              bit2(0x49a8c7) + // Phoenix Heart (All Children)
              bit3(0x49a8c7) // Lion Heart (All Children)
              ) == 15
              &&
              (
              prev(bit0(0x49a8c4)) + // Full Circle (Susan and Edmund)
              prev(bit0(0x49a8c5)) + // Ogre Bane (Peter and Edmund)
              prev(bit4(0x49a8c5)) + // Shield Shower (Edmund and Lucy)
              prev(bit7(0x49a8c5)) + // Blade Spinner (Peter and Edmund)
              prev(bit0(0x49a8c6)) + // Wolf Bane (Peter and Edmund)
              prev(bit1(0x49a8c6)) + // Lion's Leap (Peter and Edmund)
              prev(bit2(0x49a8c6)) + // Ghoul Bane (Peter and Edmund)
              prev(bit3(0x49a8c6)) + // Lion's Roar (Peter and Edmund)
              prev(bit4(0x49a8c6)) + // Boogle Bane (Peter and Edmund)
              prev(bit6(0x49a8c6)) + // Minoboard Bane (Peter and Edmund)
              prev(bit7(0x49a8c6)) + // Lion's Claw (Peter and Edmund)
              prev(bit0(0x49a8c7)) + // Valiant Heart (All Children)
              prev(bit1(0x49a8c7)) + // Brave Heart (All Children)
              prev(bit2(0x49a8c7)) + // Phoenix Heart (All Children)
              prev(bit3(0x49a8c7)) // Lion Heart (All Children)
              ) == 14
              
// 0x49a8c8, 0x49a8c9, 0x49a8ca, 0x49a8cb: Lucy's skills
Lucy_Skill = (
            bit1(0x49a8c8) + // Dryad's Cloak
            bit0(0x49a8c9) + // Sun Fire
            bit1(0x49a8c9) + // Boggle Tame
            bit2(0x49a8c9) + // Fire Flower Cordial
            bit4(0x49a8c9) + // Shield Shower (Edmund and Lucy)
            bit5(0x49a8c9) + // Rain of Fire (Susan and Lucy)
            bit0(0x49a8ca) + // First Aid
            bit1(0x49a8ca) + // Wolf Tame
            bit2(0x49a8ca) + // Ghoul Tame
            bit3(0x49a8ca) + // Fire Fill
            bit4(0x49a8ca) + // Minoboar Tame
            bit5(0x49a8ca) + // Double Drop
            bit6(0x49a8ca) + // Sun Speed
            bit7(0x49a8ca) + // Triple Tipple
            bit0(0x49a8cb) + // Valiant Heart (All Children)
            bit1(0x49a8cb) + // Brave Heart (All Children)
            bit2(0x49a8cb) + // Phoenix Heart (All Children)
            bit3(0x49a8cb) // Lion Heart (All Children)
            ) == 18
            &&
            (
            prev(bit1(0x49a8c8)) + // Dryad's Cloak
            prev(bit0(0x49a8c9)) + // Sun Fire
            prev(bit1(0x49a8c9)) + // Boggle Tame
            prev(bit2(0x49a8c9)) + // Fire Flower Cordial
            prev(bit4(0x49a8c9)) + // Shield Shower (Edmund and Lucy)
            prev(bit5(0x49a8c9)) + // Rain of Fire (Susan and Lucy)
            prev(bit0(0x49a8ca)) + // First Aid
            prev(bit1(0x49a8ca)) + // Wolf Tame
            prev(bit2(0x49a8ca)) + // Ghoul Tame
            prev(bit3(0x49a8ca)) + // Fire Fill
            prev(bit4(0x49a8ca)) + // Minoboar Tame
            prev(bit5(0x49a8ca)) + // Double Drop
            prev(bit6(0x49a8ca)) + // Sun Speed
            prev(bit7(0x49a8ca)) + // Triple Tipple
            prev(bit0(0x49a8cb)) + // Valiant Heart (All Children)
            prev(bit1(0x49a8cb)) + // Brave Heart (All Children)
            prev(bit2(0x49a8cb)) + // Phoenix Heart (All Children)
            prev(bit3(0x49a8cb)) // Lion Heart (All Children)
            ) == 17

// === Functions =============

function collecting_statues_achievements(stage_name, starting_address, amount_of_statues){
    
    // First address with the statue flags
    statues = byte(starting_address)
    
    // Same as above but with prev() for the delta AddSource chain
    prev_statues = prev(byte(starting_address))
    
    // Cicle to create the AddSource chain for the statues flags
    for index in range(0x01, amount_of_statues-1){
    
        statues = statues + byte(starting_address+index)
        
        prev_statues =prev_statues + prev(byte(starting_address+index))
    }
    // ------------------------------------------------------------------
    achievement(
        title = "Finding statues in " + stage_name,
        description = "Collect all statues in \"" + stage_name + "\".",
        points = 3,
        type = "",
        trigger = (
                  prev_statues == amount_of_statues-1 &&
                  statues == amount_of_statues &&
                  level_completed &&
                  Save_Protection &&
                  AntiCheats
                  )
                  && general_reset
    )
    // ------------------------------------------------------------------
}

// === Achievements =========

// Warning achievement ----------------------------------------------
achievement(
    title = "WARNING!",
    description = "None of the achievements will trigger if you use any cheat, and only change the difficulty in the title screen.",
    points = 0,
    type = "",
    trigger = (repeated(100, always_true()))
)
// ------------------------------------------------------------------

// Main achievements and they hard mode version

// Cicle to create the main achievements of the set
for index in range(0, 14) {

    // Aditional variables
    level_id = (byte(0x00484e23) == index)
        
    // Normal achievements
    if index != 14{
        // ------------------------------------------------------------------
        achievement(
            title = level_names[index],
            description = "Complete \"" + level_names[index] + "\".",
            points = 5,
            type = "progression",
            trigger = (
                      level_id &&
                      level_completed &&
                      Save_Protection &&
                      AntiCheats
                      )
                      && general_reset
        )
        // ------------------------------------------------------------------
    } else {
        // ------------------------------------------------------------------
        achievement(
            title = level_names[index],
            description = "Complete \"" + level_names[index] + "\".",
            points = 5,
            type = "win_condition",
            trigger = (
                      level_id &&
                      level_completed &&
                      Save_Protection &&
                      AntiCheats
                      )
                      && general_reset
        )
        // ------------------------------------------------------------------
    }
    // Hard mode achievements ---------------------------------------------
    achievement(
        title = level_names[index] + " [Hard]",
        description = "Complete \"" + level_names[index] + "\" on Hard difficulty.",
        points = 5,
        type = "",
        trigger = (
                  level_id &&
                  level_completed &&
                  Difficulty_Check &&
                  Save_Protection &&
                  AntiCheats
                  )
                  && general_reset
    )
    // ------------------------------------------------------------------
}

// Achievements for the Bonus levels
for index in range(0, 5) {

    // Aditional variables
    level_id = (byte(0x00484e23) == (index+15))
    
    // Normal difficulty achievements ------------------------------------
    achievement(
        title = achievement_titles[index],
        description = "Complete the bonus level \"" + bonus_level_names[index] + "\".",
        points = 5,
        type = "",
        trigger = (
                  level_id &&
                  level_completed &&
                  Save_Protection &&
                  AntiCheats
                  )
                  && general_reset
    )
    // Hard difficulty achievements ------------------------------------
    achievement(
        title = achievement_titles[index] + " [Hard]",
        description = "Complete the bonus level \"" + bonus_level_names[index] + "\" on Hard difficulty.",
        points = 5,
        type = "",
        trigger = (
                  level_id &&
                  level_completed &&
                  Difficulty_Check &&
                  Save_Protection &&
                  AntiCheats
                  )
                  && general_reset
    )
    // ------------------------------------------------------------------
}

// Achievements for unlocking all skills - Pete----------------------
achievement(
    title = "High King Peter the Magnificent",
    description = "Unlock all of Pete's skills.",
    points = 5,
    type = "",
    trigger = (Pete_Skill && Save_Protection && AntiCheats) && general_reset
)
// Susan ------------------------------------------------------------
achievement(
    title = "Queen Susan the Gentle",
    description = "Unlock all of Susan's skills.",
    points = 5,
    type = "",
    trigger = (Susan_Skill && Save_Protection && AntiCheats) && general_reset
)
// Edmund -----------------------------------------------------------
achievement(
    title = "King Edmund the Just",
    description = "Unlock all of Edmund's skills.",
    points = 5,
    type = "",
    trigger = (Edmund_Skill && Save_Protection && AntiCheats) && general_reset
)
// Lucy -------------------------------------------------------------
achievement(
    title = "Queen Lucy the Valiant",
    description = "Unlock all of Lucy's skills.",
    points = 5,
    type = "",
    trigger = (Lucy_Skill && Save_Protection && AntiCheats) && general_reset
)
// ------------------------------------------------------------------

// No reinforcement achievements ------------------------------------
achievement(
    title = "No Reinforcement Needed",
    description = "Complete \"The Great Battle\" without using statues.",
    points = 5,
    type = "",
    trigger = (
              AntiCheats &&
              Save_Protection &&
              level_completed && 
              byte(0x00484e23) == 13 && // Level ID
              byte(0x004e09db) == byte(0x004e09df) // Statues not used in The Great Battle = Total of statues to use in The Great Battle
              ) && general_reset
)
// No reinforcement achievements Hard difficulty --------------------
achievement(
    title = "No Reinforcement Needed [Hard]",
    description = "Complete \"The Great Battle\" on Hard difficulty without using statues.",
    points = 5,
    type = "",
    trigger = (
              AntiCheats &&
              Save_Protection &&
              level_completed &&
              Difficulty_Check &&
              byte(0x00484e23) == 13 && // Level ID
              byte(0x004e09db) == byte(0x004e09df) // Statues not used in The Great Battle = Total of statues to use in The Great Battle
              ) && general_reset
)
// ------------------------------------------------------------------

// Achievements for collecting shields
for index in range(0, 14) {

    // Aditional variables
    shields_address = [0x0049c513,
                       0x0049c517,
                       0x0049c51b,
                       0x0049c51f,
                       0x0049c523,
                       0x0049c527,
                       0x0049c52b,
                       0x0049c52f,
                       0x0049c533,
                       0x0049c537,
                       0x0049c53b,
                       0x0049c53f,
                       0x0049c543,
                       0x0049c547,
                       0x0049c54b]
                      
    amount_of_shield = [21, 5, 16, 21, 29, 4, 13, 7, 16, 10, 12, 6, 5, 7, 5]
    
    // ------------------------------------------------------------------
    achievement(
        title = "Gathering shields in " + level_names[index],
        description = "Collect all shields in \"" + level_names[index] + "\".",
        points = 3,
        type = "",
        trigger = (
                  prev(byte(shields_address[index])) == amount_of_shield[index]-1 &&
                  byte(shields_address[index]) == amount_of_shield[index] &&
                  Save_Protection &&
                  AntiCheats
                  ) && general_reset
    )
    // ------------------------------------------------------------------
}

// Achievements for collecting statues
collecting_statues_achievements("Lantern Waste", 0x0049ab7c, 10)
collecting_statues_achievements("To Western Wood", 0x0049abbc, 15)
collecting_statues_achievements("Beaver Damn", 0x0049abfc, 6)
collecting_statues_achievements("Through the Tunnel", 0x0049ac3c, 12)
collecting_statues_achievements("Frozen Lake", 0x0049ac7c, 12)
collecting_statues_achievements("The Great River", 0x0049acbc, 4)
collecting_statues_achievements("Rescue Edmund", 0x0049acfc, 4)
collecting_statues_achievements("Follow Aslan", 0x0049ad3c, 5)
collecting_statues_achievements("Battle of Beruna", 0x0049ad7c, 4)

