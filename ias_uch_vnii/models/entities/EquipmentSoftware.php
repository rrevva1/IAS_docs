<?php

namespace app\models\entities;

use yii\db\ActiveRecord;

/**
 * Связь оборудование — ПО (equipment_software).
 * @property int $id
 * @property int $equipment_id
 * @property int $software_id
 * @property string|null $installed_at
 */
class EquipmentSoftware extends ActiveRecord
{
    public static function tableName()
    {
        return 'equipment_software';
    }

    public function getEquipment()
    {
        return $this->hasOne(Equipment::class, ['id' => 'equipment_id']);
    }

    public function getSoftware()
    {
        return $this->hasOne(Software::class, ['id' => 'software_id']);
    }
}
