---
title: "How Tokenization Murders Your Model's Ability to Do Basic Math"
date: 2025-09-07T00:10:39+05:30
draft: False
comments: true
tags: ["Tokenisation"]
categories: ["AI Systems", "Engineering"]
---

# How Tokenization Murders Your Model's Ability to Do Basic Math

GPT-4o can write Shakespeare but struggles with 4-digit multiplication. It's not stupid, it literally can't see numbers the way you do. "12345" might be ["123", "45"] while "12346" is ["1", "2346"]. Try doing math when numbers randomly shatter into chunks.

> **TL;DR**: Tokenizers split numbers inconsistently, making arithmetic nearly impossible. "9.11" > "9.9" according to many models because ".11" and ".9" are different tokens. Your calculator app works. Your $100B language model doesn't. This is why.

## The Crime Scene: Test This Right Now

```python
# The murder weapon: inconsistent number tokenization
def number_tokenization_horror(tokenizer):
    """Watch tokenization destroy math ability"""
    
    numbers = [
        "1", "12", "123", "1234", "12345", "123456",
        "42", "420", "4200", "42000",
        "9.9", "9.11", "9.111",
        "2023", "2024", "2025",
        "1000000", "1,000,000", "1e6"
    ]
    
    print("Number → Tokens (How the model 'sees' it)")
    print("-" * 50)
    
    for num in numbers:
        tokens = tokenizer.encode(num)
        decoded = [tokenizer.decode([t]) for t in tokens]
        
        # The horror reveal
        if len(decoded) > 1:
            print(f"{num:10} → {decoded} 🔪 (MURDERED)")
        else:
            print(f"{num:10} → {decoded}")
    
    return "Your model can't do math because it can't even see numbers"

# Run this and watch the chaos
```

## The "9.11 > 9.9" Disaster (Yes, Really)

```python
# This actually happens in production:

comparisons = [
    ("9.9", "9.11"),    # 9.11 is SMALLER but models think it's bigger
    ("2.8", "2.80"),    # Same number, different tokens
    ("1000", "1,000"),  # Same number, different tokens
    ("3.14", "3.141"),  # π gets progressively worse
]

for a, b in comparisons:
    tokens_a = tokenizer.encode(a)
    tokens_b = tokenizer.encode(b)
    
    print(f"{a} → {tokens_a}")
    print(f"{b} → {tokens_b}")
    
    # Models compare TOKEN VALUES, not numerical values
    # "11" > "9" as a token, so 9.11 > 9.9
    # This is why your chatbot says 9.11 is bigger than 9.9

# THE KILLER: Version numbers
# "Python 3.9" vs "Python 3.11"
# Models think 3.11 < 3.9 because ".11" < ".9" as text
```

## Why Your Model Can't Count

```python
# The counting disaster:

def why_counting_fails(tokenizer):
    """Models can't count because they can't see sequences"""
    
    # Try to count from 1 to 20
    sequence = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20"
    tokens = tokenizer.encode(sequence)
    decoded = [tokenizer.decode([t]) for t in tokens]
    
    print("You see: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20")
    print(f"Model sees: {decoded}")
    
    # Reality: ['1', ' 2', ' 3', ..., ' 10', ' 11', ' 12', ' 13', ' 14', ' 15', ' 16', ' 17', ' 18', ' 19', ' 20']
    # Some are single tokens, some are split
    # Patterns are DESTROYED
    
    # Now try counting by 10s:
    by_tens = "10 20 30 40 50 60 70 80 90 100"
    tokens = tokenizer.encode(by_tens)
    decoded = [tokenizer.decode([t]) for t in tokens]
    
    print(f"Counting by 10s: {decoded}")
    # "10" might be 1 token, "20" might be 1 token, but "30" might be ["3", "0"]
    # No wonder it can't learn the pattern!

# This is why models fail at:
# - "Continue the sequence: 2, 4, 6, 8, ..."
# - "What comes after 99?"
# - "Count backwards from 10"
```

## The Arithmetic Apocalypse

```python
# Why GPT can't do basic math:

def arithmetic_tokenization_study(tokenizer):
    """See why 2+2 works but 1234+5678 doesn't"""
    
    problems = [
        "2+2",          # Perfect: ["2", "+", "2"]
        "10+10",        # Still OK: ["10", "+", "10"]
        "123+456",      # Getting bad: ["123", "+", "456"] or ["12", "3", "+", "45", "6"]
        "1234+5678",    # Disaster: ["123", "4", "+", "567", "8"]
        "12345+67890",  # Apocalypse: ["1", "234", "5", "+", "678", "90"]
    ]
    
    for problem in problems:
        tokens = tokenizer.encode(problem)
        decoded = [tokenizer.decode([t]) for t in tokens]
        
        # Calculate token chaos score
        expected_tokens = 3  # number, operator, number
        chaos_score = len(tokens) - expected_tokens
        
        if chaos_score == 0:
            status = "✅ Can solve"
        elif chaos_score <= 2:
            status = "⚠️ Might solve"
        else:
            status = "💀 Will fail"
        
        print(f"{problem:15} → {decoded:30} {status}")
    
    return "This is why calculators still exist"

# The bitter truth:
# o can write poetry about quantum physics
# But fails at 4-digit multiplication
# Because it literally cannot see "1234" as 1234
```

## The Decimal Disaster

```python
# Decimals are even worse:

decimal_nightmares = {
    "0.1": ["0", ".", "1"],           # 3 tokens for a simple decimal
    "0.01": ["0", ".", "01"],         # Inconsistent!
    "0.001": ["0", ".", "001"],       # Getting worse
    "3.14159": ["3", ".", "14", "159"], # π is shattered
    "2.718": ["2", ".", "7", "18"],   # e is broken
    "$19.99": ["$", "19", ".", "99"], # Prices are chaos
    "0.999...": ["0", ".", "999", "..."], # Math notation destroyed
}

# This is why:
# - Models think 0.9 > 0.11 (string comparison)
# - Can't properly handle financial calculations  
# - Fail at scientific notation
# - Think $19.99 and $20.00 are fundamentally different concepts
```

## The Date/Time Tokenization Massacre

```python
def datetime_tokenization_chaos(tokenizer):
    """Why models are terrible with dates and times"""
    
    dates = [
        "2023",           # Likely 1 token (common year)
        "2024",           # Might be 2 tokens
        "2025",           # Probably 2 tokens  
        "1999",           # 1-2 tokens (Y2K made it common)
        "2000",           # 1 token (millennium)
        "1823",           # 2-3 tokens (random year)
        "2024-01-01",     # 5-7 tokens
        "12/25/2023",     # 6-8 tokens
        "3:14 PM",        # 4-5 tokens
        "15:30:45",       # 5-7 tokens
    ]
    
    for date in dates:
        tokens = tokenizer.encode(date)
        if len(tokens) == 1:
            print(f"{date} → MEMORIZED (seen thousands of times)")
        else:
            decoded = [tokenizer.decode([t]) for t in tokens]
            print(f"{date} → {decoded} (fragmented perception)")
    
    # This explains why models:
    # - Can't calculate date differences
    # - Fail at "what day is 30 days from today?"
    # - Think 12/25 comes before 12/3 (string order)
    # - Can't handle timezone conversions
```

## The Phone Number Privacy Leak

```python
# Some phone numbers are single tokens (!!!)

def phone_number_investigation(tokenizer):
    """Some numbers are suspiciously well-tokenized"""
    
    numbers = [
        "911",            # Emergency (1 token)
        "1-800-273-8255", # Suicide hotline (might be few tokens)
        "867-5309",       # Jenny's number (cultural reference)
        "(555) 555-5555", # Movie/TV placeholder
        "+1234567890",    # Random number
    ]
    
    for number in numbers:
        tokens = len(tokenizer.encode(number))
        if tokens <= 3:
            print(f"🚨 {number} is {tokens} tokens - MEMORIZED IN TRAINING")
        else:
            print(f"{number} is {tokens} tokens")
    
    # If a phone number is <5 tokens, it appeared in training data
    # This is a privacy nightmare
```

## The Solution No One Wants to Hear

```python
class MathTokenizationWorkaround:
    """How to make models not suck at math"""
    
    def fix_arithmetic(self, expression):
        """Pre-tokenize numbers properly"""
        
        # Step 1: Space out everything
        # "1234+5678" → "1 2 3 4 + 5 6 7 8"
        spaced = ' '.join(expression)
        
        # Step 2: Use chain-of-thought
        prompt = f"""
        Solve step by step:
        {expression}
        
        First, identify the numbers:
        - First number: {expression.split('+')[0]}
        - Second number: {expression.split('+')[1]}
        
        Now add digit by digit...
        """
        
        # Step 3: Or just give up and use a calculator
        import re
        if re.match(r'^[\d\+\-\*/\.\s]+$', expression):
            result = eval(expression)  # Don't do this in production!
            return f"The answer is {result}"
        
        return "This is why we still need calculators"
    
    def fix_comparison(self, num1, num2):
        """Fix number comparison"""
        
        # Convert to actual numbers first
        prompt = f"""
        Compare these as decimal numbers:
        A = {num1} (decimal value: {float(num1)})
        B = {num2} (decimal value: {float(num2)})
        
        Therefore {float(num1)} {'>' if float(num1) > float(num2) else '<'} {float(num2)}
        """
        
        return prompt

# The harsh reality:
# We're using $100B language models
# But need to PRE-CALCULATE math for them
# Because they can't see numbers properly
```

## The Benchmarks That Lie

```python
# Why math benchmarks are misleading:

def benchmark_tokenization_bias():
    """GSM8K and other benchmarks use 'nice' numbers"""
    
    # Benchmark problems use:
    nice_numbers = ["2", "5", "10", "100", "1000"]  # All single tokens!
    
    # Real-world uses:
    real_numbers = ["1847", "3.14159", "$24.99", "2024-01-15"]  # All fragmented!
    
    print("Benchmark numbers (what models are tested on):")
    for n in nice_numbers:
        print(f"  {n} → {len(tokenizer.encode(n))} token(s)")
    
    print("\nReal-world numbers (what you actually need):")
    for n in real_numbers:
        print(f"  {n} → {len(tokenizer.encode(n))} token(s)")
    
    return "Models ace benchmarks, fail at your invoice calculations"
```

## The Uncomfortable Truth About Quantitative AI

**The paradox**: We're using language models for quantitative analysis, but they literally cannot perceive quantities consistently.

**What this means**:
- Financial models that can't compare prices
- Scientific models that fail at measurements
- Data analysis tools that can't count
- Coding assistants that mess up array indices

**The industry's dirty secret**: Everyone knows this, but we pretend it's fine because:
1. The models are "good enough" for text
2. We can work around it with prompting
3. Fixing it would require rebuilding everything

---

> **💡 Immediate Action**: Never trust a language model with math. Always verify numerical outputs. If you're building a financial or scientific application, pre-process all numbers into consistent tokens or use specialized numerical encodings.

---

**Takeaway:** Your $100B language model can't do 4th grade math because tokenization shatters numbers into random chunks. It's not learning arithmetic, it's pattern matching fragments. This is why "9.11 > 9.9" and why GPT-4o needs a calculator plugin. Until we fix tokenization, language models will remain quantitatively illiterate.
