# gen_golden_34bit.py
# Author: Jesse  (產生 33/33/34-bit binary 測試檔)

MASK33 = (1 << 33) - 1          # 0x1FFFFFFFF

# ---------- 基本工具 ----------
def read_int_file(fname: str) -> list[int]:
    """讀取整數檔，每行一個 (允許空行)"""
    with open(fname, encoding="utf-8") as f:
        return [int(l.strip()) for l in f if l.strip()]

def int33_bin(x: int) -> str:
    """轉成 33-bit 二補數字串（含負數支援）"""
    return format(x & MASK33, "033b")

def add_33bit(a: int, b: int) -> tuple[int, int]:
    """
    33-bit 無號加法，回傳 (carry, sum33)
      carry = bit-33 (第 34 位)
      sum33 = 33-bit 低位結果
    """
    usum   = (a & MASK33) + (b & MASK33)
    carry  = (usum >> 33) & 1
    sum33  =  usum & MASK33
    return carry, sum33

# ---------- 產生 golden ----------
def write_golden(out: str, list1: list[int], list2: list[int]) -> None:
    with open(out, "w", encoding="utf-8") as f:
        for a, b in zip(list1, list2):
            c, s33 = add_33bit(a, b)
            result_bin = f"{c:b}{s33:033b}"   # 1 + 33 = 34 bits
            f.write(f"{int33_bin(a)} {int33_bin(b)} {result_bin}\n")

# ---------- 主程式 ----------
def main() -> None:
    num1 = read_int_file("num1.dat")
    num2 = read_int_file("num2.dat")
    assert len(num1) == len(num2), "num1.dat 與 num2.dat 行數不同"

    write_golden("golden.dat", num1, num2)
    print("✅ 已產生 golden.dat（格式：33b 33b 34b）")

if __name__ == "__main__":
    main()
