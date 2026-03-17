.PHONY: dev build preview clean dev-workers deploy-workers design-system

# Start local dev server with live reload
dev:
	zola serve --open

# Build the static site into public/
build:
	zola build

# Preview production build locally (no live reload)
preview:
	zola build && cd public && python3 -m http.server 8000

# Clean build output
clean:
	rm -rf public/

# Open the design system in the browser
design-system:
	open design-system/index.html

# Run Workers backend locally (use in a separate terminal)
dev-workers:
	cd workers && wrangler dev

# Deploy Workers to Cloudflare
deploy-workers:
	cd workers && wrangler deploy
