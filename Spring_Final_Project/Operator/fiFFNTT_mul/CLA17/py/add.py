# gen_golden_17bit.py
# Author: Jesse   產生 17 / 17 / 18-bit binary 測試檔

WIDTH       = 17                     # operand bits
MASK        = (1 << WIDTH) - 1       # 0x1_FFFF

# ---------- 基本工具 ----------
def read_int_file(fname: str) -> list[int]:
    """讀取整數檔，每行一個整數，可含空行。"""
    with open(fname, encoding="utf-8") as f:
        return [int(l.strip()) for l in f if l.strip()]

def int17_bin(x: int) -> str:
    """轉成 17-bit 二補數字串（含負數支援）。"""
    return format(x & MASK, f"0{WIDTH}b")      # 017b

def add_17bit(a: int, b: int) -> tuple[int, int]:
    """
    17-bit 無號加法：(carry , sum17)
        carry = bit-17 (第 18 位)
        sum17 = 17-bit 低位結果
    """
    usum  = (a & MASK) + (b & MASK)
    carry = (usum >> WIDTH) & 1
    sum17 =  usum & MASK
    return carry, sum17

# ---------- 產生 golden ----------
def write_golden(out: str, list1: list[int], list2: list[int]) -> None:
    with open(out, "w", encoding="utf-8") as f:
        for a, b in zip(list1, list2):
            c, s17 = add_17bit(a, b)
            result_bin = f"{c:b}{s17:0{WIDTH}b}"    # 1 + 17 = 18 bits
            f.write(f"{int17_bin(a)} {int17_bin(b)} {result_bin}\n")

# ---------- 主程式 ----------
def main() -> None:
    num1 = read_int_file("num1.dat")
    num2 = read_int_file("num2.dat")
    assert len(num1) == len(num2), "num1.dat 與 num2.dat 行數不同"

    write_golden("golden.dat", num1, num2)
    print("✅ 已產生 golden.dat（格式：17b 17b 18b）")

if __name__ == "__main__":
    main()
