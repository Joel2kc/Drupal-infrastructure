#!/bin/bash
set -e

echo "Waiting for database connection..."
until php -r "
try {
    \$pdo = new PDO('mysql:host=$DB_HOST;dbname=$DB_NAME', '$DB_USER', '$DB_PASSWORD');
    echo 'connected';
} catch (Exception \$e) {
    exit(1);
}
" 2>/dev/null; do
    echo "Database not ready, retrying in 5 seconds..."
    sleep 5
done
echo "Database is ready."

if [ ! -f /var/www/html/drupal/web/index.php ]; then
    echo "Downloading Drupal to temp location..."

    COMPOSER_ALLOW_SUPERUSER=1 composer create-project \
        drupal/recommended-project:^10 \
        /tmp/drupal \
        --no-interaction \
        --no-dev

    echo "Installing Drush..."
    COMPOSER_ALLOW_SUPERUSER=1 composer require drush/drush \
        --working-dir=/tmp/drupal \
        --no-interaction

    echo "Moving Drupal files into place..."
    cp -r /tmp/drupal/. /var/www/html/drupal/
    rm -rf /tmp/drupal

    echo "Installing Drupal..."
    cd /var/www/html/drupal

    chmod 755 vendor/bin/drush
    chmod -R 755 vendor/drush

    php vendor/bin/drush site:install standard \
        --db-url="mysql://$DB_USER:$DB_PASSWORD@$DB_HOST/$DB_NAME" \
        --site-name="Drupal HA Site" \
        --account-name="$DRUPAL_ADMIN_USER" \
        --account-pass="$DRUPAL_ADMIN_PASS" \
        -y

    chown -R www-data:www-data /var/www/html/drupal
    echo "Drupal installation complete."
fi

exec "$@"