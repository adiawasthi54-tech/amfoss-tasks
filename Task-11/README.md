# Escape the Island

A small text-based adventure game written in Python. You play a spy stranded on Kinmen Island who must sneak across guarded territory, avoid suspicion, and reach the western shore to escape by swimming toward the mainland.

## Motivation

This game was inspired by a personal interest in geopolitics — specifically the real-world tensions around Kinmen Island and the Taiwan Strait, which the game's setting and premise draw on.

## Story

You wake up on Kinmen Island after a mission goes wrong. Surveillance is heavy, supplies are cut off, and a garbled radio transmission is the only guidance you get. Your goal is to move between locations, gather clues, manage how suspicious you look to patrols, and eventually cross Kinmen Bridge to reach the coast and swim to freedom.

## Requirements

- Python 3.6 or later (no external libraries required — uses only `time`, `random`, and `sys` from the standard library)

## How to Run

```bash
python3 escape_the_island.py
```

You'll be asked to enter your name, then given an introductory transmission before the game begins.

## How to Play

The game is controlled entirely through typed text commands (all lowercase):

| Command | Effect |
|---|---|
| `.<place>` | Travel to a connected location, e.g. `.jinsha` |
| `\<action>` | Interact with something in your current location, e.g. `\hide` |
| `.look` | Redisplay the description of your current area |
| `.map` | Show which places you can travel to from here |
| `.help` | Show the list of commands again |
| `.quit` | Give up and end the game |

Each area lists its own available interactions and travel destinations when you arrive or use `.look`.

## Locations

- **Jinhu Township** – Quiet farmland; a good place to lie low.
- **Jinsha** – A township with a checkpoint; guards can be bribed or eavesdropped on.
- **Jincheng** – The main town, heavily watched by cameras and soldiers.
- **Coast near Shuangkou** – A beach with a view of the bridge and the tide.
- **Kinmen Bridge** – The crossing point to the western shore.
- **Western Shore** – The final location, where you can swim to escape.

## Suspicion System

Your actions raise or lower a hidden **suspicion meter** (0–100):

- Reckless or risky actions (using the radio, a failed bribe, looking out of place) raise suspicion.
- Cautious actions (hiding, blending into a crowd, resting, successful bribes) lower it.
- If suspicion reaches **100**, you are caught and the game ends immediately (game over).

## Winning the Game

To win, you generally want to:

1. Gather clues about the bridge and tide from villagers, guards, or notice boards.
2. Manage your suspicion level by favoring low-risk actions.
3. Optionally find civilian clothes to blend in more easily.
4. Travel to the **beach**, then to **Kinmen Bridge**, and cross it.
5. From the **Western Shore**, use `\swim` to complete your escape and win.

## Notes

- Text is printed with a slight typing effect (`slow_print`) for atmosphere; you can adjust the `delay` parameter in the code to speed this up.
- Some outcomes (like bribing a guard or crossing the bridge safely) are randomized, so replaying may go differently each time.
