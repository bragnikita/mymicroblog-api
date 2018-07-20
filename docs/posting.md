## Порядок создание поста
* создаем пустой пост со статусом draft, и пустым контентом

## Порядок обновления поста

* ищем, нет ли у поста draft-та
* если нет, то создаем копию поста
    - создаем пустой пост
    - копируем скалярные поля
    - копируем создаем копии ссылок на изображения
    - создаем копию контента типа body_src
* все изменения производим там
* коммитим
    - обновляем контент
    - удаляем оригинальный пост
    - меняем статус draft-та на published

## API ref

### список
GET `/posts` -> index
IN:
1. <none> - все посты кроме draft
1. show
    * public
    * visible
    * hidden
    * drafts
OUT:
<ok>
```
items: [ { id, title, excerpt, published_at, visability_mode, cover_url } ]
```

### открыть на редактирование
GET `/posts/:id/edit`
OUT:
```
object: {
    id, node, source_type, title, mode, excerpt, body
}
```
### новый пост
POST `/posts` -> create
IN:
OUT:
<created>
```
object: {
    id, mode, source_type, title
}
```

### обновить атрибуты
PATCH `/posts/:id` -> update
IN:
```
object: {
    mode, title, source_type, datetime_of_placement, cover_id
}
```
OUT:
<ok>

### обновить контент
PATCH `/posts/:id/content` -> update_content
IN:
<content-type: plain/text>
OUT:
<ok>

### опубликовать
POST `/posts/:id/commit` -> commit
IN:
OUT:
<ok>

### изменить видимость
POST: `/posts/:id/visability` -> visability
IN:
```
params: {
    mode: ( 1 | 2 | 3 )
}
```
OUT:
<ok>

### превью
GET: `/posts/:id/preview` -> preview
IN:
OUT:
<content-type: application/html>

### удалить
DELETE: `/posts/:id` -> destroy
IN:
OUT:
<ok>