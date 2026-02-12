<?php

namespace app\controllers\api;

use Yii;
use yii\web\Controller;
use yii\web\Response;

class BaseApiController extends Controller
{
    public $enableCsrfValidation = true;

    public function beforeAction($action)
    {
        Yii::$app->response->format = Response::FORMAT_JSON;
        return parent::beforeAction($action);
    }

    protected function requireLogin()
    {
        if (Yii::$app->user->isGuest) {
            Yii::$app->response->statusCode = 401;
            return ['success' => false, 'message' => 'Требуется авторизация.'];
        }
        return null;
    }

    protected function forbid(string $message = 'Недостаточно прав.')
    {
        Yii::$app->response->statusCode = 403;
        return ['success' => false, 'message' => $message];
    }
}
