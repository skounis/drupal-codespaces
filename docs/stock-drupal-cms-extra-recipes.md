# Install Stock Drupal CMS + Extra Recipes and Demo Themes

This guide starts from the official Drupal CMS install instructions and then shows how to add the `extra_*` recipes and the two themes used in this repository's demo.

## 1) Install stock Drupal CMS (official guide)

Follow the official Drupal CMS instructions for installing with **DDEV** from:

https://new.drupal.org/docs/drupal-cms/get-started/install-drupal-cms/install-drupal-cms-locally-with-ddev

## 2) Require the extra recipes and demo themes

From your Drupal CMS project root, require the packages:

```bash
composer require \
  drupal/extra_hero \
  drupal/extra_highlight_feature \
  drupal/extra_icon_features \
  drupal/extra_project_browser \
  drupal/project_browser \
  drupal/paragraphs \
  drupal/fontawesome \
  drupal/basecore \
  drupal/corporateclean
```

Notes:
- `extra_highlight_feature` and `extra_icon_features` require the `paragraphs` module.
- `extra_icon_features` also requires `fontawesome`.
- `basecore` is the recommended theme for best styling of the `extra_*` blocks.

## 3) Enable required modules

Enable the modules needed for the recipes and the optional Project Browser UI:

```bash
vendor/bin/drush en -y project_browser extra_project_browser paragraphs fontawesome
```

If you are using DDEV:

```bash
ddev exec "vendor/bin/drush en -y project_browser extra_project_browser paragraphs fontawesome"
```

## 4) Apply the recipes

Apply each recipe with Drush:

```bash
vendor/bin/drush recipe extra_hero
vendor/bin/drush recipe extra_highlight_feature
vendor/bin/drush recipe extra_icon_features
```

If you are using DDEV:

```bash
ddev exec "vendor/bin/drush recipe extra_hero"
ddev exec "vendor/bin/drush recipe extra_highlight_feature"
ddev exec "vendor/bin/drush recipe extra_icon_features"
```

Alternative UI path:
- Enable **Project Browser** and **Extra Project Browser** in Extend.
- Open Project Browser and install the `extra_*` recipes from there.

## 5) Enable and set a theme

Enable and set the demo themes from the UI:

1. Go to **Appearance**.
2. Install and set **Basecore** as default (recommended for the `extra_*` blocks).
3. Optionally install **CorporateClean** and switch between them to compare.

If you prefer Drush, you can enable both and set a default theme:

```bash
vendor/bin/drush theme:enable basecore corporateclean
vendor/bin/drush config:set system.theme default basecore -y
```

If you are using DDEV:

```bash
ddev exec "vendor/bin/drush theme:enable basecore corporateclean"
ddev exec "vendor/bin/drush config:set system.theme default basecore -y"
```

## 6) Verify

Place the new blocks on a page or in Layout Builder, and confirm they render with Basecore styles:

- Extra Hero
- Extra Highlight Feature
- Extra Icon Features
