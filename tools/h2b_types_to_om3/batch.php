<?php

function get_type_batch(mixed $types_json_dir): mixed
{
	$type_files = [];

	foreach (scandir($types_json_dir) as $type_file) {
		if (substr($type_file, -5) == ".json") {
			$type_files[] = $type_file;
		}
	}

	return $type_files;
}
