#!/bin/sh
script_name="filament-automations"

if [ "$DISABLE_DEFAULT_CONFIG" = "false" ]; then
    # Check to see if an Artisan file exists and assume it means Laravel is configured.
    if [ -f "$APP_BASE_DIR/artisan" ]; then
        echo "Checking for Filament automations..."
        ############################################################################
        # artisan filament:optimize
        ############################################################################
        if [ "${AUTORUN_LARAVEL_FILAMENT:=true}" = "true" ]; then
            echo "🚀 Caching filament components and Blade icons.."
            php "$APP_BASE_DIR/artisan" filament:optimize
        fi
    fi
else
    if [ "$LOG_OUTPUT_LEVEL" = "debug" ]; then
        echo "👉 $script_name: DISABLE_DEFAULT_CONFIG does not equal 'false', so automations will NOT be performed."
    fi
fi
