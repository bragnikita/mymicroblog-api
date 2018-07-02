# API

## вспомогательное

```
upload_image(type, image_content): { result, message, data: {id, url, type} }
get(id): {result, message, data: {id, url, type}}
image(id): HTTP redirect, Status: 301, Location: url
```

## редактирование скрипта

```
create/update( { name, scopes: []}): {id, result, message}
delete(id): {result, message}
update_script_data( { id, script_data: text, characters: [ ids ] }): {id, result}
```

## редактирование базы персонажей

```
chara_add / chara_update (CharaType):
{
result, message
data: CharaType
}

chara_delete(id)
{
result, message
}

list_add / list_update ( {id, name, scopes:[]} ):
{ result, message, data: {id, name, scopes:[]} }

add_chara_to_list / remove_chara_from_list (chara_id, list_id)
{
    result, message
}

lists(scope):
{
lists: [
 {id, name, scopes: []}
]
}

list (id) :
{
    id
    name
    character: [ CharaType ]
    owner: UserType
}
```

## пользователи

```
create/update
({
    id (update)
    username
    password,
    is_active
})
```

# JSON типы

## CharaType

```
id (get, update)
fullname
display_name
prefixes
avatar_id
avatar_url: url (get)
color: css color
scopes: []
created_by: UserType (get)
```

## UserType
```
id
username
```



