#ifndef __JSON_UTILS_H__
#define __JSON_UTILS_H__


#define JSON_GET_DOUBLE(obj, key, val)                              \
{                                                                   \
    json_object* myobj = json_object_object_get(obj, key);          \
    if(!myobj){                                                     \
        sprintf(_sym_parse_error, "Missing %s", key);               \
        _sym_parse_ok = 0;                                          \
    }else if(!json_object_is_type(myobj, json_type_double) &&       \
            !json_object_is_type(myobj, json_type_int)){            \
        sprintf(_sym_parse_error, "%s is not a double", key);       \
        _sym_parse_ok = 0;                                          \
    }else{                                                          \
        val = json_object_get_double(myobj);                        \
        _sym_parse_ok = 1;                                          \
    }                                                               \
}



#define JSON_SET_DOUBLE(obj, key, val)                              \
{                                                                   \
    json_object* myobj = json_object_new_double(val);               \
    json_object_object_add(obj, key, myobj);                        \
}



#define JSON_GET_STRING(obj, key, val)                              \
{                                                                   \
    json_object* myobj = json_object_object_get(obj, key);          \
    if(!myobj){                                                     \
        sprintf(_sym_parse_error, "Missing %s", key);               \
        _sym_parse_ok = 0;                                          \
    }else if(!json_object_is_type(myobj, json_type_string)){        \
        sprintf(_sym_parse_error, "%s is not a string", key);       \
        _sym_parse_ok = 0;                                          \
    }else{                                                          \
        val = json_object_get_string(myobj);                        \
        _sym_parse_ok = 1;                                          \
    }                                                               \
}

#define JSON_SET_STRING(obj, key, val)                              \
{                                                                   \
    json_object* myobj = json_object_new_string(val);               \
    json_object_object_add(obj, key, myobj);                        \
}


#define JSON_GET_OBJECT(obj, key, val)                              \
{                                                                   \
    json_object* myobj = json_object_object_get(obj, key);          \
    if(!myobj){                                                     \
        sprintf(_sym_parse_error, "Missing %s", key);               \
        _sym_parse_ok = 0;                                          \
    }else if(!json_object_is_type(myobj, json_type_object)){        \
        sprintf(_sym_parse_error, "%s is not a string", key);       \
        _sym_parse_ok = 0;                                          \
    }else{                                                          \
        val = myobj;                                                \
        _sym_parse_ok = 1;                                          \
    }                                                               \
}



#define JSON_GET_BOOLEAN(obj, key, val)                              \
{                                                                   \
    json_object* myobj = json_object_object_get(obj, key);          \
    if(!myobj){                                                     \
        sprintf(_sym_parse_error, "Missing %s", key);               \
        _sym_parse_ok = 0;                                          \
    }else if(!json_object_is_type(myobj, json_type_boolean) ){      \
        sprintf(_sym_parse_error, "%s is not a double", key);       \
        _sym_parse_ok = 0;                                          \
    }else{                                                          \
        val = json_object_get_boolean(myobj);                       \
        _sym_parse_ok = 1;                                          \
    }                                                               \
}



#define JSON_GET_ARRAY(obj, key, val)                               \
{                                                                   \
    json_object* myobj = json_object_object_get(obj, key);          \
    if(!myobj){                                                     \
        sprintf(_sym_parse_error, "Missing %s", key);               \
        _sym_parse_ok = 0;                                          \
    }else if(!json_object_is_type(myobj, json_type_array)){         \
        sprintf(_sym_parse_error, "%s is not a array", key);        \
        _sym_parse_ok = 0;                                          \
    }else{                                                          \
        val = myobj;                                                \
        _sym_parse_ok = 1;                                          \
    }                                                               \
}

#endif
