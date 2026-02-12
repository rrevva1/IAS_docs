<?php

namespace app\controllers\api;

use app\models\search\ArmSearch;
use Yii;

class ArmController extends BaseApiController
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
            $searchModel = new ArmSearch();
            $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
            $dataProvider->pagination = false;

            $equipmentIds = array_map(function ($m) {
                return $m->id;
            }, $dataProvider->models);

            $charsByEquipment = $this->loadPartCharValuesByEquipment($equipmentIds);
            $data = [];
            foreach ($dataProvider->models as $model) {
                $chars = $charsByEquipment[$model->id] ?? [];
                $data[] = [
                    'id' => $model->id,
                    'user_name' => $model->responsibleUser ? $model->responsibleUser->getDisplayName() : '',
                    'location_name' => $model->location ? $model->location->name : '',
                    'cpu' => $chars['cpu'] ?? '',
                    'ram' => $chars['ram'] ?? '',
                    'disk' => $chars['disk'] ?? '',
                    'system_block' => $model->name ?? '',
                    'inventory_number' => $model->inventory_number ?? '',
                    'monitor' => $chars['monitor'] ?? '',
                    'hostname' => $chars['hostname'] ?? '',
                    'ip' => $chars['ip'] ?? '',
                    'os' => $chars['os'] ?? '',
                    'other_tech' => $model->description ?? '',
                ];
            }

            return ['success' => true, 'data' => $data, 'total' => count($data)];
        } catch (\Throwable $e) {
            return ['success' => false, 'message' => $e->getMessage(), 'data' => [], 'total' => 0];
        }
    }

    /**
     * Загружает значения из part_char_values по списку id оборудования.
     * Поддерживаются схемы: part_char_values.id_arm = equipment.id или part_char_values.equipment_id = equipment.id.
     */
    private function loadPartCharValuesByEquipment(array $equipmentIds): array
    {
        if (empty($equipmentIds)) {
            return [];
        }
        $db = Yii::$app->db;
        $idCol = 'id_arm';
        try {
            $schema = $db->getTableSchema('part_char_values', true);
            if (!$schema) {
                return array_fill_keys($equipmentIds, []);
            }
            if (isset($schema->columns['equipment_id'])) {
                $idCol = 'equipment_id';
            }
        } catch (\Throwable $e) {
            return array_fill_keys($equipmentIds, []);
        }
        try {
            $rows = (new \yii\db\Query())
                ->select([
                    'eq_id' => 'pcv.' . $idCol,
                    'part_name' => 'sp.name',
                    'char_name' => 'sc.name',
                    'value_text' => new \yii\db\Expression('COALESCE(pcv.value_text, pcv.value_num::text)'),
                ])
                ->from(['pcv' => 'part_char_values'])
                ->innerJoin(['sp' => 'spr_parts'], 'sp.id = pcv.part_id')
                ->innerJoin(['sc' => 'spr_chars'], 'sc.id = pcv.char_id')
                ->where(['pcv.' . $idCol => $equipmentIds])
                ->all($db);
        } catch (\Throwable $e) {
            return array_fill_keys($equipmentIds, []);
        }

        $out = array_fill_keys($equipmentIds, []);
        foreach ($rows as $row) {
            $key = (int) $row['eq_id'];
            $part = mb_strtolower(trim((string) $row['part_name']));
            $char = mb_strtolower(trim((string) $row['char_name']));
            $value = trim((string) $row['value_text']);
            if ($value === '') {
                continue;
            }

            if ($part === 'цп' || $char === 'цп' || $char === 'cpu') {
                $out[$key]['cpu'] = $value;
            } elseif ($part === 'озу' || $char === 'озу' || $char === 'ram') {
                $out[$key]['ram'] = $value;
            } elseif ($part === 'диск' || $char === 'диск' || $char === 'hdd') {
                $out[$key]['disk'] = $value;
            } elseif ($part === 'монитор' || $char === 'монитор') {
                $out[$key]['monitor'] = $value;
            } elseif ($char === 'имя пк' || $char === 'hostname') {
                $out[$key]['hostname'] = $value;
            } elseif ($char === 'ip' || $char === 'ip адрес') {
                $out[$key]['ip'] = $value;
            } elseif ($char === 'ос' || $char === 'os') {
                $out[$key]['os'] = $value;
            }
        }
        return $out;
    }
}
