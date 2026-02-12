<?php

namespace app\controllers\api;

use app\models\entities\Users;
use app\models\search\UsersSearch;
use Yii;

class UsersController extends BaseApiController
{
    public function actionIndex()
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        if (!Yii::$app->user->identity->isAdministrator()) {
            return $this->forbid('Доступ разрешен только администраторам.');
        }

        try {
            $searchModel = new UsersSearch();
            $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
            $dataProvider->pagination = false;
            $dataProvider->query->with('roles');

            $data = [];
            foreach ($dataProvider->getModels() as $model) {
                $roles = $model->roles ?? [];
                $roleNames = [];
                foreach ($roles as $role) {
                    $roleNames[] = $role->role_name;
                }
                $data[] = [
                    'id' => $model->id,
                    'full_name' => $model->full_name,
                    'email' => $model->email,
                    'role_name' => $roleNames ? implode(', ', $roleNames) : null,
                ];
            }

            return ['success' => true, 'data' => $data, 'total' => count($data)];
        } catch (\Throwable $e) {
            return ['success' => false, 'message' => $e->getMessage(), 'data' => [], 'total' => 0];
        }
    }

    public function actionView($id)
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        $current = Yii::$app->user->identity;
        if (!$current->isAdministrator() && (int) $id !== (int) $current->id) {
            return $this->forbid('У вас нет прав для просмотра данных других пользователей.');
        }

        $model = Users::findOne($id);
        if (!$model) {
            Yii::$app->response->statusCode = 404;
            return ['success' => false, 'message' => 'Пользователь не найден.'];
        }

        $roleNames = [];
        foreach ($model->roles as $role) {
            $roleNames[] = $role->role_name;
        }

        return [
            'success' => true,
            'data' => [
                'id' => $model->id,
                'full_name' => $model->full_name,
                'email' => $model->email,
                'roles' => $roleNames ? implode(', ', $roleNames) : null,
            ],
        ];
    }
}
