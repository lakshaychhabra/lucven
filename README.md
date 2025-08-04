# lucven.com

This repository contains the source for [lucven.com](https://lucven.com), a blog built with [Hugo](https://gohugo.io/) using the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme.

## Local development

1. Install the [Hugo extended](https://gohugo.io/getting-started/installing/) binary.
2. Start a development server:

   ```bash
   hugo server -D
   ```

   The site will be available at http://localhost:1313/.

## Production build

Generate the static site into `public/`:

```bash
hugo
```

The `hugo.toml` configuration sets `baseURL = "https://lucven.com/"` so links resolve to the live domain.

## License

Content and code are released under the MIT license unless otherwise noted.
