<?php

require_once "model_property.php";
require_once "storage.php";

namespace om3\base\schema;

class model
{
	public ?string $name = null;
	public ?string $extends = null;
	public bool $abstract = false;
	public /** vector<model_property> */ $properties = [];
	public ?storage $attached_storage = null;
}
