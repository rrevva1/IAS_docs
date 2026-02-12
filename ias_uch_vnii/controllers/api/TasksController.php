<?php

namespace app\controllers\api;

use app\models\entities\DeskAttachments;
use app\models\entities\Tasks;
use app\models\entities\Users;
use app\models\dictionaries\DicTaskStatus;
use app\models\search\TasksSearch;
use Yii;
use yii\web\UploadedFile;

class TasksController extends BaseApiController
{
    public function actionIndex()
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        try {
            $searchModel = new TasksSearch();
            $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
            $dataProvider->pagination = false;

            $data = [];
            foreach ($dataProvider->models as $model) {
                $data[] = $this->serializeTask($model);
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

        $model = Tasks::findOne($id);
        if (!$model) {
            Yii::$app->response->statusCode = 404;
            return ['success' => false, 'message' => 'Заявка не найдена.'];
        }

        if (!$this->canAccessTask($model)) {
            return $this->forbid('Нет доступа к заявке.');
        }

        return ['success' => true, 'data' => $this->serializeTask($model, true)];
    }

    public function actionCreate()
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        $model = new Tasks();
        $data = Yii::$app->request->post();
        if (!$data) {
            $data = Yii::$app->request->bodyParams;
        }

        if (array_key_exists('executor_id', $data) && $data['executor_id'] === '') {
            $data['executor_id'] = null;
        }
        $model->load($data, '');
        $model->requester_id = Yii::$app->user->id;

        if (empty($model->status_id)) {
            $model->status_id = DicTaskStatus::getDefaultStatusId();
        }

        $uploaded = UploadedFile::getInstancesByName('uploadFiles');
        if (empty($uploaded)) {
            $uploaded = UploadedFile::getInstances($model, 'uploadFiles');
        }
        $model->uploadFiles = $uploaded;

        if ($model->save()) {
            $model->uploadFiles();
            return ['success' => true, 'data' => $this->serializeTask($model, true)];
        }

        Yii::$app->response->statusCode = 422;
        return ['success' => false, 'errors' => $model->getErrors()];
    }

    public function actionUpdate($id)
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        $model = Tasks::findOne($id);
        if (!$model) {
            Yii::$app->response->statusCode = 404;
            return ['success' => false, 'message' => 'Заявка не найдена.'];
        }

        if (!$this->canAccessTask($model)) {
            return $this->forbid('Нет доступа к заявке.');
        }

        $data = Yii::$app->request->post();
        if (!$data) {
            $data = Yii::$app->request->bodyParams;
        }

        if (array_key_exists('executor_id', $data) && $data['executor_id'] === '') {
            $data['executor_id'] = null;
        }
        $model->load($data, '');

        if ($model->save()) {
            return ['success' => true, 'data' => $this->serializeTask($model, true)];
        }

        Yii::$app->response->statusCode = 422;
        return ['success' => false, 'errors' => $model->getErrors()];
    }

    public function actionOptions()
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        $statuses = DicTaskStatus::find()->orderBy(['sort_order' => SORT_ASC])->all();
        $statusList = array_map(function ($status) {
            return ['id' => $status->id, 'name' => $status->status_name];
        }, $statuses);

        $executors = [];
        if (Yii::$app->user->identity->isAdministrator()) {
            $executors = Users::find()
                ->select(['id', 'full_name'])
                ->orderBy(['full_name' => SORT_ASC])
                ->asArray()
                ->all();
        }

        $executorList = array_map(function ($user) {
            return ['id' => $user['id'], 'name' => $user['full_name']];
        }, $executors);

        return [
            'success' => true,
            'data' => [
                'statuses' => $statusList,
                'executors' => $executorList,
            ],
        ];
    }

    public function actionDeleteAttachment($id)
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        $model = Tasks::findOne($id);
        if (!$model) {
            Yii::$app->response->statusCode = 404;
            return ['success' => false, 'message' => 'Заявка не найдена.'];
        }

        if (!$this->canAccessTask($model)) {
            return $this->forbid('Нет доступа к заявке.');
        }

        $attachmentId = Yii::$app->request->post('attachment_id');
        if (!$attachmentId) {
            Yii::$app->response->statusCode = 400;
            return ['success' => false, 'message' => 'Не указан attachment_id.'];
        }

        $attachment = DeskAttachments::findOne($attachmentId);
        if (!$attachment) {
            Yii::$app->response->statusCode = 404;
            return ['success' => false, 'message' => 'Вложение не найдено.'];
        }

        $model->removeAttachment((int) $attachmentId);
        $model->save(false);
        $attachment->delete();

        return ['success' => true];
    }

    private function serializeTask(Tasks $model, bool $withAttachments = false): array
    {
        $data = [
            'id' => $model->id,
            'description' => $model->description,
            'status_id' => $model->status_id,
            'status_name' => $model->status ? $model->status->status_name : '',
            'user_id' => $model->requester_id,
            'user_name' => $model->requester ? $model->requester->full_name : '',
            'executor_id' => $model->executor_id,
            'executor_name' => $model->executor ? $model->executor->full_name : '',
            'comment' => $model->comment,
            'date' => $model->created_at ? Yii::$app->formatter->asDatetime($model->created_at, 'php:d.m.Y H:i') : '',
            'last_time_update' => $model->updated_at ? Yii::$app->formatter->asDatetime($model->updated_at, 'php:d.m.Y H:i') : '',
        ];

        if ($withAttachments) {
            $data['attachments'] = array_map(function ($attachment) {
                return [
                    'id' => $attachment->id,
                    'name' => $attachment->original_name,
                    'icon' => $attachment->getFileIcon(),
                    'is_previewable' => $attachment->isImageOrScan(),
                    'preview_url' => $attachment->getPreviewUrl(),
                    'download_url' => $attachment->getDownloadUrl(),
                ];
            }, $model->getAllAttachments());
        }

        return $data;
    }

    private function canAccessTask(Tasks $model): bool
    {
        $user = Yii::$app->user->identity;
        if (!$user) {
            return false;
        }
        if ($user->isAdministrator()) {
            return true;
        }
        return $model->requester_id == $user->id || $model->executor_id == $user->id;
    }
}
