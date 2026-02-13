<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $software app\models\entities\Software[] */
/* @var $licenses app\models\entities\License[] */

$this->title = 'ПО и лицензии';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="software-index">
    <h1><?= Html::encode($this->title) ?></h1>
    <p class="text-muted">Справочник программного обеспечения и учёт сроков действия лицензий (минимальный контур по ТЗ 5.1.12).</p>

    <h3>Программное обеспечение</h3>
    <?php if (empty($software)): ?>
        <p>Список пуст. Добавление записей — через миграции или расширение функционала.</p>
    <?php else: ?>
        <table class="table table-bordered">
            <thead><tr><th>Наименование</th><th>Версия</th></tr></thead>
            <tbody>
                <?php foreach ($software as $s): ?>
                <tr><td><?= Html::encode($s->name) ?></td><td><?= Html::encode($s->version) ?></td></tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>

    <h3>Лицензии (срок действия)</h3>
    <?php if (empty($licenses)): ?>
        <p>Нет записей о лицензиях.</p>
    <?php else: ?>
        <table class="table table-bordered">
            <thead><tr><th>ПО</th><th>Срок действия</th><th>Примечание</th></tr></thead>
            <tbody>
                <?php foreach ($licenses as $l): ?>
                <tr>
                    <td><?= $l->software ? Html::encode($l->software->name) : '—' ?></td>
                    <td><?= Html::encode($l->valid_until) ?></td>
                    <td><?= Html::encode($l->notes) ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
</div>
