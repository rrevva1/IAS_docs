<?php

namespace app\controllers;

use app\models\entities\Software;
use app\models\entities\License;
use Yii;
use yii\filters\AccessControl;
use yii\web\Controller;

/**
 * Справочник ПО и лицензий (только для администраторов).
 */
class SoftwareController extends Controller
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
            ],
        ];
    }

    public function actionIndex()
    {
        $software = Software::find()->orderBy('name')->all();
        $licenses = License::find()->with('software')->orderBy('valid_until')->all();
        return $this->render('index', ['software' => $software, 'licenses' => $licenses]);
    }
}
