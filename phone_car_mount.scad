module hanger(recess, height, thickness, hole_diameter=8) {
  ro = hole_diameter / 2 + thickness;
  ri = hole_diameter / 2;
  translate([-ro - recess, 0, -height]){
    difference() {
      cylinder(thickness, ro, ro);
      cylinder(3*thickness, ri, ri, true);
    }
    translate([ro, -thickness/2, 0]) {
      cube([recess, thickness, thickness]);
      translate([-thickness, 0, 0])
        cube([thickness, thickness, thickness]); // joint
      translate([recess, 0, 0])
        cube([thickness, thickness, height]);
    }
  }
}

module slide_in(phone_dims, thickness, border=5) {
  difference() {
    minkowski() {
      cube(phone_dims);
      sphere(thickness);
    }
    // to slide in
    scale([1, 1, 2])
      cube(phone_dims);
    // to see the screen and have no back
    scale([3, 1, 1])
      translate([-thickness, border, border])
      cube(phone_dims-[0, 2*border, 2*border]);
  }
}


module holder(phone_dims, recess=50, height=30, thickness=3) {
  slide_in(phone_dims, thickness);
  rotate([180, 0, 0])
    translate([0, thickness/2, -phone_dims[2]])
    hanger(recess, height, thickness);
  rotate([180, 0, 0])
    translate([0, -(phone_dims[1] + thickness/2), -phone_dims[2]])
    hanger(recess, height, thickness);
}

holder([10, 140, 80]);
