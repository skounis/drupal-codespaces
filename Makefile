# Variables
CMS_DIR := cms
COMPOSER_FILE := $(CMS_DIR)/composer.json

.PHONY: clean ddev setup launch start restart require-recipe-extra-hero-v2 enable-extra-recommended link-custom

# Default target to run all steps
all: clean ddev setup launch

# Clean the cms/ folder but keep composer.json and drupal_cms_installer profile
clean:
	@echo "Cleaning the $(CMS_DIR) folder but keeping $(COMPOSER_FILE) and drupal_cms_installer..."
	@find $(CMS_DIR) -mindepth 1 -depth -ignore_readdir_race ! -name $(notdir $(COMPOSER_FILE)) ! -path "*/web/profiles/drupal_cms_installer" -exec rm -rf {} +

# Ensure the custom modules symlink exists (cms/web/modules/custom -> dev/custom).
link-custom:
	@mkdir -p dev/custom
	@mkdir -p $(CMS_DIR)/web/modules
	@if [ -L $(CMS_DIR)/web/modules/custom ] || [ ! -e $(CMS_DIR)/web/modules/custom ]; then \
		ln -sfn ../../../dev/custom $(CMS_DIR)/web/modules/custom; \
		echo \"Symlink created/updated: $(CMS_DIR)/web/modules/custom -> ./dev/custom\"; \
	else \
		echo \"$(CMS_DIR)/web/modules/custom exists and is not a symlink. Remove or move it, then re-run link-custom.\"; \
		exit 1; \
	fi

# Start ddev and always reset the project database first
ddev:
	@echo "Checking ddev status and resetting DB before starting..."
	@if ddev describe >/dev/null 2>&1; then \
		echo "ddev is already running — stopping, deleting project (destructive), then starting..."; \
		ddev stop || true; \
		ddev delete --omit-snapshot -Oy || true; \
		ddev start; \
	else \
		echo "ddev is not running — deleting any existing project data then starting..."; \
		ddev delete --omit-snapshot -Oy || true; \
		ddev start; \
	fi

start:
	@echo "Starting ddev..."
	@ddev start

restart:
	@echo "Restarting ddev..."
	@ddev restart

# Run setup commands inside the ddev container
setup:
	@echo "Running setup commands inside the ddev container..."
	@echo "Commands to be executed:"
	@echo "1. cd $(CMS_DIR)"
	@echo "2. composer install"
	@echo "3. composer run-script post-install-cmd"
	@ddev exec "cd $(CMS_DIR) && composer install && composer run-script post-install-cmd"


# Launch the browser using ddev
launch:
	@echo "Launching the browser with ddev..."
	@ddev launch


# Require and whitelist the extra_hero_v2 recipe from More Than Themes
require-recipe-extra-hero-v2:
	@echo "Requiring morethanthemes/extra_hero_v2 recipe..."
	@ddev exec "cd $(CMS_DIR) && composer require morethanthemes/extra_hero_v2:@dev"
	@echo "Recipe required successfully!"


# Enable the custom extra_recommended source plugin module
enable-extra-recommended:
	@echo "Enabling drupal_cms_extra_recommended module..."
	@ddev exec "cd $(CMS_DIR) && ./vendor/bin/drush module:install drupal_cms_extra_recommended -y"
	@echo "Configuring project_browser to use extra_recommended source..."
	@ddev exec "cd $(CMS_DIR) && ./vendor/bin/drush config:set project_browser.admin_settings enabled_sources.extra_recommended '{}' -y"
	@ddev exec "cd $(CMS_DIR) && ./vendor/bin/drush cache:rebuild"
	@echo "Done! The 'Extra Recommended' source is now enabled in project_browser."


# Dropping Drupal database inside ddev...
# drush sql:drop -y 
