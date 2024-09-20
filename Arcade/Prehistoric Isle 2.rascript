// Prehistoric Isle 2
// #ID = 12343

// Functions for general use //

function bitchange(logic) => (prev(logic) < logic)

function Change_to_cero(logic) => (prev(logic) > 0 && logic == 0)

function DeltaE(address, value) {return (prev(address) == value)} // Equal
function DeltaNE(address, value) {return (prev(address) != value)} // Not Equal
function DeltaB(address, value) {return (prev(address) > value)} // Bigger
function DeltaS(address, value) {return (prev(address) < value)} // Smaller
function DeltaBE(address, value) {return (prev(address) >= value)} // Bigger or Equal
function DeltaSE(address, value) {return (prev(address) <= value)} // Smaller or Equal

// Priors
function PriorE(address, value) {return (prior(address) == value)} // Equal
function PriorNE(address, value) {return (prior(address) != value)} // Not Equal
function PriorB(address, value) {return (prior(address) > value)} // Bigger
function PriorS(address, value) {return (prior(address) < value)} // Smaller
function PriorBE(address, value) {return (prior(address) >= value)} // Bigger or Equal
function PriorSE(address, value) {return (prior(address) <= value)} // Smaller or Equal

// ResetIf
function ResetIf(logic) {return (never(logic))}

// PauseIf
function PauseIf(logic) {return (unless(logic))}
function PauseIfUntil(logic) {disable_when(logic, until=always_false())} // Pause without a reset flag
function PauseIfUntil(logic, Until) {disable_when(logic, until=Until)} // Pause with a reset flag

// AddSource chains
// Receive an array of size(address) elements and create an AddSource chain that have to be equal to the size of the array
// Used for bitflags
function AddSourceChain(array) {
    return_logic = array[0]
    for index in range(1, length(array)-1) {
        return_logic = return_logic + array[index]
    }
    
    return (measured(return_logic == length(array), when=always_true(), format="raw"))
}

// Receive an array of size(address) elements and create an AddSource Delta chain that have to be equal to the size of the array minus 1
// Used for bitflags
function AddSourceDeltaChain(array) {
    return_logic = prev(array[0])
    for index in range(1, length(array)-1) {
        return_logic = return_logic + prev(array[index])
    }
    
    return (return_logic == length(array)-1)
}

// Variables

lives = byte(0x005054)

// Civilians and soldiers saved in blue helicopter (5 on all levels)
civilians_blue = byte(0x005064)

// [16 Bits] Stars/medals
stars_medals = word(0x00506A)

// Game screen
//      
// 00 = Hardware Test
// 51 = SNK logo
// 52-61 = Intro cinematic
// 61 = Title screen
// 63 = Neo Geo logo
// 78-79 = How to play screen
// 80 = Player select screen
// 87 = Character selected
// ef = Demo
// d3 = Gameplay
// f2 = Credits
game_screen = byte(0x007503)

// [16 Bits] Can be used to check level
//        
// 0x0000 = Stage 1
// 0x6432 = Stage 1 Subteranean
// 0x5bba = Stage 1 sewer
// Change values during transition to Stage 2
// 0x1864 = Stage 2 Start
// 0x308f = Stage 3
// 0x3a33 = Stage 4
// 0x5d75 = Stage 5
// 0x6d72 = Stage 5 after red rescue helicopter
// 0x7fff = Stage 6
// 0x7aa9 = You Made It!
// 0x2a98 = Credits
level_A = word(0x00B9BC)

// [16 Bits] Can be used to check level
//
// 0x0000 = Stage 1 start
// 0x2333 = Stage 1 Subterranean
// Change randomly when the first boss appears in the subterranean
// 0x3333 = Sewer
// 0x026a = Stage 2 start
// 0x20c6 = Stage 2 Skeletons and Stage 3 and credits
// 0x2543 = Stage 4 start
// 0x5666 = Stage 5 Start
// 0x5f75 = Stage 6 start
level_B = word(0x00BE30)

// [8 Bits BCD] Score: 00XX000000
score_00XX000000 = byte(0x00C1A4)

// [8 Bits BCD] Score: XX00000000
score_XX00000000 = byte(0x00C1A5)

// [8 Bits BCD] Score: 000000XX00
score_000000XX00 = byte(0x00C1A6)

// $C1A7: [8 Bits BCD] Score: 0000XX0000
score_0000XX0000 = byte(0x00C1A7)

// [8 Bits] Civilians rescued in Red Helicopter
//      
// Stage 1: 20 in total
// Stage 2: 30 in total
// Stage 4: 30 in total
// Stage 5: 30 in total
civilians_red = byte(0x00E000)

// [8 Bits] Difficulty Level (Bios setting)
//        
// 0 = Level 1
// 7 = Level 8 (Max difficulty)
difficulty = byte(0x00FD8C)

playing = (lives > 0x00 &&
           (game_screen == 0xd3 || game_screen == 0xe1)) // In-game check

achievement_titles = ["Pachycephalosaurus", "What the hell is this?!",
                      "Bird Up", "Aptenoperissus?",
                      "The Volcano Level", "Is this an Alien?"]

rescued_civilians = byte(0x5068)

// Functions
function level_complete(level){
    if (level == 1){
        return (DeltaE(level_A, 0x5bba) &&
                level_A != 0x5bba &&
                level_B == 0x3333
               )
    }
    else if (level == 2){
        return (DeltaE(level_A, 0x1864) &&
                level_A != 0x1864 &&
                level_B == 0x20c6
               )
    }
    else if (level == 3){
        return (DeltaE(level_A, 0x308f) &&
                level_A != 0x308f &&
                DeltaE(level_B, 0x2543) &&
                level_B == 0x20c6
               )
    }
    else if (level == 4){
        return (DeltaE(level_A, 0x3a33) &&
                level_A != 0x3a33 &&
                DeltaE(level_B, 0x2543) &&
                level_B == 0x5666
               )
    }
    else if (level == 5){
        return (DeltaE(level_A, 0x6d72) &&
                level_A != 0x6d72 &&
                DeltaE(level_B, 0x5666) &&
                level_B == 0x5f75
               )
    }
    else if (level == 6){
        return (DeltaE(level_A, 0x7fff) &&
                level_A != 0x7fff &&
                DeltaE(level_B, 0x5f75)
               )
    }
}

function main_achievements(number){
    Title = achievement_titles[number-1]
    if (number < 6){
        achievement(
            title = Title, points = 10, type = "progression",
            description = "Complete Stage " + number + ".",
            trigger = level_complete(number)
        )
    }
    else{
        achievement(
            title = Title, points = 10, type = "win_condition",
            description = "Complete Stage " + number + ".",
            trigger = level_complete(number)
        )
    }
    achievement(
            title = Title + " [Level 8]", points = 10, type = "",
            description = "Complete Stage " + number + " with Difficulty Level 8.",
            trigger = level_complete(number) &&
                      difficulty == 7
        )
}

function red_helicopter(number, level_ID,letter, total_civilians){
    achievement(
    title = "Just Doing My Job " + letter, points = 5,
    description = "Save all the civilians in Stage " + number + " (the civilians that go in a red helicopter).",
    trigger = DeltaE(level_B, level_ID) &&
              level_B == level_ID &&
              DeltaS(civilians_red, total_civilians) &&
              civilians_red == total_civilians &&
              playing
    )
}

function blue_helicopter(number, letter, level_ID){
    achievement(
    title = "No One Left Behind " + letter, points = 10,
    description = "Complete Stage " + number + " with all the Rescue Bonus.",
    trigger = level_B == level_ID &&
              DeltaE(level_B, level_ID) &&
              DeltaS(rescued_civilians, 5) &&
              rescued_civilians == 5
    )
}

function invincible(number, letter, level_start_ID){
    if (number != 6){
        if (number != 1){
            achievement(
            title = "Invincible " + letter, points = 25,
            description = "Complete Stage " + number + " deadless.",
            trigger = level_complete(number) &&
                      ResetIf(game_screen != 0xe1 &&
                              game_screen != 0xd3) &&
                      PauseIfUntil(DeltaB(lives, lives),
                                   level_complete(number-1))
            )
        }
        else{
            achievement(
            title = "Invincible " + letter, points = 25,
            description = "Complete Stage " + number + " deadless.",
            trigger = level_complete(number) &&
                      PauseIfUntil(DeltaB(lives, lives),
                                   game_screen != 0xe1 &&
                                   game_screen != 0xd3)
            )
        }
    }
    else{
        achievement(
        title = "Invincible " + letter, points = 25,
        description = "Complete Stage " + number + " deadless.",
        trigger = level_complete(number) &&
                  PauseIfUntil(once(level_A == level_start_ID) &&
                               DeltaB(lives, lives),
                               game_screen != 0xe1 &&
                               game_screen != 0xd3)
        )
    }
}

// Achievement logic
main_achievements(1)
main_achievements(2)
main_achievements(3)
main_achievements(4)
main_achievements(5)
main_achievements(6)

red_helicopter(1, 0x2333, "I", 20)
red_helicopter(2, 0x26a, "II", 30)
red_helicopter(4, 0x2543, "III", 30)
red_helicopter(5, 0x5666, "IV", 30)

blue_helicopter(1, "I", 0x3333)
blue_helicopter(2, "II", 0x20c6)
blue_helicopter(4, "III", 0x2543)
blue_helicopter(5, "IV", 0x5666)

invincible(1, "I", 0x00)
invincible(2, "II", 0x1864)
invincible(3, "III", 0x308f)
invincible(4, "IV", 0x3a33)
invincible(5, "V", 0x5666)
invincible(6, "VI", 0x7fff)

achievement(
    title = "Untouchable", points = 50,
    description = "Complete the game deadless.",
    trigger = level_complete(6) &&
              PauseIfUntil(DeltaB(lives, lives),
                           game_screen != 0xe1 && game_screen != 0xd3
                          )
)

leaderboard(
    id = 103550, title = "Best Pilot in the World",
    description = "Get as many points as you can.",
    start  = DeltaE(game_screen, 0xf2) && game_screen == 0xf2,
    cancel = game_screen != 0xf2,
    submit = DeltaE(game_screen, 0xf2) && game_screen == 0xf2,
    value = measured((bcd(score_000000XX00) * 100 +
                      bcd(score_0000XX0000) * 10000 +
                      bcd(score_00XX000000) * 1000000 +
                      bcd(score_XX00000000) * 100000000 + 0)
            ),
    format = "VALUE"
)

leaderboard(
    id = 103551, title = "Medal Collector",
    description = "Get as many medals as possible.",
    start  = DeltaE(game_screen, 0xf2) && game_screen == 0xf2,
    cancel = game_screen != 0xf2,
    submit = DeltaE(game_screen, 0xf2) && game_screen == 0xf2,
    value = measured(stars_medals),
    format = "VALUE"
)
