<?php

function normalize_type_path(mixed $legacy_type_name): string
{
	$type_path = str_replace("\\", "/", $legacy_type_name);
	if (substr($type_path, 0, 4) == "Omi/") {
		$type_path = substr($type_path, 4);
	}
	return $type_path;
}

function has_value(mixed $value): bool
{
	return ($value !== null) && ($value !== false) && ($value !== "");
}

function legacy_types_info(mixed $legacy_types): mixed
{
	$info = [
		"type_name" => null,
		"is_list" => false,
	];

	if ($legacy_types === null) {
		return $info;
	}

	if ($legacy_types["type"] == "QModelArray") {
		foreach ($legacy_types["options"] as $type_key => $type_name) {
			$info["type_name"] = normalize_type_path($type_name);
			$info["is_list"] = true;
			break;
		}
		return $info;
	}

	if ($legacy_types[0] !== null) {
		foreach ($legacy_types as $type_name) {
			$info["type_name"] = normalize_type_path($type_name);
			break;
		}
		return $info;
	}

	$info["type_name"] = normalize_type_path($legacy_types);
	return $info;
}

function convert_property_to_om3(mixed $legacy_property): mixed
{
	$om3 = [
		"name" => $legacy_property["name"],
	];

	$type_info = legacy_types_info($legacy_property["types"]);
	if (has_value($type_info["type_name"])) {
		$om3["type.name"] = $type_info["type_name"];
	}
	if ($type_info["is_list"] === true) {
		$om3["type.list"] = true;
	}

	if ($legacy_property["validation"] == "mandatory") {
		$om3["required"] = true;
	}

	if (has_value($legacy_property["storage"]["optionsPool"])) {
		$om3["struct.ref"] = $legacy_property["storage"]["optionsPool"];
	}

	return $om3;
}

function convert_all_properties_to_om3(mixed $legacy_properties): mixed
{
	$om3_properties = [];

	foreach ($legacy_properties as $property_name => $legacy_property) {
		$om3_properties[$property_name] = convert_property_to_om3($legacy_property);
	}

	return $om3_properties;
}

function class_name_to_model_name(mixed $legacy_class_name): string
{
	$model_name = str_replace("\\", "/", $legacy_class_name);
	if (substr($model_name, 0, 4) == "Omi/") {
		$model_name = substr($model_name, 4);
	}
	if (substr($model_name, 0, 4) == "TFH/") {
		$model_name = substr($model_name, 4);
	}
	return $model_name;
}

function class_name_to_model_extends(mixed $legacy_parent_name): mixed
{
	if (!has_value($legacy_parent_name)) {
		return null;
	}

	$parent_name = class_name_to_model_name($legacy_parent_name);
	if (substr($parent_name, -11) == "_h2b_model_") {
		return null;
	}

	return $parent_name;
}

function convert_model_to_om3(mixed $legacy_type): mixed
{
	$om3 = [
		"name" => class_name_to_model_name($legacy_type["class"]),
	];

	$extends = class_name_to_model_extends($legacy_type["parent"]);
	if (has_value($extends)) {
		$om3["extends"] = $extends;
	}

	$om3["properties"] = convert_all_properties_to_om3($legacy_type["properties"]);

	return $om3;
}

function convert_property_storage_to_om3(mixed $legacy_property): mixed
{
	$legacy_storage = $legacy_property["storage"];
	$om3 = [
		"name" => $legacy_property["name"],
	];

	if ($legacy_storage["column"] == "none") {
		$om3["kind"] = "none";
	}

	if ($legacy_storage["none"] === true) {
		$om3["kind"] = "none";
	}

	if (has_value($legacy_storage["column"]) && ($legacy_storage["column"] != "none")) {
		$om3["column"] = $legacy_storage["column"];
	}

	if (has_value($legacy_storage["type"])) {
		$om3["sql_type"] = $legacy_storage["type"];
	}

	if (has_value($legacy_storage["default"])) {
		$om3["default"] = $legacy_storage["default"];
	}

	if ($legacy_storage["index"] === true) {
		$om3["index"] = true;
	} else if (has_value($legacy_storage["index"])) {
		$om3["index"] = $legacy_storage["index"];
	}

	if (($legacy_storage["notnull"] === true) || ($legacy_storage["nonull"] === true)) {
		$om3["nullable"] = false;
	}

	if (has_value($legacy_storage["oneToMany"])) {
		$om3["relation.type"] = "oneToMany";
		$om3["relation.target_column"] = $legacy_storage["oneToMany"];
	}

	if (($legacy_storage["manyToMany"] === true) || (has_value($legacy_storage["collection"]) && !has_value($legacy_storage["oneToMany"]))) {
		$om3["relation.type"] = "manyToMany";
		if (has_value($legacy_storage["collection"])) {
			$parts = explode(",", $legacy_storage["collection"]);
			if (count($parts) >= 3) {
				$om3["relation.table"] = $parts[0];
				$om3["relation.this_column"] = $parts[1];
				$om3["relation.target_column"] = $parts[2];
			}
		}
	}

	return $om3;
}

function convert_all_property_storage_to_om3(mixed $legacy_properties): mixed
{
	$om3_properties = [];

	foreach ($legacy_properties as $property_name => $legacy_property) {
		$om3_property_storage = convert_property_storage_to_om3($legacy_property);
		if (count($om3_property_storage) > 1) {
			$om3_properties[$property_name] = $om3_property_storage;
		}
	}

	return $om3_properties;
}

function convert_storage_to_om3(mixed $legacy_type): mixed
{
	$om3 = [];
	if (has_value($legacy_type["storage"]["table"])) {
		$om3["table"] = $legacy_type["storage"]["table"];
	}

	if (has_value($legacy_type["storage"]["database"])) {
		$om3["database"] = $legacy_type["storage"]["database"];
	}

	$om3_properties = convert_all_property_storage_to_om3($legacy_type["properties"]);
	if (count($om3_properties) > 0) {
		$om3["properties"] = $om3_properties;
	}

	return $om3;
}

function collect_unmapped_property_metadata(mixed $legacy_property): mixed
{
	$property_unmapped = [];
	$storage_unmapped = [];

	if (has_value($legacy_property["validation"]) && ($legacy_property["validation"] != "mandatory")) {
		$property_unmapped["validation"] = $legacy_property["validation"];
	}

	$legacy_storage = $legacy_property["storage"];
	if ($legacy_storage !== null) {
		foreach ($legacy_storage as $storage_key => $storage_value) {
			$is_mapped =
				($storage_key == "optionsPool") ||
				($storage_key == "column") ||
				($storage_key == "type") ||
				($storage_key == "default") ||
				($storage_key == "index") ||
				($storage_key == "notnull") ||
				($storage_key == "nonull") ||
				($storage_key == "oneToMany") ||
				($storage_key == "manyToMany") ||
				($storage_key == "collection") ||
				($storage_key == "none");

			if (!$is_mapped) {
				$storage_unmapped[$storage_key] = $storage_value;
			}
		}
	}

	$unmapped = [];

	if (count($property_unmapped) > 0) {
		$unmapped["property"] = $property_unmapped;
	}

	if (count($storage_unmapped) > 0) {
		$unmapped["storage"] = $storage_unmapped;
	}

	return $unmapped;
}

function collect_unmapped_type_metadata(mixed $legacy_type): mixed
{
	$type_unmapped = [];
	$model_unmapped = [];
	$methods_unmapped = [];
	$properties_unmapped = [];

	if (has_value($legacy_type["path"])) {
		$type_unmapped["path"] = $legacy_type["path"];
	}

	if ($legacy_type["model"] !== null) {
		foreach ($legacy_type["model"] as $model_key => $model_value) {
			$model_unmapped[$model_key] = $model_value;
		}
	}

	if ($legacy_type["methods"] !== null) {
		$methods_unmapped = $legacy_type["methods"];
	}

	foreach ($legacy_type["properties"] as $property_name => $legacy_property) {
		$property_meta = collect_unmapped_property_metadata($legacy_property);
		if (count($property_meta) > 0) {
			$properties_unmapped[$property_name] = $property_meta;
		}
	}

	$unmapped = [];

	if (count($type_unmapped) > 0) {
		$unmapped["type"] = $type_unmapped;
	}

	if (count($model_unmapped) > 0) {
		$unmapped["model"] = $model_unmapped;
	}

	if (count($methods_unmapped) > 0) {
		$unmapped["methods"] = $methods_unmapped;
	}

	if (count($properties_unmapped) > 0) {
		$unmapped["properties"] = $properties_unmapped;
	}

	return $unmapped;
}

function ensure_parent_dir(mixed $path): bool
{
	$parts = explode("/", $path);
	$current = "";
	$last_index = count($parts) - 1;
	for ($i = 0; $i < $last_index; $i++) {
		$part = $parts[$i];
		if ($current == "") {
			$current = $part;
		} else {
			$current = $current . "/" . $part;
		}

		if (!ensure_dir($current)) {
			return false;
		}
	}

	return true;
}

function legacy_file_to_model_output_name(mixed $legacy_file_name): string
{
	$base_name = substr($legacy_file_name, 0, strlen($legacy_file_name) - 5);
	return class_name_to_model_name(str_replace("-", "\\", $base_name));
}

function write_json_file(mixed $path, mixed $data): bool
{
	$json = json_encode($data);
	return file_put_contents($path, $json) !== false;
}

function ensure_dir(mixed $path): bool
{
	if (is_dir($path)) {
		return true;
	}

	return mkdir($path);
}
