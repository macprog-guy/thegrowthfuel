# How to edit your website

A plain-English guide to changing thegrowthfuel.com yourself, trying ideas
safely on your own computer, and publishing when you're happy.

Nothing you do on your computer touches the live site until you **publish**.
So you can experiment freely.

---

## One-time setup (only ever needed once)

Open the **Terminal** app and paste this, then press Enter:

```
brew install zola
```

That installs the tool that turns your text into a webpage. You only do this once.

---

## Every time you want to make a change

There are just **two commands**. Both are typed in the Terminal app, from inside
this project folder.

> Tip: to get into the folder, open Terminal and type `cd ` (with a space),
> then drag the project folder onto the Terminal window and press Enter.

### 1. Preview — see your changes as you work

```
make dev
```

This opens the website in your browser on your own computer. As you (or Claude)
edit the text, **the page updates automatically** — no need to refresh.

This is your private sandbox. Only you can see it. The real thegrowthfuel.com is
untouched.

When you're done looking, go back to Terminal and press **Ctrl + C** to stop it.

### 2. Publish — put your changes on the live site

When you're happy with how things look:

```
make publish
```

This sends your changes to the live site. Within a minute or two they'll appear
at **thegrowthfuel.com** for everyone.

Want to leave yourself a note about what you changed? Add a message:

```
make publish m="Updated the homepage headline"
```

---

## Quick reference

| I want to…                        | Type this            |
| --------------------------------- | -------------------- |
| See my changes privately          | `make dev`           |
| Stop the preview                  | Press `Ctrl + C`     |
| Put my changes on the live site   | `make publish`       |
| Publish with a note               | `make publish m="…"` |

---

## Where the content lives

If you want to edit text directly (you can also just ask Claude to do it):

- **Page text** → the `content/` folder (each page is a `.md` file)
- **Client testimonials** → `data/testimonials.toml`
- **Services** → `data/services.toml`
- **Images** → `static/images/`
- **Site-wide settings** (booking links, etc.) → `zola.toml`

---

## Good to know

- **You can't break the live site by experimenting.** Changes only go live when
  you run `make publish`.
- **Made a mess and want to start over?** Ask Claude to "undo my local changes"
  and you'll be back to the last published version.
- **The site is bilingual (English + French).** French pages end in `.fr.md`
  (for example `_index.fr.md`). If you change English text, remember to update
  the French version too — or ask Claude to do both.
