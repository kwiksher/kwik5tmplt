Title: The Last Spark - Cabin Scene
Author: A. Storyteller
Credit: A Visual Novel Example
Scene: The Old Cabin

EXT. OLD CABIN - DAY

You stand before an old cabin in the woods. The weathered structure looms before you, its wooden planks darkened by time and rain.

IMAGE: cabin_door_closed.png

OBJECT_STATE: cabin_door - CLOSED

INT. OLD CABIN - ENTRANCE - DAY

The door is firmly closed. You try the handle...

SFX: Door rattle sound

The handle won't budge. It seems locked from the inside.

[[CONDITIONAL: If player has key (hasKey == true)]]

SFX: Door creak

The door creaks open, revealing a dark interior.

OBJECT_STATE: cabin_door - OPEN

ELARA (19, with determined eyes and practical, worn-out clothing) steps cautiously through the doorway.

CHARACTER: Elara
IMAGE: elara_determined.png
EMOTION: determined

INT. OLD CABIN - MAIN ROOM - DAY

Dusty sunbeams filter through cracks in the boarded windows. The air is thick with the smell of decay and forgotten memories.

On a dusty table in the center of the room, you spot the Lumin Seed.

The LUMIN SEED sits on the wooden table, pulsing with a soft, warm light.

IMAGE: lumin_seed_glowing.png
OBJECT_STATE: lumin_seed - GLOWING

In the corner, an old chest catches your eye. Its iron bands are rusted but still intact.

IMAGE: chest_locked.png
OBJECT_STATE: chest - LOCKED

The chest is locked. You search for a key...

ELARA
(thinking)
There has to be a key somewhere around here...

[[ACTION: Player finds key]]
[[SET FLAG: hasKey = true]]

SFX: Key turn in lock

The lock clicks open with a satisfying sound.

OBJECT_STATE: chest - UNLOCKED

SFX: Chest opens with a creak

[[CONDITIONAL: If chest has not been looted (chestNotLooted == true)]]

OBJECT_STATE: chest - OPEN

The chest is empty! Someone got here first.

ELARA
(shocked)
No... it can't be!

CHARACTER: Elara
IMAGE: elara_scared.png
EMOTION: scared

OBJECT_STATE: chest - EMPTY

Suddenly—

SFX: Door slams shut

OBJECT_STATE: cabin_door - CLOSED

The door slams shut behind you! You're trapped!

ELARA
(panicking)
What?! No!

DIALOGUE:
* Try to force the door open
* Search for another way out
* Investigate the strange markings

FADE OUT.
