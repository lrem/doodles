module top(recess, height, thickness, interlock = 3*thickness, hole_diameter=8) {
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
    }
  }
  // To interlock with the vertical hole.
  translate([0, 0, -height]){
    translate([0, -thickness/2, 0])
      cube([thickness, thickness, thickness]);
    translate([thickness, -interlock/2, 0]) {
      cube([thickness, interlock, thickness]);
    }
  }
}

module vertical(height, thickness, interlock=3*thickness, margin=thickness/2) {
  translate([0, 0, -height+thickness]) {
    translate([0, -thickness/2, thickness]) {
      cube([thickness, thickness, height]);
    }
    translate([0, -interlock/2, -interlock]) {
      difference() {
        cube([thickness, 3*thickness, interlock + 2*thickness]);
        translate([-thickness, thickness-margin/2, thickness-margin]) {
          cube([3*thickness, thickness + margin, interlock + margin]);
        }
      }
    }
  }
}

module slide_in(phone_dims, thickness, border=5) {
  difference() {
    union() {
      // Rounded wall around the phone.
      minkowski() {
        cube(phone_dims);
        sphere(thickness);
      }
      // Flatten the back of the wall.
      translate([-thickness, 0, 0]) {
        intersection() {
          translate([0, -thickness, -thickness]) 
            cube([thickness, 1000*thickness, 1000*thickness]);
          minkowski() {
            cube(phone_dims);
            sphere(thickness);
          }
        }
      }
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
    translate([-thickness, thickness/2, -phone_dims[2]]) {
      translate([2*thickness, 0, 0]) // Just to show better.
        top(recess, height, thickness);
      vertical(height, thickness);
    }
  rotate([180, 0, 0])
    translate([-thickness, -(phone_dims[1] + thickness/2), -phone_dims[2]]) {
      top(recess, height, thickness);
      vertical(height, thickness);
    }
}

holder([10, 140, 80]);
