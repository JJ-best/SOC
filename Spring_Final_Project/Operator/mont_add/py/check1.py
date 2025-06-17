import random
import argparse
import pathlib
import time

def rand16() -> int:
    """回傳 0‥65535 的隨機整數"""
    return random.randint(0, 0x3001)

def main() -> None:
    ap = argparse.ArgumentParser(
        description="產生 A64check.dat / B64check.dat 測試檔"
    )
    ap.add_argument(
        "-n", "--num", type=int, default=20,
        help="pattern 數量 (預設 200)"
    )
    ap.add_argument(
        "-o", "--out", type=pathlib.Path, default=".",
        help="輸出資料夾 (預設當前目錄)"
    )
    ap.add_argument(
        "--seed", type=int,
        help="隨機種子 (不給則每次隨機)"
    )
    args = ap.parse_args()

    if args.seed is not None:
        random.seed(args.seed)            
    else:
        random.seed(time.time_ns())      

    out_dir: pathlib.Path = args.out
    out_dir.mkdir(parents=True, exist_ok=True)

    
    with (out_dir / "A64check.dat").open("w") as fA, \
         (out_dir / "B64check.dat").open("w") as fB:

        for _ in range(args.num):
            Aseg = [rand16() for _ in range(1)]   
            Bseg = [rand16() for _ in range(1)]   
            fA.write(" ".join(map(str, Aseg)) + "\n")
            fB.write(" ".join(map(str, Bseg)) + "\n")

    print(f"[generate_input_check] ✔ 已寫入 {args.num} 筆至 {out_dir.resolve()}")

if __name__ == "__main__":
    main()
