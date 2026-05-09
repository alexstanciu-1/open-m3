<?php
declare(strict_types=1);

if ($argc < 3) {
	fwrite(STDERR, "usage: php export_legacy_schema_tsv.php <input.sql> <output_dir>\n");
	exit(1);
}

$input = $argv[1];
$outputDir = $argv[2];

$sql = @file_get_contents($input);
if ($sql === false) {
	fwrite(STDERR, "failed_to_read:$input\n");
	exit(2);
}

if (!is_dir($outputDir) && !mkdir($outputDir, 0777, true) && !is_dir($outputDir)) {
	fwrite(STDERR, "failed_to_create_dir:$outputDir\n");
	exit(3);
}

$tables = [];
$columns = [];

if (preg_match_all('/CREATE TABLE\s+`([^`]+)`\s*\((.*?)\)\s*ENGINE=/si', $sql, $matches, PREG_SET_ORDER)) {
	foreach ($matches as $match) {
		$tableName = (string) ($match[1] ?? '');
		$body = (string) ($match[2] ?? '');
		if ($tableName === '') {
			continue;
		}

		$tables[] = [$tableName];
		$lines = preg_split('/\R/', $body) ?: [];
		foreach ($lines as $line) {
			$line = trim((string) $line);
			if ($line === '' || $line[0] !== '`') {
				continue;
			}
			if (!preg_match('/^`([^`]+)`\s+([a-zA-Z0-9_]+)/', $line, $colMatch)) {
				continue;
			}
			$columns[] = [
				$tableName,
				(string) $colMatch[1],
				strtolower((string) $colMatch[2]),
			];
		}
	}
}

write_tsv($outputDir . '/legacy_tables.tsv', ['table_name'], $tables);
write_tsv($outputDir . '/legacy_columns.tsv', ['table_name', 'column_name', 'column_type'], $columns);

fwrite(STDOUT, "legacy_tsv_dir=$outputDir\n");
fwrite(STDOUT, "legacy_tables=" . count($tables) . "\n");
fwrite(STDOUT, "legacy_columns=" . count($columns) . "\n");

function write_tsv(string $path, array $headers, array $rows): void
{
	$fh = fopen($path, 'wb');
	if ($fh === false) {
		throw new RuntimeException("failed_to_open:$path");
	}
	fwrite($fh, tsv_line($headers));
	foreach ($rows as $row) {
		fwrite($fh, tsv_line($row));
	}
	fclose($fh);
}

function tsv_line(array $fields): string
{
	$out = [];
	foreach ($fields as $field) {
		$value = (string) $field;
		$value = str_replace(["\t", "\r", "\n"], ' ', $value);
		$out[] = $value;
	}
	return implode("\t", $out) . "\n";
}
