<?php

namespace app\models\entities;

use yii\db\ActiveRecord;

/**
 * Справочник ПО (software).
 * @property int $id
 * @property string $name
 * @property string|null $version
 * @property string $created_at
 */
class Software extends ActiveRecord
{
    public static function tableName()
    {
        return 'software';
    }

    public function rules()
    {
        return [
            [['name'], 'required'],
            [['name'], 'string', 'max' => 200],
            [['version'], 'string', 'max' => 100],
        ];
    }
}
