# Quête 7 : Trivy

Attention : Afin de ne pas renseigner de secret dans le script, celui-ci utilise un fichier `.env`.
Pensez à créer celui-ci avant de lancer le script, en utilisant `.env.example` comme base.

## Prérequis

Installés sur la machine : 
- Docker & Docker Compose

Copier le fichier de variables d'environnements et en modifier les valeurs :
```bash
cp demo-api/.env.example demo-api/.env
```

Créer le fichier contenant le mdp de la base (en remplaçant `valeur` par le vrai mdp) : 
```
mkdir -p demo-api/secrets
echo "valeur" > secrets/db_password.txt
```

## Extraits des scans

`demo-api/scan-after.txt` :
```txt
demo-api:multi (alpine 3.20.3)
==============================
Total: 21 (HIGH: 19, CRITICAL: 2)

┌────────────┬────────────────┬──────────┬────────┬───────────────────┬───────────────┬──────────────────────────────────────────────────────────────┐
│  Library   │ Vulnerability  │ Severity │ Status │ Installed Version │ Fixed Version │                            Title                             │
├────────────┼────────────────┼──────────┼────────┼───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ libcrypto3 │ CVE-2026-31789 │ CRITICAL │ fixed  │ 3.3.2-r0          │ 3.3.7-r0      │ openssl: OpenSSL: Heap buffer overflow on 32-bit systems     │
│            │                │          │        │                   │               │ from large X.509 certificate...                              │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-31789                   │
│            ├────────────────┼──────────┤        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│            │ CVE-2024-12797 │ HIGH     │        │                   │ 3.3.3-r0      │ openssl: RFC7250 handshakes with unauthenticated servers     │
│            │                │          │        │                   │               │ don't abort as expected                                      │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2024-12797                   │
│            ├────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│            │ CVE-2025-15467 │          │        │                   │ 3.3.6-r0      │ openssl: OpenSSL: Remote code execution or Denial of Service │
│            │                │          │        │                   │               │ via oversized Initialization...                              │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2025-15467                   │
│            ├────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│            │ CVE-2025-69421 │          │        │                   │               │ openssl: OpenSSL: Denial of Service via malformed PKCS#12    │
│            │                │          │        │                   │               │ file processing                                              │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2025-69421                   │
│            ├────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-28387 │          │        │                   │ 3.3.7-r0      │ openssl: OpenSSL: Arbitrary code execution due to            │
│            │                │          │        │                   │               │ use-after-free in DANE TLSA authentication...                │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-28387                   │
│            ├────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-28388 │          │        │                   │               │ openssl: OpenSSL: Denial of Service due to NULL pointer      │
│            │                │          │        │                   │               │ dereference in delta...                                      │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-28388                   │
│            ├────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-28389 │          │        │                   │               │ openssl: OpenSSL: Denial of Service vulnerability in CMS     │
│            │                │          │        │                   │               │ processing                                                   │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-28389                   │
│            ├────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-28390 │          │        │                   │               │ openssl: OpenSSL: Denial of Service due to NULL pointer      │
│            │                │          │        │                   │               │ dereference in CMS...                                        │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-28390                   │
├────────────┼────────────────┼──────────┤        │                   │               ├──────────────────────────────────────────────────────────────┤
│ libssl3    │ CVE-2026-31789 │ CRITICAL │        │                   │               │ openssl: OpenSSL: Heap buffer overflow on 32-bit systems     │
│            │                │          │        │                   │               │ from large X.509 certificate...                              │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-31789                   │
│            ├────────────────┼──────────┤        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│            │ CVE-2024-12797 │ HIGH     │        │                   │ 3.3.3-r0      │ openssl: RFC7250 handshakes with unauthenticated servers     │
│            │                │          │        │                   │               │ don't abort as expected                                      │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2024-12797                   │
│            ├────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│            │ CVE-2025-15467 │          │        │                   │ 3.3.6-r0      │ openssl: OpenSSL: Remote code execution or Denial of Service │
│            │                │          │        │                   │               │ via oversized Initialization...                              │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2025-15467                   │
│            ├────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│            │ CVE-2025-69421 │          │        │                   │               │ openssl: OpenSSL: Denial of Service via malformed PKCS#12    │
│            │                │          │        │                   │               │ file processing                                              │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2025-69421                   │
│            ├────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-28387 │          │        │                   │ 3.3.7-r0      │ openssl: OpenSSL: Arbitrary code execution due to            │
│            │                │          │        │                   │               │ use-after-free in DANE TLSA authentication...                │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-28387                   │
│            ├────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-28388 │          │        │                   │               │ openssl: OpenSSL: Denial of Service due to NULL pointer      │
│            │                │          │        │                   │               │ dereference in delta...                                      │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-28388                   │
│            ├────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-28389 │          │        │                   │               │ openssl: OpenSSL: Denial of Service vulnerability in CMS     │
│            │                │          │        │                   │               │ processing                                                   │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-28389                   │
│            ├────────────────┤          │        │                   │               ├──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-28390 │          │        │                   │               │ openssl: OpenSSL: Denial of Service due to NULL pointer      │
│            │                │          │        │                   │               │ dereference in CMS...                                        │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-28390                   │
├────────────┼────────────────┤          │        ├───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ musl       │ CVE-2025-26519 │          │        │ 1.2.5-r0          │ 1.2.5-r1      │ musl libc 0.9.13 through 1.2.5 before 1.2.6 has an           │
│            │                │          │        │                   │               │ out-of-bounds write ......                                   │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2025-26519                   │
│            ├────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-40200 │          │        │                   │ 1.2.5-r3      │ musl: musl libc: Arbitrary code execution and denial of      │
│            │                │          │        │                   │               │ service via stack-based...                                   │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-40200                   │
├────────────┼────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│ musl-utils │ CVE-2025-26519 │          │        │                   │ 1.2.5-r1      │ musl libc 0.9.13 through 1.2.5 before 1.2.6 has an           │
│            │                │          │        │                   │               │ out-of-bounds write ......                                   │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2025-26519                   │
│            ├────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│            │ CVE-2026-40200 │          │        │                   │ 1.2.5-r3      │ musl: musl libc: Arbitrary code execution and denial of      │
│            │                │          │        │                   │               │ service via stack-based...                                   │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-40200                   │
├────────────┼────────────────┤          │        ├───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ zlib       │ CVE-2026-22184 │          │        │ 1.3.1-r1          │ 1.3.2-r0      │ zlib: zlib: Arbitrary code execution via buffer overflow in  │
│            │                │          │        │                   │               │ untgz utility                                                │
│            │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-22184                   │
└────────────┴────────────────┴──────────┴────────┴───────────────────┴───────────────┴──────────────────────────────────────────────────────────────┘

Node.js (node-pkg)
==================
Total: 33 (HIGH: 30, CRITICAL: 3)

┌────────────────────────────────┬─────────────────┬──────────┬────────┬───────────────────┬─────────────────────────────────────────────────────────┬─────────────────────────────────────────────────────────────┐
│            Library             │  Vulnerability  │ Severity │ Status │ Installed Version │                      Fixed Version                      │                            Title                            │
├────────────────────────────────┼─────────────────┼──────────┼────────┼───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ body-parser (package.json)     │ CVE-2026-111181 │ HIGH     │ fixed  │ 1.20.8            │ 2.4.0, 1.20.9                                           │ body-parser: body-parser: Denial of Service via unhandled   │
│                                │                 │          │        │                   │                                                         │ decompression stream error                                  │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-111181                 │
├────────────────────────────────┼─────────────────┤          │        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ brace-expansion (package.json) │ CVE-2026-102276 │          │        │ 2.0.1             │ 5.0.10, 3.0.7, 2.1.5, 1.1.19                            │ brace-expansion: brace-expansion: Denial of Service via     │
│                                │                 │          │        │                   │                                                         │ stack exhaustion from crafted brace patterns...             │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-102276                 │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-102278 │          │        │                   │ 5.0.11, 3.0.8, 2.1.6, 1.1.20                            │ brace-expansion: brace-expansion: Denial of Service via     │
│                                │                 │          │        │                   │                                                         │ uncontrolled recursion in nested brace patterns...          │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-102278                 │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-13149  │          │        │                   │ 5.0.7, 1.1.16, 2.1.2                                    │ brace-expansion: Brace-expansion: Denial of Service due to  │
│                                │                 │          │        │                   │                                                         │ exponential-time complexity                                 │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-13149                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-14257  │          │        │                   │ 5.0.8, 3.0.3, 2.1.3, 1.1.17                             │ brace-expansion: Brace-expansion: Denial of Service via     │
│                                │                 │          │        │                   │                                                         │ memory exhaustion in expand() function                      │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-14257                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-69152  │          │        │                   │ 1.1.18, 2.1.4, 3.0.6, 5.0.9                             │ brace-expansion: DoS via unbounded intermediate arrays,     │
│                                │                 │          │        │                   │                                                         │ bypassing the CVE-2026-14257 mitigation                     │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-69152                  │
├────────────────────────────────┼─────────────────┤          │        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ cross-spawn (package.json)     │ CVE-2024-21538  │          │        │ 7.0.3             │ 7.0.5, 6.0.6                                            │ cross-spawn: regular expression denial of service           │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2024-21538                  │
├────────────────────────────────┼─────────────────┤          │        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ glob (package.json)            │ CVE-2025-64756  │          │        │ 10.4.5            │ 11.1.0, 10.5.0                                          │ glob: glob: Command Injection Vulnerability via Malicious   │
│                                │                 │          │        │                   │                                                         │ Filenames                                                   │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2025-64756                  │
├────────────────────────────────┼─────────────────┤          │        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ ip-address (package.json)      │ CVE-2026-69192  │          │        │ 9.0.5             │ 10.3.1                                                  │ ip-address: ip-address: Inconsistent IP address parsing     │
│                                │                 │          │        │                   │                                                         │ leads to Server-Side Request Forgery (SSRF)...              │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-69192                  │
├────────────────────────────────┼─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ minimatch (package.json)       │ CVE-2026-26996  │          │        │                   │ 10.2.1, 9.0.6, 8.0.5, 7.4.7, 6.2.1, 5.1.7, 4.2.4, 3.1.3 │ minimatch: minimatch: Denial of Service via specially       │
│                                │                 │          │        │                   │                                                         │ crafted glob patterns                                       │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-26996                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-27903  │          │        │                   │ 10.2.3, 9.0.7, 8.0.6, 7.4.8, 6.2.2, 5.1.8, 4.2.5, 3.1.3 │ minimatch: minimatch: Denial of Service due to unbounded    │
│                                │                 │          │        │                   │                                                         │ recursive backtracking via crafted...                       │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-27903                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-27904  │          │        │                   │ 10.2.3, 9.0.7, 8.0.6, 7.4.8, 6.2.2, 5.1.8, 4.2.5, 3.1.4 │ minimatch: Minimatch: Denial of Service via catastrophic    │
│                                │                 │          │        │                   │                                                         │ backtracking in glob expressions                            │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-27904                  │
├────────────────────────────────┼─────────────────┤          │        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ pacote (package.json)          │ CVE-2026-9496   │          │        │ 19.0.0            │ 21.5.1                                                  │ pacote: Pacote: Denial of Service via crafted spec.rawSpec  │
│                                │                 │          │        │                   │                                                         │ value in addGitSha function...                              │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-9496                   │
├────────────────────────────────┼─────────────────┼──────────┤        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ proxy-addr (package.json)      │ CVE-2026-90711  │ CRITICAL │        │ 2.0.7             │ 2.0.8                                                   │ proxy-addr: proxy-addr vulnerable to IP spoofing via        │
│                                │                 │          │        │                   │                                                         │ IPv4-mapped IPv6 trust subnet                               │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-90711                  │
├────────────────────────────────┼─────────────────┼──────────┤        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ sigstore (package.json)        │ CVE-2026-48815  │ HIGH     │        │ 2.3.1             │ 4.1.1                                                   │ sigstore: Sigstore: Unauthorized certificates accepted due  │
│                                │                 │          │        │                   │                                                         │ to ignored `certificateOIDs` verification option            │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-48815                  │
├────────────────────────────────┼─────────────────┼──────────┤        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│ tar (package.json)             │ CVE-2026-59873  │ CRITICAL │        │ 6.2.1             │ 7.5.19                                                  │ tar: node-tar: Denial of Service via crafted gzip bomb      │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-59873                  │
│                                ├─────────────────┼──────────┤        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-23745  │ HIGH     │        │                   │ 7.5.3                                                   │ node-tar: tar: node-tar: Arbitrary file overwrite and       │
│                                │                 │          │        │                   │                                                         │ symlink poisoning via unsanitized linkpaths...              │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-23745                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-23950  │          │        │                   │ 7.5.4                                                   │ node-tar: tar: node-tar: Arbitrary file overwrite via       │
│                                │                 │          │        │                   │                                                         │ Unicode path collision race condition...                    │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-23950                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-24842  │          │        │                   │ 7.5.7                                                   │ node-tar: tar: node-tar: Arbitrary file creation via path   │
│                                │                 │          │        │                   │                                                         │ traversal bypass in hardlink...                             │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-24842                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-26960  │          │        │                   │ 7.5.8                                                   │ node-tar: node-tar: Arbitrary file read/write via malicious │
│                                │                 │          │        │                   │                                                         │ archive hardlink creation                                   │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-26960                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-29786  │          │        │                   │ 7.5.10                                                  │ node-tar: hardlink path traversal via drive-relative        │
│                                │                 │          │        │                   │                                                         │ linkpath                                                    │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-29786                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-31802  │          │        │                   │ 7.5.11                                                  │ tar: tar: File overwrite via drive-relative symlink         │
│                                │                 │          │        │                   │                                                         │ traversal                                                   │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-31802                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-59874  │          │        │                   │ 7.5.18                                                  │ tar: Node-tar: Denial of Service via malformed tar archive  │
│                                │                 │          │        │                   │                                                         │ header                                                      │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-59874                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-73566  │          │        │                   │ 7.5.21                                                  │ tar: node-tar: Denial of Service via crafted long-path tar  │
│                                │                 │          │        │                   │                                                         │ archive                                                     │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-73566                  │
│                                ├─────────────────┼──────────┤        ├───────────────────┼─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-59873  │ CRITICAL │        │ 7.4.3             │ 7.5.19                                                  │ tar: node-tar: Denial of Service via crafted gzip bomb      │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-59873                  │
│                                ├─────────────────┼──────────┤        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-23745  │ HIGH     │        │                   │ 7.5.3                                                   │ node-tar: tar: node-tar: Arbitrary file overwrite and       │
│                                │                 │          │        │                   │                                                         │ symlink poisoning via unsanitized linkpaths...              │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-23745                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-23950  │          │        │                   │ 7.5.4                                                   │ node-tar: tar: node-tar: Arbitrary file overwrite via       │
│                                │                 │          │        │                   │                                                         │ Unicode path collision race condition...                    │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-23950                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-24842  │          │        │                   │ 7.5.7                                                   │ node-tar: tar: node-tar: Arbitrary file creation via path   │
│                                │                 │          │        │                   │                                                         │ traversal bypass in hardlink...                             │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-24842                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-26960  │          │        │                   │ 7.5.8                                                   │ node-tar: node-tar: Arbitrary file read/write via malicious │
│                                │                 │          │        │                   │                                                         │ archive hardlink creation                                   │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-26960                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-29786  │          │        │                   │ 7.5.10                                                  │ node-tar: hardlink path traversal via drive-relative        │
│                                │                 │          │        │                   │                                                         │ linkpath                                                    │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-29786                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-31802  │          │        │                   │ 7.5.11                                                  │ tar: tar: File overwrite via drive-relative symlink         │
│                                │                 │          │        │                   │                                                         │ traversal                                                   │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-31802                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-59874  │          │        │                   │ 7.5.18                                                  │ tar: Node-tar: Denial of Service via malformed tar archive  │
│                                │                 │          │        │                   │                                                         │ header                                                      │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-59874                  │
│                                ├─────────────────┤          │        │                   ├─────────────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤
│                                │ CVE-2026-73566  │          │        │                   │ 7.5.21                                                  │ tar: node-tar: Denial of Service via crafted long-path tar  │
│                                │                 │          │        │                   │                                                         │ archive                                                     │
│                                │                 │          │        │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-73566                  │
└────────────────────────────────┴─────────────────┴──────────┴────────┴───────────────────┴─────────────────────────────────────────────────────────┴─────────────────────────────────────────────────────────────┘
```

`demo-api/scan-after.txt` :
```txt
Report Summary

┌───────────────────────────────────────────────────────┬──────────┬─────────────────┬─────────┐
│                        Target                         │   Type   │ Vulnerabilities │ Secrets │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ demo-api:multi (alpine 3.23.7)                        │  alpine  │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/accepts/package.json                 │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/array-flatten/package.json           │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/body-parser/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/bytes/package.json                   │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/call-bind-apply-helpers/package.json │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/call-bound/package.json              │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/content-disposition/package.json     │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/content-type/package.json            │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/cookie-signature/package.json        │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/cookie/package.json                  │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/debug/package.json                   │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/depd/package.json                    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/destroy/package.json                 │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/dunder-proto/package.json            │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/ee-first/package.json                │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/encodeurl/package.json               │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/es-define-property/package.json      │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/es-errors/package.json               │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/es-object-atoms/package.json         │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/escape-html/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/etag/package.json                    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/express/package.json                 │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/finalhandler/package.json            │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/forwarded/package.json               │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/fresh/package.json                   │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/function-bind/package.json           │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/get-intrinsic/package.json           │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/get-proto/package.json               │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/gopd/package.json                    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/has-symbols/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/hasown/package.json                  │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/http-errors/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/iconv-lite/package.json              │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/inherits/package.json                │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/ipaddr.js/package.json               │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/math-intrinsics/package.json         │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/media-typer/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/merge-descriptors/package.json       │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/methods/package.json                 │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/mime-db/package.json                 │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/mime-types/package.json              │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/mime/package.json                    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/ms/package.json                      │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/negotiator/package.json              │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/object-inspect/package.json          │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/on-finished/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/parseurl/package.json                │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/path-to-regexp/package.json          │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/pg-cloudflare/package.json           │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/pg-connection-string/package.json    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/pg-int8/package.json                 │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/pg-pool/package.json                 │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/pg-protocol/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/pg-types/package.json                │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/pg/package.json                      │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/pgpass/package.json                  │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/postgres-array/package.json          │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/postgres-bytea/package.json          │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/postgres-date/package.json           │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/postgres-interval/package.json       │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/proxy-addr/package.json              │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/qs/package.json                      │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/range-parser/package.json            │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/raw-body/package.json                │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/safe-buffer/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/safer-buffer/package.json            │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/send/node_modules/ms/package.json    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/send/package.json                    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/serve-static/package.json            │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/setprototypeof/package.json          │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/side-channel-list/package.json       │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/side-channel-map/package.json        │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/side-channel-weakmap/package.json    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/side-channel/package.json            │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/split2/package.json                  │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/statuses/package.json                │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/toidentifier/package.json            │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/type-is/package.json                 │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/unpipe/package.json                  │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/utils-merge/package.json             │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/vary/package.json                    │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/node_modules/xtend/package.json                   │ node-pkg │        0        │    -    │
├───────────────────────────────────────────────────────┼──────────┼─────────────────┼─────────┤
│ app/package.json                                      │ node-pkg │        0        │    -    │
└───────────────────────────────────────────────────────┴──────────┴─────────────────┴─────────┘
```

## Preuves du fonctionnement 

Pipeline échouée : [ici](https://github.com/mzribel/CORBEL-Marianne_M2-Docker/actions/runs/40851560116)

Pipeline corrigée et valide : [ici](https://github.com/mzribel/CORBEL-Marianne_M2-Docker/actions/runs/40851984138)
