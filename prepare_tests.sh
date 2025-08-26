#!/usr/bin/env bash
set -e

export WP_CLI_TESTS_MYSQL_PORT=33306
export WP_CLI_TEST_DBROOTPASS=password

# Detect which Docker Compose command is available
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
else
		echo "Error: Neither 'docker-compose' nor 'docker compose' is available." >&2
    exit 1
fi

$DOCKER_COMPOSE_CMD -f ./docker-compose.yml up -d

export MYSQL_HOST=127.0.0.1
export MYSQL_TCP_PORT=$WP_CLI_TESTS_MYSQL_PORT
export WP_CLI_TEST_DBUSER=wp_cli_test
export WP_CLI_TEST_DBPASS=password1
export WP_CLI_TEST_DBHOST="localhost:${WP_CLI_TESTS_MYSQL_PORT}"

# composer install
composer prepare-tests
