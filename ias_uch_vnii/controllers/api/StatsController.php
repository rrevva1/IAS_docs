<?php

namespace app\controllers\api;

use app\models\entities\Tasks;
use app\models\entities\Users;
use app\models\dictionaries\DicTaskStatus;
use Yii;

class StatsController extends BaseApiController
{
    public function actionTasks()
    {
        if ($auth = $this->requireLogin()) {
            return $auth;
        }

        $statusStats = Tasks::find()
            ->select(['status_id', 'COUNT(*) as count'])
            ->groupBy('status_id')
            ->asArray()
            ->all();

        $statusCounts = [];
        $totalTasks = 0;
        foreach ($statusStats as $stat) {
            $statusCounts[$stat['status_id']] = (int) $stat['count'];
            $totalTasks += (int) $stat['count'];
        }

        $statuses = [];
        foreach (DicTaskStatus::find()->orderBy(['sort_order' => SORT_ASC])->all() as $status) {
            $count = $statusCounts[$status->id] ?? 0;
            $statuses[] = [
                'status_id' => $status->id,
                'status_name' => $status->status_name,
                'count' => $count,
                'percentage' => $totalTasks > 0 ? round(($count / $totalTasks) * 100, 2) : 0,
            ];
        }

        $userStats = Tasks::find()
            ->select(['requester_id', 'COUNT(*) as count'])
            ->groupBy('requester_id')
            ->with('requester')
            ->asArray()
            ->all();

        $byUsers = [];
        foreach ($userStats as $stat) {
            $user = Users::findOne($stat['requester_id']);
            $count = (int) $stat['count'];
            $byUsers[] = [
                'name' => $user ? $user->full_name : 'Неизвестный пользователь',
                'count' => $count,
                'percentage' => $totalTasks > 0 ? round(($count / $totalTasks) * 100, 2) : 0,
            ];
        }

        $resolvedStatusId = (int) (DicTaskStatus::find()
            ->where(['status_code' => 'resolved'])
            ->select('id')
            ->scalar() ?: DicTaskStatus::find()
                ->where(['status_code' => 'closed'])
                ->select('id')
                ->scalar());

        $executorStats = Tasks::find()
            ->select(['executor_id', 'COUNT(*) as count'])
            ->where(['status_id' => $resolvedStatusId])
            ->andWhere(['not', ['executor_id' => null]])
            ->groupBy('executor_id')
            ->with('executor')
            ->asArray()
            ->all();

        $totalCompleted = array_sum(array_column($executorStats, 'count'));
        $byExecutors = [];
        foreach ($executorStats as $stat) {
            $executor = Users::findOne($stat['executor_id']);
            $count = (int) $stat['count'];
            $byExecutors[] = [
                'name' => $executor ? $executor->full_name : 'Неизвестный исполнитель',
                'count' => $count,
                'percentage' => $totalCompleted > 0 ? round(($count / $totalCompleted) * 100, 2) : 0,
            ];
        }

        return [
            'success' => true,
            'data' => [
                'statuses' => $statuses,
                'byUsers' => $byUsers,
                'byExecutors' => $byExecutors,
            ],
        ];
    }
}
