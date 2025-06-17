from __future__ import annotations
import argparse, pathlib, sys

Q = 12289                       

def parse_line(line: str, expect: int) -> list[int]:
    vals = line.strip().split()
    if len(vals) != expect:
        sys.exit(f"格式錯誤：期待 {expect} 整數，實得 {len(vals)} → {line}")
    return [int(v) for v in vals]

def mod_add(a: int, b: int) -> int:
    """(a + b) mod Q，以條件減法實作"""
    tmp = a + b - Q
    if tmp < 0:          
        tmp += Q
    return tmp          

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("-i", "--in-dir",  type=pathlib.Path, default=".",
                    help="輸入資料夾（預設 .）")
    ap.add_argument("-o", "--out-dir", type=pathlib.Path, default=".",
                    help="輸出資料夾（預設 .）")
    args = ap.parse_args()

    indir  = args.in_dir
    outdir = args.out_dir
    outdir.mkdir(parents=True, exist_ok=True)

    with (indir / "A64check.dat").open() as fA, \
         (indir / "B64check.dat").open() as fB, \
         (outdir / "goldencheck.dat").open("w") as fG:

        line_cnt = 0
        while True:
            Aline = fA.readline()
            Bline = fB.readline()
            if not Aline:            
                break

            line_cnt += 1
            Avals = parse_line(Aline, 1)
            Bvals = parse_line(Bline, 1)

            Rvals = [mod_add(a, b) for a, b in zip(Avals, Bvals)]

            fG.write(" ".join(str(v) for v in Rvals) + "\n")

    print(f"[make_golden_add] ✔ 已處理 {line_cnt} 行 → {outdir/'goldencheck.dat'}")

if __name__ == "__main__":
    main()
