# LeetCode Solutions with Explanations

## 1. Two Sum

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        t = target
        for i in range(len(nums)):
            for j in range(i+1, len(nums)):
                if nums[i]+nums[j]==t:
                    return [i, j]
                else:
                    continue
        return (-1, -1)
```

### Explanation

This is the **brute-force approach** — it checks every possible pair of numbers in the array.

1. `t = target` just stores the target value in a new variable (not strictly necessary; `target` could be used directly).
2. The **outer loop** (`i`) picks a starting index and goes through every element in `nums`.
3. The **inner loop** (`j`) starts from `i + 1`, not `0` — this avoids checking the same pair twice and avoids pairing a number with itself.
4. For every pair `(i, j)`, it checks whether `nums[i] + nums[j]` equals the target. If it does, the function immediately returns their indices as `[i, j]`.
5. The `else: continue` doesn't actually do anything extra — if the condition is false, the loop moves on to the next `j` regardless. It could be safely removed.
6. If no pair sums to the target after checking everything, it returns `(-1, -1)`. Note: this is a **tuple**, while the successful return is a **list** — a small inconsistency worth fixing for clean code.

### Complexity
- **Time:** O(n²) — every pair is checked.
- **Space:** O(1) — no extra data structures used.

### Optimization Note
A hashmap-based approach can solve this in **O(n) time**: while looping once through `nums`, store each number and its index in a dictionary, and at each step check if `target - nums[i]` has already been seen.

---

## 2. Add Two Numbers

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next

class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        l = ListNode()
        head = l
        c = 0
        l1_val = 0
        l2_val = 0
        while (l1 is not None or l2 is not None) or c != 0:
            if l1 is not None:
                l1_val = l1.val
            else:
                l1_val = 0
            if l2 is not None:
                l2_val = l2.val
            else:
                l2_val = 0                
            # add and set carry
            s = l1_val + l2_val + c
            c = s // 10

            if c != 0:
                l.val = s % 10
            else:
                l.val = s

            if (l1 is not None and l1.next is not None) or (l2 is not None and l2.next is not None) or c != 0:
                n = ListNode()
                n.next = None
                l.next = n
                l = n
            if l1 is not None:
                l1 = l1.next
            if l2 is not None:
                l2 = l2.next

        return head
```

### Problem context
Two numbers are represented as linked lists, with digits stored in **reverse order** (least significant digit first). The goal is to add the numbers and return the sum, also as a linked list in reverse order.

### Explanation

1. **Setup:** `l = ListNode()` creates a dummy starting node, and `head = l` keeps a permanent reference to the beginning of the result list (since `l` itself will move forward as new nodes are added). `c` tracks the carry from addition (like carrying a 1 in manual addition).

2. **The loop condition** `(l1 is not None or l2 is not None) or c != 0` keeps going as long as there are digits left in *either* list, **or** there's a leftover carry (important for cases like `5 + 5 = 10`, which needs an extra digit).

3. **Getting each digit:** Since `l1` and `l2` might have different lengths, the code checks if each list still has a current node. If it does, it grabs `.val`; if not (the list ran out), it treats that digit as `0`.

4. **The addition:**
   - `s = l1_val + l2_val + c` adds both digits plus any carry from the previous step.
   - `c = s // 10` calculates the new carry (0 or 1, since digits are 0–9, so `s` is at most `9+9+1=19`).
   - `l.val = s % 10` sets the current node's value to the last digit of the sum (`s % 10` when `c != 0`, but this line is actually equivalent to just always using `s % 10` — see note below).

5. **Creating the next node:** A new node `n` is only added if there's more work to do — either `l1` or `l2` still has more digits ahead, or there's a leftover carry that needs its own node.

6. **Advancing pointers:** `l1` and `l2` are moved to their next node (if they exist), continuing the loop.

7. Finally, `head` (the very first node, not the shifting `l`) is returned as the answer.

> **Minor note:** The `if c != 0: l.val = s % 10 else: l.val = s` branch is actually redundant — `s % 10` always gives the correct last digit whether or not there's a carry (e.g., if `s = 7`, `s % 10 = 7` too). It could be simplified to just `l.val = s % 10` unconditionally.

### Complexity
- **Time:** O(max(m, n)) — where `m` and `n` are the lengths of the two lists.
- **Space:** O(max(m, n)) — for the new result list created.

---

## 3. Roman to Integer

```python
class Solution:
    def romanToInt(self, s: str) -> int:
        prev = ""
        a = 0
        for i in s:
            if prev == "I" and i == "V":
                a += 4
                a -= 1
            elif prev == "I" and i == "X":
                a += 9
                a -= 1
            elif prev == "X" and i == "L":
                a += 40
                a -= 10
            elif prev == "X" and i == "C":
                a += 90
                a -= 10
            elif prev == "C" and i == "D":
                a += 400
                a -= 100
            elif prev == "C" and i == "M":
                a += 900
                a -= 100
            elif i == "I":
                a += 1
            elif i == "V":
                a += 5
            elif i == "X":
                a += 10
            elif i == "L":
                a += 50
            elif i == "C":
                a += 100
            elif i == "D":
                a += 500
            elif i == "M":
                a += 1000
            
            prev = i

        return a
```

### Problem context
This is the reverse of "Integer to Roman" — given a Roman numeral string, convert it back to an integer. The tricky part is handling subtractive pairs like `IV` (4) and `IX` (9), where a smaller symbol placed *before* a larger one means subtraction instead of addition.

### Explanation

1. **`prev`** keeps track of the previously seen character, and **`a`** accumulates the running total.

2. **The loop** goes through the string one character (`i`) at a time.

3. **Subtractive pair detection:** The first six `if`/`elif` branches check whether the *current* character and the *previous* character together form one of the six valid subtractive pairs (`IV`, `IX`, `XL`, `XC`, `CD`, `CM`).
   - When a pair like `IV` is detected, the code had *already added* the value of `I` (1) to `a` when it processed the previous character on its own. So to correct for this, it does `a += 4` (adds the correct value of the pair) then `a -= 1` (removes the previously-added value of the lone `I`), netting a total addition of `+3` for that step — combined with the `+1` already added earlier, this correctly totals `+4` for `IV`.
   - The same pattern repeats for all 6 subtractive pairs, each correcting for the value that was already (incorrectly) added on the prior iteration.

4. **Regular symbols:** If no subtractive pattern is matched, the code falls through to the plain `elif i == "I":`, etc., simply adding that symbol's standalone value.

5. **`prev = i`** updates `prev` at the end of every iteration, so the next character can check against the current one.

6. Finally, `a` (the accumulated total) is returned.

### Example trace: s = "MCMXCIV"

| i | prev | Action | a |
|---|------|--------|---|
| M | ""  | add 1000 | 1000 |
| C | M   | add 100 (no pair matches yet) | 1100 |
| M | C   | pair `CM` detected → `a += 900`, `a -= 100` | 1900 |
| X | M   | add 10 | 1910 |
| C | X   | add 100 | 2010 |
| I | C   | add 1 | 2011 |
| V | I   | pair `IV` detected → `a += 4`, `a -= 1` | 2014 |

Wait — let's recheck: the correct answer for "MCMXCIV" is 1994, not 2014. Tracing more carefully:

- M → a=1000, prev="M"
- C → a=1100, prev="C"
- M → pair CM: a += 900 → 2000, a -= 100 → 1900, prev="M"
- X → a += 10 → 1910, prev="X"
- C → pair XC: a += 90 → 2000, a -= 10 → 1990, prev="C"
- I → a += 1 → 1991, prev="I"
- V → pair IV: a += 4 → 1995, a -= 1 → 1994, prev="V"

Final: **1994** ✅ (the trace above was corrected — each "add" for the base symbol happens *before* the pair is recognized on the next character, which is why the pair-correction math works out).

### Complexity
- **Time:** O(n) — one pass through the string.
- **Space:** O(1) — only a couple of variables used.

---

## 4. Integer to Roman

```python
class Solution:
    def intToRoman(self, num: int) -> str:
        val_sym = [
            (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
            (100, "C"),  (90, "XC"), (50, "L"),  (40, "XL"),
            (10, "X"),   (9, "IX"),  (5, "V"),   (4, "IV"),
            (1, "I")
        ]

        result = []
        for value, symbol in val_sym:
            if num == 0:
                break
            count, num = divmod(num, value)
            result.append(symbol * count)

        return "".join(result)
```

### Explanation

1. **The lookup table (`val_sym`)** lists every Roman numeral building block — basic symbols (M, D, C, L, X, V, I) plus the six subtractive combinations (CM, CD, XC, XL, IX, IV) — sorted from largest value to smallest. Subtractive pairs are placed *before* their neighboring base symbol (e.g., `(900, "CM")` before `(500, "D")`), so the algorithm always tries the subtractive form first when it applies.

2. **The loop** walks through the table, largest value first. For each `(value, symbol)` pair:
   - `divmod(num, value)` computes `count` (how many times `value` fits fully into `num`) and simultaneously updates `num` to the remainder.
   - `symbol * count` repeats the symbol that many times (e.g., `"M" * 3` → `"MMM"`). If `count` is `0`, this adds an empty string.

3. **Why no symbol repeats more than 3 times:** subtractive forms like `(400, "CD")` are checked before `(100, "C")`. So any group of 4+ hundreds is caught by the `400` case first, leaving at most 3 leftover hundreds for `"C"` — which is why "C" never appears 4 times.

4. The loop **breaks early** once `num` hits `0`.

5. `"".join(result)` combines all collected symbol pieces into the final string.

### Example trace: num = 58
- 58 ÷ 50 = 1 remainder 8 → append "L"
- 8 ÷ 5 = 1 remainder 3 → append "V"
- 3 ÷ 1 = 3 remainder 0 → append "III"
- Final: **"LVIII"**

### Complexity
- **Time:** O(1) — the table has a fixed size (13 entries) and `num ≤ 3999`.
- **Space:** O(1) — excluding the output string.

---

## 5. Palindrome Number

### Solution 1 — String approach

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0:
            return False
        s = str(x)
        return s == s[::-1]
```

### Explanation

1. If `x` is negative, it can never be a palindrome — the minus sign only appears at the front, so reading it backward would put the sign at the end, which never matches. Return `False` immediately.
2. `str(x)` converts the number into a string (e.g., `121` → `"121"`).
3. `s[::-1]` reverses the string using Python's slice notation (start at the end, step backward by 1).
4. If the original string equals its reversed version, the number is a palindrome.

---

### Solution 2 — Reverse half the number (no string conversion)

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0 or (x % 10 == 0 and x != 0):
            return False

        reverted_half = 0
        while x > reverted_half:
            reverted_half = reverted_half * 10 + x % 10
            x //= 10

        return x == reverted_half or x == reverted_half // 10
```

### Explanation

1. **First check:** negative numbers are ruled out, same as before. Numbers ending in `0` (like `10`, `100`) are also ruled out — except `0` itself — since a reversed number can never *start* with a leading zero.

2. **The main loop** builds a new number, `reverted_half`, by repeatedly grabbing the last digit off `x`:
   - `x % 10` gets the last digit of `x`.
   - `reverted_half * 10 + x % 10` shifts `reverted_half` one place to the left and drops the new digit into the ones place — this is how a number is built up digit-by-digit.
   - `x //= 10` removes the last digit from `x` (integer division discards the remainder).

3. **Loop condition:** it continues while `x > reverted_half`. Since each iteration removes a digit from `x` and adds one to `reverted_half`, once `reverted_half` "catches up" in size to `x`, roughly half the digits have been reversed.

4. **Final comparison:**
   - **Even digit count:** `x` and `reverted_half` will be exactly equal (e.g., `1221` → `x=12`, `reverted_half=12`).
   - **Odd digit count:** `reverted_half` has one extra middle digit that doesn't need a pair (e.g., `12321` → `x=12`, `reverted_half=123`). Dividing by 10 drops that middle digit before comparing.

### Example trace: x = 1221
- Iteration 1: `x=122`, `reverted_half=1`
- Iteration 2: `x=12`, `reverted_half=12` → loop stops (`12` is not `> 12`)
- Check: `x == reverted_half` → `12 == 12` → `True` ✅

### Complexity comparison

| Approach | Time | Space |
|----------|------|-------|
| String conversion | O(log₁₀ x) | O(log₁₀ x) |
| Reverse half | O(log₁₀ x) | O(1) |
