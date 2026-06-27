<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#20535c">
  <title>{{ app_title }} - Descriptive App</title>
{{ pwa_head }}
  <link rel="stylesheet" href="./ui/main/styles.css">
</head>
<body data-dp-target="{{ target }}">
  <main id="app" class="dp-app" aria-live="polite"></main>
  <script type="module" src="./ui/main/component.js"></script>
{{ pwa_service_worker }}
</body>
</html>
