sven coop quake v0.12 (02 Mar 20) by fgsfds

includes:
  - all weapons and ammo
  - all powerups
  - dm2, dm4, dm6, introduction and the whole first episode
  - all monsters from the first episode
  - music (requires the music pack)
  - a fgd (doesn't include some misc entities)

maps:
  pvp:
    q1_dm2
    q1_dm4
    q1_dm6
  coop:
    q1_start
    q1_e1m1
    q1_e1m2
    q1_e1m3
    q1_e1m4
    q1_e1m5
    q1_e1m6
    q1_e1m7
    q1_e1m8

weapon entities:
  weapon_qaxe
  weapon_qshotgun
  weapon_qshotgun2
  weapon_qnailgun
  weapon_qnailgun2
  weapon_qgrenade
  weapon_qrocket
  weapon_qthunder

monster entities:
  monster_qdog
  monster_qarmy
  monster_qogre
  monster_qknight
  monster_qscrag
  monster_qfiend
  monster_qshambler
  monster_qzombie
  monster_qboss

ammo entities:
  ammo_qshells
  ammo_qnails
  ammo_qrockets
  ammo_qenergy

item entities:
  item_qarmor1
  item_qarmor2
  item_qarmor3
  item_qkey1
  item_qkey2
  item_qrune1
  item_qrune2
  item_qrune3
  item_qquad
  item_qinvul
  item_qinvis
  item_qsuit

misc entities:
  qnailshooter
  trigger_qboss

known bugs:
  - monster behavior breaks sometimes
  - monsters can get stuck on stairs, corners and each other
  - zombies sometimes become non-solid
  - item placement is a bit fucked
  - lighting is far from 1:1 to the original
  - the elevators are sometimes too fast to get on
  - the amount of shit in the .res files crashes some servers.
    if your server crashes when loading a quake map, delete all
    the res files from this pack (they start with q1_)
  - other assorted small inconsistencies

version history:
  v0.10 31/08/2016:
    - initial release
  v0.11 15/04/2017:
    - updated scripts to work with SC 5.12
    - monster behavior now more similar to quake
    - armors now give 25/50/100 because SC armor absorbs a lot
  v0.12 02/03/2020
    - updated scripts to work with SC 5.2x
    - added custom HUD elements
    - cleaned up q1_gfx.wad
    - biosuit now actually does something
    - changed how deathmatch works (should remove the ~14 player limit)
    - most buttons are touch-to-activate now
    - fixed a bunch of critical bugs

resources ripped from
  - deathmatch classic
  - quake (shareware version)
  - quake remake (the xash3d one)

thanks to
  - lolipirate for fixing and scaling the quake remake models,
    making proper p_ models and the medkit
  - w00tguy from the sven forums for weapon_custom
  - KernCore for the reviveme crash fix
  - xash3d quake team (Unkle Mike, XaeroX, Crazy Russian, Dr. Tressi)
  - id software
