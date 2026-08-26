# A walkthrough of how I solved every level of the *Terminal Voyage* Linux/Git CTF, from Loguetown Reef all the way to Laugh Tale.
## Level 1 — Awakening at Loguetown Reef

The setup: four storage sectors full of "Devil Fruit" files, all looking identical. The lore said replicas were "manufactured, catalogued, and permanently sealed," while the real fruit "still possesses the power to awaken itself">

I ran `ls -la` and `file *` across the sectors. Sure enough, one file stood out — it was the only one that was actually **executable**, while the rest were static, permission-locked data. I fed that file into the provided `eat.sh>

```bash
./eat.sh <real_fruit_file>
```

This decrypted an `AWAKENING_SIGNATURE` — a string I'd need to hold onto for later levels.

---
## Level 2 — The Two Faces of Whiskey Peak

At first glance, `Whiskey_Peak/` only contained a harmless `feast_manifest.txt`. But the story hinted at a "communications vault" that "recognizes the aura" of my awakened fruit — meaning there had to be something hidden that rea>

I dug into the project's git history:

```bash
git log --oneline --all
```

This revealed a separate branch, `origin/whiskey_peak_investigation`, that wasn't merged into my current branch. Checking it out exposed a hidden directory (dot-prefixed, so invisible to a normal `ls`):

```
.baroque_works_cache/unlock_vault.sh
```

Reading that script showed exactly how it worked:
- It hashed an environment variable called `AWAKENING_SIGNATURE` and compared it to a target SHA-256 hash.
- If it matched, it used that same signature as an **OpenSSL decryption password** to decrypt a flag.
- It then generated two nearly identical 100-line log files, but silently swapped in the real flag on line 42 of only one of them.

I exported my Level 1 signature and ran it:

```bash
export AWAKENING_SIGNATURE="<my signature from level 1>"
./unlock_vault.sh
diff marine_intercept.log bounty_hunter_feed.log
```

The `diff` immediately showed the one line that differed — my Executive Transmission Code:
```
BAROQUE_DIAL{SPLIT_TIMELINE_MISDIRECTION}
```

---
## Level 3 — The Wax Labyrinth of Little Garden

This level dumped **491 near-identical decoy files** across a maze of nested `sector_*/outpost/watchtower/...` directories, all following the same templated `SYSTEM_DUMP: ...` format.

The story explicitly said the real code wouldn't appear in raw form again — it would be transformed into its "broadcast representation" first. That's a classic hint for **base64 encoding**, so I pre-encoded my Level 2 flag:

```bash
echo -n "BAROQUE_DIAL{SPLIT_TIMELINE_MISDIRECTION}" | base64
```

Rather than grep through hundreds of files by eye, I used `grep`'s inverse match to find the one file that *didn't* follow the decoy template:

```bash
grep -rL "SYSTEM_DUMP" --include="*.log" .
```

That isolated a single file, `agent_manifest.log`, buried deep in `sector_beta/outpost/watchtower/storage/archive/`. It contained a `SECURITY_TAG` field matching my base64-encoded flag (confirming authenticity) and my first ciphe>

```
PONEGLYPH_FRAGMENT_I = "KjY2MjF4bW0lKzYqNyBsIS0vbTAtJTcnL"
```

---
## Level 4 — The Camouflaged Blueprints of Water 7

The story's hint was blunt: *"Ask it not for its name... ask it for its nature."* That's the `file` command in a nutshell — it inspects actual file content/magic bytes, ignoring extensions and misleading names.

I found a file called `puffing_tom_blueprints` with no extension at all. Running:

```bash
file puffing_tom_blueprints
```

revealed it was actually **gzip-compressed data**. I unwrapped it layer by layer, checking `file` at each step since each layer disguised itself as something else:

```bash
cp puffing_tom_blueprints step2_blueprints.tar.gz
gunzip step2_blueprints.tar.gz     # → tar archive
tar -xvf step2_blueprints.tar      # → contained a .zip
unzip step1_blueprints.zip         # → finally, real files
```

Inside was a decoy (`frame_specs.dat`, literally labeled `DECOY_DATA`) and the real prize, `secret_link.txt`, containing my second cipher piece:

```
PONEGLYPH_FRAGMENT_II="SwnbzptDiM3JSpvFiMuJ28PJzAlJ28VIzA="
```

---
## Level 5 — The Buster Call Timeline Recovery

The story said the two Poneglyph fragments meant nothing individually and needed to be reconciled. I concatenated them (Fragment I directly followed by Fragment II) and base64-decoded the result:

```bash
echo -n "KjY2MjF4bW0lKzYqNyBsIS0vbTAtJTcnLSwnbzptDiM3JSpvFiMuJ28PJzAlJ28VIzA=" | base64 -d
```

That produced a readable-but-garbled string — clearly still encoded somehow, not final plaintext.

Digging through git history again for the "Vault Sealed" commit revealed a hidden `.cp9_secure_vault/poneglyph.py` decoder script, alongside five decoy `decode.sh` scripts (each just printing a fake "Intruder Alert" — a nice trap>

```python
decoded = base64.b64decode(ENCODED)
flag = bytes(b ^ KEY for b in decoded).decode()
```

Running it with my combined fragment string gave me the final prize — a GitHub repo link:

```
https://github.com/rogueone-x/Laugh-Tale-Merge-War
```

---
## Level 6 — The Great Merge War at Laugh Tale

The final repo had two diverging branches: `ancient_history` and `pirate_king_path`. The README made the mechanic explicit — this was a literal **git merge conflict** I had to resolve by hand, not just pick one side.

```bash
git clone https://github.com/rogueone-x/Laugh-Tale-Merge-War
git checkout ancient_history
git merge pirate_king_path
```

The merge failed on two files: `treasure/key_part_1.txt` and `treasure/key_part_2.txt`. Opening them showed classic conflict markers with two competing halves of text:

```
<<<<<<< HEAD
Line
=======
TheGrand
>>>>>>> pirate_king_path
```
```
<<<<<<< HEAD
bers
=======
Remem
>>>>>>> pirate_king_path
```

Combining both sides of each conflict (`TheGrand` + `Line`, `Remem` + `bers`) gave:

```
TheGrandLineRemembers
```

I resolved both files with the combined text, staged and committed the merge, then fed the password into the final `victory.sh` script — which validated it against a SHA-256 hash and printed the win screen:

```
FLAG{The_Grand_Line_Remembers_Your_Commit}
```

---
