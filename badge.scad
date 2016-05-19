badge_dimensions = [85, 45, 2.5];
$fn = 42; // Smoothness of corner rounding, compute-intensive.
hole_diameter = 3;
top = hole_diameter + 2;


difference() {
    minkowski() {
        union() {
            cube(badge_dimensions, true);
            translate([badge_dimensions[0]/2, 0, 0]) 
                resize([top*2, badge_dimensions[1], badge_dimensions[2]])
                    cylinder(center=true);
        }
        sphere(1);
    }
    cube(badge_dimensions, true); // For badge.
    translate([40, 0, 0]) cube(badge_dimensions, true); // For sliding in.
    scale([0.9, 0.9, 2.0]) cube(badge_dimensions, true); // For viewing.
    translate([badge_dimensions[0]/2 + hole_diameter/2, 0, 0])
        cylinder(h=100, d=hole_diameter, center=true); // For keyring.
}
