$fn=90;  // I see no reason to have poorly done arcs in here.
epsilon=0.1;  // Below printer resolution, enough for fixing manifold errors.

module head(r=11, w=4) {
    blowthrough(hole_radius=r-w, cylinder_width=w);
    for(i = [0 : 6]) {
        rotate(i * 60) blowthrough(2*r-w, hole_radius=r-w, cylinder_width=w);
    }
}

module blowthrough (x=0, y=0, inner_height=1, hole_radius=7, cylinder_width=3,
                    fan_height=1.0, fan_width=0.5, fan_indent=1, fans=40) {
    translate([x, y]) {
        cylinder_with_a_hole(inner_height, hole_radius+cylinder_width,
                hole_radius);
        for(i = [0 : fans]) {
            rotate(i * 360/fans) 
                translate([hole_radius-fan_indent, -0.5*fan_width, -fan_height]) 
                     intersection() {
                        cube([cylinder_width, fan_width,
                                inner_height+2*fan_height], false);
                        translate([cylinder_width/2, fan_width/2, inner_height/2 + fan_height])
                            sphere(d=cylinder_width, $fn=20);
                    }
        }
        adhesion_ring_outer_radius = hole_radius+cylinder_width-fan_indent;
        translate([0, 0, -fan_height])
            cylinder_with_a_hole(fan_width, adhesion_ring_outer_radius,
                    adhesion_ring_outer_radius-fan_width);
    }
}

module handle(length=140, radius=3, offs=20, cone_height=10, fan_height=1.0) {
    rotate([90, 0, 0]) {
        translate([0, radius-fan_height, offs]) {
            cylinder(length, radius, radius);
            translate([0, 0, length]) sphere(radius);
            oblique_cone(-cone_height, radius, 0, -radius+fan_height);
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
            [[$fn-1, 0, $fn]],
            [[for(i=[0:$fn-1]) i]]);
    polyhedron(points=points, faces=faces);
}

head();
handle();
