<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */
/* @var $users array [id => full_name] */

$this->title = 'Журнал аудита';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="audit-index">
    <h1><?= Html::encode($this->title) ?></h1>

    <?php $form = ActiveForm::begin(['method' => 'get', 'action' => ['index']]); ?>
    <div class="row">
        <div class="col-md-2">
            <label>С</label>
            <input type="date" name="from" class="form-control" value="<?= Html::encode(Yii::$app->request->get('from')) ?>">
        </div>
        <div class="col-md-2">
            <label>По</label>
            <input type="date" name="to" class="form-control" value="<?= Html::encode(Yii::$app->request->get('to')) ?>">
        </div>
        <div class="col-md-2">
            <label>Пользователь</label>
            <?= Html::dropDownList('actor_id', Yii::$app->request->get('actor_id'), ['' => '—'] + $users, ['class' => 'form-control']) ?>
        </div>
        <div class="col-md-2">
            <label>Тип операции</label>
            <input type="text" name="action_type" class="form-control" value="<?= Html::encode(Yii::$app->request->get('action_type')) ?>" placeholder="task.create">
        </div>
        <div class="col-md-2">
            <label>Тип объекта</label>
            <?= Html::dropDownList('object_type', Yii::$app->request->get('object_type'), [
                '' => '—',
                'task' => 'Заявка',
                'user' => 'Пользователь',
                'attachment' => 'Вложение',
                'equipment' => 'Актив',
            ], ['class' => 'form-control']) ?>
        </div>
        <div class="col-md-2">
            <label>&nbsp;</label>
            <?= Html::submitButton('Фильтр', ['class' => 'btn btn-primary btn-block']) ?>
        </div>
    </div>
    <?php ActiveForm::end(); ?>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
            'event_time:datetime',
            [
                'attribute' => 'actor_id',
                'value' => function ($model) {
                    return $model->actor ? $model->actor->full_name : '—';
                },
            ],
            'action_type',
            'object_type',
            'object_id',
            'result_status',
        ],
    ]) ?>
</div>
