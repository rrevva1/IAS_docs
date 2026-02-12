<?php

namespace app\controllers\api;

use Yii;

class MetaController extends BaseApiController
{
    public function actionMe()
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        $user = Yii::$app->user->identity;
        $roles = [];
        foreach ($user->roles as $role) {
            $roles[] = $role->role_name;
        }

        return [
            'success' => true,
            'data' => [
                'id' => $user->id,
                'full_name' => $user->full_name,
                'email' => $user->email,
                'roles' => $roles ? implode(', ', $roles) : null,
            ],
        ];
    }
}
