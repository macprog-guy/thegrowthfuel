.PHONY: dev build preview publish clean dev-workers deploy-workers design-system

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

# Publish: save all changes and push to GitHub (Cloudflare then rebuilds the live site)
# Usage:  make publish                       -> commits with a default message
#         make publish m="new homepage text" -> commits with your own message
publish:
	@bash -c '\
	  git add -A; \
	  if git diff --cached --quiet; then \
	    echo "Nothing new to publish — you have no unsaved changes."; \
	    exit 0; \
	  fi; \
	  echo "About to publish these changes:"; \
	  git -c color.status=always status --short; \
	  echo ""; \
	  msg="$(m)"; \
	  if [ -z "$$msg" ]; then msg="Update site content"; fi; \
	  git commit -q -m "$$msg" && git push -q && \
	  echo "" && \
	  echo "✅ Published! Your changes are on their way to the live site." && \
	  echo "   They usually appear at thegrowthfuel.com within 1–2 minutes."'

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