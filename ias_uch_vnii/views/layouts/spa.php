<?php
use yii\helpers\Html;
$this->registerCsrfMetaTags();
$this->registerMetaTag(['charset' => Yii::$app->charset], 'charset');
$this->registerMetaTag(['name' => 'viewport', 'content' => 'width=device-width, initial-scale=1']);

$appContext = $this->params['appContext'] ?? [];
$manifestPath = Yii::getAlias('@webroot/spa/manifest.json');
$manifestPathAlt = Yii::getAlias('@webroot/spa/.vite/manifest.json');
$manifest = null;
if (!is_file($manifestPath) && is_file($manifestPathAlt)) {
    $manifestPath = $manifestPathAlt;
}
if (is_file($manifestPath)) {
    $manifest = json_decode(file_get_contents($manifestPath), true);
}

$viteDevServer = 'http://localhost:5173';
$isDev = YII_ENV_DEV && !$manifest;
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="<?= Yii::$app->language ?>">
<head>
    <title><?= Html::encode($this->title ?? 'IAS UCH VNII') ?></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <?php if ($isDev): ?>
        <script type="module" src="<?= $viteDevServer ?>/@vite/client"></script>
    <?php endif; ?>
    <?php
    if ($manifest && isset($manifest['src/main.js'])) {
        $entry = $manifest['src/main.js'];
        if (!empty($entry['css'])) {
            foreach ($entry['css'] as $cssFile) {
                echo Html::cssFile('@web/spa/' . $cssFile);
            }
        }
    }
    ?>
    <?php $this->head() ?>
</head>
<body>
<?php $this->beginBody() ?>

<script>
    window.__APP_CONTEXT__ = <?= json_encode($appContext, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) ?>;
</script>

<?= $content ?>

<?php
if ($isDev) {
    echo Html::jsFile($viteDevServer . '/src/main.js', ['type' => 'module']);
} elseif ($manifest && isset($manifest['src/main.js'])) {
    $entry = $manifest['src/main.js'];
    echo Html::jsFile('@web/spa/' . $entry['file'], ['type' => 'module']);
}
?>

<?php $this->endBody() ?>
</body>
</html>
<?php $this->endPage() ?>
