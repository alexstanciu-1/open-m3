<?php

declare(strict_types=1);

final class QModelArray extends ArrayObject
{
    public function __construct(array $array = [])
    {
        parent::__construct($array, ArrayObject::ARRAY_AS_PROPS);
    }
}

final class QModelAcceptedType
{
    public function __construct(
        public mixed $type = null,
        public mixed $options = null
    ) {
    }
}

final class QModelType
{
    public mixed $class = null;
    public mixed $parent = null;
    public mixed $path = null;
    public mixed $storage = null;
    public mixed $model = null;
    public mixed $cfg = null;
    public mixed $api = null;
    public mixed $properties = null;
    public mixed $methods = null;
}

final class QModelProperty
{
    public mixed $parent = null;
    public mixed $name = null;
    public mixed $types = null;
    public mixed $storage = null;
    public mixed $validation = null;
    public mixed $cfg = null;
    public mixed $security = null;
    public mixed $default = null;
    public mixed $strict = null;
    public mixed $display = null;
    public mixed $filter = null;
    public mixed $fixValue = null;
}

final class QModelMethod
{
    public mixed $parent = null;
    public mixed $name = null;
    public mixed $static = null;
    public mixed $api = null;
    public mixed $in = null;
}

function load_qmodel_type(string $path): ?QModelType
{
    $vars = (static function (string $__path): array {
        include $__path;
        return get_defined_vars();
    })($path);

    foreach ($vars as $value) {
        if ($value instanceof QModelType) {
            return $value;
        }
    }

    return null;
}

function normalize_value(mixed $value): mixed
{
    if ($value instanceof QModelAcceptedType) {
        return [
            'type' => normalize_value($value->type),
            'options' => normalize_value($value->options),
        ];
    }

    if ($value instanceof QModelArray) {
        $out = [];
        foreach ($value as $key => $item) {
            $out[$key] = normalize_value($item);
        }
        return $out;
    }

    if ($value instanceof QModelProperty || $value instanceof QModelMethod) {
        $vars = get_object_vars($value);
        unset($vars['parent']);
        $out = [];
        foreach ($vars as $key => $item) {
            if ($item === null) {
                continue;
            }
            $out[$key] = normalize_value($item);
        }
        return $out;
    }

    if ($value instanceof QModelType) {
        $out = [
            'class' => normalize_value($value->class),
            'parent' => normalize_value($value->parent),
            'path' => normalize_value($value->path),
        ];

        foreach (['storage', 'model', 'cfg', 'api', 'properties', 'methods'] as $key) {
            $item = $value->{$key};
            if ($item === null) {
                continue;
            }
            $out[$key] = normalize_value($item);
        }

        if (!isset($out['properties'])) {
            $out['properties'] = [];
        }
        if (!isset($out['methods'])) {
            $out['methods'] = [];
        }

        return $out;
    }

    if (is_array($value)) {
        $out = [];
        foreach ($value as $key => $item) {
            $out[$key] = normalize_value($item);
        }
        return $out;
    }

    return $value;
}

$sourceDir = __DIR__ . '/../_legacy_code/h2b/code/temp/types';
$targetDir = __DIR__ . '/../_legacy_code/h2b/code/temp/types_json';

if (!is_dir($sourceDir)) {
    fwrite(STDERR, "Source directory not found: {$sourceDir}\n");
    exit(1);
}

if (!is_dir($targetDir) && !mkdir($targetDir, 0777, true) && !is_dir($targetDir)) {
    fwrite(STDERR, "Unable to create target directory: {$targetDir}\n");
    exit(1);
}

$files = glob($sourceDir . '/*.type.php');
sort($files);

$written = 0;
$failed = [];

foreach ($files as $file) {
    try {
        $type = load_qmodel_type($file);
        if (!$type) {
            $failed[] = [$file, 'No QModelType found'];
            continue;
        }

        $jsonPath = $targetDir . '/' . basename((string)$file, '.type.php') . '.json';
        $payload = normalize_value($type);
        $json = json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
        if ($json === false) {
            $failed[] = [$file, 'json_encode failed'];
            continue;
        }
        file_put_contents($jsonPath, $json . PHP_EOL);
        $written++;
    } catch (Throwable $e) {
        $failed[] = [$file, $e->getMessage()];
    }
}

echo "Wrote {$written} JSON files to {$targetDir}\n";
if ($failed) {
    echo "Failed: " . count($failed) . "\n";
    foreach (array_slice($failed, 0, 20) as [$file, $reason]) {
        echo "- {$file}: {$reason}\n";
    }
    exit(2);
}

