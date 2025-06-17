import argparse, pathlib

def convert_file(fin: pathlib.Path, fout: pathlib.Path, sep: str) -> None:
    with fin.open() as fi, fout.open("w") as fo:
        for line in fi:
            for word in line.split():                
                hexstr = f"{int(word)&0xFFFF:04X}"  
                fo.write(hexstr + sep)
            fo.write("\n")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-i", "--in-dir",  type=pathlib.Path, default=".")
    ap.add_argument("-o", "--out-dir", type=pathlib.Path, default=".")
    ap.add_argument("--sep", choices=["space", "underscore"],
                    default="underscore",
                    help="欄內分隔符 (space / underscore)")
    args = ap.parse_args()

    sep = " " if args.sep == "space" else "_"
    indir, outdir = args.in_dir, args.out_dir
    outdir.mkdir(parents=True, exist_ok=True)

    files = [("A64check.dat", "A16.dat"),
             ("B64check.dat", "B16.dat"),
             ("goldencheck.dat", "golden16.dat")]

    for src, dst in files:
        convert_file(indir/src, outdir/dst, sep)

    print(f"[check2dat] ✔ 已轉檔到 {outdir.resolve()} (16-bit/word)")

if __name__ == "__main__":
    main()
