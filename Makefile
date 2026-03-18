.PHONY: dev build preview clean dev-workers deploy-workers design-system

# -----------------------------------------------------------------------------
# Zola 
# -----------------------------------------------------------------------------

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

# Run Workers locally (serves static site)
dev-workers:
	zola build && wrangler dev


# -----------------------------------------------------------------------------
# Deploy to Cloudflare Workers
# -----------------------------------------------------------------------------

deploy-workers:
	zola build && wrangler deploy


# -----------------------------------------------------------------------------
# Claude Code Sandbox
# -----------------------------------------------------------------------------

claude-build:
	devcontainer build --workspace-folder . --image-name drr-claude-sandbox

claude:
	devcontainer up --workspace-folder . && \
	devcontainer exec --workspace-folder . bash -c "\
		git config user.name '$$(git config user.name)' && \
		git config user.email '$$(git config user.email)' && \
		claude --dangerously-skip-permissions"