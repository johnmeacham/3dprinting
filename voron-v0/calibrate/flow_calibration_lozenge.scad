distance = 40;
radius  = 6;
thickness = 0.6;
$fn = 64; // needs to be super smooth
//$fs = 1;
module sqround(r,x,y) {
    hull() {
        translate([+x/2,+y/2])circle(r);
        translate([+x/2,-y/2])circle(r);
        translate([-x/2,+y/2])circle(r);
        translate([-x/2,-y/2])circle(r);
    }

}

module shell(r,t,h) {
    x = 50 - radius*2;
    y = 30 - radius*2;
    linear_extrude(h)difference() {
        sqround(r,x,y);
        sqround(r - t,x,y);
    }
}
shell(radius,thickness,20);
shell(radius + 2, 4, 0.5);
