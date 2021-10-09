include<utilities.scad>

/* measure each pad and rotate the bed screw (3 - measured)*720 degrees clockwise. */

width = 15;
len = 15;
module patch(tongs) {
    translate([-width/2,-len/2,0]) {
        cube([width,len,3]);
        translate([width/2 - 1,len,0])row(3,n=tongs,center=true)cube([2,2,3]);
    }
}

//row(22,center=true) {
rz(-60)constellation(50,center=true) {
    patch(1);
    patch(2);
    patch(3);
}
