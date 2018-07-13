## Порядок создание поста
* создаем пустой пост с режимом hidden
* создаем draft поста и body_src

## Порядок обновления поста

### при промежуточном сохранении
* ищем draft поста
* обновляем атрибуты

### при промежуточном сохранении контента
* ищем draft поста
* сохранить контент в body_src
* создать контент с типом body_result если нет
* выполнить преобразование контента и сохранить в body_result

### при обновлении поста
* скопировать атрибуты из draft в оригинальный пост
* заменить объект body_result у оригинального поста на новый

## API ref

### список
GET `/posts` -> index
IN:
1. <none> - все посты кроме draft
1. show
    * public
    * published
    * unpublished
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