<?php
declare(strict_types=1);

if ($argc < 3) {
	fwrite(STDERR, "Usage: php export_types_json.php <types_dir> <types_json_dir>\n");
	exit(1);
}

$typesDir = rtrim($argv[1], "/");
$outDir = rtrim($argv[2], "/");

if (!is_dir($typesDir)) {
	fwrite(STDERR, "Missing types dir: {$typesDir}\n");
	exit(1);
}

if (!is_dir($outDir) && !mkdir($outDir, 0777, true) && !is_dir($outDir)) {
	fwrite(STDERR, "Failed to create output dir: {$outDir}\n");
	exit(1);
}

final class QModelArray extends ArrayObject {}

final class QModelAcceptedType
{
	public $type;
	public $options;
	public $strict;
	public $no_export = true;

	public function __construct($type, $options, $strict = null)
	{
		$this->type = $type;
		$this->options = $options;
		$this->strict = $strict;
	}
}

final class QModelProperty
{
	public $name;
	public $types;
	public $strict;
	public $unsigned;
	public $length;
	public $null;
	public $default;
	public $charset;
	public $collation;
	public $comment;
	public $mandatory;
	public $parent;
	public $values;
	public $storage;
	public $getter;
	public $setter;
	public $rights;
	public $no_export = true;
	public $validation;
	public $is_mandatory;
}

final class QModelMethod
{
	public $name;
	public $type;
	public $access;
	public $static;
	public $final;
	public $abstract;
	public $comment;
	public $params;
	public $body;
	public $parent;
	public $rights;
	public $api;
	public $cfg;
	public $no_export = true;
}

final class QModelType
{
	public $class;
	public $is_final;
	public $is_abstract;
	public $is_interface;
	public $parent;
	public $properties;
	public $methods;
	public $path;
	public $is_collection;
	public $implements;
	public $rights;
	public $no_export = true;
	public $storage = null;
	public $cfg = null;
	public $model = null;
	public $api = null;
}

function normalize_value(mixed $value, int $depth = 0): mixed
{
	if ($depth > 16) {
		return null;
	}
	if ($value === null) {
		return null;
	}
	if (is_scalar($value)) {
		return $value;
	}
	if ($value instanceof QModelAcceptedType) {
		$out = [
			"type" => $value->type,
			"options" => [],
		];
		if (is_array($value->options) || $value->options instanceof Traversable) {
			foreach ($value->options as $optionKey => $optionValue) {
				$out["options"][(string) $optionKey] = normalize_value($optionValue, $depth + 1);
			}
		}
		if ($value->strict !== null) {
			$out["strict"] = (bool) $value->strict;
		}
		return $out;
	}
	if ($value instanceof ArrayObject || is_array($value)) {
		$out = [];
		foreach ($value as $itemKey => $itemValue) {
			$normalized = normalize_value($itemValue, $depth + 1);
			if ($normalized === null) {
				continue;
			}
			$out[(string) $itemKey] = $normalized;
		}
		return $out;
	}
	if ($value instanceof QModelProperty) {
		$out = [];
		foreach (get_object_vars($value) as $propKey => $propValue) {
			if ($propKey === "parent" || $propKey === "no_export") {
				continue;
			}
			$normalized = normalize_value($propValue, $depth + 1);
			if ($normalized === null) {
				continue;
			}
			$out[$propKey] = $normalized;
		}
		return $out;
	}
	if ($value instanceof QModelType) {
		$out = [];
		foreach (get_object_vars($value) as $propKey => $propValue) {
			if ($propKey === "methods" || $propKey === "rights" || $propKey === "no_export") {
				continue;
			}
			$normalized = normalize_value($propValue, $depth + 1);
			if ($normalized === null) {
				continue;
			}
			$out[$propKey] = $normalized;
		}
		return $out;
	}
	if ($value instanceof stdClass) {
		$out = [];
		foreach (get_object_vars($value) as $propKey => $propValue) {
			$normalized = normalize_value($propValue, $depth + 1);
			if ($normalized === null) {
				continue;
			}
			$out[$propKey] = $normalized;
		}
		return $out;
	}
	return null;
}

function load_type_cache_file(string $path): ?QModelType
{
	$before = get_defined_vars();
	unset($before);

	include $path;

	foreach (get_defined_vars() as $varName => $varValue) {
		if (str_starts_with($varName, "Q_TYPECACHE_") && $varValue instanceof QModelType) {
			return $varValue;
		}
	}
	return null;
}

$typeFiles = glob($typesDir . "/*.type.php");
sort($typeFiles);

$written = 0;
$failed = 0;

foreach ($typeFiles as $typeFile) {
	$type = load_type_cache_file($typeFile);
	if (!$type instanceof QModelType || !is_string($type->class) || $type->class === "") {
		$failed++;
		continue;
	}

	$payload = normalize_value($type);
	if (!is_array($payload) || !isset($payload["class"])) {
		$failed++;
		continue;
	}

	$baseName = basename($typeFile, ".type.php") . ".json";
	$outPath = $outDir . "/" . $baseName;
	$json = json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
	if ($json === false || file_put_contents($outPath, $json . "\n") === false) {
		$failed++;
		continue;
	}
	$written++;
}

echo "written={$written}\n";
echo "failed={$failed}\n";
