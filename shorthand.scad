// GLOBALS
$fs=1;
$fn=30;
$e = 0.1;
E = $e;

// TRANSLATE
module T(x,y=0,z=0) 
{
	if (is_list(x)) translate(x) children();
	else translate([x,y,z]) children();
}
module Tx(v) { T(v,0,0) children(); }
module Ty(v) { T(0,v,0) children(); }
module Tz(v) { T(0,0,v) children(); }

//ROTATE
module R(x,y=0,z=0)
{
	if (is_list(x)) rotate(x) children();
	else rotate([x,y,z]) children();
}
module Rx(v) { R(v,0,0) children(); }
module Ry(v) { R(0,v,0) children(); }
module Rz(v) { R(0,0,v) children(); }

//SCALE
module S(x,y=1,z=1)
{
	if (is_list(x)) scale(x) children();
	else scale([x,y,z]) children();
}
module Sx(v) { S(v,1,1) children(); }
module Sy(v) { S(1,v,1) children(); }
module Sz(v) { S(1,1,v) children(); }

//MIRROR
//module M(axis) { for (i=[-2,0]) scale(i*axis + [1,1,1]) children(); }
module M(x,y=0,z=0) 
{
	if (is_list(x)) mirror(x) children();
	else mirror([x,y,z]) children();
	children();
}
module Mx(d=0) { M([1,0,0]) Tx(d/2) children(); }
module My(d=0) { M([0,1,0]) Ty(d/2) children(); }
module Mz(d=0) { M([0,0,1]) Tz(d/2) children(); }

// VECTOR HELPERS
function vec3(x,y=0,z=0) = is_list(x) ? ([for (i = [0,1,2]) i < len(x) ? x[i] : 0 ]) :  [x,y,z];
function vec2(x,y=0) =     is_list(x) ? ([for (i = [0,1  ]) i < len(x) ? x[i] : 0 ]) :  [x,y];
function X(v) = v[0];
function Y(v) = v[1];
function Z(v) = v[2];
function radius(v) = X(v)/ 2;
function diam(v) = X(v);

function vabs(x, y=0, z=0) = [for (v=vec3(x,y,z)) abs(v)];
 
function pmul(va,vb) = 
         [for (i = [0:1:max(len(va),len(vb))-1]) 
          (i >= len(va) 
              ? 0 
              : va[i]) * (i >= len(vb) 
                             ? 0 
                             : vb[i])];

RIGHT = [1,0,0]; LEFT = -RIGHT;
FRONT = [0,1,0]; BACK = -FRONT;
TOP =   [0,0,1]; BOTTOM = -TOP;


// SHAPES 
// identical params means easy switching between primitives
// children will have the center of the face 'at' as origin, or are relative to the center of the object when [0,0,0]

// cylinder. if x != y, the cylinder will be a hull of 2 displaced cylinders with diameter equal to min(x,y) forming an object fitting the specified dimensions 
module cyl(x, y=0, z=0, align=[0,0,0], at=[0,0,0])
{ 
    v = vec3(x,y,z);
    
    s = X(v) != Y(v) 
      ? min(X(v), Y(v)) 
      : X(v);
    
    d = X(v) != Y(v) 
      ? [for (n = [-0.5, 0.5]) n * (v - [s,s,Z(v)])] 
      : [[0,0,0]];
	
    a = is_list(y) 
      ? y 
      : align;
      
    c = is_list(z) 
      ? z 
      : at;

    difference()
    {
        hull() 
        for (i=d) T(i+pmul(a, v/2)) 
        cylinder(d=s, h=Z(v), center=true);
    
        if (len(x) >= 4) 
	hull()
	for (i=d) T(i+pmul(a, v/2))
	cylinder(d=s-x[3]*2, h=Z(v) +E, center=true);
    }
    T(pmul(a+c, v/2)) children();
}

//prismoid
module prism(p0, p1, align=[0,0,0], at=[0,0,0])
{
      p = [p0, p1];
      a = is_list(y) ? y : align;
      c = is_list(z) ? z : at;
      hull() for (i=[0,1]) 
      T(pmul(a,v/2))
      Tz(v/(i*4-2) - $e/(i*4-2)) 
      cube([X(p[i]),Y(p[i]), $e]);
      
      T(pmul(a+c,v/2)) children(); 
}

//beveled cube
module cub(x, y=0, z=0, align=[0,0,0], at=[0,0,0], bevel = [.25,-.25,0])
{ 
    v = vec3(x,y,z) - vabs(bevel);
    //b = v - vabs(bevel);
    a = is_list(y) ? y : align;
    c = is_list(z) ? z : at;

    hull() for (i=[-2,2]) 
    T(pmul(a,v/2))
    cube(v+i*bevel, center=true); 

    T(pmul(a+c,v/2)) children(); 
}
