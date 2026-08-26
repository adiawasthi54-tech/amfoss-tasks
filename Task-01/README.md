# A walkthrough of how I solved every level of the *Terminal Voyage* Linux/Git CTF, from Loguetown Reef all the way to Laugh Tale.
## Level 1 — Awakening at Loguetown Reef

The setup: four storage sectors full of "Devil Fruit" files, all looking identical. The lore said replicas were "manufactured, catalogued, and permanently sealed," while the real fruit "still possesses the power to awaken itself">

I ran `ls -la` and `file *` across the sectors. Sure enough, one file stood out — it was the only one that was actually **executable**, while the rest were static, permission-locked data. I fed that file into the provided `eat.sh>

```bash
./eat.sh <real_fruit_file>
```

This decrypted an `AWAKENING_SIGNATURE` — a string I'd need to hold onto for later levels.

---
