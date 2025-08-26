#!/usr/bin/env bash
set -euo pipefail

touch .env

# To turn on xtracing, run the command with DEBUG=true or DEBUG=1.
DEBUG=${DEBUG:-0}
if [[ "$DEBUG" = "true" ]] || [[ "$DEBUG" -eq 1 ]]; then
	set -x
fi

if ! grep -q ^WP_CLI_TESTS_MYSQL_PORT= .env; then
	echo "WP_CLI_TESTS_MYSQL_PORT=33306" >> .env
fi

if ! grep -q ^WP_CLI_TEST_DBROOTPASS= .env; then
	echo "WP_CLI_TEST_DBROOTPASS=password" >> .env
fi

if ! grep -q ^WP_CLI_TEST_DBUSER= .env; then
	echo "WP_CLI_TEST_DBUSER=wp_cli_test" >> .env
fi

if ! grep -q ^WP_CLI_TEST_DBUSER= .env; then
	echo "WP_CLI_TEST_DBUSER=wp_cli_test" >> .env
fi

if ! grep -q ^WP_CLI_TEST_DBPASS= .env; then
	echo "WP_CLI_TEST_DBPASS=password1" >> .env
fi

if ! grep -q ^WP_CLI_TEST_DBHOST= .env; then
	echo WP_CLI_TEST_DBHOST="localhost:33306" >> .env
fi

# Detect which Docker Compose command is available
if command -v docker-compose &> /dev/null; then
    docker_compose_cmd="docker-compose"
elif docker compose version &> /dev/null; then
    docker_compose_cmd="docker compose"
else
		echo "Error: Neither 'docker-compose' nor 'docker compose' is available." >&2
    exit 1
fi

composer install --optimize-autoloader
$docker_compose_cmd -f ./docker-compose.yml up -d
$docker_compose_cmd exec mysql /app/wp-cli-tests/bin/install-package-tests
