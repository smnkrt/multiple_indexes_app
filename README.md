# About
Basically a Rails app used to show the basics of how queries works when using multiple indexes.

# Setup

When using mysql make sure to set database adapter to `mysql2` in `config/database.yml`:


# Multiple indexes in MySQL and PSQL:

## MYSQL
Connect to database: `mysql> use indexes_app_db;`

### Without `index_items_on_category_id`:

```
mysql> show indexes from items;
+-------+------------+----------------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name                               | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| items |          0 | PRIMARY                                |            1 | id          | A         |         100 |     NULL | NULL   |      | BTREE      |         |               |
| items |          1 | index_items_on_user_id_and_category_id |            1 | user_id     | A         |          10 |     NULL | NULL   | YES  | BTREE      |         |               |
| items |          1 | index_items_on_user_id_and_category_id |            2 | category_id | A         |          20 |     NULL | NULL   | YES  | BTREE      |         |               |
+-------+------------+----------------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
```

```
mysql> explain SELECT * from items where  user_id > 2;
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys                          | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | items | NULL       | ALL  | index_items_on_user_id_and_category_id | NULL | NULL    | NULL |  100 |    80.00 | Using where |
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
```

```
mysql> explain SELECT * from items where  user_id > 2 and category_id > 1;
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys                          | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | items | NULL       | ALL  | index_items_on_user_id_and_category_id | NULL | NULL    | NULL |  100 |    26.66 | Using where |
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
```

```
mysql> explain SELECT * from items where  category_id > 1;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | items | NULL       | ALL  | NULL          | NULL | NULL    | NULL |  100 |    33.33 | Using where |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
```

### With `index_items_on_category_id`:

```
mysql> show indexes from items;
+-------+------------+----------------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name                               | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| items |          0 | PRIMARY                                |            1 | id          | A         |         100 |     NULL | NULL   |      | BTREE      |         |               |
| items |          1 | index_items_on_user_id_and_category_id |            1 | user_id     | A         |          10 |     NULL | NULL   | YES  | BTREE      |         |               |
| items |          1 | index_items_on_user_id_and_category_id |            2 | category_id | A         |          20 |     NULL | NULL   | YES  | BTREE      |         |               |
| items |          1 | index_items_on_category_id             |            1 | category_id | A         |           2 |     NULL | NULL   | YES  | BTREE      |         |               |
+-------+------------+----------------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
```

```
mysql> explain SELECT * from items where  user_id > 2;
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys                          | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | items | NULL       | ALL  | index_items_on_user_id_and_category_id | NULL | NULL    | NULL |  100 |    80.00 | Using where |
+----+-------------+-------+------------+------+----------------------------------------+------+---------+------+------+----------+-------------+
```

```
mysql> explain SELECT * from items where  user_id > 2 and category_id > 1;
+----+-------------+-------+------------+------+-------------------------------------------------------------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys                                                     | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+-------------------------------------------------------------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | items | NULL       | ALL  | index_items_on_user_id_and_category_id,index_items_on_category_id | NULL | NULL    | NULL |  100 |    40.00 | Using where |
+----+-------------+-------+------------+------+-------------------------------------------------------------------+------+---------+------+------+----------+-------------+
```

```
mysql> explain SELECT * from items where  category_id > 1;
+----+-------------+-------+------------+------+----------------------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys              | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+----------------------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | items | NULL       | ALL  | index_items_on_category_id | NULL | NULL    | NULL |  100 |    50.00 | Using where |
+----+-------------+-------+------------+------+----------------------------+------+---------+------+------+----------+-------------+
```

## POSTGRESQL

Connect to database: `postgres> \c indexes_app_db`

### Without `index_items_on_category_id`:

```
indexes_app_db=# select * from pg_indexes where tablename='items';
 public     | items     | items_pkey                             |            | CREATE UNIQUE INDEX items_pkey ON items USING btree (id)
 public     | items     | index_items_on_user_id_and_category_id |            | CREATE INDEX index_items_on_user_id_and_category_id ON items USING btree (user_id, category_id)
```

```
indexes_app_db=#  explain SELECT * from items where user_id > 1;
 Bitmap Heap Scan on items  (cost=6.53..20.37 rows=307 width=60)
   Recheck Cond: (user_id > 1)
   ->  Bitmap Index Scan on index_items_on_user_id_and_category_id  (cost=0.00..6.45 rows=307 width=0)
         Index Cond: (user_id > 1)
```

```
indexes_app_db=#  explain SELECT * from items where user_id > 1 and category_id > 1;
 Bitmap Heap Scan on items  (cost=7.25..18.78 rows=102 width=60)
   Recheck Cond: ((user_id > 1) AND (category_id > 1))
   ->  Bitmap Index Scan on index_items_on_user_id_and_category_id  (cost=0.00..7.22 rows=102 width=0)
         Index Cond: ((user_id > 1) AND (category_id > 1))
```

```
indexes_app_db=#  explain SELECT * from items where category_id > 1;
 Seq Scan on items  (cost=0.00..21.50 rows=307 width=60)
   Filter: (category_id > 1)
```

### With `index_items_on_category_id`:

```
indexes_app_db=# select * from pg_indexes where tablename='items';
 public     | items     | items_pkey                             |            | CREATE UNIQUE INDEX items_pkey ON items USING btree (id)
 public     | items     | index_items_on_user_id_and_category_id |            | CREATE INDEX index_items_on_user_id_and_category_id ON items USING btree (user_id, category_id)
 public     | items     | index_items_on_category_id             |            | CREATE INDEX index_items_on_category_id ON items USING btree (category_id)
```

```
indexes_app_db=#  explain SELECT * from items where user_id > 1;
 Bitmap Heap Scan on items  (cost=6.53..20.37 rows=307 width=60)
   Recheck Cond: (user_id > 1)
   ->  Bitmap Index Scan on index_items_on_user_id_and_category_id  (cost=0.00..6.45 rows=307 width=0)
         Index Cond: (user_id > 1)
```

```
indexes_app_db=#  explain SELECT * from items where user_id > 1 and category_id > 1;
 Bitmap Heap Scan on items  (cost=7.25..18.78 rows=102 width=60)
   Recheck Cond: ((user_id > 1) AND (category_id > 1))
   ->  Bitmap Index Scan on index_items_on_user_id_and_category_id  (cost=0.00..7.22 rows=102 width=0)
         Index Cond: ((user_id > 1) AND (category_id > 1))
```

```
indexes_app_db=#  explain SELECT * from items where category_id > 1;
 Bitmap Heap Scan on items  (cost=6.53..20.37 rows=307 width=60)
   Recheck Cond: (category_id > 1)
   ->  Bitmap Index Scan on index_items_on_category_id  (cost=0.00..6.45 rows=307 width=0)
         Index Cond: (category_id > 1)
```
