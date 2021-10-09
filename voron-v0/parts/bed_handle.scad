use <utilities.scad>
hole_spacing= 37;
tab_length = 10;
tab_base = 62;
tab_roof = 42;
$fn=64;

dim = [92, tab_length + 3, 30];
pull_over()difference() {
    centerx(dim)sqround(dim,is_outer=true,r=2, chamfer=true);
    up(dim.z - 1)linear_extrude(4)trapezoid(tab_base, tab_roof, tab_length);
    push(tab_length/2)row(hole_spacing,n=2,center=true)union() {
        //        up(2)hex_shaft(5.5, direction=-1);
        shaft(2);
    }
    rx(90)sqround([dim.x - 20,(dim.z - 10)* 2,40],r=3,is_outer=true,center=true,chamfer=true);
    mirrorx()left(dim.x/2 -2)up(15)rz(30)rx(90)down(42)cylinder(r=10,h=40, center=false);
//    up(dim.z - 10)rx(20)pull(50)cube([dim.x + 10,100,100],center=true);
}
