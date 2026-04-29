<?php

require_once "schema/model.php";
require_once "schema/model_property.php";
require_once "schema/storage.php";
require_once "schema/storage_property.php";
require_once "load/json_loader.php";

namespace om3\base\app;

use om3\base\load\json_loader;

$model_path = "../samples/h2b/model/Property.json";
$storage_path = "../samples/h2b/storage/Property.json";

$m = json_loader::load_model($model_path);
$s = json_loader::load_storage($storage_path);

if (!$m || !$s) {
	echo "load_failed\n";
} else {
	json_loader::attach_storage($m, $s);

	$property_count = count($m->properties);
	$storage_property_count = count($s->properties);
	$first_property_name = "";
	foreach ($m->properties as $property) {
		$first_property_name = $property->name;
		break;
	}
	$has_attached_storage = $m->attached_storage ? "yes" : "no";

	echo $m->name, "\n";
	echo $property_count, "\n";
	echo $storage_property_count, "\n";
	echo $first_property_name, "\n";
	echo $has_attached_storage, "\n";
}
