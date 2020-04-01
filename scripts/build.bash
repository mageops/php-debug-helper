#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(pwd)"
BUILD_DIR="${ROOT_DIR}/build"
INSTALL_DIR="${BUILD_DIR}/installed"
ISOLATE_DIR="${BUILD_DIR}/isolated"

OUT_FILE="${1:-${ROOT_DIR}/mageops-debug-helper.phar}"
PHP="${PHP_BINARY:-$(which php)}"

rm -rf "$BUILD_DIR/" "$INSTALL_DIR/" "$ISOLATE_DIR/"
mkdir -p "$BUILD_DIR/" "$INSTALL_DIR/" "$ISOLATE_DIR/"

cp -r \
    "${ROOT_DIR}/composer.json" \
    "${ROOT_DIR}/composer.lock" \
    "${ROOT_DIR}/entrypoint.php" \
    "${ROOT_DIR}/src/" \
        "$INSTALL_DIR/"

cd "$ROOT_DIR"
echo -e "\n * Install production composer deps \n"
"$ROOT_DIR/vendor/bin/composer" install \
    --working-dir="$INSTALL_DIR" \
    --no-dev \
    --no-scripts \
    --no-interaction \
    --no-plugins \
    --prefer-dist \
    --ignore-platform-reqs \
    --optimize-autoloader \
    --classmap-authoritative \
    --ansi \
    --profile

echo -e "\n * Slim the build - remove tests, docs and other stuff \n"
cd "$INSTALL_DIR"
rm -rf \
    */*/Test/ \
    */*/tests/ \
    */*/src/tests/ \
    */*/docs/ \
    */*/*.md \
    */*/composer.* \
    */*/.gitignore


echo -e "\n * Isolate the namespaces with prefix \n"
cd "$INSTALL_DIR"
"$ROOT_DIR/vendor/bin/php-scoper" add-prefix \
    --working-dir "$INSTALL_DIR" \
    --output-dir "$ISOLATE_DIR" \
    --prefix "MageOpsDebugHelperIsolatedPhar" \
    --force \
    --no-config \
    --no-interaction \
    --no-progress \
    --no-suggest \
    --stop-on-failure \
    --ansi \
        "$INSTALL_DIR/" \
        "$INSTALL_DIR/vendor/"


echo -e "\n * Build isolated project into phar archive: ${ISOLATE_DIR}/ -> ${OUT_FILE} \n"
cd "$INSTALL_DIR"
$PHP -d phar.readonly=off "$ROOT_DIR/vendor/bin/phar-composer" build \
    --ansi \
        "$ISOLATE_DIR" "$OUT_FILE"





