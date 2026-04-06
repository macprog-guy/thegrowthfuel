export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    // Redirect root to /en/
    if (path === '/' || path === '') {
      return Response.redirect(url.origin + '/en/', 302);
    }

    // Rewrite /en/* to /* (strip prefix, serve from static assets)
    if (path === '/en' || path.startsWith('/en/')) {
      const newPath = path.replace(/^\/en\/?/, '/') || '/';
      const newUrl = new URL(newPath + url.search, url.origin);
      return env.ASSETS.fetch(new Request(newUrl, request));
    }

    // Everything else passes through to static assets
    return env.ASSETS.fetch(request);
  }
};
