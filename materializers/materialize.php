<?php

declare(strict_types=1);

final class Materializer
{
    private const TARGETS = [
        'pwa',
        'webview-win',
        'webview-mac',
        'webview-linux',
        'webview-ios',
        'webview-android',
    ];

    public static function main(array $argv): int
    {
        $options = self::parseArgs($argv);
        $repoRoot = dirname(__DIR__);
        $appRoot = self::resolvePath($repoRoot, $options['app'] ?? 'samples/hello_world');
        $templateName = $options['template'] ?? 'web_app_basic';
        $targets = isset($options['all']) ? self::TARGETS : [($options['target'] ?? 'pwa')];

        foreach ($targets as $target) {
            self::materializeTarget($repoRoot, $appRoot, $templateName, $target);
        }

        return 0;
    }

    private static function materializeTarget(string $repoRoot, string $appRoot, string $templateName, string $target): void
    {
        if (!in_array($target, self::TARGETS, true)) {
            throw new RuntimeException("Unknown target: {$target}");
        }

        $templateRoot = $repoRoot . '/materializers/templates/' . $templateName;
        $template = self::readJson($templateRoot . '/template.json');
        if (!in_array($target, $template['targets'] ?? [], true)) {
            throw new RuntimeException("Template {$templateName} does not support target {$target}");
        }

        $app = self::readJson($appRoot . '/app.dp.json');
        $capabilities = self::readJson($appRoot . '/app.capabilities.json');
        $uiSource = self::readJson($appRoot . '/src/ui/main/ui.json');
        $uiIr = [
            'kind' => 'descriptive-ui-ir',
            'version' => 1,
            'source' => 'src/ui/main/ui.json',
            'ui' => $uiSource['ui'] ?? 'main',
            'root' => $uiSource['root'] ?? null,
        ];

        $buildRoot = $appRoot . '/.generated/build/' . $target;
        self::ensureCleanDir($buildRoot);

        $context = self::buildContext($app, $capabilities, $uiSource, $uiIr, $template, $templateName, $target);
        $layers = self::collectLayers($repoRoot, $appRoot, $templateName, $target);
        $plan = self::buildPlan($layers, $target);
        $written = [];
        $overwritten = [];

        foreach ($plan as $relativePath => $entry) {
            $outputRelative = self::outputPathForTemplatePath($relativePath);
            $outputPath = $buildRoot . '/' . $outputRelative;
            self::ensureDir(dirname($outputPath));
            $content = file_get_contents($entry['path']);
            if ($content === false) {
                throw new RuntimeException('Failed to read template: ' . $entry['path']);
            }
            $content = self::renderTemplate($content, $context);
            file_put_contents($outputPath, $content);
            $written[] = $outputRelative;
            if (count($entry['sources']) > 1) {
                $overwritten[$outputRelative] = $entry['sources'];
            }
        }

        if ($target !== 'pwa') {
            foreach (self::mirrorDirectory($buildRoot . '/app', $buildRoot . '/host/app') as $mirroredFile) {
                $written[] = $mirroredFile;
            }
            sort($written);
        }

        $overwritten = self::relativeSourcePaths($overwritten, $repoRoot);

        $manifest = [
            'kind' => 'descriptive-materialization-manifest',
            'version' => 1,
            'app' => $app['name'] ?? basename($appRoot),
            'target' => $target,
            'template' => $templateName,
            'templateVersion' => $template['version'] ?? null,
            'runtime' => $template['runtime'] ?? null,
            'sourceFiles' => [
                'app.dp.json',
                'app.capabilities.json',
                'src/ui/main/ui.json',
            ],
            'layers' => array_map(static fn(array $layer): array => [
                'kind' => $layer['kind'],
                'selector' => $layer['selector'],
                'path' => self::relativeTo($repoRoot, $layer['path']),
            ], $layers),
            'overwrittenFiles' => $overwritten,
            'generatedFiles' => $written,
        ];

        file_put_contents($buildRoot . '/materialization.manifest.json', self::json($manifest));
        self::ensureDir($appRoot . '/.generated/diagnostics');
        file_put_contents($appRoot . '/.generated/diagnostics/materialization-' . $target . '.json', self::json([
            'ok' => true,
            'target' => $target,
            'generatedFiles' => count($written),
            'overwrittenFiles' => array_keys($overwritten),
        ]));

        echo "materialized {$target} -> " . self::relativeTo(getcwd(), $buildRoot) . PHP_EOL;
    }

    private static function relativeSourcePaths(array $overwritten, string $repoRoot): array
    {
        foreach ($overwritten as $outputPath => $sources) {
            foreach ($sources as $index => $source) {
                $source['path'] = self::relativeTo($repoRoot, $source['path']);
                $sources[$index] = $source;
            }
            $overwritten[$outputPath] = $sources;
        }
        return $overwritten;
    }

    private static function buildContext(array $app, array $capabilities, array $uiSource, array $uiIr, array $template, string $templateName, string $target): array
    {
        $isPwa = $target === 'pwa';
        $adapterFile = $isPwa ? 'pwa.js' : 'simplecpp-webview.js';
        $hostTitle = self::phpString($app['title'] ?? $app['name'] ?? 'Descriptive App');

        return [
            'app_name' => (string)($app['name'] ?? 'descriptive_app'),
            'app_title' => (string)($app['title'] ?? $app['name'] ?? 'Descriptive App'),
            'app_description' => (string)($app['description'] ?? ''),
            'target' => $target,
            'template_name' => $templateName,
            'runtime_name' => (string)($template['runtime'] ?? 'descriptivejs-v1-shell'),
            'adapter_file' => $adapterFile,
            'adapter_kind' => $isPwa ? 'pwa' : 'simplecpp-webview',
            'pwa_head' => $isPwa ? '<link rel="manifest" href="./manifest.webmanifest">' : '',
            'pwa_service_worker' => $isPwa ? self::pwaServiceWorkerRegistration() : '',
            'ui_ir_json' => self::json($uiIr),
            'ui_manifest_json' => self::json([
                'ui' => $uiIr['ui'],
                'target' => $target,
                'materializer' => 'materializers/materialize.php',
                'template' => $templateName,
                'runtime' => $template['runtime'] ?? 'descriptivejs-v1-shell',
                'source' => 'src/ui/main/ui.json',
                'artifacts' => [],
                'diagnostics' => [],
            ]),
            'app_capabilities_json' => self::json($capabilities),
            'app_description_json' => self::json($app),
            'host_title_php' => $hostTitle,
            'host_target_php' => self::phpString($target),
            'ios_bundle_identifier' => self::bundleIdentifier((string)($app['name'] ?? 'descriptive_app')),
            'ios_executable_name' => self::pascalIdentifier((string)($app['name'] ?? 'DescriptiveApp')),
            'android_package' => self::androidPackage((string)($app['name'] ?? 'descriptive_app')),
            'android_activity' => 'DescriptiveWebViewActivity',
            'android_jni_prefix' => self::androidJniPrefix(self::androidPackage((string)($app['name'] ?? 'descriptive_app')), 'DescriptiveWebViewActivity'),
        ];
    }

    private static function collectLayers(string $repoRoot, string $appRoot, string $templateName, string $target): array
    {
        $templateRoot = $repoRoot . '/materializers/templates/' . $templateName;
        $appTemplateRoot = $appRoot . '/src/materializers/templates/' . $templateName;
        $layers = [];
        $layers[] = ['kind' => 'template-base', 'selector' => 'files', 'path' => $templateRoot . '/files'];
        foreach (self::matchingOverlayDirs($templateRoot . '/overlays', $target) as $overlay) {
            $layers[] = ['kind' => 'template-overlay', 'selector' => basename($overlay), 'path' => $overlay];
        }
        foreach (self::matchingOverlayDirs($appTemplateRoot . '/overlays', $target) as $overlay) {
            $layers[] = ['kind' => 'app-overlay', 'selector' => basename($overlay), 'path' => $overlay];
        }
        return array_values(array_filter($layers, static fn(array $layer): bool => is_dir($layer['path'])));
    }

    private static function matchingOverlayDirs(string $overlaysRoot, string $target): array
    {
        if (!is_dir($overlaysRoot)) {
            return [];
        }
        $dirs = [];
        foreach (scandir($overlaysRoot) ?: [] as $entry) {
            if ($entry === '.' || $entry === '..') {
                continue;
            }
            $path = $overlaysRoot . '/' . $entry;
            if (is_dir($path) && self::selectorMatches($entry, $target)) {
                $dirs[] = $path;
            }
        }
        usort($dirs, static function (string $a, string $b) use ($target): int {
            return self::selectorSpecificity(basename($a), $target) <=> self::selectorSpecificity(basename($b), $target);
        });
        return $dirs;
    }

    private static function selectorMatches(string $selector, string $target): bool
    {
        foreach (explode('+', $selector) as $part) {
            $part = trim($part);
            if ($part === $target) {
                return true;
            }
            if (self::selectorPartMatchesFamily($part, $target)) {
                return true;
            }
        }
        return false;
    }

    private static function selectorSpecificity(string $selector, string $target): int
    {
        $score = 0;
        foreach (explode('+', $selector) as $part) {
            $part = trim($part);
            if ($part === $target) {
                $score = max($score, 1000 + strlen($part));
            } elseif (self::selectorPartMatchesFamily($part, $target)) {
                $score = max($score, 100 + strlen($part));
            }
        }
        return $score;
    }

    private static function selectorPartMatchesFamily(string $part, string $target): bool
    {
        if (str_ends_with($part, '-any')) {
            return str_starts_with($target, substr($part, 0, -3));
        }
        return str_ends_with($part, '*') && str_starts_with($target, substr($part, 0, -1));
    }

    private static function buildPlan(array $layers, string $target): array
    {
        $plan = [];
        foreach ($layers as $layer) {
            foreach (self::listFiles($layer['path']) as $file) {
                $relative = self::relativeTo($layer['path'], $file);
                if (!isset($plan[$relative])) {
                    $plan[$relative] = ['path' => $file, 'sources' => []];
                }
                $plan[$relative]['path'] = $file;
                $plan[$relative]['sources'][] = [
                    'kind' => $layer['kind'],
                    'selector' => $layer['selector'],
                    'path' => $file,
                ];
            }
        }
        ksort($plan);
        return $plan;
    }

    private static function listFiles(string $root): array
    {
        if (!is_dir($root)) {
            return [];
        }
        $files = [];
        $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($root, FilesystemIterator::SKIP_DOTS));
        foreach ($iterator as $file) {
            if ($file->isFile()) {
                $files[] = $file->getPathname();
            }
        }
        sort($files);
        return $files;
    }

    private static function outputPathForTemplatePath(string $path): string
    {
        return str_ends_with($path, '.tpl') ? substr($path, 0, -4) : $path;
    }

    private static function renderTemplate(string $content, array $context): string
    {
        return preg_replace_callback('/{{\s*([a-zA-Z0-9_]+)\s*}}/', static function (array $matches) use ($context): string {
            return array_key_exists($matches[1], $context) ? (string)$context[$matches[1]] : $matches[0];
        }, $content);
    }

    private static function parseArgs(array $argv): array
    {
        $options = [];
        for ($i = 1; $i < count($argv); $i++) {
            $arg = $argv[$i];
            if ($arg === '--all') {
                $options['all'] = true;
                continue;
            }
            if (str_starts_with($arg, '--')) {
                $key = substr($arg, 2);
                $value = $argv[$i + 1] ?? null;
                if ($value === null || str_starts_with($value, '--')) {
                    throw new RuntimeException("Missing value for --{$key}");
                }
                $options[$key] = $value;
                $i++;
                continue;
            }
            throw new RuntimeException("Unexpected argument: {$arg}");
        }
        return $options;
    }

    private static function mirrorDirectory(string $sourceRoot, string $targetRoot): array
    {
        if (!is_dir($sourceRoot)) {
            throw new RuntimeException('Missing directory to mirror: ' . $sourceRoot);
        }

        $written = [];
        foreach (self::listFiles($sourceRoot) as $sourcePath) {
            $relativePath = self::relativeTo($sourceRoot, $sourcePath);
            $targetPath = $targetRoot . '/' . $relativePath;
            self::ensureDir(dirname($targetPath));
            if (!copy($sourcePath, $targetPath)) {
                throw new RuntimeException('Failed to mirror file: ' . $sourcePath);
            }
            $written[] = self::relativeTo(dirname($targetRoot), $targetPath);
        }
        return $written;
    }

    private static function readJson(string $path): array
    {
        $raw = file_get_contents($path);
        if ($raw === false) {
            throw new RuntimeException('Failed to read JSON: ' . $path);
        }
        $data = json_decode($raw, true);
        if (!is_array($data)) {
            throw new RuntimeException('Invalid JSON: ' . $path . ' :: ' . json_last_error_msg());
        }
        return $data;
    }

    private static function json(mixed $value): string
    {
        return json_encode($value, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . "\n";
    }

    private static function ensureCleanDir(string $dir): void
    {
        if (is_dir($dir)) {
            self::removeDir($dir);
        }
        self::ensureDir($dir);
    }

    private static function removeDir(string $dir): void
    {
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($dir, FilesystemIterator::SKIP_DOTS),
            RecursiveIteratorIterator::CHILD_FIRST
        );
        foreach ($iterator as $file) {
            $file->isDir() ? rmdir($file->getPathname()) : unlink($file->getPathname());
        }
        rmdir($dir);
    }

    private static function ensureDir(string $dir): void
    {
        if (!is_dir($dir) && !mkdir($dir, 0775, true) && !is_dir($dir)) {
            throw new RuntimeException('Failed to create directory: ' . $dir);
        }
    }

    private static function resolvePath(string $repoRoot, string $path): string
    {
        if (str_starts_with($path, '/') || self::isWindowsAbsolutePath($path)) {
            return self::normalizeSlashes($path);
        }
        return self::normalizeSlashes($repoRoot . '/' . $path);
    }

    private static function isWindowsAbsolutePath(string $path): bool
    {
        return strlen($path) >= 3
            && ctype_alpha($path[0])
            && $path[1] === ':'
            && ($path[2] === '\\' || $path[2] === '/');
    }

    private static function relativeTo(string $base, string $path): string
    {
        $base = rtrim(self::normalizeSlashes($base), '/') . '/';
        $path = self::normalizeSlashes($path);
        return str_starts_with($path, $base) ? substr($path, strlen($base)) : $path;
    }

    private static function normalizeSlashes(string $path): string
    {
        return str_replace("\\", "/", $path);
    }

    private static function phpString(string $value): string
    {
        return var_export($value, true);
    }

    private static function bundleIdentifier(string $name): string
    {
        return 'dev.openm3.' . self::identifierToken($name);
    }

    private static function androidPackage(string $name): string
    {
        return 'dev.openm3.' . self::identifierToken($name);
    }

    private static function pascalIdentifier(string $name): string
    {
        $parts = preg_split('/[^A-Za-z0-9]+/', $name) ?: [];
        $result = '';
        foreach ($parts as $part) {
            if ($part === '') {
                continue;
            }
            $result .= ucfirst(strtolower($part));
        }
        return $result !== '' ? $result : 'DescriptiveApp';
    }

    private static function identifierToken(string $name): string
    {
        $token = strtolower(preg_replace('/[^A-Za-z0-9_]+/', '_', $name) ?? 'descriptive_app');
        $token = trim($token, '_');
        if ($token === '') {
            return 'descriptive_app';
        }
        if (ctype_digit($token[0])) {
            return 'app_' . $token;
        }
        return $token;
    }

    private static function androidJniPrefix(string $packageName, string $className): string
    {
        return 'Java_' . str_replace(['_', '.'], ['_1', '_'], $packageName) . '_' . str_replace('_', '_1', $className);
    }

    private static function pwaServiceWorkerRegistration(): string
    {
        return <<<'HTML'
<script>
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', () => {
        navigator.serviceWorker.register('./service-worker.js').catch((error) => {
          console.warn('[descriptive-app] service worker registration failed', error);
        });
      });
    }
  </script>
HTML;
    }
}

try {
    exit(Materializer::main($argv));
} catch (Throwable $error) {
    fwrite(STDERR, '[materialize] ' . $error->getMessage() . PHP_EOL);
    exit(1);
}
