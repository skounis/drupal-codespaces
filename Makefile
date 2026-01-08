# Variables
CMS_DIR := cms
COMPOSER_FILE := $(CMS_DIR)/composer.json

.PHONY: clean ddev setup launch start restart

# Default target to run all steps
all: clean ddev setup launch

# Clean the cms/ folder but keep composer.json and drupal_cms_installer profile
clean:
	@echo "Cleaning the $(CMS_DIR) folder but keeping $(COMPOSER_FILE) and drupal_cms_installer..."
	@find $(CMS_DIR) -mindepth 1 -depth -ignore_readdir_race ! -name $(notdir $(COMPOSER_FILE)) ! -path "*/web/profiles/drupal_cms_installer" -exec rm -rf {} +

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


# Dropping Drupal database inside ddev...
# drush sql:drop -y 