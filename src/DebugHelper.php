<?php

namespace Creativestyle\MageOps;

use Symfony\Component\ErrorHandler\Debug;
use Symfony\Component\ErrorHandler\DebugClassLoader;

class DebugHelper
{
    /**
     * @var DebugHelper|null
     */
    private $instance;

    /**
     * Make it a singleton because - why not?
     * It's a perfectly valid use-case.
     */
    protected static function get(): DebugHelper
    {
        if (!self::$instance) {
            self::$instance = new DebugHelper();
        }

        return self::$instance;
    }

    public static function enable()
    {
        Debug::enable();
        DebugClassLoader::enable();

        echo self::class . "::enable()\n";
    }
}

