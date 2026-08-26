import time
import random
import sys

def slow_print(text, delay=0.02):
    for ch in text:
        sys.stdout.write(ch)
        sys.stdout.flush()
        time.sleep(delay)
    print()

def divider():
    print("-" * 55)

# ---------------------------------------------------------
# GAME STATE
# ---------------------------------------------------------
state = {
    "location": "jinhu",
    "suspicion": 0,          # 0-100, 100 = caught
    "flags": {
        "has_civilian_clothes": False,
        "knows_tide_hint": False,
        "knows_bridge_hint": False,
        "crossed_bridge": False,
    }
}

MAX_SUSPICION = 100

def add_suspicion(amount, reason=""):
    state["suspicion"] += amount
    state["suspicion"] = max(0, min(state["suspicion"], MAX_SUSPICION))
    if amount > 0:
        print(f"*~ ...you feel eyes on you... ~*  (+{amount} suspicion{': ' + reason if reason else ''})")
    elif amount < 0:
        print(f"*~ ...you feel safer for now... ~*  ({amount} suspicion{': ' + reason if reason else ''})")
    if state["suspicion"] >= MAX_SUSPICION:
        caught()

def caught():
    divider()
    slow_print("*#*#* ...ALARM... *#*#* ...SOLDIERS SPOTTED YOU... *#*#*")
    time.sleep(1)
    slow_print("You are surrounded before you can react.")
    slow_print("GAME OVER: You have been captured by Taiwanese forces.")
    divider()
    sys.exit()

def win():
    divider()
    slow_print("The water is cold, but you keep moving, arm over arm.")
    time.sleep(1)
    slow_print("Behind you, Kinmen shrinks into the dark. Ahead, only the current.")
    time.sleep(1)
    slow_print("Somewhere past the waves, the mainland waits.")
    time.sleep(1)
    slow_print("YOU HAVE ESCAPED THE ISLAND. YOU WIN.")
    divider()
    sys.exit()

# ---------------------------------------------------------
# AREA DEFINITIONS
# ---------------------------------------------------------
# Each area has: name, description, connections (areas reachable with .name),
# and interactions (triggered with \action)

def area_jinhu():
    print("\nYou are in JINHU TOWNSHIP.")
    slow_print("Quiet farmland. Old stone houses. Few patrols out here.")
    print("Things you can interact with:")
    print("  \\search farmhouse")
    print("  \\ask villager")
    print("  \\hide")
    print("Places you can travel to: .jinsha  .jincheng")

def area_jinsha():
    print("\nYou are in JINSHA.")
    slow_print("A small township with a checkpoint near the market road.")
    print("Things you can interact with:")
    print("  \\eavesdrop")
    print("  \\bribe guard")
    print("  \\buy supplies")
    print("Places you can travel to: .jinhu  .jincheng  .beach")

def area_jincheng():
    print("\nYou are in JINCHENG.")
    slow_print("The main town. Cameras on the lampposts. Soldiers on every corner.")
    print("Things you can interact with:")
    print("  \\use radio")
    print("  \\blend in crowd")
    print("  \\read notice board")
    print("Places you can travel to: .jinhu  .jinsha  .beach")

def area_beach():
    print("\nYou are at the COAST NEAR SHUANGKOU.")
    slow_print("Wind off the water. A long bridge stretches west into the mist.")
    print("Things you can interact with:")
    print("  \\observe tide")
    print("  \\rest")
    print("Places you can travel to: .jinsha  .jincheng  .bridge")

def area_bridge():
    print("\nYou are at KINMEN BRIDGE.")
    slow_print("The bridge stretches out over dark water, patrolled but long.")
    print("Things you can interact with:")
    print("  \\cross the bridge")
    print("Places you can travel to: .beach")

def area_coast():
    print("\nYou are at THE WESTERN SHORE.")
    slow_print("This is the closest point of land to anywhere else.")
    slow_print("The water stretches out, dark and quiet, toward the horizon.")
    print("Things you can interact with:")
    print("  \\swim")
    print("Places you can travel to: .bridge")

AREA_FUNCS = {
    "jinhu": area_jinhu,
    "jinsha": area_jinsha,
    "jincheng": area_jincheng,
    "beach": area_beach,
    "bridge": area_bridge,
    "coast": area_coast,
}

CONNECTIONS = {
    "jinhu": ["jinsha", "jincheng"],
    "jinsha": ["jinhu", "jincheng", "beach"],
    "jincheng": ["jinhu", "jinsha", "beach"],
    "beach": ["jinsha", "jincheng", "bridge"],
    "bridge": ["beach", "coast"],
    "coast": ["bridge"],
}

# ---------------------------------------------------------
# INTERACTIONS
# ---------------------------------------------------------
def do_interaction(area, action):
    if area == "jinhu":
        if action == "search farmhouse":
            if not state["flags"]["has_civilian_clothes"]:
                slow_print("You find a set of plain clothes hanging to dry. You take them.")
                state["flags"]["has_civilian_clothes"] = True
            else:
                slow_print("The farmhouse has nothing else useful.")
            return
        if action == "ask villager":
            slow_print("An old man mutters: \"They watch the town. Out west, the bridge... "
                        "some say the water is narrowest there, near the far shore.\"")
            state["flags"]["knows_bridge_hint"] = True
            add_suspicion(5, "talking to strangers draws attention")
            return
        if action == "hide":
            slow_print("You stay low behind the stone wall for a while.")
            add_suspicion(-10, "you kept out of sight")
            return

    if area == "jinsha":
        if action == "eavesdrop":
            slow_print("Two guards talk about the bridge patrol schedule and the tide times.")
            state["flags"]["knows_tide_hint"] = True
            add_suspicion(3, "lingering too close to guards")
            return
        if action == "bribe guard":
            if random.random() < 0.5:
                slow_print("The guard pockets the money and looks away.")
                add_suspicion(-15, "the guard owes you silence now")
            else:
                slow_print("The guard is offended and starts asking questions.")
                add_suspicion(25, "a failed bribe draws suspicion")
            return
        if action == "buy supplies":
            if state["flags"]["has_civilian_clothes"]:
                slow_print("Dressed like a local, you buy food without issue.")
                add_suspicion(-5, "blending in worked")
            else:
                slow_print("The vendor eyes your clothes strangely.")
                add_suspicion(10, "you looked out of place")
            return

    if area == "jincheng":
        if action == "use radio":
            slow_print("Static crackles loudly. Heads turn toward the sound.")
            add_suspicion(35, "the radio signal was traced")
            return
        if action == "blend in crowd":
            slow_print("You slip into the crowd and keep your head down.")
            add_suspicion(-10, "the crowd hides you well")
            return
        if action == "read notice board":
            slow_print("A faded notice mentions the bridge connecting the western islet, "
                        "and warns of strong currents at low tide.")
            state["flags"]["knows_bridge_hint"] = True
            state["flags"]["knows_tide_hint"] = True
            return

    if area == "beach":
        if action == "observe tide":
            slow_print("The tide is out. The far shore looks closer than you expected.")
            state["flags"]["knows_tide_hint"] = True
            return
        if action == "rest":
            slow_print("You catch your breath and steady your nerves.")
            add_suspicion(-5, "resting calmed you down")
            return

    if area == "bridge":
        if action == "cross the bridge":
            slow_print("You move along the bridge, staying low, watching the patrol lights.")
            if random.random() < 0.3:
                add_suspicion(20, "a patrol light swept close to you")
            state["flags"]["crossed_bridge"] = True
            state["location"] = "coast"
            time.sleep(0.5)
            area_coast()
            return

    if area == "coast":
        if action == "swim":
            win()

    print("Nothing happens. That doesn't seem to work here.")

# ---------------------------------------------------------
# COMMAND HANDLING
# ---------------------------------------------------------
def show_help():
    divider()
    print("COMMANDS:")
    print("  .<place>        travel to a place, e.g. .jinsha")
    print("  \\<action>       interact with something here, e.g. \\hide")
    print("  .look           look around the current area again")
    print("  .map            show where you can travel from here")
    print("  .help           show this list again")
    print("  .quit           give up and end the game")
    print("Type everything in lowercase.")
    divider()

def show_map():
    print("From here you can go to: " + "  ".join("." + a for a in CONNECTIONS[state["location"]]))

def game_loop():
    area_key = state["location"]
    AREA_FUNCS[area_key]()

    while True:
        cmd = input("\n> ").strip().lower()

        if cmd == "":
            continue

        if cmd == ".help":
            show_help()
            continue

        if cmd == ".look":
            AREA_FUNCS[state["location"]]()
            continue

        if cmd == ".map":
            show_map()
            continue

        if cmd == ".quit":
            print("You give up. GAME OVER.")
            sys.exit()

        if cmd.startswith("."):
            dest = cmd[1:].strip()
            if dest in CONNECTIONS.get(state["location"], []):
                state["location"] = dest
                AREA_FUNCS[dest]()
            else:
                print("You can't get there directly from here. Type .map to see your options.")
            continue

        if cmd.startswith("\\"):
            action = cmd[1:].strip()
            do_interaction(state["location"], action)
            continue

        print("Unknown command. Type .help if you're stuck.")

# ---------------------------------------------------------
# INTRO
# ---------------------------------------------------------
def intro():
    print("WELCOME TO ESCAPE THE ISLAND")
    time.sleep(0.5)
    name = input("Please Enter Your Name: ")
    time.sleep(1)
    print("RADIO SIGNAL RECEIVED...")
    time.sleep(0.5)
    slow_print(f"*~ ...hello...{name} can you-*#-*hear me... ~*")
    time.sleep(0.5)
    slow_print("*bzzzt* ...Comrade... *krrrsh* ...you were on a miss-*static*-ion to capture ")
    slow_print("Taiwan... *#*#* ...you are currently... stuck... on Kinmen Island... ")
    slow_print("*crackle* ...the enemy has... blocked all... *bzzt* ...supplies... ")
    slow_print("and has... strict sur-*static*-veillance... ")
    print("#### signal weak ####")
    time.sleep(0.5)
    slow_print("...meiyou gong-*krrsh*-chandang... jiu meiyou... xin zhong-*bzzt*-guo!!")
    time.sleep(1)
    slow_print("*~~~ transmission lost ~~~*")
    time.sleep(1)
    print("MESSAGE: You are currently in Jinhu Township")
    time.sleep(0.5)
    slow_print("Find a way to survive. Find a way home. Nobody is coming to tell you how.")
    show_help()

if __name__ == "__main__":
    intro()
    game_loop()