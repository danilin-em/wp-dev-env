<?php

define( 'WP_DEBUG',         true );
define( 'WP_DEBUG_LOG',     true );
define( 'SCRIPT_DEBUG',     true );
define( 'SAVEQUERIES',      true );
define( 'WP_DEBUG_DISPLAY', false );
@ini_set( 'display_errors', 0 );

define( 'HOSTNAME',   getenv( 'HOSTNAME' )   ?: 'localhost' );
define( 'WP_HOME',    getenv( 'WP_HOME' )    ?: 'http://' . HOSTNAME );
define( 'WP_SITEURL', getenv( 'WP_SITEURL' ) ?: 'http://' . HOSTNAME );

define( 'FS_METHOD',  getenv( 'FS_METHOD' )  ?: 'direct' );

define( 'DB_HOST',     getenv( 'DB_HOST' )     ?: 'db' );
define( 'DB_NAME',     getenv( 'DB_NAME' )     ?: 'app' );
define( 'DB_USER',     getenv( 'DB_USER' )     ?: 'app' );
define( 'DB_PASSWORD', getenv( 'DB_PASSWORD' ) ?: 'app' );
define( 'DB_CHARSET',  getenv( 'DB_CHARSET' )  ?: 'utf8mb4' );
define( 'DB_COLLATE',  getenv( 'DB_COLLATE' )  ?: '' );

define( 'AUTH_KEY',         'xxx' );
define( 'SECURE_AUTH_KEY',  'xxx' );
define( 'LOGGED_IN_KEY',    'xxx' );
define( 'NONCE_KEY',        'xxx' );
define( 'AUTH_SALT',        'xxx' );
define( 'SECURE_AUTH_SALT', 'xxx' );
define( 'LOGGED_IN_SALT',   'xxx' );
define( 'NONCE_SALT',       'xxx' );

$table_prefix = 'wp_';

/* **************************************************** */

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}
require_once( ABSPATH . 'wp-settings.php' );
