<?php

namespace app\models\entities;

use yii\db\ActiveRecord;

/**
 * Лицензия (licenses).
 * @property int $id
 * @property int $software_id
 * @property string|null $valid_until
 * @property string|null $notes
 */
class License extends ActiveRecord
{
    public static function tableName()
    {
        return 'licenses';
    }

    public function getSoftware()
    {
        return $this->hasOne(Software::class, ['id' => 'software_id']);
    }
}
