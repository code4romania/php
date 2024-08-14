#!/command/with-contenv sh

cd /var/www

php artisan migrate --force
php artisan optimize
php artisan storage:link

if [ -f ./custom.sh ]; then
    ./custom.sh
fi

php artisan about
