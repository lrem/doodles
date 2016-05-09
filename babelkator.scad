$fn=180;  // I see no reason to have poorly done arcs in here.

module head(r=10, w=3) {
    blowthrough(r=r, w=w);
    for(i = [0 : 6]) {
        rotate(i * 60) blowthrough(2*r-w, r=r, w=w);
    }
}

module blowthrough (x=0, y=0, h=1, r=10, w=3, fh=0.5, fd=0.5, fans=40) {
    translate([x, y]) {
        cylinder_with_a_hole(h, r, r-w);
        for(i = [0 : fans]) {
            rotate(i * 360/fans) 
                translate([r-1-w, -0.5*fd, -fh]) 
                    cube([w, fd, h+2*fh], false);
        }
    }
}

module handle(l=140, r=4, offs=20, fh=1.5) {
    rotate([90, 0, 0]) {
        translate([0, r-fh, offs]) {
            cylinder(l, r, r);
            translate([0, 0, l]) sphere(r);
            oblique_cone(-offs/2, r, 0, -r);
        }
    }
}

module cylinder_with_a_hole(h, ro, ri) {
    difference() {
        cylinder(h, ro, ro);
        cylinder(3*h, ri, ri, true);
    }
}

module oblique_cone(h, r, x, y) {
    points = concat(
            [for(i=[0:$fn-1]) [r*sin(360*i/$fn), r*cos(360*i/$fn), 0]],
            [[x,y,h]]);
    faces = concat(
            [for(i=[0:$fn-2]) [i, i+1, $fn]],
            [[$fn-1, $fn, 0]],
            [[for(i=[0:$fn-1]) i]]);
    polyhedron(points=points, faces=faces);
}

head();
handle(r=3);
