include <../openscad-shorthand/shorthand.scad>

//                                                            
//                                   shaft diam    bolt diam       conn height
//                      base diam    shaft diam@D  bolt depth      conn width
//        size,  h,     base height, shaft length, bolt offset     conn offset bottom
NEMA8  = [[20.0, 32.0], [16.0, 1.5], [4, 3.5,  8], [2.5, 3,  7.7], [4.5, 11.5, 2.5]];
NEMA17 = [[42.0, 40.0], [23.0, 2.0], [8, 7.5, 25], [3.0, 5, 15.5], [4.5, 11.5, 2.5]];

NEMA_DEFAULT = NEMA17;

function nema_size(nema=NEMA_DEFAULT, h)            = [ nema[0][0], nema[0][0], 
                                                        h == undef ? nema[0][2] : h];
function nema_base_size(nema=NEMA_DEFAULT)          = [nema[1][0], nema[1][0], nema[1][1]];
function nema_base_diam(nema=NEMA_DEFAULT)          = nema[1][0];
function nema_base_height(nema=NEMA_DEFAULT)        = nema[1][1];
function nema_shaft_size(nema=NEMA_DEFAULT)         = [nema[2][0], nema[2][0], nema[2][1]];
function nema_shaft_diam(nema=NEMA_DEFAULT)         = nema[2][0];
function nema_shaft_diam_at_d(nema=NEMA_DEFAULT)    = nema[2][1];
function nema_shaft_length(nema=NEMA_DEFAULT)       = nema[2][2];
function nema_hole_diam(nema=NEMA_DEFAULT)          = nema[3][0];
function nema_hole_depth(nema=NEMA_DEFAULT)         = nema[3][1];
function nema_hole_offset(nema=NEMA_DEFAULT)        = nema[3][2];

module nema_foreach_hole(type=NEMA_DEFAULT, at=[[-1,1], [1,1], [1,-1], [-1,-1]])
{
    for (a = at) {
        echo (a); 
        echo (type);
        echo (nema_hole_offset(type));
        
        translate(nema_hole_offset(type) * a) children();
    }
}

module nema(type = NEMA_DEFAULT, h = 30, mask = undef)
{
    bottom = [0,  0, -0.5];
    top    = [0,  0,  0.5];
    bevel  = [3, -3,  0.0];
    bh = nema_base_height(type);
    bd = nema_base_diam(type);
    sd = nema_shaft_diam(type);
    sl = nema_shaft_length(type);
    hd = nema_hole_diam(type);
    hz = nema_hole_depth(type);
    
    
    if (is_list(mask))
    {
        cub(nema_size(type, h) + mask, align=BOTTOM, bevel=bevel);
    
        nema_foreach_hole(type) 
        cyl([hd,hd,hz] + mask, align=TOP);
       
        cyl([bd,bd,sl] + mask, align=TOP);           
    }
    else difference()
    {
        cub(nema_size(type, h), align=BOTTOM, bevel=bevel, at=TOP)
        cyl([sd,sd,sl], align=TOP, at=BOTTOM) 
        cyl([bd,bd,bh], align=TOP);
    
        union() nema_foreach_hole(type) 
        cyl([hd,hd,hz], align=BOTTOM);
    }
}

// nema();
// nema(NEMA8);