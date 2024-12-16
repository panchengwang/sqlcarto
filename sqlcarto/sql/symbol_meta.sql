  
-- Availability: 3.4.2 
-- 预定义好的地图符号postgres 
-- 地图符号中的线宽、点划线中的dash单位均为毫米 
-- 地图符号的定位坐标则为归一化的数值， 如圆心坐标、圆半径等 
-- 地图符号中的角度坐标为度，如弧的开始、结束角度，旋转角度 
create table symbol_meta( 
    id varchar(32) default sc_uuid(),       -- 
    english varchar(32),                    -- 英文名 
    chinese varchar(32),                    -- 中文名 
    sym symbol not null                     -- 地图符号 
); 

insert into symbol_meta(english, chinese, sym) values('0','0','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "5",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('0','〇','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "〇",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('10','十','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "十",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('1','1','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "1",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('1','一','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "一",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('2','2','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "2",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('2','二','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "二",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('3','3','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "3",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('3','三','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "三",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('4','4','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "4",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('4','四','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "四",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('5','5','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "5",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('5','五','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "五",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('6','6','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "5",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('6','六','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "六",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('7','7','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "5",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('7','七','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "七",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('8','8','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "5",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('8','八','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "八",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('9','9','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "text",
                    "text": "5",
                    "fontfamily": "SimSun",
                    "fontsize": 0.8,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": true
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('9','九','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "text",
                    "text": "九",
                    "fontfamily": "Noto Sans SC",
                    "fontsize": 0.6,
                    "anchor": {
                        "x": 0.0,
                        "y": 0
                    },
                    "weight": "bold",
                    "slant": "normal",
                    "horizontalalign": "center",
                    "verticalalign": "middle",
                    "rotate": 0,
                    "ispath": false
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('arc3points','三点定弧','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 127,
                    "green": 127,
                    "blue": 127
                },
                "width": 0.3,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 255,
                    "blue": 127
                }
            },
            "subpaths": [
                {
                    "type": "arc3points",
                    "offset": {
                        "x": 0,
                        "y": 0
                    },
                    "rotate": 0,
                    "begin": {
                        "x": -0.8,
                        "y": 0
                    },
                    "middle": {
                        "x": 0,
                        "y": 0.8
                    },
                    "end": {
                        "x": 0.8,
                        "y": 0
                    }
                },
                {
                    "type": "arc3points",
                    "offset": {
                        "x": 0,
                        "y": 0
                    },
                    "rotate": 0,
                    "begin": {
                        "x": -0.8,
                        "y": 0
                    },
                    "middle": {
                        "x": 0,
                        "y": 0.2
                    },
                    "end": {
                        "x": 0.8,
                        "y": 0
                    }
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('arc','弧','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.3,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "arc",
                    "center": {
                        "x": 0,
                        "y": 0
                    },
                    "xradius": 0.8,
                    "yradius": 0.4,
                    "rotate": 0,
                    "startangle": 0,
                    "endangle": 180
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('chord','弦','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.3,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "chord",
                    "center": {
                        "x": 0,
                        "y": 0
                    },
                    "xradius": 0.8,
                    "yradius": 0.8,
                    "rotate": 0,
                    "startangle": -180,
                    "endangle": -90
                }
            ],
            "closed": true
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('circle','圆','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.3,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 255,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": 0,
                        "y": 0
                    },
                    "radius": 0.8
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('concentric circles','同心圆','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.3,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.8
                },
                {
                    "type": "circle",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.5
                }
            ],
            "closed": true
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('ellipse','椭圆','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.3,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "ellipse",
                    "center": {
                        "x": 0,
                        "y": 0
                    },
                    "xradius": 0.8,
                    "yradius": 0.4,
                    "rotate": 45
                }
            ]
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('linestring','折线','
{
    "offset": {
        "x": 0.0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "round",
                "join": "round",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 0,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "linestring",
                    "points": [
                        {
                            "x": -0.7,
                            "y": 0.35
                        },
                        {
                            "x": -0.35,
                            "y": -0.35
                        },
                        {
                            "x": 0,
                            "y": 0.35
                        },
                        {
                            "x": 0.35,
                            "y": -0.35
                        },
                        {
                            "x": 0.7,
                            "y": 0.35
                        }
                    ]
                }
            ],
            "closed": true
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('pie','扇形','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.3,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "pie",
                    "center": {
                        "x": 0,
                        "y": 0
                    },
                    "xradius": 0.8,
                    "yradius": 0.8,
                    "rotate": 0,
                    "startangle": -180,
                    "endangle": -90
                }
            ],
            "closed": true
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('polygon','多边形','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "round",
                "join": "round",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "polygon",
                    "points": [
                        {
                            "x": -0.7,
                            "y": 0.35
                        },
                        {
                            "x": -0.35,
                            "y": -0.35
                        },
                        {
                            "x": 0.35,
                            "y": -0.35
                        },
                        {
                            "x": 0.7,
                            "y": 0.35
                        }
                    ]
                }
            ],
            "closed": true
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('provincial capital','首府','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                },
                "width": 1,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 0,
                    "red": 255,
                    "green": 255,
                    "blue": 255
                }
            },
            "subpaths": [
                {
                    "type": "circle",
                    "center": {
                        "x": 0,
                        "y": 0
                    },
                    "radius": 0.8
                }
            ]
        },
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "star",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "outerradius": 0.8,
                    "innerradius": 0.32,
                    "rotate": 0,
                    "numedges": 5
                }
            ],
            "closed": true
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('solid fill','实心填充','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "systemfill",
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            }
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('solid line','实线','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 50,
    "shapes": [
        {
            "type": "systemline",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 0,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.5,
                "dashoffset": 0,
                "dashes": [
                    3.0,
                    1,
                    1,
                    1
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            }
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('square','正方形','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 255,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "regularpolygon",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.79,
                    "rotate": 0,
                    "numedges": 4
                }
            ],
            "closed": true
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('star','五角星','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "star",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "outerradius": 0.79,
                    "innerradius": 0.3,
                    "rotate": 0,
                    "numedges": 5
                }
            ],
            "closed": true
        }
    ]
}');

insert into symbol_meta(english, chinese, sym) values('triangle','三角形','
{
    "offset": {
        "x": 0,
        "y": 0
    },
    "size": 5,
    "shapes": [
        {
            "type": "path",
            "stroke": {
                "color": {
                    "alpha": 255,
                    "red": 255,
                    "green": 0,
                    "blue": 0
                },
                "width": 0.2,
                "dashoffset": 0,
                "dashes": [
                    1.0,
                    0
                ],
                "cap": "butt",
                "join": "miter",
                "miter": 10.0
            },
            "fill": {
                "type": "solid",
                "color": {
                    "alpha": 127,
                    "red": 255,
                    "green": 255,
                    "blue": 0
                }
            },
            "subpaths": [
                {
                    "type": "regularpolygon",
                    "center": {
                        "x": -0,
                        "y": -0
                    },
                    "radius": 0.79,
                    "rotate": 0,
                    "numedges": 3
                }
            ],
            "closed": true
        }
    ]
}');

