[![Build Status](https://img.shields.io/travis/com/mageops/php-debug-helper?label=Phar+Archive+Build)](https://travis-ci.com/mageops/php-debug-helper)


MageOps Injectable PHP Debugging Helper
=======================================

An namespace-isolated PHAR package based on [Symfony Error Handler Component](https://symfony.com/doc/current/components/error_handler.html) that
adds nice error debugging information to any PHP script / application.

The whole idea is that it can be enabled for any and every PHP script globally
by using the [`auto_prepend_file` PHP INI directive](https://www.php.net/manual/en/ini.core.php#ini.auto-prepend-file).

The entrypoint already enables the error handler, so all that is left to do
is just to download the latest PHAR package from [GitHub Releases](https://github.com/mageops/php-debug-helper/releases)
and configure it in your `php.ini` or *PHP-FPM pool config*.

## Warning!

As the error handler exposes sensitive information never run it on production servers
unless it's enabled only on-demand for certain requests after they have passed some kind of
authorization - that's how we do it in [MageOps Infrastructure](https://github.com/mageops/ansible-infrastructure).

## TODO

 - [ ] Extend the Symfony's Error Handler with some extra info about the
       request and the environment incl. PHP configuration
