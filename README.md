# 🚀 Bun Replacements for Node, NPM, and NPX

Replace `node`, `npm`, and `npx` with `bun` and `bunx` for faster JavaScript workflows. These shell scripts mimic version outputs so tools/scripts that check versions still work. ✨

## ⚡ Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/saeedtahmtan/bun-replace/main/install.sh | bash
```

This will download the scripts to `~/bin` and add them to your `PATH`.

## 📦 What You Get

| Command | Replaces With | Reported Version |
|---------|---------------|------------------|
| `node`  | `bun`         | v26.2.0          |
| `npm`   | `bun`         | 11.16.0          |
| `npx`   | `bunx`        | 11.16.0          |

## ✨ Features

- ✅ **Drop-in replacement** — scripts named `node`, `npm`, `npx` (no `.sh` extension)
- ✅ **Version spoofing** — `--version`, `-v`, `--help` report expected versions
- ✅ **Fully transparent** — all other flags and args forwarded to `bun`/`bunx`
- ✅ **Node eval support** — `node -e "console.log('hi')"` works via `bun run`
- ✅ **npm commands** — `install`, `add`, `publish`, `run`, `start`, `test`, etc. all forwarded to `bun`

## 🔧 Manual Install

```bash
mkdir -p ~/bin
cp node npm npx ~/bin/
chmod +x ~/bin/node ~/bin/npm ~/bin/npx
```

Add to your shell config:

```bash
export PATH="$HOME/bin:$PATH"
```

## 📋 Latest Versions

- **Node.js**: v26.2.0
- **npm/npx**: 11.16.0
- **Bun**: 1.3.14

## ⚠️ Compatibility Notes

- Bun is highly compatible with Node.js APIs, but test complex projects thoroughly
- Some Node.js-specific flags or behaviors may differ
- Update version strings in the scripts for future releases
