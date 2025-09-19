  
-- Availability: 3.4.2 
-- 预定义好的地图符号postgres 
-- 地图符号中的线宽、点划线中的dash单位均为毫米 
-- 地图符号的定位坐标则为归一化的数值， 如圆心坐标、圆半径等 
-- 地图符号中的角度坐标为度，如弧的开始、结束角度，旋转角度 
create table sqlcarto_symbols( 
    id varchar(32) default sc_uuid(),       -- 
    english varchar(32),                    -- 英文名 
    chinese varchar(32),                    -- 中文名 
    sym symbol not null                     -- 地图符号 
); 

insert into sqlcarto_symbols(english, chinese, sym) values('arc','arc','
{
  "width": 5.0,
  "height": 5.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "arc",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "center": [0, 0],
      "radiusx": 0.5,
      "radiusy": 0.5,
      "rotation": 0,
      "startangle": 0,
      "endangle": 180
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('border','province','
{
  "width": 10.0,
  "height": 10.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [255, 0, 0, 255],
        "width": 0.1,
        "cap": "butt",
        "join": "miter",
        "dashes": [5, 5],
        "dashesoffset": 0
      }
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [255, 0, 0, 255],
        "width": 0.1,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "points": [
        [0, -0.1],
        [0, 0.1]
      ],
      "offsetalongline": 0
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [255, 0, 0, 255],
        "width": 0.1,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "points": [
        [0, -0.1],
        [0, 0.1]
      ],
      "offsetalongline": 5
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('chord','chord','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "chord",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          128,
          128,
          0,
          255
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radiusx": 0.8,
      "radiusy": 0.8,
      "rotation": 0,
      "startangle": 45,
      "endangle": 135
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('circle','circle','
{
  "width": 2.0,
  "height": 2.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [255, 0, 255, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 255, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('city','4','
{
  "width": 1.0,
  "height": 1.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.05,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 255, 127]
      },
      "center": [0.0, 0.0],
      "radius": 0.8,
      "sides": 12,
      "rotation": 0
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('ellipse','ellipse','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "ellipse",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          100
        ]
      },
      "center": [
        0,
        0
      ],
      "radiusx": 0.8,
      "radiusy": 0.4,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('fill','slash','
{
  "width": 20.0,
  "height": 20.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemfill",
      "fill": {
        "type": "solid",
        "color": [127, 127, 0, 0]
      }
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.3,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "points": [
        [-0.75, 1.0],
        [-1.0, 0.75]
      ]
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [255, 0, 0, 255],
        "width": 0.3,
        "cap": "round",
        "join": "round",
        "dashes": [4, 2],
        "dashesoffset": 0
      },
      "points": [
        [-0.25, 1.0],
        [-1.0, 0.25]
      ]
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.3,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "points": [
        [0.25, 1.0],
        [-1.0, -0.25]
      ]
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [255, 0, 0, 255],
        "width": 0.3,
        "cap": "round",
        "join": "round",
        "dashes": [4, 2],
        "dashesoffset": 0
      },
      "points": [
        [0.75, 1.0],
        [-1.0, -0.75]
      ]
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.3,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "points": [
        [1.0, 0.75],
        [-0.75, -1.0]
      ]
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [255, 0, 0, 255],
        "width": 0.3,
        "cap": "round",
        "join": "round",
        "dashes": [4, 2],
        "dashesoffset": 0
      },
      "points": [
        [1.0, 0.25],
        [-0.25, -1.0]
      ]
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.3,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "points": [
        [1.0, -0.25],
        [0.25, -1.0]
      ]
    },
    {
      "type": "linestring",
      "stroke": {
        "color": [255, 0, 0, 255],
        "width": 0.3,
        "cap": "round",
        "join": "round",
        "dashes": [4, 2],
        "dashesoffset": 0
      },
      "points": [
        [1.0, -0.75],
        [0.75, -1.0]
      ]
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('fill','solid','
{
  "width": 10.0,
  "height": 10.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemfill",
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 100]
      }
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('fill','solid','
{
  "width": 10.0,
  "height": 10.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemfill",
      "fill": {
        "type": "solid",
        "color": [127, 127, 0, 255]
      }
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "4",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('line','complex','
{
  "width": 100.0,
  "height": 100,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [255, 255, 255, 255],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [33.33, 44.44, 33.33, 44.44],
        "dashesoffset": 0
      }
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('line','dash','
{
  "width": 100.0,
  "height": 2,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          2,
          2,
          2
        ],
        "dashesoffset": 0
      }
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('line','dash','
{
  "width": 100.0,
  "height": 2,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.1,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 2, 0.25, 2],
        "dashesoffset": 0
      }
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('line','dash','
{
  "width": 100.0,
  "height": 2,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          2,
          0.25,
          2,
          0.25,
          2
        ],
        "dashesoffset": 0
      }
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('line','solid','
{
  "width": 10.0,
  "height": 10,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [0, 255, 255, 255],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0],
        "dashesoffset": 0
      }
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('linestring','linestring','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "linestring",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 3,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0],
        "dashesoffset": 0
      },
      "points": [
        [-0.25, -0.25],
        [0.25, -0.25],
        [0.25, 0.25],
        [-0.25, 0.25]
      ]
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('pie','pie','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "pie",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          128,
          128,
          0,
          100
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radiusx": 0.8,
      "radiusy": 0.8,
      "rotation": 0,
      "startangle": 60,
      "endangle": 120
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('polygon','polygon','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "polygon",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "points": [
        [
          -0.8,
          -0.8
        ],
        [
          0.8,
          -0.8
        ],
        [
          0.8,
          0.8
        ],
        [
          -0.2,
          0.8
        ],
        [
          -0.8,
          0.2
        ],
        [
          -0.8,
          -0.8
        ]
      ]
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('rectangle','rectangle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "rectangle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.1,
        "cap": "round",
        "join": "miter",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          127,
          127,
          0,
          255
        ]
      },
      "minx": -0.8,
      "maxx": 0.8,
      "miny": -0.4,
      "maxy": 0.4
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('regularpolygon','3','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          255,
          127
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8,
      "sides": 3,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('regularpolygon','4','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          255,
          127
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8,
      "sides": 4,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('regularpolygon','5','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          255,
          127
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8,
      "sides": 5,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('regularpolygon','6','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          255,
          127
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8,
      "sides": 6,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('regularpolygon','7','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          255,
          127
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8,
      "sides": 7,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('regularpolygon','8','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          255,
          127
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8,
      "sides": 8,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('star','3','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.9,
      "radius2": 0.2,
      "sides": 3,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('star','4','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 4,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('star','5','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 5,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('star','6','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 6,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('star','7','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 7,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('star','8','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 8,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('star','9','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [
          1,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 9,
      "rotation": 0
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','0','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "0",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','1','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "1",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','2','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "2",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','3','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "3",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','4','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "4",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','5','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "5",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','6','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "6",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','7','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "7",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','8','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "8",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','9','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "9",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "1",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "1",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "2",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "3",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "4",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "5",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "6",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "7",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "8",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "9",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "〇",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "一",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "七",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "三",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "九",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "二",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "五",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 6,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "circle",
      "stroke": {
        "color": [255, 0, 0, 255],
        "width": 4,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "八",
      "center": [0.0, 0.0],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "六",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

insert into sqlcarto_symbols(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          255,
          0,
          0
        ]
      },
      "center": [
        0.0,
        0.0
      ],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [
          0,
          0,
          0,
          255
        ],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [
          2,
          0
        ],
        "dashesoffset": 0
      },
      "fill": {
        "type": "solid",
        "color": [
          255,
          0,
          0,
          255
        ]
      },
      "text": "四",
      "center": [
        0.0,
        0.0
      ],
      "fontsize": 0.55,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}');

