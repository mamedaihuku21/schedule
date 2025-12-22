Usersテーブル
| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| user_name          | string | null: false |
| encrypted_password | string | null: false |
| email              | string | null: false |

has_many :events
has_many :categories

Categoriesテーブル
| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| user          | references | null: false, foreign_key: true |
| category_name | string     | null: false                    |
| color_code    | string     | null: false                    |

belongs_to :user
has_many :events

Eventsテーブル
| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| user       | references | null: false, foreign_key: true |
| category   | references | null: false, foreign_key: true |
| title      | string     | null: false                    |
| memo       | text       |                                |
| start_time | datetime   | null: false                    |
| end_time   | datetime   | null: false                    |
| temporary  | boolean    | null: false                    |

belongs_to :user
belongs_to :category
has_one :notification

Notificationsテーブル
| Column    | Type       | Options                        |
| --------- | ---------- | ------------------------------ |
| event     | references | null: false, foreign_key: true |
| notify_at | datetime   | null: false                    |

belongs_to :event