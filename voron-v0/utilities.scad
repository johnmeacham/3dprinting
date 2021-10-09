//$fn=64;
// should be larger than any dimension of final product.
infinity = 1000;

module center(size,center) {
    xyz = center == true ? "xyz" : center == false ? "" : center;
    tx = search("x",xyz) || search("w", xyz) ? - size[0] / 2 : 0;
    ty = search("y",xyz) || search("d", xyz) ? - size[1] / 2 : 0;
    tz = search("z",xyz) || search("h", xyz) ? - size[2] / 2 : 0;
    translate([tx,ty,tz])
        children();
}


//rounded off rectangle
module sqround(size,r=1,is_outer=false,center=false,h=0,chamfer = false) {
    module sqround2d(sz,off) {
        x = sz[0] - 2*off;
        y = sz[1] - 2*off;
        offx = off - (center ? x/2 + off : 0);
        offy = off - (center ? y/2 + off : 0);
        module corner() {
            echo(chamfer);
            if(chamfer) {
                circle(r=r,$fn=4);
            } else {
                circle(r=r);
            }
        }
        translate([offx,offy])hull() {
            translate([x,0])corner();
            translate([x,y])corner();
            translate([0,y])corner();
            corner();
        }
    }
    if (len(size) > 2 && h == 0) {
        sqround([size.x, size.y],r=r,is_outer=is_outer,center=center,h = size.z, chamfer=chamfer);
    } else if(h) {
        linear_extrude(height=h,center=center)sqround(size,r=r,is_outer=is_outer,center=center,h=0, chamfer=chamfer);
    } else {
        sqround2d(size, is_outer ? r : 0);

        /* off = is_outer ? r : 0; */
        /* x = size[0] - 2*off; */
        /* y = size[1] - 2*off; */
        /* offx = off - (center ? x/2 + off : 0); */
        /* offy = off - (center ? y/2 + off : 0); */
        /* translate([offx,offy])hull() { */
        /*         translate([x,0])circle(r=r); */
        /*         translate([x,y])circle(r=r); */
        /*         translate([0,y])circle(r=r); */
        /*         circle(r=r); */
        /* } */
        /* } */
}
}
module roundedcube(size = [1, 1, 1], center = false, radius = 0.5) {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate = (center == false) ?
		[radius, radius, radius] :
		[
			radius - (size[0] / 2),
			radius - (size[1] / 2),
			radius - (size[2] / 2)
	];

	translate(v = translate)
	minkowski() {
		cube(size = [
			size[0] - (radius * 2),
			size[1] - (radius * 2),
			size[2] - (radius * 2)
		]);
		sphere(r = radius);
	}
}

module corners(size,center=false,r=0) {
        off = r;
        x = size[0] - 2*off;
        y = size[1] - 2*off;
        z = len(size) > 2 ? size[2] - 2*off : 0;
        offx = off - (center ? x/2 + off : 0);
        offy = off - (center ? y/2 + off : 0);
        offz = z ? (off - (center ? z/2 + off : 0)) : 0;
        translate([offx,offy,offz])union() {
                translate([x,0])children(0);
                translate([x,y])children(1 % $children);
                translate([0,y])children(2 % $children);
                children(3 % $children);
                if(z) {
                translate([x,0,z])children(4 % $children);
                translate([x,y,z])children(5 % $children);
                translate([0,y,z])children(6 % $children);
                translate([0,0,z])children(7 % $children);
                }
        }
}

//rounded off triangle
module tround(size,r=1,is_outer=false,center=false,h=0) {
        if (len(size) > 2 && h == 0) {
                tround([size.x, size.y],r=r,is_outer=is_outer,center=center,h = size.z);
        } else if(h) {
                linear_extrude(height=h,center=center)tround(size,r=r,is_outer=is_outer,center=center,h=0);
        } else {
                off = is_outer ? r : 0;
                x = size[0] - 2*off;
                y = size[1] - 2*off;
                offx = off - (center ? x/2 + off : 0);
                offy = off - (center ? y/2 + off : 0);
                translate([offx,offy])hull() {
                        translate([x,0])circle(r=r);
                        translate([0,y])circle(r=r);
                        circle(r=r);
                }
        }
}

module shaft(d,direction=0,angle = 0,h=infinity) {
        center = direction == 0;
        rotate([direction == -1 ? 180 : 0, 0, 0])cylinder(r=d/2, h=h, center = center);
}

// width is the distance between flats
module hex_shaft(w,direction=0,angle = 0) {
        center = direction == 0;
        rotate([direction == -1 ? 180 : 0, 0, 0])cylinder(r=w/2 /
        cos(180/6), h=infinity, $fn = 6, center = center);
}

module quadrant(ld="x") {
        translate([ld == "x" ? - infinity/2 : 0, ld == "y" ? - infinity/2 :
        0, ld ==
        "z" ? - infinity / 2 : 0])cube([infinity,infinity,infinity]);
}
module bisect(ld="x") {
        translate([ld != "x" ? - infinity/2 : 0, ld != "y" ? - infinity/2 :
        0, ld !=
        "z" ? - infinity / 2 : 0])cube([infinity,infinity,infinity]);
}

module constellation(r,n=undef,angle=0,align_point=false) {
    rn = n == undef ? $children : n;
    offset = 360/rn;
    rotate([0,0,align_point ? 0: offset/2]) {
        for(i = [0 : rn - 1]) {
            rotate([0,0,i*360/rn])translate([0,-r,0])children(i % $children);
        }
    }
}
module column(d,n=4,center = true) {
    total = d * (n - 1);

    translate([0,(center ? (-total/2) : 0),0]){
        for(i = [0 : n - 1]) {
            translate([0,d*i,0])children( i % $children);
        }
    }
}

module stack(d,n=4,center = true) {
        total = d * (n - 1);

        translate([0,0,center ? (-total/2) : 0]){
                for(i = [0 : n - 1]) {
                        translate([0,0,d*i])children();
                }
        }
}
module row(d,n=undef, center = false) {
    rn = n == undef ? $children : n;
        total = d * (rn - 1);
        translate([center ? -total/2 : 0,0,0]){
                for(i = [0 : rn - 1]) {
                        translate([d*i,0,0])children(i % $children);
                }
        }
}

/* trapezoid centered on x */
module trapezoid(b1, b2, h) {
    polygon(points=[[-b1/2,0],[b1/2,0],[b2/2,h],[-b2/2,h]], paths=[[0,1,2,3]]);
}

module parallelogram(w, h, skew=0) {
    polygon(points=[[0,0],[w,0],[w + skew,h],[skew,h]], paths=[[0,1,2,3]]);
}

// generalized row,column,stack that takes a vector to arrange things by
module lineup(d,n=undef, center = false) {
    rn = n == undef ? $children : n;
    io = center ? (rn - 1)/2: 0;
    for(i = [0 : rn - 1]) {
        translate(d*(i - io))children(i % $children);
    }
}

module mirrorx(d=0,center = false) {
        left(d)children();
        mirror([1,0,0])left(d)children();
}

module up(n) translate([0,0,n]) children();
module down(n) translate([0,0,-n]) children();
module left(n) translate([-n,0,0]) children();
module right(n) translate([n,0,0]) children();
module push(n) translate([0,n,0]) children();
module pull(n) translate([0,-n,0]) children();


module centerx(size) translate([len(size) > 1 ? -size.x/2 : -size/2,0,0]) children();
module centery(size) translate([0,len(size) > 1 ? -size.y/2 : -size/2,0]) children();
module centerz(size) translate([0,0,len(size) > 1 ? -size.z/2 : -size/2]) children();
module centerxy(size) translate([-size.x/2,-size.y/2,0]) children();
module centerxz(size) translate([-size.x/2,0,-size.z/2]) children();
module centeryz(size) translate([0,-size.y/2,-size.z/2]) children();
module centerxyz(size) translate([-size.x/2,-size.y/2,-size.z/2]) children();

module sx(x=1,y=1,z=1) scale([x,y,z]) children();
module sy(y=1,x=1,z=1) scale([x,y,z]) children();
module sz(z=1,x=1,y=1) scale([x,y,z]) children();

module move(x=0,y=0,z=0) translate([x,y,z]) children();
module twist(x=0,y=0,z=0) rotate([x,y,z]) children();
module rx(x=0,y=0,z=0) rotate([x,y,z]) children();
module ry(y=0,x=0,z=0) rotate([x,y,z]) children();
module rz(z=0,x=0,y=0) rotate([x,y,z]) children();
module push_over(angle = -90) rx(angle) children();
module pull_over(angle = 90) rx(angle) children();
module tip_right(angle = 90) ry(angle) children();
module tip_left(angle = -90) ry(angle) children();

