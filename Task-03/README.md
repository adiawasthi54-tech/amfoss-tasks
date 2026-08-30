# LeetCode Solutions — My Explanations

These are my explanations for the 5 problems I solved. I tried to explain them in simple words, the way I actually understood them while writing the code.

---

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

### My Explanation

Basically the question says we have a list of numbers and we need to find two numbers that add up to the target. So the easiest way I thought of was to just check every pair of numbers one by one and see if they add up to the target. That's what this code does.

- First I made `t = target` just so its shorter to write (not really needed tbh).
- Then I use two `for` loops. The first loop `i` goes through each number.
- The second loop `j` starts from `i+1` so that we don't check the same number twice and also don't add a number to itself.
- Inside, I check `if nums[i]+nums[j]==t`, if this is true it means we found our answer so I return `[i, j]` which are the two positions.
- The `else: continue` doesn't really do anything special, it just goes to next loop anyway even without writing it, I just added it because I was following a pattern I saw somewhere.
- If nothing matches after checking all pairs, I return `(-1, -1)` to show no answer found.

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

            if (l1 is not None and l1.next is not None) or (l2 is not None and l2.next is not None) or c!= 0:
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

### My Explanation

This question is about adding two numbers but the numbers are given as linked lists, and the digits are stored backwards (like ones digit first). So this was a bit confusing at first but it's basically the same as normal addition we do by hand, just digit by digit.

- I made a new empty node `l` to start building my answer list, and I saved `head = l` because I need to return the starting node at the end (since `l` keeps moving forward as I add nodes).
- `c` is my carry variable, like when we add 7+8=15 we write 5 and carry the 1 — same idea here.
- The while loop keeps running as long as there's still digits left in `l1` or `l2`, or there's a leftover carry that still needs to be added somewhere.
- Since l1 and l2 might not be same length, I check `if l1 is not None` — if it has a value I take it, otherwise I just treat it as 0 (basically pretend that list has ended so add 0).
- Then I just add `l1_val + l2_val + c` to get sum `s`.
- `c = s // 10` gives me the new carry (this will be 0 or 1 since max digit sum is 9+9+1=19).
- I set `l.val` to `s % 10` (I did this in an if-else but actually it works even without the if, silly mistake on my part, could've just written `l.val = s % 10` directly).
- After that I check if I need to make a new node — only if there's more digits left in l1/l2, or if theres still a carry left. If yes, I make a new node and move `l` to point to it.
- At the end I move `l1` and `l2` to their next node (if they exist).
- Finally I return `head`, not `l`, because `l` moved all over the place but `head` always points to the start.

---

## 3. Roman to Integer

```python
class Solution:
    def romanToInt(self, s: str) -> int:
        prev = ""
        a = 0
        for i in s:
            if prev == "I" and i == "V":
                a+=4
                a-=1
            elif prev == "I" and i == "X":
                a+=9
                a-=1
            elif prev == "X" and i == "L":
                a+=40
                a-=10
            elif prev == "X" and i == "C":
                a+=90
                a-=10
            elif prev == "C" and i == "D":
                a+=400
                a-=100
            elif prev == "C" and i == "M":
                a+=900
                a-=100
            elif i=="I":
                a+=1
            elif i=="V":
                a+=5
            elif i=="X":
                a+=10
            elif i=="L":
                a+=50
            elif i=="C":
                a+=100
            elif i=="D":
                a+=500
            elif i=="M":
                a+=1000
            
            prev = i

        return a
```

### My Explanation

This is opposite of Integer to Roman, here we get a roman numeral string and have to convert it to a normal number. The tricky part is stuff like "IV" which means 4, not "I" + "V" = 6, because when a smaller letter comes before a bigger letter, we have to subtract instead of add.

- `prev` keeps track of the last letter I saw, and `a` is where I store my answer as I go.
- I go through the string letter by letter using `for i in s`.
- First I check all the special "subtraction" cases like IV, IX, XL, XC, CD, CM. The reason I do `a+=4` then `a-=1` for IV, is because on the previous loop when I saw just "I" alone, I already added 1 to `a`. So now when I realize its actually "IV" not just standalone I's, I add the correct value (4) and then subtract the 1 I wrongly added before. It kinda cancels out and gives correct answer.
- If none of the special cases match, then I just check what letter it is and add its normal value (I=1, V=5, X=10, etc).
- At the end of every loop I update `prev = i` so next time I can compare with this letter.
- Finally I return `a`.

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

### My Explanation

For this one I made a list `val_sym` which has all the roman numeral values and their symbols, starting from biggest (1000) to smallest (1). I also added the special subtraction cases like 900="CM", 400="CD" etc directly in this list, and put them BEFORE their normal counterpart (like 900 before 500) so that the code checks for them first.

- I loop through this list one pair at a time.
- `divmod(num, value)` is a cool function I found — it gives me two things together: how many times `value` fits inside `num` (that's `count`), and what's left over (which becomes the new `num`).
- Then `symbol * count` just repeats the symbol that many times, like `"X" * 2` gives `"XX"`. If count is 0 it just adds nothing.
- I keep doing this for every value in the list, and if `num` becomes 0 I stop early since there's nothing left to convert.
- At the end I just join everything together into one final string.

I think the reason this automatically follows the rule of "don't repeat a symbol more than 3 times" is because I already put the subtraction versions in the list before their normal version. So like once num has 4 or more hundreds, the (400, "CD") check happens first and takes care of it before reaching (100, "C").
---

## 5. Palindrome Number

### Way 1 — using strings (easier way)

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0:
            return False
        s = str(x)
        return s == s[::-1]
```

### My Explanation

This one was straightforward. A palindrome means the number reads the same forwards and backwards, like 121 or 1221.

- First I check if `x` is negative, because if it is, it can never be a palindrome (the minus sign messes it up, like -121 reversed would be 121- which isn't even valid).
- Then I just convert the number to a string using `str(x)`.
- `s[::-1]` is a trick in python to reverse a string, I learned this reverses it by going backwards.
- I just compare if original string equals the reversed string, if yes its a palindrome.

---

### Way 2 — without converting to string (bit harder, but cooler)

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

### My Explanation

This one I found while searching for a better way because I read somewhere they might ask "can you do it without converting to a string." So this method basically builds the reverse of the number using math instead of strings.

- Same as before, negative numbers are not palindromes. Also I added a check for numbers ending in 0 (like 10, 100), because if a number ends in 0, its reverse would start with 0 which isn't possible for real numbers (except 0 itself).
- I made a variable `reverted_half` which will slowly build up the reversed version of the second half of the number.
- In the while loop, `x % 10` gets me the last digit of x. Then `reverted_half * 10 + x % 10` basically shifts whatever was in reverted_half one place to the left and adds the new digit at the end. This is how you build up a number digit by digit.
- `x //= 10` removes the last digit from x since I already used it.
- I keep doing this loop only while `x > reverted_half`, because once reverted_half becomes equal or bigger, it means I've gone through about half the digits already, no need to keep going.
- At the end, if the number had even number of digits, x and reverted_half will match exactly. But if it had odd digits, reverted_half will have one extra middle digit, so I just divide it by 10 to remove that middle digit before comparing (because middle digit doesn't need to match anything in a palindrome).

---
