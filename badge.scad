badge_dimensions = [85 + 2, 55, 3.14]; // Extra length for easier fit.
$fn = 42; // Smoothness of corner rounding, compute-intensive.
min_printable = 0.4; // If we go below nozzle diameter it may go ugly.
hole_diameter = 4;
top = hole_diameter + 2; // 2mm to withstand pulling the badge down.
thickness = 1.2; // 1.2mm is the minimum reported to be durable in PLA.

module block() {
    minkowski() {
        union() {
            cube(badge_dimensions, true);
            translate([badge_dimensions[0]/2, 0, 0]) 
                resize([top*2, badge_dimensions[1], badge_dimensions[2]])
                cylinder(center=true);
        }
        sphere(thickness);
    }
}

module sliding() {
    translate([40, 0, 0]) cube(badge_dimensions, true); // For sliding in.
}

module keyring_hole() {
    translate([badge_dimensions[0]/2 + hole_diameter/2 + min_printable, 0, 0])
        cylinder(h=100, d=hole_diameter, center=true); // For keyring.
}

// Main part.
difference() {
    block();
    sliding();
    cube(badge_dimensions, true); // For badge.
    scale([0.9, 0.9, 2.0]) cube(badge_dimensions, true); // For viewing.
    keyring_hole();
}

// Cap - to not scrub fluff from the pocket.
translate([2*top, 0, -thickness * 1.15]) // Separate from the main part, align to plate.
scale([1, 0.95, 0.9]) // Make it fit despite printing fuzziness.
difference() {
    intersection() {
        block();
        sliding();
    }
    scale([1, 2, 2]) // To remove non-manifold error.
        cube(badge_dimensions, true); // For badge.
    keyring_hole();
}