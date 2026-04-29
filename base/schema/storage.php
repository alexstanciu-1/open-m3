<?php

require_once "storage_property.php";
require_once "model.php";

namespace om3\base\schema;

class storage
{
	public ?string $table = null;
	public ?string $engine = null;
	public ?string $database = null;
	public mixed $primary_key = null;
	public ?string $type_column = null;
	public /** vector<mixed> */ $indexes = [];
	public /** weak<model> */ $owner_model = null;
	public /** vector<storage_property> */ $properties = [];
}
