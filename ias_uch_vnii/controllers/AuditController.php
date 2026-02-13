<?php

namespace app\controllers;

use app\models\entities\AuditEvent;
use app\models\entities\Users;
use Yii;
use yii\data\ActiveDataProvider;
use yii\filters\AccessControl;
use yii\web\Controller;

/**
 * Просмотр журнала аудита (только для администраторов).
 */
class AuditController extends Controller
{
    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::class,
                'rules' => [
                    [
                        'allow' => true,
                        'roles' => ['@'],
                        'matchCallback' => function () {
                            return Yii::$app->user->identity && Yii::$app->user->identity->isAdministrator();
                        },
                    ],
                ],
                'denyCallback' => function () {
                    throw new \yii\web\ForbiddenHttpException('Доступ запрещён.');
                },
            ],
        ];
    }

    public function actionIndex()
    {
        $query = AuditEvent::find()->with('actor')->orderBy(['event_time' => SORT_DESC]);
        $from = Yii::$app->request->get('from');
        $to = Yii::$app->request->get('to');
        $actorId = Yii::$app->request->get('actor_id');
        $actionType = Yii::$app->request->get('action_type');
        $objectType = Yii::$app->request->get('object_type');
        if ($from !== null && $from !== '') {
            $query->andWhere(['>=', 'event_time', $from . ' 00:00:00']);
        }
        if ($to !== null && $to !== '') {
            $query->andWhere(['<=', 'event_time', $to . ' 23:59:59']);
        }
        if ($actorId !== null && $actorId !== '') {
            $query->andWhere(['actor_id' => (int) $actorId]);
        }
        if ($actionType !== null && $actionType !== '') {
            $query->andWhere(['action_type' => $actionType]);
        }
        if ($objectType !== null && $objectType !== '') {
            $query->andWhere(['object_type' => $objectType]);
        }
        $dataProvider = new ActiveDataProvider([
            'query' => $query,
            'pagination' => ['pageSize' => 50],
        ]);
        $users = Users::find()->select(['full_name', 'id'])->indexBy('id')->orderBy('full_name')->column();
        return $this->render('index', [
            'dataProvider' => $dataProvider,
            'users' => $users,
        ]);
    }
}
