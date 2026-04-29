<?php

require_once "config.php";
require_once "batch.php";
require_once "converter.php";

const DEBUG = false;

$type_files = get_type_batch(TYPES_JSON_DIR);

$dirs_ready =
	ensure_dir("../../samples") &&
	ensure_dir(SAMPLES_ROOT_DIR) &&
	ensure_dir(MODEL_OUT_DIR) &&
	ensure_dir(STORAGE_OUT_DIR) &&
	ensure_dir(REPORT_OUT_DIR);

$converted = [];
$failed = [];
$unmapped_report = [];

if (!$dirs_ready) {
	echo "failed to prepare output directories\n";
} else {
	foreach ($type_files as $type_file) {
		if (DEBUG) {
			echo "converting ";
			echo $type_file;
			echo "\n";
		}

		$json_path = TYPES_JSON_DIR . "/" . $type_file;
		$json = file_get_contents($json_path);
		if ($json === false) {
			$failed[] = $type_file;
			continue;
		}

		$data = json_decode($json);
		if ($data === null) {
			$failed[] = $type_file;
			continue;
		}

		$model_om3 = convert_model_to_om3($data);
		$storage_om3 = convert_storage_to_om3($data);
		$output_name = legacy_file_to_model_output_name($type_file);
		$model_out_path = MODEL_OUT_DIR . "/" . $output_name . ".json";
		$storage_out_path = STORAGE_OUT_DIR . "/" . $output_name . ".json";

		$model_parent_ready = ensure_parent_dir($model_out_path);
		$storage_parent_ready = ensure_parent_dir($storage_out_path);
		$model_written = $model_parent_ready && write_json_file($model_out_path, $model_om3);
		$storage_written = $storage_parent_ready && write_json_file($storage_out_path, $storage_om3);

		if ($model_written && $storage_written) {
			$converted[] = $output_name;
			$unmapped_report[$output_name] = collect_unmapped_type_metadata($data);
		} else {
			$failed[] = $type_file;
		}
	}

	write_json_file(REPORT_OUT_DIR . "/unmapped.json", $unmapped_report);

	echo "converted ";
	echo count($converted);
	echo " types";
	if (count($failed) > 0) {
		echo ", failed ";
		echo count($failed);
		echo " types";
	}
	echo "\n";
}
