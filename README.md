# Bun Replacements for Node, NPM, and NPX

This repository provides shell scripts to replace `node`, `npm`, and `npx` with `bun` and `bunx` for faster JavaScript workflows. It mimics version outputs for compatibility with tools/scripts that check Node/npm versions.

## Features
- Mimics Node.js v25.0.0 and npm v11.6.2 for `--version`, `-v`, `--help`, etc.
- Forwards all other commands to `bun`/`bunx`.
- Handles common flags like `-e` for inline eval in Node.

## Latest Versions
- Node.js: v25.0.0
- npm/npx: 11.6.2
- Bun: 1.3.1

## Setup
1. Install Bun: `curl -fsSL https://bun.sh/install | bash`
2. Save scripts as `node.sh`, `npm.sh`, `npx.sh` in `~/bin` (create if needed).
3. Make executable: `chmod +x ~/bin/*.sh`
4. Add to PATH in `~/.bashrc` or `~/.zshrc`: `export PATH="$HOME/bin:$PATH"`
5. Reload shell: `source ~/.bashrc`
6. Test: `node --version` (should output `v25.0.0`)

## Scripts
- `node.sh`: Replaces `node` with `bun`.
- `npm.sh`: Replaces `npm` with `bun` (for package management).
- `npx.sh`: Replaces `npx` with `bunx`.

## Compatibility Notes
- Bun is highly compatible, but test complex Node APIs.
- Update version strings in scripts for future releases.

## Contributing
Fork, PR, or open issues for enhancements (e.g., more flags).

## License
GPT - [Licence](LICENCE)
