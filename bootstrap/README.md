# Sanity + 11ty + Bootstrap generator

To start and stop the development servers, you will need to run the `serve.sh` and `stop.sh` scripts from your generator directory, passing the path to this project directory as an argument.

### Start Development Servers

```bash
/path/to/your/generator/serve.sh .
```

### Stop Development Servers

```bash
/path/to/your/generator/stop.sh .
```

**Note:** You will need to replace `/path/to/your/generator` with the actual path to your generator directory. You will also need to make sure that the scripts in the generator directory are executable (`chmod +x *.sh`).

## CSS Layers

- `src/assets/site.css` – framework defaults and block styling. Updated by `update.sh` (options 1 or 2).
- `src/assets/theme.css` – overwritten only when you pick a theme (option 4).
- `src/assets/custom.css` – per-site overrides. Generated once and never touched by generator scripts.

Keep custom tweaks in `custom.css` so you can safely pull in framework updates.
