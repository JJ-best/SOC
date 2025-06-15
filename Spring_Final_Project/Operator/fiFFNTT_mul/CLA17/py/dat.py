# make_num_files_signed_33.py
# 產生 ±2^k (k ≤ 32) 共 N 筆
import random

N       = 1000   # 筆數
MAX_EXP = 16     # 0‥32 → 33bit 範圍

def gen_pm_powers(n, max_exp):
    powers = [1 << k for k in range(max_exp + 1)]
    return [p if random.getrandbits(1) else -p for p in random.choices(powers, k=n)]

def dump(fname, data):
    with open(fname, 'w') as f:
        for x in data: f.write(f"{x}\n")

num1 = gen_pm_powers(N, MAX_EXP)
num2 = gen_pm_powers(N, MAX_EXP)
dump("num1.dat", num1)
dump("num2.dat", num2)
print(f"✅ 產生完畢：±2^0…±2^{MAX_EXP} 共 {N} 筆")
