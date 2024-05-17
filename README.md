Demo project for "[Shopify - send file to shop with Ruby on Rails](url)" article

# Local run

Dependencies:

```bash
yarn
cd web
rails db:prepare
```

Fill the environment variables:

```
SHOPIFY_API_KEY=
SHOPIFY_API_SECRET=
```

Redis (port 6379):

```bash
redis-server
```

Fill the prompts for app and follow generated link:

```bash
yarn dev
```
