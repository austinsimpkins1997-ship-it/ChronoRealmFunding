from pathlib import Path
import hashlib, sys

ROOT = Path(__file__).resolve().parent
manifest = ROOT / "PUBLIC_RELEASE_SHA256SUMS.txt"

def sha256(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for c in iter(lambda: f.read(1024*1024), b""):
            h.update(c)
    return h.hexdigest()

bad = []
count = 0
for line in manifest.read_text(encoding="utf-8").splitlines():
    if not line.strip():
        continue
    count += 1
    expected, rel = line.split("  ", 1)
    p = ROOT / rel
    if not p.exists():
        bad.append((rel, "MISSING"))
        continue
    got = sha256(p)
    if got.lower() != expected.lower():
        bad.append((rel, f"BAD HASH {got}"))

if bad:
    print("PUBLIC RELEASE VERIFY: FAIL")
    for rel, err in bad:
        print(f" - {rel}: {err}")
    sys.exit(1)

print("PUBLIC RELEASE VERIFY: PASS")
print(f"Verified {count} files.")
